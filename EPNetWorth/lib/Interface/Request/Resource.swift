//
//  Resource.swift
//  BraveNeuron
//
//  Created by Evgeniy on 08/02/2019.
//  Copyright © 2019 Evgeniy. (BraveNeuron) All rights reserved.
//

import Foundation

public protocol Resource {
    var path: String { get }
}

public enum AnyResource: Resource {
    public var path: String {
        assertionFailure("using abstract Resource")

        return .noValue
    }
}
