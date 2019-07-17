//
//  BlockingHoursTableViewController.swift
//  BThere
//
//  Created by Ioan Ungureanu on 09/05/2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit
import MGSwipeTableCell
protocol reloadAllAfterDelete {
    func reloadall()
}
class BlockingHoursTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,reloadAllAfterDelete {
    // Outlets
    @IBOutlet var topBorderView: UIView!
    @IBOutlet var popConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblAppointments: UITableView!
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var BlockHouresObjArray:Array<BlockHouresObj> =  Array<BlockHouresObj>()
    var intSuppliersecondID:Int = 0
    // Variables
    var generic:Generic = Generic()
    var whichOpenMe = 0
    var finalArrayCount:Array<BlockHouresObj> =  Array<BlockHouresObj>()
    var selectedRows:Array<Bool> = Array<Bool>()
    var howManyToSend:Int = 0
    var howManyWereSent:Int = 0
    var howManyFailed:Int = 0
    var dateToSend = ""
    var arrayDictionariesRequests:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
   //\\ @IBOutlet weak var downArrow: UIImageView!
    //    var iServiceProviderCalendarId:Int = 0
    //0 get second id
    func GetSecondUserIdByFirstUserIdSix()  {
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var myUserID:Int = 0
        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let currentUserIdDictionary:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let currentUserIdInt:Int = currentUserIdDictionary.value(forKey: "currentUserId") as? Int{
                myUserID = currentUserIdInt
            }
        }
        if myUserID != 0
        {
            dictionaryForServer["iUserId"] =  myUserID as AnyObject
            print("\n********************************* GetSecondUserIdByFirstUserId  ********************\n")
            if Reachability.isConnectedToNetwork() == false
            {

            }
            else
            {
                api.sharedInstance.GetSecondUserIdByFirstUserId(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                            {
                                print("eroare la GetSecondUserIdByFirstUserId \(String(describing: RESPONSEOBJECT["Error"]))")
                            }
                            else
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                                {
                                    print("eroare la GetSecondUserIdByFirstUserId \(String(describing: RESPONSEOBJECT["Error"]))")
                                }
                                else
                                {
                                    if let _:Int = RESPONSEOBJECT["Result"] as? Int
                                    {
                                        let integerResultFromServer :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                        print("GetSecondUserIdByFirstUserId \(integerResultFromServer)")
                                        if integerResultFromServer > 0 {
                                            self.setupISupplierSecondID(integerResultFromServer)
                                        }
                                    }
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in

                })
            }
        }


    }
    @IBOutlet weak var buttonConfirmDelete: UIButton!

    @IBAction func confirmDeleteAction(_ sender: UIButton)
    {

        self.generic.showNativeActivityIndicator(self)
        
        var iServiceProviderCalendarId:Int = 0
        var iProviderUserId:Int = 0
        var dDate:String = ""
        var ISFROMBLOCKTABLE:Bool = false
        var ISFROMCALENDARVIEW = true
        var dictosend:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        
        print("howManyToSend: \(howManyToSend)")
        
        for i in 0..<selectedRows.count
        {
            if selectedRows[i] == true
            {
                let date = dateFormatter.string(from: Global.sharedInstance.getStringFromDateString(finalArrayCount[i].cDate as String))
                let hourS:String = finalArrayCount[i].tFromHoure
                let hourE:String = finalArrayCount[i].tToHoure
//               let weekday = Global.sharedInstance.getStringFromDateString(finalArrayCount[i].cDate as String)
//              let dayname = moreexactlocalizablestringsfordays3(Calendar.sharedInstance.getDayOfWeek(weekday)!)
//                let targetStr = date + "      " + hourS + " - " + hourE + "       " + dayname
//                let range = NSMakeRange(0, date.count + 1)

                let onestr = "AT".localized(LanguageMain.sharedInstance.USERLANGUAGE) + "\n" + date
                if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
                    {
                        dateToSend =  hourE + " - " +  hourS + " " + onestr
                    }
                else
                    {
                        dateToSend = hourS + " - " + hourE + " " + onestr
                    }
               
               iProviderUserId = self.intSuppliersecondID
               iServiceProviderCalendarId = self.finalArrayCount[i].iServiceProviderCalendarId
               dDate = self.finalArrayCount[i].cDate
               ISFROMCALENDARVIEW = false
               ISFROMBLOCKTABLE = true
                
           //      let myarr:NSMutableArray = []
           //      myarr.add(iServiceProviderCalendarId)
           //     dictosend["iServiceProviderCalendarId"] = myarr as AnyObject
                dictosend["iServiceProviderCalendarId"] = iServiceProviderCalendarId as AnyObject
                dictosend["iProviderUserId"] = iProviderUserId as AnyObject
                dictosend["dDate"] = dDate as AnyObject
                
//                RemoveBlockedHouresFromCalendar(dictosend: dictosend)
                arrayDictionariesRequests.append(dictosend)
                
                
            }

        }
        
        if arrayDictionariesRequests.count > 0
        {
          //  RemoveBlockedHouresFromCalendar(dictosend: arrayDictionariesRequests[0])
            RemoveBulkBlockedHoursFromCalendar()
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            popConstraint.constant = 75 // 139
        } else {
            popConstraint.constant = 75
        }
        lblTitle.text = "CANCEL_BLOCK_HOURES".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    //    tryGetSupplierCustomerUserIdByEmployeeId()
        GetSecondUserIdByFirstUserIdSix()
        tblAppointments.delegate = self
        tblAppointments.dataSource = self
        
        self.tblAppointments.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        print("finalArrayCount.count \(finalArrayCount.count)")
//        for _ in finalArrayCount
//        {
//            selectedRows.append(false)
//
//        }

        buttonConfirmDelete.setTitle("CONFIRM_SELECTED_ROWS".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: .normal)
        changeConfirmButton(selectedRows: 0)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    @objc func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if ( self.finalArrayCount.count > 0) {
            self.topBorderView.isHidden = false
        } else {
            self.topBorderView.isHidden = true
        }
        print("finalArrayCount.count \(finalArrayCount.count)")
        return finalArrayCount.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let reuseIdentifier = "blockHoursCustomCell"
        let cell:blockHoursCustomCell = tableView.dequeueReusableCell(withIdentifier:reuseIdentifier) as! blockHoursCustomCell
        if selectedRows[indexPath.section] == false {
            cell.circleImg.image = UIImage(named: "blockHoursEmptyCircle.png")
        } else {
            cell.circleImg.image = UIImage(named: "blockHoursFullCircle.png")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: Global.sharedInstance.getStringFromDateString(finalArrayCount[indexPath.section].cDate as String))
        let hourS:String = finalArrayCount[indexPath.section].tFromHoure
        let hourE:String = finalArrayCount[indexPath.section].tToHoure
        
        let weekday = Global.sharedInstance.getStringFromDateString(finalArrayCount[indexPath.section].cDate as String)
      
        let dayname = moreexactlocalizablestringsfordays3(Calendar.sharedInstance.getDayOfWeek(weekday)!)
        
        if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            let targetStr = date + "      " + hourE + " - " + hourS + "       " + dayname
            let range = NSMakeRange(0, date.count + 1)
            //        cell.textLabel?.attributedText = attributedString(from: targetStr, BoldRange:  range)
            cell.blockText.attributedText = attributedString(from: targetStr, BoldRange:  range)

        }
        else // if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 1  
        {
            let targetStr = date + "      " + hourS + " - " + hourE + "       " + dayname
            let range = NSMakeRange(0, date.count + 1)
            //        cell.textLabel?.attributedText = attributedString(from: targetStr, BoldRange:  range)
            cell.blockText.attributedText = attributedString(from: targetStr, BoldRange:  range)

        }

        if selectedRows[indexPath.section] == false {
            cell.circleImg.image = UIImage(named: "blockHoursEmptyCircle.png")
        } else {
            cell.circleImg.image = UIImage(named: "blockHoursFullCircle.png")
        }
