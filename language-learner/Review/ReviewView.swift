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
    @State private var answerCorrect: Bool?
    
    var currentCard: Card {
        return cards[currentIdx]
    }
    
    var body: some View {
        VStack {
            
            ZStack {
                VStack {
                    ProgressBar(current: $currentIdx, total: cards.count).frame(height: 10).blur(radius: answerCorrect != nil ? 3.0 : 0.0)
                        .animation(.easeInOut(duration: 0.6))
                    Spacer()
                    Text(currentCard.front).font(.largeTitle).multilineTextAlignment(.center).blur(radius: answerCorrect != nil ? 3.0 : 0.0).animation(.easeInOut(duration: 0.2))
                    Spacer()
                    
                    CustomTextField(text: $textField, language: deck.language, autocorrect: true, textAlignment: .center, textSize: 32.0, returnKeyType: .done, isFirstResponder: true, changeHandler: { (newString) in
                    }, onCommitHandler: { text in
                        
                        checkAnswerCorrect(correct: text == self.currentCard.back)
                        updateCard()
                        
                        if self.currentIdx < self.cards.count - 1 {
                            self.textField = ""
                            self.currentIdx += 1
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            reviewFinished = true
                            reviewInProgress = false
                            }
                        }
                    })
                    Spacer()
                    Spacer()
                }
                if answerCorrect != nil {
                    VStack {
                        Spacer()
                    AnswerResultView(correctAnswer: answerCorrect!)
                        .transition(.opacity)
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: answerCorrect!)
                        
                    }
                }
            }
            
        }.navigationBarTitle("Review", displayMode: .inline)
        .sheet(isPresented: $reviewFinished, content: {
            FinishReviewView(deck: deck)
        })
    }
    
    func checkAnswerCorrect(correct: Bool) {
        answerCorrect = correct
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(correct ? .success : .error)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            answerCorrect = nil
        }
    }
    
    func updateCard() {
        currentCard.lastScore = answerCorrect!
        try! self.managedObjectContext.save()
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



//struct ReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewView()
//    }
//}



