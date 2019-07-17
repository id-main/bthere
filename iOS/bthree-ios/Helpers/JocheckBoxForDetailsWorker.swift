//
//  JocheckBoxForDetailsWorker.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/8/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class JocheckBoxForDetailsWorker: UIButton {

      var f:Int = 0
       let checked_checkbox = UIImage(named: "Cancel-select.png")
    let unChecked_checkbox = UIImage(named: "Cancel.png")
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
        self.addTarget(self, action: #selector(checkBoxForDetailsWorker.buttonClicked(_:)), for: UIControl.Event.touchUpInside)
          }
    
    @objc func buttonClicked(_ sender:UIButton)
    {

    }

}
