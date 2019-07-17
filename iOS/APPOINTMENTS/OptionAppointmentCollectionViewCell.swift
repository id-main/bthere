//
//  OptionAppointmentCollectionViewCell.swift
//  Bthere
//
//  Created by User on 25.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class OptionAppointmentCollectionViewCell: UICollectionViewCell  {
    var indexPath:Int = 0
    var sectionNeeded:Int = 0
    var USERDICT:NSDictionary = NSDictionary()
    @IBOutlet weak var imgOption: UIImageView!
    var storyB = UIStoryboard(name: "SupplierExist", bundle: nil)
    
    @IBOutlet weak var btnOpenOption: UIButton!
    
    @IBAction func btnOpenOption(_ sender: AnyObject) {
        
        switch indexPath {
        case 1:
            var orderDictionary:NSDictionary = NSDictionary()
          //JMODE NOT USED ANYMORE  let viewCon = storyB.instantiateViewControllerWithIdentifier("DetailsAppointmentViewController") as! DetailsAppointmentViewController
            if Global.sharedInstance.myCustomerOrdersARRAY.count > 0 {
                if let _:NSDictionary = Global.sharedInstance.myCustomerOrdersARRAY[sectionNeeded] as? NSDictionary {
                   orderDictionary = Global.sharedInstance.myCustomerOrdersARRAY[sectionNeeded] as!NSDictionary
                       print("ddddd \(orderDictionary)")
               
           
           
            let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
            let frontviewcontroller:UINavigationController? = UINavigationController()
            let viewCon:detailsAppointmetsupplierViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "detailsAppointmetsupplierViewController") as! detailsAppointmetsupplierViewController
                viewCon.isfromLIST = false
                viewCon.APPOINMENT_DICT = orderDictionary
                viewCon.userAPPOINMENT_DICT = self.USERDICT as! NSMutableDictionary
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
            return
        case 2:
             print("cancel order")
              var orderDictionary:NSDictionary = NSDictionary()
           if Global.sharedInstance.myCustomerOrdersARRAY.count > 0 {
            if let _:NSDictionary = Global.sharedInstance.myCustomerOrdersARRAY[sectionNeeded] as? NSDictionary {
                orderDictionary = Global.sharedInstance.myCustomerOrdersARRAY[sectionNeeded] as!NSDictionary
                  print("ddddd \(orderDictionary)")
           let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
           let frontviewcontroller:UINavigationController? = UINavigationController()
           let viewCon:CancelAppointmentViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "CancelAppointmentViewController") as! CancelAppointmentViewController
           viewCon.USERDICT = self.USERDICT
           viewCon.CANCEL_DICT = orderDictionary
           viewCon.isfromLIST = false
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
            return
                default:
            return
        }
        
    }
    
    @IBOutlet weak var lblDescription: UILabel!
    
    
    func setDisplayData(_ imgName:String,desc:String,index:Int, sectiune:Int, MYUSERDICT:NSDictionary)
    {
        //        btnOpenOption.layer.borderWidth = 1
        //        btnOpenOption.layer.borderColor = UIColor.blackColor().CGColor
        imgOption.image = UIImage(named: imgName)
        lblDescription.text = desc
        indexPath = index
        sectionNeeded = sectiune
        self.USERDICT = MYUSERDICT
        
    }
    

}
