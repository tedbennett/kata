//
//  CardScore+CoreDataProperties.swift
//  language-learner
//
//  Created by Ted Bennett on 12/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//
//

import Foundation
import CoreData


extension CardScore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardScore> {
        return NSFetchRequest<CardScore>(entityName: "CardScore")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var correct: Bool
    @NSManaged public var parent: ReviewRecords?

}
