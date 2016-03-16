//
//  TasksViewController.swift
//  HumanPatternCycle
//
//  Created by Admin on 19.02.16.
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

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    var link = "http://humancycle.com.swtest.ru/parser.php" // ссылка на парсер фазы луны
    var moonPhase = NSString() // сюда запишем процент фазы луны

    var currentCreateAction:UIAlertAction!
    let defaults = NSUserDefaults(suiteName: "group.HumanPatternCycle")
    var whatMoodChoose: String = "" // от какой кнопки переход

    var myLon: Double = 0 // долгота
    var myLat: Double = 0 // широта
    let forecastIOClient = APIClient(apiKey: "0fa076b21210eaf98828db2684c51b48") // Ключ к апи
    var temperature : Float = 0
    
    var isEditingMode = false
    
    var goToWeather = false
    var goToRecordToDataBase = false
    
    @IBOutlet weak var tasksTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        whatMoodChoose = defaults!.stringForKey("whatMoodChoose")!
        switch whatMoodChoose {
            case "Positive":
            self.title = selectedPositiveList.name
        case "Normal":
            self.title = selectedNormalList.name
        case "Negative":
            self.title = selectedNegativeList.name
        default: break
        }
        readTasksAndUpateUI()

    }
    
    
    // MARK: - User Actions -
    
    @IBAction func didClickOnEditTasks(sender: AnyObject) {
        isEditingMode = !isEditingMode
        self.tasksTableView.setEditing(isEditingMode, animated: true)
    }
    @IBAction func didClickOnNewTask(sender: AnyObject) {
        switch whatMoodChoose {
        case "Positive":
        self.displayAlertToAddPositiveTask(nil)
        case "Normal":
self.displayAlertToAddNormalTask(nil)
        case "Negative":
self.displayAlertToAddNegativeTask(nil)
        default: break
    }
    
    }
    func readTasksAndUpateUI(){
        switch whatMoodChoose {
        case "Positive":
            completedPositiveTasks = self.selectedPositiveList.tasks.filter("isCompleted = true")
            openPositiveTasks = self.selectedPositiveList.tasks.filter("isCompleted = false")
        case "Normal":
            completedNormalTasks = self.selectedNormalList.tasks.filter("isCompleted = true")
            openNormalTasks = self.selectedNormalList.tasks.filter("isCompleted = false")
        case "Negative":
            completedNegativeTasks = self.selectedNegativeList.tasks.filter("isCompleted = true")
            openNegativeTasks = self.selectedNegativeList.tasks.filter("isCompleted = false")
        default: break
        }

        
        self.tasksTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableViewDataSource -
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        switch whatMoodChoose {
        case "Positive":
            if section == 0{
                return openPositiveTasks.count
            }
            return completedPositiveTasks.count
        case "Normal":
            if section == 0{
                return openNormalTasks.count
            }
            return completedNormalTasks.count
        case "Negative":
            if section == 0{
                return openNegativeTasks.count
            }
            return completedNegativeTasks.count
        default: break
        }
return completedNegativeTasks.count
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Берем информацию о фазе луны-----------
        
        let currentDate = NSDate()
        let dateNow = NSCalendar.currentCalendar()
        let dateComponents = dateNow.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Nanosecond], fromDate: currentDate)
            // проверим была ли сегодня запись
        

        if let currentValue = defaults?.objectForKey("whatDayIsToday"){// проверим если пусто (первый запуск)
        
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
        // ЗАПИШЕМ В БАЗУ ДАННЫХ
        let currentRow = tableView.cellForRowAtIndexPath(indexPath) // узнаем имя выдбранной строки
        let curRow = currentRow!.textLabel!.text
        switch whatMoodChoose { // запишем все данные в БД
        case "Positive":
            
            let newRecord = GeneralList()
            newRecord.parentMoodList = selectedPositiveList.name
            newRecord.noname1 = moonPhase as String
            newRecord.cloudCover = cloudCover
            newRecord.temperature = temperature
            newRecord.pressure = pressure
            newRecord.parentMood = "Positive"
            newRecord.mood = curRow!
            newRecord.lat = coordLat
            newRecord.lon = coordLng
            try! uiRealm.write({ () -> Void in
                uiRealm.add(newRecord)
                self.readTasksAndUpateUI()
                AlertBar.show(.Success, message: "Successfully added to database!")
            })
            print("Added!")
        case "Normal":
            let newRecord = GeneralList()
            newRecord.parentMoodList = selectedNormalList.name
            newRecord.noname1 = moonPhase as String
            newRecord.cloudCover = cloudCover
            newRecord.temperature = temperature
            newRecord.pressure = pressure
            newRecord.parentMood = "Normal"
            newRecord.mood = curRow!
            newRecord.lat = coordLat
            newRecord.lon = coordLng
            try! uiRealm.write({ () -> Void in
                uiRealm.add(newRecord)
                self.readTasksAndUpateUI()
                AlertBar.show(.Success, message: "Successfully added to database!")
            })
        case "Negative":
            let newRecord = GeneralList()
            newRecord.parentMoodList = selectedNegativeList.name
            newRecord.cloudCover = cloudCover
            newRecord.temperature = temperature
            newRecord.pressure = pressure
            newRecord.parentMood = "Negative"
            newRecord.mood = curRow!
            newRecord.lat = coordLat
            newRecord.lon = coordLng
            try! uiRealm.write({ () -> Void in
                uiRealm.add(newRecord)
                self.readTasksAndUpateUI()
                AlertBar.show(.Success, message: "Successfully added to database!")
            })
        default: break
        }
        
        // через две секунды закрываем окно -----------------
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            let presentingViewController: UIViewController! = self.presentingViewController
            
            self.dismissViewControllerAnimated(true) {
                // go back to MainMenuView as the eyes of the user
                presentingViewController.dismissViewControllerAnimated(false, completion: nil)
            }
        }
        //-------------------
        
        //------------------------------------------------


    }
    
    func recordToDataBase() {
    }
    
    func getCurrentWeather() {
        forecastIOClient.units = .SI
        forecastIOClient.getForecast(latitude: myLat, longitude: myLon) { (currentForecast, error) -> Void in
            if let currentForecast = currentForecast {
                print(currentForecast.currently?.temperature) // тут делаем что то с информацией
                var tempTemperature = currentForecast.currently?.temperature
                self.temperature = tempTemperature!
                print(self.temperature)
            } else if let error = error {
                print("weather error") //  Если ошибка
                }
        }
        while temperature == 0 {
            // задержка 1 секунда до выполнения-----------------
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                print("whait temperature 1 sec")
            }
            //------------------------
        }
        if goToRecordToDataBase == true {
        recordToDataBase()
            print("recordToDataBase")
            goToRecordToDataBase = false
        }
    }
    func clearVariable() {
        
    }
    func getCurrentLocation() {
    
        let longitude = self.defaults!.doubleForKey("longitude")//проверка
        let latitude = self.defaults!.doubleForKey("latitude")//проверка
        myLon = longitude
        myLat = latitude

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        switch whatMoodChoose {
        case "Positive":
            var task: PositiveMood!
            if indexPath.section == 0{
                task = openPositiveTasks[indexPath.row]
            }
            else{
                task = completedPositiveTasks[indexPath.row]
            }
            
            cell?.textLabel?.text = task.name
            return cell!
        case "Normal":
            var task: NormalMood!
            if indexPath.section == 0{
                task = openNormalTasks[indexPath.row]
            }
            else{
                task = completedNormalTasks[indexPath.row]
            }
            
            cell?.textLabel?.text = task.name
            return cell!
        case "Negative":
            var task: NegativeMood!
            if indexPath.section == 0{
                task = openNegativeTasks[indexPath.row]
            }
            else{
                task = completedNegativeTasks[indexPath.row]
            }
            
            cell?.textLabel?.text = task.name
            return cell!
        default: break
        }
        
return cell!
    }
    
