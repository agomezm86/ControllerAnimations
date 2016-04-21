//
//  ServicesManager.swift
//  ControllerAnimations
//
//  Created by Alejandro Gomez Mutis on 3/16/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import Foundation
import UIKit

class ServicesManager: NSObject {
    
    /**
     Bloque de respuesta del servicio
     */
    typealias ServiceManagerResponse = (response: NSDictionary, error: NSString?) -> Void
    
    /**
     Obtiene la información de las aplicaciones
     desde el servicio expuesto
     @param completionHandler bloque de completitud del servicio
     */
    func getApplicationsInformation(completionHandler: ServiceManagerResponse) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let url: NSURL = NSURL(string: Constants.serviceUrl)!
        let request: NSURLRequest = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: Constants.timeoutConnection)
        
        let session: NSURLSession = NSURLSession.sharedSession()
        let dataTaskSession: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if (error != nil) {
                completionHandler(response: [:], error: error?.localizedDescription)
            }
            else {
                do {
                    guard let dat = data else { throw Enumerations.JSONError.NoData }
                    guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary else { throw Enumerations.JSONError.ConversionFailed }
                    completionHandler(response: json, error: error?.localizedDescription)
                } catch let error as Enumerations.JSONError {
                    print(error.rawValue)
                } catch {
                    print(error)
                }
            }
        })
        
        dataTaskSession.resume()
    }
    
    /**
     Descarga las imagenes del servidor
     @param urlsArray arreglo con las urls de descarga de las imagenes
     */
    func downloadApplicationsImages(urlsArray: NSArray) {
        for app in urlsArray {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true

            let application: Applications = app as! Applications
            let image: String = application.image!
            let url: NSURL = NSURL(string: image as String)!
            let request: NSURLRequest = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: Constants.timeoutConnection)
            
            let session: NSURLSession = NSURLSession.sharedSession()
            let downloadTaskSession: NSURLSessionDownloadTask = session.downloadTaskWithRequest(request, completionHandler: {(location, response, error) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                if error == nil {
                    let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                    let documentDirectoryPath:String = path[0]
                    let fileManager = NSFileManager()
                    let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath.stringByAppendingFormat("/%@.png", application.name!))
                    
                    if fileManager.fileExistsAtPath(destinationURLForFile.path!) {
                        do {
                            try fileManager.removeItemAtPath(destinationURLForFile.path!)
                        } catch {
                            print("An error occurred while removing the file")
                        }
                    }
                    
                    do {
                        try fileManager.moveItemAtURL(location!, toURL: destinationURLForFile)
                    } catch {
                        print("An error occurred while moving file to destination url")
                    }
                }
            })
            
            downloadTaskSession.resume()
        }
    }
}
