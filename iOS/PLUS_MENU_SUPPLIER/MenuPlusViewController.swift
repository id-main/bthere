//
//  MenuPlusViewController.swift
//  bthree-ios
//
//  Created by User on 22.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class MenuPlusViewController: UIViewController,UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    //fix menu 26.06.2018
    @IBOutlet weak var ttil:UICollectionView! //our items
    @IBOutlet weak var blackmenu:UIView!
    var itemuri:[String] = []
    var clientStoryBoard:UIStoryboard?
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var generic:Generic = Generic()
    var delegate:openFromMenuDelegate!=nil
    var clientStoryBoard2:UIStoryboard?
    let calendar = Foundation.Calendar.current
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    @IBOutlet var contentViewHeight: NSLayoutConstraint!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:16) 
        self.itemuri = [
            "NEW_EVENT".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "SLAIGHT_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "HELP_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "PLUS_MENU_CANCELLATON".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "LBLAPPOINTMENT_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "LIVE_CHAT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ]
        self.ttil.delegate = self
        self.ttil.dataSource = self
        self.ttil.layer.shadowColor = UIColor.black.cgColor
        self.ttil.layer.shadowOpacity = 0.4
        self.ttil.layer.shadowOffset = CGSize.zero
        self.ttil.layer.shadowRadius = 1.5
        //calculate height for menu view (black)
        let totalHeight: CGFloat = (self.view.frame.width / 3) * 2 //have 2 rows for menu
        contentViewHeight.constant = totalHeight
    }
    @objc func openlivechat(){
        let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let helpLiveChatViewController:HelpLiveChatViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "HelpLiveChatViewController") as! HelpLiveChatViewController
        helpLiveChatViewController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        
        if self.iOS8 {
            helpLiveChatViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            helpLiveChatViewController.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        
        self.present(helpLiveChatViewController, animated: true, completion: nil)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.itemuri.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
      //  let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuPlusViewController.openNewEvent))
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuPlusViewController.openViewLittleLate))
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuPlusViewController.openViewHelp))
        let tap4: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuPlusViewController.openCancellationView))
        let tap5: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuPlusViewController.openMyAppointments))
        let tap6: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuPlusViewController.openlivechat))
        let cell:PlusSettingssupplier = collectionView.dequeueReusableCell(withReuseIdentifier: "PlusSettingssupplier",for: indexPath) as! PlusSettingssupplier
        let i:Int = indexPath.row
        cell.rowDIfferent = i
            cell.setDisplayDatax(self.itemuri[i])
        cell.backgroundColor = UIColor.clear
        if indexPath.row % 2 == 0 {
            if indexPath.row == 0 {
                cell.rectangleVIEW.backgroundColor = Colors.sharedInstance.color6
            } else {
                cell.rectangleVIEW.backgroundColor = Colors.sharedInstance.color3
            }
        } else {
            cell.rectangleVIEW.backgroundColor = Colors.sharedInstance.color4
        }
        switch (indexPath.row) {
       // case 0:
        //    cell.addGestureRecognizer(tap1)
        case 1:
             cell.addGestureRecognizer(tap2)
        case 2:
            cell.addGestureRecognizer(tap3)
        case 3:
            cell.addGestureRecognizer(tap4)
        case 4:
            cell.addGestureRecognizer(tap5)
        case 5:
            cell.addGestureRecognizer(tap6)
        default:
            print("item")
        }
       
        return cell
    }
    func goToScreens(_ screen:Int) {
        switch screen {
        case 1:
         //   openNewEvent ()
            break
        case 2:
           openViewLittleLate()
            break
        case 3:
         openViewHelp()
            break
        case 4:
            openCancellationView()
            break
        case 5:
            openMyAppointments()
        default:
            //nothing
            break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let totalHeight: CGFloat = (self.view.frame.width / 3) * 2 //have 2 rows for menu
        contentViewHeight.constant = totalHeight
        Global.sharedInstance.menuPlusViewController = self
        clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
        
        let tapMenu:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMenuPlus))
        view.addGestureRecognizer(tapMenu)
     //   self.view.bringSubview(toFront: blackmenu)
       
       
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex indexPath: IndexPath?) -> Int {
//
//        return 0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex indexPath: IndexPath?) -> Int {
//
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.init(top: 0,left: 0,bottom: 0,right: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt
        indexPath: IndexPath) {
        let i:Int = indexPath.row
        print("my item \(i)")
      //  self.goToScreens(i + 1)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, UIEdgeInsets indexPath: IndexPath) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 0,bottom: 0,right: 0);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalHeight: CGFloat = (self.view.frame.width / 3)
        let totalWidth: CGFloat = (self.view.frame.width / 3)
        print("mod")
        
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // Open new event view
    @objc func openNewEvent () {
        //        clientStoryBoard2 = UIStoryboard(name: "Testing", bundle: nil)
        //        let viewCon:ClientNewEvent = clientStoryBoard2?.instantiateViewControllerWithIdentifier("ClientNewEvent") as! ClientNewEvent
        //        viewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
        //        self.dismissViewControllerAnimated(true, completion: nil)
        //        delegate.openFromMenu(viewCon)
    }
    
    
    // Open help view
    @objc func openViewHelp () {
        clientStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let viewCon:NewHelpViewController = clientStoryBoard?.instantiateViewController(withIdentifier: "NewHelpViewController") as! NewHelpViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.dismiss(animated: true, completion: nil)
        delegate.openFromMenu(viewCon)
    }
    
    
    func openViewLastMinute() {
        let dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        api.sharedInstance.GetListDiscount90(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                let discount90Obj:Discount90Obj = Discount90Obj()
                if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                    Global.sharedInstance.arrDiscount90Obj = discount90Obj.discount90ObjDicToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                }
                let viewCon:EleventhHourViewController = self.clientStoryBoard?.instantiateViewController(withIdentifier: "EleventhHourViewController") as! EleventhHourViewController
                viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                self.dismiss(animated: true, completion: nil)
                self.delegate.openFromMenu(viewCon)
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            if AppDelegate.showAlertInAppDelegate == false
//            {
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                AppDelegate.showAlertInAppDelegate = true
//            }
        })
    }
    
    
    @objc func openViewLittleLate() {
        GetCustomerOrders(3)
    }
    
    
    func openViewNewAppointment() {
        Alert.sharedInstance.showAlert("לא פותח", vc: self)
        //        let viewCon:NewAppointmentClientViewController = clientStoryBoard!.instantiateViewControllerWithIdentifier("NewAppointmentClientViewController") as! NewAppointmentClientViewController
        //        viewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
        //        self.dismissViewControllerAnimated(true, completion: nil)
        //        delegate.openFromMenu(viewCon)
        
    }
    
    
    func openViewNotArrive() {
        GetCustomerOrders(2)
    }
    
    func openViewUpdateTurn() {
        Alert.sharedInstance.showAlert("לא פותח", vc: self)
        //GetCustomerOrders(1)
    }
    
    
    // Open my appointments
    @objc func openMyAppointments() {
        GetCustomerOrders(1)
    }
    
    
    override func viewWillLayoutSubviews() {
        
    }
    
    //delegate func to dismiss view controller when touch anywhere place on the screen opened the menu
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    struct currentMonthYear
    {
        var month:Int = 0
        var year:Int = 0
    }
    
    func getCurrentMonthAndYear() -> currentMonthYear
    {
        
        
        let currDate = Date()
        let kalendar = Foundation.Calendar.current
        var year:Int = kalendar.component(.year, from: currDate)
        var month:Int = kalendar.component(.month, from: currDate)
        if month == 1
        {
            month = 12
            year -= 1
        }
        else if month <= 12 && month > 1
        {
            month -= 1
        }
        let final:currentMonthYear = currentMonthYear.init(month: month, year: year)
        
        
        return final
    }
    
    
    //קבלת רשימת התורים של לקוח בביזר
    func GetCustomerOrders(_ whichOpened:Int)
    {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        
        
        dic["iFilterByMonth"] = iFilterByMonth as AnyObject
        dic["iFilterByYear"] = iFilterByYear as AnyObject
        
//        dic["iFilterByMonth"] = getCurrentMonthAndYear().month as AnyObject
//        dic["iFilterByYear"] = getCurrentMonthAndYear().year as AnyObject
        
        if Reachability.isConnectedToNetwork() == false
        {
            
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCustomerOrders(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    let ps:OrderDetailsObj = OrderDetailsObj()
                    if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                    Global.sharedInstance.ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                   //\\     print("raspuns request: + \(RESPONSEOBJECT["Result"] as! NSArray)")
                    }
                    if Global.sharedInstance.ordersOfClientsArray.count != 0
                    {
                        for obj:OrderDetailsObj in Global.sharedInstance.ordersOfClientsArray
                        {
                            print("obj appointments: \(obj.getDic())")
                        }
                        var filteredarray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>()
                        for item in Global.sharedInstance.ordersOfClientsArray {
                            if (!self.hourisless(item) && self.isdateequal(item) ) || self.isdateafter(item) {
                                if item.nvComment != "BlockedBySupplier" {
                                    if !filteredarray.contains(item) {
                                        filteredarray.append(item)
                                    }
                                }
                            }
                            filteredarray =   filteredarray.sorted(by: { ($1 ).dtDateOrder > ($0 ).dtDateOrder })
                            Global.sharedInstance.ordersOfClientsArray = filteredarray
                        }
                        let viewCon:myAppointmentsViewController = self.clientStoryBoard!.instantiateViewController(withIdentifier: "myAppointmentsViewController") as! myAppointmentsViewController
                        viewCon.whichOpenMe = whichOpened
                        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                        self.dismiss(animated: true, completion: nil)
                        self.delegate.openFromMenu(viewCon)
                    }
                    else
                    {
                        Alert.sharedInstance.showAlert("NO_APPOINTMENTS__FROM_YOU".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
    
    // Get cancellation
    func getCancellationAppointments () {
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        dic["iFilterByMonth"] = iFilterByMonth as AnyObject
        dic["iFilterByYear"] = iFilterByYear as AnyObject
        if Reachability.isConnectedToNetwork() == false {
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        } else {
            api.sharedInstance.GetCustomerOrders(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    let ps:OrderDetailsObj = OrderDetailsObj()
                    
                    if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                        Global.sharedInstance.ordersOfClientsArray = ps.OrderDetailsObjToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                    }
                    if Global.sharedInstance.ordersOfClientsArray.count != 0 {
                        let viewCon:CustomerCancellationList = self.clientStoryBoard!.instantiateViewController(withIdentifier: "CustomerCancellationList") as! CustomerCancellationList
                        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                        self.dismiss(animated: true, completion: nil)
                        self.delegate.openFromMenu(viewCon)
                    } else {
                        Alert.sharedInstance.showAlert("NO_APPOINTMENTS__FROM_YOU".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
    
    //MARK: - dismissMenuPlus
    @objc func dismissMenuPlus() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func openCancellationView () {
        GetCustomerOrders(2)
    }
    func hourisless (_ itemx: OrderDetailsObj) -> Bool {
        var islessh:Bool  = false
        var eventHour:Int = 0
        var eventMinutes:Int = 0
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
                            if let a2:Character =  hourstring[hourstring.index(hourstring.startIndex, offsetBy: 1)] as Character?{
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
                                if let _:String = fullNameArr[1] as String?  {
                                    let hourstring:String = fullNameArr[1]
                                    let numberFromString:Int = Int(hourstring)!
                                    eventMinutes = numberFromString
                                }
                            }
                        }
                    }
                }
            }
            if eventMinutes < minutulacum! {
                islessh = true
            } else {
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
