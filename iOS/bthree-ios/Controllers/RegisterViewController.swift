//
//  RegisterViewController.swift
//  bthree-ios
//
//  Created by Tami wexelbom on 2/16/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion
import Foundation
import Crashlytics
import PhoneNumberKit
import Contacts
import FacebookLogin
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

protocol popUpPhoneDelegate {
    func deleteTxtPhone()
}

protocol didReadRegulationDelegte {
    func didReadRegulation()
}

protocol addImage{
    func ImagesCamera()
}

protocol openChooseUserDelegate{
    func openBuisnessDetails()
}

protocol openCustomerDetailsDelegate
{
    func openCustomerDetails()
}

//רישום לקוח
class RegisterViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,addImage,FBSDKLoginButtonDelegate,openChooseUserDelegate,openCustomerDetailsDelegate,didReadRegulationDelegte,WDImagePickerDelegate,popUpPhoneDelegate
{
    var viewpopupBeforeRegisterUser: popupfirstRegisterUser!// popupBeforeRegisterUser!
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    //MARK: - Properties
    @IBOutlet weak var btnClose: UIButton!
    var ISSYNCCONTACT:Bool = false
    var dateServer = Date()
    var generic:Generic = Generic()
    var isLoginInFaceBook = false
   
    ///flags for textField to check validation-which textField filled before
    var fDidBegin = false
    var flag_FullName:Bool = false
    var flag_LastName:Bool = false
    var flag_Phone:Bool = false
    var flag_Email:Bool = false
    var flag_Date:Bool = false
    var isOnlyFirstName:Bool = false
    var image:UIImage = UIImage()
    var keyboardIsShowing = false
  
    var isCheckFromClickRegister:Bool = false//האם הגיע לבדיקת השלמת התקנון רק כשלוחצים על הרשם
    ///משתנה המציין אם הכוכבית במספר טלפון נמצא רק בתחילת המספר
    var cochOnlyInBegin = true
    var arrGoodPhone:Array<Character> = Array<Character>()
    fileprivate var iimagePicker: WDImagePicker!
    //מציין האם נגמרו הבדיקות תקינות
    var isCheckEmailEnd:Bool = false
    var isCheckPhoneEnd:Bool = false
    var isCheckNameEnd:Bool = false
    var isCheckLastNameEnd:Bool = false
    
    fileprivate var imagePickerWD: WDImagePicker!
    var timer: Timer? = nil
    
