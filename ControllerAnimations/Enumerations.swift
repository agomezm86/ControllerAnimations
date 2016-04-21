//
//  Enumerations.swift
//  ControllerAnimations
//
//  Created by Alejandro Gomez Mutis on 3/16/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import Foundation

class Enumerations: NSObject {
    
    /**
     Errores JSON deserialize
     */
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    /**
     Lista de categorias
     */
    enum Categories: String {
        case Education = "Education"
        case Games = "Games"
        case Music = "Music"
        case Navigation = "Navigation"
        case PhotoVideo = "Photo & Video"
        case Social = "Social Networking"
        case Sports = "Sports"
        case Travel
    }

}