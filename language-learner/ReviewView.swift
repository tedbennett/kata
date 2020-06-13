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
                    Text(currentCard.front).font(.largeTitle).animation(.linear)
                    Spacer()
                    SATextField(tag: 0, placeholder: "", changeHandler: { (newString) in
                        self.textField = newString
                    }, onCommitHandler: {
                        self.scores.append(ReviewResult(id: self.currentCard.id, correct: self.textField == self.currentCard.back, front: self.currentCard.front, back: self.currentCard.back))
                        if self.currentIdx < self.cards.count - 1 {
                            self.textField = ""
                            self.currentIdx += 1
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
                    })
                    Spacer()
                    Spacer()

                }.navigationBarTitle("Review", displayMode: .inline))
                
            case true :
                return AnyView(
                    VStack {
                        ZStack {
                            PercentageWheel(percentage: self.totalScore).padding(.bottom)
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


class WrappableTextField: UITextField, UITextFieldDelegate {
    var textFieldChangedHandler: ((String)->Void)?
    var onCommitHandler: (()->Void)?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.text = ""
        onCommitHandler?()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentValue = textField.text as NSString? {
            let proposedValue = currentValue.replacingCharacters(in: range, with: string)
            textFieldChangedHandler?(proposedValue as String)
        }
        return true
    }

    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
}

struct SATextField: UIViewRepresentable {
    private let tmpView = WrappableTextField()
    
    //var exposed to SwiftUI object init
    var tag:Int = 0
    var placeholder:String?
    var changeHandler:((String)->Void)?
    var onCommitHandler:(()->Void)?
    
    func makeUIView(context: UIViewRepresentableContext<SATextField>) -> WrappableTextField {
        tmpView.tag = tag
        tmpView.becomeFirstResponder()
        tmpView.delegate = tmpView
        tmpView.placeholder = placeholder
        tmpView.textAlignment = .center
        tmpView.autocorrectionType = .no
        tmpView.returnKeyType = .done
        tmpView.font = UIFont.systemFont(ofSize: 32.0)
        tmpView.onCommitHandler = onCommitHandler
        tmpView.textFieldChangedHandler = changeHandler
        return tmpView
    }
    
    func updateUIView(_ uiView: WrappableTextField, context: UIViewRepresentableContext<SATextField>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}
