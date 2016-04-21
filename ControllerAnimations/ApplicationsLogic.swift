//
//  ApplicationsLogic.swift
//  ControllerAnimations
//
//  Created by Alejandro Gomez Mutis on 3/16/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import Foundation

class ApplicationsLogic: NSObject {
    
    /**
     Bloque de respuesta
     */
    typealias ApplicationsLogicResponse = (error: NSString?) -> Void
    
    var servicesManager: ServicesManager = ServicesManager()
    var applicationsDataAccess: ApplicationsDataAccess = ApplicationsDataAccess()
    
    /**
     Llama a la capa de servicios para invocar el método
     que obtiene la lista de aplicaciones
     @param completionHandler bloque de completitud del servicio
     */
    func getApplicationsInformation(completionHandler: ApplicationsLogicResponse) {
        servicesManager.getApplicationsInformation({(response, error) -> Void in
            if (error != nil) {
                completionHandler(error: error)
            } else {
                
                //Elimina la lista de aplicaciones de la base de datos
                self.applicationsDataAccess.deleteApplications()
                
                let responseDictionary: NSDictionary = NSDictionary(dictionary: response)
                let feedDictionary: NSDictionary = responseDictionary.objectForKey(Constants.feedKey) as! NSDictionary
                let entryArray: NSArray = feedDictionary.objectForKey(Constants.entryKey) as! NSArray
                
                for dictionary in entryArray {
                    // id de la aplicacion
                    let idDictionary = dictionary.objectForKey(Constants.idKey) as! NSDictionary
                    let idAttributesDictionary = idDictionary.objectForKey(Constants.attributesKey) as! NSDictionary
                    let id = idAttributesDictionary.objectForKey(Constants.numberIdKey) as! NSString
                    
                    // categoria de la app
                    let categoryDictionary = dictionary.objectForKey(Constants.categoryKey) as! NSDictionary
                    let categoryAttributesDictionary = categoryDictionary.objectForKey(Constants.attributesKey) as! NSDictionary
                    let category = categoryAttributesDictionary.objectForKey(Constants.labelKey) as! String
                    
                    // nombre de la app
                    let nameDictionary = dictionary.objectForKey(Constants.nameKey) as! NSDictionary
                    let name = nameDictionary.objectForKey(Constants.labelKey) as! String
                    
                    // url de la imagen de la app
                    let imageArray = dictionary.objectForKey(Constants.imageKey) as! NSArray
                    let imageDictionary = imageArray.lastObject as! NSDictionary
                    let image = imageDictionary.objectForKey(Constants.labelKey) as! String
                    
                    // resumen de la app
                    let summaryDictionary = dictionary.objectForKey(Constants.summaryKey) as! NSDictionary
                    let summary = summaryDictionary.objectForKey(Constants.labelKey) as! String
                    
                    // precio de la app
                    let priceDictionary = dictionary.objectForKey(Constants.priceKey) as! NSDictionary
                    let priceAttributesDictionary = priceDictionary.objectForKey(Constants.attributesKey) as! NSDictionary
                    let amount = priceAttributesDictionary.objectForKey(Constants.amountKey) as! String
                    let currency = priceAttributesDictionary.objectForKey(Constants.currencyKey) as! String
                    
                    // derechos de la app
                    let rightsDictionary = dictionary.objectForKey(Constants.rightsKey) as! NSDictionary
                    let rights = rightsDictionary.objectForKey(Constants.labelKey) as! String
                    
                    // fecha de lanzamiento de la app
                    let releaseDictionary = dictionary.objectForKey(Constants.releaseKey) as! NSDictionary
                    let releaseAttributesDictionary = releaseDictionary.objectForKey(Constants.attributesKey) as! NSDictionary
                    let releaseDate = releaseAttributesDictionary.objectForKey(Constants.labelKey) as! String
                    
                    // almacena la nueva app en la base de datos
                    let application = ApplicationsModel(newId: id.integerValue, newCategory: category, newName: name, newSummary: summary, newImage: image, newAmount: amount, newCurrency: currency, newRights: rights, newReleaseDate: releaseDate)
                    self.applicationsDataAccess.insertApplication(application)
                }
                
                // obtiene la lista de apps para descargar su imagen
                self.getApplications()
            }
            completionHandler(error: error)
        })
    }
    
    /**
     Obtiene la lista de aplicaciones de la base de datos
     */
    func getApplications() {
        let applicationsArray: NSArray = applicationsDataAccess.getApplications()
        servicesManager.downloadApplicationsImages(applicationsArray)
    }
    
    /**
     Obtiene la lista de categorias
     @return arreglo con la lista
     */
    func getCategories() -> NSArray {
        return applicationsDataAccess.getCategories()
    }
    
    /**
     Obtiene la lista de aplicaciones por categoria
     @param category categoria
     @return arreglo con la lista
     */
    func getApplicationsByCategory(category: String) -> NSArray {
        return applicationsDataAccess.getApplicationsByCategory(category)
    }
}
