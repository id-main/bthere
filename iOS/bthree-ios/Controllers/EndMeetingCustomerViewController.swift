//
//  EndMeetingCustomerViewController.swift
//  BThere
//
//  Created by Eduard Stefanescu on 12/15/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import UIKit
import MarqueeLabel

class EndMeetingCustomerViewController: NavigationModelViewController, openFromMenuDelegate {
    // Outlets
    @IBOutlet var plusMenuImage: UIImageView!
    @IBOutlet var newsDealsLabel: MarqueeLabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var line1: UILabel!
    @IBOutlet var line2: UILabel!
    @IBOutlet var line3: UILabel!
    @IBOutlet var line4: UILabel!
    @IBOutlet var line5: UILabel!
    @IBOutlet var line6: UILabel!
    @IBOutlet var line7: UILabel!
    @IBOutlet var contraint1: NSLayoutConstraint!
    @IBOutlet var contraint2: NSLayoutConstraint!
    
    
    // Variables
    var mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var isfromSPECIALSUPPLIER:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isfromSPECIALSUPPLIER == true) {
            Global.sharedInstance.whichReveal = true
            let frontviewcontroller:UINavigationController? = UINavigationController()
            let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
            let viewCon = storyBoard.instantiateViewController(withIdentifier: "MyCostumersViewController") as!  MyCostumersViewController
            isfromSPECIALSUPPLIER = false
            Global.sharedInstance.isProvider = true
            frontviewcontroller!.pushViewController(viewCon, animated: false)
            //initialize REAR View Controller- it is the LEFT hand menu.
            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
            let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
        }
        
        
        // Set navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Set background image
        self.view.addBackground()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            contraint1.constant = 21
            contraint2.constant = 21
        } else {
            contraint1.constant = 45
            contraint2.constant = 45
        }
        
        // Language
        doneButton.setTitle("END_MEETING_BUTTON".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        line1.text = "END_MEETING_TEXT1".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        line2.text = "END_MEETING_TEXT2".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        line3.text = "END_MEETING_TEXT3".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        line4.text = "END_MEETING_TEXT4".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        line5.text = "END_MEETING_TEXT5".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        line6.text = "END_MEETING_TEXT6".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        line7.text = "END_MEETING_TEXT7".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        self.getnews()
        self.newsDealsLabel.restartLabel()
        
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            plusMenuImage.image = UIImage(named: "plus.png")
        } else {
            plusMenuImage.image = UIImage(named: "plusEnglish.png")
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(EndMeetingCustomerViewController.imageTapped))
        plusMenuImage.isUserInteractionEnabled = true
        plusMenuImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getnews()
        self.newsDealsLabel.restartLabel()
    }
    
    
    func getnews(){
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
             var y:Int = 0
            if let _:NSDictionary =  (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary) {
                let a:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
                dic["iUserId"] = y as AnyObject
            }
            api.sharedInstance.GetNewsAndUpdates(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                    Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else{
                    if let abcd = RESPONSEOBJECT["Result"] as? String {
                        self.newsDealsLabel.tag = 101
                        self.newsDealsLabel.type = .continuous
                        self.newsDealsLabel.animationCurve = .linear
                        self.newsDealsLabel.type = .leftRight
                        self.newsDealsLabel.text  = abcd
                        self.newsDealsLabel.restartLabel()
                    }
                }
                }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
            })
        }
    }
    
    
    @IBAction func doneButton(_ sender: AnyObject) {
        if isfromSPECIALSUPPLIER == false {
            Global.sharedInstance.isProvider = false
            Global.sharedInstance.whichReveal = false
            let frontviewcontroller = self.mainStoryboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
            frontviewcontroller?.pushViewController(vc, animated: false)
            let rearViewController = self.mainStoryboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
        } else {
            Global.sharedInstance.whichReveal = true
            let frontviewcontroller:UINavigationController? = UINavigationController()
            let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
            let viewCon = storyBoard.instantiateViewController(withIdentifier: "MyCostumersViewController") as!  MyCostumersViewController
            isfromSPECIALSUPPLIER = false
            Global.sharedInstance.isProvider = true
            frontviewcontroller!.pushViewController(viewCon, animated: false)
            //initialize REAR View Controller- it is the LEFT hand menu.
            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
            let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
        }
    }
    
    
    @objc func imageTapped () {
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let viewCon:MenuPlusViewController = storyboard1.instantiateViewController(withIdentifier: "MenuPlusViewController") as! MenuPlusViewController
        viewCon.delegate = self
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
    }
    
    
    func openFromMenu(_ con:UIViewController) {
        self.present(con, animated: true, completion: nil)
    }
}
