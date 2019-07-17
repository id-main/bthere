//
//  BoxForAddEmployee.swift
//  bthree-ios
//


import UIKit
//
class BoxForAddEmployee: UIButton {

    var f:Int = 0
   
    let checked_checkbox = UIImage(named: "OK-select-strock-black")
    let unChecked_checkbox = UIImage(named: "ok_unSelected_clear.png")
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
