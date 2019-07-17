//
//  SettingsSetupWorkingHours.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 12/14/18.
//  Copyright © 2018 Bthere. All rights reserved.
//
//
import Foundation
import UIKit
import Fabric
import Crashlytics
protocol isOpenRowDelegate1 {
    func openRow(_WHICHCELL:Int, _WHICHSTATE:Bool)
    func seteditbuttonpressed(_WHICHCELL:Int)
    func seteditsecondbuttonpressed(_WHICHCELL:Int)
    func setaddbuttonpressed(_WHICHCELL:Int)
    func savedDataOn(_WHICHCELL:Int, _WHICHSTATE:Bool, _WHICHSTATE2:Bool, _firstSel: objWorkingHours, _secondsel: objWorkingHours)
    func savedDataFirstInterval(_WHICHCELL:Int, _WHICHSTATE:Bool, _firstSel: objWorkingHours)
    func closeandclearWorkingHours(_WHICHCELL:Int)
  //  func setaddbuttonpressed(_WHICHCELL:Int)
}
class SettingsSetupWorkingHours:UIViewController, UITableViewDelegate, UITableViewDataSource,isOpenRowDelegate1 {
    var generic:Generic = Generic()
    var myDayNames:Array<String> = Array<String>()
    var openRows:Array<Bool> = [false, false, false, false, false, false, false]
    var hasHoursSelected:Array<Bool> = [false, false, false, false, false, false, false]
    var hasHoursSecondSelected:Array<Bool> = [false, false, false, false, false, false, false]
    var lastopencell:Int = -1
    var currentopencell:Int = -1
    var haspreesededitsecondbutton:Array<Bool> = [false, false, false, false, false, false, false]
    var haspreesededitbutton:Array<Bool> = [false, false, false, false, false, false, false]
    var haspreesedaddbutton:Array<Bool> = [false, false, false, false, false, false, false]
    var FIRSTINTERVALArray = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
    var SECONDINTERVALArray = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
    @IBOutlet weak var backImage:UIImageView!
    @IBOutlet weak var TitleScreen:UILabel!
    @IBOutlet weak var Container:UITableView!
    @IBOutlet weak var closeButton:UIButton!
    @IBOutlet weak var validateScreen:UIButton!
    @IBAction func closeButton(_ sender:UIButton) {
           gotosettings()
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
    @IBAction func validateScreen(_ sender:UIButton) {
        //check hasHoursSelected
        var isValidToSave:Bool = false
        for i in hasHoursSelected {
            if i == true {
                isValidToSave = true
                AppDelegate.JHASVALIDHOURS = true
                break
            }
        }
        if isValidToSave == false {
            AppDelegate.JHASVALIDHOURS = false
      //      Alert.sharedInstance.showAlertDelegate("SELECT_HOURS_FOR_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE))
       //     return
        } else {
//            Global.sharedInstance.generalDetails.arrObjWorkingHours = Array<objWorkingHours>() //empty before mix the working and rest
            Global.sharedInstance.NEWARRAYOBJWORKINGHOURS  = Array<objWorkingHours>()
            var mymixedarray:Array<objWorkingHours> = Array<objWorkingHours>()

            if AppDelegate.JHASVALIDHOURS == true {
                //compose final array from intervals
                for i in 0..<hasHoursSelected.count {
                    if hasHoursSelected[i] == true {
                        let goodworkingintervalfirst = FIRSTINTERVALArray[i]
                        if !mymixedarray.contains(goodworkingintervalfirst) {
                            mymixedarray.append(goodworkingintervalfirst)
                        }
                    }
                }
                for i in 0..<hasHoursSecondSelected.count {
                    if hasHoursSecondSelected[i] == true {
                        let goodworkingintervalfirst = SECONDINTERVALArray[i]
                        if !mymixedarray.contains(goodworkingintervalfirst) {
                            mymixedarray.append(goodworkingintervalfirst)
                        }
                    }
                }
            }
            for h in mymixedarray {
                print("mixedArray print2: \(h.getDic())")
            }
       //     Global.sharedInstance.generalDetails.arrObjWorkingHours  = mymixedarray
            Global.sharedInstance.NEWARRAYOBJWORKINGHOURS = mymixedarray

        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetProviderSettingsForCalendarmanagement()
        //precomplete array with default values
        for i in 0..<FIRSTINTERVALArray.count {
            var workingHoursTEST:objWorkingHours = objWorkingHours()
            workingHoursTEST = objWorkingHours(
                _iDayInWeekType: i + 1,
                _nvFromHour: "00:00:00",
                _nvToHour: "00:00:00")
            FIRSTINTERVALArray[i] = workingHoursTEST
        }
        for i in 0..<SECONDINTERVALArray.count {
            var workingHoursTEST:objWorkingHours = objWorkingHours()
            workingHoursTEST = objWorkingHours(
                _iDayInWeekType: i + 1,
                _nvFromHour: "00:00:00",
                _nvToHour: "00:00:00")
            SECONDINTERVALArray[i] = workingHoursTEST
        }
        //by default has empty hours
        AppDelegate.JHASVALIDHOURS = false
//        Global.sharedInstance.generalDetails.arrObjWorkingHours = Array<objWorkingHours>()
       Global.sharedInstance.NEWARRAYOBJWORKINGHOURS = Array<objWorkingHours>()

        for a in Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours {
            print("we work on \(a.getDic())")
        }
        Global.sharedInstance.NEWARRAYOBJWORKINGHOURS = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours
        for i in 1...7 {
            var hoursinday:Array<objWorkingHours> = []
            for z in 0..<Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours.count {
                let arie:objWorkingHours = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours[z]
                let ay = arie.iDayInWeekType
                if ay == i {
                    hoursinday.append(arie)
                }
                if hoursinday.count == 0 {
                  //nothing to do
                } else  if hoursinday.count == 1 {
                    let oneelement:objWorkingHours = hoursinday[0] // Global.sharedInstance.generalDetails.arrObjWorkingHours[i-1]
                    FIRSTINTERVALArray[i-1] = oneelement
                    hasHoursSelected[i-1] = true
                    hasHoursSecondSelected[i-1] = false
                } else   if hoursinday.count == 2 {
                    let firstelement:objWorkingHours = hoursinday[0]
                    let secondelement:objWorkingHours = hoursinday[1]
                    FIRSTINTERVALArray[i - 1] = firstelement
                    SECONDINTERVALArray[i - 1] = secondelement
                    hasHoursSelected[i-1] = true
                    hasHoursSecondSelected[i-1] = true
                }
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    //    self.Container.reloadData()
    }

    override func viewDidLoad() {
        self.view.addBackground()
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.backImage.transform = scalingTransform
            self.backImage.transform = scalingTransform
        }
        validateScreen.setTitle("SAVEAddHoursButton".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        TitleScreen.text = "SET_WORKING_HOURS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        Container.delegate = self
        Container.dataSource = self
        Container.separatorStyle = .none
        myDayNames = ["SUNDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                      "MONDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                      "TUESDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                      "WEDNSDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                      "THIRTHDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                      "FRIDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                      "SHABAT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ]

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SettingsEditWorkingHoursCell = tableView.dequeueReusableCell(withIdentifier: "SettingsEditWorkingHoursCell") as! SettingsEditWorkingHoursCell
        let ax = indexPath.section
        cell.delegate = self
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.indexSection = indexPath.section
        let _isopen  = openRows[ax]
        let _firstinterval = FIRSTINTERVALArray[ax]
        let _hasHoursSelected = hasHoursSelected[ax]
        let _hasHoursSecondSelected = hasHoursSecondSelected[ax]
        cell.setDisplayData(openRows[ax], daydesc: myDayNames[indexPath.section], _indexsection:indexPath.section, _firstinterval: FIRSTINTERVALArray[ax], _secondinterval: SECONDINTERVALArray[ax], _hasHoursSelected: hasHoursSelected[ax], _hasHoursSecondSelected:hasHoursSecondSelected[ax], _isinEDIT:haspreesededitbutton[ax], _isinEDITSECOND:haspreesededitsecondbutton[ax],_isinADD:haspreesedaddbutton[ax] )
        print("_isnewopen \(currentopencell)")


    cell.mySwitch.onTintColor = Colors.sharedInstance.color4
        if _hasHoursSelected == false && _isopen == true {
            cell.mySwitch.isOn = true
            cell.mySwitch.onTintColor = Colors.sharedInstance.color3
        }
        if _hasHoursSelected == false && _isopen == false {
            cell.mySwitch.isOn = false
        }
        if _hasHoursSelected == true && _isopen == false {
            cell.mySwitch.isOn = true
        }
        switch (_isopen) {
        case false:
            if _hasHoursSelected == false  {
                cell.AddHoursButton.isHidden = true
                break
            } else
                if _hasHoursSelected == true &&  _hasHoursSecondSelected == true {
                    cell.AddHoursButton.isHidden = true
                    break
                } else
                    if _hasHoursSelected == true && _hasHoursSecondSelected == false {
                        if _firstinterval.nvToHour == "23:59:00" {
                            cell.AddHoursButton.isHidden = true
                            break
                        }
                        else {
                            cell.AddHoursButton.isHidden = false
                            break
                        }
            }
        case true:
            cell.AddHoursButton.isHidden = true
            break
        }
        let tapAction = UITapGestureRecognizer(target: cell, action: #selector(cell.EditHoursButton))
        tapAction.delegate = cell
        cell.RowSelectedHours1.isUserInteractionEnabled = true
        cell.RowSelectedHours1.addGestureRecognizer(tapAction)
        let tapAction2 = UITapGestureRecognizer(target: cell, action: #selector(cell.EditHoursSecondButton))
        tapAction2.delegate = cell
        cell.RowSelectedHours2.isUserInteractionEnabled = true
        cell.RowSelectedHours2.addGestureRecognizer(tapAction2)


        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 15
    }
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let ax = indexPath.section
        var x:CGFloat  = 0.0
        if openRows[ax] == false {
            if hasHoursSelected [ax] == true &&   hasHoursSecondSelected[ax] == true {
                x = 90
            } else if hasHoursSelected [ax] == true &&   hasHoursSecondSelected[ax] == false {
                x = 70
            } else if hasHoursSelected [ax] == false &&   hasHoursSecondSelected[ax] == false {
                x = 50
            }
        } else {
            currentopencell = ax
            let screenSize: CGRect = UIScreen.main.bounds
            let screenHeight = screenSize.height
            x = CGFloat(screenHeight * 0.7)
        }


        return x
    }
    func closeandclearWorkingHours(_WHICHCELL:Int) {
        var workingHoursTEST:objWorkingHours = objWorkingHours()
        workingHoursTEST = objWorkingHours(
            _iDayInWeekType: _WHICHCELL + 1,
            _nvFromHour: "00:00:00",
            _nvToHour: "00:00:00")
        FIRSTINTERVALArray[_WHICHCELL] = workingHoursTEST
        SECONDINTERVALArray[_WHICHCELL] = workingHoursTEST
        hasHoursSelected[_WHICHCELL] = false
        hasHoursSecondSelected[_WHICHCELL] = false
        haspreesedaddbutton[_WHICHCELL] = false
        haspreesededitbutton[_WHICHCELL] = false
        haspreesededitsecondbutton[_WHICHCELL] = false
        validateScreen(self.validateScreen)
        openRow(_WHICHCELL:_WHICHCELL, _WHICHSTATE: false)
    }

    func openRow(_WHICHCELL:Int, _WHICHSTATE:Bool) {

        if _WHICHSTATE == true {

            //close others
            for i in 0..<openRows.count {
             //   if i != _WHICHCELL {
                    openRows[i] = false



            //   }
            }

                openRows[_WHICHCELL] = true

                let indexPath = IndexPath(row: 0, section: _WHICHCELL)


                let indexes = Container.indexPathsForVisibleRows!
                if indexes.contains(indexPath)
                {
     //               self.Container.reloadRows(at: [indexPath], with: .none)
                    self.Container.scrollToRow(at: indexPath, at: .top, animated: true)
                }
              self.Container.reloadData()
        } else {
            for i in 0..<openRows.count {
                openRows[i] = false
            }
            openRows[_WHICHCELL] = false
            self.Container.reloadData()
            haspreesededitbutton[_WHICHCELL] = false
            haspreesededitsecondbutton[_WHICHCELL] = false
            haspreesedaddbutton[_WHICHCELL] = false
            for i in 0..<haspreesedaddbutton.count {
                haspreesedaddbutton[i] = false
                haspreesededitbutton[i] = false
                haspreesededitsecondbutton[i] = false
            }

            let indexPath = IndexPath(row: 0, section: 0)
            let indexes = Container.indexPathsForVisibleRows!
            if indexes.contains(indexPath)
            {
                self.Container.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            self.Container.reloadData()
        }

    }
    func savedDataFirstInterval(_WHICHCELL:Int, _WHICHSTATE:Bool, _firstSel: objWorkingHours) {
        if _WHICHSTATE == true {
            hasHoursSelected[_WHICHCELL] = true
            FIRSTINTERVALArray[_WHICHCELL] = _firstSel
            hasHoursSecondSelected[_WHICHCELL] = false
            var workingHoursTEST:objWorkingHours = objWorkingHours()
            workingHoursTEST = objWorkingHours(
                _iDayInWeekType: _WHICHCELL + 1,
                _nvFromHour: "00:00:00",
                _nvToHour: "00:00:00")
            SECONDINTERVALArray[_WHICHCELL] = workingHoursTEST
            validateScreen(self.validateScreen)
        self.lastopencell = _WHICHCELL
            self.Container.reloadData()
        }

    }

    func savedDataOn(_WHICHCELL:Int, _WHICHSTATE:Bool, _WHICHSTATE2:Bool, _firstSel: objWorkingHours, _secondsel: objWorkingHours ) {
        //    Container.beginUpdates()
        if _WHICHSTATE == true {
            hasHoursSelected[_WHICHCELL] = true
            FIRSTINTERVALArray[_WHICHCELL] = _firstSel
            if _WHICHSTATE2 == true {
                hasHoursSecondSelected[_WHICHCELL] = true
                SECONDINTERVALArray[_WHICHCELL] = _secondsel
            } else {
                hasHoursSecondSelected[_WHICHCELL] = false
                var workingHoursTEST:objWorkingHours = objWorkingHours()
                workingHoursTEST = objWorkingHours(
                    _iDayInWeekType: _WHICHCELL + 1,
                    _nvFromHour: "00:00:00",
                    _nvToHour: "00:00:00")
                SECONDINTERVALArray[_WHICHCELL] = workingHoursTEST
            }
        } else {
            hasHoursSelected[_WHICHCELL] = false
            hasHoursSecondSelected[_WHICHCELL] = false
            var workingHoursTEST:objWorkingHours = objWorkingHours()
            workingHoursTEST = objWorkingHours(
                _iDayInWeekType: _WHICHCELL + 1,
                _nvFromHour: "00:00:00",
                _nvToHour: "00:00:00")
            FIRSTINTERVALArray[_WHICHCELL] = workingHoursTEST
            SECONDINTERVALArray[_WHICHCELL] = workingHoursTEST
        }
        for i in FIRSTINTERVALArray {
            print("one \(i.getDic())")
        }
        for i in SECONDINTERVALArray {
            print("two \(i.getDic())")
        }
        openRows[_WHICHCELL] = false
        haspreesededitbutton[_WHICHCELL] = false
        haspreesededitsecondbutton[_WHICHCELL] = false
        haspreesedaddbutton[_WHICHCELL] = false
        let indexPath = IndexPath(row: 0, section: _WHICHCELL)


        let indexes = Container.indexPathsForVisibleRows!
        if indexes.contains(indexPath)
        {
            self.Container.reloadRows(at: [indexPath], with: .none)
            self.Container.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        self.Container.reloadData()
      

    }
    //EDIT HOURS LABEL PRESSED
    func seteditbuttonpressed(_WHICHCELL:Int) {
        for i in 0..<haspreesededitbutton.count {

            if i != _WHICHCELL {
                haspreesededitbutton[i] = false
            }
            haspreesedaddbutton[i] = false
            haspreesededitsecondbutton[i] = false
        }
        haspreesededitbutton[_WHICHCELL] = true
    }
    //EDIT SECOND HOURS LABEL PRESSED
    func seteditsecondbuttonpressed(_WHICHCELL:Int) {
        for i in 0..<haspreesededitsecondbutton.count {

            if i != _WHICHCELL {
                haspreesededitsecondbutton[i] = false
            }
            haspreesededitbutton[i] = false
            haspreesededitsecondbutton[i] = false
        }
        haspreesededitsecondbutton[_WHICHCELL] = true
    }
    //ADD HOURS BUTTON PRESSED
    func setaddbuttonpressed(_WHICHCELL:Int) {
        for i in 0..<haspreesedaddbutton.count {

            if i != _WHICHCELL {
                haspreesedaddbutton[i] = false
            }
            haspreesededitbutton[i] = false
            haspreesededitsecondbutton[i] = false
        }
        haspreesedaddbutton[_WHICHCELL] = true
    }
    @IBAction func validationtoServer(_ sender:UIButton) {
        print("Global.sharedInstance.generalDetails.arrObjProviderServices.count \(Global.sharedInstance.generalDetails.arrObjProviderServices.count)")
                var isValidToSave:Bool = false
                for i in hasHoursSelected {
                    if i == true {
                        isValidToSave = true
                        AppDelegate.JHASVALIDHOURS = true
                        break
                    }
                }
                if isValidToSave == false {
                    AppDelegate.JHASVALIDHOURS = false
                    Alert.sharedInstance.showAlertDelegate("SELECT_HOURS_FOR_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    return
                } else {
                validateScreen(self.validateScreen)
                Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours = Global.sharedInstance.NEWARRAYOBJWORKINGHOURS
                self.validateScreen.isUserInteractionEnabled = false
                self.tryGetSupplierCustomerUserIdByEmployeeId()
        }
    }
    func hidetoast(){
        view.hideToastActivity()
    }
    func UpdateWorkingHours(_ iUserID:Int) {
    self.generic.showNativeActivityIndicatorInteractionEnabled(self)

    if Reachability.isConnectedToNetwork() == false
    {
    self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
    }
    else {
    var dicomposed:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    dicomposed["iProviderUserId"] =  iUserID as AnyObject
    var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    var arr:Array<AnyObject> = []
    print("NEWARRAYOBJWORKINGHOURS \(Global.sharedInstance.NEWARRAYOBJWORKINGHOURS.count)")
    for it in Global.sharedInstance.NEWARRAYOBJWORKINGHOURS
    {
    dic = it.getDic()

    arr.append(dic as AnyObject)


    print("whxd \(dic)")

    }

    dicomposed["objWorkingHours"] = arr as AnyObject
    api.sharedInstance.UpdateWorkHours(dicomposed, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in

    if let _ = responseObject as? Dictionary<String,AnyObject> {
    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
    print("save working hours \(RESPONSEOBJECT)")
    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
    {
        self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
        self.validateScreen.isUserInteractionEnabled = true
    self.view.makeToast(message: "ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
    self.hidetoast()
    })
    }
    else { //success
        self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
    self.view.makeToast(message: "SUCCESS_SETUP_WORKING_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
    self.hidetoast()
    })
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.updateNOWORKINGHOURS()
        })
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
           self.gotosettings()
        })
    }
    }
    }
    },failure: {(AFHTTPRequestOperation, Error) -> Void in
        self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
         self.validateScreen.isUserInteractionEnabled = true
        self.view.makeToast(message: "ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.hidetoast()
        })
        
    })

    }
       //  self.generic.hideNativeActivityIndicatorInteractionEnabled(self)
    }
    func tryGetSupplierCustomerUserIdByEmployeeId() {
        generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            generic.hideNativeActivityIndicator(self)
        } else {
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
                self.generic.hideNativeActivityIndicator(self)
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
            self.generic.hideNativeActivityIndicator(self)
        })
        }
    }
    //2
    func GetSecondUserIdByFirstUserId(_ employeID:Int)  {
        var y:Int = 0
        var dicEMPLOYE:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        y = employeID
        dicEMPLOYE["iUserId"] =  y as AnyObject
        generic.showNativeActivityIndicator(self)
        print("\n********************************* GetSecondUserIdByFirstUserId  ********************\n")
        if Reachability.isConnectedToNetwork() == false
        {
            generic.hideNativeActivityIndicator(self)
        }
        else
        {
            api.sharedInstance.GetSecondUserIdByFirstUserId(dicEMPLOYE, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    self.generic.hideNativeActivityIndicator(self)
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
                self.generic.hideNativeActivityIndicator(self)
            })
        }
    }

    func updatenow(_ iUserID:Int) {
        self.UpdateWorkingHours(iUserID)
//
//        Global.sharedInstance.domainBuisness = ""
//        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        dic = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.getDic()
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
//        print("|Global.sharedInstance.generalDetails.iFieldId\(Global.sharedInstance.generalDetails.iFieldId)")
//        Global.sharedInstance.generalDetails.arrObjServiceProviders = []
//        Global.sharedInstance.arrObjServiceProvidersForEdit = []
//        Global.sharedInstance.generalDetails.arrObjServiceProviders = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjServiceProviders
//        print("  arrObjServiceProviders employes\( Global.sharedInstance.generalDetails.arrObjServiceProviders.count )")
//        Global.sharedInstance.generalDetails.arrObjProviderServices = []
//        Global.sharedInstance.generalDetails.arrObjProviderServices = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjProviderServices
//        print(" arrObjProviderServices servicii  \( Global.sharedInstance.generalDetails.arrObjProviderServices.count )")
//        print("calendarset \(  Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.calendarProperties.getDic())")
//        Global.sharedInstance.generalDetails.calendarProperties = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.calendarProperties
//        var dicAddProviderDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        dicAddProviderDetails["obj"] = Global.sharedInstance.generalDetails.geMASTERSecondDic(iUserID,iFieldId: Global.sharedInstance.generalDetails.iFieldId) as AnyObject
//        dicAddProviderDetails["iSupplierServiceIdForDeleteUserPermission"] = Global.sharedInstance.iSupplierServiceIdForDeleteUserPermission
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
//                            self.view.makeToast(message: "SUCCESS_SETUP_WORKING_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
//                            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//                            self.generic.showNativeActivityIndicator(self)
//                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
//                                self.hidetoast()
//
//                            })
//
//                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
//
//                                self.updateNOWORKINGHOURS()
//                            })
//                        }
//                        else
//                        {
//                             self.generic.hideNativeActivityIndicator(self)
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
    }
    func updateNOWORKINGHOURS() {
        Global.sharedInstance.NOWORKINGDAYS = []
        let anotherarray:NSMutableArray = NSMutableArray()
        let myarr = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours
        for a in myarr {
            if a.iDayInWeekType != 0 {
                if !anotherarray.contains(a.iDayInWeekType) {
                    anotherarray.add(a.iDayInWeekType)
                }
        }
        }
            let FIXEDNUMBERS:NSArray = [1,2,3,4,5,6,7]
            for item in FIXEDNUMBERS {
                if !anotherarray.contains(item) {
                    if !Global.sharedInstance.NOWORKINGDAYS.contains(item) {
                        Global.sharedInstance.NOWORKINGDAYS.add(item)
                    }
                }
        }
        print("NOWORKINGDAYS \(Global.sharedInstance.NOWORKINGDAYS)")
        self.gotosettings()
    }
    func GetProviderSettingsForCalendarmanagement() {
        var newObjectCalendar = objCalendarProperties()
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

}
