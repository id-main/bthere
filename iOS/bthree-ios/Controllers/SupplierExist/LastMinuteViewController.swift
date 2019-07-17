//
//  LastMinuteViewController.swift
//  BThere
//
//  Created by Eduard Stefanescu on 1/11/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit

class LastMinuteViewController: NavigationModelViewController, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {
    // Outlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var newOfferButton: UIButton!
    @IBOutlet var offersTable: UITableView!
    
    
    // Variables
    var storyB = UIStoryboard(name: "SupplierExist", bundle: nil)
    var delegate:openFromMenuDelegate! = nil
    var offersString: Array<String> = ["50% off on Highlight", "10% off on Men's Haircut", "On every Hair spray get a free Pocker mirror", "On every Blowout get free Hair-care oil", "Another offer", "Some other offer"]
    var offerStringExpended = ["1. This should be the text for the first one This is the latest NEW Windows 8.1 x64 U1 PE . This  portable apps  on ", "2. any new apps you need to the USB stick. New applications include Macrium Reflect, DiskCryptor,  Adobe Reader, Total Commander, FastStone Image Viewer & Java", "3. It’s a large download (1.8gb), so be patient it can take 20-40 minutes (depending on your internet speed) to downloa", "4. If you prefer to use the Portable Apps menu instead then run the Portable Apps Menu shortcut on the taskbar. ", "5. Front front front", "Roads are floating in the air"]
    
    var offersExpendedArray: Array<Bool> = [false, false, false, false, false, false]
    var rowinuseNeed:Int = 0
    
    // Constants
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Language
        titleLabel.text = "LAST_MINUTE_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        newOfferButton.setTitle("NEW_OFFER_BUTTON".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        self.offersTable.delegate = self
        self.offersTable.dataSource = self
        self.offersTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.offersTable.rowHeight = UITableView.automaticDimension
        self.offersTable.estimatedRowHeight = 20
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Close pop out
    @IBAction func closeButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // New new offer
    @IBAction func newOfferButton(_ sender: AnyObject) {
        let viewCon:NewOfferSupplierViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewOfferSupplierViewController") as! NewOfferSupplierViewController
        if self.iOS8 {
            viewCon.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            viewCon.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        self.present(viewCon, animated: true, completion: nil)
    }
    
    
    // Extend offers
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if offersExpendedArray[section] == true {
            return 2
        }
        return 1
    }
    
//        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//    
//            if offersExpendedArray[indexPath.section] == true  {
//                if indexPath.row == 0 {
//                      return 40
//                }
//                if indexPath.row == 1 {
//                    return UITableViewAutomaticDimension
//    
//                }
//            } else {
//                 return 60
//            }
//            return UITableViewAutomaticDimension
//    
//        }
    // Refresh table
        @objc func refreshTable() {
        self.offersTable.reloadData()
    }
    
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.offersString.count
    }
    
    
    // Create cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LastMinuteTableViewCell", for: indexPath) as! LastMinuteTableViewCell
        cell.viewDelegate = self
        cell.row = indexPath.section
        let rowinuse = indexPath.row
        let offername:String = offersString[indexPath.section]
        let dateoffer:String = "26.11.2018"
        var isexpanded = false
        var indexPathRow = 0
        let offerDetail:String = offerStringExpended[indexPath.section]
        
        if offersExpendedArray[indexPath.section] == true  {
            if  rowinuse == 0 {
                indexPathRow = 0
                isexpanded = true
                cell.setDisplayDataString(offername, _offerDetail: "", _dateoffer: dateoffer, _isexpanded: isexpanded, _indexPathRow:  indexPathRow)
            } else
                if  rowinuse == 1 {
                    indexPathRow = 1
                    isexpanded = true
                    cell.setDisplayDataString(offerDetail, _offerDetail: "", _dateoffer: "", _isexpanded: isexpanded, _indexPathRow:  indexPathRow)
            }
        } else {
            if  rowinuse == 0 {
                isexpanded = false
                indexPathRow = 0
                cell.setDisplayDataString(offername, _offerDetail: "", _dateoffer: dateoffer, _isexpanded: isexpanded, _indexPathRow:  indexPathRow)
            }
        }
        
        
        
        cell.tag =  indexPath.section
        let tapGuide:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didtapcell))
        tapGuide.delegate = self
        cell.addGestureRecognizer(tapGuide)
        closeCollection(cell.collItems)
        cell.collItems.reloadData()
        
        return cell
    }
    
    @objc func didtapcell(_ sender:UIGestureRecognizer) {
        let tag = sender.view!.tag
        let selectedrow = tag
        if offersExpendedArray[selectedrow] == true {
            offersExpendedArray = [false,false,false,false,false,false]
            
        } else {
            offersExpendedArray = [false,false,false,false,false,false]
            offersExpendedArray[selectedrow] = true
            
        }
        
        refreshTable()
    }
    
    
    func closeCollection(_ collection:UICollectionView) {
        let index:IndexPath = IndexPath(row:0, section: 0)
        collection.scrollToItem(at: index, at: UICollectionView.ScrollPosition.left, animated: false)
    }
    
    
    func openEditOffer(){
        print("Edit offer")
        
        let viewCon = storyB.instantiateViewController(withIdentifier: "NewOfferSupplierViewController") as! NewOfferSupplierViewController
        viewCon.isFromTable = true
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
    }
    
    
    // Remove row from table
    func removeOfferFromTable(_ row: Int, coll: UICollectionView) {
        print("Delete offer from table")
        
        if let _:String = offersString[row] {
            offersString.remove(at: row)
        }
        if let _:String = offerStringExpended[row] {
            offerStringExpended.remove(at: row)
        }
        if let _:Bool = offersExpendedArray[row] {
            offersExpendedArray.remove(at: row)
        }
        
        
        self.closeCollection(coll)
        Global.sharedInstance.isDeleted = false
        self.deleteItem(row)
    }
    
    
    func deleteItem(_ indexPath:Int){
        Global.sharedInstance.isDeleted = true
        
        //        if   let d:NSDictionary = (Global.sharedInstance.searchCostumersArray.objectAtIndex(indexPath) as? NSDictionary)! as NSDictionary {
        //            print("NSDictionary to delete \(d))")
        //            if let i:Int = Global.sharedInstance.nameCostumersArray.indexOfObject(d) as Int{
        //                //\\  print("Customer is at index \(i)")
        //                Global.sharedInstance.nameCostumersArray.removeObjectAtIndex(i)
        //                Global.sharedInstance.searchCostumersArray =  Global.sharedInstance.nameCostumersArray
        //                //TRY TO DELETE FROM SERVER TOO
        //                if let j:Int = d.objectForKey("iCustomerUserId") as? Int {
        //                    deleteCustomer(j)
        //                } else {
        //                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //                        self.tblCustomers.reloadData()
        //                    })
        //                }
        //            }
        //        }
        
        self.offersTable.reloadData()
    }
}
