//
//  RoundRectangleCheckBox.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 21/02/2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit

class RoundRectangleCheckBox: UIButton {
    var isChecked:Bool = false{
        didSet{
            if isChecked == true
            {
                  self.setImage(UIImage(named: "patratcheck.png"), for:UIControl.State())

             
            } else {
              self.setImage(UIImage(named: "patrat.png"), for:UIControl.State())
            }
        }
    }
    override func awakeFromNib() {
        self.isChecked = false
    }
}
