//
//  AddCardView.swift
//  language-learner
//
//  Created by Ted Bennett on 15/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var front = ""
    @State private var back = ""
    @State private var failedSave = false
    
    var parentDeck : Deck
    
    init(parentDeck: Deck) {
        self.parentDeck = parentDeck

    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(""), footer: Text("Make sure both fields are filled in").foregroundColor(failedSave ? .red : .clear)) {
                    CustomTextField(text: self.$front, placeholder: "Front", isFirstResponder: true, changeHandler: { (newString) in
                        DispatchQueue.main.async {
                            // prevents modifying state during view update
                            self.front = newString
                        }
                    })
                    CustomTextField(text: self.$back, placeholder: "Back", language: self.parentDeck.language, changeHandler: { (newString) in
                        //DispatchQueue.main.async {
                        //self.back = newString
                        //}
                    }, onCommitHandler: { newString in
                        self.back = newString
                    })
                    
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
                        card.learned = 0.0
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
