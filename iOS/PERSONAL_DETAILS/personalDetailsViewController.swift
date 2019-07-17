//
//  personalDetailsViewController.swift
//  Bthere
//
//  Created by User on 9.8.2016.
//  Copyright © 2016 Webit. All rights reserved.


import UIKit
import MarqueeLabel
import PhoneNumberKit
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


class personalDetailsViewController:NavigationModelViewController, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate, UIImagePickerControllerDelegate,WDImagePickerDelegate,UINavigationControllerDelegate,popUpPhoneDelegate,openFromMenuDelegate
{
    //MARK - Outlet

    @IBOutlet weak var lbladvertising: MarqueeLabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnImgPerson: UIButton!
    @IBOutlet weak var dp: UIDatePicker!
    @IBOutlet weak var viewSyncCalendar: UIView!
    @IBOutlet weak var viewWeddingDate: UIView!
    @IBOutlet weak var viewDateBurn: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var btnIn: UIButton!
    @IBOutlet weak var viewSync: UIView!
    @IBOutlet weak var btnOpenTbl: UIButton!
    @IBOutlet weak var tblSelectDesigned: UITableView!
    @IBOutlet weak var btnSelect: CheckBoxForExistSupplierOk!
    @IBOutlet weak var btnNoSelect: CheckBoxForExistSupplierCancel!
    var initialBirthday:String = ""
    var initialAniversaryDate:String = ""

    let phoneNumberKit = PhoneNumberKit()
    //comment
    @IBAction func btnSelectAction(_ sender: AnyObject) {

        if(btnSelect.isCecked == true)
        {
            btnSelect.isCecked = false
            btnNoSelect.isCecked = true
            currentUserToEdit.bIsGoogleCalendarSync = false
        }
        else
        {
            btnSelect.isCecked = true
            btnNoSelect.isCecked = false
            currentUserToEdit.bIsGoogleCalendarSync = true
        }
    }

    @IBAction func btnNoSelectAction(_ sender: AnyObject) {
        if(btnNoSelect.isCecked == true)
        {
            btnNoSelect.isCecked = false
            btnSelect.isCecked = true
            currentUserToEdit.bIsGoogleCalendarSync = true
        }
        else
        {
            btnNoSelect.isCecked = true
            btnSelect.isCecked = false
            currentUserToEdit.bIsGoogleCalendarSync = false
        }
    }
    //  @IBOutlet var newsDealsLabel: UILabel!
    @IBOutlet weak var txtWeddingDate: UITextField!
    @IBOutlet weak var txtDateBorn: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var viewDesign: UIView!
    @IBOutlet weak var plusTap: UIImageView!
    @IBOutlet weak var lblValidEmail: UILabel!
    @IBOutlet weak var lblValidPhone: UILabel!
    @IBOutlet weak var dpWedding: UIDatePicker!
    @IBOutlet weak var lblReqLastName: UILabel!
    @IBOutlet weak var lblReqFirstName: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblSync: UILabel!
    @IBOutlet weak var lblDesignCalendar: UILabel!
    @IBOutlet weak var cameraBtn: UIButton!


    //MARK: - Properties
    //commit comment 2

    fileprivate var imagePickerWD: WDImagePicker!

    var dateServerBorn = Date()
    var dateServerMarried = Date()

    var flag_FullName:Bool = false
    var flag_LastName:Bool = false
    var flag_Phone:Bool = false
    var flag_Email:Bool = false
    var flag_Date:Bool = false
    var generic:Generic = Generic()
    var isSaveClick:Bool = false
    var isCheckEmailEnd:Bool = false
    var isCheckPhoneEnd:Bool = false
    var isCheckNameEnd:Bool = false
    var isCheckLastNameEnd:Bool = false
    var currentUserToEdit:User = User()
    var userPhoneBeforeEdit = ""
    var userMailBeforeEdit = ""
    var arrGoodPhone:Array<Character> = Array<Character>()
    //   var arrayDesigned:Array<String> = Array<String>()//["יומית","שבועית","חודשית"]
    var arrayDesigned = ["DESIGN_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"DESIGN_WEEK".localized(LanguageMain.sharedInstance.USERLANGUAGE),"DESIGN_MONTH".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    //MARK: - Initial
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:24)

