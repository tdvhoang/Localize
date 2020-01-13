//
//  LocalizeLocale.swift
//  Localize
//
//  Created by Hoang Tran on 9/6/19.
//  Copyright © 2019 Hoang Tran. All rights reserved.
//

import UIKit

public extension Locale {
    static var currentAppSetting : Locale {
        return Locale(identifier: Localize.currentLanguage)
    }
}