//        let mybtn =  MGSwipeButton(title: "", icon: UIImage(named:"recicle-bin.png"), backgroundColor: .clear) {
//            (sender: MGSwipeTableCell!) -> Bool in
//            print("Convenience callback for swipe buttons!")
//            let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
//            let viewpopupcancel = storyboardtest.instantiateViewController(withIdentifier: "CancelBlockHoursViewController") as! CancelBlockHoursViewController
//            if self.iOS8 {
//                viewpopupcancel.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            } else {
//                viewpopupcancel.modalPresentationStyle = UIModalPresentationStyle.currentContext
//            }
//            let onestr = "AT".localized(LanguageMain.sharedInstance.USERLANGUAGE) + "\n" + date
//            if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
//                viewpopupcancel.date =  hourE + " - " +  hourS + " " + onestr
//            } else {
//                viewpopupcancel.date = hourS + " - " + hourE + " " + onestr
//            }
//
//            viewpopupcancel.iProviderUserId = self.intSuppliersecondID
//            viewpopupcancel.iServiceProviderCalendarId = self.finalArrayCount[indexPath.section].iServiceProviderCalendarId
//            viewpopupcancel.dDate = self.finalArrayCount[indexPath.section].cDate
//            viewpopupcancel.ISFROMCALENDARVIEW = false
//            viewpopupcancel.ISFROMBLOCKTABLE = true
//            viewpopupcancel.delegateDel = self
//            self.present(viewpopupcancel, animated: true, completion: nil)
//            print("ceva")
//            return true
//        }
//        mybtn.buttonWidth = cell.frame.size.height - 2
//        mybtn.buttonWidth = cell.frame.size.height + 12
//        mybtn.frame.size.height = mybtn.buttonWidth + 5
//        mybtn.imageView?.sizeToFit()
//        cell.leftButtons = [  mybtn ]
//        cell.leftSwipeSettings.transition = .drag
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let reuseIdentifier = "blockHoursCustomCell"
//        let cell:blockHoursCustomCell = tableView.dequeueReusableCell(withIdentifier:reuseIdentifier) as! blockHoursCustomCell
        if let _ = tableView.cellForRow(at: indexPath) as? blockHoursCustomCell
        {
            let currentCell = tableView.cellForRow(at: indexPath) as! blockHoursCustomCell
            currentCell.circleImg.image = UIImage(named: "blockHoursFullCircle.png")
            currentCell.setSelected(true, animated: true)
            selectedRows[indexPath.section] = true
            howManyToSend += 1
            if howManyToSend == 0
            {
                changeConfirmButton(selectedRows: 0)
            }
            else
            {
               changeConfirmButton(selectedRows: 1)
            }
            print("howManyToSend did select: \(howManyToSend)")
             print("index path section number: \(selectedRows[indexPath.section])")
        }


        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? blockHoursCustomCell
        {
            let currentCell = tableView.cellForRow(at: indexPath) as! blockHoursCustomCell
            currentCell.circleImg.image = UIImage(named: "blockHoursEmptyCircle.png")
            currentCell.setSelected(false, animated: true)
            selectedRows[indexPath.section] = false
            howManyToSend -= 1
            if howManyToSend == 0
            {
                changeConfirmButton(selectedRows: 0)
            }
            else
            {
               changeConfirmButton(selectedRows: 1)
            }
            print("howManyToSend did deselect: \(howManyToSend)")
            print("index path section number: \(selectedRows[indexPath.section])")
            
        }
    }
    
    func changeConfirmButton(selectedRows:Int)
    {
        if selectedRows == 0
        {
            buttonConfirmDelete.backgroundColor = UIColor.gray
            buttonConfirmDelete.isEnabled = false
            buttonConfirmDelete.isUserInteractionEnabled = false
           //\\ downArrow.image = UIImage(named: "downArrowGrey.png")
        }
        else
        {
            buttonConfirmDelete.backgroundColor = Colors.sharedInstance.color4
            buttonConfirmDelete.isEnabled = true
            buttonConfirmDelete.isUserInteractionEnabled = true
         //\\   downArrow.image = UIImage(named: "downArrowBlue.png")
        }
    }
    
    
    func moreexactlocalizablestringsfordays3(_ day:Int) -> String {
        switch day {
        case 1:
            return "SUNDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 2:
            return "MONDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 3:
            return "TUESDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 4:
            return "WEDNSDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 5:
            return "THIRTHDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 6:
            return "FRIDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 7:
            return "SHABAT_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        default:
            return "SUNDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
    }

    func GetBlockedHouresFromCalendar() {
        self.finalArrayCount = Array<BlockHouresObj>()
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var supplierID:Int = 0
//        if Global.sharedInstance.providerID == 0 {
//            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
//                supplierID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//            }
//        } else {
//            supplierID = Global.sharedInstance.providerID
//        }
        supplierID = self.intSuppliersecondID
        let calendar = Foundation.Calendar.current
        let timenow = Date()
        var timeold = (calendar as NSCalendar).date(byAdding: .month, value: -1, to: timenow, options: [])!
        var timemax = Date()
        
        timemax = (calendar as NSCalendar).date(byAdding: .month, value: 6, to: timeold, options: [])!
        dicSearch["iProviderUserId"] = self.intSuppliersecondID as AnyObject
        dicSearch["nvFromDate"] = Global.sharedInstance.convertNSDateToString(timeold) as AnyObject
        dicSearch["nvToDate"] = Global.sharedInstance.convertNSDateToString(timemax) as AnyObject
        self.generic.showNativeActivityIndicator(self)
        print("aicie \(supplierID)")
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetBlockedHouresFromCalendar(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    print(RESPONSEOBJECT)
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if  let _ = RESPONSEOBJECT["Result"] as? NSArray {
                                let ps:BlockHouresObj = BlockHouresObj()
                                self.BlockHouresObjArray = ps.dicToBlockHouresToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                if ( self.BlockHouresObjArray.count > 0)
                                {
                                    for a in self.BlockHouresObjArray
                                    {
                                   //     if Global.sharedInstance.getStringFromDateString(a.cDate) > Date()
                                       // {
                                            self.finalArrayCount.append(a)
                                            self.selectedRows.append(false)
                                    }
                                        
                                   // }
                                }
                                self.tblAppointments.reloadData()
                            }
                        } else {
                            self.tblAppointments.reloadData()
                            
                        }
                    }
                    self.generic.hideNativeActivityIndicator(self)
                }
                
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                
            })
        }
        
    }
    
    func reloadall() {
        GetBlockedHouresFromCalendar()
    }

    func setupISupplierSecondID (_ ISupplierSecondID:Int){
        self.intSuppliersecondID = ISupplierSecondID
        print("self.intSuppliersecondID \(self.intSuppliersecondID)")
        GetBlockedHouresFromCalendar()
        
    }
    func attributedString(from string: String, BoldRange: NSRange?) -> NSAttributedString {
        let fontSize = UIFont.systemFontSize
        let attrs = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: fontSize),
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black
        ]
        let BoldAttribute = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.boldSystemFont(ofSize: fontSize),
            ]
        let attrStr = NSMutableAttributedString(string: string, attributes: convertToOptionalNSAttributedStringKeyDictionary(attrs))
        if let range = BoldRange {
            attrStr.setAttributes(convertToOptionalNSAttributedStringKeyDictionary(BoldAttribute), range: range)
        }
        return attrStr
    }
    func RemoveBulkBlockedHoursFromCalendar () {
            //       {
            //            "iServiceProviderCalendarId":
            //            [
            //            1606576,
            //            1606577,
            //            1606578,
            //            ....
            //            ],
            //            "iProviderUserId":12167,
            //            "dDate":
            //            [
            //            "\/Date(1547157600000)\/",
            //            "\/Date(1547215083000)\/",
            //            "\/Date(1547225083000)\/",
            //            ....
            //            ]
            //        }
            //        iServiceProviderCalendarId - Array of iServiceProviderCalendarId
            //        iProviderUserId - The iProviderUserId
            //        dDate - Array of Epoch Dates
        var dictosend:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var arrayofIDS:Array = [] as Array
        var arrayofDATES:Array = [] as Array
        if arrayDictionariesRequests.count > 0 {
            for dictionary in arrayDictionariesRequests {
                //add in arrays
                if let requestDictionary:Dictionary<String,AnyObject>  = dictionary as Dictionary<String,AnyObject>? {
                if (requestDictionary["iServiceProviderCalendarId"] != nil && requestDictionary["dDate"] != nil ){
                    arrayofIDS.append(requestDictionary["iServiceProviderCalendarId"] as AnyObject)
                    arrayofDATES.append(requestDictionary["dDate"] as AnyObject)
                    }

                }
            }
               self.generic.showNativeActivityIndicator(self)
            dictosend["iServiceProviderCalendarId"] = arrayofIDS as AnyObject
            dictosend["iProviderUserId"] = self.intSuppliersecondID as AnyObject
            dictosend["dDate"] = arrayofDATES as AnyObject
        if Reachability.isConnectedToNetwork() == false {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {

            api.sharedInstance.RemoveBulkBlockedHoursFromCalendar(dictosend, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
self.generic.hideNativeActivityIndicator(self)
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                    print(RESPONSEOBJECT)

                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {

                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                                print("mesaj de final")

                            let alertController = UIAlertController(title: "", message:
                                "SUCCES_CANCEL_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                            self.present(alertController, animated: true, completion: nil)
                            let when = DispatchTime.now() + 3
                            DispatchQueue.main.asyncAfter(deadline: when){
                                alertController.dismiss(animated: true, completion: {
                                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {

                                        self.dismiss(animated: false, completion: {
                                           self.rereadcalendar()
                                        })
                                    })
                                })
                            }

                        } else {
                                print("mesaj de final")
                            let alertController = UIAlertController(title: "", message:
                                "FAIL_CANCEL_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                            self.present(alertController, animated: true, completion: nil)
                            let when = DispatchTime.now() + 3
                            DispatchQueue.main.asyncAfter(deadline: when){
                                alertController.dismiss(animated: true, completion: {
                                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {

                                        self.dismiss(animated: false, completion: {
                                            self.rereadcalendar()
                                        })
                                    })
                                })
                            }

                            }

                        }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in

                    print("mesaj de final")
                    self.generic.hideNativeActivityIndicator(self)
                let alertController = UIAlertController(title: "", message:
                    "FAIL_CANCEL_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                self.present(alertController, animated: true, completion: nil)
                let when = DispatchTime.now() + 3
                DispatchQueue.main.asyncAfter(deadline: when){
                    alertController.dismiss(animated: true, completion: {
                        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {

                            self.dismiss(animated: false, completion: {
                                self.rereadcalendar()
                            })
                        })
                    })
                }
            })
        }
    }
    }

    
    func RemoveBlockedHouresFromCalendar (dictosend:Dictionary<String,AnyObject>) {
   
        print("howManyToSend request: \(howManyToSend)")
//        self.howManyToSend  -= 1
        
        if Reachability.isConnectedToNetwork() == false {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            self.generic.showNativeActivityIndicator(self)
            api.sharedInstance.RemoveBlockedHouresFromCalendar(dictosend, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                    print(RESPONSEOBJECT)
                    
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                            
                            
//                            print("succes stergere")
//                            print("howManyToSend: \(self.howManyToSend)")
                            
                            self.howManyWereSent += 1
                            self.howManyToSend -= 1
                            
                            if self.howManyToSend == 0
                            {
                                print("mesaj de final")
                                self.generic.hideNativeActivityIndicator(self)

                                let coolMessage = "SUCCES_CANCEL_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                let refreshAlert = UIAlertController(title: "", message: coolMessage, preferredStyle: UIAlertController.Style.alert)
                                refreshAlert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in

                                    self.dismiss(animated: true, completion: nil)

                                }))
                                self.present(refreshAlert, animated: true, completion: nil)

                                return
                            }
                            else
                            {

                                self.RemoveBlockedHouresFromCalendar2(dictosend: self.arrayDictionariesRequests[self.howManyWereSent])
                            }
                            
                            

                            

                            
                            
                            // contor

