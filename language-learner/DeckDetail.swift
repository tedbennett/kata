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
    @State var showModalView = false
    @State var showActionSheet = false
    @ObservedObject var deck: Deck
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 150, height: 150)
                Text("\(deck.cardArray.count) cards - 73% learned - Review due in 3 days")
                    .padding(20)
            }
            List{
                ForEach(deck.cardArray, id: \.self) { card in
                    CardView(card: card)
                }.onDelete(perform: { idxSet in
                    let card = self.deck.cardArray[idxSet.first!]
                    self.managedObjectContext.delete(card)
                    try! self.managedObjectContext.save()
                })
            }
        }.navigationBarTitle(Text(deck.name))
            .navigationBarItems(trailing:
                HStack { Button(action: {
                    self.showActionSheet = true
                }, label: {
                    Image(systemName: "ellipsis").imageScale(.large)
                }).actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text(""), buttons: [.default(Text("Review this deck")),
                                                           .default(Text("Stats for this deck")),
                                                           .destructive(Text("Delete Deck"))])
                    }
                    Button(action: {
                    self.showModalView.toggle()
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                }).sheet(isPresented: $showModalView) {
                    AddCardModalView(parentDeck: self.deck)
                }})
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

struct AddCardModalView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var front = ""
    @State private var back = ""
    @State private var failedSave = false
    
    var parentDeck : Deck
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(""), footer: Text("Make sure both fields are filled in").foregroundColor(failedSave ? .red : .clear)) {
                    TextField("Front", text: $front)
                    TextField("Back", text: $back)
                    
                }
            }.navigationBarTitle(Text("Add New Card"))
                .navigationBarItems(leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {Text("Cancel")}),
                                    trailing: Button(action: {
                                        if (self.front == "") || (self.back == "") {
                                            self.failedSave = true
                                            return
                                        }
                                        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                        let card = Card(context: viewContext)
                                        card.front = self.front
                                        card.back = self.back
                                        card.id = UUID()
                                        card.parent = self.parentDeck
                                        
                                        do {
                                            try viewContext.save()
                                            print("Order saved.")
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                        self.presentationMode.wrappedValue.dismiss()
                                    }, label: {Text("Save")}))
            
        }
    }
}



//private func createPercentageWheel(score : Float) -> CAShapeLayer {
//
//    let shapeLayer = CAShapeLayer()
//    let finalAngle = (2 * CGFloat.pi * CGFloat(score)) - (CGFloat.pi / 2)
//    let centerPoint = CGPoint(x: percentageWheelView.bounds.midX, y: percentageWheelView.bounds.midY)
//    let circularPath = UIBezierPath(arcCenter: centerPoint, radius: 80, startAngle: -CGFloat.pi / 2, endAngle: finalAngle, clockwise: true)
//    shapeLayer.path = circularPath.cgPath
//
//    if score > 0.8 {
//        shapeLayer.strokeColor = UIColor.systemGreen.cgColor
//    } else if score > 0.5 {
//        shapeLayer.strokeColor = UIColor.systemOrange.cgColor
//    } else {
//        shapeLayer.strokeColor = UIColor.systemRed.cgColor
//    }
//    shapeLayer.fillColor = UIColor.clear.cgColor
//    shapeLayer.lineWidth = 10
//    shapeLayer.lineCap = CAShapeLayerLineCap.round
//    shapeLayer.strokeEnd = 0
//
//    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//    basicAnimation.toValue = 1
//    basicAnimation.duration = 1.2
//
//    basicAnimation.fillMode = CAMediaTimingFillMode.forwards
//    basicAnimation.isRemovedOnCompletion = false
//    shapeLayer.add(basicAnimation, forKey: "percentageAnimation")
//    return shapeLayer
//}
//
//private func createTrackWheel() -> CAShapeLayer {
//    let shapeLayer = CAShapeLayer()
//    let centerPoint = CGPoint(x: percentageWheelView.bounds.midX, y: percentageWheelView.bounds.midY)
//    let circularPath = UIBezierPath(arcCenter: centerPoint, radius: 80, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
//    shapeLayer.path = circularPath.cgPath
//
//    shapeLayer.strokeColor = UIColor.systemGray.cgColor
//    shapeLayer.fillColor = UIColor.clear.cgColor
//    shapeLayer.lineWidth = 10
//    shapeLayer.opacity = 0.2
//    return shapeLayer
//}
