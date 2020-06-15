//
//  Card+CoreDataProperties.swift
//  language-learner
//
//  Created by Ted Bennett on 12/06/2020.
//  Copyright © 2020 Ted Bennett. All rights reserved.
//
//

import Foundation
import CoreData


extension Card: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var id: UUID
    @NSManaged public var front: String
    @NSManaged public var back: String

    @NSManaged public var parent: Deck

}