//                            self.present(refreshAlert, animated: true, completion: nil)
                        } else {
//                            print("fail stergere")
//                            print("howManyToSend: \(self.howManyToSend)")
                            
                            self.howManyWereSent += 1
                            self.howManyToSend -= 1
                            
                            if self.howManyToSend == 0
                            {
                                print("mesaj de final")
                                self.generic.hideNativeActivityIndicator(self)
                                let coolMessage = "FAIL_CANCEL_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                let refreshAlert = UIAlertController(title: "", message: coolMessage, preferredStyle: UIAlertController.Style.alert)
                                refreshAlert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
                                    self.dismiss(animated: false, completion: nil)
                                    
                                }))
                                self.present(refreshAlert, animated: true, completion: nil)

                                return
                            }
                            else
                            {
                                
                                self.RemoveBlockedHouresFromCalendar2(dictosend: self.arrayDictionariesRequests[self.howManyWereSent])
                            }
                            
//                            self.howManyFailed += 1
                            
                            // Something is wrong
                            //contor
//                            self.present(refreshAlert, animated: true, completion: nil)
//
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                print("fail stergere 2")
//                print("howManyToSend: \(self.howManyToSend)")
                
                self.howManyWereSent += 1
                self.howManyToSend -= 1
                
                if self.howManyToSend == 0
                {
                    print("mesaj de final")
                    self.generic.hideNativeActivityIndicator(self)
                    let coolMessage = "FAIL_CANCEL_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    let refreshAlert = UIAlertController(title: "", message: coolMessage, preferredStyle: UIAlertController.Style.alert)
                    refreshAlert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
                        self.dismiss(animated: false, completion: nil)
                        
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                    
                    return
                 }
                else
                {
                    
                    self.RemoveBlockedHouresFromCalendar2(dictosend: self.arrayDictionariesRequests[self.howManyWereSent])
                }
