//
//  LastMinuteTableOptions.swift
//  BThere
//
//  Created by Eduard Stefanescu on 1/30/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit
import CoreTelephony
protocol deleteItemInLastMinuteTableView{
    func deleteItem(_ indexPath:Int)
}

protocol closeCollectionLastMinuteDelegate{
    func closeCollection(_ collection:UICollectionView)
}

class LastMinuteTableOptions: UICollectionViewCell {
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var delegate:deleteItemInLastMinuteTableView!=nil
    var delegateCloseCollectionDelegate:closeCollectionLastMinuteDelegate!=nil
    var viewDelegate:LastMinuteViewController!
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

            return
        case 2:
            

            
            return
        case 3:

            
            return
        case 4:
            
 
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
        //        btnOpenOption.layer.borderWidth = 1
        //        btnOpenOption.layer.borderColor = UIColor.blackColor().CGColor
        imgOption.image = UIImage(named: imgName)
        lblDescription.text = desc
        // lblDescription.sizeToFit()
        lblDescription.textAlignment = .center
        indexPath = index
        self.delegateCloseCollectionDelegate.closeCollection(self.coll!)
        // self.setNeedsDisplay()
        
    }
    
}

