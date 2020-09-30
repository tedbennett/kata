//
//  ScoreCard.swift
//  language-learner
//
//  Created by Ted Bennett on 30/09/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct ScoreCard: View {
    var card: Card
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(card.front).font(.headline)
                Text(card.back).font(.subheadline)
            }
            Spacer()
            if card.lastScore {
                Image(systemName: "checkmark").foregroundColor(.green)
            } else {
                Image(systemName: "xmark").foregroundColor(.red)
            }
        }
    }
}

//struct language_learner_Previews: PreviewProvider {
//    static var previews: some View {
//        language_learner()
//    }
//}
