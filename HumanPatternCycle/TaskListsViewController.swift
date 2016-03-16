//
//  TaskListsViewController.swift
//  HumanPatternCycle
//
//  Created by Admin on 19.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var positiveLists : Results<PositiveMoodList>!
    var normalLists : Results<NormalMoodList>!
    var negativeLists : Results<NegativeMoodList>!
    let defaults = NSUserDefaults(suiteName: "group.HumanPatternCycle")
    
    var isEditingMode = false
    var whatMoodChoose: String = "" // от какой кнопки переход
    
    var currentCreateAction:UIAlertAction!
    @IBOutlet weak var taskListsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whatMoodChoose = defaults!.stringForKey("whatMoodChoose")!
        print(whatMoodChoose)
    }
    
    override func viewWillAppear(animated: Bool) {
        readTasksAndUpdateUI()
    }
    
    func readTasksAndUpdateUI(){
        switch whatMoodChoose {
            
        case "Positive":
        positiveLists = uiRealm.objects(PositiveMoodList)
        self.taskListsTableView.setEditing(false, animated: true)
        self.taskListsTableView.reloadData()
        case "Normal":
        normalLists = uiRealm.objects(NormalMoodList)
        self.taskListsTableView.setEditing(false, animated: true)
        self.taskListsTableView.reloadData()
        case "Negative":
        negativeLists = uiRealm.objects(NegativeMoodList)
        self.taskListsTableView.setEditing(false, animated: true)
        self.taskListsTableView.reloadData()
        default: break
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions -
    
    
    @IBAction func didSelectSortCriteria(sender: UISegmentedControl) {
        
// ****** Выравнивание ----
        
        if whatMoodChoose ==  "Positive"{
        if sender.selectedSegmentIndex == 0{
            // A-Z
            self.positiveLists = self.positiveLists.sorted("name")
        }
        else{
            // date
            self.positiveLists = self.positiveLists.sorted("createdAt", ascending:false)
        }
        }
        if whatMoodChoose ==  "Normal"{
            if sender.selectedSegmentIndex == 0{
                // A-Z
                self.normalLists = self.normalLists.sorted("name")
            }
            else{
                // date
                self.normalLists = self.normalLists.sorted("createdAt", ascending:false)
            }
        }
        if whatMoodChoose ==  "Negative"{
            if sender.selectedSegmentIndex == 0{
                // A-Z
                self.negativeLists = self.negativeLists.sorted("name")
            }
            else{
                // date
                self.negativeLists = self.negativeLists.sorted("createdAt", ascending:false)
            }
        }
// -----**********
        
        self.taskListsTableView.reloadData()
    }
    
    
// ***** Кнопка Выход -----
    @IBAction func didClickOnEditButton(sender: UIBarButtonItem) {
        let presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismissViewControllerAnimated(false) {
            // go back to MainMenuView as the eyes of the user
            presentingViewController.dismissViewControllerAnimated(false, completion: nil)
        }
                defaults?.setObject("", forKey: "whatMoodChoose")
    }
// ------******
    
    
    @IBAction func didClickOnAddButton(sender: UIBarButtonItem) {
        switch whatMoodChoose {
            case "Positive":
            displayAlertToAddPositiveList(nil)
        case "Normal":
            displayAlertToAddNormalList(nil)
        case "Negative":
            displayAlertToAddNegativeList(nil)
        default: break
        }
        
    }
    
    //Enable the create action of the alert only if textfield text is not empty
    func listNameFieldDidChange(textField:UITextField){
        self.currentCreateAction.enabled = textField.text?.characters.count > 0
    }
//---------------
//-----------------
//---------------------
//------------------------
//------------------------------
    
    func displayAlertToAddPositiveList(updatedList:PositiveMoodList!){
        
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
                    self.readTasksAndUpdateUI()
                })
            }
            else{
                
                let newTaskList = PositiveMoodList()
                newTaskList.name = listName!
                
                try!uiRealm.write({ () -> Void in
                    
                    uiRealm.add(newTaskList)
                    self.readTasksAndUpdateUI()
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
    
    func displayAlertToAddNormalList(updatedList:NormalMoodList!){
        
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
                    self.readTasksAndUpdateUI()
                })
            }
            else{
                
                let newTaskList = NormalMoodList()
                newTaskList.name = listName!
                
                try!uiRealm.write({ () -> Void in
                    
                    uiRealm.add(newTaskList)
                    self.readTasksAndUpdateUI()
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
//----------------------------------
    
    func displayAlertToAddNegativeList(updatedList:NegativeMoodList!){
        
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
                    self.readTasksAndUpdateUI()
                })
            }
            else{
                
                let newTaskList = NegativeMoodList()
                newTaskList.name = listName!
                
                try!uiRealm.write({ () -> Void in
                    
                    uiRealm.add(newTaskList)
                    self.readTasksAndUpdateUI()
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
 //--------------------------------
//--------------------------
//---------------------
//----------------
//-----------
//-------
    // MARK: - UITableViewDataSource -
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        
        switch whatMoodChoose {
        case "Positive":
            if let listsTasks = positiveLists{
                return listsTasks.count
            }
            return 0
        case "Normal":
            if let listsTasks = normalLists{
                return listsTasks.count
            }
            return 0
        case "Negative":
            if let listsTasks = negativeLists{
                return listsTasks.count
            }
            return 0
        default: break
        }
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell")
        
        
        switch whatMoodChoose {
        case "Positive":
           let list = positiveLists[indexPath.row]
            cell?.textLabel?.text = list.name
            cell?.detailTextLabel?.text = "\(list.tasks.count)"
            return cell!
        case "Normal":
            let list = normalLists[indexPath.row]
            cell?.textLabel?.text = list.name
            cell?.detailTextLabel?.text = "\(list.tasks.count)"
            return cell!
        case "Negative":
            let list = negativeLists[indexPath.row]
            cell?.textLabel?.text = list.name
            cell?.detailTextLabel?.text = "\(list.tasks.count)"
            return cell!
        default: break
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        switch whatMoodChoose {
        case "Positive":
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
                
                //Deletion will go here
                
                let listToBeDeleted = self.positiveLists[indexPath.row]
                try!uiRealm.write({ () -> Void in
                    uiRealm.delete(listToBeDeleted)
                    self.readTasksAndUpdateUI()
                })
            }
            let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
                
                // Editing will go here
                let listToBeUpdated = self.positiveLists[indexPath.row]
                self.displayAlertToAddPositiveList(listToBeUpdated)
                
            }
            return [deleteAction, editAction]
        case "Normal":
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
                
                //Deletion will go here
                
                let listToBeDeleted = self.normalLists[indexPath.row]
                try!uiRealm.write({ () -> Void in
                    uiRealm.delete(listToBeDeleted)
                    self.readTasksAndUpdateUI()
                })
            }
            let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
                
                // Editing will go here
                let listToBeUpdated = self.normalLists[indexPath.row]
                self.displayAlertToAddNormalList(listToBeUpdated)
                
            }
            return [deleteAction, editAction]
        case "Negative":
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
                
                //Deletion will go here
                
                let listToBeDeleted = self.negativeLists[indexPath.row]
                try!uiRealm.write({ () -> Void in
                    uiRealm.delete(listToBeDeleted)
                    self.readTasksAndUpdateUI()
                })
            }
            let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
                
                // Editing will go here
                let listToBeUpdated = self.negativeLists[indexPath.row]
                self.displayAlertToAddNegativeList(listToBeUpdated)
                
            }
            return [deleteAction, editAction]
        default: break
        }
        
return []
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch whatMoodChoose {
            case "Positive":
            self.performSegueWithIdentifier("openTasks", sender: self.positiveLists[indexPath.row])
        case "Normal":
            self.performSegueWithIdentifier("openTasks", sender: self.normalLists[indexPath.row])
        case "Negative":
            self.performSegueWithIdentifier("openTasks", sender: self.negativeLists[indexPath.row])
        default: break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch whatMoodChoose {
        case "Positive":
        let tasksViewController = segue.destinationViewController as! TasksViewController
        tasksViewController.selectedPositiveList = sender as! PositiveMoodList
            case "Normal":
        let tasksViewController = segue.destinationViewController as! TasksViewController
        tasksViewController.selectedNormalList = sender as! NormalMoodList
            case "Negative":
        let tasksViewController = segue.destinationViewController as! TasksViewController
        tasksViewController.selectedNegativeList = sender as! NegativeMoodList
        default: break
            }
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
