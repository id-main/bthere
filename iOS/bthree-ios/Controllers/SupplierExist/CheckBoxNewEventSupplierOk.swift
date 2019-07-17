//
//  CheckBoxNewEventSupplierOk.swift
//  BThere
//
//  Created by Eduard Stefanescu on 1/4/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit

class CheckBoxNewEventSupplierOk: UIButton {
    
    var f:Int = 0
    
    let checked_checkbox = UIImage(named: "okSelected.png")
    let unChecked_checkbox = UIImage(named: "freeCircle.png")
    
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
        self.isCecked = false
    }
}

