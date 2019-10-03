//
//  Constant.swift
//  BraveNeuron
//
//  Created by Evgeniy on 08/02/2019.
//  Copyright © 2019 Evgeniy. (BraveNeuron) All rights reserved.
//

import Foundation

public struct EYNetError: Error, LocalizedError {
    public let reason: String

    public var localizedDescription: String {
        return "^ E: EYNetError => \(reason)"
    }

    public var errorDescription: String? {
        return "^ E: EYNetError => \(reason)"
    }
}

internal extension String {
    static let noValue: String = ""
}
