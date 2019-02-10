//
//  HTTP+Method.swift
//  EPNetWorth
//
//  Created by Evgeniy on 10/02/2019.
//

import Foundation

enum HTTP {
    enum METHOD: String {
        case GET
        case POST
    }
}

extension HTTP.METHOD {
    init?(httpMethod: String?) {
        guard let value = httpMethod else { return nil }
        self.init(rawValue: value)
    }
}
