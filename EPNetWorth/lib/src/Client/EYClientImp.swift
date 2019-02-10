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

    public let parser: EYParser

    private let session: URLSession

    private let endpoint: URL

    // MARK: - Interface

    public func get<M: EYNetworkModel>(resource: R, with query: [Q] = []) -> Promise<M> {
        return handleRequest(to: resource, with: query)
    }

    public func post<M: EYNetworkModel>(to resource: R, with query: [Q] = [], body: [B] = []) -> Promise<M> {
        return handleRequest(to: resource, with: query, body: body)
    }

    // MARK: - Array

    public func getArray<M: EYNetworkModel>(resource: R, with query: [Q] = []) -> Promise<[M]> {
        return handleRequestArray(to: resource, with: query)
    }

    // MARK: - Generic

    public func `as`<A: Resource, B: QueryElement, C: BodyElement>(_ r: A.Type, _ q: B.Type, _ b: C.Type) -> EYClientImp<A, B, C> {
        #if DEBUG
            return EYClientImp<A, B, C>(parser: parser, session: session, endpoint: endpoint)
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

        let parser = EYParserImp()
        let session = URLSession(configuration: config)
        self.init(parser: parser, session: session, endpoint: endpoint)
    }

    public init(parser: EYParser,
                session: URLSession,
                endpoint: URL) {
        self.parser = parser
        self.session = session
        self.endpoint = endpoint
    }
}

public extension EYClientImp {
    // MARK: - Common Helpers

    private func handleRequest<M: EYNetworkModel>(to resource: R, with query: [Q] = [], body: [B] = []) -> Promise<M> {
        let req = buildRequest(to: resource, with: query, body: body)
        let result = Promise<M>()
        makeRequestTask(with: req, result: result)

        return result
    }

    @discardableResult
    private func makeRequestTask<M: EYNetworkModel>(with request: URLRequest, result: Promise<M>) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, headers, err in
            self.handleResponse(promise: result, data, headers: headers, error: err)
        }
        task.resume()

        return task
    }

    private func handleResponse<M: EYNetworkModel>(promise: Promise<M>, _ data: Data?, headers: URLResponse?, error: Error?) -> Void {
        guard error == nil else { promise.reject(error.unsafelyUnwrapped); return }
        guard let data = data else {
            if let url = headers?.url {
                let err = EYNetError(reason: "no data in response of [\(url)]")
                promise.reject(err)
            } else {
                let err = EYNetError(reason: "response body was empty!")
                promise.reject(err)
            }
            return
        }

        parser.parse(M.self, data).then(promise.fulfill)
    }

    private func buildRequest(to resource: Resource, with query: [QueryElement] = [], body: [BodyElement] = []) -> URLRequest {
        let base = endpoint.appendingPathComponent(resource.path)
        let final = URL(base: base, query: query)
        let request = URLRequest(url: final, body: body)

        return request
    }
}

public extension EYClientImp {
    // MARK: - Array Helpers

    private func handleRequestArray<M: EYNetworkModel>(to resource: R, with query: [Q] = [], body: [B] = []) -> Promise<[M]> {
        let req = buildRequest(to: resource, with: query, body: body)
        let result = Promise<[M]>()
        makeRequestTaskArray(with: req, result: result)

        return result
    }

    @discardableResult
    private func makeRequestTaskArray<M: EYNetworkModel>(with request: URLRequest, result: Promise<[M]>) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, headers, err in
            self.handleResponseArray(promise: result, data, headers: headers, error: err)
        }
        task.resume()

        return task
    }

    private func handleResponseArray<M: EYNetworkModel>(promise: Promise<[M]>, _ data: Data?, headers: URLResponse?, error: Error?) -> Void {
        guard error == nil else { promise.reject(error.unsafelyUnwrapped); return }
        guard let data = data else {
            if let url = headers?.url {
                let err = EYNetError(reason: "no data in response of [\(url)]")
                promise.reject(err)
            } else {
                let err = EYNetError(reason: "response body was empty!")
                promise.reject(err)
            }
            return
        }

        parser.parseArray(M.self, data).then(promise.fulfill)
    }
}
