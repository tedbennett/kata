//
//  StatsView.swift
//  language-learner
//
//  Created by Ted Bennett on 11/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    @State private var goal = UserDefaults.standard.integer(forKey: "DailyGoal")
    @ObservedObject var userSettings = UserSettings()
    var decks: FetchedResults<Deck>
 
    var body: some View {
        NavigationView {
            
            List {
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        DailyProgressView(goal: $userSettings.dailyGoal, currentProgress: self.getDailyProgress()).padding(20)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        CalendarStatsView(scores: self.getReviews(), streak: true).padding(20).frame(alignment: .center)
                        Spacer()
                    }
                }
                Section(header: Text("Daily Goal")) {
                        Picker(selection: $userSettings.dailyGoal, label: Text("Daily Goal")) {
                            ForEach(userSettings.dailyGoals, id: \.self) { dailyGoal in
                                Text("\(dailyGoal)")
                            }
                            
                            
                        }.pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Decks")) {
                ForEach(getSortedDecks(), id: \.self) { deck in
                    HStack {
                        Text(deck.name)
                        Spacer()
                        if deck.learned > 0.8 {
                            Image(systemName: "checkmark").foregroundColor(.green)
                        } else if deck.learned > 0.4 {
                            Image(systemName: "questionmark").foregroundColor(.yellow)
                        } else {
                            Image(systemName: "xmark").foregroundColor(.red)
                        }
                    }
                }
                }
            }.navigationBarTitle("Stats")
        }.onAppear {
            self.goal = UserDefaults.standard.integer(forKey: "DailyGoal")
        }
    }
    
    
    func getReviews() -> [Review] {
        var reviews = [Review]()
        decks.forEach({ deck in
            reviews.append(contentsOf: deck.reviewsArray)
        })
        return reviews
    }
    
    struct Score : Hashable {
        var name: String
        var learned: Double
    }
    
    func getSortedDecks() -> [Score] {
        var scores = [Score]()
        for deck in Array(decks) {
            var learnedSum = 0.0
            deck.cardArray.forEach {learnedSum += $0.learned}
            scores.append(Score(name: deck.name, learned: learnedSum / Double(deck.cardArray.count)))
        }
        return scores
    }
    
    func getDailyProgress() -> Int {
        var currentProgress = 0
        self.decks.forEach({deck in
            deck.reviewsArray.forEach( {
                if $0.date == Calendar.current.startOfDay(for:Date()) {
                    currentProgress += Int($0.numCards)
                }
            })
        })
        return currentProgress
    }

}

//struct StatsView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        StatsView(decks: FetchedResults<Deck>)
//    }
//}


struct DailyProgressView: View {
    @Binding var goal : Int
    var currentProgress: Int
    
    var body: some View {
        
            VStack {
                Text("Today's progress:")
                HStack(alignment: .bottom, spacing: 3) {
                    Text("\(self.currentProgress)/\(self.goal)").font(Font.system(size: 50.0))
                }
                if Double(self.currentProgress) / Double(self.goal) > 1 {
                    Text("Well done!").italic()
                } else if Double(self.currentProgress) / Double(self.goal)  > 0.5 {
                    Text("You're almost there!").italic()
                } else {
                    Text("Keep it up!").italic()
                }

        }
    }
}

class UserSettings: ObservableObject {
    
    @Published var dailyGoal: Int {
        didSet {
            UserDefaults.standard.set(dailyGoal, forKey: "DailyGoal")
        }
    }
    
    public var dailyGoals = [20, 30, 40, 50, 75, 100]
    
    init() {
        self.dailyGoal = UserDefaults.standard.integer(forKey: "DailyGoal")
        if self.dailyGoal == 0 {
            self.dailyGoal = 20
        }
    }
}