    var dic2ForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    
    ///for underline of buttons
    var attrs = [
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: "OpenSansHebrew-Bold", size: 12)!,
        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : Colors.sharedInstance.color3,
        convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : 1] as [String : Any]
    var attributedStringsUserExist = NSMutableAttributedString(string:"")
    var attributedStringsLanguage = NSMutableAttributedString(string:"")
    let kClientId:NSString = "684155944655-dc4qpsliein6tk7al78m1gfo0b1blkfc.apps.googleusercontent.com"
    var imagePicker: UIImagePickerController!
    var arr:Array<String> = Array<String>()
    let line:UILabel = UILabel()
    
    var cell2:PersonalDetailsTableViewCell?
    var indexPathDate:IndexPath = IndexPath(row: 0, section: 0)
    
    let phoneNumberKit = PhoneNumberKit()
    
    var loginDelegate:openLoginDelegate!=nil
    var picturePopUpCount:Int = 0
    var languageDelegate: languageFromRegister!=nil
    //MARK: - Outlet
    @IBOutlet weak var orlabel: UILabel!
    @IBOutlet weak var lblRegisterBusiness: UILabel!
    @IBOutlet weak var viewRegisterProvider: UIView!
    @IBOutlet weak var backImg: UIImageView!
    
    @IBOutlet weak var btnDelImage: UIButton!
    
    @IBAction func btnDelImage(_ sender: AnyObject) {
        //txtAddress.dismissSuggestionTableView()
        img.image = nil
        btnDelImage.isHidden = true
    }
    @IBOutlet weak var btnGetP: checkBox2!
    @IBOutlet weak var lblPaymentsDetails: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblSync: UILabel!
    @IBOutlet weak var lblGetP: UILabel!
    
    @IBOutlet weak var lblDateBorn: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var dp: UIDatePicker!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var validPhone: UILabel!
    @IBOutlet weak var reqField: UILabel!
    @IBOutlet weak var scrRegister: UIScrollView!
    @IBOutlet var imgRegister: UIView!
    @IBOutlet var lblLoginTitle: UILabel!
    
    @IBOutlet weak var btnFaceBookLoginButton: FBSDKLoginButton!
    
    @IBOutlet weak var validEmal: UILabel!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viLastName: UIView!
    @IBOutlet weak var viFirstName: UIView!
    
    
    @IBOutlet weak var uploadImageLbl: UILabel!
    
    @IBOutlet weak var paymentsImformationlbl: UILabel!
    @IBOutlet weak var viPhone: UIView!
    
    @IBOutlet weak var viDateBorn: UIView!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var lblImageUrl: UILabel!
    
    @IBOutlet weak var viImage: UIView!
    @IBOutlet weak var viEmail: UIView!
    
    //when click on GooglePlush button
    
    
    @IBOutlet weak var tblDetails: UITableView!
    
    @IBOutlet weak var lblRead: UILabel!
    
    @IBOutlet weak var lblGetAdverties: UILabel!
    
    @IBOutlet weak var btnGetAdverties: CheckBox!//type of class that defines cheakbox
    
    @IBOutlet weak var btnRead: checkBox2!
    
    @IBOutlet weak var lblLastName: UILabel!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var txtAddress: SuggestiveTextField!
    
    @IBOutlet weak var validAddress: UILabel!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgContainerUiView: UIView!
    @IBOutlet weak var addPictureBtn: UIButton!
    @IBOutlet weak var customerProfilePic: UIImageView!
    @IBOutlet weak var termsOfUseLabel: UILabel!
    @IBOutlet weak var termsOfUseTrailing: NSLayoutConstraint!
    @IBOutlet weak var termsOfUseLeading: NSLayoutConstraint!
    @IBOutlet weak var alreadyRegisteredLabel: UILabel!
    var customerImage = UIImage(named:"customers_icon.png")
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var heightTopView: NSLayoutConstraint!
    
    
    @IBAction func checkread(_ sender:AnyObject ) {
    //   btnRead.isCecked = !btnRead.isCecked
        if btnRead.isCecked == true {
            Global.sharedInstance.fReadRegulation = true
        } else {
             Global.sharedInstance.fReadRegulation = false
        }
    
    }
    
    @IBAction func addPictureAction(_ sender: UIButton)
    {
        let alertController: UIAlertController = UIAlertController(title: "LOOK".localized(LanguageMain.sharedInstance.USERLANGUAGE), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title:"CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style:UIAlertAction.Style.cancel, handler:nil)
        alertController.addAction(cancelAction)
        let button1action: UIAlertAction = UIAlertAction(title: "OPEN_CAMERA".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) -> () in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        })
        let button2action: UIAlertAction = UIAlertAction(title: "OPEN_ALBUM".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) -> () in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                self.showResizablePicker(self.addPictureBtn, galleryorcamera: 0)
            }
        })
        
        let button3action: UIAlertAction = UIAlertAction(title: "REMOVE_PICTURE_PERSONAL_INFO".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) ->() in
            
            self.customerProfilePic.contentMode = .scaleAspectFit
            self.customerProfilePic.image = self.customerImage
            
            
        })
        
        
        alertController.addAction(button1action)
        alertController.addAction(button2action)
        alertController.addAction(button3action)
        alertController.popoverPresentationController?.sourceView = self.addPictureBtn
        //        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.width / 2.0, y: self.view.bounds.height / 2.0, width: 1.0, height: 1.0) // this is
        alertController.popoverPresentationController?.sourceRect = self.addPictureBtn.bounds
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showResizablePicker(_ button: UIView, galleryorcamera: Int) {
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
        let widthofview = self.view.frame.size.width - 66 // keep space for corners
        let heightofimage = widthofview * 0.70
        self.imagePickerWD.cropSize = CGSize(width: widthofview, height: heightofimage)
        self.imagePickerWD.delegate = self
        self.imagePickerWD.resizableCropArea = true
        //JMODE MODE:D
        self.imagePickerWD.lockAspectRatio = true
        
        
        self.present(self.imagePickerWD.imagePickerController, animated: true, completion: nil)
        
        
    }
   
    
    func imagePicker(_ imagePicker: WDImagePicker, pickedImage: UIImage)
    {
        if pickedImage.size.width != 0
        {
            self.customerProfilePic.contentMode = .scaleToFill
            customerProfilePic.image = self.resizeImage(pickedImage, newWidth:220)
        }
        
        self.hideImagePicker()
    }
    
    func hideImagePicker() {
        self.imagePickerWD.imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func termsOfUseAction(_ sender: Any)
    {
        let vcRegulations = self.storyboard?.instantiateViewController(withIdentifier: "RegulationsViewController") as! RegulationsViewController
        vcRegulations.delegate = self
        
        //   vcRegulations.modalPresentationStyle = UIModalPresentationStyle.Custom
        if self.iOS8 {
            vcRegulations.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            vcRegulations.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        
        self.present(vcRegulations, animated: true, completion: nil)
    }
    
    @IBAction func alreadyRegisteredAction(_ sender: UIButton)
    {
        loginDelegate.showPopUp()

    }
    
    
    @IBAction func btnRegister(_ sender: AnyObject) {
        //txtAddress.dismissSuggestionTableView()
        
        if self.customerProfilePic.image == customerImage
        {
            picturePopUpCount += 1
        }

        
        if picturePopUpCount == 1
        {
            if let _ =  Bundle.main.loadNibNamed("NoPictureRegistrationPopUp", owner: self, options: nil)?.first as? noPictureRegistrationPopUpView
            {
                let popUpReview = Bundle.main.loadNibNamed("NoPictureRegistrationPopUp", owner: self, options: nil)?.first as! noPictureRegistrationPopUpView
                popUpReview.frame = self.view.frame
                view.addSubview(popUpReview)
                picturePopUpCount += 1
                
                
                
            }
        }
        else
        {
            isCheckFromClickRegister = true
            ///-----בדיקה שהשדות תקינים-------------------
            Global.sharedInstance.isRegisterClientClick = true
            Global.sharedInstance.isRegisterProviderClick = false
            
            isCheckEmailEnd = false
            isCheckPhoneEnd = false
            isCheckNameEnd = false
            if fullName.text != ""
            {
                validationName()
            }
            else if txtPhone.text != ""
            {
                self.validationPhone()
            }
                //        else if txtEmail.text != ""
                //        {
                //            self.validationEmail()
                //        }
            else
            {
                self.validToRegister()
            }
        }
        

    }
    
    @IBOutlet weak var btnSync: checkBox2!
    @IBAction func btnLogin(_ sender: UIButton) {
        ///-----בדיקה שהשדות תקינים-------------------
        Global.sharedInstance.isRegisterClientClick = true
        
        isCheckEmailEnd = false
        isCheckPhoneEnd = false
        isCheckNameEnd = false
        
        validationName()
    }
    @IBOutlet weak var openCamera: UIButton!
    
    @IBAction func btnCamera(_ sender: UIButton) {
        Global.sharedInstance.isCamera = true
        ImagesCamera()
    }
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var dateBorn: UITextField!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var btnRegulations: UIButton!
    
    @IBAction func btnOpenPayments(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodViewController") as! PaymentMethodViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var btnOpenPayments: UIButton!
    
    /// open the regulations pages
    @IBAction func btnRegulations(_ sender: AnyObject) {
        let vcRegulations = self.storyboard?.instantiateViewController(withIdentifier: "RegulationsViewController") as! RegulationsViewController
        vcRegulations.delegate = self
        
     //   vcRegulations.modalPresentationStyle = UIModalPresentationStyle.Custom
        if self.iOS8 {
            vcRegulations.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            vcRegulations.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
 
        self.present(vcRegulations, animated: true, completion: nil)
    }
    
    //MARK: - Initial
//    @IBAction func crashButtonTapped( sender: AnyObject) {
//        Crashlytics.sharedInstance().crash()
//    }
    @IBAction func btnClose(_ sender: AnyObject)
    {

    Global.sharedInstance.logoutUSER()
    self.navigationController?.popViewController(animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.imgContainerUiView.layer.cornerRadius = self.imgContainerUiView.frame.size.width/2
        self.imgContainerUiView.clipsToBounds = true
//        alreadyRegisteredLabel.text = "LANG".localized(LanguageMain.sharedInstance.USERLANGUAGE)

        alreadyRegisteredLabel.attributedText = NSAttributedString(string: "LANG".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:
            convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle): NSUnderlineStyle.single.rawValue]))

        self.customerProfilePic.image = customerImage
        picturePopUpCount = 0
        
        if (UIDevice.current.model.range(of: "iPad") != nil)
        {
            heightTopView.constant = 238
        }
        else
        {
            heightTopView.constant = 200
        }
        
        
        let USERDEF = Global.sharedInstance.defaults
        USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
        if let _ = USERDEF.object(forKey: "didShowRegisterPopUp")
        {
            
        }
        else
        {
            USERDEF.set(0, forKey: "didShowRegisterPopUp")
        }
        
        USERDEF.synchronize()
        let mys = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId")
        print("FINDisfromSPECIALiCustomerUserId \(mys)")
        self.view.addBackground()

        print("aaa \( Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE"))")
        let leftarrowback = UIImage(named: "sageata2.png")
       // let rightarrowback = UIImage(named: "sageata1.png")
      //  if Global.sharedInstance.rtl {

        self.navigationController?.interactivePopGestureRecognizer?.delegate  = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
          self.navigationItem.setHidesBackButton(true, animated:false)
        
        Global.sharedInstance.registerViewCon = self
        Global.sharedInstance.viewConNoInternet = self

        self.viImage.bringSubviewToFront(openCamera)

        
        btnSync.isCecked = true
        fullName.attributedPlaceholder = NSAttributedString(string:"FIRSTNAME_LBL".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        dateBorn.attributedPlaceholder = NSAttributedString(string:"DATEBURN_LBL".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        txtPhone.attributedPlaceholder = NSAttributedString(string:"PHONE_NUMBER".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        txtEmail.attributedPlaceholder = NSAttributedString(string:"MAIL_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        txtLastName.attributedPlaceholder = NSAttributedString(string:"L_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 16)!]))
        
        
        titleLabel.text = "REGISTER_TITLE_FIRST_SCREEN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        termsOfUseLabel.text = "TERMS_OF_USE_NEW_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {

            termsOfUseTrailing.constant = 13
            termsOfUseLeading.constant = 13
            termsOfUseLabel.textAlignment = .right
            termsOfUseLabel.numberOfLines = 0

        }
        else
        {

            termsOfUseTrailing.constant = 60
            termsOfUseLeading.constant = 60
            termsOfUseLabel.numberOfLines = 2
            termsOfUseLabel.textAlignment = .center

        }
        
        let attrString1: NSMutableAttributedString = NSMutableAttributedString(string: "TERMS_OF_USE_NEW_TEXT1".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        let attrString2: NSMutableAttributedString = NSMutableAttributedString(string: "TERMS_OF_USE_NEW_TEXT2".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        attrString2.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.sharedInstance.color3, range: NSMakeRange(0 , attrString2.length))
        attrString1.append(attrString2)
        termsOfUseLabel.attributedText = attrString1
        
        let backView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        
        let titleImageView: UIImageView = UIImageView(image: UIImage(named: "3.png"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: titleImageView.frame.size.width * 0.8, height: 40)
        // Here I am passing origin as (45,5) but can pass them as your requirement.
        backView.addSubview(titleImageView)
        
        self.navigationItem.titleView = backView
        
        btnSync.isCecked = true
        scrRegister.isScrollEnabled = false
        fullName.delegate = self
        txtPhone.delegate = self
        txtEmail.delegate = self
        dateBorn.delegate = self
        if DeviceType.IS_IPHONE_6{
            lblRead.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            attrs = [ convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: "OpenSansHebrew-Bold", size: 14)!,
                      convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : Colors.sharedInstance.color3,
                      convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : 1]
            btnRegulations.setAttributedTitle(attributedStringsUserExist, for: UIControl.State())
            //JMODE lblRead btnregulations
            lblGetP.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblSync.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            orlabel.font = UIFont(name: "OpenSansHebrew-Bold", size: 18)
          //  lblMessage.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            
        }
        else
        {
            if DeviceType.IS_IPHONE_6P
            {
                lblRead.font = Colors.sharedInstance.fontText3
                attrs = [ convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: "OpenSansHebrew-Bold", size: 17)!,
                          convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : Colors.sharedInstance.color3,
                          convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : 1]
                btnRegulations.setAttributedTitle(attributedStringsUserExist, for: UIControl.State())
                lblSync.font = Colors.sharedInstance.fontText3
                  orlabel.font = UIFont(name: "OpenSansHebrew-Bold", size: 18)
            }
            else
            {
                
                if DeviceType.IS_IPHONE_5{
                    
                    lblRead.font = Colors.sharedInstance.fontText4
                    lblGetP.font = Colors.sharedInstance.fontText4
                    lblSync.font = Colors.sharedInstance.fontText4
                    
                    fullName.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
                    email.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
                    txtPhone.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
                    dateBorn.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
                    //lblMessage.font = UIFont(name: "OpenSansHebrew-Light", size: 13)
                      orlabel.font = UIFont(name: "OpenSansHebrew-Bold", size: 18)
                }
                
            }
        }
         orlabel.font = UIFont(name: "OpenSansHebrew-Bold", size: 18)
        lblSync.text = "SYNC_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        // btnRegister.setTitle("REGISTER_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), forState: .Normal)
        btnRegister.setTitle("CONTINUE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        orlabel.text = "OR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        reqField.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
       // lblMessage.text = "ADD_ASS_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        
     
        dp.backgroundColor = Colors.sharedInstance.color1
        dp.setValue(UIColor.white, forKeyPath: "textColor")
        dp.setValue(0.8, forKeyPath: "alpha")
        dp.datePickerMode = UIDatePicker.Mode.date
        dp.setValue(false, forKey: "highlightsToday")
        dp.addTarget(self, action: #selector(RegisterViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
        validEmal.isHidden = true
        validPhone.isHidden = true
        reqField.isHidden = true

        
        fullName.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        txtEmail.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        txtPhone.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        dateBorn.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        
        img.isUserInteractionEnabled = true
        
        dp.isHidden = true
        let gregorian: Foundation.Calendar = Foundation.Calendar(identifier: .gregorian)
        let currentDate: Date = Date()
        var components: DateComponents = DateComponents()
        
        components.year = -80
        let minDate: Date = (gregorian as NSCalendar).date(byAdding: components, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        
        components.year = -0
        let maxDate: Date = (gregorian as NSCalendar).date(byAdding: components, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        
        self.dp.minimumDate = minDate
        self.dp.maximumDate = maxDate
        
        lblRead.layer.cornerRadius = 10
       // view.bringSubviewToFront(btnRegulations)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
     //   self.imgRegister.backgroundColor = UIColor(patternImage: UIImage(named: "client.jpg")!)
        self.view.addBackground()
        //init properties to connect to google+
        
//        Global.sharedInstance.googleSignIn = GPPSignIn.sharedInstance()
//        Global.sharedInstance.googleSignIn.clientID = "428242712697-jblmgroafen9ln2nh7v639dn16i3vdqr.apps.googleusercontent.com"
//        //before the new key in 31-10-16
//        //Global.sharedInstance.googleSignIn.clientID = "684155944655-dc4qpsliein6tk7al78m1gfo0b1blkfc.apps.googleusercontent.com"
//        Global.sharedInstance.googleSignIn.shouldFetchGoogleUserEmail = true
//        Global.sharedInstance.googleSignIn.shouldFetchGoogleUserID = true
//        Global.sharedInstance.googleSignIn.shouldFetchGooglePlusUser = true
//
//        Global.sharedInstance.googleSignIn.scopes = [kGTLAuthScopePlusLogin]
//        Global.sharedInstance.googleSignIn.scopes = ["profile"]
//        Global.sharedInstance.googleSignIn.delegate = self
//

        
     //   view.bringSubviewToFront(btnRegulations)
        
        arr = ["FIRST_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE),"LAST_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE),"PHONE_NUMBER".localized(LanguageMain.sharedInstance.USERLANGUAGE),"MAIL_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE),"DATEBURN_LBL".localized(LanguageMain.sharedInstance.USERLANGUAGE),"IMAGEUPLOAD_LBL".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
        
        if (FBSDKAccessToken.current() == nil)
        {
              print("Not logged in..")
        }
        else
        {
              print("Logged in..")
        }
        btnFaceBookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
      //JMODE btnFaceBookLoginButton.frame = CGRectMake(30, 25, 80, 30)

        btnFaceBookLoginButton.delegate = self
     //   btnFaceBookLoginButton.frame = CGRect(x: 25, y: 25, width: 177, height: 38)
        btnFaceBookLoginButton.backgroundColor = UIColor.clear
    
        let buttonText = NSAttributedString(string: "LOGIN_WITH_FACEBOOK".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        btnFaceBookLoginButton.setAttributedTitle(buttonText, for: .normal)
//        btnFaceBookLoginButton.setImage(nil, forState: UIControlState.Normal)
//        btnFaceBookLoginButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
        
//        let buttonText = NSAttributedString(string: "LOGIN_WITH_FACEBOOK".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//        btnFaceBookLoginButton.setAttributedTitle(buttonText, for: .normal)

        
        lblGetP.text = "AGREE_GET_ADVERTISEMENTS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
      //  btnRegulations.setTitle("REGULATION".localized(LanguageMain.sharedInstance.USERLANGUAGE), forState: .Normal)
        
      //  lblRegisterBusiness.text = "REGISTER_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        ///for underline of buttons
        ///----------------------------------------------
       /* let buttonTitleStr = NSMutableAttributedString(string:"REGULATION".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:attrs)
        attributedStringsUserExist.appendAttributedString(buttonTitleStr)
       btnRegulations.setAttributedTitle(attributedStringsUserExist, forState: .Normal)
       */
         btnRegulations.isHidden = true
        // lblRead.text = "READCONDITIONOK".localized(LanguageMain.sharedInstance.USERLANGUAGE) + "TERMSOFUSE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        //        var stringREAD = "READCONDITIONOK".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        //        var stringTERMS = "TERMSOFUSE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblRead.layer.cornerRadius = 10
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: "READCONDITIONOK".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: lblRead.textColor, range: NSMakeRange(0, attrString.length))
        let mycolor : UIColor =   UIColor(red: 244.0/255, green: 149.0/255, blue: 114.0/255, alpha: 1.0)
        let descString: NSMutableAttributedString = NSMutableAttributedString(string:  "TERMSOFUSE".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        descString.addAttribute(NSAttributedString.Key.foregroundColor, value: mycolor, range: NSMakeRange(0, descString.length))
     
        attrString.append(descString);
        lblRead.attributedText = attrString

        lblRead?.isUserInteractionEnabled = true
        let tapOnTERMS:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tothetermsofuse))
        lblRead.addGestureRecognizer(tapOnTERMS)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
//            self.btnClose.setImage(leftarrowback, for: UIControlState())
            self.txtEmail.contentHorizontalAlignment = .right
            self.txtPhone.contentHorizontalAlignment = .right
            self.txtLastName.contentHorizontalAlignment = .right
            
            
            
            
        }
        else {
//            self.btnClose.setImage(leftarrowback, for: UIControlState())
            self.txtEmail.contentHorizontalAlignment = .left
            self.txtPhone.contentHorizontalAlignment = .left
            self.txtLastName.contentHorizontalAlignment = .left
          
         
        }
//        self.btnClose.setImage(leftarrowback, for: UIControlState())
        
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.btnClose.transform = scalingTransform
            self.backImg.transform = scalingTransform
        }
        
//        btnClose.imageView!.contentMode = .scaleAspectFit
        
            NotificationCenter.default.addObserver(self, selector: #selector(self.blockBtnInteraction(note:)),name:Notification.Name("BlockRegisterButton"), object: nil)
        
        loginBtn.backgroundColor = UIColor.clear
//        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.borderWidth = 2
        loginBtn.layer.borderColor = UIColor(red:0.14, green:0.29, blue:0.73, alpha:1.0).cgColor
        loginBtn.setTitleColor(UIColor(red:0.14, green:0.29, blue:0.73, alpha:1.0), for: .normal)
       loginLabel.text = "ALREADY_REGISTERED_AGAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        loginLabel.textColor = UIColor(red:0.14, green:0.29, blue:0.73, alpha:1.0)
        
    loginBtn.setTitle("", for: .normal)
    
    self.customerProfilePic.contentMode = .scaleAspectFit
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)

    }
    
    @IBAction func languageAction(_ sender: Any)
    {
        languageDelegate.openLanguage()
    }
    
    @objc func blockBtnInteraction(note : NSNotification)
    {
        print("butonul a fost blocat sau deblocat")
        if self.btnRegister.isUserInteractionEnabled == true
        {
            self.btnRegister.isUserInteractionEnabled = false
        }
        else
        {
            self.btnRegister.isUserInteractionEnabled = true
        }
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:2)
        let USERDEF  = Global.sharedInstance.defaults
        print( USERDEF.value(forKey:"AppleLanguages"))
        
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            dateBorn.textAlignment = .right
            txtLastName.textAlignment = .right
            fullName.textAlignment = .right
            txtEmail.textAlignment = .right
            txtPhone.textAlignment = .right
          
        }
        else
        {
            dateBorn.textAlignment = .left
            txtLastName.textAlignment = .left
            fullName.textAlignment = .left
            txtEmail.textAlignment = .left
            txtPhone.textAlignment = .left
        }
        
        btnClose.isUserInteractionEnabled = false
        btnClose.isHidden = true
        backImg.isUserInteractionEnabled = false
        backImg.isHidden = true
        
        
        if Global.sharedInstance.defaults.integer(forKey: "didShowRegisterPopUp") == 0
        {
            let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
            //   viewpopupBeforeRegisterUser = storyboardtest.instantiateViewController(withIdentifier: "popupBeforeRegisterUser") as! popupBeforeRegisterUser
            viewpopupBeforeRegisterUser = storyboardtest.instantiateViewController(withIdentifier: "popupfirstRegisterUser") as! popupfirstRegisterUser
            if self.iOS8 {
                viewpopupBeforeRegisterUser.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            } else {
                viewpopupBeforeRegisterUser.modalPresentationStyle = UIModalPresentationStyle.currentContext
            }
            
            self.present(viewpopupBeforeRegisterUser, animated: true, completion: nil)
            
            Global.sharedInstance.defaults.set("1", forKey: "didShowRegisterPopUp")
            Global.sharedInstance.defaults.synchronize()
        }


    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            dateBorn.textAlignment = .right
            txtLastName.textAlignment = .right
            fullName.textAlignment = .right
            txtEmail.textAlignment = .right
            txtPhone.textAlignment = .right
           
        }
        else
        {
            dateBorn.textAlignment = .left
            txtLastName.textAlignment = .left
            fullName.textAlignment = .left
            txtEmail.textAlignment = .left
            txtPhone.textAlignment = .left
        }

        self.navigationItem.setHidesBackButton(true, animated:false)
        
        var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicForDefault["supplierRegistered"] = false as AnyObject
        
        Global.sharedInstance.defaults.set(dicForDefault, forKey: "isSupplierRegistered")
        
        var dic1ForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic1ForDefault["nvSupplierName"] = "" as AnyObject
        Global.sharedInstance.defaults.set(dic1ForDefault, forKey: "supplierNameRegistered")
        
        dic2ForDefault["nvClientName"] = "" as AnyObject
        Global.sharedInstance.defaults.set(dic2ForDefault, forKey: "currentClintName")
        
        
        Colors.sharedInstance.addTopBorderWithColor(Colors.sharedInstance.color1, width: 1, any: viFirstName)
        Colors.sharedInstance.addTopAndBottomBorderWithColor(Colors.sharedInstance.color1, width: 1, any: viPhone)
        Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color1, width: 1, any: viEmail)
      //  Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color1, width: 1, any: viDateBorn)
      //  Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color1, width: 1, any: viImage)
