//
//  ItemInCollectionInSection1CollectionViewCell.swift
//  bthree-ios
//
//  Created by User on 23.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
protocol putSubDelegate{
    func putSub(_ tag:Int)
    func scrollTotop()
}
class ItemInCollectionInSection1CollectionViewCell: UICollectionViewCell {
    
    var delegate:putSubDelegate! = nil
    
    @IBOutlet weak var lblDescSubject: UILabel!
    @IBOutlet var btnCheck: CheckBox!
    
    @IBAction func btnChek(_ sender: CheckBox) {
       
        if !btnCheck.isCecked
        {
           Global.sharedInstance.fDomain = true
          
       // 
            
        
            delegate.scrollTotop()
           delegate.putSub(sender.tag)
            
        }
        else
        {
            Global.sharedInstance.headersCellRequired[0] = false
            Global.sharedInstance.domainBuisness = ""
            Global.sharedInstance.fDomain = false
        }
    }
    
    
    func setDisplayData(_ sub:String){
        lblDescSubject.text = sub
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            lblDescSubject.font = UIFont(name: "OpenSansHebrew-Light", size:12.5)
        }
    }
    
    
} 
