//
//  Request+Init.swift
//  EPNetWorth
//
//  Created by Evgeniy on 10/02/2019.
//

import Foundation

extension URLComponents {
    init(url: URL) {
        self.init(url: url, resolvingAgainstBaseURL: false)!
    }
}

extension URL {
    init(base: URL, query: [QueryElement]) {
        var components = URLComponents(url: base)
        components.queryItems = URL.getQueryItems(from: query)

        self = components.url ?? base
    }

    // MARK: - Helpers

    private static func getQueryItems(from query: [QueryElement]) -> [URLQueryItem]? {
        guard !query.isEmpty else {
            return nil
        }

        return query.map { URLQueryItem(name: $0.name, value: $0.value) }
    }
}

extension URLRequest {
    init(url: URL, body: [BodyElement]) {
        self.init(url: url)
    }

    // MARK: - Helpers

    private mutating func setBody(_ body: [BodyElement]) {
        guard !body.isEmpty else { return }
        method = .POST

        let bodyComponents = body.map { "\($0.key)=\($0.value.urlEncoded)" }
        let bodyString = bodyComponents.joined(separator: "&")
        httpBody = bodyString.data(using: .utf8)
    }
}

extension URLRequest {
    var method: HTTP.METHOD {
        get { return HTTP.METHOD(httpMethod: httpMethod) ?? HTTP.METHOD.GET }
        set { httpMethod = newValue.rawValue }
    }
}
