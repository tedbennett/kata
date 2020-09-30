//
//  DeckDetail.swift
//  language-learner
//
//  Created by Ted Bennett on 11/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct DeckDetail: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) var presentation
    @State var showAddCards = false
    @State var showingReview = false
    @ObservedObject var deck: Deck
    var percentage: Double {
        deck.cardArray.reduce(0.0) { sum, card in
            sum + card.learned
        } / Double(deck.cardArray.isEmpty ? 1 : deck.cardArray.count)
    }
    
    var body: some View {
        List{
            
            VStack {
                
                // Workaround getting home view to pop
                NavigationLink(destination: ReviewView(deck: deck, cards: deck.cardArray.shuffled(), reviewInProgress: $showingReview), isActive: $showingReview) {
                    EmptyView()
                }
                
                ZStack {
                    PercentageWheelView(percentage: percentage, lineWidth: 20)
                    VStack(alignment: .center, spacing: 0) {
                        Text("\(Int(percentage * 100))%").font(.largeTitle)
                        Text("Learned")
                    }
                }.frame(height: 150)
                Text("Last Review:").font(.title).padding(.top, 20)
            }.padding(20)
            
            ForEach(deck.cardArray.sorted(by: {card1, card2 in
                card1.learned > card2.learned
            }), id: \.self) { card in
                CardView(card: card)
            }
            .onDelete(perform: { idxSet in
                let card = deck.cardArray[idxSet.first!]
                managedObjectContext.delete(card)
                try! managedObjectContext.save()
            })
            
        }.navigationBarTitle(Text(deck.name))
        .navigationBarItems(trailing:
                                HStack {
                                    Button {
                                        showingReview.toggle()
                                    } label: {
                                        Text("Review")
                                    }.disabled(deck.cardArray.isEmpty)
                                    
                                    Spacer()
                                    Spacer()
                                    Button(action: {
                                        showAddCards.toggle()
                                    }, label: {
                                        Image(systemName: "plus").imageScale(.large)
                                    }).sheet(isPresented: $showAddCards) {
                                        AddCardView(parentDeck: self.deck)
                                    }
                                })
    }
}

struct CardView: View {
    var card: Card
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(card.front).font(.headline)
                Text(card.back).font(.subheadline)
            }
            Spacer()
            if card.lastScore {
                Image(systemName: "checkmark").foregroundColor(.green)
            } else {
                Image(systemName: "xmark").foregroundColor(.red)
            }
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

