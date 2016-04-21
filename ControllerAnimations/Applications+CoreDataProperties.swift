//
//  Applications+CoreDataProperties.swift
//  ControllerAnimations
//
//  Created by Alejandro Gomez Mutis on 3/16/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

/**
 Modelo de la tabla Applications de la base de datos
*/
extension Applications {
    @NSManaged var appId: NSNumber?
    @NSManaged var category: String?
    @NSManaged var name: String?
    @NSManaged var summary: String?
    @NSManaged var image: String?
    @NSManaged var amount: String?
    @NSManaged var currency: String?
    @NSManaged var rights: String?
    @NSManaged var releaseDate: String?
}
