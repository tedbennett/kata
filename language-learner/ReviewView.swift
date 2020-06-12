//
//  ReviewView.swift
//  language-learner
//
//  Created by Ted Bennett on 12/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct ReviewView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var deck: Deck
    @State var cards: [Card]
    @State private var currentCard = 0
    @State private var textField = ""
    @State private var scores = [(id: UUID, correct: Bool)]()
    @State private var reviewFinished = false
    
    var body: some View {
        VStack {
            
            Text(cards[currentCard].front)
            TextField("Translate", text: $textField, onEditingChanged: {isChanged in
                if !isChanged {
                    self.scores.append((id: self.cards[self.currentCard].id, correct: self.textField == self.cards[self.currentCard].back))
                    if self.currentCard < self.cards.count - 1 {
                        self.textField = ""
                        self.currentCard += 1
                    } else {
                        let reviewRecord = ReviewRecords(context: self.managedObjectContext)
                        reviewRecord.date = Date()
                        reviewRecord.parent = self.deck
                        for score in self.scores {
                            let cardScore = CardScore(context: self.managedObjectContext)
                            cardScore.correct = score.correct
                            cardScore.id = score.id
                            cardScore.parent = reviewRecord
                        }
                        
                        try! self.managedObjectContext.save()
                        
                        self.reviewFinished = true
                    }
                }
                }).padding(20)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            NavigationLink(destination: FinishReviewView(deck: deck), isActive: $reviewFinished) {
                Text("")
            }
        }
        
     
    }
}




//struct ReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewView()
//    }
//}
