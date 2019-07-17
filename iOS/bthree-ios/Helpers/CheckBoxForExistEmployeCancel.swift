//
//  CheckBoxForExistSupplierCancel.swift
//  bthree-ios
//
//  Created by User on 1.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class CheckBoxForExistSupplierCancel: UIButton {

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
    let checked_checkbox = UIImage(named: "Cancel-selected.png")
    let unChecked_checkbox = UIImage(named: "Cancel_unSelected.png")
    
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
                self.setImage(checked_checkbox, for:UIControl.State())
            }
            else
            {
                self.setImage(unChecked_checkbox, for:UIControl.State())
            }
        }
    }
    override func awakeFromNib() {
       // self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
       self.isCecked = false
    }
    
//    func buttonClicked(sender:UIButton)
//    {
//        if(sender == self)
//        {
//            if(isCecked == true)
//            {
//                isCecked = false
//            }
//            else
//            {
//                isCecked = true
//                
//            }
//        }
//    }
    


}
