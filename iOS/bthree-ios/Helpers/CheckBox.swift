//
//  CheckBox.swift
//  bthree-ios
//
//  Created by Tami wexelbom on 2/16/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
   
    var f:Int = 0
        /*
        // Only override drawRect: if you perform custom drawing.
        // An empty implementation adversely affects performance during animation.
        override func drawRect(rect: CGRect) {
        // Drawing code
        }
        */
// JMODE 28.12.2016 no image and button fills cell
//        let checked_checkbox = UIImage(named: "IconSelect.png")
//        let unChecked_checkbox = UIImage(named: "v (2).png")
        var isCecked:Bool = false{
            didSet{
                if isCecked == true
                {
                   // self.setImage(checked_checkbox, forState:.Normal)
              
                }
                else
                {
                 //   self.setImage(unChecked_checkbox, forState:.Normal)
                }
            }
        }
        override func awakeFromNib() {
            self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), for: UIControl.Event.touchUpInside)
            self.isCecked = false
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
