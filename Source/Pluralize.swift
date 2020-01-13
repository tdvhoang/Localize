//
//  Pluralize.swift
//  Localize
//
//  Copyright © 2019 @andresilvagomez.
//

import Foundation

protocol PluralizeProtocol {
    func plural(for number: Int) -> String
}

fileprivate extension Int {
    /// Get plural string value for Int value.
    var plural: String {
        switch Localize.currentLanguage {
        case "en":
            return EnglishPluralize.shared.plural(for: self)
        default:
            return VietnamPluralize.shared.plural(for: self)
        }
    }
}

/// Pluralize is a class focused in reduce your app logic for localized values
/// you can pluralize
public class Pluralize {

    /// Pluralize strings with numeric value
    /// get localized and pluralized key acording with the rules
    /// and value.
    ///
    /// - parameter String: The value could you pluralize
    ///
    /// - returns: Localized and Pluralized key according with the value.
    static func pluralize(key: String, value: Int, tableName: String? = nil) -> String {
        let plural = value.plural
        var newKey = key
        if plural.count > 0 {
            newKey = "\(key).\(plural)"
        }

        return newKey.localize(value: "\(value)", tableName: tableName)
    }
    
    static func pluralize(key: String, values: [Int], tableName: String? = nil) -> String {
        var newKey = key
        for aValue in values {
            let plural = aValue.plural
            if plural.count > 0 {
                newKey = "\(newKey).\(plural)"
            }
        }
        return Localize.localize(key: newKey, values: values.map { "\($0)" }, tableName: tableName)
    }
}
