//
//  MonthStatsView.swift
//  language-learner
//
//  Created by Ted Bennett on 16/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct CalendarStatsView: View {
    var goal = 40.0
    var scores: [ReviewScore]
    var numCardsCalendar = [[Int]]()
    
    init(scores: [ReviewScore]) {
        self.scores = scores
        self.numCardsCalendar = getNumCardsCalendar(scores: scores)
    }
    
    var body: some View {
        VStack {
            ForEach(self.numCardsCalendar, id:\.self) { week in
                HStack {
                    ForEach(week, id: \.self) { numCards in
                        PercentageWheel(percentage: Double(numCards) / self.goal)
                    }
                }
            }
            //Text("hello world")
                
        }
    }
    
    
}

struct MonthStatsView_Previews: PreviewProvider {
    
    static var previews: some View {
        CalendarStatsView(scores:
        [
            ReviewScore(date: Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for:Date()))!, numCards: 7),
            ReviewScore(date: Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for:Date()))!, numCards: 7)
            ]
        )
    }
}


struct ReviewScore {
    var date: Date
    var numCards: Int
}

func getNumCardsCalendar(scores: [ReviewScore]) -> [[Int]] {
    let scoresDict = getCalendarDict(from: scores)
    let thisMonday = Date().startOfWeek
    let threeWeeksAgo =  Calendar.current.date(byAdding: .day, value: -7*3, to: thisMonday!)!
    var numCardsByDayOfWeek = Array(repeating: Array(repeating: 0, count: 7), count: 4)
    for week in 0..<4 {
        let startOfWeek =  Calendar.current.date(byAdding: .day, value: 7 * week, to: threeWeeksAgo)!
        for date in 0..<7 {
            numCardsByDayOfWeek[week][date] = scoresDict[Calendar.current.date(byAdding: .day, value: date, to: startOfWeek)!] ?? 0
            //numCardsByDayOfWeek[week][date] = 5
        }
    }
    return numCardsByDayOfWeek
}

func getCalendarDict(from scores: [ReviewScore]) -> [Date:Int] {
    var scoresDict = [Date:Int]()
    for score in scores {
        if scoresDict[score.date] == nil {
            scoresDict[score.date] = score.numCards
        } else {
            scoresDict[score.date] = score.numCards + scoresDict[score.date]!
        }
    }
    return scoresDict
}


extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
}
