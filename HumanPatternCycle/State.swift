//
//  State.swift
//  HumanPatternCycle
//
//  Created by Admin on 13.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class State: Object {
    
    dynamic var name = ""
    dynamic var useCount = 0
    dynamic var key: String = "\(Int.random(259, 99569))\(Int.random(440, 8568))"
    
    override static func primaryKey() -> String? {
        return "key"
    }
    
}