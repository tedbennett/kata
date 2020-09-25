//
//  SettingsView.swift
//  language-learner
//
//  Created by Ted Bennett on 11/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        
        NavigationView {
            Form {
                Section{
                Picker(selection: $userSettings.dailyGoal, label: Text("Daily Goal")) {
                    ForEach(userSettings.dailyGoals, id: \.self) { dailyGoal in
                        Text("\(dailyGoal)")
                    }
                    .navigationBarTitle("Daily Goal")
                }
                }.navigationBarTitle("Settings")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}



class UserSettings: ObservableObject {

    @Published var dailyGoal: Int {
        didSet {
            UserDefaults.standard.set(dailyGoal, forKey: "DailyGoal")
        }
    }
    
    public var dailyGoals = [20, 30, 40, 50, 75, 100, 150, 200]
    
    init() {
        self.dailyGoal = UserDefaults.standard.integer(forKey: "DailyGoal")
    }
}
