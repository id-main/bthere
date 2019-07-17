//
//  EDITEmployeeSettingsSetupWorkingHours.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 21/03/19.
//  Copyright © 2019 Bthere. All rights reserved.
//
//
import Foundation
import UIKit
import Fabric
import Crashlytics
protocol isOpenRowDelegate6 {
    func openRow(_WHICHCELL:Int, _WHICHSTATE:Bool)
    func seteditbuttonpressed(_WHICHCELL:Int)
    func seteditsecondbuttonpressed(_WHICHCELL:Int)
    func setaddbuttonpressed(_WHICHCELL:Int)
    func savedDataOn(_WHICHCELL:Int, _WHICHSTATE:Bool, _WHICHSTATE2:Bool, _firstSel: objWorkingHours, _secondsel: objWorkingHours)
    func savedDataFirstInterval(_WHICHCELL:Int, _WHICHSTATE:Bool, _firstSel: objWorkingHours)
    func closeandclearWorkingHours(_WHICHCELL:Int)
}
class EDITEmployeeSettingsSetupWorkingHours:UIViewController, UITableViewDelegate, UITableViewDataSource,isOpenRowDelegate6 {
    var delegate:SettingsSetupEmployees!=nil
    var myIndex:Int = 0
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
    var hoursareidentical:Bool = false
    var NewUser:User = User()
    var SELECTED_PERMISSION_TEXT_LABEL_TEXT:String = ""
    var SELECTED_SERVICE_PERMISSION_TEXT_LABEL_TEXT:String = ""
    @IBOutlet weak var backImage:UIImageView!
    @IBOutlet weak var TitleScreen:UILabel!
    @IBOutlet weak var Container:UITableView!
    @IBOutlet weak var ARE_HIS_WORKING_HOURS_IDENTICAL_TO_THE_BUSINESS_WORKING_HOURS:UILabel!
    @IBOutlet weak var NEXT_BUTTON:UIButton!
    @IBOutlet weak var BACK_BUTTON:UIButton!
    @IBOutlet weak var btnYesSelect: CheckBoxForDetailsWorker3!
    @IBOutlet weak var btnNoSelect: checkBoxForDetailsWorker4!
    @IBOutlet weak var rightarrowblue: UIImageView!
    @IBOutlet weak var leftarrowblue: UIImageView!

