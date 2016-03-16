//
//  NegativeMood.swift
//  HumanPatternCycle
//
//  Created by Admin on 19.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class NegativeMood: Object {
    
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    dynamic var notes = ""
    dynamic var isCompleted = false
    dynamic var image = "noImage.ico"
    dynamic var key: String = "\(Int.random(999, 99999))\(Int.random(500, 8888))"
    
    override static func primaryKey() -> String? {
        return "key"
    }
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
