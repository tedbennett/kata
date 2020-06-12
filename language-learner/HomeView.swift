//
//  HomeView.swift
//  language-learner
//
//  Created by Ted Bennett on 11/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Button(action: {
                print("Button tapped")
            }) {
                Text("Review All")
                    .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 100)
                    .font(.largeTitle)
            }
            Button(action: {
                print("Button tapped")
            }) {
                Text("Review Deck")
                    .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 100)
                    .font(.headline)
                //.border(ShapeStyle())
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct TestView: View {
    
    var body: some View {
        Text("hi")
    }
}
