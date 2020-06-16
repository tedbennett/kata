//
//  CalendarStatsView.swift
//  language-learner
//
//  Created by Ted Bennett on 16/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct CalendarStatsView: View {
    var scores: [Review]

    var numCardsCalendar = [[Int]]()
    var weekDays = ["M", "T", "W", "T", "F", "S", "S"]
    
    init(scores: [Review], streak: Bool = false) {
        self.scores = scores
        self.numCardsCalendar = getNumCardsCalendar(scores: scores)
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day).foregroundColor(.gray)
                            .frame(width: 20, height: 20)
                            .padding(5)
                            .padding(.bottom, 0)
                }
            }
            ForEach(self.numCardsCalendar, id:\.self) { week in
                HStack {
                    ForEach(week, id: \.self) { numCards in
                        PercentageWheelView(percentage: Double(numCards) / Double(UserDefaults.standard.integer(forKey: "DailyGoal")), lineWidth: 5)
                            .frame(width: 20, height: 20)
                        .padding(5)
                    }
                }
            }
        }
    }
}

struct MonthStatsView_Previews: PreviewProvider {
    
    static var previews: some View {
        CalendarStatsView(scores: []
//        [
//            Re(date: Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for:Date()))!, numCards: 7),
//            ReviewScore(date: Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for:Date()))!, numCards: 7)
//            ]
        )
    }
}


struct ReviewScore {
    var date: Date
    var numCards: Int
}

func getNumCardsCalendar(scores: [Review]) -> [[Int]] {
    let scoresDict = getCalendarDict(from: scores)
    let thisMonday = Date().startOfWeek
    let threeWeeksAgo =  Calendar.current.date(byAdding: .day, value: -7*3, to: thisMonday!)!
    var numCardsByDayOfWeek = Array(repeating: Array(repeating: 0, count: 7), count: 4)
    for week in 0..<4 {
        let startOfWeek =  Calendar.current.date(byAdding: .day, value: 7 * week, to: threeWeeksAgo)!
        for date in 0..<7 {
            numCardsByDayOfWeek[week][date] = scoresDict[Calendar.current.date(byAdding: .day, value: date, to: startOfWeek)!] ?? 0
        }
    }
    return numCardsByDayOfWeek
}

func getCalendarDict(from scores: [Review]) -> [Date:Int] {
    var scoresDict = [Date:Int]()
    for score in scores {
        if scoresDict[score.date] == nil {
            scoresDict[score.date] = Int(score.numCards)
        } else {
            scoresDict[score.date] = Int(score.numCards) + scoresDict[score.date]!
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
