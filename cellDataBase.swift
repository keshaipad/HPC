//
//  cellDataBase.swift
//  HumanPatternCycle
//
//  Created by Admin on 25.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class cellDataBase: UITableViewCell {

    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var mood: UILabel!
    @IBOutlet weak var specMood: UILabel!
    
    @IBOutlet weak var moodDetail: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var pressure: UILabel!
    
    @IBOutlet weak var cloudCover: UILabel!
    @IBOutlet weak var moonPhase: UILabel!
    
    @IBOutlet weak var locatLN: UILabel!
    @IBOutlet weak var locatLT: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func configureCell(tempX:Float, moodX: String, specMoodX: String, moodDetailX: String, dateX: NSDate, locLongX: String, locLatX: String, pressureX: Float, cloudCoverX: Float, moonPhaseX: String) {
        temperature.text = String(tempX)
        mood.text = moodX
        specMood.text = specMoodX
        moodDetail.text = moodDetailX
        //moodDetail.text = moodDetailX
        date.text = String(dateX)
        locatLN.text = locLongX
        locatLT.text = locLatX
        pressure.text = String(pressureX)
        cloudCover.text = String(cloudCoverX)
        moonPhase.text = moonPhaseX
        print("last \(locLongX)")
    }

}
