//
//  FavoritesItem.swift
//  Rating-VolSU-iOS
//
//  Created by Настя on 30.09.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

import Foundation
import CoreData

class FavoritesItem: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var semestr: NSNumber
    @NSManaged var group: NSManagedObject
    @NSManaged var student: NSManagedObject

}
