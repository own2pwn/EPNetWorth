//
//  String+Encoding.swift
//  EPNetWorth
//
//  Created by Evgeniy on 10/02/2019.
//

import Foundation

extension String {
    var urlEncoded: String {
        let encoded = addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)

        return encoded ?? self
    }
}
