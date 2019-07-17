//
//  ChooseWorkerTableViewController.SWIFT
//  bthree-ios
//
//  Created by User on 3.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
// MARK: - Protocol
protocol hideTableDelegate
{
    func hideTable()
}
protocol reloadTableFreeDaysDelegate {
    func reloadTableFreeDays()
}
//תת טבלה של נותני שירות (בחר איש צוות)
class ChooseWorkerTableViewController: UITableViewController,hideTableDelegate,reloadTblDelegate
{
    var iMonth:Int = 0
    var iYear:Int = 0
    // MARK: - Varibals
    var delegateFreeDays:reloadTableFreeDaysDelegate!=nil
    var delegate:selectWorkerDelegate!=nil
    
    var arrayWorkers:Array<String> = Array<String> ()
    
    var getFreeDaysForService:Array<providerFreeDaysObj> =  Array<providerFreeDaysObj>()
    var generic:Generic = Generic()
    // MARK: - Initials
    @IBOutlet weak var workertable:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let todaybe:Date = Calendar.sharedInstance.carrentDate as Date
        let components = (Foundation.Calendar.current as NSCalendar).components([.day, .month, .year], from: todaybe)
        let month = components.month
        let year = components.year
        print("ENGAGE  \(String(describing: month)) \(String(describing: year))")
        //today = Calendar.sharedInstance.carrentDate
        iMonth = month!
        iYear = year!
        Global.sharedInstance.defaults.set(1, forKey: "mustreloadprovider")
        Global.sharedInstance.defaults.synchronize()
        arrayWorkers = []
        
        self.delegateFreeDays = Global.sharedInstance.designMonthAppointment
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        Global.sharedInstance.modelCalenderForAppointment?.delegate = self
        //JMODE PLUS 24.05.2017 -> autoselect first worker and get his working hours
        if Global.sharedInstance.giveServicesArray.count > 0 {
            let id  = Global.sharedInstance.giveServicesArray[0].iUserId
            if id > 0 {
                Global.sharedInstance.idWorker = id
                Global.sharedInstance.indexRowForIdGiveService = 0
            } else {
                Global.sharedInstance.idWorker = -1
                Global.sharedInstance.indexRowForIdGiveService = -1
            }
            getFreeDaysForServiceProvider()
        }
        
