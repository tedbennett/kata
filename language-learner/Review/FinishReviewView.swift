//
//  FinishReviewView.swift
//  language-learner
//
//  Created by Ted Bennett on 30/09/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct FinishReviewView: View {
    var deck: Deck
    var percentage: Double {
        deck.cardArray.reduce(0.0) { sum, card in
            sum + (card.lastScore ? 1 : 0)
        } / Double(deck.cardArray.count)
    }
    
    var body: some View {
        NavigationView {
        VStack {
            ZStack {
                PercentageWheelView(percentage: percentage, lineWidth: 20).padding(.bottom)
                Text("\(Int(percentage * 100))%").font(.largeTitle).padding(.bottom)
            }.frame(width: 300, height: 200)
            
            List {
                ForEach(deck.cardArray.filter {!$0.lastScore}) { card in
                    ScoreCard(card: card)
                }
                ForEach(deck.cardArray.filter {$0.lastScore}) { card in
                    ScoreCard(card: card)
                }
            }
        }.navigationBarTitle("Results")
        .transition(.identity)
        }
    }
}

//struct FinishReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        FinishReviewView()
//    }
//}
