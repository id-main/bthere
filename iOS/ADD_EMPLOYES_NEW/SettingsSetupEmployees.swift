//
//  SettingsSetupEmployees.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 18/03/19.
//  Copyright © 2019 Bthere. All rights reserved.
//
//
import Foundation
import UIKit
protocol isOpenRowDelegate5 {
    func reloadTableFull()
    func openRow(_WHICHCELL:Int, _WHICHSTATE:Bool)
    func editRow(_WHICHCELL:Int,_WHICHSTATE:Bool)
    func savedDataOn(_WHICHCELL:Int, _WHICHSTATE:Bool, _WHICHSTATE2:Bool, _firstSel: objWorkingHours, _secondsel: objWorkingHours)
    func closeandclearcell(_WHICHCELL:Int)
    func showPopupBeforeAddNewEmploye()
    func deleteEmployeaddtoArray(_whichID:Int)
    func AddEmployeaddtoArray(_whichID:Int)
    func UpdateEmployeaddtoArray(_whichID:Int)
}

class SettingsSetupEmployees: NavigationModelViewController, UITableViewDelegate, UITableViewDataSource,isOpenRowDelegate5  {
    var ISDELETINGHIMSELF:Bool = false //A manager or employee which deletes himself
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
        let mainstoryb = UIStoryboard(name: "newemployee", bundle: nil)
        let viewRegulation: POP_UP_EXIT_THE_ADDING_AN_EMPLOYEE_SCREEN = mainstoryb.instantiateViewController(withIdentifier: "POP_UP_EXIT_THE_ADDING_AN_EMPLOYEE_SCREEN") as! POP_UP_EXIT_THE_ADDING_AN_EMPLOYEE_SCREEN
        viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        viewRegulation.modalPresentationStyle = .overCurrentContext
        self.present(viewRegulation, animated: true, completion: nil)
    }
    func deleteEmployeaddtoArray(_whichID:Int) {
        if Global.sharedInstance.currentUser.nvPhone != "" {
            let loggedinPhone = Global.sharedInstance.currentUser.nvPhone as String
            for q in Global.sharedInstance.ARRAYEMPLOYEE {
                let workerid = q.objsers.iUserId
                let workerphone = q.objsers.nvPhone
                if workerid == _whichID {
                    if workerphone == loggedinPhone {
                        self.ISDELETINGHIMSELF = true
                    }
                }
                }
            }

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
    func showPopupBeforeAddNewEmploye() {
//        if self.revealViewController()?.isopenview == 0 {
//
//            self.revealViewController()?.revealToggle(animated: true)
//
//        }
        if (self.revealViewController()?.frontViewPosition == FrontViewPosition.right) {
            self.revealViewController()?.revealToggle(animated: true)
        }
    let mainstoryb = UIStoryboard(name: "newemployee", bundle: nil)
    let viewRegulation: POP_UP_BEFORE_ADD_YOUR_EMPLOYEES = mainstoryb.instantiateViewController(withIdentifier: "POP_UP_BEFORE_ADD_YOUR_EMPLOYEES")as! POP_UP_BEFORE_ADD_YOUR_EMPLOYEES
    viewRegulation.view.frame =  self.view.frame
   // viewRegulation.modalPresentationStyle = .custom
    viewRegulation.modalPresentationStyle = UIModalPresentationStyle.currentContext// .custom
    viewRegulation.delegate = self
    self.present(viewRegulation, animated: true, completion: nil)
    }
    func gotosettings(){
        self.generic.hideNativeActivityIndicator(self)
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

    func GetEmployeesOfSupplier(){
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
                api.sharedInstance.GetEmployeesOfSupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        self.generic.hideNativeActivityIndicator(self)
                        print("responseObject employees \(responseObject ??  1 as AnyObject)")
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                            {
                                let ps: objEMPLOYEE = objEMPLOYEE()
                                if let _:Array<Dictionary<String,AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String,AnyObject>>
                                {

                                    self.EMPLOYEES_ARRAY = ps.objServiceProvidersToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)

                                    print("self.EMPLOYEES_ARRAY \(self.EMPLOYEES_ARRAY)")
                                    Global.sharedInstance.ARRAYEMPLOYEE = []
                                    Global.sharedInstance.ARRAYEMPLOYEE = self.EMPLOYEES_ARRAY
                                    print(" workeri arrObjEMPLOYEE  \( self.EMPLOYEES_ARRAY.count )")
                                    for q in Global.sharedInstance.ARRAYEMPLOYEE {
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
    override var prefersStatusBarHidden : Bool {
        return false
    }

    override func viewDidLoad() {
        self.view.addBackground()
        self.setNeedsStatusBarAppearanceUpdate()
        GetEmployeesOfSupplier()
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.backImage.transform = scalingTransform
            self.backImage.transform = scalingTransform
        }
   
        TitleScreen.text = "EMPLOYES".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        validateScreen.setTitle("SAVEAddHoursButton".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        Container.delegate = self
        Container.dataSource = self
        Container.separatorStyle = .none

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var x:Int = 1
        x = Global.sharedInstance.ARRAYEMPLOYEE.count + 1
        return x
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myindex = indexPath.row
                if myindex == Global.sharedInstance.ARRAYEMPLOYEE.count  {
                    print("last row")
                    let cell:SettingsJoAddNewEmployeeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsJoAddNewEmployeeTableViewCell") as! SettingsJoAddNewEmployeeTableViewCell
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.setState(_isClosed: self.AddisClosed)
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    return cell
                } else {
                    let cell:SettingsEmployeeInListCell = tableView.dequeueReusableCell(withIdentifier: "SettingsEmployeeInListCell") as! SettingsEmployeeInListCell
                    cell.tag = indexPath.row
                    cell.delegate = self
                    cell.setEditState(_isEditOpen: false)
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    if Global.sharedInstance.ARRAYEMPLOYEE.count > 0 {
                    
                    cell.completeEmployeeData(_EMPLOYEE: Global.sharedInstance.ARRAYEMPLOYEE[myindex])
                    }
                    if myindex == 0 {
                        cell.btnDeleteEmployee.isHidden = true
                        cell.btnDeleteEmployee.isUserInteractionEnabled = false
                        cell.imageDeleteEmployee.isHidden = true
                    }
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
        print( Global.sharedInstance.ARRAYEMPLOYEE[_WHICHCELL].getdicWorkingHours())
        Global.sharedInstance.NEW_EMPLOYEE_EDIT  = Global.sharedInstance.ARRAYEMPLOYEE[_WHICHCELL]
        EditisClosed = false
        AddisClosed = true
        allclosed = false
       // self.Container.reloadData()
        Global.sharedInstance.myIndexForEditWorker = _WHICHCELL
        let mainstoryb = UIStoryboard(name: "newemployee", bundle: nil)

        let viewRegulation: EDIT_EMPLOYE_FIRST_SCREEN = mainstoryb.instantiateViewController(withIdentifier: "EDIT_EMPLOYE_FIRST_SCREEN")as! EDIT_EMPLOYE_FIRST_SCREEN
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
        print("Global.sharedInstance.ARRAYEMPLOYEE.count \(Global.sharedInstance.ARRAYEMPLOYEE.count)")
        RemoveSupplierEmployee() //1 calls ->
       //2 UpdateSupplierEmployee() calls ->
       //3 AddSupplierEmployee()
    }

    func RemoveSupplierEmployee() {
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
                api.sharedInstance.RemoveSupplierEmployee(dicDELEMPLOYEE, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
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
                                     self.UpdateSupplierEmployee()
                                })
                            }
                            else
                            {

                                self.view.makeToast(message: "ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    self.hidetoast()
                                    self.UpdateSupplierEmployee()
                                })
                            }
                        }
                    }

                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    self.UpdateSupplierEmployee()
                })
            }
        } else {
            UpdateSupplierEmployee()
        }

    }
    func AddSupplierEmployee() {
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
        for a in Global.sharedInstance.ARRAYEMPLOYEE {
            let usertoaddID = a.objsers.iUserId
            if EMPLOYEES_ID_TO_ADD.contains(usertoaddID) {
            if usertoaddID != 0 {
                myarr.add(a.getDic())
            }
        }
        }
        if myarr.count != 0 {

                var dicAddSupplierEmployee:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()


                dicAddSupplierEmployee["objServiceProviders"] = myarr as AnyObject
                dicAddSupplierEmployee["iSupplierId"] = providerID as AnyObject

                self.generic.showNativeActivityIndicator(self)
                if Reachability.isConnectedToNetwork() == false
                {
                    self.generic.hideNativeActivityIndicator(self)

                }
                else
                {
                    api.sharedInstance.AddSupplierEmployee(dicAddSupplierEmployee, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        if let _ = responseObject as? Dictionary<String,AnyObject> {

                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                print("eroare sau nu \(RESPONSEOBJECT)")
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                                    self.view.makeToast(message: "SUCCESS_UPDATE_EMPLOYES".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
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

    func UpdateSupplierEmployee() {
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
        for a in Global.sharedInstance.ARRAYEMPLOYEE {
            let usertoaddID = a.objsers.iUserId
            if EMPLOYEES_ID_TO_UPDATE.contains(usertoaddID) {
                if usertoaddID != 0 {
                    myarr.add(a.getDic())
                }
            }
        }
        if myarr.count == 0 {
          AddSupplierEmployee()
        } else {
        var dicAddSupplierEmployee:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()


        dicAddSupplierEmployee["objServiceProviders"] = myarr as AnyObject
        dicAddSupplierEmployee["iSupplierId"] = providerID as AnyObject

        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)

        }
        else
        {
            api.sharedInstance.UpdateSupplierEmployee(dicAddSupplierEmployee, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        print("eroare sau nu \(RESPONSEOBJECT)")
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                            self.view.makeToast(message: "SUCCESS_UPDATE_EMPLOYES".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                self.hidetoast()

                            })

                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                self.AddSupplierEmployee()
                            })
                        }
                        else
                        {
                            self.generic.hideNativeActivityIndicator(self)
                            self.view.makeToast(message: "ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                self.hidetoast()
                                self.AddSupplierEmployee()
                            })
                        }
                    }
                }

            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                self.AddSupplierEmployee()
            })
        }
        }
    }
    func opencustomerside(){
        Calendar.sharedInstance.carrentDate = Date()
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
    }
    func gobackprogramatically() {
        if self.ISDELETINGHIMSELF == true {
            opencustomerside()

        } else {


        var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
        if dicUserId["currentUserId"] as! Int != 0
        {
            let myint =  dicUserId["currentUserId"] as! Int
            self.generic.showNativeActivityIndicator(self)
            if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
            {
                self.getProviderAllDetailsbySimpleUserIDx(myint)
            }
            else
            {
                self.getProviderAllDetailsx(myint)
            }
        }
        }
    }
    //fix reload services
    //1
    func getProviderAllDetailsbySimpleUserIDx(_ id:Int)
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
                         self.opencustomerside()
                    } else {
                        self.callgetprovideralldetailsx(myInt)
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            self.gotosettings()
        })
    }
    func callgetprovideralldetailsx(_ iUseridSupplier:Int) {
        self.getProviderAllDetailsbyEmployeIDx(iUseridSupplier)
    }
    func getProviderAllDetailsbyEmployeIDx(_ iUserId:Int)
    {
        Global.sharedInstance.FREEDAYSALLWORKERS = []
        Global.sharedInstance.NOWORKINGDAYS = []
        print("now getProviderAllDetailsbyEmployeID")
        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //  dicUserId["iUserId"] = 20 important! hardcoded for test only do not use in production
        dicUserId["iUserId"] = iUserId as AnyObject
        print("id crashx: \(dicUserId["iUserId"]) ")
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
    func getProviderAllDetailsx(_ iUserId:Int)       //invoke server function to get provider details
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
extension UIViewController {

    func dismissAll(animated: Bool, completion: (() -> Void)? = nil) {
        if let optionalWindow = UIApplication.shared.delegate?.window, let window = optionalWindow, let rootViewController = window.rootViewController, let presentedViewController = rootViewController.presentedViewController  {
            if let snapshotView = window.snapshotView(afterScreenUpdates: false) {
                presentedViewController.view.addSubview(snapshotView)
                presentedViewController.modalTransitionStyle = .coverVertical
            }
            if !isBeingDismissed {
                rootViewController.dismiss(animated: animated, completion: completion)
            }
        }
    }
    }

