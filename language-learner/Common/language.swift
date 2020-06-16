//
//  language.swift
//  language-learner
//
//  Created by Ted Bennett on 15/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import Foundation
import Firebase

let languages = ["🇯🇵",
                 "🇰🇷",
                 "🇨🇳",
                 "🇪🇸",
                 "🇮🇹",
                 "🇫🇷",
                 "🇩🇪",
                 "🇬🇧",
                 "🏳️"]

let languageTranslateCodes: [String:TranslateLanguage] = [
    "🇯🇵": TranslateLanguage.ja,
    "🇰🇷": TranslateLanguage.ko,
    "🇨🇳": TranslateLanguage.zh,
    "🇪🇸": TranslateLanguage.es,
    "🇮🇹": TranslateLanguage.it,
    "🇫🇷": TranslateLanguage.fr,
    "🇩🇪": TranslateLanguage.de,
    "🇬🇧": TranslateLanguage.en,
    "🏳️": TranslateLanguage.en
]

