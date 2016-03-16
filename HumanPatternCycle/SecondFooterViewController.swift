//
//  SecondFooterViewController.swift
//  HumanPatternCycle
//
//  Created by Admin on 09.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RealmSwift
import TextFieldEffects

class SecondFooterViewController: UIViewController {
    
    var generalList : Results<GeneralList>!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var label5: UILabel!
    
    @IBOutlet weak var label6: UILabel!
    
    @IBOutlet weak var label7: UILabel!
    
    @IBOutlet weak var label8: UILabel!
    
    @IBOutlet private var textF: [TextFieldEffects]!
    
    @IBOutlet weak var Test: KaedeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readCurrentMoodFromDatabase()
    }
    
    func readCurrentMoodFromDatabase() {
        generalList = uiRealm.objects(GeneralList)
        let lastRecord = generalList.last
        label1.text = "parentMoodList \(lastRecord?.parentMoodList)"
        label2.text = "parentMood \(lastRecord?.parentMood)"
        label3.text = "temperature: \(lastRecord?.temperature))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
