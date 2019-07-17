//
//  dayCheckBox.swift
//  Bthere
//
//  Created by User on 5.7.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class dayCheckBox: UIButton {

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    var f:Int = 0
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
//    let checked_checkbox = UIImage(named: "Cancel-select.png")
//    let unChecked_checkbox = UIImage(named: "Cancel.png")
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    var isCecked:Bool = false{
        didSet{
            if isCecked == true
            {
//                self.setImage(checked_checkbox, forState:.Normal)
           
                if  Global.sharedInstance.addRecess == false {
               self.backgroundColor = Colors.sharedInstance.color4
              //   self.backgroundColor = UIColor(patternImage: UIImage(named: "hashBTNDAY.png")!)
                } else {
                self.backgroundColor = Colors.sharedInstance.color3
                   
                }
                 self.setTitleColor(UIColor.white, for: UIControl.State())
            }
            else
            {
               //JMODE 29.12.2016 
                //self.backgroundColor = Colors.sharedInstance.color9
               //   self.setTitleColor(UIColor.blackColor(), forState: .Normal)
                self.setTitleColor(UIColor.white, for: UIControl.State())
                self.backgroundColor = UIColor.darkGray
              
            }
        }
    }
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(checkBoxForDetailsWorker.buttonClicked(_:)), for: UIControl.Event.touchUpInside)
        self.isCecked = false
    }
//
    @objc func buttonClicked(_ sender:UIButton)
    {
//        if(sender == self)
//        {
//            if(isCecked == true)
//            {
//                //isCecked = false
//                Global.sharedInstance.isHoursSelected[sender.tag] = false
//            }
//            else
//            {
//                //isCecked = true
////                Global.sharedInstance.lastBtnDayTag = Global.sharedInstance.currentBtnDayTag
////                Global.sharedInstance.currentBtnDayTag = sender.tag
//                Global.sharedInstance.isHoursSelected[sender.tag] = true
//            }
//        }
    }

}
