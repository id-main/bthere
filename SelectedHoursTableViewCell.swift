//
//  SelectedHoursTableViewCell.swift
//  Bthere
//
//  Created by User on 20.7.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

protocol lineCountForLabelDelegate {
    func lineForLabels()
}

class SelectedHoursTableViewCell: UITableViewCell,lineCountForLabelDelegate {

    @IBOutlet weak var viewBottom: UIView!
    
    @IBOutlet weak var lblHours: UILabel!
    
    @IBOutlet weak var lblRecess: UILabel!
    
    var delegateReloadTbl:reloadTblDelegate!=nil
    var lastLines = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Global.sharedInstance.GlobalDataVC!.delegateLineForLabel = self
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            lblHours.font = UIFont(name: "OpenSansHebrew-Bold", size: 15)
            lblRecess.font = UIFont(name: "OpenSansHebrew-Bold", size: 15)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        Global.sharedInstance.lastLblHoursHeight = Global.sharedInstance.currentLblHoursHeight
        
        Global.sharedInstance.lastLblRestHeight = Global.sharedInstance.currentLblRestHeight
        
        lblHours.text = Global.sharedInstance.hourShow
       
        //כדי שגובה הלייבל יתרענן ולא ישאר אותו דבר
        lblHours.setNeedsLayout()
        lblHours.layoutIfNeeded()
        
        Global.sharedInstance.currentLblHoursHeight = lblHours.frame.size.height
        
        if Global.sharedInstance.lastLblHoursHeight == 0.0//בשביל הפעם הראשונה
        {
            Global.sharedInstance.lastLblHoursHeight = Global.sharedInstance.currentLblHoursHeight
        }
        
        if Global.sharedInstance.currentLblHoursHeight > Global.sharedInstance.lastLblHoursHeight
        {
            lineForLabels()//עדכון מספר השורות בלייבל
            delegateReloadTbl.reloadHeight()//רענון גובה הסל של הצגת השעות
        }
        
        if Global.sharedInstance.hourShow == ""
        {
            lblRecess.text = ""
        }
        else
        {
            lblRecess.text = Global.sharedInstance.hourShowRecess
            
            lblRecess.setNeedsLayout()
            lblRecess.layoutIfNeeded()
            
            Global.sharedInstance.currentLblRestHeight = lblRecess.frame.size.height
            
            if Global.sharedInstance.lastLblRestHeight == 0.0//בשביל הפעם הראשונה
            {
                Global.sharedInstance.lastLblRestHeight = Global.sharedInstance.currentLblRestHeight
            }
            
            if Global.sharedInstance.currentLblRestHeight > Global.sharedInstance.lastLblRestHeight
            {
                lineForLabels()//עדכון מספר השורות בלייבל
                delegateReloadTbl.reloadHeight()//רענון גובה הסל של הצגת השעות
            }
        }
       
    }
    
    func lineForLabels()
    {
        lastLines = Global.sharedInstance.numbersOfLineInLblHours
        Global.sharedInstance.numbersOfLineInLblHours = lineCountForLabel(lblHours)
        Global.sharedInstance.numbersOfLineInLblRest = lineCountForLabel(lblRecess)
        
//        if lastLines != Global.sharedInstance.numbersOfLineInLblHours
//        {
//            delegateReloadTbl.reloadTbl()
//        }
    }
    
    func lineCountForLabel(_ label:UILabel) -> Int
    {
        var lineCount: Int = 0
        let labelSize:CGSize = CGSize(width:label.frame.size.width, height: label.frame.size.height)
        let requiredSize: CGRect = label.text!.boundingRect(with: labelSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil)
        
        let charSize = lroundf(Float(label.font.lineHeight));
        let rHeight: Int = lroundf(Float(requiredSize.height))
        lineCount = rHeight / charSize
        
        return lineCount
    }
    
    
     override func layoutSubviews() {
    }
}
