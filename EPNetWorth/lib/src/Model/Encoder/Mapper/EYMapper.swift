//
//  EYMapper.swift
//  EPNetWorth
//
//  Created by Evgeniy on 10/02/2019.
//

import Foundation
import Promise

protocol EYMapper: class {
    init()

    func map<M: EYEncodableNetworkModel>(_ model: M) throws -> Promise<Data>
    // func mapArray<M: EYEncodableNetworkModel>(_ model: [M]) -> Promise<Data>
}
