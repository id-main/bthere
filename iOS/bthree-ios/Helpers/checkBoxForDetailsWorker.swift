//
//  checkBoxForDetailsWorker.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/8/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class checkBoxForDetailsWorker: UIButton {

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
    let checked_checkbox = UIImage(named: "Cancel-select.png")
    let unChecked_checkbox = UIImage(named: "Cancel.png")

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
//x
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
        self.isCecked = false
    }
    
    @objc func buttonClicked(_ sender:UIButton)
    {
//        if(sender == self)
//        {
//            if(isCecked == true)
//            {
//                isCecked = false
//            }
//            else
//            {
//                isCecked = true
//            }
//        }
    }

}
