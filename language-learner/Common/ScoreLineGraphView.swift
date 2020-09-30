//
//  ScoreLineGraphView.swift
//  language-learner
//
//  Created by Ted Bennett on 25/09/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct ScoreLineGraphView: View {
    var reviews: [ReviewScore]
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .foregroundColor(Color(red: 0.90, green: 0.90, blue: 0.90))
                .frame(width: 300, height: 150, alignment: .center)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                Path { path in
                    path.move(to: CGPoint(x: (geometry.size.width / 2) - 130, y: (geometry.size.height / 2) - 50))
                    path.addLine(to: CGPoint(x: (geometry.size.width / 2) - 130, y: (geometry.size.height / 2) + 60))
                    path.addLine(to: CGPoint(x: (geometry.size.width / 2) + 120, y: (geometry.size.height / 2) + 60))
                }.stroke(Color(red: 0.5, green: 0.5, blue: 0.5), lineWidth: 2)
            }
            
            
        }
    }
}

struct ScoreLineGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreLineGraphView(reviews: [])
    }
}

struct ReviewScore {
    var numCards: Int
    var score: Double
    var date: Date
}
