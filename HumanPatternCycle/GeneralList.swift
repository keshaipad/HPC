//
//  GeneralList.swift
//  HumanPatternCycle
//
//  Created by Admin on 19.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class GeneralList: Object {
 
    dynamic var createdAt = NSDate()
    dynamic var minute = String.sepaDate("minute")
    dynamic var hour = String.sepaDate("hour")
    dynamic var day = String.sepaDate("day")
    dynamic var month = String.sepaDate("month")
    dynamic var year = String.sepaDate("year")
    dynamic var notes = ""
    dynamic var parentMoodList = "" // категория настроения
    dynamic var parentMood = "" // настроение
    dynamic var noname1 = "" // фаза луны
    dynamic var mood = ""
    dynamic var image = "noImage.ico" // изображение
    dynamic var noname4 = ""
    dynamic var noname5 = ""
    dynamic var noname6 = ""
    dynamic var noname7 = ""
    dynamic var noname8 = ""
    dynamic var lat: String = "0" // местность lat
    dynamic var lon: String = "0" // местность lon
    dynamic var temperature : Float = 0 // температура воздуха
    dynamic var pressure : Float = 0
    dynamic var cloudCover : Float = 0
    dynamic var nonameD1 : Double = 0
    dynamic var nonameD2 : Double = 0
    dynamic var nonameD3 : Double = 0
    dynamic var nonameD4 : Double = 0
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}

