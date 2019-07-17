//
//  CONFIRM_EMPLOYEE_DETAILS.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 13/03/2019
//  Copyright © 2019 Bthere. All rights reserved.
//

import UIKit


class CONFIRM_EMPLOYEE_DETAILS: UIViewController, UIGestureRecognizerDelegate {
    var delegate:SettingsSetupEmployees!=nil
    var delegate1:SettingsSetupEmployees!=nil
    var isNEW:Bool = false
    var myIndex:Int = 0
    var NewUser:User = User()
    var ArrayServicesPermissions:Array<Int> = Array<Int>()
    var NEWARRAYOBJEMPLOYEEWORKINGHOURS:Array<objWorkingHours> = Array<objWorkingHours>()
    var ismanager:Int = 0
    var  SELECTED_PERMISSION_TEXT_LABEL_TEXT:String = ""
    var  SELECTED_SERVICE_PERMISSION_TEXT_LABEL_TEXT:String = ""
    @IBOutlet weak var txtView: UILabel!
    @IBOutlet weak var titletext:UILabel!
    @IBOutlet weak var FULL_NAME:UILabel!
    @IBOutlet weak var PHONE_NUMBER:UILabel!
    @IBOutlet weak var EDITED_PHONE_NUMBER:UILabel!
    @IBOutlet weak var EDITED_FULL_NAME:UILabel!
    @IBOutlet weak var MANAGER_PERMISSION:UILabel!
    @IBOutlet weak var ACCESS_PERMISSIONS:UILabel!
    @IBOutlet weak var SERVICE_PERMISSIONS:UILabel!
    @IBOutlet weak var EDITED_ACCESS_PERMISSIONS:UILabel!
    @IBOutlet weak var EDITED_SERVICE_PERMISSIONS:UILabel!
    @IBOutlet weak var EDITED_WORKING_HOURS:UILabel!
    @IBOutlet weak var FINISH_BUTTON:UIButton!
    @IBOutlet weak var BUTTON_BACK:UIButton!
    @IBOutlet weak var NEXT_BUTTON:UIButton!
    @IBOutlet weak var btnYesSelect: CheckBoxForDetailsWorker3!
    @IBOutlet weak var btnNoSelect: checkBoxForDetailsWorker4!
    @IBOutlet weak var leftarrowblue: UIImageView!
    @IBAction func gobacktoStepTwo(){
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    override func viewWillAppear(_ animated: Bool) {
        print(Global.sharedInstance.NEW_EMPLOYEE_EDIT.getDic())
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            leftarrowblue.image =    UIImage(named: "returnarrowinsuppliuerregistrationhebrew.png")
            FULL_NAME.textAlignment = .right
            EDITED_FULL_NAME.textAlignment = .right
            PHONE_NUMBER.textAlignment = .right
            EDITED_PHONE_NUMBER.textAlignment = .right
            MANAGER_PERMISSION.textAlignment = .right
            ACCESS_PERMISSIONS.textAlignment = .right
            EDITED_ACCESS_PERMISSIONS.textAlignment = .right
            SERVICE_PERMISSIONS.textAlignment = .right
            EDITED_SERVICE_PERMISSIONS.textAlignment = .right
            EDITED_WORKING_HOURS.textAlignment = .right
        }
        else
        {
            leftarrowblue.image =    UIImage(named: "returnarrowinsuppliuerregistration.png")
            FULL_NAME.textAlignment = .left
            EDITED_FULL_NAME.textAlignment = .left
            PHONE_NUMBER.textAlignment = .left
            EDITED_PHONE_NUMBER.textAlignment = .left
            MANAGER_PERMISSION.textAlignment = .left
            ACCESS_PERMISSIONS.textAlignment = .left
            EDITED_ACCESS_PERMISSIONS.textAlignment = .left
            SERVICE_PERMISSIONS.textAlignment = .left
            EDITED_SERVICE_PERMISSIONS.textAlignment = .left
            EDITED_WORKING_HOURS.textAlignment = .left
        }
       
        titletext.text = "CONFIRM_EMPLOYEE_DETAILS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        FULL_NAME.text = "FULL_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        EDITED_FULL_NAME.text = Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.nvFirstName + " " + Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.nvLastName
        PHONE_NUMBER.text = "PHONE_NUMBER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        EDITED_PHONE_NUMBER.text = Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.nvPhone
        MANAGER_PERMISSION.text = "MANAGER_PERMISSION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ACCESS_PERMISSIONS.text = "ACCESS_PERMISSIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        EDITED_ACCESS_PERMISSIONS.text =  SELECTED_PERMISSION_TEXT_LABEL_TEXT
        SERVICE_PERMISSIONS.text = "SERVICE_PERMISSIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        print(SELECTED_PERMISSION_TEXT_LABEL_TEXT)
        EDITED_SERVICE_PERMISSIONS.text = SELECTED_SERVICE_PERMISSION_TEXT_LABEL_TEXT
        EDITED_WORKING_HOURS.text = ""
        NEXT_BUTTON.setTitle("FINISH_BUTTON".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        ismanager = Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.bIsManager 
        if ismanager == 1 {
            btnYesSelect.isCecked = true
            btnNoSelect.isCecked = false
//            ACCESS_PERMISSIONS.isHidden = true
//            EDITED_ACCESS_PERMISSIONS.isHidden = true
//            SERVICE_PERMISSIONS.isHidden = true
//            EDITED_SERVICE_PERMISSIONS.isHidden = true
        } else {
            btnYesSelect.isCecked = false
            btnNoSelect.isCecked = true
            ACCESS_PERMISSIONS.isHidden = false
            EDITED_ACCESS_PERMISSIONS.isHidden = false
            SERVICE_PERMISSIONS.isHidden = false
            EDITED_SERVICE_PERMISSIONS.isHidden = false
        }

        print(NEWARRAYOBJEMPLOYEEWORKINGHOURS.description)

                    let workingHours:objWorkingHours = objWorkingHours()
                    var arrWorkingHours = workingHours.sortHoursArrayByDays(NEWARRAYOBJEMPLOYEEWORKINGHOURS)

                    var DayFlagArr = [0,0,0,0,0,0,0]
                    var hourShow = ""

                    for i in 0 ..< 7 {
                        if arrWorkingHours[i].count != 0 {
                            if DayFlagArr[i] != 1 {
                                if arrWorkingHours[i].count == 2 {
                                    if arrWorkingHours[i][0].nvFromHour != "" && !(arrWorkingHours[i][0].nvFromHour == "00:00:00" && arrWorkingHours[i][0].nvToHour == "00:00:00" && arrWorkingHours[i][1].nvFromHour == "00:00:00" && arrWorkingHours[i][1].nvToHour == "00:00:00") {
                                        for j in 0 ..< 7 {
                                            if arrWorkingHours[j].count == 2 {
                                                if arrWorkingHours[i][0].nvFromHour == arrWorkingHours[j][0].nvFromHour && arrWorkingHours[i][0].nvToHour == arrWorkingHours[j][0].nvToHour && arrWorkingHours[i][1].nvFromHour == arrWorkingHours[j][1].nvFromHour && arrWorkingHours[i][1].nvToHour == arrWorkingHours[j][1].nvToHour {
                                                    hourShow = "\(hourShow) \(convertDays(j)),"
                                                    DayFlagArr[j] = 1
                                                }
                                            }
                                        }

                                        hourShow = String(hourShow.dropLast())
                                        hourShow = "\(hourShow) - "

                                        if arrWorkingHours[i].count != 0 {
                                            hourShow = "\(hourShow) \(cutHour(arrWorkingHours[i][0].nvFromHour))-\(cutHour(arrWorkingHours[i][0].nvToHour)), \(cutHour(arrWorkingHours[i][1].nvFromHour))-\(cutHour(arrWorkingHours[i][1].nvToHour)),\n"
                                        }
                                    }
                                } else if arrWorkingHours[i].count == 1 {
                                    if arrWorkingHours[i][0].nvFromHour != "" && !(arrWorkingHours[i][0].nvFromHour == "00:00:00" && arrWorkingHours[i][0].nvToHour == "00:00:00") {
                                        for j in 0 ..< 7 {
                                            if arrWorkingHours[j].count == 1 {
                                                if arrWorkingHours[i][0].nvFromHour == arrWorkingHours[j][0].nvFromHour && arrWorkingHours[i][0].nvToHour == arrWorkingHours[j][0].nvToHour {
                                                    hourShow = "\(hourShow) \(convertDays(j)),"
                                                    DayFlagArr[j] = 1
                                                }
                                            }
                                        }

                                        hourShow = String(hourShow.dropLast())
                                        hourShow = "\(hourShow) - "

                                        if arrWorkingHours[i].count != 0 {
                                            hourShow = "\(hourShow) \(cutHour(arrWorkingHours[i][0].nvFromHour))-\(cutHour(arrWorkingHours[i][0].nvToHour)),\n"
                                        }
                                    }
                                }
                            }
                        }
                    }
        //CODE IS ANCIENT so I JUST CLEAN IT FAST :) JMODE
        hourShow = String(hourShow.dropLast())
        hourShow = clearLastComma(_whichString: hourShow)
        hourShow = clearLastComma(_whichString: hourShow)
        hourShow = clearLastComma(_whichString: hourShow)

            EDITED_WORKING_HOURS.text = hourShow

    }
    func clearLastComma(_whichString:String) -> String {
        var hourShow:String = _whichString
        if _whichString.count > 1 {
            let last = _whichString.substring(from:hourShow.index(hourShow.endIndex, offsetBy: -1))
            if last == "," {
                hourShow = String(hourShow.dropLast())
            }
        }
        return hourShow
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func convertDays(_ day:Int) -> String {
        switch day {
        case 0:
            return "SUNDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 1:
            return "MONDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 2:
            return "TUESDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 3:
            return "WEDNSDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 4:
            return "THIRTHDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 5:
            return "FRIDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 6:
            return "SHABAT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        default:
            return "SUNDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
    }
    func cutHour(_ hour:String) -> String {
        var fixedHour = String(hour.dropLast())
        fixedHour = String(fixedHour.dropLast())
        fixedHour = String(fixedHour.dropLast())
        return fixedHour
    }
    @IBAction func FINISHBUTTON(){

        Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.bAdvertisingApproval = true
        Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.bAutomaticUpdateApproval = false
        Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.bDataDownloadApproval =  true
        Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.bIsGoogleCalendarSync = true
        Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.bTermOfUseApproval = true
        Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.iCreatedByUserId = Global.sharedInstance.providerID
        Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.iLastModifyUserId = 0
        Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.iSysRowStatus = 1
        Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.iUserStatusType = 24
        Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.iCityType = 1

        print("to save: \(Global.sharedInstance.NEW_EMPLOYEE_EDIT.getDic())")
//        let mainstoryb = UIStoryboard(name: "newemployee", bundle: nil)
//        let viewSettingsSetupEmployees: SettingsSetupEmployees = mainstoryb.instantiateViewController(withIdentifier: "SettingsSetupEmployees")as! SettingsSetupEmployees
//            let frontviewcontroller:UINavigationController? = UINavigationController()
//            frontviewcontroller!.pushViewController(viewSettingsSetupEmployees, animated: false)
//            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
//            let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//            let mainRevealController = SWRevealViewController()
//            mainRevealController.frontViewController = frontviewcontroller
//            mainRevealController.rearViewController = rearViewController
//            let window :UIWindow = UIApplication.shared.keyWindow!
//            window.rootViewController = mainRevealController
       // self.dismiss(animated: true, completion: nil)
        if isNEW == true  {
        Global.sharedInstance.ARRAYEMPLOYEE.append(Global.sharedInstance.NEW_EMPLOYEE_EDIT)
        delegate.reloadTableFull()
        delegate.AddEmployeaddtoArray(_whichID: Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.iUserId)
        } else {
            let existingid = Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.iUserId

            if delegate1.EMPLOYEES_ID_TO_ADD.contains(existingid) {
                Global.sharedInstance.ARRAYEMPLOYEE[myIndex] = Global.sharedInstance.NEW_EMPLOYEE_EDIT
                delegate1.reloadTableFull()
            } else {
        Global.sharedInstance.ARRAYEMPLOYEE[myIndex] = Global.sharedInstance.NEW_EMPLOYEE_EDIT
        delegate1.UpdateEmployeaddtoArray(_whichID: Global.sharedInstance.NEW_EMPLOYEE_EDIT.objsers.iUserId)
        delegate1.reloadTableFull()
        }
        }
        dismissAll(animated: false)

    }

    
}
