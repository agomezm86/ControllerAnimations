//
//  ApplicationsModel.swift
//  ControllerAnimations
//
//  Created by Alejandro Gomez Mutis on 3/16/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import Foundation

/**
 Modelo que representa la respuesta del servicio
*/
class ApplicationsModel: NSObject {
    
    var id: Int?
    var category: String?
    var name: String?
    var summary: String?
    var image: String?
    var amount: String?
    var currency: String?
    var rights: String?
    var releaseDate: String?
    
    /**
     Constructor de la clase
     @param newId id de la aplicación en la tienda
     @param newCategory categoría a la que pertence la app
     @param newName nombre de la app
     @param newSummary descripción de la app
     @param newImage ruta de la imagen de la app
     @param newAmount valor número del costo de la app
     @param newCurrency moneda en la que se maneja la app
     @param newRights derechos de la app
     @param newReleaseDate fecha de lanzamiento
     */
    init(newId: Int?, newCategory: String?, newName: String?, newSummary: String?, newImage: String?, newAmount: String?, newCurrency: String?, newRights: String?, newReleaseDate: String?) {
        id = newId
        category = newCategory
        name = newName
        summary = newSummary
        image = newImage
        amount = newAmount
        currency = newCurrency
        rights = newRights
        releaseDate = newReleaseDate
    }
}