//        btnFaceBookLoginButton.setBackgroundImage(UIImage(named: "40.png"), forState: .Normal)
        



        
        if self.img.isHidden
        {
            print("img is hidden")
        }
        else
        {
            print("img is not hidden")
        }
       
    }
    
    override func viewDidLayoutSubviews() {
        
        if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P{
            scrRegister.contentSize.height = 700
        }
        else
        {
            if DeviceType.IS_IPHONE_5{
                scrRegister.contentSize.height = 600
            }
            else{
                scrRegister.contentSize.height = 550
                
            }
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func tothetermsofuse() {
        let vcRegulations = self.storyboard?.instantiateViewController(withIdentifier: "RegulationsViewController") as! RegulationsViewController
        vcRegulations.delegate = self
        
    //    vcRegulations.modalPresentationStyle = UIModalPresentationStyle.Custom
        if self.iOS8 {
            vcRegulations.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            vcRegulations.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        

        self.present(vcRegulations, animated: true, completion: nil)
    }
    //MARK: - Camera
    
    /// ImagesCamera() - this function open images file
    /// or camera to get an image.
    func ImagesCamera()
    {
        let settingsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertController.Style.actionSheet)
        
        settingsActionSheet.addAction(UIAlertAction(title: "OPEN_CAMERA".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default, handler: { (UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        /// to open images file
        settingsActionSheet.addAction(UIAlertAction(title:"OPEN_ALBUM".localized(LanguageMain.sharedInstance.USERLANGUAGE), style:UIAlertAction.Style.default, handler:{ (UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
//                self.showResizablePicker(self.viImage)
                
            }
            }
            
            ))
        settingsActionSheet.addAction(UIAlertAction(title:"CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style:UIAlertAction.Style.cancel, handler:nil))
        self.present(settingsActionSheet, animated:true, completion:nil)
        
    }
    
    func showCamera()
    {
        Global.sharedInstance.isCamera = true
        ImagesCamera()
    }
    
    
    // MARK: - login in facebook
    //====================login in facebook=======================
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        if error == nil
        {
            
              print("facebook Login complete.")
            
            if(FBSDKAccessToken.current() != nil) {
                print(FBSDKAccessToken.current) 
                if let _ = FBSDKAccessToken.current().tokenString
                {
                print(FBSDKAccessToken.current().tokenString)
                }
                returnUserData()
            }
        }
        else
        {
              //\\print(error.localizedDescription)
        }
//        btnFaceBookLoginButton.setBackgroundImage(UIImage(named: "40.png"), forState: .Normal)
//        btnFaceBookLoginButton.setBackgroundImage(UIImage(named: "40.png"), forState: .Selected)
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
//        btnFaceBookLoginButton.setBackgroundImage(UIImage(named: "40.png"), forState: .Normal)
          print("facebook User logged out...")
//        btnFaceBookLoginButton.setBackgroundImage(UIImage(named: "40.png"), forState: .Normal)
//        btnFaceBookLoginButton.setBackgroundImage(UIImage(named: "40.png"), forState: .Selected)
        
    }
    
    func returnUserData()
    {
//        btnFaceBookLoginButton.setBackgroundImage(UIImage(named: "40.png"), forState: .Normal)
        isLoginInFaceBook = true
       // let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,id,name, first_name, last_name,birthday"])
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,id,name, first_name, last_name"])
        //["fields":"email,name,birthday"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            print("fetched user: \(String(describing: result))")
            if let _ = result as? Dictionary<String,AnyObject> {
            let myuserdict = result as! Dictionary<String,AnyObject>
//                fetched user: Optional({
//                "first_name" = Dormeo;
//                id = 137606440515908;
//                "last_name" = Costelo;
//                name = "Dormeo Costelo";
//                })
                var userName:String = ""
                var eMail:String = ""
                var firstName:String = ""
                var lastName:String = ""
                var facebookID:String = ""
             //   var pictureURL:String = ""
            if let _:String = myuserdict["name"] as? String {
            userName  = myuserdict["name"] as! String
            print("User Name is: \(userName)")
            }
                 if let _:String = myuserdict["email"] as? String {
                    eMail  = myuserdict["email"] as! String
                    print("email is: \(eMail)")
                }
                if let _:String = myuserdict["first_name"] as? String {
                    firstName  = myuserdict["first_name"] as! String
                    print("firstName is: \(firstName)")
                }
                if let _:String = myuserdict["last_name"] as? String {
                    lastName  = myuserdict["last_name"] as! String
                    print("lastName is: \(lastName)")
                }
                if let _:String = myuserdict["id"] as? String {
                    facebookID  = myuserdict["id"] as! String
                    print("facebookID is: \(facebookID)")
                }
//                if facebookID.count > 0 {
//                    pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
//                    let url = URL(string:pictureURL)
//                    let data=try? Data(contentsOf: url!)
//                    let image=UIImage(data: data!)
//                }
            self.fullName.text = firstName as String + " " + (lastName as String)
            self.txtLastName.text = lastName as String
            self.email.text = eMail as String
            self.reqField.isHidden = true
            self.validPhone.isHidden = true
            self.validEmal.isHidden = true
          
            }
        })
//        btnFaceBookLoginButton.setBackgroundImage(UIImage(named: "40.png"), forState: .Normal)
//        btnFaceBookLoginButton.setBackgroundImage(UIImage(named: "40.png"), forState: .Selected)
        
    }
    
    // MARK: - DatePicker
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateServer = sender.date
        dateBorn.text = dateFormatter.string(from: sender.date)
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        cell2 = tblDetails.cellForRow(at: indexPathDate) as? PersonalDetailsTableViewCell
        
        cell2!.txtfDetails.text = dateFormatter.string(from: sender.date)
        
    }
    // MARK: - KeyBoard
    
    //=======================KeyBoard================
    
    
    @objc func dismissKeyboard() {
        dp.isHidden = true
        //tableView.hidden = true
        view.endEditing(true)
    }
    
    // MARK: - TextField
    //=========================TextField==============
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch(textField){
        case(fullName):
            txtPhone.becomeFirstResponder()

        case(txtPhone):
            txtEmail.becomeFirstResponder()
        case(txtEmail):
            dismissKeyboard()
        default:
            fullName.becomeFirstResponder()
        }
        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        Global.sharedInstance.isRegisterClientClick = false
        
        if textField == dateBorn
        {
            textField.inputView = UIView()
            dp.isHidden = false
        }
        else if textField == fullName
        {
            self.reqField.isHidden = true
        }
        else if textField == txtPhone
        {
            self.validPhone.isHidden = true
        }
        else
        {
            dp.isHidden = true
        }
        
        checkValidation(textField)
    }
    
    
    func myTargetFunction(_ textField: UITextField) {
        // user touch field
        if textField == dateBorn
        {
            if dp.isHidden == true
            {
                textField.inputView = UIView()
                dp.isHidden = false
            }
            else
            {
                dp.isHidden = true
            }
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        fDidBegin = false
        timer?.invalidate()
        timer = nil
        if true {
            
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.doDelayed), userInfo: string, repeats: false)
            
            
            var startString = ""
            if (textField.text != nil)
            {
                startString += textField.text!
            }
            startString += string
            
            
            
            if textField == txtPhone
            {
                print("smart paste: \(textField.text)")
                var cleanNumber:String = ""
                if string.count > 1
                {
                    
                    var cleanedString: String = (string.components(separatedBy: CharacterSet(charactersIn: "0123456789-+()").inverted) as NSArray).componentsJoined(by: "")
                    print("cleaned string \(cleanedString)")
                    //            cleanedString = "+972505119731" // modedphone    String    "+972505119731"
                    if cleanedString != ""
                    {
                        if cleanedString.count > 3 {
                        let first3 = cleanedString.substring(to:cleanedString.index(cleanedString.startIndex, offsetBy: 3))
                        if first3 == "009"
                        {
                            let start = cleanedString.index(cleanedString.startIndex, offsetBy: 2)
                            let end = cleanedString.endIndex
                            let range = start..<end
                            
                            let mySubstring = cleanedString[range]
                            
                            cleanedString = "+" + mySubstring
                            
                        }
                        }
                        cleanNumber = cleanPhoneNumber(cleanedString)
                        print("smart paste cleaned string: \(cleanNumber)")
                    }
                    if cleanNumber.characters.count > 2 {
                        let numertocompare = cleanNumber
                        let index0 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 0)
                        let index1 = numertocompare.characters.index(numertocompare.startIndex, offsetBy: 1)
                        if numertocompare.characters.count != 10 || (numertocompare.characters[index0] != "0" || numertocompare.characters[index1] != "5")
                        {
                            Alert.sharedInstance.showAlert("ENTER_TEN_DIGITS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            //                                            ignore all bad numbers
                            
                            return false
                            
                        }
                        else
                        {
                            textField.text = cleanNumber
                            return false
                        }
                    }
                    
                    
                }
                
                if startString.characters.count > 10
                {    txtPhone.resignFirstResponder()
                    Alert.sharedInstance.showAlert("ENTER_TEN_DIGITS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                    return false
                }
                    
                else
                {
                    //                    textField.text = cleanNumber
                    return true
                }
                

            }
            
            if textField == txtEmail
            {


                if textField.text?.count > 20
                {
                    
                    showAlertDelegateX("ENTER_ONLY20_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    let result = String(textField.text!.dropLast((textField.text!.count - 20)))
                    textField.text = result
                      //  textField.text!.remove(at: textField.text!.index(before: textField.text!.endIndex))
                    
                    
                    return false
                }
                else
                {
                    return true
                }
            }
            
            if textField == fullName
            {
                if textField.text?.count > 20
                {
                    showAlertDelegateX("ENTER_ONLY20_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                   // textField.text!.remove(at: textField.text!.index(before: textField.text!.endIndex))
                    let result = String(textField.text!.dropLast((textField.text!.count - 20)))
                    textField.text = result
                    return false
                }
                else
                {
                    return true
                }
                
            }
            

            
            
            
        }
        return true
    }
    
    
    func cleanPhoneNumber(_ nvPhone:String) -> String {
        var  nvTmpPN2:String = ""
        var modedphone = nvPhone
        
        if  nvPhone != ""
        {
            //add to check if number has country code
            do {
                let phoneNumber = try phoneNumberKit.parse(nvPhone)
                let phoneNumberCustomDefaultRegion = try phoneNumber.countryCode
                if phoneNumberCustomDefaultRegion != 0 {
                    print ("phoneNumberCustomDefaultRegion \(phoneNumberCustomDefaultRegion)")
                    let newString = modedphone.stringByReplacingFirstOccurrenceOfString(target: String(phoneNumberCustomDefaultRegion), withString: "0")
                    modedphone = newString
                    print("formated number is \(modedphone)")
                }
            }
            catch {
                print("Generic parser error")
            }
            for char in (modedphone.characters)
            {
                if (char >= "0" && char <= "9") || char == "*"
                {
                    let c:Character = char
                    nvTmpPN2 = nvTmpPN2 + String(c)
                }
            }
        }
        
        
        
        return nvTmpPN2
    }
    
    
    @objc func doDelayed(_ t: Timer) {
        if fDidBegin == true
        {
            fDidBegin = false
        }
        else
        {
            
            dismissKeyboard()
        }
        timer = nil
    }
    
    func getHints(_ timer: Timer) {
          print("Hints for textField: \(timer.userInfo!)")
    }
    
    //    func textInputMode() -> UITextInputMode {
    //        if isEmailField {
    //            for inputMode: UITextInputMode in UITextInputMode.activeInputModes() {
    //                if (inputMode.primaryLanguage == "en-US") {
    //                    return inputMode
    //                }
    //            }
    //        }
    //        return super.textInputMode()
    //    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        fDidBegin = true
        dismissKeyboard()
        return true;
    }
    
   @objc func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch(textField){
        case fullName:
            
            //lblFullName.textColor = UIColor.blackColor()
            dp.isHidden = true
            
        case txtLastName:
            
            //lblLastName.textColor = UIColor.blackColor()
            dp.isHidden = true
            
            //        case txtAddress:
            //
            //            //            if txtAddress.text == ""
            //            //            {
            //            //                  }
            //            //lblAddress.textColor = UIColor.blackColor()
            //            dp.hidden = true
            ////            }
            
            
        case txtPhone:
            validPhone.isHidden = true
            //lblPhone.textColor = UIColor.blackColor()
            dp.isHidden = true
            
        case dateBorn:
            dp.isHidden = true
            
            
        default:
            validEmal.isHidden = true
            //lblEmail.textColor = UIColor.blackColor()
            dp.isHidden = true
        }
    }
    
    // MARK: -Login in GooglePlus
    //=======================Login in GooglePlus======================
    
    
    // GooglePlush Delegate Methods
    //the method called from the func in appDelegate:"openURL" after clicked on "allow" button in the screen and it retrieve the details of the user from GooglePlush

    func didDisconnectWitherror(_ error:Error?){
          //\\print(error)
    }
    
    //MARK: - Validation
    
    ///פונקציה זו בודקת את תקינות השדות
    ///מקבלת את הtextField הנוכחי שעליו נמצא הפוקוס,
    ///וכן flag  לבדיקה ע״י מי הפונקציה נקראה:1=נקראה ע״י לחיצה על הרשם,2=נקראה ע״י כניסה לאחד מהשדות
    func checkValidation(_ textField:UITextField)
    {
        ///* הערה:בכל אחת מהבדיקות בדקתי גם האם הטקסטפילד לא שווה אלי בעצמי למקרה שהטקסטפילד לא תקין והא היה האחרון שערכתי ועכשיו אני רוצה להכנס אליו שוב לתקן אותו
        
        
        //====================בדיקה מי ה-textField הקודם שמולא כדי לבדוק את תקינותו==============================
        
        ///---------------------------------------בדיקת השם------------------------
        
        if flag_FullName == true && textField != fullName && fullName.text != ""
        {
            validationName()
            
            flag_FullName = false
        }
            
            ///-----------------------------בדיקת השם משפחה---------------------------
            
     /*   else if flag_LastName == true && textField != txtLastName && txtLastName.text != ""
        {
            validationLastName()
            
            flag_LastName = false
        }
            */
            ///-----------------------------בדיקת הטלפון-----------------------
            
        else if flag_Phone == true && textField != txtPhone && txtPhone.text != ""
        {
            validationPhone()
            
            flag_Phone = false
        }
            ///--------------------בדיקת המייל------------------------
            
//        else if flag_Email == true && textField != txtEmail && txtEmail.text != ""
//        {
//            validationEmail()
//
//            flag_Email = false
//        }
        
        //=======================================================================
        
        //בדיקה מי ה-textField הנוכחי שנבחר
        //והדלקת דגל מתאים,כדי לדעת בפעם הבאה מי היה הקודם לצורך בדיקת תקינות
        switch textField
        {
        case fullName:
            flag_FullName = true
            //jmode 
            flag_LastName = true
            break
            
     /*   case txtLastName:
            flag_LastName = true
            break
         */
        case txtPhone:
            flag_Phone = true
            break
            
        case txtEmail:
            flag_Email = true
            break
            
        case dateBorn:
            flag_Date = true
            break
            
        default:
            break
        }
    }
    
    //for first and last name
    func isValidName(_ input: String) -> Bool {
        var numSpace = 0
        for chr in input.characters {
            print ("verifychr \(chr)")
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z")  && !(chr >= "א" && chr <= "ת") && !(chr >= "0" && chr <= "9") && chr != " " && chr != "’" && chr != "‘"  && chr != "“" && chr != "'" && chr != "\"" && chr != "”" && chr != "“" && chr != "”" && chr != "׳" && (input.isRussiantext(title: input) == false) )
            {
                return false
            }
            if chr == " "
            {
                numSpace += 1
            }
        }
        if numSpace == input.characters.count || numSpace == input.characters.count - 1// אם יש רק רווחים או רק אות אחת והשאר רווחים
        {
            return false
        }
        else if numSpace > 0
        {
            //first clean double empty spaces or more
            let bar = input
                .components(separatedBy: " ")
                .filter { !$0.isEmpty }
                .joined(separator: " ")
           
            let arr = bar.components(separatedBy: " ")
            for word in arr {
                 print("word \(word)")
                if word.characters.count == 1
                {
                    return false
                }
            }
        }
        return true
    }
    
    func isValidAddress(_ input: String) -> Bool {
        for scalar in (txtAddress.text?.unicodeScalars)! {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F:   // Variation Selectors
                return false
            default:
                continue
            }
        }
        return true
    }
    //JMODE firstlastname
    func validationName()
    {
        isCheckNameEnd = true
        let fullNameVerify = fullName.text! as String
        let bar = fullNameVerify
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }
            .joined(separator: " ")
      
        let fullNameArr = bar.components(separatedBy: " ")
        let myArray : NSMutableArray = []
        let size = fullNameArr.count
        //\\print ("size of my arr \(size)")
        var firstNameVerify:String = ""
        var lastNameVerify:String = ""
        if(size > 1) {
            for item in fullNameArr {
                if(item.characters.count > 0) {
                   print("Found \(item)")
                    myArray.add(item)
                }
               
            }
            let sizemutablearray = myArray.count
            for item in myArray {
                      print("Found myArray\(item)")
            }
                if(sizemutablearray > 1 ) {
                    if let _:String = myArray.object(at: 0) as? String {
                        firstNameVerify = myArray.object(at: 0) as! String
                        
                    }
                    if let _:String = myArray.object(at: 1) as? String {
                        lastNameVerify = myArray.object(at: 1) as! String
                        
                    }

                    self.txtLastName.text = lastNameVerify
                }
            
        
            print("firstNameVerify\(firstNameVerify)")
            print("lastNameVerify\(lastNameVerify)")
      
       

            if fullName.text!.characters.count == 1 || isValidName(fullName.text!) == false ///שם פרטי
            {
                if(firstNameVerify.characters.count == 0  || isValidName(firstNameVerify) == false || isValidName(lastNameVerify) == false || lastNameVerify.characters.count == 0 ) {
                    reqField.text = "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    reqField.isHidden = false
                    Global.sharedInstance.isValid_FullName = false
                }
            }
            else
            {
                Global.sharedInstance.isValid_FullName = true
                txtLastName.text = lastNameVerify
            }
        
        if Global.sharedInstance.isRegisterClientClick == true || Global.sharedInstance.isRegisterProviderClick == true
        {
            
          /*  if txtLastName.text != ""
            {
                self.validationLastName()
            }
            else */
            if txtPhone.text != ""
            {
                self.validationPhone()
            }
//            else if txtEmail.text != ""
//            {
//                self.validationEmail()
//            }
            else
            {
                self.validToRegister()
            }
            }
        } else {
            reqField.text = "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            reqField.isHidden = false
            Global.sharedInstance.isValid_FullName = false
        }
    }
    
    
    func validationPhone()
    {
        var flag = true
        arrGoodPhone = []
        var dicPhone:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
     //JMODE 12.01.2018
        dicPhone["nvPhone"] = txtPhone.text as AnyObject
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false//if there is connection
        {
             self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.CheckPhoneValidity(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                 self.generic.hideNativeActivityIndicator(self)
                self.isCheckPhoneEnd = true
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if RESPONSEOBJECT["Result"] as! Int == 0 //קיים
                {
                    self.ISSYNCCONTACT = false
                    self.validPhone.isHidden = false
                    self.validPhone.text = "PHONE_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    Global.sharedInstance.isValid_Phone = false
                }
                else  if RESPONSEOBJECT["Result"] as! Int == 2 // this was sync by contacts and have response 2 and status 26 in database
                {
                    Global.sharedInstance.isValid_Phone = true
                    self.ISSYNCCONTACT = true
                }
                else  if RESPONSEOBJECT["Result"] as! Int == 1 //לא קיים
                {
                    Global.sharedInstance.isValid_Phone = true
                    self.ISSYNCCONTACT = false
                }
                let index0 = self.txtPhone.text?.characters.index((self.txtPhone.text?.startIndex)!, offsetBy: 0)
                let index1 = self.txtPhone.text?.characters.index((self.txtPhone.text?.startIndex)!, offsetBy: 1)
                if self.txtPhone.text?.characters.count < 10 || (self.txtPhone.text?.characters[index0!] != "0" || self.txtPhone.text?.characters[index1!] != "5")
                {
                    Global.sharedInstance.isValid_Phone = false
                    self.validPhone.text = "PHONE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    self.validPhone.isHidden = false
                    
                }
                
                //בדיקה שהטלפון תקין
                let specialCharacterRegEx  = "[*]?[0-9]+"
                let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
                let specialresult = texttest2.evaluate(with: self.txtPhone.text)
                
                
                if !specialresult && self.txtPhone.text != ""// לא תקין
                {
                    if self.txtPhone.text?.characters.count > 2 {
                     
                        let numertocompare = self.txtPhone.text
                        let index0 = numertocompare!.characters.index(numertocompare!.startIndex, offsetBy: 0)
                        let index1 = numertocompare!.characters.index(numertocompare!.startIndex, offsetBy: 1)
                        if self.txtPhone.text!.characters.count != 10 || (self.txtPhone.text?.characters[index0] != "0" || self.txtPhone.text?.characters[index1] != "5") {
                     
                            self.validPhone.text = "PHONE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                            self.validPhone.isHidden = false
                            self.txtPhone.text = ""
                            Global.sharedInstance.isValid_Phone = true
                            flag = false
                           return
                        }
                    }
                    for char in (self.txtPhone.text?.characters)!
                    {
                        
                        if (char >= "0" && char <= "9") || char == "*"
                        {
                            let c:Character = char
                            self.arrGoodPhone.append(c)
                        }
                            
                        else
                        {
                            self.validPhone.text = "PHONE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                            self.validPhone.isHidden = false
                            self.txtPhone.text = ""
                            Global.sharedInstance.isValid_Phone = true
                            flag = false
                            break
                        }
                    }
                    
                    if flag == true
                    {
                        
                        self.txtPhone.text = ""
                        for i in 0 ..< self.arrGoodPhone.count
                        {
                            self.txtPhone.text = self.txtPhone.text! + String(Array(self.arrGoodPhone)[i])
                        }
                        Global.sharedInstance.isValid_Phone = true
                    }
                }
                    
                else
                {
                    //אם לא היה תקין בגלל השרת
                    if Global.sharedInstance.isValid_Phone != false
                    {
                        Global.sharedInstance.isValid_Phone = true
                    }
                }
                
                ///אם הגיעו מהכפתור של הרשם
                if Global.sharedInstance.isRegisterClientClick == true || Global.sharedInstance.isRegisterProviderClick == true
                {
//                    if self.txtEmail.text != ""
//                    {
//                        self.validationEmail()
//                    }
//                    else
//                    {
                        if self.ISSYNCCONTACT == false {
                        self.validToRegister()
                        } else {
                        self.validToUpdateUser()
                        }
//                    }
                }
                }
                
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                      print("Error: ", Error!.localizedDescription)
                     self.generic.hideNativeActivityIndicator(self)
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
    func validationEmail()
    {
        var dicMail:Dictionary<String,String> = Dictionary<String,String>()
        dicMail["nvEmail"] = txtEmail.text
        
        ///בדיקה שהמייל לא קיים כבר במערכת
       self.generic.showNativeActivityIndicator(self)
        
        if Reachability.isConnectedToNetwork() == false
        {
             self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.CheckMailValidity(dicMail, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
               self.generic.hideNativeActivityIndicator(self)
                self.isCheckEmailEnd = true
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if RESPONSEOBJECT["Result"] as! Int == 0 //קיים
                {
                    self.validEmal.isHidden = false
                    self.validEmal.text = "MAIL_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    Global.sharedInstance.isValid_Email = false
                }
                else //לא קיים
                {
                    Global.sharedInstance.isValid_Email = true
                }
                
                ///בדיקה שהמייל תקין
                if !Validation.sharedInstance.mailValidation(
                    self.txtEmail.text!) && self.txtEmail.text != ""
                {
                    self.validEmal.isHidden = false
                    self.validEmal.text = "MAIL_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    
                    Global.sharedInstance.isValid_Email = false
                }
                else //תקין
                {
                    //אם לא היה תקין בגלל השרת
                    if Global.sharedInstance.isValid_Email != false
                    {
                        Global.sharedInstance.isValid_Email = true
                    }
                }
                
                ///אם הגיעו מהכפתור של הרשם יש לבדוק אם אפשר לעבור עמוד
                if Global.sharedInstance.isRegisterClientClick == true || Global.sharedInstance.isRegisterProviderClick == true
                {
                    
                    if self.ISSYNCCONTACT == false {
                        self.validToRegister()
                    } else {
                        self.validToUpdateUser()
                    }
                }
                }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                      print("Error: ", Error!.localizedDescription)
                     self.generic.hideNativeActivityIndicator(self)
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    func validToUpdateUser(){
       
            var x = 0
            
    
            
            if self.fullName.text == ""
            {
                self.reqField.isHidden = false
                
                self.reqField.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                x = 1
            }
        
//            if self.txtEmail.text == ""
//            {
//                self.validEmal.isHidden = false
//                self.validEmal.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//
//                x = 1
//            }
            if self.txtPhone.text == ""{
                self.validPhone.isHidden = false
                self.validPhone.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                
                x = 1
            }
            
   
//            if self.btnRead.isCecked == false && isCheckFromClickRegister == true
//            {
//                Alert.sharedInstance.showAlert("READING_ARTICLE_NOT_FILLED".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//                    , vc: self)
//                x = 1
//                isCheckFromClickRegister = false
//            }
        
            if !Global.sharedInstance.isValid_FullName   || !Global.sharedInstance.isValid_Phone /* || !Global.sharedInstance.isValid_Email */
            {
                x = 1
                if Global.sharedInstance.isRegisterClientClick == true
                {
                    Global.sharedInstance.isRegisterClientClick = false
                }
                else if Global.sharedInstance.isRegisterProviderClick == true
                {
                    Global.sharedInstance.isRegisterProviderClick = false
                }
                
            }
            
            ///-----------------------------------
            
            if x == 0 ///הכל תקין
            {

                var dicPhone:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                
                //JMODE 12.01.2018  
                dicPhone["nvPhone"] = txtPhone.text as AnyObject

                if Reachability.isConnectedToNetwork() == false
                {
//                    showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else
                {
                    //not get iuserid by phone
                    if Reachability.isConnectedToNetwork() == false//if there is connection
                    {
                        self.generic.hideNativeActivityIndicator(self)
//                        showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else
                    {
                        api.sharedInstance.CheckCustomerExistByPhone(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
                            self.isCheckPhoneEnd = true
                            if let _ = responseObject as? Dictionary<String,AnyObject> {
                                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                if let _ = RESPONSEOBJECT["Result"] as? Int {
                            print("numar verifica \(String(describing: RESPONSEOBJECT["Result"]))")
                            
                            if RESPONSEOBJECT["Result"] as! Int == 0//phone not found
                            {

                              //\\              self.txtPhone.text = "PHONE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                
                            } else
                            {
                                //since after number exist we must know which user is
                                self.updateUser(RESPONSEOBJECT["Result"] as! Int)
                            }
                                }
                            }
                            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                                print("Error: ", Error!.localizedDescription)
                                self.generic.hideNativeActivityIndicator(self)
//                                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        })

                    }
                }
        }
        

    }
    func updateUser(_ iUserid:Int) {
        print("update \(iUserid)")
        var dicGetCustomerDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicGetCustomerDetails["iUserId"] = iUserid as AnyObject
      //  var partialnumber = self.txtPhone.text!
        //removeAtIndex(self.startIndex)
//        let compareresult = String(partialnumber.characters.prefix(1))
//        let modified = partialnumber.replace(compareresult, withString:"")
//        let finalservernumber = "972" + modified
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetCustomerDetails(dicGetCustomerDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                {
                    let RESPONSEFULL  = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                    print("customer existent \(String(describing: RESPONSEOBJECT["Result"]?.description))")
                    var base64 = ""
                    if self.customerProfilePic.image != self.customerImage
                    {
                        base64 = Global.sharedInstance.setImageToString(self.customerProfilePic.image!)
                    }
                    else
                    {
                        base64 = ""
                    }
                    let fullNameVerify = self.fullName.text! as String
                    
                    let fullNameArr = fullNameVerify.components(separatedBy: " ")
                    let myArray : NSMutableArray = []
                    let size = fullNameArr.count
                    var firstNameVerify = ""
                    var lastNameVerify = ""
                    if(size > 1) {
                        for item in fullNameArr {
                            if(item.characters.count > 0) {
                                print("Found \(item)")
                                myArray.add(item)
                            }
                            let sizemutablearray = myArray.count
                            
                            if(sizemutablearray > 1 ) {
                                if let _:String = myArray.object(at: 0) as? String {
                                    firstNameVerify = myArray.object(at: 0) as! String
                                    
                                }
                                if let _:String = myArray.object(at: 1) as? String {
                                    lastNameVerify = myArray.object(at: 1) as! String
                                    
                                }
                            }
                        }
                    }

                    var nvPassword:String = ""
                    var nvVerification:String = ""
                    var nvNickName:String = ""
                    if let _:String = RESPONSEFULL["nvPassword"] as? String {
                        nvPassword = RESPONSEFULL["nvPassword"] as! String
                    }
                    if let _:String = RESPONSEFULL["nvVerification"] as? String {
                        nvVerification = RESPONSEFULL["nvVerification"] as! String
                    }
                    if let _:String = RESPONSEFULL["nvNickName"] as? String {
                        nvNickName = RESPONSEFULL["nvNickName"] as! String
                    }
                    let user:User = User(
                        _iUserId: iUserid,
                        _nvUserName: self.txtEmail.text!,
                        _nvFirstName: firstNameVerify,
                        _nvLastName: lastNameVerify,
                        _dBirthdate: self.dateServer,
                        _nvMail: self.txtEmail.text!,
                        _iCityType: 1,
                        _nvPhone: self.txtPhone.text!, //finalservernumber, //JMODE 12.01.2018
                        _nvPassword: nvPassword,
                        _nvVerification: nvVerification,
                        _bAutomaticUpdateApproval: self.btnGetP.isCecked,
                        _bDataDownloadApproval: true,
                        _bAdvertisingApproval: self.btnRead.isCecked,
                        _bTermOfUseApproval: true,
                        _iUserStatusType: 24,
                        _bIsGoogleCalendarSync:true,
                        _nvImage:base64,
                        _iCreatedByUserId: 1,
                        _iLastModifyUserId: 1,
                        _iSysRowStatus: 1,
                        _bIsManager : 0,
                        _nvDeviceToken : "",
                        _iStatus: 1,
                        _nvNickName: nvNickName
                )
                    Global.sharedInstance.currentUser = user
                    let DBHELPER = DataMasterProcessor()
                    var exista : Bool = false
                    let ceva = Global.sharedInstance.currentUser.iUserId
                    if ceva != 0
                    {
                        let telefonuser = String(ceva)
                        //do insert user
                        exista = DBHELPER.insertUser (telefonuser)
                        if(exista == true) {
                            //\\print ("USER SAVED IN DB   2")
                            
                        }
                    }
                    if Global.sharedInstance.currentUser.nvImage == ""
                    {
                        print("nu e poza buna - register view controller")
                    }
                    else
                    {
                        print("e poza buna - register view controller")
                    }
                    self.dic2ForDefault["nvClientName"] = Global.sharedInstance.currentUser.nvFirstName as AnyObject
                    Global.sharedInstance.defaults.set(self.dic2ForDefault, forKey: "currentClintName")
                    Global.sharedInstance.defaults.synchronize()
                    self.getsmscodeforupdate()
                }
                }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
            })
        }

    }
    func getsmscodeforupdate() {
        var dicPhone:Dictionary<String,String> = Dictionary<String,String>()
        //JMODE 12.01.2018
        dicPhone["nvPhoneNumber"] = self.txtPhone.text!
    //    var partialnumber = self.txtPhone.text!
//      
//        let compareresult = String(partialnumber.characters.prefix(1))
//        let modified = partialnumber.replace(compareresult, withString:"")
//        let finalservernumber = "972" + modified
//        dicPhone["nvPhoneNumber"] = finalservernumber
        if Reachability.isConnectedToNetwork() == false
        {
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetAndSmsValidationCode(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
              //  print("resp 3 \(responseObject)")
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"] as? Dictionary<String,AnyObject> {
                    let FULLRESPONSE = RESPONSEOBJECT["Error"] as! Dictionary<String,AnyObject>
                    
                    if let _ = FULLRESPONSE["ErrorCode"] as? Int {
                if FULLRESPONSE["ErrorCode"] as! Int == 0
                {
                    var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                    dicForDefault["verification"] = RESPONSEOBJECT["Result"]
                  //JMODE 12.01.2018   dicForDefault["phone"] = self.txtPhone.text!
                    dicForDefault["phone"] = self.txtPhone.text! as AnyObject
                    Global.sharedInstance.defaults.set(dicForDefault, forKey: "verificationPhone")
                    
                    if Global.sharedInstance.isRegisterClientClick == true || Global.sharedInstance.isRegisterProviderClick == true
                    {
                        Global.sharedInstance.isFromRegister = true
                        print("btn terms: \(self.btnRead.isCecked)")
                        print("fReadRegulation: \(Global.sharedInstance.fReadRegulation)")
                        print("isCheckFromClickRegister: \(self.isCheckFromClickRegister)")
                        
                        let viewCon:MessageVerificationViewController = self.storyboard?.instantiateViewController(withIdentifier: "MessageVerificationViewController") as! MessageVerificationViewController
                        viewCon.phone = self.txtPhone.text! //finalservernumber //JMODE 12.01.2018 self.txtPhone.text!
                        viewCon.ISSYNC = true
                        viewCon.verification = ((RESPONSEOBJECT["Result"] as? Int)?.description)!
                        viewCon.isProviderClickd = Global.sharedInstance.isRegisterProviderClick
                        viewCon.delegate = self
                        viewCon.isFromPersonalDetails = false
                        viewCon.delegateShowPhone = self
                        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                        self.present(viewCon, animated: true, completion: nil)
                    }
                }
                else
                {
                    Alert.sharedInstance.showAlert("ERROR_PHONE".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                }
                    }
                }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
            })
            }
        }
    func validToRegister()
    {
        var x = 0
        
        ///---------בדיקה שהשדות חובה מלאים
        
        if self.fullName.text == ""
        {
            self.reqField.isHidden = false
            
            self.reqField.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            x = 1
        }
        
//        if self.txtEmail.text == ""
//        {
//            self.validEmal.isHidden = false
//            self.validEmal.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//
//            x = 1
//        }
        if self.txtPhone.text == ""{
            self.validPhone.isHidden = false
            self.validPhone.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            
            x = 1
        }
        
        ///-----------------------------------
        
//        ///אם סמנו וי
//        if self.btnRead.isCecked == false && isCheckFromClickRegister == true
//        {
//            Alert.sharedInstance.showAlert("READING_ARTICLE_NOT_FILLED".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//                , vc: self)
//            x = 1
//            isCheckFromClickRegister = false
//        }
//
//        if self.btnRead.isCecked == false
//        {
//            x = 1
//        }
        
        if !Global.sharedInstance.isValid_FullName  /*|| !Global.sharedInstance.isValid_lName */ || !Global.sharedInstance.isValid_Phone /*|| !Global.sharedInstance.isValid_Address* || ! Global.sharedInstance.isValid_Email*/
        {
            x = 1
            if Global.sharedInstance.isRegisterClientClick == true
            {
                Global.sharedInstance.isRegisterClientClick = false
            }
            else if Global.sharedInstance.isRegisterProviderClick == true
            {
                Global.sharedInstance.isRegisterProviderClick = false
            }
            
        }
        
        ///-----------------------------------
        
        if x == 0 ///הכל תקין
        {
            var dicPhone:Dictionary<String,String> = Dictionary<String,String>()
            //now remove first 0
     //       var partialnumber = self.txtPhone.text!
//            //removeAtIndex(self.startIndex)
//            let compareresult = String(partialnumber.characters.prefix(1))
//            let modified = partialnumber.replace(compareresult, withString:"")
//           let finalservernumber = "972" + modified
           //JMODE 12.01.2018 dicPhone["nvPhoneNumber"] = self.txtPhone.text!
            dicPhone["nvPhoneNumber"] =  self.txtPhone.text!
            if Reachability.isConnectedToNetwork() == false
            {
//                showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            else
            {
                api.sharedInstance.GetAndSmsValidationCode(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                //     print("resp 4 \(responseObject)")
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]  as? Dictionary<String,AnyObject> {
                        let DICTErrorobj = RESPONSEOBJECT["Error"]  as! Dictionary<String,AnyObject>
                        if let _ = DICTErrorobj["ErrorCode"] as? Int {
                    if DICTErrorobj["ErrorCode"] as! Int == 0
                    {
                        var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                        dicForDefault["verification"] = RESPONSEOBJECT["Result"]
                        dicForDefault["phone"] = self.txtPhone.text! as AnyObject
                        Global.sharedInstance.defaults.set(dicForDefault, forKey: "verificationPhone")
                        var dateToServer = ""
                        if self.dateBorn.text != "" {
                            let arrDate_ddMMyyyy = Global.sharedInstance.cutStringBySpace(self.dateBorn.text!, strToCutBy: "/")
                            let arrDate_yyyMMdd:Array<String> = [arrDate_ddMMyyyy[2],arrDate_ddMMyyyy[1],arrDate_ddMMyyyy[0]]
                            
                            dateToServer = arrDate_yyyMMdd.joined(separator: "")
                        }
                        var base64 = ""
                        if self.customerProfilePic.image != self.customerImage
                        {
                            base64 = Global.sharedInstance.setImageToString(self.customerProfilePic.image!)
                        }
                        else
                        {
                            base64 = ""
                        }
                        
                        //                        let dateFormatter1 = NSDateFormatter()
                        //                        dateFormatter1.timeStyle = .NoStyle
                        //                        dateFormatter1.dateFormat = "dd/MM/yyyy"
                        
                        //                        var dateToSer = NSDate()
                        //                        if self.dateBorn.text! != ""
                        //                        {
                        //                            dateToSer = dateFormatter1.dateFromString(self.dateBorn.text!)!
                        //                        }
                        //                        else
                        //                        {
                        //                            dateToSer = NSDate()
                        //                        }
                      
                
                        let fullNameVerify = self.fullName.text! as String
                        
                        let fullNameArr = fullNameVerify.components(separatedBy: " ")
                        let myArray : NSMutableArray = []
                        let size = fullNameArr.count
                        var firstNameVerify = ""
                        var lastNameVerify = ""
                        if(size > 1) {
                            for item in fullNameArr {
                                if(item.characters.count > 0) {
                                      print("Found \(item)")
                                    myArray.add(item)
                                }
                                let sizemutablearray = myArray.count
                                
                                if(sizemutablearray > 1 ) {
                                    if let _:String = myArray.object(at: 0) as? String {
                                        firstNameVerify = myArray.object(at: 0) as! String
                                        
                                    }
                                    if let _:String = myArray.object(at: 1) as? String {
                                        lastNameVerify = myArray.object(at: 1) as! String
                                      
                                    }
                                }
                            }
                        }
///שמירת הנתונים בגלובל
                        let user:User = User(_iUserId: 0,
                            _nvUserName: self.txtEmail.text!,
                          //  _nvFirstName: self.fullName.text!,
                           //  _nvLastName:  self.txtLastName.text!,
                            _nvFirstName: firstNameVerify,
                            _nvLastName: lastNameVerify,
                           //// _nvSupplierNotes : "",
                            _dBirthdate: self.dateServer,//dateToSer,
                            _nvMail: self.txtEmail.text!,
                            // _nvAdress: "",
                            _iCityType: 1,
                            _nvPhone:  self.txtPhone.text!,//finalservernumber,
                            _nvPassword: (RESPONSEOBJECT["Result"] as! Int).description,
                            _nvVerification: (RESPONSEOBJECT["Result"] as! Int).description,
                            _bAutomaticUpdateApproval: self.btnGetP.isCecked,//אם סימן אני מאשר
                            _bDataDownloadApproval: true,//?
                            _bAdvertisingApproval: self.btnRead.isCecked,//אם סימן קראתי את התקנון
                            _bTermOfUseApproval: true,//תמיד
                            _iUserStatusType: 24,
                            _bIsGoogleCalendarSync: self.btnSync.isCecked,
                          //  _bIsGoogleCalendarSync:true,
                            //בינתיים
                            //2do -להכניס את המחרוזת של התמונה ב base64
                            _nvImage:base64,
                            _iCreatedByUserId: 1,//?
                            _iLastModifyUserId: 1,//?
                            _iSysRowStatus: 1,
                            _bIsManager : 0,
                            _nvDeviceToken : "",
                            _iStatus: 1,
                            _nvNickName: ""
                            
                        )
            //pana aici
                        Global.sharedInstance.currentUser = user
                        print("current user in Register: \(Global.sharedInstance.currentUser.getDic())")
                        let DBHELPER = DataMasterProcessor()
                        var exista : Bool = false
                       
                        
                       let ceva = Global.sharedInstance.currentUser.iUserId
                       if ceva != 0
                        {
                          let telefonuser = String(ceva)
                          //do insert user
                            exista = DBHELPER.insertUser (telefonuser)
                                    if(exista == true) {
                                        //\\print ("USER SAVED IN DB   2")
                                       
                                    }
                        }
                        self.dic2ForDefault["nvClientName"] = Global.sharedInstance.currentUser.nvFirstName as AnyObject
                        Global.sharedInstance.defaults.set(self.dic2ForDefault, forKey: "currentClintName")
                        Global.sharedInstance.defaults.synchronize()
                        if Global.sharedInstance.isRegisterClientClick == true || Global.sharedInstance.isRegisterProviderClick == true
                        {
                            Global.sharedInstance.isFromRegister = true
                            print("btn terms2: \(self.btnRead.isCecked)")
                            print("fReadRegulation2: \(Global.sharedInstance.fReadRegulation)")
                            print("isCheckFromClickRegister2: \(self.isCheckFromClickRegister)")
                            let viewCon:MessageVerificationViewController = self.storyboard?.instantiateViewController(withIdentifier: "MessageVerificationViewController") as! MessageVerificationViewController
                            viewCon.ISSYNC = false
                            viewCon.phone =    self.txtPhone.text!  //JMODE 12.01.2018  self.txtPhone.text!
                            viewCon.verification = ((RESPONSEOBJECT["Result"] as? Int)?.description)!
                            viewCon.isProviderClickd = Global.sharedInstance.isRegisterProviderClick
                            viewCon.delegate = self
                            viewCon.isFromPersonalDetails = false
                            viewCon.delegateShowPhone = self
                            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                            self.present(viewCon, animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        Alert.sharedInstance.showAlert("ERROR_PHONE".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                    }
                    }
                    }
                    }
                }
                    ,failure: {(AFHTTPRequestOperation, Error) -> Void in
                })
            }
        }
    }
    
    //open client exist
    func openCustomerDetails()
    {
        Global.sharedInstance.whichDesignOpenDetailsAppointment = 0
        let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
        let viewCon:ModelCalenderViewController = clientStoryBoard.instantiateViewController(withIdentifier: "ModelCalenderViewController") as! ModelCalenderViewController
        
        self.navigationController?.pushViewController(viewCon, animated: false)
    }
    
    //when come back from ReadRegulation page
    func didReadRegulation() {
        if Global.sharedInstance.fReadRegulation == true
        {
            btnRead.isCecked = true
        }
        else
        {
            btnRead.isCecked = false
        }
    }
    //MARK:-------cropImage
    
        //After choosing an image / photo image, the image is obtained
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
{
    //        if image.size.width > image.size.height
    //        {
    //            customerProfilePic.contentMode = .scaleToFill
    //        }
    //        else
    //        {
    //            customerProfilePic.contentMode = .scaleAspectFit
    //        }
    
    
    self.customerProfilePic.contentMode = .scaleToFill
    customerProfilePic.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    if picker.sourceType == UIImagePickerController.SourceType.camera
    {
        picker.dismiss(animated: true, completion: nil)
    }
    else
    {
        customerProfilePic.image = self.resizeImage(info[UIImagePickerController.InfoKey.originalImage] as! UIImage, newWidth: 220)
        //btnImgPerson.setImage(image, forState: UIControlState.Normal)
        
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}
    


    
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        var neededwidth:CGFloat = 120
        var newImage = UIImage()
        if image.size.height > 0 || image.size.width > 0 {
            let scale = neededwidth / image.size.width
            let newHeight = image.size.height * scale
            UIGraphicsBeginImageContext(CGSize(width: neededwidth, height: newHeight))
            image.draw(in: CGRect(x: 0, y: 0, width: neededwidth, height: newHeight))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    //add crop to image
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
    
    func openProvider()
    {
        isCheckFromClickRegister = true
        Global.sharedInstance.isRegisterClientClick = false
        Global.sharedInstance.isRegisterProviderClick = true
        
        isCheckEmailEnd = false
        isCheckPhoneEnd = false
        isCheckNameEnd = false
        if fullName.text != ""
        {
            validationName()
        }
        else if txtPhone.text != ""
        {
            self.validationPhone()
        }
//        else if txtEmail.text != ""
//        {
//            self.validationEmail()
//        }
        else
        {
            self.validToRegister()
        }
        
    }
    
    //open provider registration
    func openBuisnessDetails(){
        
        Global.sharedInstance.isProvider = true
        
        let viewCon:RgisterModelViewController = self.storyboard?.instantiateViewController(withIdentifier: "RgisterModelViewController") as! RgisterModelViewController
        let viewCon1:GlobalDataViewController = self.storyboard?.instantiateViewController(withIdentifier: "GlobalDataViewController") as! GlobalDataViewController
        
        viewCon.delegateFirstSection = viewCon1
        viewCon.delegateSecond1Section = viewCon1
        
        self.navigationController?.pushViewController(viewCon, animated: false)
    }
    
    //show the image big when tap on the image
    
    func deleteTxtPhone()
    {
        txtPhone.text = ""
    }
    
    func setImageBig(_ view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {() -> Void in
            view.isHidden = hidden
            }, completion: { _ in })
    }
    
   
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
