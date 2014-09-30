//
//  Student.swift
//  Rating-VolSU-iOS
//
//  Created by Настя on 30.09.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

import Foundation
import CoreData

class Student: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var number: String
    @NSManaged var group: Group
    @NSManaged var ratingItems: NSSet
    @NSManaged var favoritesItems: NSSet

}