        //        let rowToSelect:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0);  //selecting 0th row with 0th section
        //
        //        self.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None)
        //        tableView.delegate.imageTappedWorkersMenu()
        /*
         getServicesProviderForSupplierfunc()
         let indexPath = NSIndexPath(forRow: 0, inSection: 0)
         delegate.selectWorker((tableView.cellForRowAtIndexPath(indexPath) as! WorkerNameTableViewCell).lblDesc.text!)
         let id  = Global.sharedInstance.giveServicesArray[0].iUserId
         if id > 0 {
         Global.sharedInstance.idWorker = id
         Global.sharedInstance.indexRowForIdGiveService = 0
         } else {
         Global.sharedInstance.idWorker = -1
         Global.sharedInstance.indexRowForIdGiveService = -1
         }
         getFreeDaysForServiceProvider()
         */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //function that send iProviderId and get list of Services Providers
    func getServicesProviderForSupplierfunc()
    {
        arrayWorkers = []
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        var arrUsers:Array<User> = Array<User>()
        
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.getServicesProviderForSupplierfunc(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in     ////  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            Alert.sharedInstance.showAlertDelegate("NO_GIVES_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                                let u:User = User()
                                arrUsers = u.usersToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                if arrUsers.count != 0
                                {
                                    for u:User in arrUsers
                                    {
                                        let s = u.nvFirstName + " " + u.nvLastName
                                        self.arrayWorkers.append(s)
                                    }
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Global.sharedInstance.arrayWorkers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerNameTableViewCell") as! WorkerNameTableViewCell
        cell.selectionStyle = .none
        cell.setDisplayData(Global.sharedInstance.arrayWorkers[indexPath.row])
        if indexPath.row == Global.sharedInstance.arrayWorkers.count-1
        {
            cell.viewButtom.isHidden = true
        }
        else{
            cell.viewButtom.isHidden = false
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //אם בחרתי עובד מסוים
        if (tableView.cellForRow(at: indexPath) as! WorkerNameTableViewCell).lblDesc.text! != "NOT_CARE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            delegate.selectWorker((tableView.cellForRow(at: indexPath) as! WorkerNameTableViewCell).lblDesc.text!)
            let id  = Global.sharedInstance.giveServicesArray[indexPath.row].iUserId
            if id > 0 {
                Global.sharedInstance.idWorker = id
                Global.sharedInstance.indexRowForIdGiveService = indexPath.row
            } else {
                Global.sharedInstance.idWorker = -1
                Global.sharedInstance.indexRowForIdGiveService = -1
            }
            self.getFreeDaysForServiceProvider()
        }
        else//אם בחרתי - לא משנה לי
        {
            delegate.selectWorker((tableView.cellForRow(at: indexPath) as! WorkerNameTableViewCell).lblDesc.text!)
            Global.sharedInstance.idWorker = -1
            Global.sharedInstance.indexRowForIdGiveService = -1
            self.getFreeDaysForServiceProvider()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height * 0.25
    }
    
    func hideTable()
    {
        self.view.removeFromSuperview()
    }
    
    func reloadTbl(){
        self.tableView.reloadData()
        
    }
    func reloadHeight(){
        
    }
    func beginHeightUpdate() {
    }
    
    
    func PREETYJSON_J(_ params:Dictionary<String,AnyObject>, pathofweb: String) {
        print("********************************* \(pathofweb) my data ********************\n")
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        print("\n********************************* END of \(pathofweb)  ********************\n")
    }
    func getFreeDaysForServiceProvider(){
        //        var dicGetFreeDaysForServiceProvider:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        //compuse string date
        var monthneed:String = ""
        var yearneeded:String = ""
        monthneed = String(iMonth)
        yearneeded = String(iYear)
        let composedDATE = yearneeded + "-" + monthneed + "-1"
        print("composedDATE \(composedDATE)")
        Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
        Global.sharedInstance.arrayGiveServicesKods = []
        Global.sharedInstance.dateFreeDays = []
        
        if Global.sharedInstance.idWorker == -1//אם בחרו - לא משנה לי
        {
            for  item in Global.sharedInstance.giveServicesArray
            {
                Global.sharedInstance.arrayGiveServicesKods.append(item.iUserId)//אחסון כל הקודים של נותני השרות כי בחר - לא משנה לי
            }
        }
        else
        {
            
            //מערך שאוחסנו בו השעות של הימים הפנויים
            Global.sharedInstance.arrayGiveServicesKods.append(Global.sharedInstance.idWorker)
        }
        ////////\\\\\\lProviderServiceId
        Global.sharedInstance.dicGetFreeDaysForServiceProvider["lServiseProviderId"] = Global.sharedInstance.arrayGiveServicesKods as AnyObject
        
        Global.sharedInstance.dicGetFreeDaysForServiceProvider["lProviderServiceId"] = Global.sharedInstance.arrayServicesKodsToServer as AnyObject
        print("one code \(Global.sharedInstance.arrayServicesKodsToServer)")
        
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
            
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            //new 23-01-17
            Global.sharedInstance.dicGetFreeDaysForServiceProvider["nvDate"] = composedDATE as AnyObject
            print("Global.sharedInstance.dicGetFreeDaysForServiceProvider \(self.PREETYJSON_J(Global.sharedInstance.dicGetFreeDaysForServiceProvider, pathofweb: "cHOSEW"))")
            api.sharedInstance.GetFreeDaysForServiceProvider(Global.sharedInstance.dicGetFreeDaysForServiceProvider, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in     //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            self.generic.hideNativeActivityIndicator(self)
                            Alert.sharedInstance.showAlertDelegate("NO_FREE_HOURS_FOUND".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            let ps:providerFreeDaysObj = providerFreeDaysObj()
                            if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                            Global.sharedInstance.getFreeDaysForService = ps.objFreeDaysToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            }
                            //איפוס המערך מנתונים ישנים
                            Global.sharedInstance.dateFreeDays = []
                            for i in 0 ..< Global.sharedInstance.getFreeDaysForService.count{
                                let dateDt = Calendar.sharedInstance.addDay(Global.sharedInstance.getStringFromDateString(Global.sharedInstance.getFreeDaysForService[i].dtDate))
                                let provider:providerFreeDaysObj = Global.sharedInstance.getFreeDaysForService[i]
                                
                                let hourStart = Global.sharedInstance.getStringFromDateString(provider.objProviderHour.nvFromHour)
                                Global.sharedInstance.fromHourArray.append(hourStart)
                                let hourEnd = Global.sharedInstance.getStringFromDateString(provider.objProviderHour.nvToHour)
                                Global.sharedInstance.endHourArray.append(hourEnd)
                                
                                Global.sharedInstance.dateFreeDays.append(dateDt)
                            }
                            self.delegateFreeDays.reloadTableFreeDays()
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
}
