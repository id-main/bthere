//
//  workingHoursBtn.swift
//  Bthere
//
//  Created by Iustin Bthere on 10/11/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit

// 0 = light blue, 1 = clear, 2 = gray

class workingHoursBtn: UIButton {

var stateBtn:Int = 0
var onBtn:Bool = true
var hoursDictionary:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    
    override func awakeFromNib()
    {
        self.addTarget(self, action: #selector(workingHoursBtn.buttonClicked(_:)), for: UIControl.Event.touchUpInside)

    }
    
    @objc func buttonClicked(_ sender:UIButton)
    {
//        //light blue color =>  dark gray color
//        print("sender bckg color \(String(describing: sender.backgroundColor))")
//        if sender.backgroundColor == Colors.sharedInstance.color4
//        {
//            self.backgroundColor = Colors.sharedInstance.color5
//            stateBtn = 2
//            sender.isHidden = true
//                    print("sender bckg color \(String(describing: sender.backgroundColor))")
//        }
//        //dark gray color => clear
//        else if sender.backgroundColor == Colors.sharedInstance.color5
//        {
//            sender.backgroundColor = .clear
//            stateBtn = 1
//        }
//            //clear => light blue color
//        else if sender.backgroundColor == .clear
//        {
//            sender.backgroundColor = Colors.sharedInstance.color4
//            stateBtn = 0
//        }
    }
    
    
    
}
