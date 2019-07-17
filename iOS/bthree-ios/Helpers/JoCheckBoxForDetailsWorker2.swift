//
//  JoCheckBoxForDetailsWorker2.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/8/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//
class JoCheckBoxForDetailsWorker2: UIButton {

    var f:Int = 0
   
    let checked_checkbox = UIImage(named: "OK-select.png")
    let unChecked_checkbox = UIImage(named: "ok (1).png")
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
        
//        self.addTarget(self, action: #selector(CheckBoxForDetailsWorker2.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        self.contentMode = .scaleAspectFit
        
        
    }
    
    @objc func buttonClicked(_ sender:UIButton)
    {
    }
}
