//
//  RegisterBuisnessProphielViewController.swift
//  bthree-ios
//
//  Created by User on 29.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import AssetsLibrary
import CoreLocation
import CoreMotion
import Foundation
import MapKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}



//דף 5 בהרשמה - פרופיל עסקי
class RegisterBuisnessProphielViewController: NavigationModelViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate,WDImagePickerDelegate,NSURLConnectionDelegate,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var lblRemovePic: UILabel!
    @IBOutlet weak var removePicView: UIView!
    @IBOutlet weak var removeCompanyLabel: UILabel!

    @IBOutlet weak var removeCompanyImg: UIImageView!
    @IBOutlet weak var CompanyViewRemovePic: UIView!

    @IBOutlet weak var removeSaleView: UIView!
    @IBOutlet weak var removeSaleLabel: UILabel!
    @IBOutlet weak var pageTitleLabel: UILabel!



    //labels zone

    @IBOutlet weak var dayOneLabel: UILabel!
    @IBOutlet weak var dayTwoLabel: UILabel!
    @IBOutlet weak var dayThreeLabel: UILabel!
    @IBOutlet weak var dayFourLabel: UILabel!
    @IBOutlet weak var dayFiveLabel: UILabel!
    @IBOutlet weak var daySixLabel: UILabel!
    @IBOutlet weak var daySevenLabel: UILabel!

    @IBOutlet weak var hoursOneLabel: UILabel!
    @IBOutlet weak var hoursTwoLabel: UILabel!
    @IBOutlet weak var hoursThreeLabel: UILabel!
    @IBOutlet weak var hoursFourLabel: UILabel!
    @IBOutlet weak var hoursFiveLabel: UILabel!
    @IBOutlet weak var hoursSixLabel: UILabel!
    @IBOutlet weak var hoursSevernLabel: UILabel!

    @IBOutlet weak var openOrClosedLabel: UILabel!

    @IBOutlet weak var geseata: UIImageView!
    @IBOutlet weak var hoursLabel: UILabel!


    @IBAction func btnsavedoi(_ sender: AnyObject) {
        //\\ self.dismissViewControllerAnimated(true, completion:nil)

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent

        //        if let topController = UIApplication.topViewController() {
        self.generic.showNativeActivityIndicator(self)
        //        }



        //1. slogen
        var providerProfileObjToUpdate:AddProviderBusinessProfile = AddProviderBusinessProfile()
        providerProfileObjToUpdate = Global.sharedInstance.addProviderBusinessProfile
        //        if Global.sharedInstance.addProviderBusinessProfile.nvFacebookLink == ""
        //        {
        //            Global.sharedInstance.addProviderBusinessProfile.nvFacebookLink = facebookTxt.text!
        //        }
        //        if Global.sharedInstance.addProviderBusinessProfile.nvInstagramLink == ""
        //        {
        //            Global.sharedInstance.addProviderBusinessProfile.nvInstagramLink = instagramTxt.text!
        //        }
        if Global.sharedInstance.addProviderBusinessProfile.nvFacebookLink != facebookTxt.text!
        {
            validateFacebookLink(textField: facebookTxt)
        }
        if Global.sharedInstance.addProviderBusinessProfile.nvInstagramLink != instagramTxt.text!
        {
            validateInstagramLink(textField: instagramTxt)
        }
        providerProfileObjToUpdate.nvFacebookLink = Global.sharedInstance.addProviderBusinessProfile.nvFacebookLink
        providerProfileObjToUpdate.nvInstagramLink = Global.sharedInstance.addProviderBusinessProfile.nvInstagramLink
        Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvFacebookLink = providerProfileObjToUpdate.nvFacebookLink
        Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvInstagramLink = providerProfileObjToUpdate.nvInstagramLink

        providerProfileObjToUpdate.nvILogoImage = Global.sharedInstance.addProviderBusinessProfile.nvILogoImage
        Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage = providerProfileObjToUpdate.nvILogoImage

        providerProfileObjToUpdate.nvSlogen = Global.sharedInstance.addProviderBusinessProfile.nvSlogen
        Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen = providerProfileObjToUpdate.nvSlogen

        providerProfileObjToUpdate.nvCampaignImage = Global.sharedInstance.addProviderBusinessProfile.nvCampaignImage
        Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvCampaignImage = providerProfileObjToUpdate.nvCampaignImage

        providerProfileObjToUpdate.nvFooterImage = Global.sharedInstance.addProviderBusinessProfile.nvFooterImage
        Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvFooterImage = providerProfileObjToUpdate.nvFooterImage

        providerProfileObjToUpdate.nvAboutComment = Global.sharedInstance.addProviderBusinessProfile.nvAboutComment
        Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvAboutComment = providerProfileObjToUpdate.nvAboutComment

        providerProfileObjToUpdate.nvHeaderImage = Global.sharedInstance.addProviderBusinessProfile.nvHeaderImage
        Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvHeaderImage = providerProfileObjToUpdate.nvHeaderImage


        print("facebook value to be saved: \(Global.sharedInstance.addProviderBusinessProfile.nvFacebookLink)")
        print("instagram value to be saved: \(Global.sharedInstance.addProviderBusinessProfile.nvInstagramLink)")
        print("CEEE Global.sharedInstance.providerID \(Global.sharedInstance.providerID)")
        print ("Global.sharedInstance.addProviderBuisnessProfile \(providerProfileObjToUpdate.getDic())")
        //        print("trimit instagram: \(Global.sharedInstance.)")
        // var dicAddProviderDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()


        var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicuser["obj"] = providerProfileObjToUpdate.getDic() as AnyObject
        if Reachability.isConnectedToNetwork() == false
        {
            //            if let topController = UIApplication.topViewController() {
            self.generic.hideNativeActivityIndicator(self)
            //            }
            //Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            self.view.makeToast(message: "NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.hidetoast()
                self.btnback(self.btnBack)
            })
        }
        else {

            //  self.generic.showNativeActivityIndicator(self)

            api.sharedInstance.AddProviderBusinessProfile(dicuser, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in

                //                if let topController = UIApplication.topViewController() {
                self.generic.hideNativeActivityIndicator(self)
                //                }
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    //  print("ce aduce \(RESPONSEOBJECT)")
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                        {
                            self.generic.hideNativeActivityIndicator(self)
                            self.view.makeToast(message: "ERROR_UPDATE_BUSINESS_PROFILE".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                self.hidetoast()
                            })
                        }
                        else
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int
                            {

                                let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!

                                if myInt == 1 {
                                    //success
                                    self.generic.showNativeActivityIndicator(self)
                                    self.view.makeToast(message: "UPDATED_BUSINESS_PROFILE".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(4.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                        self.hidetoast()

                                        self.btnback(self.btnBack)
                                    })

                                }
                        }
                    }
                }

            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                //                if let topController = UIApplication.topViewController() {
                self.generic.hideNativeActivityIndicator(self)
                //                }
                self.view.makeToast(message: "ERROR_UPDATE_BUSINESS_PROFILE".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                    self.hidetoast()
                })
                //                if AppDelegate.showAlertInAppDelegate == false
                //                {
                //                    Alert.sharedInstance.showAlertDelegate("ERROR_UPDATE_BUSINESS_PROFILE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                //                    AppDelegate.showAlertInAppDelegate = true
                //                }

            })
        }
    }

    //MARK: - Jo
    //===========Jo=========
    var storyBoard1Main:UIStoryboard?
    var supplierStoryBoard2:UIStoryboard?
    @IBOutlet weak var viewNEWTOP: UIView!
    @IBOutlet weak var viewBOTTOMSAVE: UIView!
    @IBOutlet weak var viewBLUETOP: UIView!
    @IBOutlet weak var JUPLOADCOMPANYLOGO: UIView!
    @IBOutlet weak var uploadcompanylogo: UILabel! //UPLOAD_COMPANY_LOGO
    @IBOutlet weak var lblNmeBuisness: UILabel!
    @IBOutlet weak var uploadcompanyprofilePhoto: UILabel! //UPLOAD_COMPANY_PROFILE_PHOTO
    @IBOutlet weak var lblSlogenBuisness: UITextField!
    @IBOutlet weak var rateourBussines: UIButton!
    @IBOutlet weak var takelogo: UIImageView!
    @IBOutlet weak var takeprofile: UIImageView!
    @IBOutlet weak var takesale: UIImageView!
    //hours address fb
    @IBOutlet weak var viewNEWWorkingHoursandAddress : UIView!
    @IBOutlet weak var LabelAddress : UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSaveDoi: UIButton!
    @IBOutlet weak var linkToInstagramLabel: UILabel!
    @IBOutlet weak var linkToFacebookLabel: UILabel!

    //===========End Jo=========
    //MARK: - Properties
    //===========Properties=========

    @IBOutlet weak var topSCREEN:NSLayoutConstraint!
    var topSaleOpen:NSLayoutConstraint!
    var topSaleClose:NSLayoutConstraint!
    var generic:Generic = Generic()
    var latitude:CLLocationDegrees = 0
    var longitude:CLLocationDegrees = 0
    var isOnChosenAddress = true

    var flagFirst = false

    var flagImage = 0
    var scrollAbout:CGFloat = 0
    var scrollCampain:CGFloat = 0

    var longMessage:String = ""

    var tapGestureRecognizerForAlbom = UIGestureRecognizer()//logo
    var tapGestureRecognizerForCamera = UITapGestureRecognizer()//logo

    var tapGestureRecognizerForAlbom_3 = UIGestureRecognizer()//viewLightBlue3
    var tapGestureRecognizerForCamera_3 = UITapGestureRecognizer()//viewLightBlue3

    var tapGestureRecognizerForAlbom_campain = UIGestureRecognizer()//view_campain
    var tapGestureRecognizerForCamera_campain = UITapGestureRecognizer()//view_campain
    var removePictureRecognizer = UITapGestureRecognizer()

    var removeCompanyPictureRecognizer = UIGestureRecognizer()
    var removeSaleRecognizer = UIGestureRecognizer()

    var tapGestureRecognizer2 = UITapGestureRecognizer()

    var changeImage:String = ""


    fileprivate var iimagePicker: WDImagePicker!
    fileprivate var imagePickerWD: WDImagePicker!

    var imagePicker: UIImagePickerController!

    //MARK: - Outlet
    //==========outlet=========


    @IBOutlet weak var addImage8: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    //////----top view



    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblCity: UILabel!


    // דירוג: 8.9 | 32 מדרגים

    ////view 3----------

    @IBOutlet weak var addImage3: UIImageView!
    @IBOutlet weak var imgLightBlue3: UIImageView!
    @IBOutlet weak var view_lightBlue_3: UIView!
    /////// @IBOutlet weak var lblHoursWork: UILabel!

    @IBAction func btnLikeF(_ sender: AnyObject) {}
    @IBOutlet weak var btnLikeF: UIButton!
    @IBOutlet weak var btnShareF: UIButton!
    @IBAction func btnShareF(_ sender: AnyObject) {}
    //    @IBOutlet weak var btnInviteTor: UIButton!
    //    @IBAction func btnInviteTor(sender: AnyObject) {}



    @IBOutlet weak var addressLabel: UILabel!

    //About
    @IBOutlet weak var viewAbout_4: UIView!
    @IBOutlet weak var lblAbout: UILabel!


    // to show the text
    @IBOutlet weak var txtViewAbout: UITextView!
    @IBOutlet weak var view_lightBlue_5: UIView!
    @IBOutlet weak var imgLightBlue5: UIImageView!
    @IBOutlet weak var lblUploadCampaign: UILabel!
    @IBOutlet weak var topToSale: NSLayoutConstraint!


    //------ ViewToHide : Logo ----

    @IBOutlet weak var viewLogo: UIView!
    @IBOutlet weak var lblLogo: UILabel!
    @IBOutlet weak var lblCameraLogo: UILabel!
    @IBOutlet weak var lblAddFromAlbum: UILabel!
    @IBOutlet weak var imgFromAlbom: UIImageView!
    @IBOutlet weak var imgFromCamera: UIImageView!
    @IBOutlet weak var viewCameraLogo: UIView!
    @IBOutlet weak var viewAlbumLogo: UIView!
    @IBOutlet weak var instagramTxt: UITextField!
    @IBOutlet weak var facebookTxt: UITextField!

    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:38)
        if    Global.sharedInstance.defaults.integer(forKey: "ISFROMMENU") != 1 {

            let adresa: String = Global.sharedInstance.currentProvider.nvAddress
            let oras: String = Global.sharedInstance.currentProvider.nvCity
            if adresa.count == 0 || oras.count == 0 {
                lblCity.text = ""
            } else {
                lblCity.text = "ADDRESS_CITY".localized(LanguageMain.sharedInstance.USERLANGUAGE) + Global.sharedInstance.currentProvider.nvAddress + " / " + Global.sharedInstance.currentProvider.nvCity
            }
            if  instagramTxt.text == ""
            {
                instagramTxt.text = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvInstagramLink
            }
            if facebookTxt.text == ""
            {
                facebookTxt.text = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvFacebookLink
            }
            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
            {
                facebookTxt.textAlignment = .right
                instagramTxt.textAlignment = .right
            }
            else
            {
                facebookTxt.textAlignment = .left
                instagramTxt.textAlignment = .left
            }
            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
            {
                txtViewAbout.textAlignment = .right
            }
            else
            {
                txtViewAbout.textAlignment = .left
            }


            lblCity.numberOfLines = 0
            // Working hours
            //            let workingHours:objWorkingHours = objWorkingHours()
            //            var arrWorkingHours = workingHours.sortHoursArrayByDays(Global.sharedInstance.generalDetails.arrObjWorkingHours)
            //
            //            var DayFlagArr = [0,0,0,0,0,0,0]
            //            var hourShow = ""
            //
            //            for i in 0 ..< 7 {
            //                if arrWorkingHours[i].count != 0 {
            //                    if DayFlagArr[i] != 1 {
            //                        if arrWorkingHours[i].count == 2 {
            //                            if arrWorkingHours[i][0].nvFromHour != "" && !(arrWorkingHours[i][0].nvFromHour == "00:00:00" && arrWorkingHours[i][0].nvToHour == "00:00:00" && arrWorkingHours[i][1].nvFromHour == "00:00:00" && arrWorkingHours[i][1].nvToHour == "00:00:00") {
            //                                for j in 0 ..< 7 {
            //                                    if arrWorkingHours[j].count == 2 {
            //                                        if arrWorkingHours[i][0].nvFromHour == arrWorkingHours[j][0].nvFromHour && arrWorkingHours[i][0].nvToHour == arrWorkingHours[j][0].nvToHour && arrWorkingHours[i][1].nvFromHour == arrWorkingHours[j][1].nvFromHour && arrWorkingHours[i][1].nvToHour == arrWorkingHours[j][1].nvToHour {
            //                                            hourShow = "\(hourShow) \(convertDays(j)),"
            //                                            DayFlagArr[j] = 1
            //                                        }
            //                                    }
            //                                }
            //
            //                                hourShow = String(hourShow.dropLast())
            //                                hourShow = "\(hourShow) - "
            //
            //                                if arrWorkingHours[i].count != 0 {
            //                                    hourShow = "\(hourShow) \(cutHour(arrWorkingHours[i][0].nvFromHour))-\(cutHour(arrWorkingHours[i][0].nvToHour)), \(cutHour(arrWorkingHours[i][1].nvFromHour))-\(cutHour(arrWorkingHours[i][1].nvToHour)),\n"
            //                                }
            //                            }
            //                        } else if arrWorkingHours[i].count == 1 {
            //                            if arrWorkingHours[i][0].nvFromHour != "" && !(arrWorkingHours[i][0].nvFromHour == "00:00:00" && arrWorkingHours[i][0].nvToHour == "00:00:00") {
            //                                for j in 0 ..< 7 {
            //                                    if arrWorkingHours[j].count == 1 {
            //                                        if arrWorkingHours[i][0].nvFromHour == arrWorkingHours[j][0].nvFromHour && arrWorkingHours[i][0].nvToHour == arrWorkingHours[j][0].nvToHour {
            //                                            hourShow = "\(hourShow) \(convertDays(j)),"
            //                                            DayFlagArr[j] = 1
            //                                        }
            //                                    }
            //                                }
            //
            //                                hourShow = String(hourShow.dropLast())
            //                                hourShow = "\(hourShow) - "
            //
            //                                if arrWorkingHours[i].count != 0 {
            //                                    hourShow = "\(hourShow) \(cutHour(arrWorkingHours[i][0].nvFromHour))-\(cutHour(arrWorkingHours[i][0].nvToHour)),\n"
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //            }
            //
            //            hourShow = String(hourShow.dropLast())
            //            if hourShow.count > 1 {
            //                let last = hourShow.substring(from:hourShow.index(hourShow.endIndex, offsetBy: -1))
            //                if last == "," {
            //                    hourShow = String(hourShow.dropLast())
            //                }
            //            }
            print("/////////////////////////////")
            for i:objWorkingHours in Global.sharedInstance.generalDetails.arrObjWorkingHours
            {
                print(i.getDic())
            }
            print("/////////////////////////////")

            print("curreny day ius: \(String(describing: Calendar.sharedInstance.getDayOfWeek(Date())))")
            arrayDaysNames = [dayOneLabel,dayTwoLabel,dayThreeLabel,dayFourLabel,dayFiveLabel,daySixLabel,daySevenLabel]
            arrayHoursIntervals = [hoursOneLabel,hoursTwoLabel,hoursThreeLabel,hoursFourLabel,hoursFiveLabel,hoursSixLabel,hoursSevernLabel]
            var days:Array<String> = ["SUNDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"MONDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"TUESDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"WEDNSDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"THIRTHDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"FRIDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SHABAT_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)]


            var workingHoursDay:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            for i in 0...6
            {
                if let _ = Calendar.sharedInstance.getDayOfWeek(Date())
                {
                    var index:Int = Calendar.sharedInstance.getDayOfWeek(Date())! - 1 + i
                    if index > 6
                    {
                        index -= 7
                    }
                    arrayDaysNames[i].text = days[index]
                }
                arrayHoursIntervals[i].text = "CLOSED_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                if let _ = Calendar.sharedInstance.getDayOfWeek(Date())
                {
                    var realKey:Int = Calendar.sharedInstance.getDayOfWeek(Date())! + i
                    if realKey > 7
                    {
                        realKey -= 7
                    }
                    dictionaryIndexes[realKey] = i
                }
                print("dictionaryIndexes: \(dictionaryIndexes)")


            }

            for i in 0..<Global.sharedInstance.generalDetails.arrObjWorkingHours.count
            {
                print(Global.sharedInstance.generalDetails.arrObjWorkingHours[i].getDic())
                workingHoursDay = Global.sharedInstance.generalDetails.arrObjWorkingHours[i].getDic()
                if let _ = workingHoursDay["iDayInWeekType"] as? Int
                {
                    var indexWrkObj:Int = workingHoursDay["iDayInWeekType"] as! Int
                    if let _ = workingHoursDay["nvFromHour"] as? String
                    {
                        if let _ = workingHoursDay["nvToHour"] as? String
                        {
                            let fromHour = workingHoursDay["nvFromHour"] as! String
                            let toHour = workingHoursDay["nvToHour"] as! String
                            let endIndex = fromHour.index(fromHour.endIndex, offsetBy: -3)
                            let truncatedFromHour = fromHour.substring(to: endIndex)
                            let truncatedToHour = toHour.substring(to: endIndex)

                            let indexForHour = dictionaryIndexes[indexWrkObj]

                            if let _ = indexForHour
                            {
                                if arrayHoursIntervals[indexForHour!].text == "" || arrayHoursIntervals[indexForHour!].text == "CLOSED_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                {
                                    arrayHoursIntervals[indexForHour!].text = truncatedFromHour + "-" + truncatedToHour
                                }
                                else
                                {
                                    if let _ = arrayHoursIntervals[indexForHour!].text
                                    {
                                        let firstInterval:String = arrayHoursIntervals[indexForHour!].text as! String
                                        arrayHoursIntervals[indexForHour!].text = firstInterval + ", " + truncatedFromHour + "-" + truncatedToHour
                                    }

                                }

                            }

                        }

                    }
                }
            }
            if arrayHoursIntervals[0].text == "CLOSED_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                openOrClosedLabel.text = "CLOSED_TODAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            }
            else
            {
                openOrClosedLabel.text = "OPEN_TODAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            }

            //            txtViewHoursWork.text = "\(Global.sharedInstance.hourShow) \n" +  /*"RECESS".localized(LanguageMain.sharedInstance.USERLANGUAGE) + */ " \(Global.sharedInstance.hourShowRecess)"
        } else {
            self.generic.showNativeActivityIndicator(self)
        }
    }
    //on click X to close popUp of logo
    @IBAction func btnCloseViewLogo(_ sender: AnyObject) {
        viewLogo.isHidden = true

    }
    @IBAction func nearbyJ(_ sender: AnyObject) {
        print(" ATT")

    }

    @IBAction func btnback(_ sender: AnyObject) {
        //now clean isfromsettings
        self.generic.hideNativeActivityIndicator(self)


        if Global.sharedInstance.defaults.integer(forKey: "ISFROMMENU") == 1 {
            Global.sharedInstance.defaults.set(0, forKey: "ISFROMMENU")
            Global.sharedInstance.defaults.synchronize()

            var dicClientName:Dictionary<String,String> = Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") as! Dictionary<String,String>
            if dicClientName["nvSupplierName"] != "" {
                supplierStoryBoard2 = UIStoryboard(name: "SupplierExist", bundle: nil)
                storyBoard1Main = UIStoryboard(name: "Main", bundle: nil)
                Global.sharedInstance.isProvider = true
                let frontviewcontroller = storyBoard1Main!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                let rearViewController = storyBoard1Main!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                let mainRevealController = SWRevealViewController()
                mainRevealController.frontViewController = frontviewcontroller
                mainRevealController.rearViewController = rearViewController
                let CalendarSupplier: CalendarSupplierViewController = supplierStoryBoard2!.instantiateViewController(withIdentifier: "CalendarSupplierViewController")as! CalendarSupplierViewController
                let navigationController: UINavigationController = UINavigationController(rootViewController: CalendarSupplier)
                mainRevealController.pushFrontViewController(navigationController, animated: false)
                //                mainRevealController.revealToggle(animated: true)
                Global.sharedInstance.isFromprintCalender = false
                let window :UIWindow = UIApplication.shared.keyWindow!
                window.rootViewController = mainRevealController
                return
            }


        } else if Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 {
            Global.sharedInstance.defaults.set(0, forKey: "ISFROMSETTINGS")
            Global.sharedInstance.defaults.synchronize()
            self.view.isHidden = true
        }
    }

    //---- ViewToHide : viewSlogen ----
    //
    //    @IBOutlet weak var triangleSlogen: TriangeView!
    //    @IBOutlet weak var viewSlogen: UIView!
    //    @IBOutlet weak var btnCloseSlogen: UIButton!
    //
    //        //on click X to close popUp of slogen
    //    @IBAction func btnCloseSlogen(sender: AnyObject)
    //    {
    //        viewSlogen.hidden = true
    //        triangleSlogen.hidden = true
    //        dismissKeyboard()
    //        //show popUp of the business image
    //        selectPicture(imgPicture)
    //
    //    }
    ///@IBOutlet weak var lblTitleSlogen: UILabel!
    @IBOutlet weak var txtViewSlogen: UITextView!
    //  @IBOutlet weak var btnSaveSlogen: UIButton!

    //on click to save the slogen
    //    @IBAction func btnSaveSlogen(sender: AnyObject) {
    //        viewSlogen.hidden = true
    //        triangleSlogen.hidden = true
    //
    //        let arr:Array<String> = txtViewSlogen.text.componentsSeparatedByString("\n")
    //        if arr.count == 1
    //        {
    //           lblSlogenBuisness.text = txtViewSlogen.text
    //        }
    //        else
    //        {
    //            for row in arr {
    //                lblSlogenBuisness.text! += " " + (row)
    //            }
    //        }
    //        Global.sharedInstance.addProviderBuisnessProfile.nvSlogen = lblSlogenBuisness.text!
    //
    //        dismissKeyboard()
    //        //show popUp of the business image
    //        selectPicture(imgPicture)
    //    }

    //------ ViewToHide : forViewLightBlue 3 ----

    @IBOutlet weak var viewAddPictureToView3: UIView!
    @IBOutlet weak var lblTakePicture3: UILabel!
    @IBOutlet weak var lblPicture: UILabel!
    @IBOutlet weak var lblAddPicture: UILabel!

    //on click X to close popUp of business image
    @IBAction func btnCloseView(_ sender: AnyObject) {

        //      self.scrollView.setContentOffset(CGPointMake(0, -self.scrollView.contentInset.top), animated: false)
        viewAddPictureToView3.isHidden = true
        let aRectangle:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.scrollView.scrollRectToVisible(aRectangle, animated: true)

        //show popUp of about the business
        //   selectAbout(imgPicture)
    }

    @IBOutlet weak var imgAddFromAlbom: UIImageView!
    @IBOutlet weak var imgAddFromCamera_for3: UIImageView!
    @IBOutlet weak var viewAlbum3: UIView!
    @IBOutlet weak var viewCamera3: UIView!

    //------------------------------------------

    //------ ViewToHide : for about ----

    @IBOutlet weak var btnCloseAbout: UIButton!


    // @IBOutlet weak var viewHideAbout: UIView!

    //   @IBOutlet weak var lblTitleAbout: UILabel!
    // to write the text - pop up
    @IBOutlet weak var textViewAbout: UITextView!

    //  @IBOutlet weak var btnSave: UIButton!
    func hidetoast(){
        view.hideToastActivity()
    }

    //    func btnSave() {
    //
    //        txtViewAbout.text = textViewAbout.text
    //
    //        let numRows = txtViewAbout.text.components(separatedBy: "\n").count
    //        var arrSpaces:Array<String> = []
    //
    //        if numRows >= 2
    //        {
    //            let aboutArr = txtViewAbout.text.components(separatedBy: "\n")
    //
    //            if aboutArr[0].characters.count > 53
    //            {
    //                if aboutArr[0].characters.count > 104
    //                {
    //                    let index = aboutArr[0].characters.index(aboutArr[0].startIndex, offsetBy: 104)
    //                    txtViewAbout.text = aboutArr[0].substring(to: index)
    //
    //                    arrSpaces = txtViewAbout.text.components(separatedBy: " ")
    //
    //                    if textViewAbout.text.characters[textViewAbout.text.index(textViewAbout.text.startIndex, offsetBy: 104)] != " " && txtViewAbout.text.characters.last != " "
    //                    {
    //                        txtViewAbout.text = ""
    //                        for item in arrSpaces
    //                        {
    //                            if item != arrSpaces.last
    //                            {
    //                                txtViewAbout.text! += (item + " ")
    //                            }
    //                            else
    //                            {
    //                                txtViewAbout.text.substring(to: txtViewAbout.text.index(before: txtViewAbout.text.endIndex))
    //                            }
    //                        }
    //                    }
    //
    //
    //
    //                }
    //                else
    //                {
    //                    txtViewAbout.text = aboutArr[0]
    //
    //                }
    //            }
    //            else if aboutArr[1].characters.count > 53
    //            {
    //                let index = aboutArr[1].characters.index(aboutArr[1].startIndex, offsetBy: 53)
    //                txtViewAbout.text = aboutArr[0] + "\n" + aboutArr[1].substring(to: index)
    //
    //                arrSpaces = txtViewAbout.text.components(separatedBy: " ")
    //
    //                if aboutArr[1].characters[aboutArr[1].characters.index(aboutArr[1].startIndex, offsetBy: 53)] != " " && txtViewAbout.text.characters.last != " "
    //                {
    //                    txtViewAbout.text = ""
    //                    for item in arrSpaces
    //                    {
    //                        if item != arrSpaces.last
    //                        {
    //                            txtViewAbout.text! += (item + " ")
    //                        }
    //                        else
    //                        {
    //                            txtViewAbout.text.substring(to: txtViewAbout.text.index(before: txtViewAbout.text.endIndex))
    //                        }
    //                    }
    //                }
    //
    //
    //            }
    //            else if numRows > 2
    //            {
    //                txtViewAbout.text = aboutArr[0] + "\n" + aboutArr[1]
    //
    //            }
    //        }
    //
    //        else if txtViewAbout.text.characters.count > 104
    //        {
    //            let index = txtViewAbout.text.index(txtViewAbout.text.startIndex, offsetBy: 104)
    //            txtViewAbout.text = (txtViewAbout.text.substring(to: index))
    //
    //            arrSpaces = txtViewAbout.text.components(separatedBy: " ")
    //
    //            if textViewAbout.text.characters[textViewAbout.text.index(textViewAbout.text.startIndex, offsetBy: 104)] != " " && txtViewAbout.text.characters.last != " "
    //            {
    //                txtViewAbout.text = ""
    //                for item in arrSpaces
    //                {
    //                    if item != arrSpaces.last
    //                    {
    //                        txtViewAbout.text! += (item + " ")
    //                    }
    //                    else
    //                    {
    //                        print("txt endIndex: \(txtViewAbout.text.endIndex)")
    //                        txtViewAbout.text.substring(to: txtViewAbout.text.index(before: txtViewAbout.text.endIndex))
    //                    }
    //                }
    //            }
    //
    //        }
    //        else
    //        {
    //
    //        }
    //        Global.sharedInstance.addProviderBusinessProfile.nvAboutComment = txtViewAbout.text
    //
    //    }


    //------------------------------------------

    //-----viewHide Campaign--------

    @IBOutlet weak var viewCampaign: UIView!

    @IBOutlet weak var lblTakePictureCamp: UILabel!

    @IBOutlet weak var lblTitleCampaign: UILabel!

    @IBOutlet weak var lblAddFromAlbumToCamp: UILabel!

    //on click X to close popUp of sale image
    @IBAction func btnClose(_ sender: AnyObject) {

        //        let topOffset1: CGPoint = CGPointMake(0, scrollCampain + 0.085 * scrollView.contentSize.height)
        //        self.scrollView.setContentOffset(topOffset1, animated: false)
        let aRectangle:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.scrollView.scrollRectToVisible(aRectangle, animated: true)
        viewCampaign.isHidden = true
        //show popUp of bottom image
        // selectBottom(imgPicture)
    }
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var viewCameraCampain: UIView!
    @IBOutlet weak var viewAlbumCampain: UIView!


    //------------------------------------------

    //-----viewHide Bottom--------

    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lblTakePictureBottom: UILabel!
    @IBOutlet weak var lblFromAlbumToOttom: UILabel!
    @IBOutlet weak var lblTitlePicture: UILabel!

    var arrayDaysNames:Array<UILabel> = Array<UILabel>()
    var arrayHoursIntervals:Array<UILabel> = Array<UILabel>()
    var dictionaryIndexes:Dictionary<Int,Int> = Dictionary<Int,Int>()
    //on click X to close popUp of bottom image

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandHoursBtn: UIButton!




    //MARK - Properties
    var locationManager = CLLocationManager()
    var key = ""

    //MARK: - Initial
    //===========Initial==============

    override func viewDidLoad()
    {
        super.viewDidLoad()

        heightConstraint.constant = 40
        openOrClosedLabel.isHidden = false
        geseata.isHidden = false
        expandHoursBtn.tag = 0
        facebookTxt.layer.borderWidth = 0.05
        instagramTxt.layer.borderWidth = 0.05

        //        let workingHours:objWorkingHours = objWorkingHours()
        //        var arrWorkingHours = workingHours.sortHoursArrayByDays(Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours)

        print("/////////////////////////////")
        for i:objWorkingHours in Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours
        {
            print(i.getDic())
        }
        print("/////////////////////////////")
        hoursLabel.text = "HHOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        linkToFacebookLabel.text = "LINK_TO_FACEBOOK".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        linkToInstagramLabel.text = "LINK_TO_INSTAGRAM".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        print("curreny day ius: \(String(describing: Calendar.sharedInstance.getDayOfWeek(Date())))")
        arrayDaysNames = [dayOneLabel,dayTwoLabel,dayThreeLabel,dayFourLabel,dayFiveLabel,daySixLabel,daySevenLabel]
        arrayHoursIntervals = [hoursOneLabel,hoursTwoLabel,hoursThreeLabel,hoursFourLabel,hoursFiveLabel,hoursSixLabel,hoursSevernLabel]
        var days:Array<String> = ["SUNDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"MONDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"TUESDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"WEDNSDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"THIRTHDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"FRIDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SHABAT_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)]


        var workingHoursDay:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        for i in 0...6
        {
            if let _ = Calendar.sharedInstance.getDayOfWeek(Date())
            {
                var index:Int = Calendar.sharedInstance.getDayOfWeek(Date())! - 1 + i
                if index > 6
                {
                    index -= 7
                }
                arrayDaysNames[i].text = days[index]
            }
            arrayHoursIntervals[i].text = "CLOSED_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            if let _ = Calendar.sharedInstance.getDayOfWeek(Date())
            {
                var realKey:Int = Calendar.sharedInstance.getDayOfWeek(Date())! + i
                if realKey > 7
                {
                    realKey -= 7
                }
                dictionaryIndexes[realKey] = i
            }
            print("dictionaryIndexes: \(dictionaryIndexes)")


        }



        for i in 0..<Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours.count
        {
            workingHoursDay = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours[i].getDic()
            if let _ = workingHoursDay["iDayInWeekType"] as? Int
            {
                var indexWrkObj:Int = workingHoursDay["iDayInWeekType"] as! Int
                if let _ = workingHoursDay["nvFromHour"] as? String
                {
                    if let _ = workingHoursDay["nvToHour"] as? String
                    {
                        let fromHour = workingHoursDay["nvFromHour"] as! String
                        let toHour = workingHoursDay["nvToHour"] as! String
                        let endIndex = fromHour.index(fromHour.endIndex, offsetBy: -3)
                        let truncatedFromHour = fromHour.substring(to: endIndex)
                        let truncatedToHour = toHour.substring(to: endIndex)

                        let indexForHour = dictionaryIndexes[indexWrkObj]

                        if let _ = indexForHour
                        {
                            if arrayHoursIntervals[indexForHour!].text == "" || arrayHoursIntervals[indexForHour!].text == "CLOSED_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                            {
                                arrayHoursIntervals[indexForHour!].text = truncatedFromHour + "-" + truncatedToHour
                            }
                            else
                            {
                                if let _ = arrayHoursIntervals[indexForHour!].text
                                {
                                    let firstInterval:String = arrayHoursIntervals[indexForHour!].text as! String
                                    if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
                                    {
                                        arrayHoursIntervals[indexForHour!].text =  truncatedFromHour + "-" + truncatedToHour + " ," + firstInterval
                                    }
                                    else
                                    {
                                        arrayHoursIntervals[indexForHour!].text = firstInterval + ", " + truncatedFromHour + "-" + truncatedToHour
                                    }
                                }

                            }

                        }

                    }

                }
            }
        }
        if arrayHoursIntervals[0].text == "CLOSED_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            openOrClosedLabel.text = "CLOSED_TODAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        else
        {
            openOrClosedLabel.text = "OPEN_TODAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }


        //        viewAbout_4.addBackground()
        //        viewNEWWorkingHoursandAddress.addBackground()

        pageTitleLabel.text = "POP_UP_BUSINESS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        //        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
        //        viewPopUpRegisterBusiness = storyboardtest.instantiateViewController(withIdentifier: "popUpBusinessProfile") as! popUpBusinessProfile
        //        self.present(viewPopUpRegisterBusiness, animated: true, completion: nil)
        btnSaveDoi.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent

        // Hide save button if is on register
        if (Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 ||   Global.sharedInstance.defaults.integer(forKey: "ISFROMMENU") == 1)
        {
            viewBOTTOMSAVE.isHidden = false
        } else {
            //            let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
            //            viewPopUpRegisterBusiness = storyboardtest.instantiateViewController(withIdentifier: "popUpBusinessProfile") as! popUpBusinessProfile
            //            self.parent?.present(viewPopUpRegisterBusiness, animated: true, completion: nil)
            viewBOTTOMSAVE.isHidden = true
        }

        viewBOTTOMSAVE.isHidden = true
        viewBOTTOMSAVE.isUserInteractionEnabled = false
        key="AIzaSyBGjEDOd6MtNtfTv76CzIp_WyMxzvj_KJg"
        txtViewAbout.isEditable = false
        txtViewAbout.isHidden = true

        //        imgLogo.autoresizingMask = [ UIViewAutoresizing.FlexibleBottomMargin ,UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleRightMargin , UIViewAutoresizing.FlexibleLeftMargin , UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleWidth]
        //
        //         imgLightBlue3.autoresizingMask = [ UIViewAutoresizing.FlexibleBottomMargin ,UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleRightMargin , UIViewAutoresizing.FlexibleLeftMargin , UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleWidth]
        //        imgLightBlue5.autoresizingMask = [ UIViewAutoresizing.FlexibleBottomMargin ,UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleRightMargin , UIViewAutoresizing.FlexibleLeftMargin , UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleWidth]
        imgLogo.contentMode = .scaleAspectFit
        imgLightBlue3.contentMode = .scaleAspectFill
        imgLightBlue5.contentMode = .scaleAspectFill
        imgLogo.clipsToBounds = true
        imgLightBlue3.clipsToBounds = true
        imgLightBlue5.clipsToBounds = true
        uploadcompanylogo.text = "UPLOAD_COMPANY_LOGO".localized(LanguageMain.sharedInstance.USERLANGUAGE) //UPLOAD_COMPANY_LOGO
        uploadcompanylogo.numberOfLines = 2
        lblNmeBuisness.text = Global.sharedInstance.currentProvider.nvSupplierName
        lblNmeBuisness.numberOfLines = 2
        lblSlogenBuisness.delegate = self
        lblSlogenBuisness.text = ""
        instagramTxt.delegate = self
        facebookTxt.delegate = self
        instagramTxt.text = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvInstagramLink
        facebookTxt.text = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvFacebookLink
        let Name  = "COMPANY_SLOGAN".localized(LanguageMain.sharedInstance.USERLANGUAGE) // PlaceHolderText
        lblSlogenBuisness.placeholder = Name

        //\\print ("business name " + Name)
        uploadcompanyprofilePhoto.text = "UPLOAD_COMPANY_PROFILE_PHOTO".localized(LanguageMain.sharedInstance.USERLANGUAGE)  //UPLOAD_COMPANY_PROFILE_PHOTO

        //   txtViewSlogen.delegate = self

        // imgLightBlue3.image = UIImage(named: "IMG_05072016_131013.png")
        txtViewAbout.delegate = self
        txtViewAbout.isHidden = true
        textViewAbout.delegate = self
        textViewAbout.layer.cornerRadius = 5.0


        takelogo.contentMode = .scaleAspectFit
        imgLightBlue3.clipsToBounds = true
        imgLightBlue5.clipsToBounds = true

        rateourBussines.layer.cornerRadius = 5
        rateourBussines.layer.borderWidth = 1
        rateourBussines.layer.borderColor = UIColor.black.cgColor
        viewLogo.layer.cornerRadius = 5
        viewLogo.layer.masksToBounds = true
        viewLogo.layer.borderColor = UIColor.black.cgColor
        viewLogo.layer.borderWidth = 0.5
        viewAddPictureToView3.layer.cornerRadius = 5
        viewAddPictureToView3.layer.masksToBounds = true
        viewAddPictureToView3.layer.borderColor = UIColor.black.cgColor
        viewAddPictureToView3.layer.borderWidth = 0.5
        viewCampaign.layer.cornerRadius = 5
        viewCampaign.layer.masksToBounds = true
        viewCampaign.layer.borderColor = UIColor.black.cgColor
        viewCampaign.layer.borderWidth = 0.5

        viewLogo.isHidden = true
        viewAddPictureToView3.isHidden = true
        viewCampaign.isHidden = true
        //set all the text's of the labels by Localizable
        lblLogo.text = "LOGO".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblAbout.text = "ABOUT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ////  lblHoursWork.text = "HOURS_WORK".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblTitleCampaign.text = "CAMPAIGN".localized(LanguageMain.sharedInstance.USERLANGUAGE)

        lblUploadCampaign.text = "UPLOAD_CAMPAIGN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblTakePicture3.text = "TAKE_PICTURE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblPicture.text = "TAKE_PICTURE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblAddPicture.text = "ATTACH_PHOTO".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblCameraLogo.text = "TAKE_PICTURE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblAddFromAlbum.text = "ATTACH_PHOTO".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblTakePictureCamp.text = "TAKE_PICTURE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblAddFromAlbumToCamp.text = "ATTACH_PHOTO".localized(LanguageMain.sharedInstance.USERLANGUAGE)

        lblUploadCampaign.sizeToFit()
        lblTakePicture3.sizeToFit()
        lblTakePicture3.sizeToFit()
        lblPicture.sizeToFit()
        lblAddPicture.sizeToFit()
        lblCameraLogo.sizeToFit()
        lblAddFromAlbum.sizeToFit()
        lblTakePictureCamp.sizeToFit()
        lblAddFromAlbumToCamp.sizeToFit()
        self.btnBack.isHidden = true
        tapOnViews()

        //show a map:
        //    viewMap.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        takelogo.image =  UIImage(named: "cameraiconJ.png")
        takeprofile.image  =  UIImage(named: "cameraiconJ.png")
        takesale.image  =  UIImage(named: "cameraiconJ.png")

        if Global.sharedInstance.defaults.integer(forKey: "ISFROMMENU") == 0 &&  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 {
            topSCREEN.constant = 40
        }

        if Global.sharedInstance.defaults.integer(forKey: "ISFROMMENU") == 1  {

            topSCREEN.constant = 64
            //need this in order to proper open camera
            Global.sharedInstance.defaults.set(1, forKey: "ISFROMSETTINGS")
            Global.sharedInstance.defaults.synchronize()

        }

        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 ||   Global.sharedInstance.defaults.integer(forKey: "ISFROMMENU") == 1 {

            if (Global.sharedInstance.defaults.integer(forKey: "ISFROMMENU") == 1) {
                topSCREEN.constant = 64
            } else {
                topSCREEN.constant = 0
            }

            // self.btnBack.hidden = false
            let leftarrowback = UIImage(named: "sageata2.png")

            self.btnBack.setImage(leftarrowback, for: UIControl.State())
            var scalingTransform : CGAffineTransform!
            scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                self.btnBack.transform = scalingTransform
            }
            btnBack.imageView!.contentMode = .scaleAspectFit
            //\\self.btnSaveDoi.hidden = false
            self.btnBack.isUserInteractionEnabled = true
            //\\    self.btnSaveDoi.userInteractionEnabled = true
            //            self.navigationController?.setNavigationBarHidden(true, animated: true)
     //       self.navigationController?.setNavigationBarHidden(false, animated: false)
            // self.title = "Bussines Profile"
            //\\    topSCREEN.constant = 40



            //            //\\print ("1 x -> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName)")
            //            //\\print ("2x-> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress)")
            //            //\\print ("3x -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen)")
            //            //\\print ("4x -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage)")
            /*
             /*
             @nvSlogen nvarchar(1000) √
             ,@nvILogoImagePath nvarchar(150) √
             ,@nvAboutComment nvarchar(250) √
             ,@nvHeaderImagePath nvarchar(150) √
             ,@nvFooterImagePath nvarchar (150)
             ,@nvCampaignImagePath nvarchar(150) √
             ,@iProviderId int √
             */
             */
            ///1. LOGO
            if Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage != "" && Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage != "<null>"{
                //and also add to general  Global.sharedInstance.addProviderBuisnessProfile even in case no data is changed we need this on SAVE 1 √
                Global.sharedInstance.addProviderBusinessProfile.nvILogoImage = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage //
                let dataDecoded:Data = Data(base64Encoded: (
                    Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
                var decodedimage:UIImage = UIImage()
                if UIImage(data: dataDecoded) != nil
                {
                    decodedimage = UIImage(data: dataDecoded)!
                    //                    UIGraphicsBeginImageContext(takelogo.frame.size)
                    //                decodedimage.drawInRect(takelogo.bounds)
                    //                let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                    //                UIGraphicsEndImageContext()
                    //\\ takelogo.image = image
                    imgLogo.image = decodedimage


                }
            }
            // 2. PROFILE - HEADER IMAGE
            if Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvHeaderImage != "" && Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvHeaderImage != "<null>"{
                //and also add to general  Global.sharedInstance.addProviderBuisnessProfile even in case no data is changed we need this on SAVE 2 √
                Global.sharedInstance.addProviderBusinessProfile.nvHeaderImage = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvHeaderImage
                let dataDecoded:Data = Data(base64Encoded: (
                    Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvHeaderImage), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!

                var decodedimage:UIImage = UIImage()
                if UIImage(data: dataDecoded) != nil
                {
                    decodedimage = UIImage(data: dataDecoded)!
                    //                    UIGraphicsBeginImageContext(view_lightBlue_3.frame.size)
                    //                    decodedimage.drawInRect(view_lightBlue_3.bounds)
                    //                    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                    //                    UIGraphicsEndImageContext()
                    //\\takeprofile.image = image
                    imgLightBlue3.contentMode = .scaleAspectFill
                    imgLightBlue3.image = decodedimage

                }
            }

            //            else
            //            {
            //
            //            }

            //3. CAMPAIGN
            if Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvCampaignImage != "" && Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvCampaignImage != "<null>"{
                //and also add to general  Global.sharedInstance.addProviderBuisnessProfile even in case no data is changed we need this on SAVE 3 √
                Global.sharedInstance.addProviderBusinessProfile.nvCampaignImage = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvCampaignImage
                let dataDecoded:Data = Data(base64Encoded: (
                    Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvCampaignImage), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
                var decodedimage:UIImage = UIImage()
                if UIImage(data: dataDecoded) != nil
                {
                    decodedimage = UIImage(data: dataDecoded)!
                    //                    UIGraphicsBeginImageContext(view_lightBlue_5.frame.size)
                    //                    decodedimage.drawInRect(view_lightBlue_5.bounds)
                    //                    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                    //                    UIGraphicsEndImageContext()
                    //\\ takesale.image  = image
                    imgLightBlue5.contentMode = .scaleAspectFill
                    imgLightBlue5.image = decodedimage
                }
            }
            //4. SLOGAN
            if Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen != "" && Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen != "<null>"{
                //and also add to general  Global.sharedInstance.addProviderBuisnessProfile even in case no data is changed we need this on SAVE 4 √
                Global.sharedInstance.addProviderBusinessProfile.nvSlogen = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen
                lblSlogenBuisness.text = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen
            }
            //5. COMPANY NAME
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName  != "" && Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName != "<null>"{
                lblNmeBuisness.text = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName
            }
            //6. ABOUT COMPANY
            //nvAboutComment
            if Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvAboutComment  != ""
                && Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvAboutComment != "<null>"{

                textViewAbout.textColor = .black
                textViewAbout.text = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvAboutComment

                //and also add to general  Global.sharedInstance.addProviderBuisnessProfile even in case no data is changed we need this on SAVE 5 √
                Global.sharedInstance.addProviderBusinessProfile.nvAboutComment = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvAboutComment
                //textViewAbout.text = "alfa test"
            }
            else
            {
                textViewAbout.textColor = .gray
                textViewAbout.text = "COMPANY_DESCRIPTION_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            }

            //            let workingHours:objWorkingHours = objWorkingHours()
            //            var arrWorkingHours = workingHours.sortHoursArrayByDays(Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours)
            //
            //            print("/////////////////////////////")
            //            for i:objWorkingHours in Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours
            //            {
            //                print(i.getDic())
            //            }
            //            print("/////////////////////////////")
            //            var DayFlagArr = [0,0,0,0,0,0,0]
            //            var hourShow = ""
            //
            //            for i in 0 ..< 7 {
            //                if arrWorkingHours[i].count != 0 {
            //                    if DayFlagArr[i] != 1 {
            //                        if arrWorkingHours[i].count == 2 {
            //                            if arrWorkingHours[i][0].nvFromHour != "" && !(arrWorkingHours[i][0].nvFromHour == "00:00:00" && arrWorkingHours[i][0].nvToHour == "00:00:00" && arrWorkingHours[i][1].nvFromHour == "00:00:00" && arrWorkingHours[i][1].nvToHour == "00:00:00") {
            //                                for j in 0 ..< 7 {
            //                                    if arrWorkingHours[j].count == 2 {
            //                                        if arrWorkingHours[i][0].nvFromHour == arrWorkingHours[j][0].nvFromHour && arrWorkingHours[i][0].nvToHour == arrWorkingHours[j][0].nvToHour && arrWorkingHours[i][1].nvFromHour == arrWorkingHours[j][1].nvFromHour && arrWorkingHours[i][1].nvToHour == arrWorkingHours[j][1].nvToHour {
            //                                            hourShow = "\(hourShow) \(convertDays(j)),"
            //                                            DayFlagArr[j] = 1
            //                                        }
            //                                    }
            //                                }
            //
            //                                hourShow = String(hourShow.dropLast())
            //                                hourShow = "\(hourShow) - "
            //
            //                                if arrWorkingHours[i].count != 0 {
            //                                    hourShow = "\(hourShow) \(cutHour(arrWorkingHours[i][0].nvFromHour))-\(cutHour(arrWorkingHours[i][0].nvToHour)), \(cutHour(arrWorkingHours[i][1].nvFromHour))-\(cutHour(arrWorkingHours[i][1].nvToHour)),\n"
            //                                }
            //                            }
            //                        } else if arrWorkingHours[i].count == 1 {
            //                            if arrWorkingHours[i][0].nvFromHour != "" && !(arrWorkingHours[i][0].nvFromHour == "00:00:00" && arrWorkingHours[i][0].nvToHour == "00:00:00") {
            //                                for j in 0 ..< 7 {
            //                                    if arrWorkingHours[j].count == 1 {
            //                                        if arrWorkingHours[i][0].nvFromHour == arrWorkingHours[j][0].nvFromHour && arrWorkingHours[i][0].nvToHour == arrWorkingHours[j][0].nvToHour {
            //                                            hourShow = "\(hourShow) \(convertDays(j)),"
            //                                            DayFlagArr[j] = 1
            //                                        }
            //                                    }
            //                                }
            //
            //                                hourShow = String(hourShow.dropLast())
            //                                hourShow = "\(hourShow) - "
            //
            //                                if arrWorkingHours[i].count != 0 {
            //                                    hourShow = "\(hourShow) \(cutHour(arrWorkingHours[i][0].nvFromHour))-\(cutHour(arrWorkingHours[i][0].nvToHour)),\n"
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //            }
            //
            //            hourShow = String(hourShow.dropLast())
            //            if hourShow.count > 1 {
            //                let last = hourShow.substring(from:hourShow.index(hourShow.endIndex, offsetBy: -1))
            //                if last == "," {
            //                    hourShow = String(hourShow.dropLast())
            //                }
            //            }
            //            txtViewHoursWork.text = hourShow
            //8. ADDRESS  CITY
            var adresa: String = ""
            var city:String = ""
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvCity != "" && Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvCity != "<null>"{
                city = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvCity
            }
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress != "" && Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress != "<null>"{
                adresa = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress
            }
            print("city \(city) and adress \(adresa)")
            if adresa.count > 0 {
                if city.count > 0 {
                    lblCity.text = "ADDRESS_CITY".localized(LanguageMain.sharedInstance.USERLANGUAGE) + adresa + " / " + city
                } else {
                    lblCity.text = "ADDRESS_CITY".localized(LanguageMain.sharedInstance.USERLANGUAGE) + adresa
                }
            }

            lblCity.numberOfLines = 0
            viewBOTTOMSAVE.isHidden = false
            viewBOTTOMSAVE.isUserInteractionEnabled = true

            //            objProviderProfile
            instagramTxt.text = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvInstagramLink
            facebookTxt.text = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvFacebookLink


        }
        else {
            topSCREEN.constant = 0
       //     self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.btnBack.isHidden = true
            self.btnBack.isUserInteractionEnabled = false
            self.viewBOTTOMSAVE.isHidden = true

        }


        removePictureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterBuisnessProphielViewController.removeProfilePicture(_:)))
        removePicView.addGestureRecognizer(removePictureRecognizer)
        removePicView.isUserInteractionEnabled = true

        //working
        removeCompanyPictureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterBuisnessProphielViewController.removeCompanyPicture(_:)))
        CompanyViewRemovePic.addGestureRecognizer(removeCompanyPictureRecognizer)
        CompanyViewRemovePic.isUserInteractionEnabled = true


        removeSaleRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterBuisnessProphielViewController.removeSalePicture(_:)))
        removeSaleView.addGestureRecognizer(removeSaleRecognizer)
        removeSaleView.isUserInteractionEnabled = true


        lblRemovePic.text = "REMOVE_LOGO_BUSINESS_PROFILE".localized(LanguageMain.sharedInstance.USERLANGUAGE)

        removeCompanyLabel.text = "REMOVE_COMPANY_PIC".localized(LanguageMain.sharedInstance.USERLANGUAGE)

        removeSaleLabel.text = "REMOVE_COMPANY_PIC".localized(LanguageMain.sharedInstance.USERLANGUAGE)

        pageTitleLabel.isHidden = true
    }

    override var prefersStatusBarHidden : Bool {
        return false
    }

    @IBAction func toExpandOrNotToExpand(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            heightConstraint.constant = 190
            openOrClosedLabel.isHidden = true
            geseata.isHidden = true
            sender.tag = 1
        }
        else if sender.tag == 1
        {
            heightConstraint.constant = 40
            openOrClosedLabel.isHidden = false
            geseata.isHidden = false
            sender.tag = 0
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent

        self.generic.hideNativeActivityIndicator(self)

        //fb buttons
        //  next time to      let FBlikeButton:FBSDKLikeControl = FBSDKLikeControl()
        //        let FBshareButton:FBSDKShareButton = FBSDKShareButton()
        //
        //        FBlikeButton.objectID = "https://www.facebook.com/FacebookDevelopers"
        //        FBlikeButton.likeControlHorizontalAlignment = .Left
        //        FBlikeButton.frame = CGRectMake(66, 20, 90, 40)
        //        FBshareButton.frame = CGRectMake(170,20, 90, 40)
        //        viewNEWWorkingHoursandAddress.addSubview(FBlikeButton)
        //        viewNEWWorkingHoursandAddress.addSubview(FBshareButton)

        //JMODE
        //        if flagFirst == false
        //        {
        //            flagFirst = true
        //            selectLogo(imgLogo)
        //        }

        //  viewMap.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()


        //        if lblNmeBuisness.text?.characters.count > 24
        //        {
        //            if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        //            {
        //                lblNmeBuisness.font = UIFont(name: "OpenSansHebrew-Bold", size: 13)
        //            }
        //            else
        //            {
        //                lblNmeBuisness.font = UIFont(name: "OpenSansHebrew-Bold", size: 14)
        //            }
        //        }

        //----------------

        //JMODE -


        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            lblCity.font = UIFont(name: "OpenSansHebrew-Regular", size: 17)
            lblUploadCampaign.font = UIFont(name: "OpenSansHebrew-Bold", size: 19)
            lblAbout.font = UIFont(name: "OpenSansHebrew-Bold", size: 19)
            lblTakePicture3.font = UIFont(name: "OpenSansHebrew-Regular", size: 15)
            lblCameraLogo.font = UIFont(name: "OpenSansHebrew-Regular", size: 15)
            lblTakePictureCamp.font = UIFont(name: "OpenSansHebrew-Regular", size: 15)
            lblAddPicture.font = UIFont(name: "OpenSansHebrew-Regular", size: 15)
            lblAddFromAlbum.font = UIFont(name: "OpenSansHebrew-Regular", size: 15)
            lblAddFromAlbumToCamp.font = UIFont(name: "OpenSansHebrew-Regular", size: 15)

        }


    }

    //commit comment
    //iustin
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if textView.text == "COMPANY_DESCRIPTION_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            textView.text = ""
            textView.textColor = .black

        }
        return true

    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        if textView.text.count == 0
        {
            textView.textColor = .gray
            textView.text = "COMPANY_DESCRIPTION_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)

        }
        return true
    }

    override func viewDidLayoutSubviews() {

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent


        let neededFrame = CGRect(x: 0,y: 0,width: scrollView.frame.size.width,height: scrollView.contentSize.height)
        self.viewNEWTOP.frame = neededFrame
        print("viewNEWTOP -> \(viewNEWTOP.frame.size.height) scrollView -> \(scrollView.contentSize.height)")
        scrollView.isScrollEnabled = true
    }

    //MARK: - textField
    func textFieldDidBeginEditing(_ textField: UITextField) {


        if textField == lblSlogenBuisness
        {
            print("hereee")
        }
        if (textField == facebookTxt || textField == instagramTxt ) && textField.textColor == .red
        {
            textField.textColor = .black
            textField.text = ""

        }

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == lblSlogenBuisness
        {
            if lblSlogenBuisness.text?.characters.count > 120
            {
                Alert.sharedInstance.showAlert("ENTER_ONLY120_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)

            } else {
                Global.sharedInstance.addProviderBusinessProfile.nvSlogen = lblSlogenBuisness.text!
                //                dismissKeyboard()
            }
            let screenSize: CGRect = UIScreen.main.bounds
            let screenHeight = screenSize.height
            //            if UIDevice.current.userInterfaceIdiom == .pad {
            //                scrollView.contentSize.height = screenHeight
            //            } else {
            //                scrollView.contentSize.height = screenHeight * 1.35
            //            }
        }
        if textField == facebookTxt && textField.text != ""
        {

            validateFacebookLink(textField: facebookTxt)
        }
        if textField == instagramTxt && textField.text != ""
        {

            validateInstagramLink(textField: instagramTxt)
        }

    }

    func validateInstagramLink(textField:UITextField)
    {
        if textField.text?.contains("https://www.instagram.com") == true || textField.text?.contains("https://instagram.com") == true || textField.text?.contains("www.instagram.com") == true || textField.text?.contains("instagram.com") == true || textField.text?.contains("http://www.instagram.com") == true || textField.text?.contains("http://instagram.com")  == true
        {
            //good
            if let _ = textField.text
            {
                let first3 = textField.text!.substring(to:textField.text!.index(textField.text!.startIndex, offsetBy: 3))
                if first3 == "www"
                {
                    Global.sharedInstance.addProviderBusinessProfile.nvInstagramLink = "https://" + textField.text!
                }
                else if first3 == "ins"
                {
                    Global.sharedInstance.addProviderBusinessProfile.nvInstagramLink = "https://www." + textField.text!
                }
                else
                {
                    Global.sharedInstance.addProviderBusinessProfile.nvInstagramLink = textField.text!
                }
            }
        }
        else if textField.text == ""
        {
            Global.sharedInstance.addProviderBusinessProfile.nvInstagramLink = ""
        }
        else
        {
            textField.textColor = .red
            textField.text = "INSTA_FACEBOOK_INVALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            Global.sharedInstance.addProviderBusinessProfile.nvInstagramLink = ""

        }
    }

    func validateFacebookLink(textField:UITextField)
    {
        if textField.text?.contains("https://www.facebook.com") == true || textField.text?.contains("https://facebook.com") == true || textField.text?.contains("www.facebook.com") == true || textField.text?.contains("facebook.com") == true || textField.text?.contains("http://www.facebook.com") == true || textField.text?.contains("http://facebook.com") == true
        {
            //good
            let first3 = textField.text!.substring(to:textField.text!.index(textField.text!.startIndex, offsetBy: 3))
            if first3 == "www"
            {
                Global.sharedInstance.addProviderBusinessProfile.nvFacebookLink = "https://" + textField.text!
            }
            else if first3 == "fac"
            {
                Global.sharedInstance.addProviderBusinessProfile.nvFacebookLink = "https://www." + textField.text!
            }
            else
            {
                Global.sharedInstance.addProviderBusinessProfile.nvFacebookLink = textField.text!
            }

        }
        else if textField.text == ""
        {
            Global.sharedInstance.addProviderBusinessProfile.nvFacebookLink = ""
        }

        else
        {
            textField.textColor = .red
            textField.text = "INSTA_FACEBOOK_INVALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            Global.sharedInstance.addProviderBusinessProfile.nvFacebookLink = ""

        }
    }
    //MARK: - textView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var startString = ""
        if (textView.text != nil)
        {
            startString += textView.text!
        }
        startString += text

        //enable to enter only 120 characters in slogen
        //        if textView == txtViewSlogen
        //        {
        //            if startString.characters.count > 120
        //            {
        //                Alert.sharedInstance.showAlert("ENTER_ONLY120_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        //                return false
        //            }
        //            return true
        //       }
        return true
    }

    func textViewDidChange(_ textView: UITextView)
    { //Handle the text changes here
        print("textView.count: \(textView.text.count)")
        if textView == textViewAbout
        {
            if textView.text.count >= 121
            {
                Alert.sharedInstance.showAlertDelegate("ENTER_ONLY120_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                textView.text.remove(at: textView.text.index(before: textView.text.endIndex))
                let result = String(textView.text.dropLast((textView.text.count - 120)))
                textView.text = result
            }
        }
    }
    //    func textViewDidBeginEditing(_ textView: UITextView)
    //    {
    //        let bottomOffset: CGPoint = CGPoint(x: 0, y: self.scrollView.contentSize.height - scrollView.contentSize.height * 0.72)
    //        self.scrollView.setContentOffset(bottomOffset, animated: true)
    //
    //    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == textViewAbout
        {
            Global.sharedInstance.addProviderBusinessProfile.nvAboutComment = textView.text
        }
    }


    //MARK: - Functions
    //==========Functions=================

    //add taps to the views to show popUps on tap them
    func tapOnViews()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action:#selector(RegisterBuisnessProphielViewController.dismissKeyboard))
        tap.delegate=self
        self.view.addGestureRecognizer(tap)

        ///----------when tap on logo view
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(RegisterBuisnessProphielViewController.selectLogo(_:)))
        imgLogo.isUserInteractionEnabled = true
        imgLogo.addGestureRecognizer(tapGestureRecognizer)


        tapGestureRecognizerForAlbom = UITapGestureRecognizer(target:self, action:#selector(RegisterBuisnessProphielViewController.openAlbom(_:)))
        viewAlbumLogo.isUserInteractionEnabled = true
        viewAlbumLogo.addGestureRecognizer(tapGestureRecognizerForAlbom)

        tapGestureRecognizerForCamera = UITapGestureRecognizer(target:self, action:#selector(RegisterBuisnessProphielViewController.openCamera(_:)))
        viewCameraLogo.isUserInteractionEnabled = true
        viewCameraLogo.addGestureRecognizer(tapGestureRecognizerForCamera)
        ///---------------------------------

        ///------when tap on view 3(the first view light  blue)
        let tapGestureRecognizer1 = UITapGestureRecognizer(target:self, action:#selector(RegisterBuisnessProphielViewController.selectPicture(_:)))
        view_lightBlue_3.isUserInteractionEnabled = true
        view_lightBlue_3.addGestureRecognizer(tapGestureRecognizer1)

        tapGestureRecognizerForAlbom_3 = UITapGestureRecognizer(target:self, action:#selector(RegisterBuisnessProphielViewController.openAlbom(_:)))
        viewAlbum3.isUserInteractionEnabled = true
        viewAlbum3.addGestureRecognizer(tapGestureRecognizerForAlbom_3)

        tapGestureRecognizerForCamera_3 = UITapGestureRecognizer(target:self, action:#selector(RegisterBuisnessProphielViewController.openCamera(_:)))
        viewCamera3.isUserInteractionEnabled = true
        viewCamera3.addGestureRecognizer(tapGestureRecognizerForCamera_3)
        //-------------------------------------------


        //-------------------------------------------

        ///------when tap on view campain
        let tapGestureRecognizer3 = UITapGestureRecognizer(target:self, action:#selector(RegisterBuisnessProphielViewController.selectCampain(_:)))
        view_lightBlue_5.isUserInteractionEnabled = true
        view_lightBlue_5.addGestureRecognizer(tapGestureRecognizer3)

        tapGestureRecognizerForAlbom_campain = UITapGestureRecognizer(target:self, action:#selector(RegisterBuisnessProphielViewController.openAlbom(_:)))
        viewAlbumCampain.isUserInteractionEnabled = true
        viewAlbumCampain.addGestureRecognizer(tapGestureRecognizerForAlbom_campain)

        tapGestureRecognizerForCamera_campain = UITapGestureRecognizer(target:self, action:#selector(RegisterBuisnessProphielViewController.openCamera(_:)))
        viewCameraCampain.isUserInteractionEnabled = true
        viewCameraCampain.addGestureRecognizer(tapGestureRecognizerForCamera_campain)
        //-------------------------------------------


        //-------------------------------------------
    }

    // MARK: - Select Image
    //===================Select Image=================

    //open the library to choose image
    @objc func openAlbom(_ img: AnyObject)
    {
        var whatint:Int = 0

        if img as! UITapGestureRecognizer == tapGestureRecognizerForAlbom
        {
            changeImage = "logo"
            whatint = 1
        }
        else if img as! UITapGestureRecognizer == tapGestureRecognizerForAlbom_3
        {
            changeImage = "ligtyBlue3"
            whatint = 2
        }
        else if img as! UITapGestureRecognizer == tapGestureRecognizerForAlbom_campain
        {
            changeImage = "campain"
            whatint = 3

        }


        let alertController: UIAlertController = UIAlertController(title: "LOOK".localized(LanguageMain.sharedInstance.USERLANGUAGE), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title:"CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style:UIAlertAction.Style.cancel, handler:nil)
        alertController.addAction(cancelAction)
        let button1action: UIAlertAction = UIAlertAction(title: "LOOK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) -> () in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                if  whatint == 1 {
                    self.showResizablePicker(self.imgLogo,galleryorcamera: 0, _lockAspectRatio:true)
                } else {
                    self.showResizablePicker(self.imgLogo,galleryorcamera: 0, _lockAspectRatio:true)
                }

            }

        })
        alertController.addAction(button1action)
        // for iPAD support:

        switch whatint {
        case 1:
            //  alertController.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.width / 2.0, self.view.bounds.height / 2.0, 1.0, 1.0)
            //alertController.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.width / 2.0, self.viewLogo.frame.origin.y + self.viewLogo.frame.size.height + 50, 1.0, 1.0)
            alertController.popoverPresentationController?.sourceView = self.viewLogo
            alertController.popoverPresentationController?.sourceRect =  self.viewLogo.bounds
        case 2:
            alertController.popoverPresentationController?.sourceView = self.viewAddPictureToView3
            alertController.popoverPresentationController?.sourceRect =  self.viewAddPictureToView3.bounds

        case 3:
            alertController.popoverPresentationController?.sourceView = self.viewCampaign
            alertController.popoverPresentationController?.sourceRect =  self.viewCampaign.bounds

        default:
            0
        }
        // this is the center of the screen currently but it can be any point in the view

        self.present(alertController, animated: true, completion: nil)



    }

    //MARK:-------cropImage; int
    func showResizablePicker(_ button: UIView, galleryorcamera: Int, _lockAspectRatio:Bool) {
        //self.imagePickerWD = WDImagePicker()

        var someselect : UIImagePickerController.SourceType = UIImagePickerController.SourceType.init(rawValue: 0)!
        if( galleryorcamera == 0) {
            //gallery
            someselect = .photoLibrary
        }
        if (galleryorcamera == 1 ) {
            //camera
            someselect = .camera

        }
        self.imagePickerWD = WDImagePicker.init(withSourceType: someselect)
        //   self.imagePickerWD.cropSize = CGSizeMake(280, 86) // 280, 280 original but no quite adeqv. for mobile JMODE
        //        let widthofview = self.view.frame.size.width - 66 // keep space for corners
        // iustin crop
        let widthofview = self.view.frame.size.width - (self.view.frame.size.width * 0.17)
        //        var heightofimage = widthofview * 0.28
        var heightofimage = widthofview * 0.265
        if changeImage == "logo" {
            heightofimage = widthofview
        }
        self.imagePickerWD.cropSize = CGSize(width: widthofview, height: heightofimage)
        self.imagePickerWD.delegate = self
        self.imagePickerWD.resizableCropArea = true
        //JMODE MODE:D
        self.imagePickerWD.lockAspectRatio =  _lockAspectRatio



        if UIDevice.current.userInterfaceIdiom == .pad {

            self.imagePickerWD.imagePickerController.allowsEditing = true

            if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 {
                self.present(self.imagePickerWD.imagePickerController, animated: true, completion: nil)
            } else {
                Global.sharedInstance.rgisterModelViewController?.present(self.imagePickerWD.imagePickerController, animated: true, completion: nil)
            }


        } else {
            if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 1 {
                self.present(self.imagePickerWD.imagePickerController, animated: true, completion: nil)
            } else {
                Global.sharedInstance.rgisterModelViewController?.present(self.imagePickerWD.imagePickerController, animated: true, completion: nil)
            }
        }

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

    //save the chosen picture - album
    func imagePicker(_ imagePicker: WDImagePicker, pickedImage: UIImage) {
        //\\print ("hhh \(pickedImage.size.width)")
        if pickedImage.size.height > 0 || pickedImage.size.width > 0 {
            //JMODE   let img:UIImage = Global.sharedInstance.resizeImage(pickedImage, newWidth: pickedImage.size.width*0.5)
            //  let img:UIImage = Global.sharedInstance.resizeImage(pickedImage, newWidth: pickedImage.size.width)
            let img:UIImage = Global.sharedInstance.resizeImage(pickedImage, newWidth:1024) //maximum widht
            let base64String = Global.sharedInstance.setImageToString(img)


            if changeImage=="ligtyBlue3"
            {



                //            UIGraphicsBeginImageContext(view_lightBlue_3.frame.size)
                //            pickedImage.drawInRect(view_lightBlue_3.bounds)
                //            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                //            UIGraphicsEndImageContext()
                imgLightBlue3.clipsToBounds = true
                // imgLightBlue3.contentMode = UIViewContentMode.ScaleAspectFit
                imgLightBlue3.contentMode = UIView.ContentMode.scaleAspectFill
                imgLightBlue3.image =  pickedImage
                if  pickedImage.size.height > 0 {
                    takeprofile.isHidden  = true }
                else {
                    takeprofile.isHidden  = false
                }
                Global.sharedInstance.addProviderBusinessProfile.nvHeaderImage = base64String

                viewAddPictureToView3.isHidden=true


                //    self.scrollView.setContentOffset(CGPointMake(0, -self.scrollView.contentInset.top), animated: false)
                let aRectangle:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
                self.scrollView.scrollRectToVisible(aRectangle, animated: true)


                UIApplication.shared.isStatusBarHidden = false
                UIApplication.shared.statusBarStyle = .lightContent
                //     selectAbout(imgCamera)
            }
            else if changeImage=="logo"
            {
                imgLogo.contentMode = UIView.ContentMode.scaleAspectFit
                //imgLogo.contentMode = UIViewContentMode.ScaleAspectFill
                imgLogo.clipsToBounds = true
                imgLogo.backgroundColor = UIColor.clear
                imgLogo.image = pickedImage
                if pickedImage.size.height > 0 {
                    takelogo.isHidden  = true }
                else {
                    takelogo.isHidden  = false
                }
                viewLogo.isHidden=true
                Global.sharedInstance.addProviderBusinessProfile.nvILogoImage = base64String

                UIApplication.shared.isStatusBarHidden = false
                UIApplication.shared.statusBarStyle = .lightContent
            }
            else if changeImage=="campain"
            {
                //            UIGraphicsBeginImageContext(view_lightBlue_5.frame.size)
                //            pickedImage.drawInRect(view_lightBlue_5.bounds)
                //            let image1: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
                //            UIGraphicsEndImageContext()
                imgLightBlue5.clipsToBounds = true
                //  imgLightBlue5.contentMode = UIViewContentMode.ScaleAspectFit

                imgLightBlue5.contentMode = UIView.ContentMode.scaleAspectFill
                imgLightBlue5.image =  pickedImage
                if  pickedImage.size.height > 0 {
                    takesale.isHidden  = true }
                else {
                    takesale.isHidden  = false
                }
                viewCampaign.isHidden = true
                Global.sharedInstance.addProviderBusinessProfile.nvCampaignImage = base64String
                //            let topOffset1: CGPoint = CGPointMake(0, scrollCampain + 0.085 * scrollView.contentSize.height)
                //            self.scrollView.setContentOffset(topOffset1, animated: false)
                //  self.scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
                let aRectangle:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
                self.scrollView.scrollRectToVisible(aRectangle, animated: true)
                UIApplication.shared.isStatusBarHidden = false
                UIApplication.shared.statusBarStyle = .lightContent
                /////////    selectBottom(imgCamera)
            }
            //        else if changeImage=="bottom"
            //        {
            //            UIGraphicsBeginImageContext(view_lightBlue8.frame.size)
            //            pickedImage.drawInRect(view_lightBlue8.bounds)
            //            let image1: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
            //            UIGraphicsEndImageContext()
            //            addImage8.hidden = true
            //            imgLightBlue8.image = image1
            //            viewBottom.hidden = true
            //
            //
            //            Global.sharedInstance.addProviderBusinessProfile.nvFooterImage = base64String
            //        }

            UIApplication.shared.isStatusBarHidden = false
            UIApplication.shared.statusBarStyle = .lightContent
            self.hideImagePicker()
        } else {
            UIApplication.shared.isStatusBarHidden = false
            UIApplication.shared.statusBarStyle = .lightContent

            //JMODE to prevent user selecting black (nil)
            //            func showalerta() {
            //                let alert = UIAlertController(title: "Alert", message: "No arrea of image selected! ", preferredStyle: UIAlertControllerStyle.Alert)
            //                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            //
            //
            //            }
            //              self.hideImagePicker()
            //                     Alert.sharedInstance.showAlert(("Select arrea of image"), vc: self)
            //
            //nothing
        }

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }

    func hideImagePicker() {

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent

        // self.navigationController!.navigationBar.translucent = false

        //  self.popoverController.dismissPopoverAnimated(true)
        self.imagePickerWD.imagePickerController.dismiss(animated: true, completion: nil)

        //        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
        //
        //            UIApplication.sharedApplication().statusBarHidden = false
        //            UIApplication.sharedApplication().statusBarStyle = .LightContent
        //
        //            //  self.popoverController.dismissPopoverAnimated(true)
        //            self.imagePickerWD.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        //        } else {
        //
        //            UIApplication.sharedApplication().statusBarHidden = false
        //            UIApplication.sharedApplication().statusBarStyle = .LightContent
        //
        //            self.imagePickerWD.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        //        }

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }


    //open the camera
    @objc func openCamera(_ img: AnyObject)
    {
        if img as! UITapGestureRecognizer  == tapGestureRecognizerForCamera
        {
            changeImage="logo"
        }
        else if img as! UITapGestureRecognizer  == tapGestureRecognizerForCamera_3
        {
            changeImage="ligtyBlue3"
        }
        else if img as! UITapGestureRecognizer  == tapGestureRecognizerForCamera_campain
        {
            changeImage="campain"
        }
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            //            let imagePicker = UIImagePickerController()
            //            imagePicker.delegate = self
            //            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            //            imagePicker.allowsEditing = false
            //
            //            imagePicker.modalPresentationStyle = UIModalPresentationStyle.Custom
            //            self.presentViewController(imagePicker, animated: true, completion: nil)
            if img as! UITapGestureRecognizer  == tapGestureRecognizerForCamera {
                self.showResizablePicker(self.imgLogo, galleryorcamera: 1, _lockAspectRatio:true)
            } else {
                self.showResizablePicker(self.imgLogo, galleryorcamera: 1, _lockAspectRatio:false)
            }


        }

        else {
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }


    @objc func removeProfilePicture(_ sender: UITapGestureRecognizer)
    {
        //        Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage = ""
        if sender == removePictureRecognizer
        {
            changeImage = "logo"

            imgLogo.contentMode = UIView.ContentMode.scaleAspectFit

            imgLogo.clipsToBounds = true
            imgLogo.backgroundColor = UIColor.clear
            imgLogo.image = nil
            takelogo.image =  UIImage(named: "cameraiconJ.png")
            takelogo.isHidden = false
            imgLogo.contentMode = UIView.ContentMode.scaleAspectFill

            viewLogo.isHidden=true
            Global.sharedInstance.addProviderBusinessProfile.nvILogoImage = ""

            UIApplication.shared.isStatusBarHidden = false
            UIApplication.shared.statusBarStyle = .lightContent
        }
        //        viewAddPictureToView3.isHidden = true

    }

    @objc func removeCompanyPicture(_ sender: UITapGestureRecognizer)
    {
        //        Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage = ""
        if sender == removeCompanyPictureRecognizer
        {
            changeImage = "ligtyBlue3"

            imgLightBlue3.contentMode = UIView.ContentMode.scaleAspectFit

            imgLightBlue3.clipsToBounds = true
            imgLightBlue3.backgroundColor = UIColor.clear
            imgLightBlue3.image = nil
            takeprofile.image  =  UIImage(named: "cameraiconJ.png")
            takeprofile.isHidden = false
            //            takesale.image  =  UIImage(named: "cameraiconJ.png")
            imgLightBlue3.contentMode = UIView.ContentMode.scaleAspectFill
            viewAddPictureToView3.isHidden=true
            Global.sharedInstance.addProviderBusinessProfile.nvHeaderImage = ""

            UIApplication.shared.isStatusBarHidden = false
            UIApplication.shared.statusBarStyle = .lightContent
        }

    }

    @objc func removeSalePicture(_ sender: UITapGestureRecognizer)
    {
        if sender == removeSaleRecognizer
        {
            changeImage = "campain"

            imgLightBlue5.contentMode = UIView.ContentMode.scaleAspectFit

            imgLightBlue5.clipsToBounds = true
            imgLightBlue5.backgroundColor = UIColor.clear
            imgLightBlue5.image = nil
            takesale.image  =  UIImage(named: "cameraiconJ.png")
            takesale.isHidden = false
            //            takesale.image  =  UIImage(named: "cameraiconJ.png")
            imgLightBlue5.contentMode = UIView.ContentMode.scaleAspectFill
            viewCampaign.isHidden=true
            Global.sharedInstance.addProviderBusinessProfile.nvCampaignImage = ""

            UIApplication.shared.isStatusBarHidden = false
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent

        picker.dismiss(animated: true, completion: nil)

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }

    //save the chosen image - camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        let img:UIImage = Global.sharedInstance.resizeImage(image, newWidth: image.size.width)
        let base64String = Global.sharedInstance.setImageToString(img)

        //------------------------

        if changeImage=="ligtyBlue3"
        {
            //            UIGraphicsBeginImageContext(view_lightBlue_3.frame.size)
            //            image.drawInRect(view_lightBlue_3.bounds)
            //            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            //            UIGraphicsEndImageContext()
            imgLightBlue3.contentMode = UIView.ContentMode.scaleAspectFill
            imgLightBlue3.clipsToBounds = true
            imgLightBlue3.image = img
            Global.sharedInstance.addProviderBusinessProfile.nvHeaderImage = base64String
            viewAddPictureToView3.isHidden=true
            //  self.scrollView.setContentOffset(CGPointMake(0, -self.scrollView.contentInset.top), animated: false)
            let aRectangle:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
            self.scrollView.scrollRectToVisible(aRectangle, animated: true)

            UIApplication.shared.isStatusBarHidden = false
            UIApplication.shared.statusBarStyle = .lightContent
        }
        else if changeImage=="logo"
        {
            imgLogo.contentMode = UIView.ContentMode.scaleAspectFit

            imgLogo.clipsToBounds = true
            imgLogo.backgroundColor = UIColor.clear
            imgLogo.image = img
            viewLogo.isHidden=true
            Global.sharedInstance.addProviderBusinessProfile.nvILogoImage = base64String

            UIApplication.shared.isStatusBarHidden = false
            UIApplication.shared.statusBarStyle = .lightContent
        }
        else if changeImage=="campain"
        {
            //            UIGraphicsBeginImageContext(view_lightBlue_5.frame.size)
            //            image?.drawInRect(view_lightBlue_5.bounds)
            //            let image1: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
            //            UIGraphicsEndImageContext()
            imgLightBlue5.contentMode = UIView.ContentMode.scaleAspectFill
            imgLightBlue5.clipsToBounds = true
            imgLightBlue5.image = img
            viewCampaign.isHidden = true
            Global.sharedInstance.addProviderBusinessProfile.nvCampaignImage = base64String
            //    let topOffset1: CGPoint = CGPointMake(0, scrollCampain + 0.085 * scrollView.contentSize.height)
            //    self.scrollView.setContentOffset(topOffset1, animated: false)
            // self.scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
            let aRectangle:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
            self.scrollView.scrollRectToVisible(aRectangle, animated: true)

            UIApplication.shared.isStatusBarHidden = false
            UIApplication.shared.statusBarStyle = .lightContent
        }
        //        else if changeImage=="bottom"
        //        {
        //            UIGraphicsBeginImageContext(view_lightBlue8.frame.size)
        //            image?.drawInRect(view_lightBlue8.bounds)
        //            let image1: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        //            UIGraphicsEndImageContext()
        //            addImage8.hidden = true
        //            imgLightBlue8.image = image1
        //            viewBottom.hidden = true
        //
        //
        //            Global.sharedInstance.addProviderBusinessProfile.nvFooterImage = base64String
        //        }

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent

        picker.dismiss(animated: true, completion: nil)

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }

    // MARK: - pop up
    //================pop up================

    //show popUp of logo
    @objc func selectLogo(_ img: AnyObject)
    {
        flagImage = 1
        self.viewLogo.isHidden = false        ///hide all the views that on the base view
        viewAddPictureToView3.isHidden = true
        viewCampaign.isHidden = true

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }


    //show popUp of business image
    @objc func selectPicture(_ img: AnyObject)
    {
        flagImage = 2
        //       let bottomOffset: CGPoint = CGPointMake(0, self.scrollView.contentSize.height - scrollView.contentSize.height * 0.92)
        //        self.scrollView.setContentOffset(bottomOffset, animated: true)
        let aRectangle:CGRect = CGRect(x: 0, y: viewAddPictureToView3.frame.origin.y +  viewAddPictureToView3.frame.size.height * 2, width: 0, height: 0)
        self.scrollView.scrollRectToVisible(aRectangle, animated: true)
        self.viewAddPictureToView3.isHidden = false
        viewLogo.isHidden = true

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }


    //show popUp of campaign
    @objc func selectCampain(_ img: AnyObject)
    {
        flagImage = 4
        //   scrollCampain = self.scrollView.bounds.size.height / 8

        //   let bottomOffset: CGPoint = CGPointMake(0, self.scrollView.contentSize.height / 4)
        ///            - scrollView.contentSize.height * 0.34)
        //     self.scrollView.setContentOffset(bottomOffset, animated: true)
        let aRectangle:CGRect = CGRect(x: 0, y: viewCampaign.frame.origin.y +  viewCampaign.frame.size.height * 2, width: 0, height: 0)
        self.scrollView.scrollRectToVisible(aRectangle, animated: true)
        viewLogo.isHidden = true
        viewAddPictureToView3.isHidden = true
        self.viewCampaign.isHidden = false

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }




    //
    //    func showHideSale()
    //    {
    //        //if the sale image is shown - hide it
    //        if Global.sharedInstance.isOpenSale == true
    //        {
    //            Global.sharedInstance.isOpenSale = false
    //            viewShowSale.backgroundColor = Colors.sharedInstance.color9
    //            topSaleOpen = topToSale
    //            self.view.removeConstraint(topSaleOpen)
    //            let constraint = NSLayoutConstraint(item: viewUnderSale, attribute: .Top, relatedBy: .Equal, toItem: viewShowSale, attribute: .Top, multiplier: 1, constant: viewShowSale.frame.size.height)
    //            topSaleClose = constraint
    //            self.view.addConstraint(constraint)
    //            scrollView.contentSize.height = 1450 - view_lightBlue_5.frame.size.height
    //
    //            if self.viewCampaign.hidden == false
    //            {
    //                self.viewCampaign.hidden = true
    //
    //
    //                //show popUp of bottom image
    //          //      selectBottom(imgPicture)
    //            }
    //        }
    //        else
    //        {
    //            Global.sharedInstance.isOpenSale = true
    //            viewShowSale.backgroundColor = UIColor.clearColor()
    //
    //            self.view.removeConstraint(topSaleClose)
    //            self.view.addConstraint(topToSale)
    //        }
    //    }
    ////original

    //MARK: - GoogleMaps
    //==================GoogleMaps===================

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        if status == .authorizedWhenInUse {

            // 4
            locationManager.startUpdatingLocation()

            //5
            //            viewMap.isMyLocationEnabled = true
            //            viewMap.settings.myLocationButton = true
            //
            //            viewMap.animate(toZoom: 18)
        } else {
            let alert = UIAlertController(title: nil, message: "REQUEST_LOCATION_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
            })

            self.present(alert, animated: true, completion: nil)
        }
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {

            //   viewMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }

    }


//    func googleURLString() ->String
//    {
//        var url:String = ""
//        url = NSString(format:"https://maps.googleapis.com/maps/api/place/details/json?input=bar&placeid=%@&key=%@",Global.sharedInstance.placeIdForMap,key) as String
//        return url
//    }


    // MARK:NSURLConnectionDelegate


    // MARK: - Key board
    //================Key Board=============

    @objc func dismissKeyboard()
    {
        self.view.endEditing(true)
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        self.dismissKeyboard()
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func cutHour(_ hour:String) -> String {
        var fixedHour = String(hour.characters.dropLast())
        fixedHour = String(fixedHour.characters.dropLast())
        fixedHour = String(fixedHour.characters.dropLast())
        return fixedHour
    }


    var data: NSMutableData?
    var connectionAutocomplete = NSURLConnection()


    func ImageCropViewControllerSuccess(_ controller: UIViewController!, didFinishCroppingImage croppedImage: UIImage!)
    {
        self.navigationController!.popViewController(animated: true)
    }

    func ImageCropViewControllerDidCancel(_ controller: UIViewController!)
    {
        self.navigationController!.popViewController(animated: true)
    }

    func cropToBounds(_ image: UIImage, width: Double, height: Double) -> UIImage {

        let contextImage: UIImage = image

        let contextSize: CGSize = contextImage.size

        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)

        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

        return image
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


}

