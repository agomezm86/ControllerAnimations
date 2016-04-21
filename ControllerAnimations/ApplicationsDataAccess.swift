//
//  ApplicationsDataAccess.swift
//  ControllerAnimations
//
//  Created by Alejandro Gomez Mutis on 3/16/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import Foundation
import CoreData

class ApplicationsDataAccess: CoreDataHelper {
    
    /**
     Instancia del CoreDataHelper
     */
    var coreDataHelper = CoreDataHelper()
    
    /**
     Almacena una nueva aplicación a la base de datos
     */
    func insertApplication(application: ApplicationsModel) {
        let context: NSManagedObjectContext = coreDataHelper.managedObjectContext
        let applications = NSEntityDescription.insertNewObjectForEntityForName(Constants.dataModelEntityApplications, inManagedObjectContext: context) as! Applications
        applications.appId = application.id!
        applications.category = application.category!
        applications.name = application.name!
        applications.summary = application.summary!
        applications.image = application.image!
        applications.amount = application.amount!
        applications.currency = application.currency!
        applications.rights = application.rights!
        applications.releaseDate = application.releaseDate!
        
        coreDataHelper.saveContext()
    }
    
    /**
     Obtiene la lista de aplicaciones almacenadas
     */
    func getApplications() -> NSArray {
        let context: NSManagedObjectContext = coreDataHelper.managedObjectContext
        let entity = NSEntityDescription.entityForName(Constants.dataModelEntityApplications, inManagedObjectContext: context)! as NSEntityDescription
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        var applicationArray = NSArray()
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            applicationArray = results as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return applicationArray
    }
    
    /**
     Obtiene la lista de categorias almacenadas
     */
    func getCategories() -> NSArray {
        let context: NSManagedObjectContext = coreDataHelper.managedObjectContext
        let entity = NSEntityDescription.entityForName(Constants.dataModelEntityApplications, inManagedObjectContext: context)! as NSEntityDescription
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.propertiesToFetch = NSArray(object: entity.propertiesByName[Constants.category]!) as [AnyObject]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = .DictionaryResultType
        
        let sortDescriptor = NSSortDescriptor(key: Constants.category, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var categoriesArray = NSArray()
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            categoriesArray = results as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return categoriesArray
    }
    
    /**
     Obtiene la lista de aplicaciones por categoría
     */
    func getApplicationsByCategory(category: String) -> NSArray {
        let context: NSManagedObjectContext = coreDataHelper.managedObjectContext
        let entity = NSEntityDescription.entityForName(Constants.dataModelEntityApplications, inManagedObjectContext: context)! as NSEntityDescription
        
        let predicate = NSPredicate(format: "category = %@", category)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        
        var applicationArray = NSArray()
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            applicationArray = results as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return applicationArray
    }
    
    /**
     Elimina las aplicaciones almacenadas de la base de datos
     */
    func deleteApplications() {
        let context: NSManagedObjectContext = coreDataHelper.managedObjectContext
        let entity = NSEntityDescription.entityForName(Constants.dataModelEntityApplications, inManagedObjectContext: context)! as NSEntityDescription
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        var applicationsArray = NSArray()
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            applicationsArray = results as NSArray
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        for application in applicationsArray {
            context.deleteObject(application as! NSManagedObject)
        }
        coreDataHelper.saveContext()
    }
}
