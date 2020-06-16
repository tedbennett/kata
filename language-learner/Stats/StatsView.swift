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
                CalendarStatsView(scores: self.getReviews(), streak: true)
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

}

//struct StatsView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        StatsView(decks: FetchedResults<Deck>)
//    }
//}
