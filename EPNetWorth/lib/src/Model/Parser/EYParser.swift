//
//  EYParser.swift
//  BraveNeuron
//
//  Created by Evgeniy on 08/02/2019.
//  Copyright © 2019 Evgeniy. (BraveNeuron) All rights reserved.
//

import Foundation
import Promise

public protocol EYParser: class {
    init()

    func parse<M: EYNetworkModel>(_ modelType: M.Type, _ data: Data) -> Promise<M>
    func parseArray<M: EYNetworkModel>(_ modelType: M.Type, _ data: Data) -> Promise<[M]>
}
