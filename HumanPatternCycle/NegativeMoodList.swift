//
//  NegativeMoodList.swift
//  HumanPatternCycle
//
//  Created by Admin on 19.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class NegativeMoodList: Object {
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    let tasks = List<NegativeMood>()
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}