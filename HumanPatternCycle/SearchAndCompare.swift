//
//  SearchAndCompare.swift
//  HumanPatternCycle
//
//  Created by Admin on 03.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RealmSwift

class SearchAndCompare: UIViewController {
var positiveLists : Results<GeneralList>!
    
    func sameName(mood: String, name: String) {
        
        
        //отфильтруем необходимое имя по настроению и совпадению с самим именем.
        let predicate = NSPredicate(format: "parentMoodList = %@ AND parentMood BEGINSWITH %@", mood, name)
        positiveLists = uiRealm.objects(GeneralList).filter(predicate)
        print("Совпадения \(positiveLists.count)")
        
        
        // Выведем по одному все совпадения
        var countItems = positiveLists.count - 1
        while countItems >= 0 {
        let currentItem = positiveLists[countItems]
            print("Date is \(currentItem.createdAt)")
            --countItems
        }
        
        
    }
    
}
