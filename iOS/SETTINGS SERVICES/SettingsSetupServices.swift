//
//  SettingsSetupServices.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 28/02/19.
//  Copyright © 2019 Bthere. All rights reserved.
//
//
import Foundation
import UIKit
protocol isOpenRowDelegate3 {
    func reloadTableFull()
    func openRow(_WHICHCELL:Int, _WHICHSTATE:Bool)
    func editRow(_WHICHCELL:Int,_WHICHSTATE:Bool)
    func savedDataOn(_WHICHCELL:Int, _WHICHSTATE:Bool, _WHICHSTATE2:Bool, _firstSel: objWorkingHours, _secondsel: objWorkingHours)
    func closeandclearcell(_WHICHCELL:Int)
    func deleteServiceaddtoArray(_whichID:Int)
    func AddServiceaddtoArray(_whichID:Int)
    func UpdateServiceaddtoArray(_whichID:Int)
}

class SettingsSetupServices:UIViewController, UITableViewDelegate, UITableViewDataSource,isOpenRowDelegate3 {
    var SERVICES_ID_TO_DELETE:Array<Int> = Array<Int>()
    var SERVICES_ID_TO_UPDATE:Array<Int> = Array<Int>()
    var SERVICES_ID_TO_ADD:Array<Int> = Array<Int>()
    var generic:Generic = Generic()
    var allclosed:Bool = true
    var AddisClosed:Bool = true //by default add service is not touch on load
    var EditCell:Int = -1 // default value
    var EditisClosed:Bool = true //by default edit service is closed
    var openRows:Array<Bool> = []
    @IBOutlet weak var backImage:UIImageView!
    @IBOutlet weak var TitleScreen:UILabel!
    @IBOutlet weak var Container:UITableView!
    @IBOutlet weak var closeButton:UIButton!
    @IBOutlet weak var validateScreen:UIButton!
    @IBAction func closeButton(_ sender:UIButton) {
        gotosettings()
    }
    func closeandgotosettings(){

        var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
        if dicUserId["currentUserId"] as! Int != 0
        {
            let myint =  dicUserId["currentUserId"] as! Int
            self.generic.showNativeActivityIndicator(self)
                if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
                {
                   self.getProviderAllDetailsbySimpleUserID(myint)
                }
                else
                {
                    self.getProviderAllDetails(myint)
                }
        }
    }
    func gotosettings(){
        self.generic.hideNativeActivityIndicator(self)
        Global.sharedInstance.isProvider = true
        Global.sharedInstance.whichReveal = true
        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
        frontviewcontroller!.pushViewController(viewcon, animated: false)
        //initialize REAR View Controller- it is the LEFT hand menu.
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }

