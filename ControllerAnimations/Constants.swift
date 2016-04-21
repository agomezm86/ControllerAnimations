//
//  Constants.swift
//  ControllerAnimations
//
//  Created by Alejandro Gomez Mutis on 3/16/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import Foundation
import UIKit

class Constants: NSObject {
    
    /**
     Servicios
     */
    static var serviceUrl: String = "https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json"
    static var timeoutConnection = 30.0
    
    /**
     JSON deserialize
     */
    static var entryKey = "entry"
    static var feedKey = "feed"
    static var categoryKey = "category"
    static var idKey = "id"
    static var attributesKey = "attributes"
    static var labelKey = "label"
    static var numberIdKey = "im:id"
    static var nameKey = "im:name"
    static var imageKey = "im:image"
    static var summaryKey = "summary"
    static var priceKey = "im:price"
    static var amountKey = "amount"
    static var currencyKey = "currency"
    static var rightsKey = "rights"
    static var releaseKey = "im:releaseDate"
    
    /**
     Core data models
     */
    static var dataModelEntityApplications = "Applications"
    
    /**
     Core data fields
     */
    static var appId = "appId"
    static var category = "category"
    
    /**
     Segues
     */
    static var applicationsListSegueId = "goToApplicationsList"
    static var summarySegueId = "goToSummary"
    
    /**
     Cells
     */
    static var categoryTableCell = "CategoryTableViewCell"
    static var categoryCollectionCell = "CategoryCollectionViewCell"
    static var appsTableCell = "AppsTableViewCell"
    static var appsCollectionCell = "AppsCollectionViewCell"
    static var summaryTableCell = "SummaryTableViewCell"
    
    /**
     Images
     */
    static var educationImage = "education"
    static var gamesImage = "games"
    static var musicImage = "music"
    static var navigationImage = "navigation"
    static var photoImage = "photo"
    static var socialImage = "socialnetwork"
    static var sportsImage = "sports"
    static var travelImage = "travel"
    static var unknownImage = "unknown"
    
    
    /**
     Utils
     */
    static var isIphone: Bool = (UIDevice.currentDevice().userInterfaceIdiom == .Phone)
    
    static func getDocumentsDirectory() -> String {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentDirectoryPath:String = path[0]
        return documentDirectoryPath
    }
}
