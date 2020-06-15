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
    
    let languages : [Language:String] = [
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
    
    //var exposed to SwiftUI object init
    var tag = 0
    var placeholder: String?
    var changeHandler: ((String)->Void)?
    var onCommitHandler: (()->Void)?
    
    init(tag: Int = 0, language: Language, placeholder: String?, changeHandler: (String)->Void, onCommitHandler: (()->Void)?) {
        tmpView = WrappableTextField(language: languages[language] ?? "en-GB")
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> WrappableTextField {
        tmpView.tag = tag
        tmpView.becomeFirstResponder()
        tmpView.delegate = tmpView
        tmpView.placeholder = placeholder
        tmpView.textAlignment = .center
        tmpView.autocorrectionType = .no
        tmpView.returnKeyType = .done
        tmpView.font = UIFont.systemFont(ofSize: 32.0)
        tmpView.onCommitHandler = onCommitHandler
        tmpView.textFieldChangedHandler = changeHandler
        return tmpView
    }
    
    func updateUIView(_ uiView: WrappableTextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}


