//
//  CancelAppointmentClientViewController.swift
//  BThere
//
//  Created by Racheli Kroiz on 30.11.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class CancelAppointmentClientViewController: UIViewController {
    // Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet var popConstraint: NSLayoutConstraint!
    
    
    // Variables
    var iSupplierId:Int = 0
    var serviceName = ""
    var providername = ""
    var date = ""
    var hour = ""
    var service = ""
    var idTurn = Global.sharedInstance.orderDetailsFoBthereEvent.iCoordinatedServiceId
    var tag:Int = 0
    var hourS = ""
    var isFromMyMeetings: Bool = false
    var appointmentTime: String = ""
    var appointmentID: Int = 0
    var nvPhone:String = ""
    // Constants
    let dateFormatter = DateFormatter()
    let dateFormatter2 = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("iSupplierId \(iSupplierId)")
        print("nvPhone \(nvPhone)")
        print("#########################################################")
        print("serviceName \(serviceName)")
        print("date \(date)")
        print("hour \(hour)")
        print("service \(service)")
        print("idTurn \(idTurn)")
        print("tag \(tag)")
        print("#########################################################")
        
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
        
        print("Final tag is: \(tag)")
        
        lblTitle.text = "CANCELAPPOINTMENT_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnOk.setTitle("CONTINUE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        lblDesc.text = "CHOOSE_CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        // Set date format
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter2.dateFormat = "hh:mm"
        
        if (isFromMyMeetings == true) {
            lblServiceName.text = Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName
            lblService.text = service
            lblHour.text = date
            lblDate.text = appointmentTime
            idTurn = appointmentID
        } else {
            
            if (tag == 0) {
                // Get service name
                for item in Global.sharedInstance.orderDetailsFoBthereEvent.objProviderServiceDetails {
                    if serviceName == "" {
                        serviceName = item.nvServiceName
                    } else {
                        serviceName = "\(serviceName),\(item.nvServiceName)"
                    }
                }
                // let myString:String = Global.sharedInstance.orderDetailsFoBthereEvent.nvToHour
                
                // Set cancel appointment text
                lblServiceName.text = Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName // Supplier name
                lblHour.text = dateFormatter.string(from: Global.sharedInstance.dateEventBthereClick as Date) // Date
                


                
                print("eventBthereDateStart: \(Global.sharedInstance.eventBthereDateStart)")
                print("eventBthereDateEnd: \(Global.sharedInstance.eventBthereDateEnd)")
                print("hourBthereEvent: \(Global.sharedInstance.hourBthereEvent)")
                print("houreNDBthereEvent: \(Global.sharedInstance.orderDetailsFoBthereEvent.nvToHour)")
                
                let goDateString:String! = Global.sharedInstance.orderDetailsFoBthereEvent.nvToHour
                
                //                print(goDateString)
                //                let datamea:Date = Global.sharedInstance.getStringFromDateString(goDateString)
                //                let calendar = Foundation.Calendar.current
                //                let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: datamea)
                //                let hourS = componentsStart.hour
                //                let minuteS = componentsStart.minute
                //                var hourS_Show:String = hourS!.description
                //                var minuteS_Show:String = minuteS!.description
                //
                //
                //                if hourS! < 10
                //                {
                //                    hourS_Show = "0" + hourS_Show
                //                }
                //
                //                if minuteS! < 10
                //                {
                //                    minuteS_Show = "0" +   minuteS_Show
                //                }
                //

                //             let st =  "\(hourS_Show):\(minuteS_Show)"
                
                lblDate.text = Global.sharedInstance.hourBthereEvent + " - " + goDateString
                
                
                lblService.text = service // Service name
                
                // Check if Hebrew language
                if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                    
                }
            } else {
                lblServiceName.text = Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName
                lblService.text = service
                lblHour.text = date
                lblDate.text = hour
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnCancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnOk(_ sender: AnyObject) {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iCoordinatedServiceId"] = idTurn as AnyObject
        api.sharedInstance.CancelOrder(dic,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in     //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                        let alertController = UIAlertController(title: "", message:
                            "SUCCESS_CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                        self.present(alertController, animated: true, completion: nil)
                        let when = DispatchTime.now() + 3
                        DispatchQueue.main.asyncAfter(deadline: when){
                            alertController.dismiss(animated: true, completion: {
                                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.dismiss(animated: false, completion: {
                                        Global.sharedInstance.isInMeetingProcess = 0
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        Global.sharedInstance.isProvider = false
                                        Global.sharedInstance.whichReveal = false
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
                                    })
                                })
                            })
                        }

                    } else {
                        let alertController = UIAlertController(title: "", message:
                            "APPOINTMENT_CANCEL_IMPOSSIBLE".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                        self.present(alertController, animated: true, completion: nil)
                        let when = DispatchTime.now() + 3
                        DispatchQueue.main.asyncAfter(deadline: when){
                            alertController.dismiss(animated: true, completion: {
                                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.dismiss(animated: false, completion: {
                                        Global.sharedInstance.isInMeetingProcess = 0
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        Global.sharedInstance.isProvider = false
                                        Global.sharedInstance.whichReveal = false
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
                                    })
                                })
                            })
                        }
                    }

                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            //            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
}
