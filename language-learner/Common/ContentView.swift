//
//  ContentView.swift
//  language-learner
//
//  Created by Ted Bennett on 10/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Deck.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Deck.name, ascending: true)]) var decks: FetchedResults<Deck>

    var body: some View {
//        TabView {
//            HomeView(decks: decks).tabItem {
//                Text("Home")
//                Image(systemName: "house.fill")
//            }
            DeckView(decks: decks)
//                .tabItem {
//                Text("Decks")
//                Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
//            }
//            StatsView(decks: decks).tabItem {
//                Text("Stats")
//                Image(systemName: "chart.bar.fill")
//            }
//        }
    }
}














struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let deck = Deck(context: context)
//        deck.name = "New Deck"
//        deck.language = "🇰🇷"
//        deck.id = UUID()
//        try! context.save()
        return ContentView().environment(\.managedObjectContext, context)
    }

}
