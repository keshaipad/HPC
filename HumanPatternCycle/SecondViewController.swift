//
//  SecondViewController.swift
//  HumanPatternCycle
//
//  Created by Admin on 27.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RealmSwift
extension UIFont {
    
    enum FontType: String {
        case Regular = "Regular"
        case Bold = "Bold"
        case Light = "Light"
        case UltraLight = "UltraLight"
        case Italic = "Italic"
        case Thin = "Thin"
    }
    
    enum FontName: String {
        case HelveticaNeue = "HelveticaNeue"
        case Helvetica = "Helvetica"
        case Futura = "Futura"
        case Menlo = "Menlo"
    }
    
    class func Font (name: FontName, type: FontType, size: CGFloat) -> UIFont {
        return UIFont (name: name.rawValue + "-" + type.rawValue, size: size)!
    }
    
    class func HelveticaNeue (type: FontType, size: CGFloat) -> UIFont {
        return Font(.HelveticaNeue, type: type, size: size)
    }
}
class SecondViewController: UIViewController {
    
    // MARK: Properties
    
    var borderColor: UIColor?
    var bgColor: UIColor?
    var bottomColor: UIColor?
    
    
    var gridView : ReorderableGridView?
    var itemCount: Int = 0
    var itemsInListsCount = 0 //сколько в БД записей
    var currentNumberInDB = 0 // кто сейчас записывается
    
    var positiveLists : Results<PositiveMood>!
    var normalLists : Results<NormalMood>!
    var negativeLists : Results<NegativeMood>!
    
    
    var whatMoodButtonNow = "Normal"
    
    var currentCreateAction:UIAlertAction!
    
