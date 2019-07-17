//
//  CancelAppointmentViewController.swift
//  Bthere
//
//  Created by User on 24.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

//ספק קיים:ביטול תור
class CancelAppointmentViewController: UIViewController,UITextViewDelegate,UIGestureRecognizerDelegate {
    var generic:Generic = Generic()
    //MARK: - Properties
    var nvUsername = ""
    var dateTurn = ""
    var hourTurn = ""
    var dayweek = ""
    let dateFormatter = DateFormatter()
    //MARK: - Outlet
    var isfromLIST:Bool = false
    var USERDICT:NSDictionary = NSDictionary()
    var CANCEL_DICT:NSDictionary = NSDictionary()
    var EVENT_DICT:allKindEventsForListDesign = allKindEventsForListDesign()
    let calendar = Foundation.Calendar.current
    @IBOutlet weak var lblHourTurn: UILabel!
    @IBOutlet weak var titlescreen: UILabel!
    @IBOutlet weak var messagescreen: UILabel!
    @IBOutlet weak var lblDateTurn: UILabel!
    @IBOutlet weak var lbldayofweek: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var txtComment: UITextView!
    
    @IBAction func btnClose(_ sender: AnyObject) {
        if self.isfromLIST == false {
            openMycustomers()
        } else {
            openCalendar()
        }
    }
    @IBAction func btncancel(_ sender: AnyObject) {
        var iCoordinatedServiceId:Int = 0
        if self.isfromLIST == false {
            if let _:Int =  CANCEL_DICT.object(forKey: "iCoordinatedServiceId") as? Int
            {
                iCoordinatedServiceId = CANCEL_DICT.object(forKey: "iCoordinatedServiceId") as! Int
            }
        } else {
            if let _:Int =  EVENT_DICT.iCoordinatedServiceId as Int?
            {
                iCoordinatedServiceId = EVENT_DICT.iCoordinatedServiceId
            }
        }
        
        print("iCoordinatedServiceId\(iCoordinatedServiceId)")
        if iCoordinatedServiceId != 0 {
            self.cancelOrder(iCoordinatedServiceId)
        }
    }
    
    //MARK: - Initial
    
