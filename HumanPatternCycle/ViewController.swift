//
//  ViewController.swift
//  HumanPatternCycle
//
//  Created by Admin on 19.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import ForecastIO
import CoreLocation
import MapKit
import SwiftOverlays

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var footerContainer: UIView!
    
    let forecastIOClient = APIClient(apiKey: "0fa076b21210eaf98828db2684c51b48") // Ключ к апи
    var timer = NSTimer()
    
    ///Для таблицы
    
    var containerView: ContainerViewController?
    var containerFooterView: FooterContainerViewController?
    var activeButtonNowIs = 1
    
    @IBOutlet weak var badButtonSelf: UIButton!
    @IBOutlet weak var normalButtonSelf: UIButton!
    @IBOutlet weak var goodButtonSelf: UIButton!
    @IBOutlet weak var normalButtonNSelf: UIButton!
    @IBOutlet weak var badButtonNSelf: UIButton!

    @IBOutlet weak var goodButtonNSelf: UIButton!
    let defaults = NSUserDefaults(suiteName: "group.HumanPatternCycle")
    var secViewC = SecondViewController()
    
    var footerContainerPositionY: CGFloat = 0
    
    
//******** При нажатии на кнопки
    @IBAction func GoodMoodButton(sender: AnyObject) {
        defaults?.setObject("Positive", forKey: "whatMoodChoose")
    }
    @IBAction func NormMoodButton(sender: AnyObject) {
                defaults?.setObject("Normal", forKey: "whatMoodChoose")
    }
    @IBAction func BadMoodButton(sender: AnyObject) {
                defaults?.setObject("Negative", forKey: "whatMoodChoose")
    }
    func getLocation() { // Получаем локацию в Default
        do {
            try! SwiftLocation.shared.currentLocation(.City, timeout: 20, onSuccess: { (location) -> Void in
                // location is a CLPlacemark

                let coord = location!.coordinate // вытаскиваем только координаты
                let lat1 : NSNumber = NSNumber(double: coord.latitude) // конвертируем координаты в double
                let lng1 : NSNumber = NSNumber(double: coord.longitude) // конвертируем координаты в double
                
                let locationDict = ["lat": lat1, "lng": lng1] // запишем в словарь
                
                
                self.defaults?.setObject(locationDict, forKey: "locationDict") // записываем в Defaults
                
                //------+++++++Проверка начата
                print("1. Location found \(location?.description)")
                let longlat = self.defaults!.objectForKey("locationDict") as! [String : NSNumber]  //вытаскиваем сло
                let userLat = longlat["lat"]
                let userLng = longlat["lng"]
                print(userLat)
                print(userLng)
                //+++++++------Проверка закончена
                
                }) { (error) -> Void in
                    print("Something went wrong -> \(error?.localizedDescription). I'm take defaults data...")
                   
            }
        }
    }
    func waitForLocation() {
        let text = "Please wait..."
        self.showWaitOverlayWithText(text)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerAction", userInfo: nil, repeats: true)

    }
    
    
    @IBAction func showPopUpWindow(sender: AnyObject) { //При нажатии на кнопку вызываем всплывающее окно
        
    }
    
    func popUpWin(notification: NSNotification) {  //Вызываем всплывающее окно с ТАЙМЛАЙНОМ
        print(notification.userInfo)
        let popup = PopupController.create(self)
        popup.animation = .FadeIn
        
        let container = NewPopupViewController.instance()
        container.closeHandler = { _ in
            popup.closePopup(nil)
        }
        popup.backgroundStyle = .Blur(style: .Dark)
        popup.presentPopupController(container, completion: nil)
    }
    
    func popUpWinImageCollaction(notification: NSNotification) {  //Вызываем всплывающее окно с СПИСКОМ КАРТИНОК ИЗОБРАЖЕНИЙ
        let popup = PopupController.create(self)
        popup.animation = .FadeIn
        
        let container = ImagesCollectionViewController.instance()
        container.closeHandler = { _ in
            popup.closePopup(nil)
        }
        popup.backgroundStyle = .Blur(style: .Dark)
        popup.presentPopupController(container, completion: nil)
    }
    
    func timerAction() {
        if self.defaults!.objectForKey("locationDict") != nil {
            getWeather() // берем погоду
            timer.invalidate()
            removeAllOverlays()
        }
    }
    func getWeather() { // Определяем погоду
        print("Take weather")
        if self.defaults!.objectForKey("locationDict") != nil { //Если первый вход или нет данных
        forecastIOClient.units = .SI // выставляем формат в градусах
        let longlat = self.defaults!.objectForKey("locationDict") as! [String : NSNumber]  //скачиваем словарь с координатами
        let userLat = longlat["lat"] //записываем координаты в константу
        let userLng = longlat["lng"] //записываем координаты в константу
        
        let Annotation = MKPointAnnotation() // Обьявляем переменную для обратной конвертации из NSNumber в CCLocation
        Annotation.coordinate.latitude = userLat as! CLLocationDegrees  //Конвертируем NSNumber в CLLocationDegrees
        Annotation.coordinate.longitude = userLng as! CLLocationDegrees //Конвертируем NSNumber в CLLocationDegrees
        
        let Latit = Annotation.coordinate.latitude //записываем координаты в переменную
        let Long = Annotation.coordinate.longitude //записываем координаты в переменную
        
        forecastIOClient.getForecast(latitude: Latit, longitude: Long) { (currentForecast, error) -> Void in
            if let currentForecast = currentForecast { // Берем информацию по известным координатам
                print("Облачность - \(currentForecast.currently?.cloudCover)")
                print("температура - \(currentForecast.currently?.temperature)")
                print("давление - \(currentForecast.currently?.pressure)")
                let cloudCover = currentForecast.currently?.cloudCover // запишем облачность в переменную
                self.defaults?.setObject(cloudCover, forKey: "cloudCover") //записываем облачность в Defaults
                let temperature = currentForecast.currently?.temperature // запишем температуру в переменную
                self.defaults?.setObject(temperature, forKey: "temperature") //записываем температуру в Defaults
                let pressure = currentForecast.currently?.pressure // запишем давление в переменную
                self.defaults?.setObject(pressure, forKey: "pressure") //записываем давление в Defaults
                } else if let error = error {
                print("weather error") //  Если ошибка
                }
                }
        } 
    }
    @IBAction func testest(sender: AnyObject) {
       
       // moveFooterContainer()
        //containerView!.segueIdentifierReceivedFromParent("buttonOne")
        // SearchAndCompare().sameName("Positive", name: "Scary")
    }
    
    
    
    func moveFooterContainer(notification: NSNotification) { // перемещаем контейнер наверх когда открывается и закрывается клавиатура
        if footerContainerPositionY == 0 {
        footerContainerPositionY = self.footerContainer.frame.origin.y
        UIView.animateWithDuration(1.0, animations: {
            
            self.footerContainer.frame = CGRect(x: 0, y: 0, width: self.footerContainer.frame.size.width, height: self.footerContainer.frame.size.height)
        })
        } else {
            UIView.animateWithDuration(1.0, animations: {
                self.footerContainer.frame = CGRect(x: 0, y: self.footerContainerPositionY, width: self.footerContainer.frame.size.width, height: self.footerContainer.frame.size.height)
            })
            footerContainerPositionY = 0
        }

    }
    
    
    
    func everyOneSecond() {
        var currentSecondsToUpdate = 0
        currentSecondsToUpdate = defaults!.integerForKey("currentSecondsToUpdate")
        if currentSecondsToUpdate < 300 { // если нет 5 минут еше
            ++currentSecondsToUpdate // то добавим одну секунду
            defaults?.setObject(currentSecondsToUpdate, forKey: "currentSecondsToUpdate")
        } else if currentSecondsToUpdate == 300 { // если достигли 5 минуты
            defaults?.setObject(0, forKey: "currentSecondsToUpdate") // обнулим снова
            print(currentSecondsToUpdate)
    // чекаем локацию и записываем
            do {
                try! SwiftLocation.shared.currentLocation(.Block, timeout: 20, onSuccess: { (location) -> Void in
                    // location is a CLPlacemark
                    print("1. Location found \(location?.description)")
                    let coord = location!.coordinate // вытаскиваем только координаты
                    self.defaults?.setObject(coord.longitude, forKey: "longitude") // записываем новые данные
                    self.defaults?.setObject(coord.latitude, forKey: "latitude") //записываем новые данные
                    
                    }) { (error) -> Void in
                        print("Something went wrong -> \(error?.localizedDescription). I'm take defaults data...")
                }
                }
    // ----------+++-----++чек и запись
                }
                }
    
