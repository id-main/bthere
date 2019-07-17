//
//  CheckBoxForDetailsWorker3.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/8/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//V
class CheckBoxForDetailsWorker3: UIButton {

    var f:Int = 0
   
    let checked_checkbox = UIImage(named: "OK-select-strock-black")
    let unChecked_checkbox = UIImage(named: "ok_unSelected.png")
    var isCecked:Bool = false
        {
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
        
        self.addTarget(self, action: #selector(CheckBoxForDetailsWorker2.buttonClicked(_:)), for: UIControl.Event.touchUpInside)
        self.contentMode = .scaleAspectFit
        
        if Global.sharedInstance.isSelected == false{
               self.isCecked = false
        }
        else{
            Global.sharedInstance.isSelected = false
        }
    
    }
    
    @objc func buttonClicked(_ sender:UIButton)
    {
    }
}
