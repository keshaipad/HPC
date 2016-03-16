//
//  NewPopupViewController.swift
//  HumanPatternCycle
//
//  Created by Admin on 10.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class NewPopupViewController: UIViewController, PopupContentViewController {

    var closeHandler: (() -> Void)?
    
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.layer.borderColor = UIColor(red: 242/255, green: 105/255, blue: 100/255, alpha: 1.0).CGColor
            button.layer.borderWidth = 1.5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size = CGSizeMake(670,768) // Первое (из двух) мест где меняем размер всплывающего окна
        
        // Do any additional setup after loading the view.
               
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instance() -> NewPopupViewController {
        let storyboard = UIStoryboard(name: "PopUpStory1", bundle: nil)
        return storyboard.instantiateInitialViewController() as! NewPopupViewController
    }
    
    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSizeMake(670,768) // Второе (из двух) мест где меняем размер всплывающего окна
    }
    
    @IBAction func didTapCloseButton(sender: AnyObject) {
        closeHandler?()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}
