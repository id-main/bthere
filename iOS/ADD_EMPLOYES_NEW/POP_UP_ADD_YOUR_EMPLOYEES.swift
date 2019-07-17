//
//  POP_UP_ADD_YOUR_EMPLOYEES.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 06/03/2019
//  Copyright © 2019 Bthere. All rights reserved.
//

import UIKit


class POP_UP_ADD_YOUR_EMPLOYEES: UIViewController, UIGestureRecognizerDelegate {
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var delegate1:OPENVIEW2!=nil
    @IBOutlet weak var txtView: UILabel!
    @IBOutlet weak var titletext:UILabel!
    @IBOutlet weak var btnCall: UIButton!
    var nvPhone:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        titletext.text = "ADD_YOUR_EMPLOYEES".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        let USERDEF = UserDefaults.standard
        if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            txtView.textAlignment = .right
        } else {
            txtView.textAlignment = .left
        }
        txtView.numberOfLines = 0
        txtView.text = "IF_YOU_HAVE_EMPLOYEES".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnCall.setTitle("GO_TO_ADD_EMPLOYEE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)
        USERDEF.set(1, forKey: "firstpopup_addEmployeesalreadyseen")
        USERDEF.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //func to dismiss the popUp
    @IBAction func closePopup(_ sender:AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func callButton(_ sender:AnyObject)
    {

//        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
//        let  viewpopupAccessCode:popupAccessCode = storyboardtest.instantiateViewController(withIdentifier: "popupAccessCode") as! popupAccessCode
//        if self.iOS8 {
//            viewpopupAccessCode.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        } else {
//            viewpopupAccessCode.modalPresentationStyle = UIModalPresentationStyle.currentContext
//        }
//            viewpopupAccessCode.delegate1 = self.delegate1
//            viewpopupAccessCode.WHICHSCREEN = 3
//            self.present(viewpopupAccessCode, animated: true, completion: nil)
//
        Global.sharedInstance.isProvider = true
        Global.sharedInstance.whichReveal = true
        let mainstoryb = UIStoryboard(name: "newemployee", bundle: nil)
        let  storyBoard1Main = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyBoard1Main.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let viewcon:  SettingsSetupEmployees = mainstoryb.instantiateViewController(withIdentifier: "SettingsSetupEmployees")as! SettingsSetupEmployees
        viewcon.view.frame = CGRect(x: 0, y:  64  , width: self.view.frame.width, height: self.view.frame.height - 64)
        viewcon.modalPresentationStyle = UIModalPresentationStyle.custom
//        self.present(viewcon, animated: true, completion: nil)
        frontviewcontroller!.pushViewController(viewcon, animated: false)
//        initialize REAR View Controller- it is the LEFT hand menu.
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController

    }
    
}
