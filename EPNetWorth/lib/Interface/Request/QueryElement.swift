//
//  QueryElement.swift
//  BraveNeuron
//
//  Created by Evgeniy on 08/02/2019.
//  Copyright © 2019 Evgeniy. (BraveNeuron) All rights reserved.
//

import Foundation

public protocol QueryElement {
    var name: String { get }

    var value: String { get }
}

public enum AnyQueryElement: QueryElement {
    public var name: String {
        assertionFailure("using abstract QueryElement name")

        return .noValue
    }

    public var value: String {
        assertionFailure("using abstract QueryElement value")

        return .noValue
    }
}