//                self.howManyFailed += 1
//                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
    
     func RemoveBlockedHouresFromCalendar2 (dictosend:Dictionary<String,AnyObject>)
     {
        print("howManyToSend request: \(howManyToSend)")
        //        self.howManyToSend  -= 1
        
        if Reachability.isConnectedToNetwork() == false {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            
            api.sharedInstance.RemoveBlockedHouresFromCalendar(dictosend, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                    print(RESPONSEOBJECT)
                    
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                            
                            
                            //                            print("succes stergere")
                            //                            print("howManyToSend: \(self.howManyToSend)")
                            
                            self.howManyWereSent += 1
                            self.howManyToSend -= 1
                            
                            if self.howManyToSend == 0
                            {
                                print("mesaj de final")
                                self.generic.hideNativeActivityIndicator(self)
                                
                                let coolMessage = "SUCCES_CANCEL_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                let refreshAlert = UIAlertController(title: "", message: coolMessage, preferredStyle: UIAlertController.Style.alert)
                                refreshAlert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    self.dismiss(animated: true, completion: nil)
                                    
                                }))
                                self.present(refreshAlert, animated: true, completion: nil)
                                
                                return
                            }
                            else
                            {
                                
                                self.RemoveBlockedHouresFromCalendar(dictosend: self.arrayDictionariesRequests[self.howManyWereSent])
                            }
                            
                            
                            
                            
                            
                            
                            
                            // contor
                            
                            //                            self.present(refreshAlert, animated: true, completion: nil)
                        } else {
                            //                            print("fail stergere")
                            //                            print("howManyToSend: \(self.howManyToSend)")
                            
                            self.howManyWereSent += 1
                            self.howManyToSend -= 1
                            
                            if self.howManyToSend == 0
                            {
                                print("mesaj de final")
                                self.generic.hideNativeActivityIndicator(self)
                                let coolMessage = "FAIL_CANCEL_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                let refreshAlert = UIAlertController(title: "", message: coolMessage, preferredStyle: UIAlertController.Style.alert)
                                refreshAlert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
                                    self.dismiss(animated: false, completion: nil)
                                    
                                }))
                                self.present(refreshAlert, animated: true, completion: nil)
                                
                                return
                            }
                            else
                            {
                                
                                self.RemoveBlockedHouresFromCalendar(dictosend: self.arrayDictionariesRequests[self.howManyWereSent])
                            }
                            
                            //                            self.howManyFailed += 1
                            
                            // Something is wrong
                            //contor
                            //                            self.present(refreshAlert, animated: true, completion: nil)
                            //
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                //                print("fail stergere 2")
                //                print("howManyToSend: \(self.howManyToSend)")
                
                self.howManyWereSent += 1
                self.howManyToSend -= 1
                
                if self.howManyToSend == 0
                {
                    print("mesaj de final")
                    self.generic.hideNativeActivityIndicator(self)
                    let coolMessage = "FAIL_CANCEL_BLOCK_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    let refreshAlert = UIAlertController(title: "", message: coolMessage, preferredStyle: UIAlertController.Style.alert)
                    refreshAlert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
                        self.dismiss(animated: false, completion: nil)
                        
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                    
                    return
                }
                else
                {
                    
                    self.RemoveBlockedHouresFromCalendar(dictosend: self.arrayDictionariesRequests[self.howManyWereSent])
                }
                //                self.howManyFailed += 1
