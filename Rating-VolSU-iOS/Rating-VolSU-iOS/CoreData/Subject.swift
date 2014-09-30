//
//  Subject.swift
//  Rating-VolSU-iOS
//
//  Created by Настя on 30.09.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

import Foundation
import CoreData

class Subject: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var type: NSNumber
    @NSManaged var ratingItems: NSSet

}
