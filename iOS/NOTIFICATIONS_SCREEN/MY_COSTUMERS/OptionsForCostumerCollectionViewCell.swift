//
//  OptionsForCostumerCollectionViewCell.swift
//  bthree-ios
//
//  Created by User on 21.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import CoreTelephony
protocol deleteItemInTableView{
    func deleteItem(_ indexPath:Int)
}
protocol closeCollectionDelegate{
    func closeCollection(_ collection:UICollectionView)
}

class OptionsForCostumerCollectionViewCell: UICollectionViewCell {
    var isocassional:Bool = false
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var delegate:deleteItemInTableView!=nil
      var delegateCloseCollectionDelegate:closeCollectionDelegate!=nil
        var viewDelegate:MyCostumersViewController!
    var generic:Generic = Generic()
  
    @IBOutlet weak var viewLeft: UIView!
    var indexPath:Int = 0
    var secton:Int = 0
    var row:Int = 0
    var item:Int = 0
    var coll:UICollectionView?
    @IBOutlet weak var imgOption: UIImageView!
    var storyB = UIStoryboard(name: "SupplierExist", bundle: nil)
    
    @IBOutlet weak var btnOpenOption: UIButton!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBAction func btnOpenOption(_ sender: AnyObject) {

        switch indexPath {
        
        case 1:
            let viewCon = storyB.instantiateViewController(withIdentifier: "DeleteCustomerViewController") as! DeleteCustomerViewController
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            viewCon.row = row
            viewCon.delegate = Global.sharedInstance.mycustomers
            viewCon.delegateCloseCollectionDelegate = Global.sharedInstance.mycustomers
            viewCon.coll = coll
            Global.sharedInstance.PresentViewMe?.present(viewCon, animated: true, completion: nil)
            return
        case 2:
          
            let customer:NSDictionary = (Global.sharedInstance.searchCostumersArray.object(at: row) as! NSDictionary) as NSDictionary
               print("ce sterge \(customer.description)")
            if let nvPhone:String = customer.object(forKey: "nvPhone") as? String {
                print ("nvPhone occasional customer: \(nvPhone)")
                Global.sharedInstance.makeCall(nvPhone as NSString)
            }
                  return
            
            case 3:
          
            let customer:NSDictionary = (Global.sharedInstance.searchCostumersArray.object(at: row) as! NSDictionary) as NSDictionary
            if let iCustomerUserId:Int =  customer.object(forKey: "iCustomerUserId") as? Int {
                let viewCon = self.storyB.instantiateViewController(withIdentifier: "CostumerAppointmentsViewController") as! CostumerAppointmentsViewController
                viewCon.row = self.row
                viewCon.ICUSTOMERID = iCustomerUserId
                if self.iOS8 {
                    viewCon.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                } else {
                    viewCon.modalPresentationStyle = UIModalPresentationStyle.currentContext
                }
                Global.sharedInstance.PresentViewMe?.present(viewCon, animated: true, completion: nil)
           }
            return
        case 4:
           
            let viewCon = storyB.instantiateViewController(withIdentifier: "DetailsCustomerViewController") as! DetailsCustomerViewController
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            viewCon.row = row
            if self.iOS8 {
                viewCon.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            } else {
                viewCon.modalPresentationStyle = UIModalPresentationStyle.currentContext
            }
            let customer:NSDictionary = (Global.sharedInstance.searchCostumersArray.object(at: row) as! NSDictionary) as NSDictionary
            print("ce are \(customer.description)")
            if let nvPhone:String = customer.object(forKey: "nvPhone") as? String {
                print ("nvPhone occasional customer: \(nvPhone)")
//                Global.sharedInstance.makeCall(nvPhone as NSString)
            }
            
            Global.sharedInstance.PresentViewMe?.present(viewCon, animated: true, completion: nil)
            return
            
        default:
            return
        }

    }
//just for reference not used
    func openUpdateView (_ MYiCustomerUserId:Int, txtVComment:String) {
        let viewCon:UpdateCustomerViewController = self.storyB.instantiateViewController(withIdentifier: "UpdateCustomerViewController") as! UpdateCustomerViewController
        viewCon.delegate = Global.sharedInstance.mycustomers
        viewCon.row = self.row
        viewCon.newiUserId = MYiCustomerUserId
        viewCon.SalvatnvSupplierRemark = txtVComment
        if self.iOS8 {
            viewCon.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            viewCon.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }

        Global.sharedInstance.PresentViewMe?.present(viewCon, animated: true, completion: nil)
    }
      func setDisplayData(_ imgName:String,desc:String,index:Int)
    {
        imgOption.image = UIImage(named: imgName)
        lblDescription.text = desc
        lblDescription.textAlignment = .center
        indexPath = index
        self.delegateCloseCollectionDelegate.closeCollection(self.coll!)
    }
}
