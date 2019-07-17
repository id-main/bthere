//
//  CheckBoxInTblNotification.swift
//  Bthere
//
//  Created by User on 28.7.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class CheckBoxInTblNotification: UIButton {

    var f:Int = 0
    
    let checked_checkbox = UIImage(named: "OK-select.png")
    let unChecked_checkbox = UIImage(named: "cancelSelect.png")
    var isCecked:Bool = false{
        didSet{
            if isCecked == true
            {
                self.setImage(checked_checkbox, for:UIControl.State())
            }
            else
            {
                self.setImage(unChecked_checkbox, for:UIControl.State())
            }
        }
    }
    override func awakeFromNib() {
        
//        self.addTarget(self, action: #selector(CheckBoxForDetailsWorker2.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        
        if Global.sharedInstance.isSelected == false{
            self.isCecked = false
        }
        else{
            Global.sharedInstance.isSelected = false
        }
        
    }
    
   @objc func buttonClicked(_ sender:UIButton)
    {
        if(sender == self)
        {
            if(isCecked == true)
            {
                isCecked = false
            }
            else
            {
                isCecked = true
                
            }
        }
    }

}
