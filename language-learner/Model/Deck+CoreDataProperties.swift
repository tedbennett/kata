//
//  Deck+CoreDataProperties.swift
//  language-learner
//
//  Created by Ted Bennett on 15/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//
//

import Foundation
import CoreData


extension Deck: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deck> {
        return NSFetchRequest<Deck>(entityName: "Deck")
    }

    @NSManaged public var desc: String?
    @NSManaged public var id: UUID
    @NSManaged public var language: Int16
    @NSManaged public var name: String
    @NSManaged public var cards: NSSet?
    @NSManaged public var reviews: NSSet?
    
    public var cardArray : [Card] {
        let cardSet = cards as? Set<Card> ?? []
        return Array(cardSet)
    }
    
    public var reviewsArray : [Review] {
        let reviewsSet = reviews as? Set<Review> ?? []
        return Array(reviewsSet)
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

// MARK: Generated accessors for reviews
extension Deck {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}
