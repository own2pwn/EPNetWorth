//
//  EYNetworkModel.swift
//  EPNetWorth
//
//  Created by Evgeniy on 10/02/2019.
//

import Foundation

public protocol EYNetworkModel {
    init(from data: Data, args: Any...) throws
    static func makeArray<M: EYNetworkModel>(from data: Data, args: Any...) throws -> [M]
}
