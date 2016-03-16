//
//  cellDataBaseViewController.swift
//  HumanPatternCycle
//
//  Created by Admin on 25.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class cellDataBaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var uglyTitles = ["Is this even legal?", "Have to puke", "This was digusting!", "Oh, please!", "My eyes!", "Hey! This is not ugly!"]
    var uglyThings = ["https://s-media-cache-ak0.pinimg.com/236x/f1/9a/51/f19a5199180cc1f5c82bb5367fca65b8.jpg","http://cdn0.lostateminor.com/wp-content/uploads/2009/02/richard-stipl-2.jpg","http://application.denofgeek.com/images/gb/25bb/gremlins2.jpg","http://i.telegraph.co.uk/multimedia/archive/01565/blobfish_1565953c.jpg","https://monoinfinito.files.wordpress.com/2010/08/ugly3_lg1.gif", "http://goodereader.s3.amazonaws.com/blog/uploads/images/Gillian-Anderson-24.jpg"]
    var lists : Results<GeneralList>!
    func readTasksAndUpdateUI() {
        lists = uiRealm.objects(GeneralList)
        self.lists = self.lists.sorted("createdAt", ascending:false)
        self.tableView.setEditing(false, animated: true)
        self.tableView.reloadData()
    }
    
    @IBAction func buttonBack(sender: AnyObject) {
        // выход
        
        let presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismissViewControllerAnimated(true) {
            // go back to MainMenuView as the eyes of the user
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         readTasksAndUpdateUI()
        tableView.delegate = self
        tableView.dataSource = self
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 
        let cellDB = tableView.dequeueReusableCellWithIdentifier("cellDataBase") as? cellDataBase
        let list = lists[indexPath.row]
        let parentMood = list.parentMood
        let date = list.createdAt
        let parentMoodList = list.parentMoodList
        let moon = list.noname1
        let temperature = list.temperature
        let pressure = list.pressure
        let cloud = list.cloudCover
        let coordLat = list.lat
        let coordLon = list.lon
        let moodDet = list.mood
        print("before \(coordLat)")

        cellDB?.configureCell(temperature, moodX: parentMood, specMoodX: parentMoodList, moodDetailX: moodDet, dateX: date, locLongX: coordLon, locLatX: coordLat, pressureX: pressure, cloudCoverX: cloud, moonPhaseX: moon)
            return cellDB!
    }
    

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return lists.count
        }
        return lists.count
    }
    

}