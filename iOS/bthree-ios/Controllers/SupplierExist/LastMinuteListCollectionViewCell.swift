//
//  LastMinuteListCollectionViewCell.swift
//  BThere
//
//  Created by Eduard Stefanescu on 1/15/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit

class LastMinuteListCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    @IBOutlet weak var defaultImg: UIImageView!
    @IBOutlet weak var viewDefaultimg: UIView!
    @IBOutlet weak var imgCostumer: UIImageView!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var cellclickbutton: UIButton!
    @IBOutlet weak var offerDetailsLabel: UILabel!
    
    
    var viewDelegate:LastMinuteViewController!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    func setDisplayData(_ offerName:String, offerDate:String, flag:Bool) {
        if (flag == true) {
            offerLabel.text = ""
            offerDetailsLabel.text = offerName
            dateLabel.text = ""
        } else {
            offerLabel.text = offerName
            offerDetailsLabel.text = ""
            dateLabel.text = offerDate
        }
    }
}

