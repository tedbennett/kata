//
//  DeckView.swift
//  language-learner
//
//  Created by Ted Bennett on 11/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct DeckView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showAddDeckView = false
    var decks: FetchedResults<Deck>
    var body: some View {
        NavigationView {
            List(decks) { deck in
                DeckCell(deck: deck)
            }.navigationBarTitle(Text("Decks"))
            .navigationBarItems(trailing: Button {
                showAddDeckView.toggle()
            } label: {
                Image(systemName: "plus").imageScale(.large)
            }).sheet(isPresented: $showAddDeckView, content: {
                AddDeckView()
            })
        }
    }
}

struct DeckCell: View {
    @ObservedObject var deck: Deck
    var body: some View {
        return NavigationLink(destination: DeckDetail(deck: deck)) {
            HStack {
                Text(deck.language).font(.largeTitle)
                VStack(alignment: .leading) {
                    Text(deck.name).font(.headline)
                    Text("\(deck.cardArray.count) card\(deck.cardArray.count == 1 ? "" : "s")").font(.subheadline)
                }
            }
        }
    }
}

//struct DeckView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeckView()
//    }
//}
