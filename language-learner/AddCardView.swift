//
//  AddCardView.swift
//  language-learner
//
//  Created by Ted Bennett on 12/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

//struct AddCardView: View {
//    //@State private var card = CardTemp(front: "", back: "")
//    @ObservedObject var cards = [CardForm()];
//    
//    var body: some View {
//        Form {
//            ForEach(self.cards) { card in
//                Section {
//                    TextField("Front", text: card.$front)
//                    
//                    //.foregroundColor(card.frontValid ? Color.gray : Color.red)
//    
//                    TextField("Back", text: card.$back)
//                    
//                    //.foregroundColor(card.backValid ? Color.gray : Color.red)
//                }
//            }
//            Button(action: {
//                self.cards.append(CardForm())
//                print(self.cards)
//            }, label: {
//                Text("Add Another Card")
//            })
//        }.navigationBarTitle(Text("Add Card"))
//    }
//}
//
//struct AddCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCardView()
//    }
//}
//
//
//
//class Cards
