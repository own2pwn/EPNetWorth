//
//  DecodableParser.swift
//  BraveNeuron
//
//  Created by Evgeniy on 08/02/2019.
//  Copyright © 2019 Evgeniy. (BraveNeuron) All rights reserved.
//

import Foundation
import Promise

public final class EYParserImp: EYParser {
    // MARK: - Members

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()

        return decoder
    }()

    // MARK: - Interface

    public func parse<M: EYNetworkModel>(_ modelType: M.Type, _ data: Data) -> Promise<M> {
        let parsedModel = Promise<M>()

        do {
            let result = try modelType.init(from: data, args: decoder)
            parsedModel.fulfill(result)
        } catch {
            parsedModel.reject(error)
        }

        return parsedModel
    }

    public func parseArray<M: EYNetworkModel>(_ modelType: M.Type, _ data: Data) -> Promise<[M]> {
        let parsedModel = Promise<[M]>()

        do {
            let result: [M] = try modelType.makeArray(from: data, args: decoder)
            parsedModel.fulfill(result)
        } catch {
            parsedModel.reject(error)
        }

        return parsedModel
    }

    // MARK: - Init

    public init() {}
}
