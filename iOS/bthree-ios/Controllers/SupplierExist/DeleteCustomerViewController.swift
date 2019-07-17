//
//  DeleteCustomerViewController.swift
//  Bthere
//
//  Created by User on 2.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//
//provider PopUp deleting a customer //ספק קים פופאפ מחיקת לקוח
import UIKit

class DeleteCustomerViewController: UIViewController {
    
    var row:Int = 0
    var delegate:deleteItemInTableView!=nil
    var delegateCloseCollectionDelegate:closeCollectionDelegate!=nil
    var coll:UICollectionView?
    @IBOutlet weak var titlescreen: UILabel!
    @IBOutlet weak var messageareyousure: UILabel!
    @IBOutlet weak var lblNameCustomer: UILabel!
    @IBAction func btnClose(_ sender: UIButton) {
          self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var btnDeleteOk: UIButton!
    
    @IBAction func btnDeleteOk(_ sender: UIButton) {
        delegateCloseCollectionDelegate.closeCollection(coll!)
        Global.sharedInstance.isDeleted = false
        delegate.deleteItem(row)
        self.dismiss(animated: true, completion: nil)
  
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:43) 
        titlescreen.text = "DELETE_CUSTOMER_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        messageareyousure.text =  "DELETE_CUSTOMER_MESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnDeleteOk.setTitle("CONFIRM_BTN_DEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
      
       // btnDeleteOk.?.text =  "CONFIRM_BTN_DEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
  
          //\\print("CONFIRM_BTN_DEL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
      }
    override func viewDidLoad() {
        super.viewDidLoad()
        //JMODE + 20.01.2017
        titlescreen.text = "DELETE_CUSTOMER_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        messageareyousure.text =  "DELETE_CUSTOMER_MESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
      //  btnDeleteOk.titleLabel?.text =  "CONFIRM_BTN_DEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
           btnDeleteOk.setTitle("CONFIRM_BTN_DEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        if let _:NSDictionary = (Global.sharedInstance.searchCostumersArray.object(at: row) as! NSDictionary) as NSDictionary {
        let d:NSDictionary = (Global.sharedInstance.searchCostumersArray.object(at: row) as! NSDictionary) as NSDictionary
      //\\    print("ce sterge \(d.description)")
        if let cNAME:String = d.object(forKey: "nvFullName") as? String {
            lblNameCustomer.text = cNAME
        } else {
            lblNameCustomer.text = ""
        }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
}