//-------****------****-----
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
     //  AddNewRecord().addTestRandomData() // ТУТ ДОБАВЛЯЕМ ТЕСТОВЫЕ ДАННЫЕ В  GENERALLIST!
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openFirstWindow:", name:"FirstScreen", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshItems:", name: "refreshItems", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "footerSecond:", name: "footerMood", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "popUpWin:", name: "popUpStart", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "popUpWinImageCollaction:", name: "openImageCollection", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveFooterContainer:", name: "moveFooterContainer", object: nil)
        
        if let firstStart = NSUserDefaults.standardUserDefaults().objectForKey("firstStart") {
            
        } else {
            NSUserDefaults.standardUserDefaults().setObject("Yes", forKey: "firstStart")
            AddNewRecord().firstStart()
        }
        
        print("poplse")
        getLocation() // Сразу берем локацию
        waitForLocation()
        defaults?.setObject("Normal", forKey: "moodView")
         var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "everyOneSecond", userInfo: nil, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
        goodButtonNSelf.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
///////////////////////////////////

    
   
    
    @IBAction func badButton(sender: AnyObject) {
    }
    @IBAction func normalButton(sender: AnyObject) {
        
    }
    @IBAction func goodButton(sender: AnyObject) {
        
    }
    
    @IBAction func goodButtonN(sender: AnyObject) {
        enableButtonAlpha()
        goodButtonNSelf.alpha = 0
        NSUserDefaults.standardUserDefaults().setObject("Good", forKey: "moodBut")
    refreshMoodItems()
    }
    
    
    @IBAction func normalButtonN(sender: AnyObject) {
        enableButtonAlpha()
        normalButtonNSelf.alpha = 0
        NSUserDefaults.standardUserDefaults().setObject("Normal", forKey: "moodBut")
    refreshMoodItems()
        
    }
    
    @IBAction func badButtonN(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject("Bad", forKey: "moodBut")
        enableButtonAlpha()
        badButtonNSelf.alpha = 0
        
    refreshMoodItems()
        
    }
    func enableButtonAlpha() { // Если что то нажато - отжимаем
        if goodButtonNSelf.alpha == 0 {
            goodButtonNSelf.alpha = 1
        }
        if normalButtonNSelf.alpha == 0 {
            normalButtonNSelf.alpha = 1
        }
        if badButtonNSelf.alpha == 0 {
            badButtonNSelf.alpha = 1
        }
    }
    func footerSecond(note: NSNotification) {  // Вызов второго окна настроений
        containerFooterView!.segueIdentifierReceivedFromParent("buttonTwo")
    }
    func refreshItems(note: NSNotification) {
        refreshMoodItems()
    }
    
    func refreshMoodItems() {
        
        containerView!.segueIdentifierReceivedFromParent("buttonThree")
        containerView!.segueIdentifierReceivedFromParent("buttonTwo")
        
    }
    func openFirstWindow(notification: NSNotification) {
        containerView!.segueIdentifierReceivedFromParent("buttonOne")
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "container"{
            
            containerView = segue.destinationViewController as? ContainerViewController
            
        }
        if segue.identifier == "footerSegue"{
            
            containerFooterView = segue.destinationViewController as? FooterContainerViewController
            
            
        }
    }

}

public extension String {
    
    public static func sepaDate(whatNeed: String) -> String  {
        var currentDate = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComponents = calendar!.components([.Day, .Month, .Year, .Minute, .Hour], fromDate: currentDate)
        var forReturn: String = "0"
        switch whatNeed {
            case "day":
                let valu = String(dateComponents.day)
                forReturn = valu
            case "month":
            let valu = String(dateComponents.month)
            forReturn = valu
            case "year":
            let valu = String(dateComponents.year)
            forReturn = valu
            case "hour":
            let valu = String(dateComponents.hour)
            forReturn = valu
            case "minute":
            let valu = String(dateComponents.minute)
            forReturn = valu
            default: print("Error")
        }
        return forReturn
    }
}
