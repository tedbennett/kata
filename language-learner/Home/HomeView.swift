//
//  HomeView.swift
//  language-learner
//
//  Created by Ted Bennett on 11/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

// UNUSED

//struct HomeView: View {
//    @Environment(\.managedObjectContext) var managedObjectContext
//    @State var isActive = false
//    var decks: FetchedResults<Deck>
//    var body: some View {
//        NavigationView {
//            VStack {
//                Spacer()
//                if self.decks.first != nil {
//                NavigationLink(destination: ReviewView(deck: self.decks.first!, cards: self.decks.first!.cardArray.shuffled())) {
//                    ZStack {
//                        Rectangle().frame(width:250 , height: 100)
//                            .opacity(0.3)
//                            .foregroundColor(Color(UIColor.gray))
//
//                        Text("Review Last Deck")
//                            .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 100)
//                            .multilineTextAlignment(.center)
//                            .font(.largeTitle)
//                    }.cornerRadius(10)
//                }.isDetailLink(false)
//                } else {
//                    Button(action: {}, label: { Text("Review Last Deck")
//                        .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 100)
//                        .multilineTextAlignment(.center)
//                        .font(.largeTitle)
//                    })
//                }
//                Spacer()
//                NavigationLink(destination: HomeDecksView(decks: self.decks), isActive: self.$isActive) {
//                    ZStack {
//                        Rectangle().frame(width:250 , height: 100)
//                            .opacity(0.3)
//                            .foregroundColor(Color(UIColor.gray))
//
//                        Text("Review Decks")
//                            .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 100)
//                            .multilineTextAlignment(.center)
//                            .font(.largeTitle)
//                    }.cornerRadius(10)
//
//                }
//                Spacer()
//            }.navigationBarTitle("Home")
//        }
//    }
//}
//
////struct HomeView_Previews: PreviewProvider {
////    static var previews: some View {
////        HomeView()
////    }
////}
//
//struct HomeDecksView: View {
//
//    @State var isActive = false
//    var decks: FetchedResults<Deck>
//    var body: some View {
//        List(decks) { deck in
////            NavigationLink(destination: ReviewView(deck: deck, cards: deck.cardArray.shuffled())) {
////                VStack(alignment: .leading) {
////                    Text("\(deck.name) \(deck.language)").font(.headline)
////                    Text("\(deck.cardArray.count) cards").font(.subheadline)
////                }
////            }
//        }.navigationBarTitle(Text("Decks"))
//    }
//}

