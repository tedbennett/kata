//
//  AddDeckView.swift
//  language-learner
//
//  Created by Ted Bennett on 11/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

private let flags = ["🇰🇷", "🇯🇵", "🇨🇳", "🇪🇸", "🇫🇷", "🇮🇹", "🏳️"]

struct AddDeckView: View {
    // Makes view scroll on opening keyboard
    @ObservedObject private var keyboard = KeyboardResponder()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Flags to determine whether to show alerts when the user tries to leave/save
    @State private var deckNotComplete = false
    @State private var deckEdited = false
    
    @State private var deck = TempDeck()
    
    var body: some View {
        Form {
            Section(header: Text("Details").font(.headline)) {
                TextField("Name", text: $deck.name)
                Picker(selection: $deck.languageIndex, label: Text("Language")) {
                    ForEach(0 ..< flags.count) {
                        Text(flags[$0]).tag($0 as Int?)
                    }
                }
                TextField("Description (Optional)", text: $deck.description)
            }
            
            ForEach(self.deck.cards.indices, id:\.self) { idx in
                Section(header: Text("Card \(idx + 1)")) {
                    TextField("Front", text: self.$deck.cards[idx].front)
                    TextField("Back", text: self.$deck.cards[idx].back)
                }
            }
            Button(action: {
                self.deck.cards.append(CardForm())
                print(self.deck.cards)
            }, label: {
                Text(self.deck.cards.count == 0 ? "Add Cards" : "Add Another Card")
            })
            
        }
            
        .navigationBarTitle("Add Deck")
            
        .navigationBarItems(
            leading: Button(action: {
                if (self.deck.languageIndex != nil) ||
                    (self.deck.name != "") ||
                    (self.deck.description != "") ||
                    !self.deck.cards.isEmpty {
                    self.deckEdited = true
                } else {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }, label: {
                Image(systemName: "chevron.left").imageScale(.large)
                Text("Cancel")
            }
            ).alert(isPresented: self.$deckEdited) {
                Alert(title: Text("Go Back?"), message: Text("All changes will be lost"), primaryButton: .destructive(Text("Go Back")) {
                    self.presentationMode.wrappedValue.dismiss()
                    }, secondaryButton: .default(Text("Keep Editing")))
                
            },
            trailing:
            Button(action: {
                if (self.deck.languageIndex == nil) || (self.deck.name == "") {
                    self.deckNotComplete = true
                }
                for card in self.deck.cards {
                    if card.front.isEmpty || card.back.isEmpty {
                        self.deckNotComplete = true
                    }
                }
                if !self.deckNotComplete {
                    saveDeck(deck: self.deck)
                    self.presentationMode.wrappedValue.dismiss()
                }
            },
                   label: {Text("Save")}
            ).alert(isPresented: self.$deckNotComplete) {
                Alert(title: Text("Deck Not Complete"), message: Text("Make sure to fill in all card and deck fields"))
        })
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.1))
    }
}

func saveDeck(deck: TempDeck) {
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let newDeck = Deck(context: viewContext)
    
    newDeck.id = UUID()
    newDeck.name = deck.name
    if let idx = deck.languageIndex {
        newDeck.language = flags[idx]
    } else {
        newDeck.language = "🏳️"
    }
    newDeck.desc = deck.description
    for card in deck.cards {
        let newCard = Card(context: viewContext)
        newCard.front = card.front
        newCard.back = card.back
        newCard.id = UUID()
        newCard.parent = newDeck
    }
    do {
        try viewContext.save()
        print("Order saved.")
    } catch {
        print(error.localizedDescription)
    }
}

// temporary data structures used before commiting to core data

struct TempDeck {
    var name = ""
    var description = ""
    var languageIndex : Int?
    var cards = [CardForm]()
}

struct CardForm: Identifiable {
    var id = UUID()
    var front = ""
    var back = ""
    var frontValid = true
    var backValid = true
}

struct AddDeckView_Previews: PreviewProvider {
    static var previews: some View {
        AddDeckView()
    }
}


// SO solution to having the keyboard scroll to the selected TextField

final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0
    
    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }
    
    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}



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