        // self.getnews()
        // self.lbladvertising.restartLabel()


    }
    func getnews(){
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //    dic["iLanguageId"] = finalIntforlang

        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            var y:Int = 0
            if let _:NSDictionary =  (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary) {
                let a:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
                dic["iUserId"] = y as AnyObject
            }
            api.sharedInstance.GetNewsAndUpdates(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                        Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else{
                        if let abcd = RESPONSEOBJECT["Result"] as? String {
                            self.lbladvertising.tag = 101
                            self.lbladvertising.type = .continuous
                            self.lbladvertising.animationCurve = .linear
                            self.lbladvertising.type = .leftRight
                            self.lbladvertising.text  = abcd
                            self.lbladvertising.restartLabel()
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                //                if AppDelegate.showAlertInAppDelegate == false
                //                {
                //                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                //                    AppDelegate.showAlertInAppDelegate = true
                //                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //  Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color1, width: 1, any: viewLastName)
        txtPhone.text = ""
        txtMail.text = ""
        txtDateBorn.text = ""
        txtFirstName.text = ""
        txtWeddingDate.text = ""

        self.navLabel?.textColor = Colors.sharedInstance.color3
        self.leftbtnImage? = UIImage(named: "4.png")!
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            txtPhone.textAlignment = .right
            txtMail.textAlignment = .right
            txtDateBorn.textAlignment = .right
            txtFirstName.textAlignment = .right
            txtWeddingDate.textAlignment = .right
        }
        else
        {
            txtPhone.textAlignment = .left
            txtMail.textAlignment = .left
            txtDateBorn.textAlignment = .left
            txtFirstName.textAlignment = .left
            txtWeddingDate.textAlignment = .left
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //  arrayDesigned = Global.sharedInstance.arrayDicForTableViewInCell[2]![2]
        currentUserToEdit = Global.sharedInstance.currentUser
        dpWedding.isHidden = true
        dp.backgroundColor = Colors.sharedInstance.color1
        dp.setValue(UIColor.white, forKeyPath: "textColor")
        dp.setValue(0.8, forKeyPath: "alpha")
        dp.datePickerMode = UIDatePicker.Mode.date
        dp.setValue(false, forKey: "highlightsToday")
        dp.addTarget(self, action: #selector(personalDetailsViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        let gregorian: Foundation.Calendar = Foundation.Calendar(identifier: .gregorian)
        let currentDate: Date = Date()
        var components: DateComponents = DateComponents()
        components.year = -80
        let minDate: Date = (gregorian as NSCalendar).date(byAdding: components, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        components.year = -0
        let maxDate: Date = (gregorian as NSCalendar).date(byAdding: components, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        self.dp.minimumDate = minDate
        self.dp.maximumDate = maxDate
        self.dpWedding.maximumDate = maxDate

        dpWedding.backgroundColor = Colors.sharedInstance.color1
        dpWedding.setValue(UIColor.white, forKeyPath: "textColor")
        dpWedding.setValue(0.8, forKeyPath: "alpha")
        dpWedding.datePickerMode = UIDatePicker.Mode.date
        dpWedding.setValue(false, forKey: "highlightsToday")
        dpWedding.addTarget(self, action: #selector(personalDetailsViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        lblReqFirstName.isHidden = true
        tblSelectDesigned.isHidden = true
        btnImgPerson.isEnabled = false
        lblValidEmail.isHidden = true
        lblValidPhone.isHidden = true
        btnOpenTbl.layer.borderWidth = 1
        btnOpenTbl.layer.borderColor = UIColor.gray.cgColor
        self.btnOpenTbl.layer.shadowColor = UIColor.gray.cgColor
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        tap.delegate = self
        view.addGestureRecognizer(tap)

        view.addGestureRecognizer(tap)
        self.btnOpenTbl.layer.shadowOpacity = 0.4
        self.btnOpenTbl.layer.shadowRadius = 1.5
        tblSelectDesigned.separatorStyle = .none
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            btnIn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        } else {
            btnIn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        }
        dp.isHidden = true

        // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Search Result Hairdresser.jpg")!)
        self.view.addBackground2()

        lblTitle.text = "PERSONAL_DETAILS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnSave.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        // lbladvertising.text = "ADVERTISINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblSync.text = "SYNC_CALENDAR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblDesignCalendar.text = "CALENDAR_DESIGN".localized(LanguageMain.sharedInstance.USERLANGUAGE)

        txtFirstName.attributedPlaceholder = NSAttributedString(string:"NAME_PD".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 15)!]))
        txtMail.attributedPlaceholder = NSAttributedString(string:"MAIL_DP".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 15)!]))
        txtPhone.attributedPlaceholder = NSAttributedString(string:"PHONE_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 15)!]))
        txtDateBorn.attributedPlaceholder = NSAttributedString(string:"DATEBURN_LBL".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 15)!]))
        txtWeddingDate.attributedPlaceholder = NSAttributedString(string:"MARRIAGE_DATE".localized(LanguageMain.sharedInstance.USERLANGUAGE), attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.black,convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 15)!]))
        txtFirstName.delegate = self
        txtMail.delegate = self
        txtWeddingDate.delegate = self
        txtPhone.delegate = self
        txtDateBorn.delegate =  self
        txtFirstName.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        txtDateBorn.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)

        txtMail.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        txtPhone.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        txtWeddingDate.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)


        //   txtFirstName.text = Global.sharedInstance.currentUser.nvLastName + " " + Global.sharedInstance.currentUser.nvFirstName
        txtFirstName.text = Global.sharedInstance.currentUser.nvFirstName + " " + Global.sharedInstance.currentUser.nvLastName
        //\\print("Catch last name: \(Global.sharedInstance.currentUser.nvLastName)")
        //\\print("Catch first name: \(Global.sharedInstance.currentUser.nvFirstName)")

        txtMail.text = Global.sharedInstance.currentUser.nvMail
        txtPhone.text = Global.sharedInstance.currentUser.nvPhone
        userPhoneBeforeEdit = Global.sharedInstance.currentUser.nvPhone
        userMailBeforeEdit = Global.sharedInstance.currentUser.nvMail
        if  Global.sharedInstance.currentUser.bIsGoogleCalendarSync == true{
            self.btnSelect.isCecked = true

        }
        else{
            self.btnNoSelect.isCecked = true
        }


        if Global.sharedInstance.currentUser.iCalendarViewType == 0
        {
            btnIn.setTitle(arrayDesigned[0], for: UIControl.State()) //day
        }
        else if Global.sharedInstance.currentUser.iCalendarViewType == 2
        {
            btnIn.setTitle(arrayDesigned[2], for: UIControl.State()) //month
        }
            //hide week view
            //        else if Global.sharedInstance.currentUser.iCalendarViewType == 1
            //        {
            //            btnIn.setTitle(arrayDesigned[1], for: UIControlState()) //week
            //        }
        else if Global.sharedInstance.currentUser.iCalendarViewType == 1
        {
            btnIn.setTitle(arrayDesigned[0], for: UIControl.State()) //day again
        }

        //dateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX")

        let calendar:Foundation.Calendar = Foundation.Calendar.current
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
        var componentsBDay = (calendar as NSCalendar).components([.day, .month, .year], from: Global.sharedInstance.currentUser.dBirthdate as Date)

        if componentsCurrent.year == componentsBDay.year && componentsCurrent.month == componentsBDay.month && componentsCurrent.day == componentsBDay.day
        {
            txtDateBorn.text = ""
        }
        else
        {
            txtDateBorn.text = dateFormatter.string(from: Global.sharedInstance.currentUser.dBirthdate as Date)
        }
        initialBirthday = txtDateBorn.text!

        componentsBDay = (calendar as NSCalendar).components([.day, .month, .year], from: Global.sharedInstance.currentUser.dMarriageDate as Date)
        if componentsCurrent.year == componentsBDay.year && componentsCurrent.month == componentsBDay.month && componentsCurrent.day == componentsBDay.day
        {
            txtWeddingDate.text = ""
        }
        else
        {
            txtWeddingDate.text = dateFormatter.string(from: Global.sharedInstance.currentUser.dMarriageDate as Date)

        }
        initialAniversaryDate = txtWeddingDate.text!

        //\\  //\\print("cum vine imaginea: \(Global.sharedInstance.currentUser.nvImage)")

        if Global.sharedInstance.currentUser.nvImage == ""
        {
            img.image = UIImage(named: "user-3.png")
        }
        else
        {

            let dataDecoded:Data = Data(base64Encoded: (Global.sharedInstance.currentUser.nvImage), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!

            var decodedimage:UIImage = UIImage()
            if UIImage(data: dataDecoded) != nil
            {

                decodedimage = UIImage(data: dataDecoded)!
                img.image = decodedimage

            }
            else
            {
                img.image = UIImage(named: "user-3.png")

            }




            if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                // Hebrew
                dpWedding.locale = Locale(identifier: "he_IL")
                dp.locale = Locale(identifier: "he_IL")
            } else {
                // English
                dpWedding.locale = Locale(identifier: "en_GB")
                dp.locale = Locale(identifier: "en_GB")
            }



        }

        let tapBornDateTap = UITapGestureRecognizer(target: self, action: #selector(personalDetailsViewController.openDateBornPicker))
        viewDateBurn.addGestureRecognizer(tapBornDateTap)
        txtDateBorn.isUserInteractionEnabled = false
        let tapWeddingDate = UITapGestureRecognizer(target: self, action: #selector(personalDetailsViewController.openWeddingDatePicker))
        viewWeddingDate.addGestureRecognizer(tapWeddingDate)
        txtWeddingDate.isUserInteractionEnabled = false

    }

    @objc func openDateBornPicker()
    {
        if dp.isHidden
        {
            print("asdasdasdasdasd")
            txtDateBorn.inputView = UIView()
            dp.isHidden = false
            dpWedding.isHidden = true
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date = dateFormatter.date(from: "01/01/1950")
            dp.setDate(date!, animated: false)
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd/MM/yyyy"

            if txtDateBorn.text! != "" && txtDateBorn.text! != initialBirthday
            {
                currentUserToEdit.dBirthdate = dateServerBorn
            }

            dp.isHidden = true
            dpWedding.isHidden = true
        }

    }

    @objc func openWeddingDatePicker()
    {
        if dpWedding.isHidden
        {
            txtWeddingDate.inputView = UIView()
            dpWedding.isHidden = false
            dp.isHidden = true
            dpWedding.setDate(Date(), animated: false)
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd/MM/yyyy"

            if txtWeddingDate.text! != "" && txtWeddingDate.text! != initialAniversaryDate {
                currentUserToEdit.dMarriageDate = dateServerMarried
            }

            dp.isHidden = true
            dpWedding.isHidden = true
        }

    }


    override func viewDidAppear(_ animated: Bool) {
        viewFirstName.layer.borderWidth = 0.3
        viewFirstName.layer.borderColor = Colors.sharedInstance.color5.cgColor
        viewPhone.layer.borderWidth = 0.3
        viewPhone.layer.borderColor = Colors.sharedInstance.color5.cgColor
        viewDesign.layer.borderWidth = 0.3
        viewDesign.layer.borderColor = Colors.sharedInstance.color5.cgColor
        viewEmail.layer.borderWidth = 0.3
        viewEmail.layer.borderColor = Colors.sharedInstance.color5.cgColor
        viewDateBurn.layer.borderWidth = 0.3
        viewDateBurn.layer.borderColor = Colors.sharedInstance.color5.cgColor
        viewWeddingDate.layer.borderWidth = 0.3
        viewWeddingDate.layer.borderColor = Colors.sharedInstance.color5.cgColor
        viewSync.layer.borderWidth = 0.3
        viewSync.layer.borderColor = Colors.sharedInstance.color5.cgColor

        //\\print("frame button: \(cameraBtn.frame.width)")
        //\\print("frame button: \(cameraBtn.frame.height)")


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    func addShaddow(_ view:UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 1.5
    }

    //MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDesigned.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let  cell = tableView.dequeueReusableCell(withIdentifier: "DescDesignTableViewCell")as!DescDesignTableViewCell
        cell.selectionStyle = .none
        cell.setDisplayData(arrayDesigned[indexPath.row])
        if indexPath.row == 2{
            cell.viewButtom.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        btnIn.setTitle(arrayDesigned[indexPath.row], for: UIControl.State())
        tblSelectDesigned.isHidden = true
        btnIn.tag = 0
        let stringSelected = (tableView.cellForRow(at: indexPath) as! DescDesignTableViewCell).desc.text!
        let indexsearch = arrayDesigned.index(of: stringSelected)
        let intsarray = [0,1,2]
        currentUserToEdit.iCalendarViewType = intsarray[indexsearch!]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1
        {
            return 0
        }
        else
        {
            return tblSelectDesigned.frame.size.height/2
        }
        //hide week view
        //        return tblSelectDesigned.frame.size.height/3
    }

    @IBAction func btnOpenTable(_ sender: UIButton) {
        if sender.tag == 0{
            tblSelectDesigned.isHidden = false
            sender.tag = 1
        }
        else{
            tblSelectDesigned.isHidden = true
            sender.tag = 0
        }
    }

    //כדי שהטבלה הפנימית של תצוגת יומן תהיה לחיצה
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: tblSelectDesigned)  {

            return false
        }
        return true
    }

    @IBAction func btnOpenCamera(_ sender: UIButton) {
        // setImageBig(viewBigImage, hidden: true)
        //txtAddress.dismissSuggestionTableView()
        Global.sharedInstance.isCamera = true
        ImagesCamera()
    }


    @IBAction func btnClickNoSelect(_ sender: CheckBoxForExistSupplierCancel) {
        btnSelect.isCecked = false
    }
    @IBAction func btnClickSelect(_ sender: CheckBoxForExistSupplierOk) {
        btnNoSelect.isCecked = false
    }
    //שמור
    @IBAction func btnSave(_ sender: UIButton) {
        //iustin

        dateServerBorn = dp.date

        dateServerBorn = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: dateServerBorn
            , options: [])!
        dateServerMarried = dpWedding.date

        dateServerMarried = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: dateServerMarried
            , options: [])!
        dismissKeyboard()
        txtWeddingDate.resignFirstResponder()
        txtDateBorn.resignFirstResponder()
        isSaveClick = true

        dp.isHidden = true
        dpWedding.isHidden = true




        if txtFirstName.text != ""
        {
            fullNameVaidation()
        }
        else if txtPhone.text != ""
        {
            self.validationPhone()
        }
            //        else if txtMail.text != ""
            //        {
            //            self.validationEmail()
            //        }
        else
        {
            self.validToUpdate()
        }


    }
    func saveUserDetails()
    {
        //set validation
        currentUserToEdit.iUserId = Global.sharedInstance.currentUser.iUserId

        currentUserToEdit.nvUserName = txtFirstName.text!
        currentUserToEdit.nvFirstName = txtFirstName.text!
        currentUserToEdit.dBirthdate = dateServerBorn//Global.sharedInstance.getDateFromString(txtDateBorn.text!)
        currentUserToEdit.dMarriageDate = dateServerMarried//Global.sharedInstance.getDateFromString(txtWeddingDate.text!)
        currentUserToEdit.nvMail = txtMail.text!
        //        currentUserToEdit.nvAdress = txt.text!
        currentUserToEdit.nvPhone = txtPhone.text!
        if btnNoSelect.isCecked
        {
            currentUserToEdit.bIsGoogleCalendarSync = false
        }
        else
        {
            currentUserToEdit.bIsGoogleCalendarSync = true
        }
    }


    func UpdateUser() {
        var dicDicRegister:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var dicRegister:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //\\  //\\print("nvimg current user: \(currentUserToEdit.nvImage)")
        dicDicRegister = currentUserToEdit.getDicToEdit()
        //\\  //\\print("dictionar update user: \(dicDicRegister)")
        dicRegister["objUser"] = dicDicRegister as AnyObject

        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false {
            self.generic.hideNativeActivityIndicator(self)
            //            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            api.sharedInstance.UpdateUser(dicRegister as! Dictionary<String, Dictionary<String, AnyObject>>, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    //\\print(RESPONSEOBJECT)
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 {

                            Alert.sharedInstance.showAlert("אירעה תקלה בשמירת הפרטים",vc: self)
                        } else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                            // Show success message
                            let refreshAlert = UIAlertController(title: "", message: "SUCCESS_SAVECHANGES".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                            refreshAlert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
                                // Reload client
                                self.reloadclient()
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                            //
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                //                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }

    }
    //add
    func reloadclient(){
        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {


            var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>

            if dicUserId["currentUserId"] as! Int != 0
            {
                //קבלת פרטי הלקוח
                var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                api.sharedInstance.GetCustomerDetails(dicForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                        {
                            let RESULTFULL = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                            //\\     //\\print("GetCustomerDetails \(String(describing: RESPONSEOBJECT["Result"]))")
                            var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

                            dicForDefault["nvClientName"] = RESULTFULL["nvFirstName"]
                            dicForDefault["nvPhone"] = RESULTFULL["nvPhone"]
                            Global.sharedInstance.defaults.set(dicForDefault, forKey: "currentClintName")

                            var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

                            dicUserId["currentUserId"] = RESULTFULL["iUserId"]

                            //                        Global.sharedInstance.defaults.value(forKey: "APPDELnvVerCode") as! String
                            if let _ = RESULTFULL["nvVerification"]
                            {
                                Global.sharedInstance.defaults.set(RESULTFULL["nvVerification"], forKey: "APPDELnvVerCode")
                            }
                            if let _ = RESULTFULL["nvPhone"]
                            {
                                Global.sharedInstance.defaults.set(RESULTFULL["nvPhone"], forKey: "APPDELnvPhone")
                            }



                            //save the userId on device
                            Global.sharedInstance.defaults.set(dicUserId, forKey: "currentUserId")
                            Global.sharedInstance.defaults.synchronize()
                            //\\   //\\print("user desc \(dicUserId.description)")


                            if let _:User = Global.sharedInstance.currentUser.dicToUser(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>) {
                                Global.sharedInstance.currentUser = Global.sharedInstance.currentUser.dicToUser(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)

                                Global.sharedInstance.currentUser.dBirthdate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dBirthdate
                                    , options: [])!
                                Global.sharedInstance.currentUser.dMarriageDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dMarriageDate
                                    , options: [])!
                            }
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            Global.sharedInstance.isProvider = false
                            Global.sharedInstance.whichReveal = false
                            let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
                            let vc = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
                            frontviewcontroller?.pushViewController(vc, animated: false)

                            //initialize REAR View Controller- it is the LEFT hand menu.

                            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                            let mainRevealController = SWRevealViewController()

                            mainRevealController.frontViewController = frontviewcontroller
                            mainRevealController.rearViewController = rearViewController
                            let window :UIWindow = UIApplication.shared.keyWindow!
                            window.rootViewController = mainRevealController
                            window.makeKeyAndVisible()
                        }

                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    //                        if AppDelegate.showAlertInAppDelegate == false
                    //                        {
                    //                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    //                            AppDelegate.showAlertInAppDelegate = true
                    //                        }
                })
            }
        }
    }
    //end add
    func ImagesCamera()
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
                self.showResizablePicker(self.btnImgPerson, galleryorcamera: 0)
            }
        })

        let button3action: UIAlertAction = UIAlertAction(title: "REMOVE_PICTURE_PERSONAL_INFO".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) ->() in

            self.img.image = UIImage(named: "user-3.png")


        })


        alertController.addAction(button1action)
        alertController.addAction(button2action)
        alertController.addAction(button3action)
        alertController.popoverPresentationController?.sourceView = self.cameraBtn
        //        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.width / 2.0, y: self.view.bounds.height / 2.0, width: 1.0, height: 1.0) // this is
        alertController.popoverPresentationController?.sourceRect = self.cameraBtn.bounds
        self.present(alertController, animated: true, completion: nil)


    }

    //  MARK:-------cropImage
    ///JMODE TODO AND VERIFY
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


    func imagePicker(_ imagePicker: WDImagePicker, pickedImage: UIImage) {
        img.image = self.resizeImage(pickedImage, newWidth:220)
        self.hideImagePicker()
    }

    func hideImagePicker() {
        ImagesCamera()
        self.imagePickerWD.imagePickerController.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        img.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        if picker.sourceType == UIImagePickerController.SourceType.camera
        {
            picker.dismiss(animated: true, completion: nil)
        }
        else
        {
            img.image = self.resizeImage(info[UIImagePickerController.InfoKey.originalImage] as! UIImage, newWidth: 220)
            //btnImgPerson.setImage(image, forState: UIControlState.Normal)


            picker.dismiss(animated: true, completion: nil)

        }
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

    // MARK: - KeyBoard

    //=======================KeyBoard================


    @objc func dismissKeyboard() {
        dp.isHidden = true
        dpWedding.isHidden = true
        //tableView.hidden = true
        view.endEditing(true)
    }

    // MARK: - TextField
    //=========================TextField==============
    //    func textFieldShouldReturn(textField: UITextField) -> Bool {
    //        self.view.endEditing(true)
    //        return false
    //    }
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch(textField)
        {
        case(txtFirstName):
            txtPhone.becomeFirstResponder()
        case(txtPhone):
            //txtAddress.becomeFirstResponder()
            //case(txtAddress):
            txtMail.becomeFirstResponder()
        case(txtMail):
            txtDateBorn.becomeFirstResponder()
        case(txtDateBorn):
            txtWeddingDate.becomeFirstResponder()
        case(txtWeddingDate):
            dismissKeyboard()
        default:
            txtFirstName.becomeFirstResponder()
        }

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        //iustin

        if textField == txtDateBorn
        {
            textField.inputView = UIView()
            dp.isHidden = false
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date = dateFormatter.date(from: "01/01/1950")
            dp.setDate(date!, animated: false)
            //dp.setDate(NSDate(), animated: false)
        }
        else if textField == txtWeddingDate{
            textField.inputView = UIView()
            dpWedding.isHidden = false
            dpWedding.setDate(Date(), animated: false)
        }
        else if textField == txtFirstName
        {
            //txtAddress.dismissSuggestionTableView()
            self.lblReqFirstName.isHidden = true
        }

        else
        {
            dp.isHidden = true

        }
        if textField != txtWeddingDate{
            dpWedding.isHidden = true
        }
        isSaveClick = false

        checkValidation(textField)

    }

    //    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    //        if textField == txtMail
    //        {
    //            if !Validation.sharedInstance.mailValidation(
    //                self.txtMail.text!) || self.txtMail.text == ""
    //            {
    //
    //                //self.lblEmail.textColor = UIColor.redColor()
    //                //Alert.sharedInstance.showAlert("MAIL_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
    //                self.lblValidEmail.text = "MAIL_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    //                self.lblValidEmail.isHidden = false
    //
    //                Global.sharedInstance.isValid_Email = false
    //            }
    //            else //תקין
    //            {
    //                //אם לא היה תקין בגלל השרת
    //
    //                    Global.sharedInstance.isValid_Email = true
    //                    self.lblValidEmail.isHidden = true
    //            }
    //        }
    //        return true
    //
    //    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //iustin
        switch(textField) {
        case txtFirstName:
            //            currentUserToEdit.nvLastName = "nothing"
            currentUserToEdit.nvFirstName = textField.text!
            dp.isHidden = true
            dpWedding.isHidden = true
        case txtPhone:
            if (textField.text?.count == 10)
            {
                self.validationPhone()

                currentUserToEdit.nvPhone = textField.text!
                lblValidPhone.isHidden = true
                dp.isHidden = true
                dpWedding.isHidden = true
            }


        case txtDateBorn:
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd/MM/yyyy"

            if textField.text! != "" && textField.text! != initialBirthday {
                currentUserToEdit.dBirthdate = dateServerBorn
            }

            dp.isHidden = true
            dpWedding.isHidden = true
        case txtWeddingDate:
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd/MM/yyyy"

            if textField.text! != "" && textField.text! != initialAniversaryDate {
                currentUserToEdit.dMarriageDate = dateServerMarried
            }

            dp.isHidden = true
            dpWedding.isHidden = true
        case txtMail:
            //            if !Validation.sharedInstance.mailValidation(
            //                self.txtMail.text!) || self.txtMail.text == ""
            //            {
            //
            //                //self.lblEmail.textColor = UIColor.redColor()
            //                //Alert.sharedInstance.showAlert("MAIL_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            //                self.lblValidEmail.text = "MAIL_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            //                self.lblValidEmail.isHidden = false
            //
            //                Global.sharedInstance.isValid_Email = false
            //            }
            //            else //תקין
            //            {
            //                //אם לא היה תקין בגלל השרת
            //                if Global.sharedInstance.isValid_Email != false
            //                {
            //                    Global.sharedInstance.isValid_Email = true
            //                    self.lblValidEmail.isHidden = true
            //                }
            //            }
            currentUserToEdit.nvMail = textField.text!
        default:
            lblValidEmail.isHidden = true
            dp.isHidden = true
        }
    }


    func getStringFromDateString(_ dateString: String)-> Date
    {
        if dateString != ""
        {
            let lastName: String? = dateString
            let lastNam: String? = lastName

            let myDouble = Double(lastNam!)
            let date = Date(timeIntervalSince1970: myDouble!/1000.0)
            return date
        }
        return Date()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        fDidBegin = false
        //        timer?.invalidate()
        //        timer = nil
        if true {

            // timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(self.doDelayed), userInfo: string, repeats: false)


            //        if textField == txtAddress {
            //            googlePlacesAutocomplete.input = textField.text! + string
            //            googlePlacesAutocomplete.fetchPlaces()
            //        }

            var startString = ""
            if (textField.text != nil)
            {
                startString += textField.text!
            }
            startString += string


            //            if textField == txtPhone
            //            {
            //                if startString.characters.count > 10
            //                {    txtPhone.resignFirstResponder()
            //                    Alert.sharedInstance.showAlert("ENTER_TEN_DIGITS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            //
            //                    //                dismissKeyboard()
            //                    return false
            //                }
            //                else
            //                {
            //                    return true
            //                }
            //            }

            if textField == txtFirstName || textField == txtMail {
                if startString.count > 20 {
                    Alert.sharedInstance.showAlert("ENTER_ONLY20_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
                    return false
                }
            }
            if textField == txtPhone
            {

                var cleanNumber:String = ""
                if string.count > 1
                {

                    var cleanedString: String = (string.components(separatedBy: CharacterSet(charactersIn: "0123456789-+()").inverted) as NSArray).componentsJoined(by: "")
                    //\\print("cleaned string \(cleanedString)")
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
                        //\\print("smart paste cleaned string: \(cleanNumber)")
                    }
                    if cleanNumber.count > 2 {
                        let numertocompare = cleanNumber
                        let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                        let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                        if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5")
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

                if startString.count > 10
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

            return true
        }
    }

    //MARK: - Validation

    func checkValidation(_ textField:UITextField)
    {

        ///* הערה:בכל אחת מהבדיקות בדקתי גם האם הטקסטפילד לא שווה אלי בעצמי למקרה שהטקסטפילד לא תקין והא היה האחרון שערכתי ועכשיו אני רוצה להכנס אליו שוב לתקן אותו


        //================בדיקה מי ה-textField הקודם שמולא כדי לבדוק את תקינותו==============

        ///---------------------------------------בדיקת השם------------------------

        if flag_FullName == true && textField != txtFirstName && txtFirstName.text != ""
        {
            validationName()

            flag_FullName = false
        }

            ///-----------------------------בדיקת השם משפחה---------------------------


            ///-----------------------------בדיקת הטלפון-----------------------

        else if flag_Phone == true && textField != txtPhone && txtPhone.text != ""
        {
            validationPhone()

            flag_Phone = false
        }

        ///-----------------------------בדיקת הכתובת------------------------
        //        else if flag_address == true && textField != txtAddress && txtAddress.text != ""
        //        {
        //            validationAddress()
        //            flag_address = false
        //        }



        ///--------------------בדיקת המייל------------------------

        //        else if flag_Email == true && textField != txtMail && txtMail.text != ""
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
        case txtFirstName:
            flag_FullName = true
            break

        case txtPhone:
            flag_Phone = true
            break

            //        case txtAddress:
            //            flag_address = true
            //            break

            //        case txtMail:
            //            flag_Email = true
            //            break

        case txtDateBorn:
            flag_Date = true
            break

        default:
            break
        }
    }
    //for first and last name
    func isValidName(_ input: String) -> Bool {
        var numSpace = 0
        for chr in input {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z")  && !(chr >= "א" && chr <= "ת") && !(chr >= "0" && chr <= "9") && chr != " " && chr != "’" && chr != "‘"  && chr != "“" && chr != "'" && chr != "\"" && chr != "”" && chr != "“" && chr != "”" && chr != "׳" && (input.isRussiantext(title: input) == false) )  {
                return false
            }
            if chr == " "
            {
                numSpace += 1
            }
        }
        if numSpace == input.count || numSpace == input.count - 1// אם יש רק רווחים או רק אות אחת והשאר רווחים
        {
            return false
        }
        else if numSpace > 0
        {
            let arr = input.components(separatedBy: " ")
            for word in arr {
                if word.count == 1
                {
                    return false
                }
            }
        }
        return true
    }

    func validationName()
    {
        isCheckNameEnd = true

        if txtFirstName.text!.count == 1 || isValidName(txtFirstName.text!) == false ///שם פרטי
        {
            lblReqFirstName.text = "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            lblReqFirstName.isHidden = false
            //lblFullName.textColor = UIColor.redColor()
            Global.sharedInstance.isValid_FullName = false
        }
        else
        {
            Global.sharedInstance.isValid_FullName = true
            lblReqFirstName.isHidden = true
        }

        if self.isSaveClick == true
        {
            if txtPhone.text != ""
            {
                self.validationPhone()
            }
                //            else if txtMail.text != ""
                //            {
                //                self.validationEmail()
                //            }
            else
            {
                self.validToUpdate()
            }

        }
    }


    func validationLastName()
    {
        isCheckLastNameEnd = true


        if self.isSaveClick == true
        {
            if txtPhone.text != ""
            {
                self.validationPhone()
            }
                //            else if txtMail.text != ""
                //            {
                //                self.validationEmail()
                //            }
            else
            {
                self.validToUpdate()
            }
        }
    }


    //            currentUserToEdit.nvPhone = textField.text!
    //            lblValidPhone.isHidden = true
    //            dp.isHidden = true
    //            dpWedding.isHidden = true

    func validationPhone()
    {
        var flag = true
        arrGoodPhone = []
        var dicPhone:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicPhone["nvPhone"] = txtPhone.text as AnyObject
        ///בדיקה שהטלפון לא קיים כבר במערכת

        self.generic.showNativeActivityIndicator(self)

        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
            //            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            if let _ = self.txtPhone.text
            {
                if self.txtPhone.text!.count > 1
                {
                    api.sharedInstance.CheckPhoneValidity(dicPhone, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            //\\print("CheckPhoneValidity \(String(describing: responseObject))")
                            self.isCheckPhoneEnd = true

                            if RESPONSEOBJECT["Result"] as! Int == 0 && self.userPhoneBeforeEdit != self.txtPhone.text//קיים
                            {
                                self.lblValidPhone.isHidden = false
                                self.lblValidPhone.text = "PHONE_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                Global.sharedInstance.isValid_Phone = false
                            }
                            else //לא קיים
                            {
                                Global.sharedInstance.isValid_Phone = true
                                self.lblValidPhone.isHidden = true
                            }
                            let index0 = self.txtPhone.text?.index((self.txtPhone.text?.startIndex)!, offsetBy: 0)
                            let index1 = self.txtPhone.text?.index((self.txtPhone.text?.startIndex)!, offsetBy: 1)
                            if self.txtPhone.text?.count < 10 || (self.txtPhone.text?[index0!] != "0" || self.txtPhone.text?[index1!] != "5")
                            {
                                Global.sharedInstance.isValid_Phone = false
                                self.lblValidPhone.text = "PHONE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                self.lblValidPhone.isHidden = false
                                //aici
                            }

                            //בדיקה שהטלפון תקין
                            let specialCharacterRegEx  = "[*]?[0-9]+"
                            let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
                            let specialresult = texttest2.evaluate(with: self.txtPhone.text)


                            if !specialresult && self.txtPhone.text != ""// לא תקין
                            {
                                for char in (self.txtPhone.text)!
                                {
                                    if (char >= "0" && char <= "9") || char == "*"
                                    {
                                        let c:Character = char
                                        self.arrGoodPhone.append(c)
                                    }

                                    else
                                    {
                                        self.lblValidPhone.text = "PHONE_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                        // self.lblPhone.textColor = UIColor.redColor()
                                        self.lblValidPhone.isHidden = false
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
                            if self.isSaveClick == true
                            {
                                //                                if self.txtMail.text != ""
                                //                                {
                                //                                    self.validationEmail()
                                //                                }
                                //                                else
                                //                                {
                                self.validToUpdate()
                                //                                }
                            }
                        }


                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        //\\print("Error: ", Error!.localizedDescription)
                        self.generic.hideNativeActivityIndicator(self)
                        //                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    })
                }
                else
                {
                    self.generic.hideNativeActivityIndicator(self)
                }
            }
            else
            {
                self.generic.hideNativeActivityIndicator(self)
            }



        }
    }

    func validationEmail()
    {
        var dicMail:Dictionary<String,String> = Dictionary<String,String>()
        dicMail["nvEmail"] = txtMail.text

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

                    if RESPONSEOBJECT["Result"] as! Int == 0 && self.userMailBeforeEdit != self.txtMail.text//קיים
                    {
                        self.lblValidEmail.isHidden = false
                        self.lblValidEmail.text = "MAIL_EXIST".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        Global.sharedInstance.isValid_Email = false
                    }
                    else //לא קיים
                    {
                        Global.sharedInstance.isValid_Email = true
                        self.lblValidEmail.isHidden = true
                    }

                    ///בדיקה שהמייל תקין
                    //                if !Validation.sharedInstance.mailValidation(
                    //                    self.txtMail.text!) || self.txtMail.text == ""
                    //                {
                    //
                    //                    //self.lblEmail.textColor = UIColor.redColor()
                    //                    //Alert.sharedInstance.showAlert("MAIL_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                    //                    self.lblValidEmail.text = "MAIL_ERROR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    //                    self.lblValidEmail.isHidden = false
                    //
                    //                    Global.sharedInstance.isValid_Email = false
                    //                }
                    //                else //תקין
                    //                {
                    //                    //אם לא היה תקין בגלל השרת
                    //                        Global.sharedInstance.isValid_Email = true
                    //                        self.lblValidEmail.isHidden = true
                    //                }

                    ///אם הגיעו מהכפתור של הרשם יש לבדוק אם אפשר לעבור עמוד
                    if self.isSaveClick == true
                    {
                        self.validToUpdate()
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                //\\print("Error: ", Error!.localizedDescription)
                self.generic.hideNativeActivityIndicator(self)
                //                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }

    func validToUpdate()
    {
        var x = 0

        ///---------בדיקה שהשדות חובה מלאים

        if self.txtFirstName.text == ""
        {
            self.lblReqFirstName.isHidden = false
            self.lblReqFirstName.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            x = 1
        }

        //        if self.txtMail.text == ""
        //        {
        //            self.lblValidEmail.isHidden = false
        //            self.lblValidEmail.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        //            x = 1
        //        }
        if self.txtPhone.text == ""
        {
            self.lblValidPhone.isHidden = false
            self.lblValidPhone.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            x = 1
        }
            //            else if !Global.sharedInstance.isValid_FullName || !Global.sharedInstance.isValid_lName || !Global.sharedInstance.isValid_Phone || !Global.sharedInstance.isValid_Email
        else if !Global.sharedInstance.isValid_FullName || !Global.sharedInstance.isValid_lName || !Global.sharedInstance.isValid_Phone
        {
            x = 1

            Alert.sharedInstance.showAlert("VALID_FIELDS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)

        }

        if x == 0//הכל תקין
        {
            if self.img.image != nil && self.img.image != UIImage(named:"user-3.png")
            {

                currentUserToEdit.nvImage = self.setImageToString(self.img.image!)

            }

            else if self.img.image == UIImage(named:"user-3.png")
            {
                currentUserToEdit.nvImage = ""
            }

            else
            {
                currentUserToEdit.nvImage = ""
            }
            if self.userPhoneBeforeEdit != self.txtPhone.text//ערכו את הטלפון
            {

                let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewCon:MessageVerificationViewController = MainStoryboard.instantiateViewController(withIdentifier: "MessageVerificationViewController") as! MessageVerificationViewController
                viewCon.phone = self.txtPhone.text!
                viewCon.currentUserToEdit = self.currentUserToEdit
                viewCon.isFromPersonalDetails = true
                viewCon.delegateShowPhone = self
                Global.sharedInstance.isFromRegister = false

                viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
                self.present(viewCon, animated: true, completion: nil)
            }
            else
            {
                UpdateUser()
            }
        }
    }
    // MARK: - DatePicker
    //iustin
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"

        if sender == dp
        {
            dateServerBorn = sender.date

            dateServerBorn = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: dateServerBorn
                , options: [])!

            txtDateBorn.text = dateFormatter.string(from: sender.date)

            if txtDateBorn.text! != "" && txtDateBorn.text! != initialBirthday {
                currentUserToEdit.dBirthdate = dateServerBorn
            }

        }
        else
        {
            dateServerMarried = sender.date

            dateServerMarried = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: dateServerMarried
                , options: [])!

            txtWeddingDate.text = dateFormatter.string(from: sender.date)

            if txtWeddingDate.text! != "" && txtWeddingDate.text! != initialAniversaryDate {
                currentUserToEdit.dMarriageDate = dateServerMarried
            }
        }
    }

    func datePickerValueChanged(_ sender:UIDatePicker) {

        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = DateFormatter.Style.medium

        dateFormatter.timeStyle = DateFormatter.Style.none
    }


    func maskRoundedImage(_ image: UIImage, radius: Float) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer

        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)

        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return roundedImage!
    }

    //מחזיר את הקוד לשורה מסויימת מהטבלה שנבחרה-בשביל השליחה לשרת
    //מקבלת את קוד הטבלה אליה לגשת ואת הסטרינג שנבחר
    func SysTableRowId(_ iTableRowId:Int,str:String)->Int
    {
        for sys in Global.sharedInstance.dicSysAlerts[iTableRowId.description]!
        {
            if sys.iTableId == iTableRowId && sys.nvAletName == str
            {
                return sys.iSysTableRowId
            }
        }
        return 0
    }

    func SysTableRowString(_ iTableRowId:Int,id:Int)->String {
        for sys in Global.sharedInstance.dicSysAlerts[iTableRowId.description]!
        {
            if sys.iTableId == iTableRowId && sys.iSysTableRowId == id
            {
                return sys.nvAletName
            }
        }
        return ""
    }




    func deleteTxtPhone() {
        txtPhone.text = ""
    }


    @objc func imageTapped(){
        let storyboard1:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewCon:MenuPlusViewController = storyboard1.instantiateViewController(withIdentifier: "MenuPlusViewController") as! MenuPlusViewController
        viewCon.delegate = self
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
    }


    func openFromMenu(_ con:UIViewController) {
        self.present(con, animated: true, completion: nil)
    }

    func setImageToString(_ image:UIImage)->String{
        var imageData:NSString
        var dataForJPEGFile:Data
        var quality:CGFloat = 0.4
        if let _:UIImage=image{
            if UIDevice.current.userInterfaceIdiom == .pad {
                quality = 0.3
            }
            dataForJPEGFile = image.jpegData(compressionQuality: quality)!
            imageData = dataForJPEGFile.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) as NSString
            //let imageSize: Int = imageData.length
            //\\print("size of image in KB: %f ", Double(imageSize) / 1024.0)
            return imageData as String
        }
        else{
            return ""
        }
    }
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        let neededwidth:CGFloat = 120
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
    func fullNameVaidation() {
        isCheckNameEnd = true

        let fullNameVerify = txtFirstName.text! as String
        let bar = fullNameVerify
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        let fullNameArr = bar.components(separatedBy: " ")
        //    let fullNameArr = fullNameVerify.componentsSeparatedByString(" ")
        let myArray : NSMutableArray = []
        let size = fullNameArr.count
        var firstNameVerify:String = ""
        var lastNameVerify:String = ""

        if (size > 1) {
            for item in fullNameArr {
                if (item.count > 0) {
                    //\\print("Found \(item)")
                    myArray.add(item)
                }
            }

            let sizemutablearray = myArray.count

//            for item in myArray {
//                //\\print("Found myArray\(item)")
//            }

            if (sizemutablearray > 1 ) {
                if let _:String = myArray.object(at: 0) as? String {
                    firstNameVerify = myArray.object(at: 0) as! String

                    if let _:String = myArray.object(at: 1) as? String {
                        lastNameVerify = myArray.object(at: 1) as! String

                    }
                }

                if txtFirstName.text!.count == 1 || isValidName(txtFirstName.text!) == false
                {
                    if(firstNameVerify.count == 0  || isValidName(firstNameVerify) == false || isValidName(lastNameVerify) == false || lastNameVerify.count == 0 )
                    {
                        lblReqFirstName.text = "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        lblReqFirstName.isHidden = false
                        Global.sharedInstance.isValid_FullName = false
                    }
                }
                else
                {
                    Global.sharedInstance.isValid_FullName = true
                    Global.sharedInstance.isValid_lName = true
                    lblReqFirstName.isHidden = true

                    currentUserToEdit.nvLastName = lastNameVerify
                    currentUserToEdit.nvFirstName = firstNameVerify

                    //\\print("This last name: \(lastNameVerify)")
                    //\\print("This first name: \(firstNameVerify)")


                    self.validToUpdate()
                }
            }
            else
            {
                lblReqFirstName.text = "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                lblReqFirstName.isHidden = false
                Global.sharedInstance.isValid_FullName = false
            }
        }
        else
        {
            lblReqFirstName.text = "ERROR_FNAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            lblReqFirstName.isHidden = false
            Global.sharedInstance.isValid_FullName = false
            Alert.sharedInstance.showAlert("VALID_FIELDS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)

        }

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
                    //\\print ("phoneNumberCustomDefaultRegion \(phoneNumberCustomDefaultRegion)")
                    let newString = modedphone.stringByReplacingFirstOccurrenceOfString(target: String(phoneNumberCustomDefaultRegion), withString: "0")
                    modedphone = newString
                    //\\print("formated number is \(modedphone)")
                }
            }
            catch {
                //\\print("Generic parser error")
            }
            for char in modedphone
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
