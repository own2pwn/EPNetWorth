//
//  EY+Encodable.swift
//  EPNetWorth
//
//  Created by Evgeniy on 10/02/2019.
//

import Foundation

public protocol EncodableConvertible: EYEncodableNetworkModel, Encodable {}

public extension EncodableConvertible {
    func serialize(args: Any...) throws -> Data {
        guard let encoder = args.first as? JSONEncoder else {
            throw EYNetError(reason: "no json encoder provided to serialize [\(Self.self)]!")
        }

        do {
            return try encoder.encode(self)
        } catch {
            #if DEBUG
                logError(error, type(of: self))
            #endif
            throw error
        }
    }

    // MARK: - Helpers

    private func logError(_ error: Error, _ caller: EncodableConvertible.Type) {
        print("^ E: [\(caller)] can't serialize model: [\(error.localizedDescription)]")
    }
}
