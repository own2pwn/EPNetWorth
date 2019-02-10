//
//  KeyValue.swift
//  BraveNeuron
//
//  Created by Evgeniy on 08/02/2019.
//  Copyright © 2019 Evgeniy. (BraveNeuron) All rights reserved.
//

import Foundation

public protocol KeyValue {
    var key: String { get }

    var value: String { get }
}
