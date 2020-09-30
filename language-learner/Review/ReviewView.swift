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
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var deck: Deck
    @State var cards: [Card]
    @State private var currentIdx = 0
    @State private var textField = ""
    
    @State private var reviewFinished = false
    @Binding var reviewInProgress: Bool
    
    var currentCard: Card {
        return cards[currentIdx]
    }
    
    var body: some View {
        VStack {
            ProgressBar(current: $currentIdx, total: cards.count).frame(height: 10)
                .animation(.easeInOut(duration: 0.6))
            
            Spacer()
            Text(currentCard.front).font(.largeTitle).multilineTextAlignment(.center)
            Spacer()
            
            CustomTextField(text: $textField, language: deck.language, autocorrect: true, textAlignment: .center, textSize: 32.0, returnKeyType: .done, isFirstResponder: true, changeHandler: { (newString) in
            }, onCommitHandler: { text in
                updateCard(correct: text == self.currentCard.back)
                if self.currentIdx < self.cards.count - 1 {
                    self.textField = ""
                    self.currentIdx += 1
                } else {
                    reviewFinished = true
                    reviewInProgress = false
                }
            })
            Spacer()
            Spacer()
            
        }.navigationBarTitle("Review", displayMode: .inline)
        .sheet(isPresented: $reviewFinished, content: {
            FinishReviewView(deck: deck)
        })
    }
    
    func updateCard(correct: Bool) {
        currentCard.lastScore = correct
        try! self.managedObjectContext.save()
    }
    
    //func finishReview() {
        // Collect scores and create review object
       // let calendar = Calendar.current
//        // If deck has been reviewed, update db
//        if let review = self.deck.reviewsArray.filter({ $0.date == calendar.startOfDay(for:Date()) }).first {
//            review.numCards += Int16(self.cards.count)
//            review.score += self.totalScore
//        } else {
//            //otherwise new db entry
//            let review = Review(context: self.managedObjectContext)
//
//            review.date = calendar.startOfDay(for:Date())
//            review.numCards = Int16(self.cards.count)
//            review.score = self.totalScore
//            review.parent = self.deck
//        }

//    }
}

struct ProgressBar: View {
    @Binding var current: Int
    var total: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                Rectangle().frame(width: min(CGFloat(Double(self.current) / Double(self.total)) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
            }
        }.cornerRadius(45.0)
    }
}



//struct ReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewView()
//    }
//}



