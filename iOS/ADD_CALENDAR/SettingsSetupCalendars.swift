//
//  SettingsSetupCalendars.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 18/03/19.
//  Copyright © 2019 Bthere. All rights reserved.
//
//
import Foundation
import UIKit
protocol isOpenRowDelegate7 {
    func reloadTableFull()
    func openRow(_WHICHCELL:Int, _WHICHSTATE:Bool)
    func editRow(_WHICHCELL:Int,_WHICHSTATE:Bool)
    func savedDataOn(_WHICHCELL:Int, _WHICHSTATE:Bool, _WHICHSTATE2:Bool, _firstSel: objWorkingHours, _secondsel: objWorkingHours)
    func closeandclearcell(_WHICHCELL:Int)
    func showPopupBeforeAddNewCalendar()
    func deleteEmployeaddtoArray(_whichID:Int)
    func AddEmployeaddtoArray(_whichID:Int)
    func UpdateEmployeaddtoArray(_whichID:Int)
}



class SettingsSetupCalendars: NavigationModelViewController, UITableViewDelegate, UITableViewDataSource,isOpenRowDelegate7  {
    var generic:Generic = Generic()
    var EMPLOYEES_ARRAY:Array<objEMPLOYEE> = Array<objEMPLOYEE>()
    var EMPLOYEES_ID_TO_DELETE:Array<Int> = Array<Int>()
    var EMPLOYEES_ID_TO_UPDATE:Array<Int> = Array<Int>()
    var EMPLOYEES_ID_TO_ADD:Array<Int> = Array<Int>()
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
        if (self.revealViewController()?.frontViewPosition == FrontViewPosition.right) {
            self.revealViewController()?.revealToggle(animated: true)
        }
        let mainstoryb = UIStoryboard(name: "addeditcalendar", bundle: nil)
        let viewRegulation: POP_UP_EXIT_THE_ADDING_A_CALENDAR_SCREEN = mainstoryb.instantiateViewController(withIdentifier: "POP_UP_EXIT_THE_ADDING_A_CALENDAR_SCREEN") as! POP_UP_EXIT_THE_ADDING_A_CALENDAR_SCREEN
        viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        viewRegulation.modalPresentationStyle = .custom
        self.present(viewRegulation, animated: true, completion: nil)
    }
    func deleteEmployeaddtoArray(_whichID:Int) {
        if !EMPLOYEES_ID_TO_DELETE.contains(_whichID) {
            EMPLOYEES_ID_TO_DELETE.append(_whichID)
        }
        if EMPLOYEES_ID_TO_UPDATE.contains(_whichID) {
            let index1 = EMPLOYEES_ID_TO_UPDATE.index(of: _whichID)
            EMPLOYEES_ID_TO_UPDATE.remove(at: index1!)
        }
        if EMPLOYEES_ID_TO_ADD.contains(_whichID) {
            let index1 = EMPLOYEES_ID_TO_ADD.index(of: _whichID)
            EMPLOYEES_ID_TO_ADD.remove(at: index1!)
        }
    }
    func AddEmployeaddtoArray(_whichID:Int) {
        if !EMPLOYEES_ID_TO_ADD.contains(_whichID) {
            EMPLOYEES_ID_TO_ADD.append(_whichID)
        }

    }
    func UpdateEmployeaddtoArray(_whichID:Int) {
        if !EMPLOYEES_ID_TO_UPDATE.contains(_whichID) {
            EMPLOYEES_ID_TO_UPDATE.append(_whichID)
        }
    }
    func showPopupBeforeAddNewCalendar() { // case FrontViewPosition.
        print("if self.revealViewController()?.isopenview \( self.revealViewController()?.isopenview)")
        if (self.revealViewController()?.frontViewPosition == FrontViewPosition.right) {
            self.revealViewController()?.revealToggle(animated: true)
        }
    let mainstoryb = UIStoryboard(name: "addeditcalendar", bundle: nil)
    let viewRegulation: POP_UP_BEFORE_ADD_YOUR_CALENDAR = mainstoryb.instantiateViewController(withIdentifier: "POP_UP_BEFORE_ADD_YOUR_CALENDAR")as! POP_UP_BEFORE_ADD_YOUR_CALENDAR
    viewRegulation.view.frame =  self.view.frame
   // viewRegulation.modalPresentationStyle = .custom
    viewRegulation.modalPresentationStyle = UIModalPresentationStyle.currentContext// .custom
    viewRegulation.delegate = self
    self.present(viewRegulation, animated: true, completion: nil)
    }
    func gotosettings(){
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



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController()?.isopenview = 1
        self.reloadTableFull()
        

    }

    func GetCalendarsOfSupplier(){
        self.EMPLOYEES_ARRAY = []
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
                api.sharedInstance.GetCalendarsOfSupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        self.generic.hideNativeActivityIndicator(self)
                        print("responseObject calendars \(responseObject ??  1 as AnyObject)")
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                            {
                                let ps: objEMPLOYEE = objEMPLOYEE()
                                if let _:Array<Dictionary<String,AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String,AnyObject>>
                                {

                                    self.EMPLOYEES_ARRAY = ps.objServiceProvidersToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)

                                    print("self.EMPLOYEES_ARRAY \(self.EMPLOYEES_ARRAY)")
                                    Global.sharedInstance.ARRAYCALENDAR = []
                                    Global.sharedInstance.ARRAYCALENDAR = self.EMPLOYEES_ARRAY
                                    print(" workeri arrObjEMPLOYEE  \( self.EMPLOYEES_ARRAY.count )")
                                    for q in Global.sharedInstance.ARRAYCALENDAR {
                                        print(q.getDic())
                                        self.openRows.append(false)
                                    }
                                    self.Container.reloadData()
                                }
                            }
                    }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)

                })
            }
        }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        self.view.addBackground()

        GetCalendarsOfSupplier()
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.backImage.transform = scalingTransform
            self.backImage.transform = scalingTransform
        }
   
        TitleScreen.text = "ADD_CALENDARS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        validateScreen.setTitle("SAVEAddHoursButton".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        Container.delegate = self
        Container.dataSource = self
        Container.separatorStyle = .none

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var x:Int = 1
        x = Global.sharedInstance.ARRAYCALENDAR.count + 1
        return x
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myindex = indexPath.row
                if myindex == Global.sharedInstance.ARRAYCALENDAR.count  {
                    print("last row")
                    let cell:SettingsJoAddNewCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsJoAddNewCalendarTableViewCell") as! SettingsJoAddNewCalendarTableViewCell
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.setState(_isClosed: self.AddisClosed)
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    return cell
                } else {
                    let cell:SettingsCalendarInListCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCalendarInListCell") as! SettingsCalendarInListCell
                    cell.tag = indexPath.row
                    cell.delegate = self
                    cell.setEditState(_isEditOpen: false)
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    if Global.sharedInstance.ARRAYCALENDAR.count > 0 {
                    
                    cell.completeEmployeeData(_EMPLOYEE: Global.sharedInstance.ARRAYCALENDAR[myindex])
                    }
//                    if myindex == 0 {
//                        cell.btnDeleteEmployee.isHidden = true
//                        cell.btnDeleteEmployee.isUserInteractionEnabled = false
//                        cell.imageDeleteEmployee.isHidden = true
//                    }
                    return cell
                }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 print(indexPath.row)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let y = view.frame.size.height * 0.07
        return y
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
        Global.sharedInstance.NEW_EMPLOYEE_EDIT = objEMPLOYEE()
        print( Global.sharedInstance.ARRAYCALENDAR[_WHICHCELL].getdicWorkingHours())
        Global.sharedInstance.NEW_EMPLOYEE_EDIT  = Global.sharedInstance.ARRAYCALENDAR[_WHICHCELL]
        EditisClosed = false
        AddisClosed = true
        allclosed = false
       // self.Container.reloadData()
        Global.sharedInstance.myIndexForEditWorker = _WHICHCELL
        let mainstoryb = UIStoryboard(name: "addeditcalendar", bundle: nil)

        let viewRegulation: EDIT_CALENDAR_FIRST_SCREEN = mainstoryb.instantiateViewController(withIdentifier: "EDIT_CALENDAR_FIRST_SCREEN")as! EDIT_CALENDAR_FIRST_SCREEN
        viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        viewRegulation.modalPresentationStyle = .custom
        viewRegulation.delegate = self
        viewRegulation.myIndex = _WHICHCELL

        self.present(viewRegulation, animated: true, completion: nil)
    }
    func savedDataOn(_WHICHCELL:Int, _WHICHSTATE:Bool, _WHICHSTATE2:Bool, _firstSel: objWorkingHours, _secondsel: objWorkingHours ) {

        self.Container.reloadData()


    }

    func reloadTableFull() {
        self.Container.reloadData()
    }
    
    func hidetoast(){
        view.hideToastActivity()
    }
    @IBAction func validationtoServer(_ sender:UIButton) {
        print("ARRAYCALENDAR \(Global.sharedInstance.ARRAYCALENDAR.count)")
        RemoveSupplierCalendar() //1 calls ->
       //2 UpdateSupplierEmployee() calls ->
       //3 AddSupplierEmployee()
    }

    func RemoveSupplierCalendar() {
        //sends and array of ids for deleted employes
        if EMPLOYEES_ID_TO_DELETE.count > 0 {
            var dicDELEMPLOYEE:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            dicDELEMPLOYEE["liUserId"] = EMPLOYEES_ID_TO_DELETE as AnyObject

            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)

            }
            else
            {
                api.sharedInstance.RemoveSupplierCalendar(dicDELEMPLOYEE, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
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
                                     self.UpdateSupplierCalendar()
                                })
                            }
                            else
                            {

                                self.view.makeToast(message: "ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.hidetoast()
                                    self.UpdateSupplierCalendar()
                                })
                            }
                        }
                    }

                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    self.UpdateSupplierCalendar()
                })
            }
        } else {
            UpdateSupplierCalendar()
        }

    }
    func AddSupplierCalendar() {
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails

            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        var myarr:NSMutableArray = []
        for a in Global.sharedInstance.ARRAYCALENDAR {
            let usertoaddID = a.objsers.iUserId
            if EMPLOYEES_ID_TO_ADD.contains(usertoaddID) {
        //    if usertoaddID != 0 {
                myarr.add(a.getDic())
        //    }
        }
        }
        if myarr.count != 0 {

                var dicAddSupplierEmployee:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()


                dicAddSupplierEmployee["objSupplierCalendars"] = myarr as AnyObject
                dicAddSupplierEmployee["iSupplierId"] = providerID as AnyObject

                self.generic.showNativeActivityIndicator(self)
                if Reachability.isConnectedToNetwork() == false
                {
                    self.generic.hideNativeActivityIndicator(self)

                }
                else
                {
                    api.sharedInstance.AddSupplierCalendar(dicAddSupplierEmployee, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {

                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                print("eroare sau nu \(RESPONSEOBJECT)")
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                                    self.view.makeToast(message: "CALENDARS_WERE_SAVED_SUCCESSFULLY".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                        self.hidetoast()

                                    })

                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.gobackprogramatically()
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
                                        self.gobackprogramatically()
                                    })
                                }
                            }
                        }

                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        self.gobackprogramatically()
                    })
            }
        } else {
          self.gobackprogramatically()
            
        }
        }

    func UpdateSupplierCalendar() {
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails

            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        var myarr:NSMutableArray = []
        for a in Global.sharedInstance.ARRAYCALENDAR {
            let usertoaddID = a.objsers.iUserId
            if EMPLOYEES_ID_TO_UPDATE.contains(usertoaddID) {
                if usertoaddID != 0 {
                    myarr.add(a.getDic())
                }
            }
        }
        if myarr.count == 0 {
          AddSupplierCalendar()
        } else {
        var dicAddSupplierEmployee:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()


        dicAddSupplierEmployee["objSupplierCalendars"] = myarr as AnyObject
        dicAddSupplierEmployee["iSupplierId"] = providerID as AnyObject

        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)

        }
        else
        {
            api.sharedInstance.UpdateSupplierCalendar(dicAddSupplierEmployee, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        print("eroare sau nu \(RESPONSEOBJECT)")
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                            self.view.makeToast(message: "CALENDARS_WERE_SAVED_SUCCESSFULLY".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                self.hidetoast()

                            })

                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                self.AddSupplierCalendar()
                            })
                        }
                        else
                        {
                            self.generic.hideNativeActivityIndicator(self)
                            self.view.makeToast(message: "ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                self.hidetoast()
                                self.AddSupplierCalendar()
                            })
                        }
                    }
                }

            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                self.AddSupplierCalendar()
            })
        }
        }
    }
    func gobackprogramatically() {
        self.generic.hideNativeActivityIndicator(self)
        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
        frontviewcontroller!.pushViewController(viewcon, animated: false)
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }

}

