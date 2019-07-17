//
//  LastMinuteForCollectionCell.swift
//  BThere
//
//  Created by Eduard Stefanescu on 1/15/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit
import CoreTelephony

//protocol deleteItemInTableView{
//    func deleteItem(indexPath:Int)
//}
//
//protocol closeCollectionDelegate{
//    func closeCollection(collection:UICollectionView)
//}

class LastMinuteForCollectionCell: UICollectionViewCell {
    // Outlets
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var imgOption: UIImageView!
    @IBOutlet weak var btnOpenOption: UIButton!
    
    
    // Constants
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    
    
    // Variables
    var delegate:deleteItemInTableView!=nil
    var delegateCloseCollectionLastMinuteDelegate:closeCollectionLastMinuteDelegate!=nil
    var viewDelegate:LastMinuteViewController!
    var generic:Generic = Generic()
    var indexPath:Int = 0
    var secton:Int = 0
    var row:Int = 0
    var item:Int = 0
    var coll:UICollectionView?
    var storyB = UIStoryboard(name: "SupplierExist", bundle: nil)
    
    
    @IBAction func btnOpenOption(_ sender: AnyObject) {
        print(indexPath)
        
        if (indexPath == 1) {
            // Edit
            self.viewDelegate.openEditOffer()
        } else if (indexPath == 2) {
            // Delete
            
            print("row \(row)")
            print("coll \(coll)")
            
            self.viewDelegate.removeOfferFromTable(row, coll: coll!)
        }
    }
    
    
    func setDisplayData(_ imgName:String, index:Int, offerRow:Int, offerColl:UICollectionView) {
        imgOption.image = UIImage(named: imgName)
        indexPath = index
        row = offerRow
        coll = offerColl
    }
}

