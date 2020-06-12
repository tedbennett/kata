//
//  HistoryData+CoreDataProperties.swift
//  language-learner
//
//  Created by Ted Bennett on 12/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//
//

import Foundation
import CoreData


extension HistoryData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryData> {
        return NSFetchRequest<HistoryData>(entityName: "HistoryData")
    }

    @NSManaged public var cardsCorrect: Int32
    @NSManaged public var cardsReviewed: Int32
    @NSManaged public var date: Date?
    @NSManaged public var parent: Deck?

}
