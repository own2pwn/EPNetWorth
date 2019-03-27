//
//  EY+Decodable.swift
//  BraveNeuron
//
//  Created by Evgeniy on 09/02/2019.
//  Copyright © 2019 Evgeniy. (BraveNeuron) All rights reserved.
//

import Foundation

public protocol DecodableConvertible: EYNetworkModel, Decodable {}

public extension DecodableConvertible {
    init(from data: Data, args: Any...) throws {
        guard let decoder = args.first as? JSONDecoder else {
            throw EYNetError(reason: "no json decoder provided to map [\(Self.self)]]!")
        }

        do {
            self = try decoder.decode(Self.self, from: data)
        } catch {
            #if DEBUG
                Self.logError(error, Self.self)
            #endif
            throw error
        }
    }

    // MARK: - Array

    static func makeArray<M: EYNetworkModel>(from data: Data, args: Any...) throws -> [M] {
        guard let decoder = args.first as? JSONDecoder else {
            throw EYNetError(reason: "no json decoder provided to map [\(Self.self)]]!")
        }

        do {
            let result = try decoder.decode([Self].self, from: data)

            return (result as? [M]).unsafelyUnwrapped
        } catch {
            #if DEBUG
                Self.logError(error, Self.self)
            #endif
            throw error
        }
    }

    // MARK: - Helpers

    private static func logError(_ error: Error, _ caller: DecodableConvertible.Type) {
        print("^ E: [\(caller)] can't parse model: [\(error.localizedDescription)]")
    }
}
