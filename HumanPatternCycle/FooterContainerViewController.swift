//
//  FooterContainerViewController.swift
//  HumanPatternCycle
//
//  Created by Admin on 08.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class FooterContainerViewController: UIViewController {

    var vc : UIViewController!
    
    var segueIdentifier : String!
    
    var lastViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segueIdentifierReceivedFromParent("buttonOne")
        
    }
    
    func segueIdentifierReceivedFromParent(button: String){
        if button == "buttonOne"
        {
            
            self.segueIdentifier = "firstSegue"
            self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
            
            
        }
        else if button == "buttonTwo"
        {
            
            self.segueIdentifier = "secondSegue"
            self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
            
        }
        
        
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


}
