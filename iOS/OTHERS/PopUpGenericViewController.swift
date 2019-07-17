//
//  PopUpGenericViewController.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 27/02/2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit


class PopUpGenericViewController: UIViewController, UIGestureRecognizerDelegate {
    var isfromSPECIALiCustomerUserId:Int = 0
     @IBOutlet weak var txtView: UILabel!
    var isfromWhichScreen:Int = 0
    var ISFROMSPECIALSUPPLIER:Bool = false
    var delegateReloadTbl:reloadTblServiceDelegte!=nil
    var supplierId:Int = 0
    var supplierName:String = ""
    var nrOrders = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        let USERDEF = Global.sharedInstance.defaults
        if USERDEF.object(forKey: "isfromSPECIALiCustomerUserId") == nil {
            USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
            USERDEF.synchronize()
        } else {
            if let _:Int = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as? Int {
                let myint = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as! Int
                self.isfromSPECIALiCustomerUserId = myint
            }
        }
        txtView.numberOfLines = 0
        
        //tap on the page dismiss it
        let touchOnView:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimissViewController))
        self.view.addGestureRecognizer(touchOnView)
        switch (isfromWhichScreen) {
        case 1:
          txtView.text = "JUST_ONE_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 2:
            if self.isfromSPECIALiCustomerUserId != 0 {
                txtView.text = "\("THX".localized(LanguageMain.sharedInstance.USERLANGUAGE)),\n\("FULL_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
            } else {
        txtView.text = "\("THX".localized(LanguageMain.sharedInstance.USERLANGUAGE)) \(" ") \(Global.sharedInstance.currentUser.nvFirstName),\n\("FULL_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
            }
        case 3:
        txtView.text = "SECOND_ONE_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 4:
//            txtView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam lacinia molestie metus, tincidunt molestie sem placerat nec. Duis congue, lectus id euismod ultricies, nunc dolor ultricies diam, at sagittis libero purus vitae sapien. Donec nunc nisl, laoreet non ligula ac, malesuada gravida tortor. Quisque euismod egestas ornare. Proin maximus dapibus neque ac ornare. Praesent vulputate suscipit imperdiet. Etiam ut dui at nunc eleifend scelerisque at et libero. Integer fringilla sodales nisl, vel laoreet urna tempus posuere. Nullam arcu arcu, aliquet ac porttitor at, semper eget eros. Nam facilisis consequat magna, auctor maximus est tristique non. Pellentesque aliquam maximus dictum. eleifend lobortis. Integer et scelerisque erat. Mauris fringilla non diam ac ullamcorper. Fusce eget dictum neque. In finibus metus sit amet venenatis vestibulum. Mauris eu justo ut mi gravida tempus ullamcorper sed dolor. Etiam ultricies nec mi vel vestibulum. Fusce tristique lacus massa, nec viverra ante rhoncus ac. Nulla facilisi. Proin finibus eu tellus id molestie. Praesent et ornare lacus. Sed id facilisis metus, ut tincidunt mi. Sed consectetur a quam nec molestie. "
            if self.isfromSPECIALiCustomerUserId != 0 {
                txtView.text = "\("THX".localized(LanguageMain.sharedInstance.USERLANGUAGE)),\n\("FULL_APPOINTMENT_FAILED".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
            } else {
                txtView.text = "\("THX".localized(LanguageMain.sharedInstance.USERLANGUAGE)) \(" ") \(Global.sharedInstance.currentUser.nvFirstName),\n\("FULL_APPOINTMENT_FAILED".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
            }
            default:
            print(isfromWhichScreen)
        }
        //JUST_ONE_APPOINTMENT
     print(isfromWhichScreen)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //func to dismiss the popUp
    @objc func dimissViewController()
    {
        if self.nrOrders == 3
        {
            self.rateBusiness(idBusiness: self.supplierId, businessName: self.supplierName)
            self.nrOrders = -1
        }
        else
        {
            switch (isfromWhichScreen) {
            case 1, 3:
                self.dismiss(animated: false, completion: nil)
            case 2, 4:
                let USERDEF = UserDefaults.standard
                
                if ISFROMSPECIALSUPPLIER == true ||  USERDEF.integer(forKey: "isfromSPECIALSUPPLIER") == 1  {
                    self.dismiss(animated: false, completion: {
                        Global.sharedInstance.whichReveal = true
                        let frontviewcontroller:UINavigationController? = UINavigationController()
                        let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
                        let viewCon = storyBoard.instantiateViewController(withIdentifier: "MyCostumersViewController") as!  MyCostumersViewController
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
                    })
                } else {
                    
                    self.dismiss(animated: false, completion: {
                        //                 if USERDEF.integer(forKey: "hasrecomendedbusiness") == 0 {
                        //                    USERDEF.set(1, forKey: "hasrecomendedbusiness")
                        //                    USERDEF.synchronize()
                        //                    let mainstoryb = UIStoryboard(name: "CustomersRecommendations", bundle: nil)
                        //                    let vc: CustomersRecommendations = mainstoryb.instantiateViewController(withIdentifier: "CustomersRecommendations")as! CustomersRecommendations
                        //                    let window :UIWindow = UIApplication.shared.keyWindow!
                        //                    window.rootViewController = vc
                        //                    window.makeKeyAndVisible()
                        //                 } else {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        Global.sharedInstance.isProvider = false
                        Global.sharedInstance.whichReveal = false
                        let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                        let vc = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
                        frontviewcontroller?.pushViewController(vc, animated: false)
                        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                        let mainRevealController = SWRevealViewController()
                        mainRevealController.frontViewController = frontviewcontroller
                        mainRevealController.rearViewController = rearViewController
                        let window :UIWindow = UIApplication.shared.keyWindow!
                        window.rootViewController = mainRevealController
                        window.makeKeyAndVisible()
                        //                }
                    })
                }
            default:
                print(isfromWhichScreen)
            }
        }


    }
    
}
