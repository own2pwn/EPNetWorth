//
//  EYClient.swift
//  BraveNeuron
//
//  Created by Evgeniy on 10/02/2019.
//  Copyright © 2019 Evgeniy. (BraveNeuron) All rights reserved.
//

import Foundation
import Promise

public final class EYClientImp<R: Resource, Q: QueryElement, B: BodyElement>: EYClient {
    // MARK: - Members

    private let mapper: EYMapper

    private let parser: EYParser

    private let session: URLSession

    private let endpoint: URL

    // MARK: - Interface

    public func get<M: EYNetworkModel>(resource: R, with query: [Q] = []) -> Promise<M> {
        return handleRequest(to: resource, with: query)
    }

    public func post<M: EYNetworkModel>(to resource: R, with query: [Q] = [], body: [B] = []) -> Promise<M> {
        return handleRequest(to: resource, with: query, body: body)
    }

    // MARK: - Model

    public func post<T: EYEncodableNetworkModel, RT: EYNetworkModel>(to resource: R, with query: [Q] = [], model: T) -> Promise<RT> {
        return handleRequest(to: resource, with: query, model: model)
    }

    // MARK: - Array

    public func get<M: EYNetworkModel>(resource: R, with query: [Q] = []) -> Promise<[M]> {
        return handleRequestArray(to: resource, with: query)
    }

    // MARK: - Generic

    public func `as`<A: Resource, B: QueryElement, C: BodyElement>(_ r: A.Type, _ q: B.Type, _ b: C.Type) -> EYClientImp<A, B, C> {
        #if DEBUG
            return EYClientImp<A, B, C>(
                mapper: mapper, parser: parser,
                session: session, endpoint: endpoint
            )
        #else
            return unsafeDowncast(self, to: EYClientImp<A, B, C>.self)
        #endif
    }

    // MARK: - Init

    public convenience init(endpoint: URL) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 25
        config.httpShouldUsePipelining = true
        if #available(iOS 11, OSX 10.13, *) {
            config.waitsForConnectivity = true
        }

        let mapper = EYMapperImp()
        let parser = EYParserImp()
        let session = URLSession(configuration: config)
        self.init(
            mapper: mapper, parser: parser,
            session: session, endpoint: endpoint
        )
    }

    public init(mapper: EYMapper,
                parser: EYParser,
                session: URLSession,
                endpoint: URL) {
        self.mapper = mapper
        self.parser = parser
        self.session = session
        self.endpoint = endpoint
    }
}

public extension EYClientImp {
    // MARK: - Common Helpers

    private func handleRequest<M: EYNetworkModel>(to resource: R, with query: [Q] = [], body: [B] = []) -> Promise<M> {
        let bodyData = getBodyData(body)
        let req = buildRequest(to: resource, with: query, body: bodyData)
        let result = Promise<M>()
        makeRequestTask(with: req, result: result)

        return result
    }

    private func handleRequest<T: EYEncodableNetworkModel, RT: EYNetworkModel>(to resource: R, with query: [Q] = [], model: T) -> Promise<RT> {
        let bodyData = try? mapper.map(model)
        let req = buildRequest(to: resource, with: query, body: bodyData)
        let result = Promise<RT>()
        makeRequestTask(with: req, result: result)

        return result
    }

    @discardableResult
    private func makeRequestTask<M: EYNetworkModel>(with request: URLRequest, result: Promise<M>) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, headers, err in
            try? self.handleResponse(promise: result, data, headers: headers, error: err)
        }
        task.resume()

        return task
    }

    private func handleResponse<M: EYNetworkModel>(promise: Promise<M>, _ data: Data?, headers: URLResponse?, error: Error?) throws {
        // TODO: middleware

        guard error == nil else { promise.reject(error.unsafelyUnwrapped); return }
        guard let data = data, !data.isEmpty else {
            if let url = headers?.url {
                let err = EYNetError(reason: "no data in response of [\(url)]")
                promise.reject(err)
            } else {
                let err = EYNetError(reason: "response body was empty!")
                promise.reject(err)
            }
            return
        }

        do {
            try validateStatusCode(headers)
        } catch {
            promise.reject(error)
            return
        }

        try parser.parse(M.self, data).then(promise.fulfill)
    }

    private func buildRequest(to resource: Resource, with query: [QueryElement] = [], body: Data? = nil) -> URLRequest {
        let base = endpoint.appendingPathComponent(resource.path)
        let final = URL(base: base, query: query)
        let request = URLRequest(url: final, body: body)

        return request
    }

    private func getBodyData(_ body: [B] = []) -> Data? {
        let bodyComponents = body.map { "\($0.key)=\($0.value.urlEncoded)" }
        let bodyString = bodyComponents.joined(separator: "&")

        return bodyString.data(using: .utf8)
    }

    private func validateStatusCode(_ headers: URLResponse?) throws {
        guard let responseCode = (headers as? HTTPURLResponse)?.statusCode else {
            throw EYNetError(reason: "no headers while checking response code!")
        }
        guard responseCode == 200 else {
            throw EYNetError(reason: "response code is not valid! [\(responseCode)]")
        }
    }
}

public extension EYClientImp {
    // MARK: - Array Helpers

    private func handleRequestArray<M: EYNetworkModel>(to resource: R, with query: [Q] = [], body: Data? = nil) -> Promise<[M]> {
        let req = buildRequest(to: resource, with: query, body: body)
        let result = Promise<[M]>()
        makeRequestTaskArray(with: req, result: result)

        return result
    }

    @discardableResult
    private func makeRequestTaskArray<M: EYNetworkModel>(with request: URLRequest, result: Promise<[M]>) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, headers, err in
            try? self.handleResponseArray(promise: result, data, headers: headers, error: err)
        }
        task.resume()

        return task
    }

    private func handleResponseArray<M: EYNetworkModel>(promise: Promise<[M]>, _ data: Data?, headers: URLResponse?, error: Error?) throws {
        guard error == nil else { promise.reject(error.unsafelyUnwrapped); return }
        guard let data = data else {
            if let url = headers?.url {
                let err = EYNetError(reason: "no data in response; url: [\(url)]")
                promise.reject(err)
            } else {
                let err = EYNetError(reason: "response body was empty!")
                promise.reject(err)
            }
            return
        }

        try parser.parseArray(M.self, data).then(promise.fulfill)
    }
}
