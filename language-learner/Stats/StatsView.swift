//
//  StatsView.swift
//  language-learner
//
//  Created by Ted Bennett on 11/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    var decks: FetchedResults<Deck>
 
    var body: some View {
        NavigationView {
            VStack {
                DailyGoalProgressView().padding(10)
                CalendarStatsView(scores: self.getReviews(), streak: true).padding(10)
                Spacer()
            }.navigationBarTitle("Stats")
        }
    }
    
    
    func getReviews() -> [Review] {
        var reviews = [Review]()
        decks.forEach({ deck in
            reviews.append(contentsOf: deck.reviewsArray)
        })
        return reviews
    }
    
    func DailyGoalProgressView() -> AnyView {
        var currentProgress = 0
        decks.forEach({deck in
            deck.reviewsArray.forEach( {
                if $0.date == Calendar.current.startOfDay(for:Date()) {
                    currentProgress += Int($0.numCards)
                }
            })
        })
        let fraction = Double(currentProgress) / Double(UserDefaults.standard.integer(forKey: "DailyGoal"))
        return AnyView(
            VStack {
                Text("Today's progress:")
                HStack(alignment: .bottom, spacing: 3) {
                    Text("\(currentProgress)").font(.largeTitle).fontWeight(.bold)
                    Text("/\(UserDefaults.standard.integer(forKey: "DailyGoal"))")
                }
                if fraction > 1 {
                    Text("Well done!")
                } else if fraction > 0.5 {
                    Text("You're almost there!")
                } else {
                    Text("Keep it up!")
                }
            }
        )
        
    }

}

//struct StatsView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        StatsView(decks: FetchedResults<Deck>)
//    }
//}


