//
//  language.swift
//  language-learner
//
//  Created by Ted Bennett on 15/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import Foundation

@objc enum Language: Int16 {
    case english
    case japanese
    case korean
    case chinese
    case spanish
    case italian
    case french
    case german
    case other
}

let languageFlags: [String:Language] = [
    "🇬🇧": .english,
    "🇯🇵": .japanese,
    "🇰🇷": .korean,
    "🇨🇳": .chinese,
    "🇪🇸": .spanish,
    "🇮🇹": .italian,
    "🇫🇷": .french,
    "🇩🇪": .german,
    "🏳️": .other
]

let languageIdCodes: [Language:String] = [
    .english: "en-GB",
    .japanese: "ja",
    .korean: "ko",
    .chinese: "zh-Hans",
    .spanish: "es",
    .italian: "it",
    .french: "fr",
    .german: "de",
    .other: "en-GB"
]

