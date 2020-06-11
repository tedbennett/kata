//
//  ContentView.swift
//  language-learner
//
//  Created by Ted Bennett on 10/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView().tabItem {
                Text("Home")
                Image(systemName: "house.fill")
            }
            DeckView().tabItem {
                Text("Decks")
                Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
            }
            StatsView().tabItem {
                Text("Stats")
                Image(systemName: "chart.bar.fill")
            }
            SettingsView().tabItem {
                Text("Settings")
                Image(systemName: "gear")
            }
        }
    }
}














struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
