//
//  AnswerResultView.swift
//  language-learner
//
//  Created by Ted Bennett on 30/09/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct AnswerResultView: View {
    @State private var animate = false
    @State private var alpha = 0.0
    var correctAnswer: Bool
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous).frame(width: 150, height: 150).foregroundColor(correctAnswer ? .green : .red)
                switch correctAnswer {
                    case true:
                        Path {path in
                            path.move(to: CGPoint(x: geometry.size.width/2 - 35, y: geometry.size.height/2))
                            path.addLine(to: CGPoint(x: geometry.size.width/2 - 15, y: geometry.size.height/2 + 25))
                            path.addLine(to: CGPoint(x: geometry.size.width/2 + 35, y: geometry.size.height/2 - 30))
                        }
                        .trim(to: animate ? 1 : 0)
                        .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .foregroundColor(.white)
                    case false:
                        Path {path in
                            path.move(to: CGPoint(x: geometry.size.width/2 - 35, y: geometry.size.height/2 - 35))
                            path.addLine(to: CGPoint(x: geometry.size.width/2 + 35, y: geometry.size.height/2 + 35))
                            path.move(to: CGPoint(x: geometry.size.width/2 + 35, y: geometry.size.height/2 - 35))
                            path.addLine(to: CGPoint(x: geometry.size.width/2 - 35, y: geometry.size.height/2 + 35))
                        }
                        .trim(to: animate ? 1 : 0)
                        .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .foregroundColor(.white)
                }
            }.opacity(alpha)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.2)) {
                    alpha = 1
                }
                withAnimation(Animation.easeInOut(duration: 0.5).delay(0.1)) {
                    animate.toggle()
                }
                withAnimation(Animation.easeInOut(duration: 0.2).delay(0.8)) {
                    alpha = 0
                }
            }
        }
    }
}

struct AnswerResultView_Previews: PreviewProvider {
    @State static private var tick = false
    static var previews: some View {
        Group {
            AnswerResultView(correctAnswer: true)
        }
    }
}
