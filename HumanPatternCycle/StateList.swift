//
//  StateList.swift
//  HumanPatternCycle
//
//  Created by Admin on 13.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class StateList: Object {
    
    dynamic var createdAt = NSDate()
    dynamic var minute = String.sepaDate("minute")
    dynamic var hour = String.sepaDate("hour")
    dynamic var day = String.sepaDate("day")
    dynamic var month = String.sepaDate("month")
    dynamic var year = String.sepaDate("year")
    dynamic var name = ""
    dynamic var key: String = "\(Int.random(259, 99569))\(Int.random(440, 8568))"
    
    override static func primaryKey() -> String? {
        return "key"
    }
    
}
