//
//  BodyElement.swift
//  BraveNeuron
//
//  Created by Evgeniy on 08/02/2019.
//  Copyright © 2019 Evgeniy. (BraveNeuron) All rights reserved.
//

import Foundation

public protocol BodyElement: KeyValue {}

public enum AnyBodyElement: BodyElement {
    public var key: String {
        assertionFailure("using abstract BodyElement key")

        return .noValue
    }

    public var value: String {
        assertionFailure("using abstract BodyElement name")

        return .noValue
    }
}
