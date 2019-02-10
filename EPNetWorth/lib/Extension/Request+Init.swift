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
    init(url: URL, body: Data?) {
        self.init(url: url)
        setBody(body)
    }

    // MARK: - Helpers

    private mutating func setBody(_ body: Data?) {
        guard let body = body else { return }
        method = .POST
        httpBody = body
    }
}

extension URLRequest {
    var method: HTTP.METHOD {
        get { return HTTP.METHOD(httpMethod: httpMethod) ?? HTTP.METHOD.GET }
        set { httpMethod = newValue.rawValue }
    }
}
