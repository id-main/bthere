//
//  slaightLateViewController.swift
//  BThere
//
//  Created by Racheli Kroiz on 30.11.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class slaightLateViewController: UIViewController {
    // Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var popVIEW:UIView!
    @IBOutlet var popConstraint: NSLayoutConstraint!
    

    //MARK - Variables
    var serviceName = ""
    var date = ""
    var hour = ""
    var service = ""
    var iCoordinatedServiceId:Int = 0
    var iSupplierId:Int = 0
    var nvPhone:String = ""
    // Constants
    let dateFormatter = DateFormatter()
    let dateFormatter2 = DateFormatter()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:17)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print( iSupplierId)
        if UIDevice.current.userInterfaceIdiom == .pad {
          popConstraint.constant = 75
            
            // Update font size
            lblDesc.font = UIFont(name: lblDesc.font.fontName, size: 18)
            lblDate.font = UIFont(name: lblDate.font.fontName, size: 18)
            lblService.font = UIFont(name: lblService.font.fontName, size: 18)
            lblServiceName.font = UIFont(name: lblServiceName.font.fontName, size: 18)
            lblHour.font = UIFont(name: lblHour.font.fontName, size: 18)
        } else {
           popConstraint.constant = 75
            
            // Update font size
            lblDesc.font = UIFont(name: lblDesc.font.fontName, size: 16)
            lblDate.font = UIFont(name: lblDate.font.fontName, size: 16)
            lblService.font = UIFont(name: lblService.font.fontName, size: 16)
            lblServiceName.font = UIFont(name: lblServiceName.font.fontName, size: 16)
            lblHour.font = UIFont(name: lblHour.font.fontName, size: 16)
        }
        
        // Set date format
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter2.dateFormat = "hh:mm"
        
        // Get service name
        for item in Global.sharedInstance.orderDetailsFoBthereEvent.objProviderServiceDetails {
            if serviceName == "" {
                serviceName = item.nvServiceName
            } else {
                serviceName = "\(serviceName),\(item.nvServiceName)"
            }
        }
        
        lblTitle.text = "SLAIGHT_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnOk.setTitle("CONTINUE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        lblDesc.text = "ASK_SLAIGHT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        // lblServiceName.text = Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName
        // lblHour.text = hour
        lblDate.text = dateFormatter.string(from: Global.sharedInstance.dateEventBthereClick as Date)
        lblService.text = serviceName
        
        
        lblServiceName.text = Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName
//        
//       let myString:String = Global.sharedInstance.orderDetailsFoBthereEvent.nvToHour
//        Global.sharedInstance.getStringFromDateString(myString)
        
        print("eventBthereDateStart: \(Global.sharedInstance.eventBthereDateStart)")
        print("eventBthereDateEnd: \(Global.sharedInstance.eventBthereDateEnd)")
        print("hourBthereEvent: \(Global.sharedInstance.hourBthereEvent)")
        
        
        let goDateString:String! = Global.sharedInstance.orderDetailsFoBthereEvent.nvToHour
        
        print("\(goDateString ?? "goDateString") ")
        let datamea:Date = Global.sharedInstance.getStringFromDateString(goDateString)
        let calendar = Foundation.Calendar.current
        let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: datamea)
        let hourS = componentsStart.hour
        let minuteS = componentsStart.minute
        var hourS_Show:String = hourS!.description
        var minuteS_Show:String = minuteS!.description
        
        
        if hourS! < 10
        {
            hourS_Show = "0" + hourS_Show
        }
       
        if minuteS! < 10
        {
            minuteS_Show = "0" +   minuteS_Show
        }
       
        
        let st =  "\(hourS_Show):\(minuteS_Show)"
        
        lblHour.text = Global.sharedInstance.hourBthereEvent + " - " + st
        
        
        /////////
        if (hour != "" && hour != " ") {
            lblHour.text = hour
         //   lblServiceName.text = serviceName
            lblService.text = service
            lblDate.text = date
        }
        
        print("###############################################")
        print("ProviderName: \(Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName)")
        print("date: \(date)")
        print("hour: \(hour)")
        print("service: \(service)")
        print("self.iCoordinatedServiceId \(self.iCoordinatedServiceId)")
        print("nvPhone \(nvPhone)")
        print("###############################################")
        self.view.bringSubviewToFront(btnOk)
        print("popview height \(popVIEW.frame.size.height) si y pt buton ok \(btnOk.frame.origin.y)")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnCancel(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func btnOk(_ sender: AnyObject) {
        Alert.sharedInstance.showAlert("SHORT_DELAY_MESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        
        // SendPushNotificationFromCustomerWhenCustomerIsLate
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController

        let vc = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        
        
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
        window.makeKeyAndVisible()
        
        self.sendNotification()
    }
    
    func sendNotification () {
        var dictosend:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dictosend["iCoordinatedServiceId"] = self.iCoordinatedServiceId as AnyObject //Global.sharedInstance.orderDetailsFoBthereEvent.iCoordinatedServiceId
        dictosend["message"] = "" as AnyObject
        dictosend["iPhoneOsType"] = 1 as AnyObject
        if Reachability.isConnectedToNetwork() == false {
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            api.sharedInstance.SendPushNotificationFromCustomerWhenCustomerIsLate(dictosend, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                
                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                    let coolMessage = "SHORT_DELAY_MESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    let refreshAlert = UIAlertController(title: "", message: coolMessage, preferredStyle: UIAlertController.Style.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        Global.sharedInstance.isProvider = false
                        Global.sharedInstance.whichReveal = false
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                        let vc = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
                        frontviewcontroller?.pushViewController(vc, animated: false)
                        
                        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                        let mainRevealController = SWRevealViewController()
                        mainRevealController.frontViewController = frontviewcontroller
                        mainRevealController.rearViewController = rearViewController
                        
                        let window :UIWindow = UIApplication.shared.keyWindow!
                        window.rootViewController = mainRevealController
                        window.makeKeyAndVisible()
                    }))
                } else {
                    // Something is wrong
                    self.showAlertDelegateX("SHORT_DELAY_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                    }
                }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
   
}
