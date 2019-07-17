//
//  POP_UP_EXIT_THE_ADDING_A_CALENDAR_SCREEN.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 07/03/2019
//  Copyright © 2019 Bthere. All rights reserved.
//

import UIKit


class POP_UP_EXIT_THE_ADDING_A_CALENDAR_SCREEN: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var txtView: UILabel!
    @IBOutlet weak var titletext:UILabel!
    @IBOutlet weak var btnCall: UIButton!
    var nvPhone:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        titletext.text = ""
        txtView.numberOfLines = 0
        txtView.text = "ARE_YOU_SURE_YOU_WANT_TO_EXIT_THE_ADDING_A_CALENDAR_SCREEN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnCall.setTitle("CONTINUE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //func to dismiss the popUp
    @IBAction func closePopup(_ sender:AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func callButton(_ sender:AnyObject) {
      print("gata 2")
        self.dismiss(animated: false, completion: {
        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
        frontviewcontroller!.pushViewController(viewcon, animated: false)
        //initialize REAR View Controller- it is the LEFT hand menu.
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    })
    }
    
}
