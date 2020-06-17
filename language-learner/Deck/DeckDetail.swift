//
//  DeckDetail.swift
//  language-learner
//
//  Created by Ted Bennett on 11/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI
import Firebase

struct DeckDetail: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) var presentation
    @State var showModalView = false
    @State var startReview = false
    @ObservedObject var deck: Deck
    var percentage: Double
    
    init(deck: Deck) {
        self.deck = deck
        var learnedSum = 0.0
        deck.cardArray.forEach {learnedSum += $0.learned}
        self.percentage = learnedSum / Double(deck.cardArray.count)
    }
    
    var body: some View {
        List{
            VStack {
                ZStack {
                    PercentageWheelView(percentage: percentage, lineWidth: 20)
                    VStack(alignment: .center, spacing: 0) {
                        Text("\(Int(percentage * 100))%").font(.largeTitle)
                        Text("Learned")
                    }
                }
                    
                .frame(height: 150)
                Text("\(deck.cardArray.count) cards - Review due in 3 days")
                    .padding(20)
            }.padding(20)
            
            ForEach(deck.cardArray, id: \.self) { card in
                CardView(card: card)
            }.onDelete(perform: { idxSet in
                let card = self.deck.cardArray[idxSet.first!]
                self.managedObjectContext.delete(card)
                try! self.managedObjectContext.save()
            })
            
        }.navigationBarTitle(Text(deck.name))
            .navigationBarItems(trailing:
                HStack { NavigationLink(destination: ReviewView(deck: self.deck, cards: self.deck.cardArray.shuffled())) {
                    Text("Review")
                    }
                    Spacer()
                    Spacer()
                    Button(action: {
                        self.showModalView.toggle()
                    }, label: {
                        Image(systemName: "plus").imageScale(.large)
                    }).sheet(isPresented: $showModalView) {
                        AddCardView(parentDeck: self.deck)
                    }})
    }
}

struct CardView: View {
    var card: Card
    var body: some View {
        VStack(alignment: .leading) {
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

