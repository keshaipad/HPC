//
//  AddNewRecord.swift
//  HumanPatternCycle
//
//  Created by Admin on 29.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RealmSwift
import AlertBar
import ForecastIO
import CoreLocation
import MapKit
import Foundation
import Darwin

class AddNewRecord: UIViewController {
    var selectedPositiveList : PositiveMoodList!
    var selectedPositiveMood : PositiveMood!
    var selectedNormalList : NormalMoodList!
    var selectedNegativeList : NegativeMoodList!
    var openPositiveTasks : Results<PositiveMood>!
    var openNormalTasks : Results<NormalMood>!
    var openNegativeTasks : Results<NegativeMood>!
    var completedPositiveTasks : Results<PositiveMood>!
    var completedNormalTasks : Results<NormalMood>!
    var completedNegativeTasks : Results<NegativeMood>!
    
    var positiveLists : Results<PositiveMood>!
    var normalLists : Results<NormalMood>!
    var negativeLists : Results<NegativeMood>!
    var stateLists: Results<StateList>!
    
    var keyForAdding: Int = 0

    var link = "http://humancycle.com.swtest.ru/parser.php" // ссылка на парсер фазы луны
    var moonPhase = NSString() // сюда запишем процент фазы луны
    
    let defaults = NSUserDefaults(suiteName: "group.HumanPatternCycle")
    var whatMoodChoose: String = "" // от какой кнопки переход
    
    var myLon: Double = 0 // долгота
    var myLat: Double = 0 // широта
    
    let forecastIOClient = APIClient(apiKey: "0fa076b21210eaf98828db2684c51b48") // Ключ к апи
    var temperature : Float = 0
    
    var isEditingMode = false
    
    var goToWeather = false
    var goToRecordToDataBase = false
    
    var currentCreateAction:UIAlertAction!
    
