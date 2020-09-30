//
//  Card+CoreDataProperties.swift
//  language-learner
//
//  Created by Ted Bennett on 30/09/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var back: String
    @NSManaged public var front: String
    @NSManaged public var id: UUID
    @NSManaged public var learned: Double
    @NSManaged public var lastScore: Bool
    @NSManaged public var parent: Deck?

}

extension Card : Identifiable {

}