    @IBAction func btnNoSelect(_ sender: AnyObject) {
        Global.sharedInstance.employehassamehours = false
        hoursareidentical = false
        btnYesSelect.isCecked = false
        btnNoSelect.isCecked = true
        hasHoursSelected = [false, false, false, false, false, false, false]
        hasHoursSecondSelected = [false, false, false, false, false, false, false]
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
        for a in Global.sharedInstance.NEWARRAYOBJEMPLOYEEWORKINGHOURS {
            print("we work on \(a.getDic())")
            for i in 1...7 {
                var hoursinday:Array<objWorkingHours> = []
                for z in 0..<Global.sharedInstance.NEWARRAYOBJEMPLOYEEWORKINGHOURS.count {
                    let arie:objWorkingHours = Global.sharedInstance.NEWARRAYOBJEMPLOYEEWORKINGHOURS[z]
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
        Container.isHidden = false
        Container.reloadData()

    }
    @IBAction func btnYesSelect(_ sender: AnyObject) {
        Global.sharedInstance.employehassamehours = true
        hoursareidentical = true
        btnYesSelect.isCecked = true
        btnNoSelect.isCecked = false
        Global.sharedInstance.NEWARRAYOBJWORKINGHOURS = Array<objWorkingHours>()
        hasHoursSelected = [false, false, false, false, false, false, false]
        hasHoursSecondSelected = [false, false, false, false, false, false, false]
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

        Container.isHidden = true
        Container.reloadData()
    }
    @IBAction func gobacktoStepOne(){
        if hoursareidentical == true {
            Global.sharedInstance.employehassamehours = true
        } else {
            Global.sharedInstance.employehassamehours = false
        }
        validateScreen(self.NEXT_BUTTON)
        self.dismiss(animated: true, completion: nil)
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
            Global.sharedInstance.NEWARRAYOBJEMPLOYEEWORKINGHOURS  = Array<objWorkingHours>()
            //       Alert.sharedInstance.showAlertDelegate("SELECT_HOURS_FOR_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            return
        } else {

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
            Global.sharedInstance.NEWARRAYOBJEMPLOYEEWORKINGHOURS = mymixedarray
            print(Global.sharedInstance.NEWARRAYOBJEMPLOYEEWORKINGHOURS .count)

        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        if Global.sharedInstance.employehassamehours == true {
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
        } else {
            for a in Global.sharedInstance.NEWARRAYOBJEMPLOYEEWORKINGHOURS {
                print("we work on \(a.getDic())")
                for i in 1...7 {
                    var hoursinday:Array<objWorkingHours> = []
                    for z in 0..<Global.sharedInstance.NEWARRAYOBJEMPLOYEEWORKINGHOURS.count {
                        let arie:objWorkingHours = Global.sharedInstance.NEWARRAYOBJEMPLOYEEWORKINGHOURS[z]
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

        }
        if Global.sharedInstance.employehassamehours == true {
            hoursareidentical = true
            btnYesSelect.isCecked = true
            btnNoSelect.isCecked = false
            Container.isHidden = true
        } else {
            hoursareidentical = false
            btnYesSelect.isCecked = false
            btnNoSelect.isCecked = true
            Container.isHidden = false
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //    self.Container.reloadData()
    }

    override func viewDidLoad() {
        self.view.addBackground()
        print("NewUser \(Global.sharedInstance.NEW_EMPLOYEE_EDIT.getDic())")
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            rightarrowblue.image =    UIImage(named: "leftarrowblue.png")
            leftarrowblue.image =    UIImage(named: "returnarrowinsuppliuerregistrationhebrew.png")
        }
        else
        {
            rightarrowblue.image =    UIImage(named: "rightarrowblue.png")
            leftarrowblue.image =    UIImage(named: "returnarrowinsuppliuerregistration.png")
        }
        NEXT_BUTTON.setAttributedTitle(NSAttributedString(string:"NEXT_BUTTON".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!, convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : 1])), for: .normal)
        TitleScreen.text = "EDIT_EMPLOYEE_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ARE_HIS_WORKING_HOURS_IDENTICAL_TO_THE_BUSINESS_WORKING_HOURS.text = "ARE_HIS_WORKING_HOURS_IDENTICAL_TO_THE_BUSINESS_WORKING_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
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
        let cell:EDITEmployeeSettingsEditWorkingHoursCell = tableView.dequeueReusableCell(withIdentifier: "EDITEmployeeSettingsEditWorkingHoursCell") as! EDITEmployeeSettingsEditWorkingHoursCell
        let ax = indexPath.section
        cell.delegate = self
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.indexSection = indexPath.section
        cell.AddHoursButton.layer.cornerRadius = 0
        cell.AddHoursButton.setTitle("AddHoursButton_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        cell.AddHoursButton.titleLabel?.textColor = Colors.sharedInstance.color3
        cell.AddHoursButton.layer.borderColor = Colors.sharedInstance.color3.cgColor
        cell.AddHoursButton.layer.borderWidth =  1
        cell.AddHoursButton.layer.cornerRadius = 0
        cell.SAVEAddHoursButton.setTitle("SAVEAddHoursButton".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        cell.SAVEAddHoursButton.backgroundColor =  Colors.sharedInstance.color4
        cell.FROM_LABEL.text = "FROM_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        cell.UNTIL_LABEL.text = "UNTIL_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        let _isopen  = openRows[ax]
        let _firstinterval = FIRSTINTERVALArray[ax]
        let _hasHoursSelected = hasHoursSelected[ax]
        let _hasHoursSecondSelected = hasHoursSecondSelected[ax]
        cell.setDisplayData(openRows[ax], daydesc: myDayNames[indexPath.section], _indexsection:indexPath.section, _firstinterval: FIRSTINTERVALArray[ax], _secondinterval: SECONDINTERVALArray[ax], _hasHoursSelected: hasHoursSelected[ax], _hasHoursSecondSelected:hasHoursSecondSelected[ax], _isinEDIT:haspreesededitbutton[ax], _isinEDITSECOND:haspreesededitsecondbutton[ax],_isinADD:haspreesedaddbutton[ax] )
        print("_isnewopen \(currentopencell)")
//        DispatchQueue.main.async {
//        cell.setDisplayData(self.openRows[ax], daydesc: self.myDayNames[indexPath.section], _indexsection:indexPath.section, _firstinterval: self.FIRSTINTERVALArray[ax], _secondinterval: self.SECONDINTERVALArray[ax], _hasHoursSelected: self.hasHoursSelected[ax], _hasHoursSecondSelected:self.hasHoursSecondSelected[ax], _isinEDIT:self.haspreesededitbutton[ax], _isinEDITSECOND:self.haspreesededitsecondbutton[ax],_isinADD:self.haspreesedaddbutton[ax] )
//        print("_isnewopen \(self.currentopencell)")
//        }


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
        validateScreen(self.NEXT_BUTTON)
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
            validateScreen(self.NEXT_BUTTON)
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

        validateScreen(self.NEXT_BUTTON)
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
    //LAST STEP
    @IBAction func gotoStepThree(_ sender:UIButton) {
        if Global.sharedInstance.employehassamehours == false {
            self.validateScreen(self.NEXT_BUTTON)
            if Global.sharedInstance.NEWARRAYOBJEMPLOYEEWORKINGHOURS.count == 0 {
                Alert.sharedInstance.showAlertDelegate("SELECT_HOURS_FOR_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                return
            }
        }
        let mainstoryb = UIStoryboard(name: "newemployee", bundle: nil)
        let viewCONFIRM_EMPLOYEE_DETAILS: CONFIRM_EMPLOYEE_DETAILS = mainstoryb.instantiateViewController(withIdentifier: "CONFIRM_EMPLOYEE_DETAILS")as! CONFIRM_EMPLOYEE_DETAILS
        viewCONFIRM_EMPLOYEE_DETAILS.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        viewCONFIRM_EMPLOYEE_DETAILS.modalPresentationStyle = .custom
        Global.sharedInstance.NEW_EMPLOYEE_EDIT.bSameWH = Global.sharedInstance.employehassamehours
        print(SELECTED_PERMISSION_TEXT_LABEL_TEXT)
        viewCONFIRM_EMPLOYEE_DETAILS.SELECTED_PERMISSION_TEXT_LABEL_TEXT = SELECTED_PERMISSION_TEXT_LABEL_TEXT
        viewCONFIRM_EMPLOYEE_DETAILS.SELECTED_SERVICE_PERMISSION_TEXT_LABEL_TEXT = SELECTED_SERVICE_PERMISSION_TEXT_LABEL_TEXT
        viewCONFIRM_EMPLOYEE_DETAILS.isNEW = false
        viewCONFIRM_EMPLOYEE_DETAILS.delegate1 = self.delegate
        viewCONFIRM_EMPLOYEE_DETAILS.myIndex = myIndex
        if Global.sharedInstance.employehassamehours == true {
            viewCONFIRM_EMPLOYEE_DETAILS.NEWARRAYOBJEMPLOYEEWORKINGHOURS = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours
            Global.sharedInstance.NEW_EMPLOYEE_EDIT.arrObjWorkingHours = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours

        } else {
            viewCONFIRM_EMPLOYEE_DETAILS.NEWARRAYOBJEMPLOYEEWORKINGHOURS = Global.sharedInstance.NEWARRAYOBJEMPLOYEEWORKINGHOURS
            Global.sharedInstance.NEW_EMPLOYEE_EDIT.arrObjWorkingHours = Global.sharedInstance.NEWARRAYOBJEMPLOYEEWORKINGHOURS

        }
        self.present(viewCONFIRM_EMPLOYEE_DETAILS, animated: true, completion: nil)
    }
    
    func hidetoast(){
        view.hideToastActivity()
    }

   


}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
