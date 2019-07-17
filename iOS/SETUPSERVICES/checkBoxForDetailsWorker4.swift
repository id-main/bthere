
//
//  checkBoxForDetailsWorker4.swift


import UIKit

class checkBoxForDetailsWorker4: UIButton {
    var f:Int = 0
    let checked_checkbox = UIImage(named: "cancelSelect.png")
    let unChecked_checkbox = UIImage(named: "cancel-strock-black..png")
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
    }

}
