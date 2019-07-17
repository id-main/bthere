//
//  OpenRowListCollectionViewCell.swift
//  Bthere
//
//  Created by User on 23.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class OpenRowListCollectionViewCell: UICollectionViewCell {
    var delegate:openFromMenuDelegate!=nil
    @IBOutlet weak var lblText: UILabel!
    var ClientDict:NSDictionary = NSDictionary()
    @IBOutlet weak var imgIcon: UIImageView!
    var dateTurn:String = ""
    var hourTurn:String = ""
    var EVENT_DICT:allKindEventsForListDesign = allKindEventsForListDesign()
    @IBOutlet weak var btnOpen: UIButton!
    
    var storyB = UIStoryboard(name: "SupplierExist", bundle: nil)
    
    @IBAction func btnOpen(_ sender: AnyObject) {
        switch indexPath {
        case 1://פרטי התור
            let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
            let frontviewcontroller:UINavigationController? = UINavigationController()
            let viewCon:detailsAppointmetsupplierViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "detailsAppointmetsupplierViewController") as! detailsAppointmetsupplierViewController
            
       //     viewCon.APPOINMENT_DICT = self.APPOINMENT_DICT
            viewCon.isfromLIST = true
            viewCon.EVENT_DICT = self.EVENT_DICT
            let userdict:NSDictionary = self.ClientDict
            viewCon.userAPPOINMENT_DICT = userdict as! NSMutableDictionary
            //\\JMODE TODO viewCon.userAPPOINMENT_DICT = self.USERDICT
            
            frontviewcontroller!.pushViewController(viewCon, animated: false)
            //initialize REAR View Controller- it is the LEFT hand menu.
            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
            let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController

        
        
        case 2://ביטול התור
            Global.sharedInstance.isCancelAppointmentClick = true
            let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
            let frontviewcontroller:UINavigationController? = UINavigationController()
            let viewCon:CancelAppointmentViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "CancelAppointmentViewController") as! CancelAppointmentViewController
                viewCon.USERDICT = self.ClientDict
                viewCon.EVENT_DICT = self.EVENT_DICT
                viewCon.isfromLIST = true
            frontviewcontroller!.pushViewController(viewCon, animated: false)
            //initialize REAR View Controller- it is the LEFT hand menu.
            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
            let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            let mainRevealController = SWRevealViewController()
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
            return
        case 3://חייג   call
            let clientInfo:NSDictionary = ClientDict
            if let nvPhone:String = clientInfo.object(forKey: "nvPhone") as? String {
                //\\print ("nvPhone \(nvPhone)")
                Global.sharedInstance.makeCall(nvPhone as NSString)
            }
        //    return
        default:
            return
        }
    }

    var indexPath:Int = 0
    
    func setDisplayData(_ text:String,img:String,index:Int, MYClientDict:NSDictionary, cancelEVENT_DICT:allKindEventsForListDesign) {
        lblText.text = text
        imgIcon.image = UIImage(named: img)
        indexPath = index
        ClientDict = MYClientDict
        EVENT_DICT = cancelEVENT_DICT
        //\\print ("SELF.ClientDict  \(ClientDict) EVENT_DICT \(EVENT_DICT)")
        }
}
