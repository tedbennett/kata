//
//  HomeView.swift
//  language-learner
//
//  Created by Ted Bennett on 11/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var decks: FetchedResults<Deck>
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: HomeDecksView(decks: self.decks)) {
                    VStack(alignment: .leading) {
                        Text("Review Last Deck")
                            .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 100)
                            .font(.largeTitle)
                    }
                }
                Button(action: {
                    print("Button tapped")
                }) {
                    Text("Review Decks...")
                        .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 100)
                        .font(.largeTitle)
                }
            }.navigationBarTitle("Home")
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

struct HomeDecksView: View {
    //@Environment(\.managedObjectContext) var managedObjectContext
    var decks: FetchedResults<Deck>
    var body: some View {
        List(decks) { deck in
            NavigationLink(destination: ReviewView(deck: deck, cards: deck.cardArray.shuffled())) {
                VStack(alignment: .leading) {
                    Text("\(deck.name) \(deck.language)").font(.headline)
                    Text("\(deck.cardArray.count) cards").font(.subheadline)
                }
            }
        }.navigationBarTitle(Text("Decks"))
    }
}

