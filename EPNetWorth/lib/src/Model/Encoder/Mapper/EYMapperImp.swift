//
//  EYMapperImp.swift
//  EPNetWorth
//
//  Created by Evgeniy on 10/02/2019.
//

import Foundation
import Promise

public final class EYMapperImp: EYMapper {
    // MARK: - Members

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()

        return encoder
    }()

    // MARK: - Interface

    public func map<M: EYEncodableNetworkModel>(_ model: M) throws -> Data {
        return try model.serialize(args: encoder)
    }

    // MARK: - Init

    public init() {}
}
