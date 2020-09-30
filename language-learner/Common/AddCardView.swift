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
    
    @State var parentDeck : Deck
    @State var tempDeck = TempDeck()
    
    struct TempDeck {
        struct TempCard: Identifiable {
            var id = UUID()
            var front = ""
            var back = ""
        }
        var cards = [TempCard()]
    }
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(self.tempDeck.cards.indices, id:\.self) { idx in
                    Section(header: Text("Card \(idx + 1)")) {
                        CustomTextField(text: $tempDeck.cards[idx].front, placeholder: "Front", autocorrect: false, returnKeyType: .next, changeHandler: {str in
                            tempDeck.cards[idx].front = str
                        })
                        CustomTextField(text: $tempDeck.cards[idx].back, placeholder: "Back", language: parentDeck.language, autocorrect: false, returnKeyType: .next, changeHandler: {str in
                            tempDeck.cards[idx].back = str
                        })
                    }
                }
                Button(action: {
                    tempDeck.cards.append(TempDeck.TempCard())
                }, label: {
                    Text("Add Another Card")
                })
                
            }.navigationBarTitle(Text("Add New Cards"))
            .navigationBarItems(trailing: Button(action: {
                    saveCards()
                }, label: {Text("Done")}))
            
        }
    }
    
    func saveCards() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        tempDeck.cards.forEach { card in
            if !card.front.isEmpty && !card.back.isEmpty {
                let newCard = Card(context: context)
                newCard.front = card.front
                newCard.back = card.back
                newCard.id = UUID()
                newCard.learned = 0.0
                newCard.parent = self.parentDeck
                newCard.lastScore = false
            }
        }
        do {
            try context.save()
            print("Order saved.")
        } catch {
            print(error.localizedDescription)
        }
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let deck = Deck(context: viewContext)
        AddCardView(parentDeck: deck)
    }
}
