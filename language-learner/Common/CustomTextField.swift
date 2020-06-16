//
//  CustomTextField.swift
//  language-learner
//
//  Created by Ted Bennett on 15/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

class WrappableTextField: UITextField, UITextFieldDelegate {
    var textFieldChangedHandler: ((String)->Void)?
    var onCommitHandler: (()->Void)?
    var language: String = "en-GB"
    
    convenience init(language: String) {
        self.init()
        self.language = language
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.text = ""
        onCommitHandler?()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentValue = textField.text as NSString? {
            let proposedValue = currentValue.replacingCharacters(in: range, with: string)
            textFieldChangedHandler?(proposedValue as String)
        }
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == language {
                return mode
            }
        }
        return nil
    }
}

struct CustomTextField: UIViewRepresentable {
    private let tmpView : WrappableTextField
    
    let languageIdCodes: [String:String] = [
        "🇯🇵": "ja-JP",
        "🇰🇷": "ko",
        "🇨🇳": "zh-Hans",
        "🇪🇸": "es",
        "🇮🇹": "it",
        "🇫🇷": "fr",
        "🇩🇪": "de",
        "🇬🇧": "en-GB",
        "🏳️": "en-GB"
    ]
    
    //var exposed to SwiftUI object init
    var tag = 0
    var placeholder: String?
    var changeHandler: ((String)->Void)?
    var onCommitHandler: (()->Void)?
    
    var autocorrect: Bool
    var textAlignment: NSTextAlignment
    var textSize: Double
    var returnKeyType: UIReturnKeyType
    var isFirstResponder: Bool
    
    init(tag: Int = 0, placeholder: String = "", language: String = "🇬🇧", autocorrect: Bool = true, textAlignment: NSTextAlignment = .left, textSize: Double = 16.0, returnKeyType: UIReturnKeyType = .default, isFirstResponder: Bool = false, changeHandler: ((String)->Void)? , onCommitHandler: (()->Void)?) {
        self.tmpView = WrappableTextField(language: languageIdCodes[language] ?? "en-GB")
        self.tag = tag
        self.placeholder = placeholder
        self.changeHandler = changeHandler
        self.onCommitHandler = onCommitHandler
        
        self.autocorrect = autocorrect
        self.textAlignment = textAlignment
        self.textSize = textSize
        self.returnKeyType = returnKeyType
        self.isFirstResponder = isFirstResponder
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> WrappableTextField {
        tmpView.tag = tag
        if isFirstResponder {
            tmpView.becomeFirstResponder()
        }
        tmpView.delegate = tmpView
        tmpView.placeholder = placeholder
        tmpView.onCommitHandler = onCommitHandler
        tmpView.textFieldChangedHandler = changeHandler
        
        tmpView.textAlignment = textAlignment
        tmpView.autocorrectionType = autocorrect ? .yes : .no
        tmpView.returnKeyType = returnKeyType
        tmpView.font = UIFont.systemFont(ofSize: CGFloat(textSize))
        return tmpView
    }
    
    func updateUIView(_ uiView: WrappableTextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}


