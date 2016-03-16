//
//  TimeLineContainerViewController.swift
//  HumanPatternCycle
//
//  Created by Admin on 10.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RealmSwift

class TimeLineContainerViewController: UIViewController {
    var scrollView: UIScrollView!
    var timeline:   TimelineView!
    
    var generalRecords : Results<GeneralList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        view.addConstraints([
            NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 29),
            NSLayoutConstraint(item: scrollView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
            ])
        
               
        let selectedDate = NSUserDefaults.standardUserDefaults().objectForKey("selectDate") as! NSDate //Принимаем данные о выбранном дне
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComponents = calendar!.components([.Day, .Month, .Year], fromDate: selectedDate)
        print("day = \(dateComponents.day)", "month = \(dateComponents.month)", "year = \(dateComponents.year)")
        let dayday = String(dateComponents.day) // Конвертируем в цифры в текст
        let monthmonth = String(dateComponents.month) // Конвертируем в цифры в текст
        let yearyear = String(dateComponents.year) // Конвертируем в цифры в текст
        let predicate = NSPredicate(format: "day = %@ AND month = %@ AND year = %@", dayday, monthmonth, yearyear) // Устанавливаем поиск по дате месяцу и году
            generalRecords = uiRealm.objects(GeneralList).filter(predicate) // Фильтруем с предикатом
        
        
        var timeLineFrame = [TimeFrame]() // Создаем пустой массив для таймфрейм данных
        var timeFrameCount = generalRecords.count - 1 // Запишем количество найденных елементов
        print(timeFrameCount)
        var countIndexForArray = 0
        var countFromZiro = 0
        
        while timeFrameCount >= countFromZiro { // Запишем в массив все необходимые елементы
            print("start")
            let currentRecord = generalRecords[countFromZiro]
            
            var correctHour = String(currentRecord.hour) // Если число от 1 до 9 - добавим 0
            if correctHour.characters.count == 1 {
                correctHour = "0" + correctHour
            }
            
            var correctMinute = String(currentRecord.minute) // Если число от 1 до 9 - добавим 0
            if correctMinute.characters.count == 1 {
                correctMinute = "0" + correctMinute
            }
            

            let writeTime = String("\(correctHour):\(correctMinute)") // Запишем в переменную время формата 10:56
            
            timeLineFrame.insert(TimeFrame(text: currentRecord.parentMood, date: writeTime, image: UIImage(named: currentRecord.image)), atIndex: countIndexForArray)  // Присвоим новый таймлайн item
            
            ++countIndexForArray
            ++countFromZiro
        }
        timeline = TimelineView(bulletType: .Circle, timeFrames: timeLineFrame) // Создадим новый таймлайн с массивом

        scrollView.addSubview(timeline)
        scrollView.addConstraints([
            NSLayoutConstraint(item: timeline, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: scrollView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .Right, relatedBy: .Equal, toItem: scrollView, attribute: .Right, multiplier: 1.0, constant: 0),
            
            NSLayoutConstraint(item: timeline, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: 0)
            ])
        
        view.sendSubviewToBack(scrollView)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
