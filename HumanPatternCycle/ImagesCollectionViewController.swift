//
//  ImagesCollectionViewController.swift
//  HumanPatternCycle
//
//  Created by Admin on 10.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RealmSwift

class ImagesCollectionViewController: UIViewController, PopupContentViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var positiveLists : Results<PositiveMood>!
    var normalLists : Results<NormalMood>!
    var negativeLists : Results<NegativeMood>!
    
    var whatMoodButtonNow = "Normal"
    
    let moodImagesNames = ["emoB.jpg","emoG.jpg","emoN.jpg"]
    var imagesCount: Int = 0
    
    let reuseIdentifier = "cell"
    private var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())   // Initialization
      var closeHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size = CGSizeMake(670,768) // Первое (из двух) мест где меняем размер всплывающего окна
        self.collectionView.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
        
        if let currentValue = NSUserDefaults.standardUserDefaults().objectForKey("moodBut"){
            let curValue = NSUserDefaults.standardUserDefaults().stringForKey("moodBut")
            if curValue == "Good" {
                whatMoodButtonNow = "Good"
            } else if curValue == "Normal" {
                whatMoodButtonNow = "Normal"
            } else if curValue == "Bad" {
                whatMoodButtonNow = "Bad"
            }
            
        }else{
            NSUserDefaults.standardUserDefaults().setObject("Good", forKey: "moodBut")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    class func instance() -> ImagesCollectionViewController {
        let storyboard = UIStoryboard(name: "ImagesCollection", bundle: nil)
        return storyboard.instantiateInitialViewController() as! ImagesCollectionViewController
    }
    
    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSizeMake(670,768) // Второе (из двух) мест где меняем размер всплывающего окна
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moodImagesNames.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MoodImagesCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let currentImage: String = moodImagesNames[imagesCount]
        cell.moodImage.image = UIImage(named: currentImage)
        ++imagesCount
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        switch whatMoodButtonNow {
        case "Good":
            positiveLists = uiRealm.objects(PositiveMood)
            let lastAdding = positiveLists.last
            let keyLastAdd = lastAdding!.key
            try! uiRealm.write({ () -> Void in
                uiRealm.create(PositiveMood.self, value: ["key": keyLastAdd, "image": moodImagesNames[indexPath.item]], update: true)
                NSNotificationCenter.defaultCenter().postNotificationName("refreshItems", object: nil) // Вызываем перезагрузку страницы
                closeHandler?()  // закрыть всплывающее окно
            })
        case "Normal":
            normalLists = uiRealm.objects(NormalMood) // Подгружаем результаты среднего настроения
            let lastAdding = normalLists.last
            let keyLastAdd = lastAdding!.key
            try! uiRealm.write({ () -> Void in
                uiRealm.create(NormalMood.self, value: ["key": keyLastAdd, "image": moodImagesNames[indexPath.item]], update: true)
                NSNotificationCenter.defaultCenter().postNotificationName("refreshItems", object: nil) // Вызываем перезагрузку страницы
                closeHandler?() // закрыть всплывающее окно
            })

        case "Bad":
            negativeLists = uiRealm.objects(NegativeMood) // Подгружаем результаты среднего настроения
            let lastAdding = negativeLists.last
            let keyLastAdd = lastAdding!.key
            try! uiRealm.write({ () -> Void in
                uiRealm.create(NegativeMood.self, value: ["key": keyLastAdd, "image": moodImagesNames[indexPath.item]], update: true)
                NSNotificationCenter.defaultCenter().postNotificationName("refreshItems", object: nil) // Вызываем перезагрузку страницы
                closeHandler?() // закрыть всплывающее окно
            })
        default: print("-")
        }
    }
    
}
