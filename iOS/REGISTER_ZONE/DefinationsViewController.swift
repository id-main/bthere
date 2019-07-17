//
//  DefinationsViewController.swift
//  Bthere
//
//  Created by User on 18.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class DefinationsViewController: NavigationModelViewController {

    @IBOutlet weak var viewPersonalDetails: UIView!

    @IBOutlet weak var viewLanguage: UIView!
    
    @IBOutlet weak var viewGlobalData: UIView!
    
    @IBOutlet weak var viewPayment: UIView!
    @IBOutlet weak var viewSyncWithContact: UIView!
    @IBOutlet weak var viewProphile: UIView!
    @IBOutlet weak var viewNotifications: UIView!
    @IBOutlet weak var viewBussines: UIView!
    
    //---
    @IBOutlet weak var viewPDTop: UIView!
    
    @IBOutlet weak var viewPDRight: UIView!
    @IBOutlet weak var viewPDButtom: UIView!
    
    @IBOutlet weak var viewPDLeft: UIView!
    //--------
    
    @IBOutlet weak var viewBRight: UIView!
    @IBOutlet weak var viewBLeft: UIView!
    @IBOutlet weak var viewBTop: UIView!
    @IBOutlet weak var viewBbuttom: UIView!
    //-----
    
    @IBOutlet weak var viewGDLeft: UIView!
    @IBOutlet weak var viewGDTop: UIView!
    
    @IBOutlet weak var viewGDRight: UIView!
    @IBOutlet weak var viewGDButtom: UIView!
    //---
    
    @IBOutlet weak var viewNButtom: UIView!
    @IBOutlet weak var viewNTop: UIView!
    
    @IBOutlet weak var viewNLeft: UIView!
    @IBOutlet weak var viewNRight: UIView!
    //----
    
    @IBOutlet weak var viewPLeft: UIView!
    @IBOutlet weak var viewPRight: UIView!
    @IBOutlet weak var viewPButton: UIView!
    @IBOutlet weak var viewPTop: UIView!
    override func viewDidLoad() {
      super.viewDidLoad()
        self.view.addBackground()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openUserDetails))
        self.viewPersonalDetails.addGestureRecognizer(tap)
        
        
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openLanguage))
        self.viewLanguage.addGestureRecognizer(tap1)
        
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openProphile))
        self.viewBussines.addGestureRecognizer(tap2)
        viewPDTop.layer.shadowColor = UIColor.black.cgColor
        viewPDTop.layer.shadowOpacity = 0.4
        viewPDTop.layer.shadowOffset = CGSize.zero
        viewPDTop.layer.shadowRadius = 1.5
        
        viewPDButtom.layer.shadowColor = UIColor.black.cgColor
        viewPDButtom.layer.shadowOpacity = 0.4
        viewPDButtom.layer.shadowOffset = CGSize.zero
        viewPDButtom.layer.shadowRadius = 1.5
        
        viewPDLeft.layer.shadowColor = UIColor.black.cgColor
        viewPDLeft.layer.shadowOpacity = 0.4
        viewPDLeft.layer.shadowOffset = CGSize.zero
        viewPDLeft.layer.shadowRadius = 1.5
        
        viewPDRight.layer.shadowColor = UIColor.black.cgColor
        viewPDRight.layer.shadowOpacity = 0.4
        viewPDRight.layer.shadowOffset = CGSize.zero
        viewPDRight.layer.shadowRadius = 1.5
        addShaddow(viewBTop)
        addShaddow(viewBbuttom)
        addShaddow(viewBLeft)
        addShaddow(viewBRight)
        
        addShaddow(viewGDTop)
        addShaddow(viewGDLeft)
        addShaddow(viewGDButtom)
        addShaddow(viewGDRight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func openUserDetails()
    {
        let viewCon:editUserDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "editUserDetailsViewController") as! editUserDetailsViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
    }

    @objc func openLanguage()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let frontviewcontroller:UINavigationController = UINavigationController()
        
        let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
        let vc = storyboardSupplierExist.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        
        frontviewcontroller.pushViewController(vc, animated: false)
        
        
        //initialize REAR View Controller- it is the LEFT hand menu.
        
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController

    }
    
    func addShaddow(_ view:UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 1.5
    }
    @objc func openProphile()
    {
        //        var storyboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        //        let viewCon:LanguageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LanguageViewController") as! LanguageViewController
        //        viewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
        //        self.presentViewController(viewCon, animated: true, completion: nil)
        
       // let storyboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        //        let viewCon:LanguageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LanguageViewController") as! LanguageViewController
        //
        //        navigationController.viewControllers = [viewCon]
        //
        //        self.presentViewController(navigationController, animated: true, completion: nil)
        
        //        let frontviewcontroller = storyboard.instantiateViewControllerWithIdentifier("navigation") as? UINavigationController
        //        let vc = storyboard.instantiateViewControllerWithIdentifier("LanguageViewController") as! LanguageViewController
        //        frontviewcontroller?.pushViewController(vc, animated: false)
        //
        //
        //        //initialize REAR View Controller- it is the LEFT hand menu.
        //
        //        let rearViewController = storyboard.instantiateViewControllerWithIdentifier("MenuTableViewController") as? MenuTableViewController
        //
        //        let mainRevealController = SWRevealViewController()
        //
        //        mainRevealController.frontViewController = frontviewcontroller
        //        mainRevealController.rearViewController = rearViewController
        //
        //        self.window!.rootViewController = mainRevealController
        //        self.window?.makeKeyAndVisible()
//        let frontviewcontroller:UINavigationController = UINavigationController()
//        
//        let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
//        let vc = storyboardSupplierExist.instantiateViewControllerWithIdentifier("LanguageViewController") as! LanguageViewController
//        
//        frontviewcontroller.pushViewController(vc, animated: false)
//        
//        
//        //initialize REAR View Controller- it is the LEFT hand menu.
//        
//        let rearViewController = storyboard.instantiateViewControllerWithIdentifier("MenuTableViewController") as? MenuTableViewController
//        
//        let mainRevealController = SWRevealViewController()
//        
//        mainRevealController.frontViewController = frontviewcontroller
//        mainRevealController.rearViewController = rearViewController
//        
//        let window :UIWindow = UIApplication.sharedApplication().keyWindow!
//        window.rootViewController = mainRevealController
        
        
//        let prophilDetails:BusinessDetailsViewController = storyboard.instantiateViewControllerWithIdentifier("BusinessDetailsViewController")as! BusinessDetailsViewController
//        self.presentViewController(prophilDetails, animated: true, completion: nil)
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
