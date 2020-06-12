//
//  DeckDetail.swift
//  language-learner
//
//  Created by Ted Bennett on 11/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct DeckDetail: View {
    var deck: Deck
    var body: some View {
        VStack {
            DeckInfo(deck: deck)
            List(deck.cardArray) { card in
                CardView(card: card)
            }
        }.navigationBarTitle(Text(deck.name))
        .navigationBarItems(trailing: NavigationLink(destination: AddDeckView()) {
            Image(systemName: "plus").imageScale(.large)
        })
    }
}

struct DeckInfo: View {
    var deck : Deck
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            Text(deck.name).font(.largeTitle)
                
            Text("\(deck.cardArray.count) cards - 73% learned - Review due in 3 days")
            .padding(20)
        }//.frame(minWidth: .infinity, maxWidth: .infinity, minHeight: 0, maxHeight: 200)
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