    var secondController = SecondViewController()
    var containerController: ContainerViewController?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "container")
        {
            containerController = segue.destinationViewController as! ContainerViewController
        }
    }
    
    func DidLoad() {
      
        
        
    }
    
    func readTasks(){
        
        if keyForAdding > 1000 { // Если ключ длинный, значит он с другой базы.
            stateLists = uiRealm.objects(StateList)
        } else {
        
        let curValue = NSUserDefaults.standardUserDefaults().stringForKey("moodBut")
        if curValue == "Good" {
            positiveLists = uiRealm.objects(PositiveMood) // Подгружаем результаты
            print("Good")
        } else if curValue == "Normal" {
            normalLists = uiRealm.objects(NormalMood) // Подгружаем результаты
            print("Normal")
        } else if curValue == "Bad" {
            negativeLists = uiRealm.objects(NegativeMood) // Подгружаем результаты
            print("Bad")
        }

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addRecord (selectItem: Int) { // Запись в базу данных
        
        keyForAdding = selectItem
        //Берем информацию о фазе луны-----------
        
        let currentDate = NSDate()
        let dateNow = NSCalendar.currentCalendar()
        let dateComponents = dateNow.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Nanosecond], fromDate: currentDate)
        // проверим была ли сегодня запись
        
        
        if let currentValue = defaults?.objectForKey("whatDayIsToday"){     // проверим если пусто (первый запуск)
            
        }else{
            defaults?.setObject("", forKey: "whatDayIsToday")
            defaults?.setObject("", forKey: "moonPhase")
        }

        let whatDayIsToday = defaults!.integerForKey("whatDayIsToday")
        
        if whatDayIsToday != dateComponents.day { // если сегодняшняя дата не совпадает с записанной значит запись была НЕ сегодня
            
            print("Не совпало")
            
            let testUrl = NSURL(string: link)
            
            do {
                moonPhase = try NSString(contentsOfURL: testUrl!, encoding: NSISOLatin1StringEncoding)
                
                print ("Лезем в интернет")
            } catch{
                print(error)
                AlertBar.show(.Warning, message: "Can't connect to moon phase", duration: 2)
            }
            // очистим текст от левой информации
          
            let htmlString = String(moonPhase)
            
            let htmlStringData = htmlString.dataUsingEncoding(NSUTF8StringEncoding)!
            
            let options: [String: AnyObject] = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding]
            
            let attributedHTMLString = try! NSAttributedString(data: htmlStringData, options: options, documentAttributes: nil)
            
            let string = attributedHTMLString.string
            moonPhase = string
            print(moonPhase)
            //--------------
            //--------------
           
            defaults?.setObject(moonPhase, forKey: "moonPhase") // запишем сегодняшнюю фазу луны в default
            defaults?.setObject(dateComponents.day, forKey: "whatDayIsToday") // запишем сегодняшнюю дату
        } else { // если дата не сегодняшняя то запишем новые данные
            moonPhase = defaults!.stringForKey("moonPhase")! // возьмем сегодняшнюю уже выбранную фазу
        }
        
        
        //--------------------------------------
        // Возьмем локальные погодные данные и координаты из Defaults
        let cloudCover = defaults!.floatForKey("cloudCover")
        let temperature = defaults!.floatForKey("temperature")
        let pressure = defaults!.floatForKey("pressure")
        //let coordinates = self.defaults!.objectForKey("locationDict") as! [String : NSNumber]
        // -----возьмем последние  координаты
        let longlat = defaults!.objectForKey("locationDict") as! [String : NSNumber]  //вытаскиваем сло
        let userLat = longlat["lat"]
        let userLng = longlat["lng"]
        let coordLat = String(userLat)
        let coordLng = String(userLng)
        print(coordLat)
        
        // ------
        readTasks() // Подгружаем результаты
        
        var whatNameMoodNow = ""
        var whatParrentNameMood = ""
        var imageInSelected = ""
        
        if selectItem > 500 {
          
            whatNameMoodNow = NSUserDefaults.standardUserDefaults().stringForKey("parentMood")!
            
        } else {
        
        
        var whatMoodButtonInDefaults = NSUserDefaults.standardUserDefaults().stringForKey("moodBut")
        if whatMoodButtonInDefaults == "Good" {
            let goodDictionary = positiveLists[selectItem] // Найдем выбранный элемент
            whatNameMoodNow = goodDictionary.name // Выпишем имя
            whatParrentNameMood = "Positive"
            imageInSelected = goodDictionary.image  // Выпишем изображение
        } else if whatMoodButtonInDefaults == "Normal" {
            let normalDictionary = normalLists[selectItem] // Найдем выбранный элемент
            whatNameMoodNow = normalDictionary.name  // Выпишем имя
            whatParrentNameMood = "Normal"
            imageInSelected = normalDictionary.image // Выпишем изображение
        } else if whatMoodButtonInDefaults == "Bad" {
            let badDictionary = negativeLists[selectItem] // Найдем выбранный элемент
            whatNameMoodNow = badDictionary.name  // Выпишем имя
            imageInSelected = badDictionary.image // Выпишем изображение
            whatParrentNameMood = "Negative" }
        
       NSUserDefaults.standardUserDefaults().setObject(whatNameMoodNow, forKey: "parentMood")
        NSUserDefaults.standardUserDefaults().setObject(whatParrentNameMood, forKey: "parentMoodList")
        }
        
        let newRecord = GeneralList()
        newRecord.parentMoodList = whatParrentNameMood
        newRecord.parentMood = whatNameMoodNow
        newRecord.cloudCover = cloudCover
        newRecord.temperature = temperature
        newRecord.pressure = pressure
        newRecord.noname1 = moonPhase as String
        newRecord.lat = coordLat
        newRecord.lon = coordLng
        newRecord.image = imageInSelected
        try! uiRealm.write({ () -> Void in
            uiRealm.add(newRecord)
            
        })
         if selectItem > 500 {
            speetchGreatAlert(whatNameMoodNow)
         } else {
            greatAlert()
        }
        
     NSNotificationCenter.defaultCenter().postNotificationName("FirstScreen", object: nil) // Вызываем календарь
       // NSNotificationCenter.defaultCenter().postNotificationName("footerMood", object: nil) // Вызываем футер
    }
    
    func greatAlert() {
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        alertView.showSuccess("Great!", subTitle: "Successfully added to database!", closeButtonTitle: "closebuttonTitle", duration: 1, colorStyle: 0x22B573, colorTextButton: 0xFFFFFF)
    }
    
    func speetchGreatAlert(nameOfMood: String) {
        
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        alertView.addButton("No! Cancel!", target:self, selector:Selector("cancelLastAdding"))
        alertView.showSuccess(nameOfMood, subTitle: "Successfully added to database!", closeButtonTitle: "No! Cancel!", duration: 3, colorStyle: 0x22B573, colorTextButton: 0xFFFFFF)
    }
    
    //------------------------
    //------------------------------
    
    
    
    func delatedAlert() {
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        alertView.showSuccess("Okay", subTitle: "Successfully delete last record", closeButtonTitle: "closebuttonTitle", duration: 1, colorStyle: 0x22B573, colorTextButton: 0xFFFFFF)
    }
    
    func cancelLastAdding() {
        let lastRealmRecord = uiRealm.objects(GeneralList).last!
        try! uiRealm.write {
            uiRealm.delete(lastRealmRecord)
        }
        delatedAlert()
    }
    
    func addNewItem() {
        displayAlertToAddPositiveList(nil)
    }
    
    func displayAlertToAddPositiveList(updatedList:PositiveMood!){
        
        var title = "New Mood Group"
        var doneTitle = "Create"
        if updatedList != nil{
            title = "Update Mood Group"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your mood group.", preferredStyle: UIAlertControllerStyle.Alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let listName = alertController.textFields?.first?.text
            
            if updatedList != nil{
                // update mode
                try!uiRealm.write({ () -> Void in
                    updatedList.name = listName!
                  //  self.readTasksAndUpdateUI()
                })
            }
            else{
                
                let newTaskList = PositiveMoodList()
                newTaskList.name = listName!
                
                try!uiRealm.write({ () -> Void in
                    
                    uiRealm.add(newTaskList)
                  //  self.readTasksAndUpdateUI()
                })
            }
            
            
            
            print(listName)
        }
        
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Mood name"
            textField.addTarget(self, action: "listNameFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            if updatedList != nil{
                textField.text = updatedList.name
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // --------------------------

    func addNewItemToCurrentMood(nameOfMood: String) {
        
        let whatMoodButtonInDefaults = NSUserDefaults.standardUserDefaults().stringForKey("moodBut")
        
        if whatMoodButtonInDefaults == "Good" {
            let newTaskList = PositiveMood()
            newTaskList.name = nameOfMood
            
            try!uiRealm.write({ () -> Void in
                
                uiRealm.add(newTaskList)
                //  self.readTasksAndUpdateUI()
            })
            
        } else if whatMoodButtonInDefaults == "Normal" {
            let newTaskList = NormalMood()
            newTaskList.name = nameOfMood
            
            try!uiRealm.write({ () -> Void in
                
                uiRealm.add(newTaskList)
                //  self.readTasksAndUpdateUI()
            })
        } else if whatMoodButtonInDefaults == "Bad" {
            let newTaskList = NegativeMood()
            newTaskList.name = nameOfMood
            
            try!uiRealm.write({ () -> Void in
                
                uiRealm.add(newTaskList)
                //  self.readTasksAndUpdateUI()
            })
        }

            print("Added \(nameOfMood)")
            
            
        }
    
    func firstStart() { // Первый запуск, уставновим стандартный набор настроений
        
        let positiveMoods: Dictionary = ["Радость":"emoG.jpg","Собранность":"emoG.jpg","Блаженство":"emoG.jpg","Умиротворение":"emoG.jpg","Возбуждение":"emoG.jpg"]
        let normalMoods: Dictionary = ["Безразличие":"emoG.jpg","Спокойствие":"emoG.jpg","Неуверенность":"emoG.jpg"]
        let negativeMoods: Dictionary = ["Волнение":"emoG.jpg","Грусть":"emoG.jpg","Злость":"emoG.jpg","Подавленность":"emoG.jpg","Рассеянность":"emoG.jpg","Тревога":"emoG.jpg","Апатия":"emoG.jpg"]
        
        var posCount = positiveMoods.count - 1
        var normCount = normalMoods.count - 1
        var negCount = negativeMoods.count - 1
        
        let positiName = Array(positiveMoods.keys)
        let positiImage = Array(positiveMoods.values)
        let normalName = Array(normalMoods.keys)
        let normalImage = Array(normalMoods.values)
        let negatiName = Array(negativeMoods.keys)
        let negatiImage = Array(negativeMoods.values)
        
        while posCount >= 0 {
// Запись в настроения
            let newTaskList = PositiveMood()
            newTaskList.name = positiName[posCount]
            newTaskList.image = positiImage[posCount]
            try!uiRealm.write({ () -> Void in
                uiRealm.add(newTaskList)      })
// Запись в состояния
            let newState = State()
            newState.name = positiName[posCount]
            newState.useCount = 1
            try!uiRealm.write({ () -> Void in
                uiRealm.add(newState)      })
            
            --posCount
        }
        
        while normCount >= 0 {
// Запись в настроения
            let newTaskList = NormalMood()
            newTaskList.name = normalName[normCount]
            newTaskList.image = normalImage[normCount]
            try!uiRealm.write({ () -> Void in
                uiRealm.add(newTaskList)      })
// Запись в состояния
            let newState = State()
            newState.name = normalName[normCount]
            newState.useCount = 1
            try!uiRealm.write({ () -> Void in
                uiRealm.add(newState)      })
            
            --normCount
        }
        
        while negCount >= 0 {
// Запись в настроения
            let newTaskList = NegativeMood()
            newTaskList.name = negatiName[negCount]
            newTaskList.image = negatiImage[negCount]
            try!uiRealm.write({ () -> Void in
                uiRealm.add(newTaskList)      })
// Запись в состояния
            let newState = State()
            newState.name = negatiName[negCount]
            try!uiRealm.write({ () -> Void in
                uiRealm.add(newState)
                if negCount == 1 {
                    NSNotificationCenter.defaultCenter().postNotificationName("makingFirstTags", object: nil) // Вызываем загрузку тегов
                }
            })
            
            --negCount
        }
        
        
        
    }
    
    
    func addStateToDataBase(nameNewState: String) {
        
        // Запись в состояния
        let newState = State()
        newState.name = nameStateInDB
        try!uiRealm.write({ () -> Void in
            uiRealm.add(newState)
            
        })
        
    }
    
    func addTestRandomData() {
        
        var count = 10
        // Запишем позитив
        while count > 0 {
        let mood = ["Собранность", "Блаженство", "Умиротворение", "Возбуждение"]
        let randomIndex = Int.random(0, mood.count-1)  // Генерируем рандомное число из количества слов выше
        print(mood[randomIndex])
        let date = NSDate.randomWithinDaysBeforeToday(60) // Генерируем дату
        let temperature = Float.random(1.2, 30.5)
        let pressure = Float.random(1000.1, 1020.5)
        let cloudCover = Float.random(0.1, 1)
        print("1")
        let genList = GeneralList()
        genList.parentMoodList = "Positive"
            print("2")
        genList.parentMood = mood[randomIndex]
            print("3")
        genList.createdAt = date
        genList.temperature = temperature
        genList.pressure = pressure
        genList.cloudCover = cloudCover
            print("4")
        try!uiRealm.write({ () -> Void in
            uiRealm.add(genList)
        })
        --count
        }
        
        count = 10
        
        // Запишем нормальное
        while count > 0 {
            let mood = ["Спокойствие", "Неуверенность", "Безразличие"]
            let randomIndex = Int.random(0, mood.count-1)  // Генерируем рандомное число из количества слов выше
            print(mood[randomIndex])
            let date = NSDate.randomWithinDaysBeforeToday(60) // Генерируем дату
            let temperature = Float.random(1.2, 30.5)
            let pressure = Float.random(1000.1, 1020.5)
            let cloudCover = Float.random(0.1, 1)
            
            let genList = GeneralList()
            genList.parentMoodList = "Normal"
            genList.parentMood = mood[randomIndex]
            genList.createdAt = date
            genList.temperature = temperature
            genList.pressure = pressure
            genList.cloudCover = cloudCover
            
            try!uiRealm.write({ () -> Void in
                uiRealm.add(genList)
            })
            --count
        }
        
        count = 10
        
        // Запишем негативное
        while count > 0 {
            let mood = ["Волнение", "Грусть", "Злость", "Апатия", "Подавленность"]
            let randomIndex = Int.random(0, mood.count-1)  // Генерируем рандомное число из количества слов выше
            print(mood[randomIndex])
            let date = NSDate.randomWithinDaysBeforeToday(60) // Генерируем дату
            let temperature = Float.random(1.2, 30.5)
            let pressure = Float.random(1000.1, 1020.5)
            let cloudCover = Float.random(0.1, 1)
            
            let genList = GeneralList()
            genList.parentMoodList = "Negative"
            genList.parentMood = mood[randomIndex]
            genList.createdAt = date
            genList.temperature = temperature
            genList.pressure = pressure
            genList.cloudCover = cloudCover
            
            try!uiRealm.write({ () -> Void in
                uiRealm.add(genList)
            })
            --count
        }

        
    }
    
    func addTestDataToGeneralList() {
        
            let genList = GeneralList()
            genList.parentMoodList = "Positive"
            genList.parentMood = "Scary"
            
            try!uiRealm.write({ () -> Void in
                uiRealm.add(genList)
            })
        
        let genList2 = GeneralList()
        genList2.parentMoodList = "Positive"
        genList2.parentMood = "Scary"
        
        try!uiRealm.write({ () -> Void in
            uiRealm.add(genList2)
        })

        
        let genList3 = GeneralList()
        genList3.parentMoodList = "Positive"
        genList3.parentMood = "Happy"
        
        try!uiRealm.write({ () -> Void in
            uiRealm.add(genList3)
        })

        
        let genList4 = GeneralList()
        genList4.parentMoodList = "Positive"
        genList4.parentMood = "Scary"
        
        try!uiRealm.write({ () -> Void in
            uiRealm.add(genList4)
        })

        let genList5 = GeneralList()
        genList5.parentMoodList = "Positive"
        genList5.parentMood = "Happy"
        
        try!uiRealm.write({ () -> Void in
            uiRealm.add(genList5)
        })
        
        
    }
    
            }



