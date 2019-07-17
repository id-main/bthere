//
//  PlusMenuNewCustomer.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 20/11/2018 dmy :)
//  Copyright © 2018 Bthere. All rights reserved.
// Replaces old MenuPlusViewController which anyway was obsolete

import Foundation
import UIKit
class PlusMenuNewCustomer: UIView, UIGestureRecognizerDelegate {
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
  //  @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
   // @IBOutlet weak var view4: UIView!
    @IBOutlet weak var greaterView: UIView!
    @IBOutlet weak var CentralButton: UIView!
    let calendar = Foundation.Calendar.current
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var myArrayLabels = Array<UILabel>()
    var myarrstring = Array<String>()
    override public func awakeFromNib() {
        super.awakeFromNib()
        myArrayLabels.append(lbl1)
        myArrayLabels.append(lbl2)
        myArrayLabels.append(lbl3)
      //  myArrayLabels.append(lbl4)

        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openViewLittleLate))
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openMyAppointments))
     //   let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openNewEvent))
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openCancellationView))
        tap1.delegate = self
        tap2.delegate = self
        tap3.delegate = self
      //  tap4.delegate = self 5
        view1.addGestureRecognizer(tap1)
        view2.addGestureRecognizer(tap2)
        view3.addGestureRecognizer(tap3)
     //   view4.addGestureRecognizer(tap4)
        let tapExit:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeMe))
        let tapExit1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeMe))
        CentralButton.addGestureRecognizer(tapExit)
        greaterView.addGestureRecognizer(tapExit1)
        myarrstring = []
        myarrstring = ["NEW_Short_delay".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                       "NEW_My_appointments".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                  //     "CUSTOMER_New_event".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                       "NEW_Cancellation".localized(LanguageMain.sharedInstance.USERLANGUAGE),
        ]
        for i in 0..<myArrayLabels.count {
            myArrayLabels[i].text = myarrstring[i]
        }
    }
    @objc func removeMe() {
        self.removeFromSuperview()
    }
    @objc func openViewLittleLate() {
        GetCustomerOrders(3)
    }
    @objc func openMyAppointments() {
        GetCustomerOrders(1)
    }
    @objc func openNewEvent () {
    }
    @objc func openCancellationView () {
        GetCustomerOrders(2)
    }
    func GetCustomerOrders(_ whichOpened:Int)
    {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        dic["iFilterByMonth"] = iFilterByMonth as AnyObject
        dic["iFilterByYear"] = iFilterByYear as AnyObject

        if Reachability.isConnectedToNetwork() == false
        {

//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetCustomerOrders(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    let ps:OrderDetailsObj = OrderDetailsObj()
                    if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                    print("raspuns pt json: \(RESPONSEOBJECT["Result"] as? NSArray ?? [])")
                        Global.sharedInstance.ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                    }
                    if Global.sharedInstance.ordersOfClientsArray.count != 0
                    {
//                        for obj:OrderDetailsObj in Global.sharedInstance.ordersOfClientsArray
//                        {
//                        //    print("obj appointments: \(obj.getDic())")
//                        }
                        var filteredarray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>()
                        var pastArray:Array<OrderDetailsObj> = Array<OrderDetailsObj>()
                        for item in Global.sharedInstance.ordersOfClientsArray {
                            if (!self.hourisless(item) && self.isdateequal(item) ) || self.isdateafter(item) {
                                if item.nvComment != "BlockedBySupplier" {
                                    if !filteredarray.contains(item)  {
                                        filteredarray.append(item)
                                    }
                                }
                            }
                                //                                let datetoadd10minutes = orderClient.dtDateOrder.addingTimeInterval(10.0 * 60.0)
                            else if (self.hourisless(item) && self.isdateequal(item)) || (!self.isdateafter(item) && !self.isdateequal(item))
                            {
                                if item.nvComment != "BlockedBySupplier" {
                                    if !pastArray.contains(item)  && self.isUnder30Days(item) {
                                        pastArray.append(item)
                                    }
                                }
                            }
                            filteredarray =   filteredarray.sorted(by: { ($1 ).dtDateOrder > ($0 ).dtDateOrder })
                            pastArray = pastArray.sorted(by: { ($1 ).dtDateOrder > ($0 ).dtDateOrder })
                            Global.sharedInstance.ordersOfClientsArray = filteredarray
                            //                            Global.sharedInstance.ordersOfClientsArray = pastArray
                        }
                        let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                        let viewCon:myAppointmentsViewController = clientStoryBoard.instantiateViewController(withIdentifier: "myAppointmentsViewController") as! myAppointmentsViewController
                        viewCon.whichOpenMe = whichOpened
                        viewCon.pastAppointmentsFilter = pastArray
                        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                        // self.removeFromSuperview()
                        self.parentViewController?.present(viewCon, animated: true, completion:nil)

                    }
                    else
                    {
                        Alert.sharedInstance.showAlertDelegate("NO_APPOINTMENTS__FROM_YOU".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))

            })
        }
    }
    func hourisless (_ itemx: OrderDetailsObj) -> Bool {
        var islessh:Bool  = false
        var eventHour:Int = 0
        var eventMinutes:Int = 0
        itemx.dtDateOrder = itemx.dtDateOrder.addingTimeInterval(10.0 * 60.0)
        //   if itemx.iCoordinatedServiceId > 0 { don't care all events has starting and ending hours and hollydays are in separated array
        if let a1:Character =  itemx.nvFromHour[itemx.nvFromHour.startIndex] as Character? {
            if a1 == "0" {
                //now get the real hour
                if let a2:Character =  itemx.nvFromHour[itemx.nvFromHour.index(itemx.nvFromHour.startIndex, offsetBy: 1)] as Character?{
                    //let charAtIndex = someString[someString.startIndex.advanceBy(10)]
                    if a2 == "0" {
                        print("ora1 0 add to 0")
                        eventHour = 0
                    }
                    else {
                        print("ora1 \(a2) add to \(a2)") //section
                        let str = String(a2)
                        let IntHOUR:Int = Int(str)!
                        eventHour = IntHOUR

                    }
                }
            }
            else { //full hour 2 chars
                let fullNameArr = itemx.nvFromHour.components(separatedBy: ":")
                let size = fullNameArr.count
                if(size > 1 ) {
                    if let _:String = fullNameArr[0] as String? {
                        let hourstring:String = fullNameArr[0]
                        let numberFromString:Int = Int(hourstring)!
                        eventHour = numberFromString
                    }
                }
            }
        }
        // }
        let componentsToday = (calendar as NSCalendar).components([.hour, .minute], from: Date())
        let minutulacum = componentsToday.minute
        let oraacum = componentsToday.hour

        if eventHour < oraacum! {
            islessh = true
        } else  if eventHour == oraacum {
            //minutes compare
            let fullNameArr = itemx.nvFromHour.components(separatedBy: ":")
            let size = fullNameArr.count
            if(size > 1 ) {
                if let _:String = fullNameArr[1] as String? {
                    let hourstring:String = fullNameArr[1]
                    if let a1:Character =  hourstring[hourstring.startIndex] as Character? {
                        if a1 == "0" {
                            //now get the real minute
                            if let a2:Character =  hourstring[hourstring.index(hourstring.startIndex, offsetBy: 1)] as Character? {
                                if a2 == "0" {
                                    print("minutul 0 add to 0")
                                    eventMinutes = 0
                                }
                                else {
                                    print("minutul \(a2) add to \(a2)") //section
                                    let str = String(a2)
                                    let IntHOUR:Int = Int(str)!
                                    eventMinutes = IntHOUR

                                }
                            }
                        }
                        else { //full minutes 2 chars
                            let fullNameArr = itemx.nvFromHour.components(separatedBy: ":")
                            let size = fullNameArr.count
                            if(size > 1 ) {
                                if let _:String = fullNameArr[1]  as String? {
                                    let hourstring:String = fullNameArr[1]
                                    let numberFromString:Int = Int(hourstring)!
                                    eventMinutes = numberFromString
                                }
                            }
                        }
                    }
                }
            }
            //added 10 minutes because that's how life works
            if eventMinutes < minutulacum!
            {
                islessh = true
            } else
            {
                islessh = false
            }
        }


        else {
            islessh = false
        }
        //\\print ("oraacum \(oraacum) - minutulacum \(minutulacum) si eventHour \(eventHour)  eventMinutes \(eventMinutes) ")

        return islessh
    }
    func isdateafter (_ itemx: OrderDetailsObj) -> Bool {
        var isafter:Bool  = false
        let eventDay:Date = itemx.dtDateOrder as Date
        //\\print ("eventday \(eventDay)")
        let todayStart:Date = Date()
        if eventDay.compare(todayStart) == ComparisonResult.orderedDescending
        {
            NSLog("date1 after date2");
            isafter = true

        } else if eventDay.compare(todayStart) == ComparisonResult.orderedAscending
        {
            NSLog("date1 before date2");
            isafter = false
        } else
        {
            NSLog("dates are equal");
            isafter = false
        }

        return isafter
    }

    func isUnder30Days (_ item:OrderDetailsObj) -> Bool
    {
        var isUnder:Bool = false

        let eventDay:Date = item.dtDateOrder as Date

        let currentDate:Date = Date()
        let thirtyDaysAgoDate = Foundation.Calendar.current.date(byAdding: .day,value: -30, to: currentDate)
        print("thirtyDaysAgoDate: \(String(describing: thirtyDaysAgoDate))")
        print("item date: \(item.dtDateOrder)")
        if let _ = thirtyDaysAgoDate
        {
            if eventDay.compare(thirtyDaysAgoDate!) == ComparisonResult.orderedDescending
            {
                print("30 days ago")
                isUnder = true
            }
            else if eventDay.compare(thirtyDaysAgoDate!) == ComparisonResult.orderedSame
            {
                print("30 days ago")
                isUnder = true

            }
            else if eventDay.compare(thirtyDaysAgoDate!) == ComparisonResult.orderedAscending
            {
                print("less than 30 days ago")
                isUnder = false
            }
        }
        return isUnder
    }


    func isdateequal (_ itemx: OrderDetailsObj) -> Bool {
        var isafter:Bool  = false
        let eventDay:Date = itemx.dtDateOrder as Date
        //\\print ("eventday \(eventDay)")
        let todayStart:Date = Date()
        if eventDay.compare(todayStart) == ComparisonResult.orderedDescending
        {
            NSLog("date1 after date2");
            isafter = false

        } else if eventDay.compare(todayStart) == ComparisonResult.orderedAscending
        {
            NSLog("date1 before date2");
            isafter = false
        } else
        {
            NSLog("dates are equal");
            isafter = true
        }

        return isafter
    }
}
