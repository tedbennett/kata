//
//  AddCardView.swift
//  language-learner
//
//  Created by Ted Bennett on 15/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI
import Firebase

struct AddCardView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var front = ""
    @State private var back = ""
    @State private var failedSave = false
    //@State private var suggestions = [String]()
    @State private var suggestion: String?
    
    var parentDeck : Deck
    var translator : Translator
    var conditions : ModelDownloadConditions
    
    var modelDownloaded: Bool {
        for model in ModelManager.modelManager().downloadedTranslateModels {
            print(model.language.toLanguageCode())
            if model.language == languageTranslateCodes[parentDeck.language] {
                return true
            }
        }
        return false
    }
    
    init(parentDeck: Deck) {
        self.parentDeck = parentDeck
        let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: languageTranslateCodes[
            parentDeck.language]!)
        conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        translator = NaturalLanguage.naturalLanguage().translator(options: options)
        TranslateRemoteModel.translateRemoteModel(language: .ja)
        translator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
        }
        
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(""), footer: Text("Make sure both fields are filled in").foregroundColor(failedSave ? .red : .clear)) {
                    CustomTextField(tag: 2, placeholder: "Front", changeHandler: { (newString) in
                        self.front = newString
                        self.translator.translate(self.front) { translatedText, error in
                            guard error == nil, let translatedText = translatedText else {
                                print(error!.localizedDescription)
                                return
                            }
                            self.suggestion = translatedText
                        }
                        
                    }, onCommitHandler: {
                        
                    })
                    CustomTextField(tag: 1, placeholder: "Back", language: self.parentDeck.language, changeHandler: { (newString) in
                        self.back = newString
                    }, onCommitHandler: {})
                    
                }
                if suggestion != nil {
                    Section(header: Text("Suggested Translation")) {
                        Text(suggestion!)
                    }
                }
                if !modelDownloaded {
                    Text("Translation model downlaoding")
                }
                
                
            }.navigationBarTitle(Text("Add New Card"))
                .navigationBarItems(
                    leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {Text("Cancel")}),
                    trailing: Button(action: {
                        if (self.front == "") || (self.back == "") {
                            self.failedSave = true
                            return
                        }
                        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        let card = Card(context: viewContext)
                        card.front = self.front
                        card.back = self.back
                        card.id = UUID()
                        card.parent = self.parentDeck
                        
                        do {
                            try viewContext.save()
                            print("Order saved.")
                        } catch {
                            print(error.localizedDescription)
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {Text("Save")}))
            
        }
    }
}

//struct AddCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCardView()
//    }
//}
