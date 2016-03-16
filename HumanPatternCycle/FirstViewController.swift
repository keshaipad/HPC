//
//  FirstViewController.swift
//  HumanPatternCycle
//
//  Created by Admin on 27.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    
    
    var positiveLists : Results<GeneralList>!
    @IBOutlet weak var calendar: FSCalendar!
    let datesWithCat = ["20150505","20150605"]
    var parentMood: String = ""
    var parentMoodList: String = ""
    var withoutMoodParent: String = ""
    var dates = [NSDate]()
    var datesCount = 0
    var dateR: NSDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        withoutMoodParent = NSUserDefaults.standardUserDefaults().stringForKey("withoutMoodParent")!
        
        if withoutMoodParent == "Yes" {
            
            parentMood = NSUserDefaults.standardUserDefaults().stringForKey("parentMood")! // Берем переданную эмоцию из истории записей
            parentMoodList = ""
            NSUserDefaults.standardUserDefaults().setObject("No", forKey: "withoutMoodParent")
        } else {
        
        parentMood = NSUserDefaults.standardUserDefaults().stringForKey("parentMood")! // Берем переданную эмоцию из истории записей
        parentMoodList = NSUserDefaults.standardUserDefaults().stringForKey("parentMoodList")! // Берем переданную эмоцию из истории записей
            }
        
        calendar.appearance.cellStyle = .Rectangle
        calendar.scrollDirection = .Vertical
        calendar.allowsMultipleSelection = true // множественное выделение - да
        calendar.appearance.selectionColor = UIColor.orangeColor() // установим оранжевый цвет для выделенных частей
        
        filterDatabaseMoods(parentMood, parentMoodListX: parentMoodList) // Отфильтруем базу данных и покажем какие даты совпали с добавленным событием
        
        
    }
   // func calendar(calendar: FSCalendar!, numberOfEventsForDate date: NSDate!) -> Int {
   //         }
    func filterDatabaseMoods(parentMoodX: String, parentMoodListX: String) {
        
        
        //отфильтруем необходимое имя по настроению и совпадению с самим именем.
        let predicate = NSPredicate(format: "parentMoodList = %@ AND parentMood BEGINSWITH %@", parentMoodListX, parentMoodX)
        positiveLists = uiRealm.objects(GeneralList).filter(predicate)
        print("Совпадения \(positiveLists.count)")
        
        
        // Выведем по одному все совпадения и добавим в библиотеку даты
        var countItems = positiveLists.count - 1
        while countItems >= 0 {
            let currentItem = positiveLists[countItems]
            print("Date is \(currentItem.createdAt)")
            dates.insert(currentItem.createdAt, atIndex: datesCount) //Добавление данных в массив
            
            
            let calendarSep = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)! // Делаем формат года 2016
            let components = calendarSep.components([.Day, .Month, .Year], fromDate: currentItem.createdAt) // устанавливаем дату выбранную в массиве
            dateR = currentItem.createdAt
            
            calendar.selectDate(calendar.dateWithYear(components.year, month: components.month, day: components.day))  // отметим совпавшие даты
            
            print(components.year)
            print(components.day)
            ++datesCount
            --countItems
        }
        
        
    }
    
   // func calendar(calendar: FSCalendar!, imageForDate date: NSDate!) -> UIImage! {
   //     return UIImage(named: "1N.jpg")
  //  }
    
    func calendar(calendar: FSCalendar!, subtitleForDate date: NSDate!) -> String! {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let day = components.day

        if (day == 8 )
        {
            return "JIZA1"}
        else if ( day == 10 )
        {return "JIZA2"}
        else if (day == 13)
        {return "JIZA3"}
        
        return nil

    }
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        NSLog("calendar did select date \(calendar.stringFromDate(date))")
            }
    func calendar(calendar: FSCalendar!, didDeselectDate date: NSDate!) {
        NSLog("calendar did select date \(calendar.stringFromDate(date))")
        NSUserDefaults.standardUserDefaults().setObject(date, forKey:"selectDate") //Запишем дату, для передачи в таймлайн
        NSNotificationCenter.defaultCenter().postNotificationName("popUpStart", object: nil, userInfo: ["progress":"376373734734734735737","345345345":"345345345"]) // Вызываем всплывающее окно
        calendar.selectDate(date)
    }
    
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
