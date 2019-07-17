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
    
    var delegateReloadTbl:reloadTblDelegate?=nil
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
       //     delegateReloadTbl?.reloadHeight()//רענון גובה הסל של הצגת השעות
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
          //      delegateReloadTbl?.reloadHeight()//רענון גובה הסל של הצגת השעות
            }
        }
       
    }
    
    func lineForLabels()
    {
        lastLines = Global.sharedInstance.numbersOfLineInLblHours
        if lblHours != nil {
        Global.sharedInstance.numbersOfLineInLblHours = countLabelLines(lblHours)
        }
        if lblRecess != nil {
        Global.sharedInstance.numbersOfLineInLblRest = countLabelLines(lblRecess)
        }
//        if lastLines != Global.sharedInstance.numbersOfLineInLblHours
//        {
//            delegateReloadTbl.reloadTbl()
//        }
    }
    func countLabelLines(_ label: UILabel) -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        var mynumber:Int = 0
        if label.text != nil {
        let myText = label.text! as NSString
        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 17)
        let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font) : labelFont!]), context: nil)
        
        mynumber = Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
        }
        return mynumber
    }
    func lineCountForLabel(_ label:UILabel) -> Int
    {
        var lineCount: Int = 0
        let labelSize:CGSize = CGSize(width:label.frame.size.width, height: label.frame.size.height)
        let labelFont = UIFont(name: "OpenSansHebrew-Bold", size: 17)
        if let  _:CGRect = label.text?.boundingRect(with: labelSize, options: .usesLineFragmentOrigin, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font) : labelFont!]), context: nil ) {
        let requiredSize: CGRect = label.text!.boundingRect(with: labelSize, options: .usesLineFragmentOrigin, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): labelFont!]), context: nil)
        
        let charSize = lroundf(Float(label.font.lineHeight))
        let rHeight: Int = lroundf(Float(requiredSize.height))
        lineCount = rHeight / charSize
        }
        return lineCount
    }
    
    
     override func layoutSubviews() {
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
