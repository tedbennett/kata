//
//  PercentageWheelView.swift
//  language-learner
//
//  Created by Ted Bennett on 16/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct PercentageWheelView: View {
    var percentage: Double
    var lineWidth: CGFloat
    @State var endAngle = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray, lineWidth: lineWidth)
                .opacity(0.2)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.endAngle, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(getWheelColour())
                .rotationEffect(Angle(degrees: 270.0))
                .onAppear {
                    let baseAnimation = Animation.easeOut(duration: 1.2)
                    
                    return withAnimation(baseAnimation) {
                        self.endAngle = self.percentage
                    }
            }
        }
    }
    
    func getWheelColour() -> Color {
        switch self.percentage {
            case let x where x > 0.8: return Color.green
            case let x where x >= 0.5: return Color.yellow
            case let x where x < 0.5: return Color.red
            default: return Color.red
        }
    }
}


//struct PercentageWheelView_Previews: PreviewProvider {
//    static var previews: some View {
//        PercentageWheelView()
//    }
//}
