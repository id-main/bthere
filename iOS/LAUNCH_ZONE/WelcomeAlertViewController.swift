//
//  WelcomeAlertViewController.swift
//  bthree-ios
//
//  Created by Tami wexelbom on 2/17/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//פופאפ ברוך הבא לאחר רישום ספק
class WelcomeAlertViewController: UIViewController {
    var delegate:openRegisterDelegate!=nil
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var btnOk: UIButton!
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate.openRegisterView()
        }
    }
    @IBAction func btnOk(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnOk.setTitle("OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        if DeviceType.IS_IPHONE_6 {
          lblTitle.font = Colors.sharedInstance.fontSecondHeader
        }
        else if  DeviceType.IS_IPHONE_5{
            lblTitle.font = Colors.sharedInstance.fontSmallHeader

        }
        
        lblTitle.text = "WELCOME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lbl1.text = "OPEN_CALENSER1".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lbl2.text = "OPEN_CALENSER2".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnOk.setTitle("OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