//****************
//**************
//******************************
//************************
    func displayAlertToAddPositiveTask(updatedTask:PositiveMood!){
        
        var title = "The name of Sensations"
        var doneTitle = "Create"
        if updatedTask != nil{
            title = "Update Sensations"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your sensations.", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let taskName = alertController.textFields?.first?.text
            
            if updatedTask != nil{
                // update mode
                try!uiRealm.write({ () -> Void in
                    updatedTask.name = taskName!
                    self.readTasksAndUpateUI()
                })
            }
            else{
                
                let newTask = PositiveMood()
                newTask.name = taskName!
                
                try!uiRealm.write({ () -> Void in
                    
                    self.selectedPositiveList.tasks.append(newTask)
                    self.readTasksAndUpateUI()
                })
            }
            
            
            
            print(taskName)
        }
        
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Sensation Name"
            textField.addTarget(self, action: "taskNameFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            if updatedTask != nil{
                textField.text = updatedTask.name
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //***********
    
    func displayAlertToAddNormalTask(updatedTask:NormalMood!){
        
        var title = "The name of Sensations"
        var doneTitle = "Create"
        if updatedTask != nil{
            title = "Update Sensation"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your Sensation.", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let taskName = alertController.textFields?.first?.text
            
            if updatedTask != nil{
                // update mode
                try!uiRealm.write({ () -> Void in
                    updatedTask.name = taskName!
                    self.readTasksAndUpateUI()
                })
            }
            else{
                
                let newTask = NormalMood()
                newTask.name = taskName!
                
                try!uiRealm.write({ () -> Void in
                    
                    self.selectedNormalList.tasks.append(newTask)
                    self.readTasksAndUpateUI()
                })
            }
            
            
            
            print(taskName)
        }
        
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Sensation Name"
            textField.addTarget(self, action: "taskNameFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            if updatedTask != nil{
                textField.text = updatedTask.name
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //******************
    
    func displayAlertToAddNegativeTask(updatedTask:NegativeMood!){
        
        var title = "The name of Sensations"
        var doneTitle = "Create"
        if updatedTask != nil{
            title = "Update Sensation"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your Sensation.", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let taskName = alertController.textFields?.first?.text
            
            if updatedTask != nil{
                // update mode
                try!uiRealm.write({ () -> Void in
                    updatedTask.name = taskName!
                    self.readTasksAndUpateUI()
                })
            }
            else{
                
                let newTask = NegativeMood()
                newTask.name = taskName!
                
                try!uiRealm.write({ () -> Void in
                    
                    self.selectedNegativeList.tasks.append(newTask)
                    self.readTasksAndUpateUI()
                })
            }
            
            
            
            print(taskName)
        }
        
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Sensation Name"
            textField.addTarget(self, action: "taskNameFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            if updatedTask != nil{
                textField.text = updatedTask.name
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
//************************
//***********************
//**************************
//*****************************
    
    //Enable the create action of the alert only if textfield text is not empty
    func taskNameFieldDidChange(textField:UITextField){
        self.currentCreateAction.enabled = textField.text?.characters.count > 0
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        switch whatMoodChoose {
        case "Positive":
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
                
                //Deletion will go here
                
                var taskToBeDeleted: PositiveMood!
                if indexPath.section == 0{
                    taskToBeDeleted = self.openPositiveTasks[indexPath.row]
                }
                else{
                    taskToBeDeleted = self.completedPositiveTasks[indexPath.row]
                }
                
                try!uiRealm.write({ () -> Void in
                    uiRealm.delete(taskToBeDeleted)
                    self.readTasksAndUpateUI()
                })
            }
            let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
                // Editing will go here
                var taskToBeUpdated: PositiveMood!
                if indexPath.section == 0{
                    taskToBeUpdated = self.openPositiveTasks[indexPath.row]
                }
                else{
                    taskToBeUpdated = self.completedPositiveTasks[indexPath.row]
                }
                
                self.displayAlertToAddPositiveTask(taskToBeUpdated)
                
            }
            
            let doneAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Done") { (doneAction, indexPath) -> Void in
                // Editing will go here
                var taskToBeUpdated: PositiveMood!
                if indexPath.section == 0{
                    taskToBeUpdated = self.openPositiveTasks[indexPath.row]
                }
                else{
                    taskToBeUpdated = self.completedPositiveTasks[indexPath.row]
                }
                try!uiRealm.write({ () -> Void in
                    taskToBeUpdated.isCompleted = true
                    self.readTasksAndUpateUI()
                })
                
            }
            return [deleteAction, editAction, doneAction]
        case "Normal":
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
                
                //Deletion will go here
                
                var taskToBeDeleted: NormalMood!
                if indexPath.section == 0{
                    taskToBeDeleted = self.openNormalTasks[indexPath.row]
                }
                else{
                    taskToBeDeleted = self.completedNormalTasks[indexPath.row]
                }
                
                try!uiRealm.write({ () -> Void in
                    uiRealm.delete(taskToBeDeleted)
                    self.readTasksAndUpateUI()
                })
            }
            let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
                // Editing will go here
                var taskToBeUpdated: NormalMood!
                if indexPath.section == 0{
                    taskToBeUpdated = self.openNormalTasks[indexPath.row]
                }
                else{
                    taskToBeUpdated = self.completedNormalTasks[indexPath.row]
                }
                
                self.displayAlertToAddNormalTask(taskToBeUpdated)
                
            }
            
            let doneAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Done") { (doneAction, indexPath) -> Void in
                // Editing will go here
                var taskToBeUpdated: NormalMood!
                if indexPath.section == 0{
                    taskToBeUpdated = self.openNormalTasks[indexPath.row]
                }
                else{
                    taskToBeUpdated = self.completedNormalTasks[indexPath.row]
                }
                try!uiRealm.write({ () -> Void in
                    taskToBeUpdated.isCompleted = true
                    self.readTasksAndUpateUI()
                })
                
            }
            return [deleteAction, editAction, doneAction]
        case "Negative":
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
                
                //Deletion will go here
                
                var taskToBeDeleted: NegativeMood!
                if indexPath.section == 0{
                    taskToBeDeleted = self.openNegativeTasks[indexPath.row]
                }
                else{
                    taskToBeDeleted = self.completedNegativeTasks[indexPath.row]
                }
                
                try!uiRealm.write({ () -> Void in
                    uiRealm.delete(taskToBeDeleted)
                    self.readTasksAndUpateUI()
                })
            }
            let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
                // Editing will go here
                var taskToBeUpdated: NegativeMood!
                if indexPath.section == 0{
                    taskToBeUpdated = self.openNegativeTasks[indexPath.row]
                }
                else{
                    taskToBeUpdated = self.completedNegativeTasks[indexPath.row]
                }
                
                self.displayAlertToAddNegativeTask(taskToBeUpdated)
                
            }
            
            let doneAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Done") { (doneAction, indexPath) -> Void in
                // Editing will go here
                var taskToBeUpdated: NegativeMood!
                if indexPath.section == 0{
                    taskToBeUpdated = self.openNegativeTasks[indexPath.row]
                }
                else{
                    taskToBeUpdated = self.completedNegativeTasks[indexPath.row]
                }
                try!uiRealm.write({ () -> Void in
                    taskToBeUpdated.isCompleted = true
                    self.readTasksAndUpateUI()
                })
                
            }
            return [deleteAction, editAction, doneAction]
        default: break
        }

        

        return []
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}