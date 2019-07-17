//
//  AfterVideoPlayerScreen.swift
//  BThere
//
//  Created by Ioan Ungureanu on 29/10/18.
//  Copyright © 2018 Bthere. All rights reserved.
//

import Foundation
import UIKit

class  AfterVideoPlayerScreen:UIViewController {
    @IBOutlet weak var TitleScreen:UILabel!
    @IBOutlet weak var LineText1:UILabel!
    @IBOutlet weak var LineText2:UILabel!
    @IBOutlet weak var LineText3:UILabel!
    @IBOutlet weak var LineText4:UILabel!
    @IBOutlet weak var ViewBlue:UIView!
    @IBOutlet weak var SkipButton:UIButton!
    @IBOutlet weak var ViewContainer:UIView!

    @IBAction func SkipButton(_ sender: AnyObject) {
 //   self.dismiss(animated: false, completion: nil)
        gotoEntranceCustomerx()
    }
    func gotoEntranceCustomerx() {
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        let storyBoard1 =  UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyBoard1.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyBoard1.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        let rearViewController = storyBoard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
     self.ViewContainer.addBackground()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.ViewContainer.addBackground()
        TitleScreen.text = "AFTERVIDEOPLAYERSCREENTITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText1.text = "AFTERVIDEOPLAYERSCREENLINELINETEXT1".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText2.text = "AFTERVIDEOPLAYERSCREENLINELINETEXT2".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText3.text = "AFTERVIDEOPLAYERSCREENLINELINETEXT3".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText4.text = "AFTERVIDEOPLAYERSCREENLINELINETEXT4".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ViewBlue.backgroundColor = Colors.sharedInstance.color4
        let tapProvider:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openBusinessRegistrationScreen))
        ViewBlue.addGestureRecognizer(tapProvider)
        SkipButton.setTitle("SKIP_AFTER_VIDEO".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        self.view.bringSubviewToFront(SkipButton)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @objc func openBusinessRegistrationScreen() {
        Global.sharedInstance.defaults.set(0, forKey: "ISFROMSETTINGS")
        Global.sharedInstance.defaults.set(1,  forKey: "isenteringregister")
        Global.sharedInstance.defaults.synchronize()
        Global.sharedInstance.isProvider = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewCon:RgisterModelViewController = storyboard.instantiateViewController(withIdentifier: "RgisterModelViewController") as! RgisterModelViewController
        let viewCon1:GlobalDataViewController = storyboard.instantiateViewController(withIdentifier: "GlobalDataViewController") as! GlobalDataViewController
        viewCon.delegateFirstSection = viewCon1
        viewCon.delegateSecond1Section = viewCon1
        let front = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        front.pushViewController(viewCon, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = front
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
}
