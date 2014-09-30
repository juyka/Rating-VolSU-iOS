//
//  RatingItem.swift
//  Rating-VolSU-iOS
//
//  Created by Настя on 30.09.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

import Foundation
import CoreData

class RatingItem: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var secondAttestation: NSNumber
    @NSManaged var firstAttestation: NSNumber
    @NSManaged var thirdAttestation: NSNumber
    @NSManaged var total: NSNumber
    @NSManaged var exam: NSNumber
    @NSManaged var sum: NSNumber
    @NSManaged var semestr: NSNumber
    @NSManaged var student: NSManagedObject
    @NSManaged var subject: NSManagedObject

}
