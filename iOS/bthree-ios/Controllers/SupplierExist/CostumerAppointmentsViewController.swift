//
//  CostumerAppointmentsViewController.swift
//  Bthere
//
//  Created by User on 24.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//ספק  דף רשימת  תורים
class CostumerAppointmentsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,openFromMenuDelegate,UIGestureRecognizerDelegate{
    var MyWeekDayNames:NSArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var MyHebrewWeekDayNames:NSArray = ["יוֹם רִאשׁוֹן" ,"יוֹם שֵׁנִי‎","יוֹם שְׁלִישִׁי‎","יוֹם רְבִיעִי","יוֹם חֲמִישִׁי" ,"יוֹם שִׁישִּׁי" ,"יוֹם שַׁבָּת"]
    var myArray : NSArray = NSArray()
    var ICUSTOMERID:Int = 0
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var iFilterByMonthEnd:Int = 0
    var iFilterByYearEnd:Int = 0
    var DCUSTOMER:NSDictionary = NSDictionary()
    @IBOutlet weak var titleofScreen: UILabel!
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:44) 
        Global.sharedInstance.myCustomerOrdersARRAY = []
        DCUSTOMER = (Global.sharedInstance.searchCostumersArray.object(at: row) as! NSDictionary) as NSDictionary
        print("DCUSTOMER \(DCUSTOMER)")
        if let a:String =  DCUSTOMER.object(forKey: "nvFullName") as? String
        {
            if (a == "Occassional Customer") {
                titleofScreen.text = "OCCASIONAL_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            } else {
                titleofScreen.text = a
            }
        } else {
            self.titleofScreen.text = "CUSTOMER_APPOINMENTS_SUBTITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.GetCustomerOrdersForSupplier(self.ICUSTOMERID)
        })
    }
    var MYordersOfClientsArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>()
    let calendar = Foundation.Calendar.current
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    var row:Int = 0
    
    
    @IBOutlet weak var tblData: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblData.delegate = self
        self.tblData.reloadData()
        Global.sharedInstance.appointmentsCostumers = self
        print("MYordersOfClientsArray \(MYordersOfClientsArray)")
        AppDelegate.i = 0
        tblData.separatorStyle = .none
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  Global.sharedInstance.myCustomerOrdersARRAY.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberRows:Int = 0
        var totalnumberrows:Int = 0
        if Global.sharedInstance.myCustomerOrdersARRAY.count > 0 {
            if let d:NSDictionary = Global.sharedInstance.myCustomerOrdersARRAY[section] as? NSDictionary {
                if (d.object(forKey: "objProviderServiceDetails") as? NSArray) != nil
                {
                    numberRows =  1
                    print("objProviderServiceDetails\(numberRows)")
                }
            }
            totalnumberrows = 1 + numberRows //header + service name and details
        }
        return totalnumberrows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var STRdtDateOrder:Date = Date()
        
        if let _:NSDictionary = Global.sharedInstance.myCustomerOrdersARRAY[indexPath.section] as? NSDictionary {
            let d:NSDictionary = Global.sharedInstance.myCustomerOrdersARRAY[indexPath.section] as!NSDictionary
            print("mydict \(d)")
            
            if let ORDERDATE =  d.object(forKey: "dtDateOrder") as? String
            {
                STRdtDateOrder = Global.sharedInstance.getStringFromDateString(ORDERDATE)
                print("STRdtDateOrder\(STRdtDateOrder)")
            }
        }
        
        
        let dayWeek = Calendar.sharedInstance.getDayOfWeek(STRdtDateOrder)
        let dayInWeek = DateFormatter().veryShortWeekdaySymbols[dayWeek! - 1]
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Calendar.sharedInstance.carrentDate as Date)
        let componentsToday = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
        let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: STRdtDateOrder)
        
        yearToday =  componentsCurrent.year!
        monthToday = componentsCurrent.month!
        dayToday = componentsCurrent.day!
        
        let yearEvent =  componentsEvent.year
        let monthEvent = componentsEvent.month
        let monthName = DateFormatter().shortStandaloneMonthSymbols[monthEvent! - 1]
        let dayEvent = componentsEvent.day
        
        if indexPath.row == 0{
            
            let cell:HeaderRecordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HeaderRecordTableViewCell")as!HeaderRecordTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            if componentsToday.day == dayEvent{
                cell.imgToday.isHidden = false
            }
            else{
                cell.imgToday.isHidden = true
            }
            let dayEvent = componentsEvent.day
            let dayEventtext = "\(dayEvent ?? dayToday)"
            let yearEventtext = "\(yearEvent ?? yearToday)"
            let str =  " ," + dayEventtext + " " + String(monthName) + " " + yearEventtext
            cell.setDisplayData(str,daydesc: dayInWeek)
            cell.tag = indexPath.section
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showContent(_:)))
            tap.delegate = self
            cell.addGestureRecognizer(tap)
            
            return cell
        }
        
        
        let cell:AppointmentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AppointmentTableViewCell")as!AppointmentTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.tag = indexPath.section
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showContent(_:)))
        tap.delegate = self
        cell.addGestureRecognizer(tap)
        cell.setDisplayData(indexPath.section, MYDICT: self.DCUSTOMER)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 25
        }
        return self.view.frame.height * 0.12
    }
    
    //openFromMenuDelegate
    func openFromMenu(_ con:UIViewController){
        self.present(con, animated: true, completion: nil)
    }
    
    //GetCustomerOrdersForSupplier(int iUserId, int iSupplierId, int iFilterByMonth, int iFilterByYear, int iFilterByMonthEnd, int iFilterByYearEnd )
    func GetCustomerOrdersForSupplier(_ customerID:Int)  {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        self.myArray = [] //empty first
        //JMODE in order to get customer's appoinments for current provider and not all of them
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        let todaybe:Date = Date()
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let month = components.month
        let year = components.year
        //6 months back and 6 months in future
        if month! - 6 > 0 {
            iFilterByMonth = month! - 6
            iFilterByYear = year!
        } else if month! - 6 == 0 {
            iFilterByMonth = 12
            iFilterByYear = year! - 1
        } else {
            iFilterByMonth = 12 - 6 - month!
            iFilterByYear = year! - 1
        }
        if month! + 6 <= 12 {
            iFilterByMonthEnd = month! + 6
            iFilterByYearEnd = year!
        } else if month! + 6 > 12 {
            iFilterByMonthEnd = 12 - month! + 6
            iFilterByYearEnd = year! + 1
        }
        
        
//        dic["iFilterByMonth"] = iFilterByMonth as AnyObject
//        dic["iFilterByYear"] = iFilterByYear as AnyObject
//        dic["iFilterByMonthEnd"] = iFilterByMonthEnd as AnyObject
//        dic["iFilterByYearEnd"] = iFilterByYearEnd as AnyObject
        dic["iFilterByYearEnd"] = 0 as AnyObject
        dic["iFilterByMonthEnd"] = 0 as AnyObject
        dic["iFilterByYear"] = 0 as AnyObject
        dic["iFilterByMonth"] = 0 as AnyObject
        print ("myxiFilterByMonthx \(iFilterByMonth) iFilterByYear \(iFilterByYear) iFilterByMonthEnd \(iFilterByMonthEnd) iFilterByYearEnd \(iFilterByYearEnd)")
        dic["iUserId"] = customerID as AnyObject
        dic["iSupplierId"] = providerID as AnyObject
        print("my data: \(dic)")
        api.sharedInstance.GetCustomerOrdersForSupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                // fix Swift 3
                print("response server: \(RESPONSEOBJECT)")
                if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                    let REZULTATE:NSArray = RESPONSEOBJECT["Result"] as! NSArray
                    self.processMYARRAY(REZULTATE)
                } else {
                    let REZULTATE:NSArray = []
                    self.processMYARRAY(REZULTATE)
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
    }
    
    @objc func showContent(_ sender: UITapGestureRecognizer) {
        let tag = sender.view!.tag
        print("sender tag \(tag)")
        var d:NSDictionary = NSDictionary()
        
        if Global.sharedInstance.myCustomerOrdersARRAY.count > 0 {
            if let _:NSDictionary = Global.sharedInstance.myCustomerOrdersARRAY[tag] as? NSDictionary {
                d = Global.sharedInstance.myCustomerOrdersARRAY[tag] as!NSDictionary
                print("ddddd \(d)")
                let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
                let frontviewcontroller:UINavigationController? = UINavigationController()
                let viewCon:detailsAppointmetsupplierViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "detailsAppointmetsupplierViewController") as! detailsAppointmetsupplierViewController
                viewCon.APPOINMENT_DICT = d
                viewCon.isfromLIST = false
//                let emi:NSMutableDictionary = NSMutableDictionary()
//                if let _:String = mydic["nvPhone"] as? String   {
//                    let nvPhone = mydic["nvPhone"] as! String
//                    emi["nvPhone"] = nvPhone
//                }
                viewCon.userAPPOINMENT_DICT = self.DCUSTOMER as! NSMutableDictionary
                let dic:NSMutableDictionary = DCUSTOMER.mutableCopy() as! NSMutableDictionary
                if let _:Int = DCUSTOMER["iCustomerUserId"]  as? Int {
                    let a:Int =  DCUSTOMER["iCustomerUserId"]  as! Int
                    if a == 134 {
                       
                        if let _:String = d["nvComment"] as? String {
                            let b:String =  d["nvComment"]  as! String
                            dic["nvPhone"] = b
                             viewCon.userAPPOINMENT_DICT = dic
                        }
                    }
                }
                frontviewcontroller!.pushViewController(viewCon, animated: false)
                let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                let mainRevealController = SWRevealViewController()
                mainRevealController.frontViewController = frontviewcontroller
                mainRevealController.rearViewController = rearViewController
                let window :UIWindow = UIApplication.shared.keyWindow!
                window.rootViewController = mainRevealController
            }
        }
    }
    func hidetoast(){
        view.hideToastActivity()
    }
    
    
    func processMYARRAY (_ mycustomerorder: NSArray) {
        self.myArray = mycustomerorder
        print("self.myarraydata \(self.myArray)")
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "dtDateOrder", ascending: true)
        if let _ = self.myArray.sortedArray(using: [descriptor]) as? NSArray {
        let sortedResults: NSArray = self.myArray.sortedArray(using: [descriptor]) as NSArray
        Global.sharedInstance.myCustomerOrdersARRAY = sortedResults
        } else {
        Global.sharedInstance.myCustomerOrdersARRAY = self.myArray //in case sorting does not succeed
        }
        print("self.myArray.count FIRST\(self.myArray.count)")
        if self.myArray.count == 0 {
            self.view.makeToast(message: "NO_APPOINMENTS_YET".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionTop as AnyObject)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.hidetoast()
            })
            
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
                self.tblData.reloadData()
            })
        }
    }
}
