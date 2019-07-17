//
//  ExistProviderFirstViewController.swift
//  bthree-ios
//
//  Created by User on 10.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

//דף  ראשון של ספק (כעת קבע הרשאת עובדים)
class ExistProviderFirstViewController: NavigationModelViewController {
    
    
    
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    
    
    @IBOutlet weak var popoutTitleLabel: UILabel!
    
    @IBOutlet weak var lblNameProvider: UILabel!
    
    
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    
    @IBAction func btnUpdate(_ sender: AnyObject) {
        // self.dismissViewControllerAnimated(true, completion: nil)
        
        let storyboardSupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
        let viewCon = storyboardSupplierExist.instantiateViewController(withIdentifier: "EmployePermissionViewController") as! EmployePermissionViewController
        if self.iOS8 {
            viewCon.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            viewCon.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        let parent = self.presentingViewController
        print("parent\(parent)")
        self.dismiss(animated: true, completion: {
        parent!.present(viewCon, animated: true, completion: nil)
        })
    }
    
    @IBAction func btnNo(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
      //  self.view.removeFromSuperview()
    }
    override func viewDidLayoutSubviews() {
       
        //EMPLOYE_PERMISSIONS
        popoutTitleLabel.text = "POPUP_EMPLOYE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnUpdate.setTitle("YES".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnNo.setTitle("NO_THANKS".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        if let a = Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") {
            
            var dicSupplierName:Dictionary<String,String> = Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") as! Dictionary<String,String>
            
            
            lblNameProvider.text =  "WELCOME_PROVIDER".localized(LanguageMain.sharedInstance.USERLANGUAGE) + " " + dicSupplierName["nvSupplierName"]!
            print("a ... \(a)")
        }
        else{
            lblNameProvider.text =  "WELCOME_PROVIDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        //Global.sharedInstance.currentProvider.nvSupplierName
        
        if lblNameProvider.text?.characters.count > 25
        {
            lblNameProvider.font = UIFont(name: "OpenSansHebrew-Bold", size: 13)
            
        }
        else if lblNameProvider.text?.characters.count > 20
        {
            lblNameProvider.font = UIFont(name: "OpenSansHebrew-Bold", size: 16)
            
        }
        else if lblNameProvider.text?.characters.count > 10
        {
            lblNameProvider.font = UIFont(name: "OpenSansHebrew-Bold", size: 24)
        }

    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Global.sharedInstance.isFIRSTSUPPLIER = false
        
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
