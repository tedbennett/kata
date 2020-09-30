//
//  Review+CoreDataProperties.swift
//  language-learner
//
//  Created by Ted Bennett on 30/09/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var date: Date
    @NSManaged public var numCards: Int16
    @NSManaged public var score: Double
    @NSManaged public var parent: Deck?

}

extension Review : Identifiable {

}
