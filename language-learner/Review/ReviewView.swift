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
    @State private var scores = [ReviewResult]()
    @State private var reviewFinished = false
    
    
    var currentCard: Card {
        return cards[currentIdx]
    }
    var totalScore : Double {
        return Double(scores.filter({$0.correct}).count) / Double(scores.count)
    }
    
    var body: some View {
        containedView()
    }
    
    func containedView() -> AnyView {
        switch reviewFinished {
            case false:
                return AnyView(VStack {
                    ProgressBar(current: $currentIdx, total: cards.count).frame(height: 10)
                        .animation(.easeInOut(duration: 0.6))
                    
                    Spacer()
                    Text(currentCard.front).font(.largeTitle).multilineTextAlignment(.center)
                    Spacer()
                    
                    CustomTextField(text: $textField, language: deck.language, autocorrect: true, textAlignment: .center, textSize: 32.0, returnKeyType: .done, isFirstResponder: true, changeHandler: { (newString) in
                    }, onCommitHandler: { text in
                        self.scores.append(ReviewResult(id: self.currentCard.id, correct: text == self.currentCard.back, front: self.currentCard.front, back: self.currentCard.back))
                        if self.currentIdx < self.cards.count - 1 {
                            self.textField = ""
                            self.currentIdx += 1
                        } else {
                            let calendar = Calendar.current
                            // If deck has been reviewed, update db
                            if let review = self.deck.reviewsArray.filter({ $0.date == calendar.startOfDay(for:Date()) }).first {
                                review.numCards += Int16(self.cards.count)
                                review.score += self.totalScore
                            } else {
                                //otherwise new db entry
                                let review = Review(context: self.managedObjectContext)
                                
                                review.date = calendar.startOfDay(for:Date())
                                review.numCards = Int16(self.cards.count)
                                review.score = self.totalScore
                                review.parent = self.deck
                            }
                            
                            for card in self.deck.cardArray {
                                let score = self.scores.filter( {$0.id == card.id})
                                if score.first != nil {
                                    if score.first!.correct {
                                        card.learned = min(card.learned + 0.2, 1.0)
                                    } else {
                                        card.learned = max(card.learned - 0.1, 0.0)
                                    }
                                }
                            }
                            
                            try! self.managedObjectContext.save()
                            self.reviewFinished = true
                        }
                    })
                    Spacer()
                    Spacer()
                    
                }.navigationBarTitle("Review", displayMode: .inline))
            
            case true :
                return AnyView(
                    VStack {
                        ZStack {
                            PercentageWheelView(percentage: self.totalScore, lineWidth: 20).padding(.bottom)
                            Text("\(Int(self.totalScore * 100))%").font(.largeTitle).padding(.bottom)
                        }.frame(width: 300, height: 200)
                        
                        
                        List {
                            Section(header: Text("Needs Review")) {
                                ForEach(self.scores.filter {!$0.correct}) { score in
                                    VStack(alignment: .leading) {
                                        Text(score.front).font(.headline)
                                        Text(score.back).font(.subheadline)
                                    }
                                }
                            }
                            Section(header: Text("Correct")) {
                                ForEach(self.scores.filter {$0.correct}) { score in
                                    VStack(alignment: .leading) {
                                        Text(score.front).font(.headline)
                                        Text(score.back).font(.subheadline)
                                    }
                                }
                            }
                        }
                    }.navigationBarTitle("Results"))
        }
    }
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

struct ReviewResult: Identifiable {
    var id: UUID
    var correct: Bool
    var front: String
    var back: String
}


//struct ReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewView()
//    }
//}



