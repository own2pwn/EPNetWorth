//
//  EYEncodableNetworkModel.swift
//  EPNetWorth
//
//  Created by Evgeniy on 10/02/2019.
//

import Foundation

public protocol EYEncodableNetworkModel {
    func serialize(args: Any...) throws -> Data
}
