//
//  ContainerViewController.swift
//  HumanPatternCycle
//
//  Created by Admin on 27.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var vc : UIViewController!
    
    var segueIdentifier : String!
    
    var lastViewController: UIViewController!
    
    
    func segueIdentifierReceivedFromParent(button: String){
        if button == "buttonOne"
        {
            
            self.segueIdentifier = "first"
        
            self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
            
        }
        else if button == "buttonTwo"
        {
            
            self.segueIdentifier = "second"
            self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
            
        }
        else if button == "buttonThree"
        {
            self.segueIdentifier = "third"
            self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
        }
        
        
    }
    func refreshItems() {
        
        self.segueIdentifier = "third"
        self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
        
        self.segueIdentifier = "second"
        self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier{

            if lastViewController != nil{
                lastViewController.view.removeFromSuperview()
      
            }
            
            vc = segue.destinationViewController
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.width,height: self.view.frame.height)
            
            self.view.addSubview(vc.view)
            
            vc.didMoveToParentViewController(self)
            lastViewController = vc
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        segueIdentifierReceivedFromParent("buttonTwo")
        
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
