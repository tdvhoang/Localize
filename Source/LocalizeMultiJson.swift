//
//  LocalizeMultiJson.swift
//  Localize
//
//  Created by Hoang Tran on 7/31/19.
//

import UIKit

private typealias JSON = NSDictionary

fileprivate extension JSON {
    /// This method has path where file is
    /// If can't find a path return a nil value
    /// If can't serialize data return a nil value
    static func read(bundle: Bundle, named name: String) -> JSON? {
        guard let path = bundle.path(forResource: name, ofType: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONSerialization.jsonObject(
                with: data,
                options: JSONSerialization.ReadingOptions.mutableContainers
                ) as? NSDictionary
        } catch {
            print("Localize can't parse your file", error)
        }
        return nil
    }
    
    /// Try search key in your dictionary using single level
    /// If it doesn't find the key it will use the multilevel
    /// If the key not exis in your JSON return nil value
    func valueFor(key: String) -> String? {
        if let string = self[key] {
            return string as? String
        }
        
        if let string = valueForKeyInLevels(key: key) {
            return string
        }
        
        return nil
    }
    
    /// Try search key in your dictionary using multiples levels
    /// It is necessary that the result be a string
    /// Otherwise it returns nil value
    private func valueForKeyInLevels(key: String) -> String? {
        let values = key.components(separatedBy: ".")
        var jsonCopy: AnyObject? = self as AnyObject
        for key in values {
            if let result = jsonCopy?[key] {
                jsonCopy = result as AnyObject?
            } else {
                return nil
            }
        }
        
        return jsonCopy as? String
    }
}

class LocalizeMultiJson: LocalizeJson {
    
    public static let `default` = LocalizeMultiJson()
    
    var fileNameWithBundle = [(String, Bundle)]()
    
    /// Create default lang name
    override init() {
        super.init()
        fileName = "lang"
    }
    
    @available(*, deprecated, message: "Deprecated. Please use update(fileName:, bundle:) instead.")
    override public func update(bundle: Bundle) {
        fatalError("Please use update(fileName:, bundle:)")
    }
    
    @available(*, deprecated, message: "Deprecated. Please use update(fileName:, bundle:) instead.")
    override public func update(fileName: String) {
        fatalError("Please use update(fileName:, bundle:)")
    }
    
    func update(fileName: String, bundle: Bundle) {
        self.fileNameWithBundle.append((fileName, bundle))
    }
    
    /// Show all aviable languages with criteria name
    ///
    /// - returns: list with storaged languages code
    override var availableLanguages: [String] {
        var languages: Set<String> = []
        
        for localeId in NSLocale.availableLocaleIdentifiers {
            for (aFileName, aBundle) in self.fileNameWithBundle {
                let name = "\(aFileName)-\(localeId)"
                let path = aBundle.path(forResource: name, ofType: "json")
                if path != nil {
                    languages.insert(localeId)
                }
            }
        }
        
        return Array(languages)
    }
    
    // MARK: Read JSON methods
    
    /// This metod contains a logic to read return JSON data
    /// If JSON not is defined, this try use a default
    /// As long as the default language is the same as the current one.
    private func readJSON(tableName: String? = nil) -> JSON? {
        var lang = currentLanguage
        let json = NSMutableDictionary()
        for (aFileName, aBundle) in self.fileNameWithBundle {
            let tableName = tableName ?? aFileName
            if let aJson = JSON.read(bundle: aBundle, named: "\(tableName)-\(lang)") as? [AnyHashable : Any] {
                json.addEntries(from: aJson)
            }
        }
        
        if json.count > 0 {
            return json
        }
        
        lang = lang.components(separatedBy: "-")[0]
        for (aFileName, aBundle) in self.fileNameWithBundle {
            let tableName = tableName ?? aFileName
            if let aJson = JSON.read(bundle: aBundle, named: "\(tableName)-\(lang)") as? [AnyHashable : Any] {
                json.addEntries(from: aJson)
            }
        }
        
        if json.count == 0 && lang != defaultLanguage {
            if let aJson = readDefaultJSON() as? [AnyHashable : Any] {
                json.addEntries(from: aJson)
            }
        }
        
        return json
    }
    
    /// Read a JSON with default language value.
    ///
    /// - returns: json or nil value.
    private func readDefaultJSON(tableName: String? = nil) -> JSON? {
        let json = NSMutableDictionary()
        for (aFileName, aBundle) in self.fileNameWithBundle {
            let tableName = tableName ?? aFileName
            if let aJson = JSON.read(bundle: aBundle, named: "\(tableName)-\(defaultLanguage)") as? [AnyHashable : Any] {
                json.addEntries(from: aJson)
            }
        }
        return json
    }
    
    // MARK: Public methods
    
    /// Localize a string using your JSON File
    /// If the key is not found return the same key
    /// That prevent replace untagged values
    ///
    /// - returns: localized key or same text
    override func localize(key: String, tableName: String? = nil) -> String {
        guard let json = readJSON(tableName: tableName) else {
            return key
        }
        
        if let string = json.valueFor(key: key) {
            return string
        }
        
        guard let defaultJSON = readDefaultJSON(tableName: tableName) else {
            return key
        }
        
        guard let defaultString = defaultJSON.valueFor(key: key) else {
            return key
        }
        
        return defaultString
    }
}
