//
//  EnglishPluralize.swift
//  Localize
//
//  Created by Hoang Tran on 5/31/19.
//  Copyright © 2019 Hoang Tran. All rights reserved.
//

import Foundation

internal class EnglishPluralize: PluralizeProtocol {
    
    static let shared = EnglishPluralize()
    
    func plural(for number: Int) -> String {
        switch number {
        case 1:
            return "one"
        default:
            return "any"
        }
    }
}
