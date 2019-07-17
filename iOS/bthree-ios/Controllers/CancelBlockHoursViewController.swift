//
//  CancelBlockHoursViewController.swift
//  BThere
//
//  Created by Ioan Ungureanu on 14/05/2018
//  Copyright © 2018 BThere. All rights reserved.
//

import UIKit

class CancelBlockHoursViewController: UIViewController {
    // Outlets
    var ISFROMCALENDARVIEW = true
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet var popConstraint: NSLayoutConstraint!
    //MARK - Variables
    var generic:Generic = Generic()
    var delegateDel:reloadAllAfterDelete! = nil
    var date = ""
    var iServiceProviderCalendarId:Int = 0
    var iProviderUserId:Int = 0
    var dDate:String = ""
    var ISFROMBLOCKTABLE:Bool = false


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:34)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            popConstraint.constant = 75
            lblDesc.font = UIFont(name: lblDesc.font.fontName, size: 18)
            lblDate.font = UIFont(name: lblDate.font.fontName, size: 18)
        } else {
            popConstraint.constant = 75
            lblDesc.font = UIFont(name: lblDesc.font.fontName, size: 16)
            lblDate.font = UIFont(name: lblDate.font.fontName, size: 16)
        }
        lblTitle.text = "CANCEL_BLOCK_HOURES".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnOk.setTitle("CONTINUE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        lblDesc.text = "YOU_CHOOSE_TO_CANCEL_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblDate.text = date
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnCancel(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    func rereadcalendar() {
        Global.sharedInstance.isProvider = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SupplierExist = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        let viewCon = SupplierExist.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as!  CalendarSupplierViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        frontViewController.pushViewController(viewCon, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontViewController
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    
    @IBAction func btnOk(_ sender: AnyObject) {
          self.RemoveBlockedHouresFromCalendar()
    }
    
    func RemoveBlockedHouresFromCalendar () {
        var dictosend:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
      
        let myarr:NSMutableArray = []
        myarr.add(self.iServiceProviderCalendarId)
        dictosend["iServiceProviderCalendarId"] = myarr as AnyObject
        dictosend["iProviderUserId"] = self.iProviderUserId as AnyObject
        dictosend["dDate"] = self.dDate as AnyObject
        
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            
            api.sharedInstance.RemoveBlockedHouresFromCalendar(dictosend, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                    print(RESPONSEOBJECT)
                    
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                
                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                    let coolMessage = "SUCCES_CANCEL_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    let refreshAlert = UIAlertController(title: "", message: coolMessage, preferredStyle: UIAlertController.Style.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    if  self.ISFROMCALENDARVIEW == false {

                        self.dismiss(animated: false, completion: {
                            self.delegateDel.reloadall()
                        })
                    }
                    else {
                        self.dismiss(animated: false, completion: {
                            self.rereadcalendar()
                        })
                  
                        }
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                } else {
                    // Something is wrong
                    let coolMessage = "FAIL_CANCEL_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    let refreshAlert = UIAlertController(title: "", message: coolMessage, preferredStyle: UIAlertController.Style.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        self.dismiss(animated: false, completion: nil)
                     
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)

                }
                    }
                }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
}
