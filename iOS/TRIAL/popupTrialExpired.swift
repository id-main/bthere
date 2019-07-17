//
//  popupTrialExpired.swift
//  BThere
//
//  Created by Ioan Ungureanu on 28/08/18 dmy.
//  Copyright © 2018 Bthere-Tech. All rights reserved.
//

import Foundation
import UIKit

class popupTrialExpired: NavigationModelViewController {
    
    @IBOutlet weak var popUPPASSWORD:UIView!
    @IBOutlet weak var titlepopUPPASSWORD:UILabel!
    @IBOutlet weak var btnCloseX: UIButton!
    @IBOutlet weak var labelWelcomeText:TTTAttributedLabel!
    @IBOutlet weak var btnGotoPayment: UIButton!
    @IBAction func btnCloseX(_ sender: AnyObject) {
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        let storyBoard2 = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyBoard2.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyBoard2.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        Global.sharedInstance.whichReveal = false
        let rearViewController = storyBoard2.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    @IBAction func btnGotoPayment(_ sender: AnyObject) {
            Global.sharedInstance.isProvider = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
            let viewCon = storyboard.instantiateViewController(withIdentifier: "PaymentForm") as!  PaymentForm
            viewCon.isfromSuppierSettings = false
            viewCon.isFROMCUSTOMER = true
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            frontViewController.pushViewController(viewCon, animated: false)
            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontViewController
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        titlepopUPPASSWORD.text = "TRIAL_PERIOD_ENDS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        labelWelcomeText.text = "TRIAL_PERIOD_ENDS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnGotoPayment.setTitle("TRIAL_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        labelWelcomeText.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(btnCloseX)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
