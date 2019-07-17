//
//  SupplierCustomerViewController.swift
//  bthree-ios
//
//  Created by User on 10.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//ספק קיים (לבדוק אם משתמשים)
class SupplierCustomerViewController: UIViewController {
    
    var generic:Generic = Generic()
    @IBOutlet weak var viewSupplierCustomer: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    
    var supplierStoryBoard:UIStoryboard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        
        self.navigationController?.isNavigationBarHidden = true
        
        if Global.sharedInstance.isProvider == true
        {
            viewSupplierCustomer.backgroundColor = Colors.sharedInstance.color3
            
            if Global.sharedInstance.defaults.value(forKey: "currentClintName") != nil {
                
                var dicClientName:Dictionary<String,String> = Global.sharedInstance.defaults.value(forKey: "currentClintName") as! Dictionary<String,String>
                
                lblName.text = dicClientName["nvClientName"]//Global.sharedInstance.currentUser.nvFirstName
                
            }
            else
            {
                lblName.text = ""
            }
        }
        else
        {
            viewSupplierCustomer.backgroundColor = Colors.sharedInstance.color4
            
            
            if Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil {
                
                var dicSupplierName:Dictionary<String,String> = Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") as! Dictionary<String,String>
                
                lblName.text = dicSupplierName["nvSupplierName"]
                //Global.sharedInstance.currentProvider.nvSupplierName
            }
            else
            {
                lblName.text = ""
            }
        }

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openNextVC))
        viewSupplierCustomer.addGestureRecognizer(tap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func openNextVC() {
        if Global.sharedInstance.isProvider == true
        {
            Global.sharedInstance.isProvider = false
            Global.sharedInstance.whichReveal = false
         
            let frontviewcontroller = storyboard!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
            let vc = storyboard!.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
            frontviewcontroller?.pushViewController(vc, animated: false)
            
            
       //initialize REAR View Controller- it is the LEFT hand menu.
            let rearViewController = storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            
            let mainRevealController = SWRevealViewController()
            
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
   
        }
        else
        {
            Global.sharedInstance.isProvider = true
            
            let frontviewcontroller = storyboard!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
            let vc = supplierStoryBoard!.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as! CalendarSupplierViewController
            frontviewcontroller?.pushViewController(vc, animated: false)
            
// initialize REAR View Controller- it is the LEFT hand menu.
 
            let rearViewController = storyboard!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            
            let mainRevealController = SWRevealViewController()
            
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController            
        }
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
