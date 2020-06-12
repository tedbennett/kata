//
//  ReviewRecords+CoreDataProperties.swift
//  language-learner
//
//  Created by Ted Bennett on 12/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//
//

import Foundation
import CoreData


extension ReviewRecords {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReviewRecords> {
        return NSFetchRequest<ReviewRecords>(entityName: "ReviewRecords")
    }

    @NSManaged public var date: Date?
    @NSManaged public var parent: Deck?
    @NSManaged public var scores: NSSet?
    
    public var scoresArray : [CardScore] {
        let scoresSet = scores as? Set<CardScore> ?? []
        return Array(scoresSet)
    }

}

// MARK: Generated accessors for scores
extension ReviewRecords {

    @objc(addScoresObject:)
    @NSManaged public func addToScores(_ value: CardScore)

    @objc(removeScoresObject:)
    @NSManaged public func removeFromScores(_ value: CardScore)

    @objc(addScores:)
    @NSManaged public func addToScores(_ values: NSSet)

    @objc(removeScores:)
    @NSManaged public func removeFromScores(_ values: NSSet)

}