//                self.generic.hideNativeActivityIndicator(self)
                //                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
     }
    func rereadcalendar() {
          self.generic.hideNativeActivityIndicator(self)
//        let displayedwindows = UIApplication.shared.keyWindow
//        for subview in displayedwindows!.subviews as [UIView] {
//            if let alertvisible = subview as? UIAlertController {
//          alertvisible.dismiss(animated: false, completion: nil)
//        }
//        }

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
    
}




////
////  BlockingHoursTableViewController.swift
////  BThere
////
////  Created by Ioan Ungureanu on 09/05/2018
////  Copyright © 2018 Bthere. All rights reserved.
////
//
//import UIKit
//import MGSwipeTableCell
//protocol reloadAllAfterDelete {
//    func reloadall()
//}
//class BlockingHoursTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,reloadAllAfterDelete {
//    // Outlets
//    @IBOutlet var topBorderView: UIView!
//    @IBOutlet var popConstraint: NSLayoutConstraint!
//    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var tblAppointments: UITableView!
//    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
//    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
//    var BlockHouresObjArray:Array<BlockHouresObj> =  Array<BlockHouresObj>()
//    var intSuppliersecondID:Int = 0
//    // Variables
//    var generic:Generic = Generic()
//    var whichOpenMe = 0
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            popConstraint.constant = 75 // 139
//        } else {
//            popConstraint.constant = 75
//        }
//        lblTitle.text = "CANCEL_BLOCK_HOURES".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        tryGetSupplierCustomerUserIdByEmployeeId()
//        tblAppointments.delegate = self
//        tblAppointments.dataSource = self
//
//        self.tblAppointments.separatorStyle = UITableViewCellSeparatorStyle.none
//    }
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//
//    @IBAction func btnClose(_ sender: AnyObject) {
//        self.dismiss(animated: false, completion: nil)
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return 1
//    }
//
//
//    @objc func numberOfSections(in tableView: UITableView) -> Int {
//
//        if ( self.BlockHouresObjArray.count > 0) {
//            self.topBorderView.isHidden = false
//        } else {
//            self.topBorderView.isHidden = true
//        }
//
//        return  self.BlockHouresObjArray.count
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let reuseIdentifier = "mgswipe"
//        let cell:MGSwipeTableCell = tableView.dequeueReusableCell(withIdentifier:reuseIdentifier) as! MGSwipeTableCell
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        let date = dateFormatter.string(from: Global.sharedInstance.getStringFromDateString(self.BlockHouresObjArray[indexPath.section].cDate as String))
//        let hourS:String = self.BlockHouresObjArray[indexPath.section].tFromHoure
//        let hourE:String = self.BlockHouresObjArray[indexPath.section].tToHoure
//        let targetStr = date + "      " + hourS + " - " + hourE
//        let range = NSMakeRange(0, date.characters.count + 1)
//        cell.textLabel?.attributedText = attributedString(from: targetStr, BoldRange:  range)
//        let mybtn =  MGSwipeButton(title: "", icon: UIImage(named:"recicle-bin.png"), backgroundColor: .clear) {
//            (sender: MGSwipeTableCell!) -> Bool in
//            print("Convenience callback for swipe buttons!")
//            let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
//            let viewpopupcancel = storyboardtest.instantiateViewController(withIdentifier: "CancelBlockHoursViewController") as! CancelBlockHoursViewController
//            if self.iOS8 {
//                viewpopupcancel.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            } else {
//                viewpopupcancel.modalPresentationStyle = UIModalPresentationStyle.currentContext
//            }
//            let onestr = "AT".localized(LanguageMain.sharedInstance.USERLANGUAGE) + "\n" + date
//            if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
//                viewpopupcancel.date =  hourE + " - " +  hourS + " " + onestr
//            } else {
//              viewpopupcancel.date = hourS + " - " + hourE + " " + onestr
//            }
//
//            viewpopupcancel.iProviderUserId = self.intSuppliersecondID
//            viewpopupcancel.iServiceProviderCalendarId = self.BlockHouresObjArray[indexPath.section].iServiceProviderCalendarId
//            viewpopupcancel.dDate = self.BlockHouresObjArray[indexPath.section].cDate
//            viewpopupcancel.ISFROMCALENDARVIEW = false
//            viewpopupcancel.ISFROMBLOCKTABLE = true
//            viewpopupcancel.delegateDel = self
//            self.present(viewpopupcancel, animated: true, completion: nil)
//            return true
//        }
//        mybtn.buttonWidth = cell.frame.size.height - 2
//        cell.leftButtons = [  mybtn ]
//        cell.leftSwipeSettings.transition = .drag
//        cell.selectionStyle = .none
//        return cell
//    }
//
//         @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//    func GetBlockedHouresFromCalendar() {
//        self.BlockHouresObjArray =  Array<BlockHouresObj>()
//        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        var supplierID:Int = 0
//        if Global.sharedInstance.providerID == 0 {
//            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
//                supplierID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//            }
//        } else {
//            supplierID = Global.sharedInstance.providerID
//        }
//        let calendar = Foundation.Calendar.current
//        let timenow = Date()
//        var timeold = (calendar as NSCalendar).date(byAdding: .month, value: -1, to: timenow, options: [])!
//        var timemax = Date()
//
//        timemax = (calendar as NSCalendar).date(byAdding: .month, value: 6, to: timeold, options: [])!
//        dicSearch["iProviderUserId"] = self.intSuppliersecondID as AnyObject
//        dicSearch["nvFromDate"] = Global.sharedInstance.convertNSDateToString(timeold) as AnyObject
//        dicSearch["nvToDate"] = Global.sharedInstance.convertNSDateToString(timemax) as AnyObject
//        self.generic.showNativeActivityIndicator(self)
//        print("aicie \(supplierID)")
//        if Reachability.isConnectedToNetwork() == false
//        {
//            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//        }
//        else
//        {
//            api.sharedInstance.GetBlockedHouresFromCalendar(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                if let _ = responseObject as? Dictionary<String,AnyObject> {
//                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                      print(RESPONSEOBJECT)
//                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
//                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
//                        {
//                            if  let _ = RESPONSEOBJECT["Result"] as? NSArray {
//                                let ps:BlockHouresObj = BlockHouresObj()
//                                self.BlockHouresObjArray = ps.dicToBlockHouresToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
//                                print(self.BlockHouresObjArray)
//                                self.tblAppointments.reloadData()
//                            }
//                        } else {
//                                self.tblAppointments.reloadData()
//
//                        }
//                    }
//                      self.generic.hideNativeActivityIndicator(self)
//                }
//
//            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                self.generic.hideNativeActivityIndicator(self)
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//
//            })
//        }
//
//    }
//
//    func reloadall() {
//        GetBlockedHouresFromCalendar()
//    }
//    //1
//    func tryGetSupplierCustomerUserIdByEmployeeId() {
//        var y:Int = 0
//        var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
//        let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
//        if let x:Int = a.value(forKey: "currentUserId") as? Int{
//            y = x
//        }
//        }
//        dicuser["iUserId"] =  y as AnyObject
//        api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//            if let _ = responseObject as? Dictionary<String,AnyObject> {
//                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                if let _:Int = RESPONSEOBJECT["Result"] as? Int
//                {
//                    let myInt :Int = RESPONSEOBJECT["Result"] as! Int
//                    print("sup id e ok ? " + myInt.description)
//                    if myInt == 0 {
//                        //NO EMPL NO BUSINESS
//                    } else {
//                        self.GetSecondUserIdByFirstUserId(myInt)
//                    }
//                }
//            }
//        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            if AppDelegate.showAlertInAppDelegate == false
//            {
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                AppDelegate.showAlertInAppDelegate = true
//            }
//        })
//    }
//    //2
//    func GetSecondUserIdByFirstUserId(_ employeID:Int)  {
//
//        var y:Int = 0
//        var dicEMPLOYE:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        y = employeID
//        dicEMPLOYE["iUserId"] =  y as AnyObject
//        if Reachability.isConnectedToNetwork() == false
//        {
//
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//        }
//        else
//        {
//            api.sharedInstance.GetSecondUserIdByFirstUserId(dicEMPLOYE, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                if let _ = responseObject as? Dictionary<String,AnyObject> {
//                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
//                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
//                        {
//                            print("eroare la GetSecondUserIdByFirstUserId \(RESPONSEOBJECT["Error"] ?? -1 as AnyObject)")
//                        }
//                        else
//                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
//                            {
//
//                                print("eroare la GetSecondUserIdByFirstUserId \(RESPONSEOBJECT["Error"] ?? -2 as AnyObject)")
//                            }
//
//                            else
//                            {
//                                if let _:Int = RESPONSEOBJECT["Result"] as? Int
//                                {
//                                    let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
//                                    print("SECOND USER ID \(myInt)")
//                                    if myInt > 0 {
//                                        self.setupISupplierSecondID(myInt)
//                                    }
//                                }
//                        }
//                    }
//                }
//            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                if AppDelegate.showAlertInAppDelegate == false
//                {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
//            })
//        }
//    }
//    //3
//    func setupISupplierSecondID (_ ISupplierSecondID:Int){
//        self.intSuppliersecondID = ISupplierSecondID
//        print("self.intSuppliersecondID \(self.intSuppliersecondID)")
//        GetBlockedHouresFromCalendar()
//
//    }
//    func attributedString(from string: String, BoldRange: NSRange?) -> NSAttributedString {
//        let fontSize = UIFont.systemFontSize
//        let attrs = [
//            NSFontAttributeName: UIFont.systemFont(ofSize: fontSize),
//            NSForegroundColorAttributeName: UIColor.black
//        ]
//        let BoldAttribute = [
//            NSFontAttributeName: UIFont.boldSystemFont(ofSize: fontSize),
//            ]
//        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
//        if let range = BoldRange {
//            attrStr.setAttributes(BoldAttribute, range: range)
//        }
//        return attrStr
//    }
//}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
