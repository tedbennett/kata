//
//  AddDeckView.swift
//  language-learner
//
//  Created by Ted Bennett on 11/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct AddDeckView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Flags to determine whether to show alerts when the user tries to leave/save
    @State private var deckNotComplete = false
    
    @State private var languageIdx = 0
    @State private var name = ""
    @State private var description = ""
    @State private var cards = [CardForm]()
    
    var body: some View {
        NavigationView {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField("Description (Optional)", text: $description)
            }
            
            Section(header: Text("Language")) {
            Picker(selection: $languageIdx, label: Text("")) {
                ForEach(0 ..< languages.count) {
                    Text(languages[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
            }
            
            ForEach(cards.indices, id:\.self) { idx in
                Section(header: Text("Card \(idx + 1)")) {
                    CustomTextField(text: $cards[idx].front, placeholder: "Front", autocorrect: false, returnKeyType: .next, changeHandler: {str in
                        cards[idx].front = str
                    })
                    CustomTextField(text: $cards[idx].back, placeholder: "Back", language: languages[languageIdx], autocorrect: false, returnKeyType: .next, changeHandler: {str in
                        cards[idx].back = str
                    })
                }
            }
            Section {
                Button(action: {
                    cards.append(CardForm())
                }, label: {
                    Text(cards.count == 0 ? "Add Cards" : "Add Another Card")
                })
            }
        }.navigationBarTitle("Add Deck")
        .navigationBarItems(
            trailing:
                Button(action: {
                    if (name == "") {
                        deckNotComplete = true
                    } else {
                        saveDeck()
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                label: {Text("Done")}
                ).alert(isPresented: $deckNotComplete) {
                    Alert(title: Text("Finish?"), message: Text("Some fields not complete. All changes will be lost."), primaryButton: .destructive(Text("Finish")) {
                        presentationMode.wrappedValue.dismiss()
                    }, secondaryButton: .default(Text("Keep Editing")))
                    
                })
        }
    }
    
    func saveDeck() {
        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newDeck = Deck(context: viewContext)
        
        newDeck.id = UUID()
        newDeck.name = name
        
        newDeck.language = languages[languageIdx]
        
        newDeck.desc = description
        cards.filter {$0.front != "" && $0.back != ""}.forEach { card in
            let newCard = Card(context: viewContext)
            newCard.front = card.front
            newCard.back = card.back
            newCard.id = UUID()
            newCard.learned = 0.0
            newCard.lastScore = false
            newCard.parent = newDeck
        }
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct CardForm: Identifiable {
    var id = UUID()
    var front = ""
    var back = ""
}

struct AddDeckView_Previews: PreviewProvider {
    static var previews: some View {
        AddDeckView()
    }
}


//// SO solution to having the keyboard scroll to the selected TextField
//
//final class KeyboardResponder: ObservableObject {
//    private var notificationCenter: NotificationCenter
//    @Published private(set) var currentHeight: CGFloat = 0
//
//    init(center: NotificationCenter = .default) {
//        notificationCenter = center
//        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    deinit {
//        notificationCenter.removeObserver(self)
//    }
//
//    @objc func keyBoardWillShow(notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            currentHeight = keyboardSize.height
//        }
//    }
//
//    @objc func keyBoardWillHide(notification: Notification) {
//        currentHeight = 0
//    }
//}



// Saved for the case where I want card placeholders to turn red if left empty

//ZStack(alignment: .leading) {
//    if !self.deck.cards[idx].backValid { Text("Back").foregroundColor(.red) }
//    TextField(self.deck.cards[idx].backValid ? "Back" : "", text: self.$deck.cards[idx].back, onEditingChanged: {
//        isChanged in
//        if !isChanged {
//            self.deck.cards[idx].backValid = !self.deck.cards[idx].back.isEmpty
//        }
//
//    })
//}