    let tapRec = UITapGestureRecognizer()
    let defaults = NSUserDefaults(suiteName: "group.HumanPatternCycle")
    var containerView: ContainerViewController!
    
  
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
            containerView = segue.sourceViewController as! ContainerViewController
       
    }
    
    func readTasksAndUpdateUI(moodButtonClicked: String){
        switch moodButtonClicked {
            case "Good":
                positiveLists = uiRealm.objects(PositiveMood) // Подгружаем результаты хорошего настроения
                itemsInListsCount = positiveLists.count // Присваиваем общее количество елементов
            whatMoodButtonNow = "Good"
            
            case "Normal":
            normalLists = uiRealm.objects(NormalMood) // Подгружаем результаты среднего настроения
            itemsInListsCount = normalLists.count // Присваиваем общее количество елементов
            whatMoodButtonNow = "Normal"
            
            case "Bad":
                negativeLists = uiRealm.objects(NegativeMood) // Подгружаем результаты плохого настроения
                itemsInListsCount = negativeLists.count // Присваиваем общее количество елементов
            whatMoodButtonNow = "Bad"
            
        default: return
        }
        

    }

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    func deleteAllItems() {
        print(itemsInListsCount)
        while itemsInListsCount>0 {
            gridView?.removeReorderableView(gridView!.reorderableViews[0])
            print(itemsInListsCount)
            --itemsInListsCount
            
        }
    }
    func reloadSetup() {
        borderColor = RGBColor(233, g: 233, b: 233)
        bgColor = RGBColor(242, g: 242, b: 242)
        bottomColor = RGBColor(65, g: 65, b: 65)
        
        self.title = ""
        self.navigationItem.title = ""
        
        let wi = 677
        let he = 424
        let w = CGFloat(wi)
        let h = CGFloat(he)
        
        
        setupGridView()
        gridView?.setH(h)// Зададим начальную высоту
        gridView?.setW(w) // Зададим начальную ширину
        gridView?.invalidateLayout()
        
        
        tapRec.addTarget(self, action: "tappedView4")
        gridView?.addGestureRecognizer(tapRec)
        gridView?.userInteractionEnabled = true
    }
    func exitController() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
       
    }
    func tappedView(){
        print("Yes, it's tap")
        
       // AddNewRecord().addNewItem()
        
            }
    func tappedView4(){ // При нажатии на пустое поле, добавляем новый элемент
        
    }
    
    func addNewMood() {
        let alertView = SCLAlertView()
        
        let txt = alertView.addTextField("Joyful")
        alertView.showCloseButton = false
        alertView.addButton("Add") {
            print(txt.text)
            AddNewRecord().addNewItemToCurrentMood(txt.text!)
            NSNotificationCenter.defaultCenter().postNotificationName("refreshItems", object: nil) // Вызываем перезагрузку страницы
            NSNotificationCenter.defaultCenter().postNotificationName("openImageCollection", object: nil) // Вызываем список изображений для выбора
        }
        alertView.showEdit("Add new mood", subTitle: "Write the name of mood")
    }
    
    func refre() {
        let thirdViewController:ThirdViewController = ThirdViewController()
        
        self.presentViewController(thirdViewController, animated: true, completion: nil)

    }
    func succesAlert() {
        let alertViewSuc = SCLAlertView()
        alertViewSuc.showCloseButton = false
        alertViewSuc.showSuccess("Great!", subTitle: "Successfully added to database!", closeButtonTitle: "closebuttonTitle", duration: 1, colorStyle: 0x22B573, colorTextButton: 0xFFFFFF)
    }
    override func viewDidAppear(animated: Bool) {
        exitController()
        if let grid = gridView {
            grid.invalidateLayout()
        }
        deleteAllItems()
        if let currentValue = NSUserDefaults.standardUserDefaults().objectForKey("moodBut"){
            print("Have")
            let curValue = NSUserDefaults.standardUserDefaults().stringForKey("moodBut")
            if curValue == "Good" {
                readTasksAndUpdateUI("Good")
                reloadSetup()
                print("Good")
            } else if curValue == "Normal" {
                readTasksAndUpdateUI("Normal")
                reloadSetup()
                print("Normal")
            } else if curValue == "Bad" {
                readTasksAndUpdateUI("Bad")
                reloadSetup()
                print("Bad")
            }
            
        }else{
            print("doesen't have")
            readTasksAndUpdateUI("Good")
            reloadSetup()
            NSUserDefaults.standardUserDefaults().setObject("Good", forKey: "moodBut")
        }

    }
    
    func testFunc() {
        
    }
    
    func addToDataBase(Yy: Int) {
        
        print(Yy)

    }
    
    // MARK: Grid View
    
    func setupGridView () {
        let add = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addPressed:")
        let remove = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "removePressed:")
        
        self.navigationItem.leftBarButtonItem = add
        self.navigationItem.rightBarButtonItem = remove
        
        gridView = ReorderableGridView(frame: view.frame, itemWidth: 120, verticalPadding: 40)
        view.addSubview(gridView!)
        
        for _ in 0..<itemsInListsCount { //Определяем количество будуще созданных елементов (от количества в БД)
            gridView!.addReorderableView(itemView())
            ++currentNumberInDB
        }
        gridView!.addReorderableView(addButtonView())
        currentNumberInDB = 0
    }
    
    func goToCalendarView() {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("smallWindow") as UIViewController
        self.presentViewController(viewController, animated: false, completion: nil)
        
    }
    
    func itemView () -> ReorderableView {
        let w : CGFloat = 114 // утановка ширины иконки
        let h : CGFloat = 170 // установка высоты иконки
        
        let view = ReorderableView (x: 0, y: 0, w: w, h: h)
        view.tag = itemCount++
        view.layer.borderColor = borderColor?.CGColor
        
        
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        
        let topView = UIView(x: 0, y: 0, w: view.w, h: 50) // Ставим верхний блок с Label
        view.addSubview(topView)
        
        let itemLabel = UILabel (frame: topView.frame) // Вписываем текст
        itemLabel.center = topView.center
        itemLabel.font = UIFont.HelveticaNeue(.Thin, size: 15)
        itemLabel.textAlignment = NSTextAlignment.Center
        
        var textLab = ""
        var imageName = ""
        switch whatMoodButtonNow {
        case "Normal":
            let textNormalLab = normalLists[currentNumberInDB]
             textLab = textNormalLab.name
            imageName = textNormalLab.image
        case "Good":
            let textPositiveLab = positiveLists[currentNumberInDB]
             textLab = textPositiveLab.name
            imageName = textPositiveLab.image
        case "Bad":
            let textNegativeLab = negativeLists[currentNumberInDB]
             textLab = textNegativeLab.name
            imageName = textNegativeLab.image
        default: print("-")
        }
      
        

        itemLabel.text = textLab
        itemLabel.layer.masksToBounds = true
        topView.addSubview(itemLabel)
        //------------------------
        
        let sepLayer = CALayer ()
        sepLayer.frame = CGRect (x: 0, y: topView.bottom, width: topView.w, height: 1)
        sepLayer.backgroundColor = borderColor?.CGColor
        topView.layer.addSublayer(sepLayer)
        
        //let bottomView = UIView(frame: CGRect(x: 0, y: topView.bottom, width: view.w, height: view.h-topView.h))
        let bottomView = UIImageView(image: UIImage(named: imageName)!) // Устанавливаем изображение, сответствующее названию настроения
        bottomView.frame = CGRect(x: 0, y: topView.bottom, width: view.w, height: view.h-topView.h)
        let bottomLayer = CALayer ()
        bottomLayer.frame = CGRect (x: 0, y: bottomView.h-5, width: bottomView.w, height: 5)
        bottomLayer.backgroundColor = bottomColor?.CGColor
        bottomView.layer.addSublayer(bottomLayer)
        bottomView.layer.masksToBounds = true
        view.addSubview(bottomView)
        
        return view
    }
    
    func addButtonView() -> ReorderableView {  // Установка кнопки "Добавить"
        
        let w : CGFloat = 114 // утановка ширины иконки
        let h : CGFloat = 170 // установка высоты иконки
        
        let view = ReorderableView (x: 0, y: 0, w: w, h: h)
        view.tag = 999
        view.layer.borderColor = borderColor?.CGColor
        
        
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        
        let topView = UIView(x: 0, y: 0, w: view.w, h: 50) // Ставим верхний блок с Label
        view.addSubview(topView)
        
        let itemLabel = UILabel (frame: topView.frame) // Вписываем текст
        itemLabel.center = topView.center
        itemLabel.font = UIFont.HelveticaNeue(.Thin, size: 15)
        itemLabel.textAlignment = NSTextAlignment.Center
        

        itemLabel.text = "Add new"
        itemLabel.layer.masksToBounds = true
        topView.addSubview(itemLabel)
        //------------------------
        
        let sepLayer = CALayer ()
        sepLayer.frame = CGRect (x: 0, y: topView.bottom, width: topView.w, height: 1)
        sepLayer.backgroundColor = borderColor?.CGColor
        topView.layer.addSublayer(sepLayer)
        
        //let bottomView = UIView(frame: CGRect(x: 0, y: topView.bottom, width: view.w, height: view.h-topView.h))
        let bottomView = UIImageView(image: UIImage(named: "plus.ico")!)
        bottomView.frame = CGRect(x: 0, y: topView.bottom, width: view.w, height: view.h-topView.h)
        let bottomLayer = CALayer ()
        bottomLayer.frame = CGRect (x: 0, y: bottomView.h-5, width: bottomView.w, height: 5)
        bottomLayer.backgroundColor = bottomColor?.CGColor
        bottomView.layer.addSublayer(bottomLayer)
        bottomView.layer.masksToBounds = true
        view.addSubview(bottomView)
        
        return view
    }
    
    
    // MARK: Add/Remove
    
    func addPressed (sender: AnyObject) {
        //gridView?.addReorderableView(itemView())
        gridView?.addReorderableView(itemView(), gridPosition: GridPosition (x: 0, y: 1))
    }
    
    func removePressed (sender: AnyObject) {
        gridView?.removeReorderableViewAtGridPosition(GridPosition (x: 0, y: 0))
        
    }
    func removeAllItems() {
        gridView?.removeReorderableView((gridView?.reorderableViews[1])!)
    }
    
    
    
    // MARK: Interface Rotation
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        let w = UIScreen.mainScreen().bounds.size.width
        let h = UIScreen.mainScreen().bounds.size.height
        
        gridView?.setW(h, h: w)
        gridView?.invalidateLayout()
    }
    
    
    
    // MARK: Utils
    
    func randomColor () -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    func RGBColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor (red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
    
    func RGBAColor (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor (red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