    func GetProviderSettingsForCalendarmanagement() {
        let newObjectCalendar = objCalendarProperties()
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails

            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        self.generic.showNativeActivityIndicator(self)
        dicSearch["iProviderId"] = providerID as AnyObject
        print("aicie \(providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
        }
        else
        {
            api.sharedInstance.GetProviderSettingsForCalendarmanagement(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    self.generic.hideNativeActivityIndicator(self)
                    print("responseObject \(responseObject ??  1 as AnyObject)")
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                            {
                                let possiblerezult:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                                if let _:Bool = possiblerezult["bIsAvailableForNewCustomer"] as? Bool {
                                    newObjectCalendar.bIsAvailableForNewCustomer = possiblerezult["bIsAvailableForNewCustomer"] as! Bool
                                }
                                if let _:Bool = possiblerezult["bIsGoogleCalendarSync"] as? Bool {
                                    let ax = possiblerezult["bIsGoogleCalendarSync"] as! Bool
                                    if ax == true {
                                        newObjectCalendar.bSyncGoogleCalendar = true
                                    } else {
                                        newObjectCalendar.bSyncGoogleCalendar = false
                                    }
                                }
                                if let _:Bool = possiblerezult["bLimitSeries"] as? Bool {
                                    let ax = possiblerezult["bLimitSeries"] as! Bool
                                    if ax == true {
                                        newObjectCalendar.bLimitSeries = true
                                    } else {
                                        newObjectCalendar.bLimitSeries = false
                                    }
                                }
                                if let _:Int = possiblerezult["iCustomerViewLimit"] as? Int {
                                    newObjectCalendar.iCustomerViewLimit = possiblerezult["iCustomerViewLimit"] as! Int
                                }
                                if let _:Int = possiblerezult["iFirstCalendarViewType"] as? Int {
                                    newObjectCalendar.iFirstCalendarViewType = possiblerezult["iFirstCalendarViewType"] as! Int
                                }
                                if let _:Int = possiblerezult["iHoursForPreCancelServiceByCustomer"] as? Int {
                                    let ax = possiblerezult["iHoursForPreCancelServiceByCustomer"] as! Int
                                    if ax == 1 {
                                        newObjectCalendar.iHoursForPreCancelServiceByCustomer = 1
                                    } else {
                                        newObjectCalendar.iHoursForPreCancelServiceByCustomer = 0
                                    }
                                }
                                if let _:Int = possiblerezult["iMaxServiceForCustomer"] as? Int {
                                    newObjectCalendar.iMaxServiceForCustomer = possiblerezult["iMaxServiceForCustomer"] as! Int
                                }
                                if let _:Int = possiblerezult["iPeriodInWeeksForMaxServices"] as? Int {
                                    newObjectCalendar.iPeriodInWeeksForMaxServices = possiblerezult["iPeriodInWeeksForMaxServices"] as! Int
                                }
                                Global.sharedInstance.generalDetails.calendarProperties = newObjectCalendar
                                Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.calendarProperties = newObjectCalendar
                                print(newObjectCalendar.getDic())

                            }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)

            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetProviderSettingsForCalendarmanagement()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        self.view.addBackground()
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.backImage.transform = scalingTransform
            self.backImage.transform = scalingTransform
        }
   
        TitleScreen.text = "SETUP_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        validateScreen.setTitle("SAVEAddHoursButton".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        Container.delegate = self
        Container.dataSource = self
        Container.separatorStyle = .none
        Global.sharedInstance.generalDetails.arrObjProviderServices = []
        Global.sharedInstance.generalDetails.arrObjProviderServices = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjProviderServices
        print(" arrObjProviderServices servicii  \( Global.sharedInstance.generalDetails.arrObjProviderServices.count )")
        for _ in Global.sharedInstance.generalDetails.arrObjProviderServices {
             openRows.append(false)
        }
        self.Container.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var x:Int = 1
        //case 1 -> no service -> edit service cell -> number of rows 1
        if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0 {
            x = 1
        } else {
            //case 2-> services> 0 -> list services table   + add service row -> number of services + 1 (all closed)
            if allclosed == true {
                x = Global.sharedInstance.generalDetails.arrObjProviderServices.count + 1
            } else {
                //case 3 -> services> 0 -> list services table   + add service row -> number of services + edit service cell  + 1 (one open for edit)
                x = Global.sharedInstance.generalDetails.arrObjProviderServices.count + 2
            }
        }
        return x
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mycel = UITableViewCell()
        let myindex = indexPath.row
        //case 1 -> no service -> edit service cell -> number of rows 1
        if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0 {
            //nothing now
            let cell:SettingsNewBussinesServicesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsNewBussinesServicesTableViewCell") as! SettingsNewBussinesServicesTableViewCell
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.setDisplayDataNull()
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        } else {
            //case 2-> services> 0 -> list services table   + add service row -> number of services + 1 (all closed)
            if allclosed == true {
                if myindex == Global.sharedInstance.generalDetails.arrObjProviderServices.count   {
                    print("last row")
                    let cell:SettingsJoAddNewServiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsJoAddNewServiceTableViewCell") as! SettingsJoAddNewServiceTableViewCell
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.setState(_isClosed: self.AddisClosed)
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    return cell
                } else {
                    //last row  x = Global.sharedInstance.generalDetails.arrObjProviderServices.count + 1
                    //other rows
                    let cell:SettingsServiceInListCell = tableView.dequeueReusableCell(withIdentifier: "SettingsServiceInListCell") as! SettingsServiceInListCell
                    cell.tag = indexPath.row
                    cell.delegate = self
                    cell.setEditState(_isEditOpen: false)
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row].nvServiceName)
                    return cell
                }

            } else {
                //case 3 -> services> 0 -> list services table   + add service row -> number of services + edit service cell  + 1 (one open for edit)
                //last row


            if EditisClosed == true  {
                if myindex == Global.sharedInstance.generalDetails.arrObjProviderServices.count     {
                    print("add row")
                    let cell:SettingsJoAddNewServiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsJoAddNewServiceTableViewCell") as! SettingsJoAddNewServiceTableViewCell
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.setState(_isClosed: self.AddisClosed)
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                                        return cell
                } else if myindex == Global.sharedInstance.generalDetails.arrObjProviderServices.count + 1  {
                    print("edit row")
                    let cell:SettingsNewBussinesServicesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsNewBussinesServicesTableViewCell") as! SettingsNewBussinesServicesTableViewCell
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.delegate = self
                    cell.tag = indexPath.row
                    cell.txtPrice.tag = -11
                    cell.setDisplayDataNull()

                    return cell
                } else {
                    let cell:SettingsServiceInListCell = tableView.dequeueReusableCell(withIdentifier: "SettingsServiceInListCell") as! SettingsServiceInListCell
                    cell.setEditState(_isEditOpen: false)
                    cell.tag = indexPath.row
                    cell.delegate = self
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                   // cell.setEditState(_isEditOpen: self.EditisClosed)
                    cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row].nvServiceName)
                    return cell
                }
              }
            else  if EditisClosed == false  {   //case 3 -> services> 0 -> list services table    -> number of services + edit service cell  + 1 (one open for edit) + add service row
                if myindex == self.EditCell + 1 { //because origin is existing one
                    let cell:SettingsNewBussinesServicesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsNewBussinesServicesTableViewCell") as! SettingsNewBussinesServicesTableViewCell
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.delegate = self
                    cell.txtPrice.tag = myindex - 1
                    cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row - 1])
                    cell.iProviderServiceId = Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row - 1].iProviderServiceId
                    cell.tag = indexPath.section
                    return cell
                }
                if myindex == self.EditCell + 2 {
                    let cell:SettingsJoAddNewServiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsJoAddNewServiceTableViewCell") as! SettingsJoAddNewServiceTableViewCell
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.setState(_isClosed: self.AddisClosed)
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    return cell
                }
                if myindex == self.EditCell {
                    let cell:SettingsServiceInListCell = tableView.dequeueReusableCell(withIdentifier: "SettingsServiceInListCell") as! SettingsServiceInListCell
                    cell.tag = indexPath.row
                    cell.setEditState(_isEditOpen: true)
                    cell.delegate = self
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row].nvServiceName)
                    return cell
                }
                if myindex < self.EditCell {
                    let cell:SettingsServiceInListCell = tableView.dequeueReusableCell(withIdentifier: "SettingsServiceInListCell") as! SettingsServiceInListCell
                    cell.tag = indexPath.row
                    cell.setEditState(_isEditOpen: false)
                    cell.delegate = self
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero

                   cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row].nvServiceName) //allways have add
                    return cell
                    }
                if myindex > self.EditCell + 2 {
                        let cell:SettingsServiceInListCell = tableView.dequeueReusableCell(withIdentifier: "SettingsServiceInListCell") as! SettingsServiceInListCell
                        cell.tag = indexPath.row - 2
                        cell.setEditState(_isEditOpen: false)
                        cell.delegate = self
                        cell.selectionStyle = .none
                        cell.separatorInset = UIEdgeInsets.zero
                        cell.layoutMargins = UIEdgeInsets.zero
                    print(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row - 2].nvServiceName)
                        cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row - 2].nvServiceName) //allways have add
                    return cell
                    }


            }
        }
        }

        return mycel
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 print(indexPath.row)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let ax = indexPath.row
        var x:CGFloat  = 0.0
        let y = view.frame.size.height * 0.07
        let y2 = view.frame.size.height
        if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0 {
            x = y2
        } else {
            if EditisClosed == true  {
            //case 2-> services> 0 -> list services table   + add service row -> number of services + 1 (all closed)
            if allclosed == true {
                x =  y
            } else {
                //case 3 -> services> 0 -> list services table   + add service row -> number of services + edit service cell  + 1 (one open for edit)
                if ax == Global.sharedInstance.generalDetails.arrObjProviderServices.count + 1 {
                    x = y2
                } else {

                        x = y
                }
            }
        }
            if EditisClosed == false && self.EditCell != -1 {
                //case 2-> services> 0 -> list services table   + add service row -> number of services + 1 (all closed)
                if allclosed == true {
                    x =  y
                } else {
                    //case 3 -> services> 0 -> list services table   + add service row -> number of services + edit service cell  + 1 (one open for edit)
                    if ax == self.EditCell + 1 {
                        x = y2
                    } else {

                        x = y
                    }
                }
            }
            }
        return x
    }
    func closeandclearcell(_WHICHCELL:Int) {
        allclosed = true
        AddisClosed = true
        self.EditisClosed = true
        self.EditCell = -1
        self.Container.reloadData()
    }

    func openRow(_WHICHCELL:Int, _WHICHSTATE:Bool) {
        allclosed = false
        AddisClosed = false
        EditisClosed = true
        self.EditCell = -1
        self.EditCell = _WHICHCELL
        self.Container.reloadData()
        let numberOfRows = Container.numberOfRows(inSection: 0)
        if numberOfRows > 0 {
            let indexPath = IndexPath(
                row: numberOfRows - 1,
                section: 0)
            self.Container.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    func editRow(_WHICHCELL:Int, _WHICHSTATE:Bool) {
        self.EditCell = _WHICHCELL
        EditisClosed = false
        AddisClosed = true
        allclosed = false
        self.Container.reloadData()
    }
    func savedDataOn(_WHICHCELL:Int, _WHICHSTATE:Bool, _WHICHSTATE2:Bool, _firstSel: objWorkingHours, _secondsel: objWorkingHours ) {

        self.Container.reloadData()


    }

    func reloadTableFull() {
        self.Container.reloadData()
    }
    func tryGetSupplierCustomerUserIdByEmployeeId() {
        var y:Int = 0
        var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let x:Int = a.value(forKey: "currentUserId") as? Int{
                y = x
            }
        }
        dicuser["iUserId"] =  y as AnyObject
        api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                {
                    let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                    print("sup id e ok ? " + myInt.description)
                    if myInt == 0 {

                    } else {
                        self.GetSecondUserIdByFirstUserId(myInt)
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in

        })
    }
    //2
    func GetSecondUserIdByFirstUserId(_ employeID:Int)  {
        var y:Int = 0
        var dicEMPLOYE:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        y = employeID
        dicEMPLOYE["iUserId"] =  y as AnyObject
        print("\n********************************* GetSecondUserIdByFirstUserId  ********************\n")
        if Reachability.isConnectedToNetwork() == false
        {

        }
        else
        {
            api.sharedInstance.GetSecondUserIdByFirstUserId(dicEMPLOYE, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
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
                                    let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                    print("SECOND USER ID \(myInt)")
                                    if myInt > 0 {
                                        self.updatenow(myInt)
                                    }
                                }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in

            })
        }
    }
    func updatenow(_ iUserID:Int) {

//        Global.sharedInstance.domainBuisness = ""
//        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        dic = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.getDic()
//
//
//        if let _:Int = dic["iFieldId"]  as? Int{
//            let dicgeneraliFieldId:Int = dic["iFieldId"]  as! Int
//            Global.sharedInstance.generalDetails.iFieldId = dicgeneraliFieldId
//            for i in 0..<AppDelegate.arrDomainFilter.count {
//                var domain:Domain = Domain()
//                domain = AppDelegate.arrDomainFilter[i]
//                if domain.iCategoryRowId == dicgeneraliFieldId {
//                    Global.sharedInstance.domainBuisness = domain.nvCategoryName
//                    print("Global.sharedInstance.domainBuisness \(Global.sharedInstance.domainBuisness)")
//                }
//            }
//        }
//        Global.sharedInstance.NEWARRAYOBJWORKINGHOURS =  Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours
//        print("|Global.sharedInstance.generalDetails.iFieldId\(Global.sharedInstance.generalDetails.iFieldId)")
//        Global.sharedInstance.generalDetails.arrObjServiceProviders = []
//        Global.sharedInstance.arrObjServiceProvidersForEdit = []
//        Global.sharedInstance.generalDetails.arrObjServiceProviders = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjServiceProviders
//        print("  arrObjServiceProviders employes\( Global.sharedInstance.generalDetails.arrObjServiceProviders.count )")
//        Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjProviderServices =  Global.sharedInstance.generalDetails.arrObjProviderServices
//        print(" arrObjProviderServices servicii  \( Global.sharedInstance.generalDetails.arrObjProviderServices.count )")
//        print("calendarset \(  Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.calendarProperties.getDic())")
//        Global.sharedInstance.generalDetails.calendarProperties = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.calendarProperties
//        var dicAddProviderDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        dicAddProviderDetails["obj"] = Global.sharedInstance.generalDetails.geMASTERSecondDic(iUserID,iFieldId: Global.sharedInstance.generalDetails.iFieldId) as AnyObject
//        dicAddProviderDetails["iSupplierServiceIdForDeleteUserPermission"] = Global.sharedInstance.iSupplierServiceIdForDeleteUserPermission
//
//        self.generic.showNativeActivityIndicator(self)
//        if Reachability.isConnectedToNetwork() == false
//        {
//            self.generic.hideNativeActivityIndicator(self)
//
//        }
//        else
//        {
//            api.sharedInstance.UpdateProviderGeneralDetails(dicAddProviderDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                if let _ = responseObject as? Dictionary<String,AnyObject> {
//                    self.generic.hideNativeActivityIndicator(self)
//                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
//                        print("eroare sau nu \(RESPONSEOBJECT)")
//                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
//                            self.view.makeToast(message: "SUCCESS_SETUP_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
//                            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//                            self.generic.showNativeActivityIndicator(self)
//                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
//                                self.hidetoast()
//                                self.gotosettings()
//                            })
//                        }
//                        else
//                        {
//                            self.generic.hideNativeActivityIndicator(self)
//                            self.view.makeToast(message: "ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
//                            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
//                                self.hidetoast()
//                            })
//                        }
//                    }
//                }
//
//            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                self.generic.hideNativeActivityIndicator(self)
//            })
//        }
        RemoveSupplierService()
    }
    func hidetoast(){
        view.hideToastActivity()
    }
    @IBAction func validationtoServer(_ sender:UIButton) {
        print("Global.sharedInstance.generalDetails.arrObjProviderServices.count \(Global.sharedInstance.generalDetails.arrObjProviderServices.count)")
        if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0 {
            Alert.sharedInstance.showAlertDelegate("SELECT_SERVICE_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            return
        } else {
            sender.isUserInteractionEnabled = false
            self.tryGetSupplierCustomerUserIdByEmployeeId()
        }
    }
    func RemoveSupplierService() {
        //sends and array of ids for deleted services
         self.generic.showNativeActivityIndicator(self)
        if SERVICES_ID_TO_DELETE.count > 0 {
            var dicDELEMPLOYEE:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            //liProviderServiceId-> Array of iProviderServiceId. Each entry is the iProviderServiceId for the Service.
            dicDELEMPLOYEE["liProviderServiceId"] = SERVICES_ID_TO_DELETE as AnyObject

            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)

            }
            else
            {
                api.sharedInstance.RemoveSupplierService(dicDELEMPLOYEE, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {

                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            print("eroare sau nu \(RESPONSEOBJECT)")
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                                self.view.makeToast(message: "SUCCESS_DELETE_EMPLOYE".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.hidetoast()

                                })

                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.UpdateSupplierService()
                                })
                            }
                            else
                            {

                                self.view.makeToast(message: "ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.hidetoast()
                                    self.UpdateSupplierService()
                                })
                            }
                        }
                    }

                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    self.UpdateSupplierService()
                })
            }
        } else {
            UpdateSupplierService()
        }

    }
    func AddSupplierService() {
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails

            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        let myarr:NSMutableArray = []
        for a in Global.sharedInstance.generalDetails.arrObjProviderServices {
            let usertoaddID = a.iProviderServiceId
                if usertoaddID == 0 {
                    myarr.add(a.getDic())
                }
        }
        if myarr.count != 0 {

            var dicAddSupplierEmployee:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()


            dicAddSupplierEmployee["objSupplierServices"] = myarr as AnyObject
            dicAddSupplierEmployee["iSupplierId"] = providerID as AnyObject

            self.generic.showNativeActivityIndicator(self)
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)

            }
            else
            {
                api.sharedInstance.AddSupplierService(dicAddSupplierEmployee, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {

                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            print("eroare sau nu \(RESPONSEOBJECT)")
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                                self.view.makeToast(message: "SUCCESS_SETUP_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.hidetoast()

                                })

                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.closeandgotosettings()
                                })
                            }
                            else
                            {

                                self.view.makeToast(message: "ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.hidetoast()

                                })
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.gotosettings()
                                })
                            }
                        }
                    }

                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
              self.gotosettings()
                })
            }
        } else {
       self.closeandgotosettings()

        }
    }

    func UpdateSupplierService() {
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails

            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        let myarr:NSMutableArray = []
        for a in Global.sharedInstance.generalDetails.arrObjProviderServices {
            let usertoaddID = a.iProviderServiceId
            if SERVICES_ID_TO_UPDATE.contains(usertoaddID) {
                if usertoaddID != 0 {
                    myarr.add(a.getDic())
                }
            }
        }
        if myarr.count == 0 {
            AddSupplierService()
        } else {
            var dicAddSupplierEmployee:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()


            dicAddSupplierEmployee["objSupplierServices"] = myarr as AnyObject
            dicAddSupplierEmployee["iSupplierId"] = providerID as AnyObject

            self.generic.showNativeActivityIndicator(self)
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)

            }
            else
            {
                api.sharedInstance.UpdateSupplierService(dicAddSupplierEmployee, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            print("eroare sau nu \(RESPONSEOBJECT)")
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                                self.view.makeToast(message: "SUCCESS_SETUP_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.hidetoast()

                                })

                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.AddSupplierService()
                                })
                            }
                            else
                            {
                                self.generic.hideNativeActivityIndicator(self)
                                self.view.makeToast(message: "ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.hidetoast()
                                    self.AddSupplierService()
                                })
                            }
                        }
                    }

                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    self.AddSupplierService()
                })
            }
        }
    }
    func deleteServiceaddtoArray(_whichID:Int) {
        //SERVICES_ID_TO_DELETE  SERVICES_ID_TO_UPDATE SERVICES_ID_TO_ADD
        if !SERVICES_ID_TO_DELETE.contains(_whichID) {
            SERVICES_ID_TO_DELETE.append(_whichID)
        }
        if SERVICES_ID_TO_UPDATE.contains(_whichID) {
            let index1 = SERVICES_ID_TO_UPDATE.index(of: _whichID)
            SERVICES_ID_TO_UPDATE.remove(at: index1!)
        }
        if SERVICES_ID_TO_ADD.contains(_whichID) {
            let index1 = SERVICES_ID_TO_ADD.index(of: _whichID)
            SERVICES_ID_TO_ADD.remove(at: index1!)
        }
    }
    func AddServiceaddtoArray(_whichID:Int) {
        if !SERVICES_ID_TO_ADD.contains(_whichID) {
            SERVICES_ID_TO_ADD.append(_whichID)
        }

    }
    func UpdateServiceaddtoArray(_whichID:Int) {
        if !SERVICES_ID_TO_UPDATE.contains(_whichID) {
            SERVICES_ID_TO_UPDATE.append(_whichID)
        }
    }