    @objc func dismissKeyBoard() {
        
        view.endEditing(true)
    }
    override func viewDidLoad() {
        let tapKeyBoard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
        tapKeyBoard.delegate = self
        self.view.addGestureRecognizer(tapKeyBoard)
        super.viewDidLoad()
        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS
        {
            lbldayofweek.font = UIFont(name: lbldayofweek.font.fontName, size: 14)
            lblDateTurn.font = UIFont(name: lblDateTurn.font.fontName, size: 14)
            lblHourTurn.font = UIFont(name: lblHourTurn.font.fontName, size: 14)
        }
        
        self.txtComment.delegate = self
        btncancel.setTitle("CONFIRM_BTN_DEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        self.titlescreen.text = "TITLE_CANCEL_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        let DESCR:String = "DESCRIPTION_CANCEL_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        //JMODE + MASSIVE MODE JMODE + MASSIVE MODE JMODE + MASSIVE MODE JMODE + MASSIVE MODE JMODE + MASSIVE MODE JMODE + MASSIVE MODE
        if self.isfromLIST == false {
            print("USERDICT cancel\(USERDICT) CANCEL_DICT \(CANCEL_DICT)")
            
            if let nvFullName:String =  USERDICT.object(forKey: "nvFullName") as? String
            {
                nvUsername = nvFullName
                print("nvFullName\(nvFullName)")
            }
            self.messagescreen.text = DESCR + nvUsername
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            var STRdtDateOrder:Date = Date()
            
            if let ORDERDATE =  CANCEL_DICT.object(forKey: "dtDateOrder") as? String
            {
                STRdtDateOrder = Global.sharedInstance.getStringFromDateString(ORDERDATE)
                print("STRdtDateOrder\(STRdtDateOrder)")
            }
            var STRStartDate:Date = Date()
            var STREndDate:Date = Date()
            if let nvFromHour =  CANCEL_DICT.object(forKey: "nvFromHour") as? String
            {
                STRStartDate = Global.sharedInstance.getStringFromDateString(nvFromHour)
                print("STRStartDate\(STRStartDate)")
            }
            if let nvToHour =  CANCEL_DICT.object(forKey: "nvToHour") as? String
            {
                STREndDate = Global.sharedInstance.getStringFromDateString(nvToHour)
                print("STREndDate\(STREndDate)")
            }
            
            let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: STRStartDate)
            
            let componentsEnd = (calendar as NSCalendar).components([.hour, .minute], from: STREndDate)
            
            
            let hourS = componentsStart.hour
            let minuteS = componentsStart.minute
            
            let hourE = componentsEnd.hour
            let minuteE = componentsEnd.minute
            
            var hourS_Show:String = hourS!.description
            var hourE_Show:String = hourE!.description
            var minuteS_Show:String = minuteS!.description
            var minuteE_Show:String = minuteE!.description
            
            if hourS! < 10
            {
                hourS_Show = "0" + hourS_Show
            }
            if hourE! < 10
            {
                hourE_Show = "0" + hourE_Show
            }
            if minuteS! < 10
            {
                minuteS_Show = "0" +   minuteS_Show
            }
            if minuteE! < 10
            {
                minuteE_Show = "0" + minuteE_Show
            }
            let st =  "\(hourS_Show):\(minuteS_Show) - \(hourE_Show):\(minuteE_Show)"
            
            lblHourTurn.text = hourTurn
            lblDateTurn.text = dateTurn
            
            lblDateTurn.text = dateFormatter.string(from: STRdtDateOrder)
            lblHourTurn.text = st
            let dayWeek = Calendar.sharedInstance.getDayOfWeek(STRdtDateOrder)
            
            let dayInWeek = DateFormatter().weekdaySymbols[dayWeek! - 1]
            lbldayofweek.text = dayInWeek
        } else {
            var STRdtDateOrder:Date = Date()
            print("USERDICT cancel\(USERDICT) CANCEL_DICT \(EVENT_DICT)")
            if let nvFullName:String =  EVENT_DICT.ClientnvFullName  as String?
            {
                nvUsername = nvFullName
                print("nvFullName\(nvFullName)")
            } else {
                if let nvFullName:String =  USERDICT.object(forKey: "nvFullName") as? String
                {
                    nvUsername = nvFullName
                    print("nvFullName\(nvFullName)")
                }
            }
            self.messagescreen.text = DESCR + nvUsername
            dateFormatter.dateFormat = "dd/MM/yyyy"
            var STRdtDateEvent = ""
            if let ORDERDATE:Date =  EVENT_DICT.dateEvent as Date?
            {
                STRdtDateEvent = dateFormatter.string(from: ORDERDATE)
                STRdtDateOrder = ORDERDATE
                print("STRdtDateOrder\(STRdtDateEvent)")
            }
            
            var STRStartDate:String = ""
            var STREndDate = ""
            print("EVENT_DICT.fromHour\(EVENT_DICT.fromHour)")
            if let nvFromHour:String =  EVENT_DICT.fromHour as String?
            {
                STRStartDate = nvFromHour
                print("STRStartDate\(STRStartDate)")
            }
            if let nvToHour:String =  EVENT_DICT.toHour as String?
            {
                STREndDate = nvToHour
                print("STREndDate\(STREndDate)")
                
            }
            let st = "\(STRStartDate) - \(STREndDate)"
            lblHourTurn.text = hourTurn
            lblDateTurn.text = dateTurn
            
            lblDateTurn.text = dateFormatter.string(from: STRdtDateOrder)
            lblHourTurn.text = st
            let dayWeek = Calendar.sharedInstance.getDayOfWeek(STRdtDateOrder)
            
            let dayInWeek = DateFormatter().weekdaySymbols[dayWeek! - 1]
            lbldayofweek.text = dayInWeek
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openCalendar() {
        self.dismissKeyBoard()
        let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        Global.sharedInstance.isProvider = true
        
        let viewCon = storyBoard.instantiateViewController(withIdentifier: "CalendarSupplierViewController") as!  CalendarSupplierViewController
        self.navigationController?.pushViewController(viewCon, animated: false)
    }
    func openMycustomers() {
        self.dismissKeyBoard()
        Global.sharedInstance.whichReveal = true
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let viewCon = storyBoard.instantiateViewController(withIdentifier: "MyCostumersViewController") as!  MyCostumersViewController
        Global.sharedInstance.isProvider = true
        frontviewcontroller!.pushViewController(viewCon, animated: false)
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    func cancelOrder(_ idTurn:Int) {
        self.dismissKeyBoard()
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iCoordinatedServiceId"] = idTurn as AnyObject
        api.sharedInstance.CancelOrder(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in      //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.showAlertDelegateX("SUCCESS_CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        })
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        })
                    }
                }
            }
            if self.isfromLIST == false {
                self.dismiss(animated: false, completion: {
                self.openMycustomers()
                })
            } else {
                 self.dismiss(animated: false, completion: {
                self.openCalendar()
                     })
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
}
