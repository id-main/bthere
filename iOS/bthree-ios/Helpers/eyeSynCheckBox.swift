//
//  eyeSynCheckBox.swift
//  Bthere
//
//  Created by User on 6.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class eyeSynCheckBox: UIButton {

  
    
    var f:Int = 0
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    let checked_checkbox = UIImage(named: "open_eye_J.png")
    let unChecked_checkbox = UIImage(named: "closed_eye_J.png")
    
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
        self.addTarget(self, action: #selector(eyeSynCheckBox.buttonClicked(_:)), for: UIControl.Event.touchUpInside)
        self.isCecked = false
        self.imageView!.contentMode = .scaleAspectFit
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