//fix reload services
    //1
    func getProviderAllDetailsbySimpleUserID(_ id:Int)
    {
        var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicuser["iUserId"] =  id as AnyObject
        api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject>  {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _:Int = RESPONSEOBJECT["Result"] as? Int
                {
                    let myInt :Int = RESPONSEOBJECT["Result"] as! Int
                    print("sup id e ok ? " + myInt.description)
                    if myInt == 0 {
                        print ("no business")
                    } else {
                        self.callgetprovideralldetails(myInt)
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            self.gotosettings()
        })
    }
    func callgetprovideralldetails(_ iUseridSupplier:Int) {
        self.getProviderAllDetailsbyEmployeID(iUseridSupplier)
    }
    func getProviderAllDetailsbyEmployeID(_ iUserId:Int)
    {
        Global.sharedInstance.FREEDAYSALLWORKERS = []
        Global.sharedInstance.NOWORKINGDAYS = []
        print("now getProviderAllDetailsbyEmployeID")
        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //  dicUserId["iUserId"] = 20 important! hardcoded for test only do not use in production
        dicUserId["iUserId"] = iUserId as AnyObject
//        print("id crashx: \(dicUserId["iUserId"]) ")
        api.sharedInstance.getProviderAllDetails(dicUserId, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            //in any case hide loader

            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//שגיאה
                    {
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                    {
                        UserDefaults.standard.removeObject(forKey: "supplierNameRegistered")
                    }
                    else
                    {
                        if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                        {
                            //\\      print("crashx \(String(describing: RESPONSEOBJECT["Result"]))")
                            //KEEP IN MIND TO NOT OVERWRITE CURRENT LOGGED IN EMPLOYE SO USE dicToProviderDetailsObjByEmploye
                            Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObjByEmploye(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                            let mydic :Dictionary<String,AnyObject> = (RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>)!
                            //IMPORTANT THIS FIX PROVIDERID AFTER SETTING ORDER TO ANOTHER ONE.
                            if let onedic:Dictionary<String,AnyObject> = mydic["objProviderProfile"] as? Dictionary<String,AnyObject> {

                                //BLOCKED DAYS ARE GENERAL FOR PROVIDER AND
                                // 1. SEPARATE FOR EVERY WORKER IF HE HAS bSameWH = 0
                                // 2. SAME AS PROVIDER IF WORKER has bSameWH = 1
                                let anotherarray:NSMutableArray = NSMutableArray()
                                if let onearray:NSArray = onedic["objWorkingHours"] as? NSArray {

                                    for item in onearray {
                                        if let mydicfast:NSDictionary = item as? NSDictionary {
                                            if let MYDAYINTS:Int = mydicfast["iDayInWeekType"] as? Int {
                                                if !anotherarray.contains(MYDAYINTS) {
                                                    anotherarray.add(MYDAYINTS)
                                                }
                                            }
                                        }
                                    }
                                    //       Global.sharedInstance.FREEDAYSSUPPLIER
                                    let FIXEDNUMBERS:NSArray = [1,2,3,4,5,6,7]
                                    for item in FIXEDNUMBERS {
                                        if !anotherarray.contains(item) {
                                            if !Global.sharedInstance.NOWORKINGDAYS.contains(item) {
                                                Global.sharedInstance.NOWORKINGDAYS.add(item)
                                            }
                                        }
                                    }
                                }
                                print("NOWORKINGDAYS \(Global.sharedInstance.NOWORKINGDAYS)")
                            }

                            if let seconddic:Dictionary<String,AnyObject> = mydic["objProviderGeneralDetails"] as? Dictionary<String,AnyObject> {
                                if let onearray:NSArray = seconddic["objServiceProviders"] as? NSArray
                                {
                                    for item in onearray {
                                        let freedaysworkersrarray:NSMutableArray = NSMutableArray()
                                        let blockdaysworkersrarray:NSMutableArray = NSMutableArray()
                                        let USERX:NSMutableDictionary = NSMutableDictionary()
                                        if let mydicfast:NSDictionary = item as? NSDictionary {
                                            if let MYDAYINTS:Int = mydicfast["bSameWH"] as? Int {
                                                var miUSERID:Int = 0
                                                if let mydicuser:NSDictionary = mydicfast["objUsers"] as? NSDictionary {
                                                    if let _:Int = mydicuser["iUserId"] as? Int {
                                                        miUSERID = mydicuser["iUserId"] as! Int
                                                    }
                                                }
                                                if MYDAYINTS == 1 {
                                                    //same hours as provider
                                                    USERX["bSameWH"] = MYDAYINTS
                                                    USERX["WORKERID"] = miUSERID
                                                    USERX["FREEDAYS"] = Global.sharedInstance.NOWORKINGDAYS
                                                    if !Global.sharedInstance.FREEDAYSALLWORKERS.contains(USERX) {
                                                        Global.sharedInstance.FREEDAYSALLWORKERS.add(USERX)
                                                    }
                                                } else {
                                                    //custom hours
                                                    if let workerhoursarraay:NSArray = mydicfast["objWorkingHours"] as? NSArray {
                                                        for item in workerhoursarraay {
                                                            if let mydicfast:NSDictionary = item as? NSDictionary {
                                                                if let MYDAYINTS:Int = mydicfast["iDayInWeekType"] as? Int {
                                                                    if !freedaysworkersrarray.contains(MYDAYINTS) {
                                                                        freedaysworkersrarray.add(MYDAYINTS)
                                                                        print("MYDAYINTS \(MYDAYINTS)")
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        //       Global.sharedInstance.FREEDAYSSUPPLIER
                                                        let FIXEDNUMBERS:NSArray = [1,2,3,4,5,6,7]
                                                        for item in FIXEDNUMBERS {
                                                            if !freedaysworkersrarray.contains(item) {
                                                                if !blockdaysworkersrarray.contains(item) {
                                                                    blockdaysworkersrarray.add(item)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    USERX["bSameWH"] = MYDAYINTS
                                                    USERX["WORKERID"] = miUSERID
                                                    USERX["FREEDAYS"] = blockdaysworkersrarray
                                                    if !Global.sharedInstance.FREEDAYSALLWORKERS.contains(USERX) {
                                                        Global.sharedInstance.FREEDAYSALLWORKERS.add(USERX)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            print("Global.sharedInstance.FREEDAYSALLWORKERS \(Global.sharedInstance.FREEDAYSALLWORKERS)")
                            //שמירת שם העסק במכשיר
                            var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                            dicForDefault["nvSupplierName"] = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as AnyObject
                            Global.sharedInstance.defaults.set(dicForDefault, forKey: "supplierNameRegistered")
                            var iBusinessStatus:Int = 0
                            var iSupplierStatus:Int = 0
                            if let  _:Int = mydic["iBusinessStatus"] as? Int {
                                iBusinessStatus = mydic["iBusinessStatus"] as! Int
                            }
                            if let  _:Int = mydic["iSupplierStatus"] as? Int {
                                iSupplierStatus = mydic["iSupplierStatus"] as! Int
                            }
                            Global.sharedInstance.defaults.set(iBusinessStatus,  forKey: "iBusinessStatus")
                            Global.sharedInstance.defaults.set(iSupplierStatus,  forKey: "iSupplierStatus")
                            var iSyncedStatus:Int = 0
                            if let  _:Int = mydic["iSyncedStatus"] as? Int {
                                iSyncedStatus = mydic["iSyncedStatus"] as! Int
                            }
                            Global.sharedInstance.defaults.set(iSyncedStatus,  forKey: "iSyncedStatus")
                            Global.sharedInstance.defaults.synchronize()
                            var y:Int = 0
                            if let _:NSDictionary =  (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary) {
                                let a:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
                                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                                    y = x
                                }
                            }
                            print("crentiduser \(y)")
                        }
                        //  print ("1 x -> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName)")
                        //  print ("2x-> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress)")
                        //  print ("3x -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen)")
                        //  print ("4x -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage)")
                    }
                }
            }
             self.gotosettings()
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
             self.gotosettings()
        })
    }
    //2
    func getProviderAllDetails(_ iUserId:Int)       //invoke server function to get provider details
    {
        //show a loader
        Global.sharedInstance.FREEDAYSALLWORKERS = []
        Global.sharedInstance.NOWORKINGDAYS = []
        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicUserId["iUserId"] = iUserId as AnyObject
        //קבלת פרטי הספק
        api.sharedInstance.getProviderAllDetails(dicUserId, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            //in any case hide loader


            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1//שגיאה
                    {
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                    {
                        UserDefaults.standard.removeObject(forKey: "supplierNameRegistered")
                    }
                    else
                    {
                        if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                        {
                            print("crash 1 \(String(describing: RESPONSEOBJECT["Result"]))")

                            Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                            // print ("exact \( Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours.description)")
                            let mydic :Dictionary<String,AnyObject> = (RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>)!

                            //IMPORTANT THIS FIX PROVIDERID AFTER SETTING ORDER TO ANOTHER ONE.
                            if let onedic:Dictionary<String,AnyObject> = mydic["objProviderProfile"] as? Dictionary<String,AnyObject> {

                                //BLOCKED DAYS ARE GENERAL FOR PROVIDER AND
                                // 1. SEPARATE FOR EVERY WORKER IF HE HAS bSameWH = 0
                                // 2. SAME AS PROVIDER IF WORKER has bSameWH = 1
                                let anotherarray:NSMutableArray = NSMutableArray()
                                if let onearray:NSArray = onedic["objWorkingHours"] as? NSArray {

                                    for item in onearray {
                                        if let mydicfast:NSDictionary = item as? NSDictionary {
                                            if let MYDAYINTS:Int = mydicfast["iDayInWeekType"] as? Int {
                                                if !anotherarray.contains(MYDAYINTS) {
                                                    anotherarray.add(MYDAYINTS)
                                                }
                                            }
                                        }
                                    }
                                    //       Global.sharedInstance.FREEDAYSSUPPLIER
                                    let FIXEDNUMBERS:NSArray = [1,2,3,4,5,6,7]
                                    for item in FIXEDNUMBERS {
                                        if !anotherarray.contains(item) {
                                            if !Global.sharedInstance.NOWORKINGDAYS.contains(item) {
                                                Global.sharedInstance.NOWORKINGDAYS.add(item)
                                            }
                                        }
                                    }
                                }
                                print("NOWORKINGDAYS \(Global.sharedInstance.NOWORKINGDAYS)")
                            }

                            if let seconddic:Dictionary<String,AnyObject> = mydic["objProviderGeneralDetails"] as? Dictionary<String,AnyObject> {
                                if let onearray:NSArray = seconddic["objServiceProviders"] as? NSArray
                                {
                                    for item in onearray {
                                        let freedaysworkersrarray:NSMutableArray = NSMutableArray()
                                        let blockdaysworkersrarray:NSMutableArray = NSMutableArray()
                                        let USERX:NSMutableDictionary = NSMutableDictionary()
                                        if let mydicfast:NSDictionary = item as? NSDictionary {
                                            if let MYDAYINTS:Int = mydicfast["bSameWH"] as? Int {
                                                var miUSERID:Int = 0
                                                if let mydicuser:NSDictionary = mydicfast["objUsers"] as? NSDictionary {
                                                    if let _:Int = mydicuser["iUserId"] as? Int {
                                                        miUSERID = mydicuser["iUserId"] as! Int
                                                    }
                                                }
                                                if MYDAYINTS == 1 {
                                                    //same hours as provider
                                                    USERX["bSameWH"] = MYDAYINTS
                                                    USERX["WORKERID"] = miUSERID
                                                    USERX["FREEDAYS"] = Global.sharedInstance.NOWORKINGDAYS
                                                    if !Global.sharedInstance.FREEDAYSALLWORKERS.contains(USERX) {
                                                        Global.sharedInstance.FREEDAYSALLWORKERS.add(USERX)
                                                    }
                                                } else {
                                                    //custom hours
                                                    if let workerhoursarraay:NSArray = mydicfast["objWorkingHours"] as? NSArray {
                                                        for item in workerhoursarraay {
                                                            if let mydicfast:NSDictionary = item as? NSDictionary {
                                                                if let MYDAYINTS:Int = mydicfast["iDayInWeekType"] as? Int {
                                                                    if !freedaysworkersrarray.contains(MYDAYINTS) {
                                                                        freedaysworkersrarray.add(MYDAYINTS)
                                                                        print("MYDAYINTS \(MYDAYINTS)")
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        //       Global.sharedInstance.FREEDAYSSUPPLIER
                                                        let FIXEDNUMBERS:NSArray = [1,2,3,4,5,6,7]
                                                        for item in FIXEDNUMBERS {
                                                            if !freedaysworkersrarray.contains(item) {
                                                                if !blockdaysworkersrarray.contains(item) {
                                                                    blockdaysworkersrarray.add(item)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    USERX["bSameWH"] = MYDAYINTS
                                                    USERX["WORKERID"] = miUSERID
                                                    USERX["FREEDAYS"] = blockdaysworkersrarray
                                                    if !Global.sharedInstance.FREEDAYSALLWORKERS.contains(USERX) {
                                                        Global.sharedInstance.FREEDAYSALLWORKERS.add(USERX)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            print("Global.sharedInstance.FREEDAYSALLWORKERS \(Global.sharedInstance.FREEDAYSALLWORKERS)")
                            //שמירת שם העסק במכשיר
                            var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                            dicForDefault["nvSupplierName"] = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as AnyObject
                            Global.sharedInstance.defaults.set(dicForDefault, forKey: "supplierNameRegistered")
                            var iBusinessStatus:Int = 0
                            var iSupplierStatus:Int = 0
                            if let  _:Int = mydic["iBusinessStatus"] as? Int {
                                iBusinessStatus = mydic["iBusinessStatus"] as! Int
                            }
                            if let  _:Int = mydic["iSupplierStatus"] as? Int {
                                iSupplierStatus = mydic["iSupplierStatus"] as! Int
                            }


                            Global.sharedInstance.defaults.set(iBusinessStatus,  forKey: "iBusinessStatus")
                            Global.sharedInstance.defaults.set(iSupplierStatus,  forKey: "iSupplierStatus")

                            var iSyncedStatus:Int = 0
                            if let  _:Int = mydic["iSyncedStatus"] as? Int {
                                iSyncedStatus = mydic["iSyncedStatus"] as! Int
                            }
                            Global.sharedInstance.defaults.set(iSyncedStatus,  forKey: "iSyncedStatus")
                            Global.sharedInstance.defaults.synchronize()
                        }
                    }
                }
            }
             self.gotosettings()
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            self.gotosettings()
        })
    }
}

