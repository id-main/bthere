//
//  SmallInServiceCollectionViewCell.swift
//  bthree-ios
//
//  Created by User on 14.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class SmallInServiceCollectionViewCell: UICollectionViewCell {
    
    var delegate:showMoreInfoDelegate!=nil
    var myServiceName:String = ""
    var iServiceTime:Int = 0
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var btnOpen: UIButton!
    @IBOutlet weak var serviceWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var serviceHeightConstraint: NSLayoutConstraint!
    
    
    
    var index:Int = 0
    var pressedButton:Int =  0
    var delegateReloadTbl:reloadTblServiceDelegte!=nil
    var canbechecked:Bool  = false
    @IBAction func btnOpen(_ sender: AnyObject) {
        
        Global.sharedInstance.serviceName = ""
        
        if pressedButton == 1//מידע נוסף
        {
            //  delegate.showMoreInfo(index)
        }
        else if pressedButton == 2//בחירה מרובה
        {
            if self.tag == 0//לא בחור
            {
                if !Global.sharedInstance.arrayServicesKodsToServer.contains(Global.sharedInstance.arrayServicesKods[index])
                {
                    Global.sharedInstance.arrayServicesKodsToServer.append(Global.sharedInstance.arrayServicesKods[index])
                }
                
              //  if !Global.sharedInstance.multipleServiceName.contains(Global.sharedInstance.arrayServicesNames[index])
               // {
                    Global.sharedInstance.multipleServiceName.append(Global.sharedInstance.arrayServicesNames[index])
               // }
                
                Global.sharedInstance.numCellsCellected += 1
                
                Global.sharedInstance.indexCellSelected = index
                
                self.tag = 1
                Global.sharedInstance.isFirstCellSelected = false
                Global.sharedInstance.arrCellsMultiple[index] = true
                delegateReloadTbl.reloadTblService()
            }
            else//בחור-נהפך ללא בחור
            {
                if Global.sharedInstance.arrayServicesKodsToServer.contains(Global.sharedInstance.arrayServicesKods[index])
                {
                    let indexs = Global.sharedInstance.arrayServicesKodsToServer.index(of: Global.sharedInstance.arrayServicesKods[index])
                    Global.sharedInstance.arrayServicesKodsToServer.remove(at: indexs!)
                }
                
                if Global.sharedInstance.multipleServiceName.contains(Global.sharedInstance.arrayServicesNames[index])
                {
                    let indexs = Global.sharedInstance.multipleServiceName.index(of: Global.sharedInstance.arrayServicesNames[index])
                    Global.sharedInstance.multipleServiceName.remove(at: indexs!)
                }
                
                if Global.sharedInstance.numCellsCellected != 0
                {
                    Global.sharedInstance.numCellsCellected -= 1
                }
                self.tag = 0
                Global.sharedInstance.isFirstCellSelected = false
                Global.sharedInstance.arrCellsMultiple[index] = false
                if Global.sharedInstance.numCellsCellected == 0
                {
                    Global.sharedInstance.indexCellSelected = -1
                }
                
                delegateReloadTbl.reloadTblService()
            }
            print("what codes in 2 \(Global.sharedInstance.arrayServicesKodsToServer)")
        }
        else if pressedButton == 3 // && self.lblText.text != ""//הזמן
        {
            if Global.sharedInstance.multipleServiceName.count != 0//מבחירה מרובה
            {
                Global.sharedInstance.serviceName = ""
                for item in Global.sharedInstance.multipleServiceName
                {
                    if Global.sharedInstance.serviceName == ""
                    {
                        Global.sharedInstance.serviceName = item
                    }
                    else
                    {
                        Global.sharedInstance.serviceName = "\(Global.sharedInstance.serviceName), \(item)"
                    }
                }
            }
            else
            {
                Global.sharedInstance.serviceName = myServiceName//בחירה רגילה
            }
            
            Global.sharedInstance.indexRowForIdService = index
            if !Global.sharedInstance.arrayServicesKodsToServer.contains(Global.sharedInstance.arrayServicesKods[index])
            {
                Global.sharedInstance.arrayServicesKodsToServer.append(Global.sharedInstance.arrayServicesKods[index])
                print("what codes \(Global.sharedInstance.arrayServicesKodsToServer)")
            }
            
            delegate.showOdrerTurn()
        }
    }
    
    func setDisplayData(_ image:String,text:String,index:Int,serviceName:String,_canbechecked:Bool, _iServiceTime:Int) {
        self.iServiceTime = _iServiceTime
        if canbechecked == false {
        //    self.isUserInteractionEnabled = false
        }
        canbechecked = _canbechecked
        myServiceName = serviceName
        btnOpen.layer.borderColor = UIColor.black.cgColor
        btnOpen.layer.borderWidth = 1
        pressedButton = index
        
        img.image = UIImage(named: image)
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
        } else {
            serviceWidthConstraint.constant = 48 * 0.5
            serviceHeightConstraint.constant = 48 * 0.5
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
