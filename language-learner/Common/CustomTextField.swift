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
    var onCommitHandler: ((String)->Void)?
    var language: String = "en-GB"
    
    convenience init(language: String) {
        self.init()
        self.language = language
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onCommitHandler?(textField.text ?? "")
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
    private let tmpView : WrappableTextField
    @Binding var text: String
    
    init(text: Binding<String>, tag: Int = 0, placeholder: String = "", language: String = "🇬🇧", autocorrect: Bool = true, textAlignment: NSTextAlignment = .left, textSize: Double = 16.0, returnKeyType: UIReturnKeyType = .default, isFirstResponder: Bool = false, changeHandler: ((String)->Void)? , onCommitHandler: ((String)->Void)? = nil)  {
        self.tmpView = WrappableTextField(language: languageIdCodes[language] ?? "en-GB")
        self.tmpView.tag = tag
        self.tmpView.placeholder = placeholder
        self.tmpView.textFieldChangedHandler = changeHandler
        self.tmpView.onCommitHandler = onCommitHandler
        
        self.tmpView.textAlignment = textAlignment
        self.tmpView.autocorrectionType = autocorrect ? .yes : .no
        self.tmpView.returnKeyType = returnKeyType
        self.tmpView.font = UIFont.systemFont(ofSize: CGFloat(textSize))
        
        if isFirstResponder {
            self.tmpView.becomeFirstResponder()
        }
        self._text = text
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> WrappableTextField {
        tmpView.delegate = tmpView
        return tmpView
    }
    
    func updateUIView(_ uiView: WrappableTextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiView.text = self.text
        print(self.text)
    }
}


