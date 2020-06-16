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
    @State var showActionSheet = false
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
            VStack(alignment: .center) {
                ZStack {
                    PercentageWheelView(percentage: percentage, lineWidth: 20)
                    VStack(alignment: .center, spacing: 0) {
                        Text("\(Int(percentage * 100))%").font(.largeTitle)
                        Text("Learned")
                    }
                }
                
                    .frame(width: 150, height: 150)
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

//struct AddCardModalView: View {
//    @Environment(\.presentationMode) private var presentationMode
//
//    @State private var front = ""
//    @State private var back = ""
//    @State private var failedSave = false
//    //@State private var suggestions = [String]()
//    @State private var suggestion: String?
//
//    var parentDeck : Deck
//    var translator : Translator
//    var conditions : ModelDownloadConditions
//
//    let languageTranslateCodes: [String:TranslateLanguage] = [
//        "🇯🇵": TranslateLanguage.ja,
//        "🇰🇷": TranslateLanguage.ko,
//        "🇨🇳": TranslateLanguage.zh,
//        "🇪🇸": TranslateLanguage.es,
//        "🇮🇹": TranslateLanguage.it,
//        "🇫🇷": TranslateLanguage.fr,
//        "🇩🇪": TranslateLanguage.de,
//        "🇬🇧": TranslateLanguage.en,
//        "🏳️": TranslateLanguage.en
//
//    ]
//
//
//    init(parentDeck: Deck) {
//        self.parentDeck = parentDeck
//        let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: languageTranslateCodes[
//            parentDeck.language]!)
//        translator = NaturalLanguage.naturalLanguage().translator(options: options)
//        conditions = ModelDownloadConditions(
//            allowsCellularAccess: false,
//            allowsBackgroundDownloading: true
//        )
//        translator.downloadModelIfNeeded(with: conditions) { error in
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//        }
//    }
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text(""), footer: Text("Make sure both fields are filled in").foregroundColor(failedSave ? .red : .clear)) {
//                    TextField("Front", text: $front, onCommit: {
//                        self.translator.downloadModelIfNeeded(with: self.conditions) { error in
//                            guard error == nil else {
//                                print(error!.localizedDescription)
//                                return
//                            }
//                            self.translator.translate(self.front) { translatedText, error in
//                                guard error == nil, let translatedText = translatedText else {
//                                    print(error!.localizedDescription)
//                                    return
//                                }
//
//                                // Translation succeeded.
//                                self.suggestion = translatedText
//                            }
//                        }
//
//                    })
//                    TextField("Back", text: $back)
//
//                }
//                Section(header: Text("Suggested Translation")) {
//                    if suggestion != nil {
//                        Text(suggestion!)
//                    }
//                }.disabled(self.suggestion == nil)
//
//            }.navigationBarTitle(Text("Add New Card"))
//                .navigationBarItems(
//                    leading: Button(action: {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }, label: {Text("Cancel")}),
//                    trailing: Button(action: {
//                        if (self.front == "") || (self.back == "") {
//                            self.failedSave = true
//                            return
//                        }
//                        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//                        let card = Card(context: viewContext)
//                        card.front = self.front
//                        card.back = self.back
//                        card.id = UUID()
//                        card.parent = self.parentDeck
//
//                        do {
//                            try viewContext.save()
//                            print("Order saved.")
//                        } catch {
//                            print(error.localizedDescription)
//                        }
//                        self.presentationMode.wrappedValue.dismiss()
//                    }, label: {Text("Save")}))
//
//        }
//    }
//}
//
//
