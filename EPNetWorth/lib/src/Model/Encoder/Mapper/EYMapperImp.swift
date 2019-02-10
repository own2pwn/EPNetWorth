//
//  EYMapperImp.swift
//  EPNetWorth
//
//  Created by Evgeniy on 10/02/2019.
//

import Foundation
import Promise

final class EYMapperImp: EYMapper {
    // MARK: - Members

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()

        return encoder
    }()

    // MARK: - Interface

    func map<M: EYEncodableNetworkModel>(_ model: M) throws -> Promise<Data> {
        return Promise<Data>(value: try model.serialize(args: encoder))
    }
}
