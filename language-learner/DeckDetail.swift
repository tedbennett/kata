//
//  DeckDetail.swift
//  language-learner
//
//  Created by Ted Bennett on 11/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct DeckDetail: View {
    @Environment(\.presentationMode) var presentation
    @State var showModalView = false
    @State var deck: Deck
    var body: some View {
        VStack {
            DeckInfo(deck: deck)
            List(deck.cardArray) { card in
                CardView(card: card)
            }
        }.navigationBarTitle(Text(deck.name))
            .navigationBarItems(trailing: Button(action: {
                self.showModalView.toggle()
            }, label: {
                Image(systemName: "plus").imageScale(.large)
            }).sheet(isPresented: $showModalView) {
                AddCardModalView(parentDeck: self.$deck)
            })
    }
}

struct DeckInfo: View {
    var deck : Deck
    var body: some View {
        VStack(alignment: .center) {
            Text("\(deck.cardArray.count) cards - 73% learned - Review due in 3 days")
                .padding(20)
        }
    }
    
}

struct CardView: View {
    var card: Card
    var body: some View {
        VStack {
            Text(card.front).font(.headline)
            Text(card.back).font(.subheadline)
        }
    }
}

//struct DeckDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        DeckDetail(deck: DeckTemp(name: "Hangul", language: "🇰🇷",
//                    cards: [CardTemp(front: "ka", back: "가", altBack: nil),
//                            CardTemp(front: "ja", back: "자", altBack: nil)]))
//    }
//}

struct AddCardModalView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var front = ""
    @State private var back = ""
    @State private var failedSave = false
    
    @Binding var parentDeck : Deck
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(""), footer: Text("Make sure both fields are filled in").foregroundColor(failedSave ? .red : .clear)) {
                    TextField("Front", text: $front)
                    TextField("Back", text: $back)
                    
                }
            }.navigationBarTitle(Text("Add New Card"))
                .navigationBarItems(leading: Button(action: {
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


