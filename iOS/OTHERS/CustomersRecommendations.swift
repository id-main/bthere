//
//  CustomersRecommendations.swift
//  BThere
//
//  Created by Ioan Ungureanu on 05/09/2018 dmy.
//  Copyright © 2018 Bthere-Tech. All rights reserved.
//

import Foundation
import UIKit

class CustomersRecommendations: NavigationModelViewController {
    
    @IBOutlet weak var titleCustomersRecommendations:UILabel!
    @IBOutlet weak var btnCloseX: UIButton!
    @IBOutlet weak var labelCustomersRecommendationsText:TTTAttributedLabel!
    @IBOutlet weak var btnGotoWebView: UIButton!
    @IBAction func btnCloseX(_ sender: AnyObject) {
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        let storyBoard2 = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyBoard2.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyBoard2.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        let rearViewController = storyBoard2.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    @IBAction func btnGotoWebView(_ sender: AnyObject) {
        let mainstoryb = UIStoryboard(name: "CustomersRecommendations", bundle: nil)
        //
        let viewRegulation: GenericWebView = mainstoryb.instantiateViewController(withIdentifier: "GenericWebView") as! GenericWebView
        viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        viewRegulation.modalPresentationStyle = .custom
        self.present(viewRegulation, animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        titleCustomersRecommendations.text = "TITLE_CUSTOMER_RECOMANDATION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        labelCustomersRecommendationsText.text = "LABEL_CUSTOMER_RECOMANDATION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnGotoWebView.setTitle("BTN_CUSTOMER_RECOMANDATION".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        labelCustomersRecommendationsText.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(btnCloseX)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
