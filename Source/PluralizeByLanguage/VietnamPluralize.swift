//
//  VietnamPluralize.swift
//  Localize
//
//  Created by Hoang Tran on 5/31/19.
//  Copyright © 2019 Hoang Tran. All rights reserved.
//

import Foundation

internal class VietnamPluralize: PluralizeProtocol {
    
    static let shared = VietnamPluralize()
    
    func plural(for number: Int) -> String {
        return "any"
    }
}
