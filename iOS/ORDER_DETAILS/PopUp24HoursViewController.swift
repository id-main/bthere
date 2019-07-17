//
//  PopUp24HoursViewController.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 25/02/2019
//  Copyright © 2019 Bthere. All rights reserved.
//

import UIKit


class PopUp24HoursViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var txtView: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    var nvPhone:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        txtView.numberOfLines = 0
        txtView.text = "PROMPT_NO_CANCEL_POSSIBLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnCall.setTitle("DIAL_BUTTON".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //func to dismiss the popUp
    @IBAction func closePopup(_ sender:AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func callButton(_ sender:AnyObject) {
        if self.nvPhone != "" {
            Global.sharedInstance.makeCall(nvPhone as NSString)
        }
    }
    
}
