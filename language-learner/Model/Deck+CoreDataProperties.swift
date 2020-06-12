//
//  Deck+CoreDataProperties.swift
//  language-learner
//
//  Created by Ted Bennett on 12/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//
//

import Foundation
import CoreData


extension Deck : Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deck> {
        return NSFetchRequest<Deck>(entityName: "Deck")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var language: String
    @NSManaged public var desc: String?
    @NSManaged public var author: String?
    @NSManaged public var cards: NSSet?
    @NSManaged public var history: NSSet?
    
    public var cardArray : [Card] {
        let cardSet = cards as? Set<Card> ?? []
        return Array(cardSet)
    }
    
    public var historyArray : [ReviewRecords] {
        let historySet = history as? Set<ReviewRecords> ?? []
        return Array(historySet)
    }

}

// MARK: Generated accessors for cards
extension Deck {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: Card)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: Card)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for history
extension Deck {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: ReviewRecords)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: ReviewRecords)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}
