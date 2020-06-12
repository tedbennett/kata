//
//  FinishReviewView.swift
//  language-learner
//
//  Created by Ted Bennett on 12/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//

import SwiftUI

struct FinishReviewView: View {
    @ObservedObject var deck: Deck
    
    var body: some View {
        Text("\(deck.historyArray.count)")
        
    }
}

//struct FinishReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        FinishReviewView()
//    }
//}
