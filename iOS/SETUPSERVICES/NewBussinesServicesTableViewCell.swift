//
//  NewBussinesServicesTableViewCell.swift


import UIKit
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





class NewBussinesServicesTableViewCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,saveDataToWorkerDelegate,TTTAttributedLabelDelegate{
    var delegate:isOpenRowDelegate2!=nil
    var myindexrow:Int = 0
    var initialname:String = ""
    var initialprice:String = ""
    var initialtime:String = ""
    var initialbtnyes:Bool = false
    var initialnumberofcustomers:String = ""
    var initialtimeinterval:String = ""
    var finalname:String = ""
    var finalprice:String = ""
    var finaltime:String = ""
    var finallbtnyes:Bool = false
    var finalnumberofcustomers:String = ""
    var finaltimeinterval:String = ""
    //MARK: - Properties

    var arrayServiceProduct:Array<String> = ["CUT_HAIR".localized(LanguageMain.sharedInstance.USERLANGUAGE),"HAIR_DO".localized(LanguageMain.sharedInstance.USERLANGUAGE),"LEVEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    // var arrayOptions:Array<String> = ["PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var arrayOptions:Array<String> = ["PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE)]

    var delegateSave:reloadTableForSaveDelegate! = nil
    var delegateScroll:scrollOnEditDelegate!=nil
    var closeCellDelegate:closeLastCellSelegate!=nil
    var fromPrice:Float = 0 // לשמירת ממחיר
    var untilPrice:Float = 0 // לשמירת עד מחיר
    var fromServiceTime:Int = 0 //לשמירת ממשך זמן
    var untilServiceTime:Int = 0 //לשמירת עד משך זמן

    var selectedTextField:UITextField?

    //MARK: - Outlet

    @IBOutlet weak var tblSelectOption: UITableView!
    @IBOutlet weak var lblServiceProduct: UILabel!
    @IBOutlet weak var lblDuringTime: TTTAttributedLabel!
    @IBOutlet weak var lblRangTime: UILabel!
    @IBOutlet weak var lblNumCustomers: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var txtServiceName: UITextField!
    @IBOutlet weak var lblInputServiceName: UILabel!
    @IBOutlet weak var lblShowPrice: UILabel!
    @IBOutlet weak var btnNoSelect: checkBoxForDetailsWorker4!
    @IBOutlet weak var txtTimeInterval: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var maxConcurrentCustomers: UITextField!
    @IBOutlet weak var txtTimeOfService: UITextField!
    @IBAction func btnNoSelect(_ sender: AnyObject) {
        btnYesSelect.isCecked = false
        btnNoSelect.isCecked = true
    }

    @IBOutlet weak var btnYesSelect: CheckBoxForDetailsWorker3!
    @IBAction func btnYesSelect(_ sender: AnyObject) {

        btnYesSelect.isCecked = true
        btnNoSelect.isCecked = false
    }


    @IBOutlet weak var btnHEIGHT: NSLayoutConstraint! //checkbox in edit service
    @IBOutlet weak var dyanmicrowHEIGHT: NSLayoutConstraint! //row in list fields service name, price, etc




    @IBAction func btnSave(_ sender: UIButton)
    {
        Global.sharedInstance.fIsSaveConBussinesServicesPressed = true
        Global.sharedInstance.selectedCellForEditService.append(false)
        if self.saveDataToWorker() == true {
            delegate.closeandclearcell(_WHICHCELL: self.tag)
        }

       // closeCellDelegate.closeCellFromOtherCell()
    }
    @IBOutlet var btnSave: UIButton!


    //MARK: - Initial
    override func layoutSubviews() {
        super.layoutSubviews()
        lblDuringTime.verticalAlignment = TTTAttributedLabelVerticalAlignment.top

    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //JMODE ON
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            lblServiceProduct.textAlignment = .right
            lblDuringTime.textAlignment = .right
            lblRangTime.textAlignment = .right
            lblNumCustomers.textAlignment = .right
            lblPrice.textAlignment = .right
            lblServiceName.textAlignment = .right
            txtServiceName.textAlignment = .right
            lblInputServiceName.textAlignment = .right
            lblShowPrice.textAlignment = .right
            txtTimeInterval.textAlignment = .right
            txtPrice.textAlignment = .right
            maxConcurrentCustomers.textAlignment = .right
            txtTimeOfService.textAlignment = .right
        } else {
            lblServiceProduct.textAlignment = .left
            lblDuringTime.textAlignment = .left
            lblRangTime.textAlignment = .left
            lblNumCustomers.textAlignment = .left
            lblPrice.textAlignment = .left
            lblServiceName.textAlignment = .left
            txtServiceName.textAlignment = .left
            lblInputServiceName.textAlignment = .left
            lblShowPrice.textAlignment = .left
            txtTimeInterval.textAlignment = .left
            txtPrice.textAlignment = .left
            maxConcurrentCustomers.textAlignment = .left
            txtTimeOfService.textAlignment = .left
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            lblServiceProduct.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblDuringTime.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblRangTime.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblNumCustomers.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblPrice.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblServiceName.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            txtServiceName.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblInputServiceName.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            lblShowPrice.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            txtTimeInterval.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            txtPrice.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            maxConcurrentCustomers.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            txtTimeOfService.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
            self.btnHEIGHT.constant = 90
            self.dyanmicrowHEIGHT.constant = 50
        } else {
            if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
            {
                lblServiceProduct.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblDuringTime.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblRangTime.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblNumCustomers.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblPrice.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblServiceName.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                txtServiceName.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblInputServiceName.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblShowPrice.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                txtTimeInterval.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                txtPrice.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                maxConcurrentCustomers.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                txtTimeOfService.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                self.btnHEIGHT.constant = 35
                self.dyanmicrowHEIGHT.constant = 40
            }
            else
            {
                lblServiceProduct.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                lblDuringTime.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
                lblRangTime.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                lblNumCustomers.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                lblPrice.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                lblServiceName.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                txtServiceName.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                lblInputServiceName.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                lblShowPrice.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                txtTimeInterval.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                txtPrice.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                maxConcurrentCustomers.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                txtTimeOfService.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                self.btnHEIGHT.constant = 35
                self.dyanmicrowHEIGHT.constant = 40
            }
        }

        lblDuringTime.numberOfLines = 2
        //in case of add PRODUCTs
    //  let tapOpenTbl:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openTbl))
    //   viewOpenTable.addGestureRecognizer(tapOpenTbl)
        Global.sharedInstance.GlobalDataVC?.delegateSaveBussines = self
    //    Global.sharedInstance.businessService = self
        lblServiceProduct.text = "SERVICE_PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
       // lblServiceProduct.sizeToFit()
        lblServiceName.text = "CHOOESE_SERVICE_PRDUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblServiceName.sizeToFit()
        lblPrice.text = "PRICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblShowPrice.text = "SHOW_PRICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblDuringTime.text = "DURING_TIME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblNumCustomers.text = "NUM_IN_PARALLEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblRangTime.text = "TIME_SPACE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnSave.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        lblInputServiceName.text = "SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblServiceName.text = "SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        tblSelectOption.isHidden = true
        txtPrice.delegate = self
        txtPrice.keyboardType = UIKeyboardType.decimalPad
        txtServiceName.delegate = self
        txtTimeInterval.delegate = self
        txtTimeOfService.delegate = self
        maxConcurrentCustomers.delegate = self
        tblSelectOption.delegate = self
        tblSelectOption.dataSource = self
        tblSelectOption.layer.borderColor = UIColor.black.cgColor
        tblSelectOption.layer.borderWidth = 1
        tblSelectOption.allowsSelection = true
        tblSelectOption.backgroundColor = UIColor.black
        tblSelectOption.separatorStyle = .none
        self.tblSelectOption.frame.size.height = 45

        //        txtServiceName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    func setindexPathnumber(_myindexrow:Int) {
        self.myindexrow = _myindexrow
    }
    func setDisplayData(_ service:objProviderServices){
     //   lblServiceProduct.sizeToFit()
        txtServiceName.textColor = UIColor.black
        txtPrice.textColor = UIColor.black
        txtTimeInterval.textColor = UIColor.black
        txtTimeOfService.textColor = UIColor.black
        maxConcurrentCustomers.textColor = UIColor.black

        txtServiceName.text = service.nvServiceName
        if service.nUntilPrice > 0
        {
            if ((Int)( service.iPrice * 10 ) % 10) == 0 && ((Int)( service.nUntilPrice * 10 ) % 10) == 0
            {
                txtPrice.text = "\(String(Int(service.iPrice)))-\(String(Int(service.nUntilPrice)))"
            }
            else if ((Int)( service.iPrice * 10 ) % 10) > 0 && ((Int)( service.nUntilPrice * 10 ) % 10) == 0
            {
                txtPrice.text = "\(String(service.iPrice))-\(String(Int(service.nUntilPrice)))"
            }
            else if ((Int)( service.iPrice * 10 ) % 10) == 0 && ((Int)( service.nUntilPrice * 10 ) % 10) > 0
            {
                txtPrice.text = "\(String(Int(service.iPrice)))-\(String(service.nUntilPrice))"
            }
            else
            {
                txtPrice.text = "\(String(service.iPrice))-\(String(service.nUntilPrice))"
            }
        }
        else
        {
            if ((Int)( service.iPrice * 10 ) % 10) == 0
            {
                txtPrice.text = String(Int(service.iPrice))
            }
            else
            {
                txtPrice.text = String(service.iPrice)
            }
        }

        if service.iServiceType == 90{
            lblInputServiceName.text = "SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            lblServiceName.text = "SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            txtTimeInterval.text = String( service.iTimeInterval)

            if service.iUntilSeviceTime > 0
            {
                if ((Int)( service.iTimeOfService * 10 ) % 10) == 0 && ((Int)( service.iUntilSeviceTime * 10 ) % 10) == 0
                {
                    txtTimeOfService.text = "\(String(Int(service.iTimeOfService)))-\(String(Int(service.iUntilSeviceTime)))"
                }
                else if ((Int)( service.iTimeOfService * 10 ) % 10) > 0 && ((Int)( service.iUntilSeviceTime * 10 ) % 10) == 0
                {
                    txtTimeOfService.text = "\(String(service.iTimeOfService))-\(String(Int(service.iUntilSeviceTime)))"
                }
                else if ((Int)( service.iTimeOfService * 10 ) % 10) == 0 && ((Int)( service.iUntilSeviceTime * 10 ) % 10) > 0
                {
                    txtTimeOfService.text = "\(String(Int(service.iTimeOfService)))-\(String(service.iUntilSeviceTime))"
                }
                else
                {
                    txtTimeOfService.text = "\(String(service.iTimeOfService))-\(String(service.iUntilSeviceTime))"
                }
            }
            else
            {
                if ((Int)( service.iTimeOfService * 10 ) % 10) == 0
                {
                    txtTimeOfService.text = String(Int(service.iTimeOfService))
                }
                else
                {
                    txtTimeOfService.text = String(service.iTimeOfService)
                }
            }

            maxConcurrentCustomers.text = String(service.iMaxConcurrentCustomers)
        }
        else{
            lblInputServiceName.text = "PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            lblServiceName.text = "PRODUCT_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            txtTimeInterval.text = ""
            txtTimeOfService.text = ""
            maxConcurrentCustomers.text = ""

        }
        if service.bDisplayPerCustomer == true
        {
            btnYesSelect.isCecked = true
            btnNoSelect.isCecked = false
        }
        else
        {
            btnNoSelect.isCecked = true
            btnYesSelect.isCecked = false
        }
        initialname = txtServiceName.text!
        initialprice = txtPrice.text!
        initialtime = txtTimeOfService.text!
        initialbtnyes = btnYesSelect.isCecked
        initialnumberofcustomers = maxConcurrentCustomers.text!
        initialtimeinterval = txtTimeInterval.text!
    }

    func setDisplayDataNull()
    {
    //    lblServiceProduct.sizeToFit()
        Global.sharedInstance.isNewServicePlusOpen = true // נדלק לאחר שהוסיף שרות או מוצר, כדי שבעת גלילה לא יתרוקנו הנתונים
        txtTimeInterval.text = "0"
        txtPrice.text = ""
        txtServiceName.text = ""
        txtTimeOfService.text = ""
        maxConcurrentCustomers.text = "1"
        btnYesSelect.isCecked = true
        btnNoSelect.isCecked = false
        initialname = ""
        initialprice = ""
        initialtime = ""
        initialbtnyes = btnYesSelect.isCecked
        initialnumberofcustomers = maxConcurrentCustomers.text!
        initialtimeinterval = txtTimeInterval.text!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }


    //MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView != tblSelectOption{
            return  arrayServiceProduct.count
        }
        return arrayOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView != tblSelectOption{
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")! as UITableViewCell
            cell.textLabel!.text = arrayServiceProduct[indexPath.row]
            cell.textLabel!.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
            cell.textLabel?.textColor = UIColor.white
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarDesignTableViewCell")as!CalendarDesignTableViewCell
        cell.selectionStyle = .none
        cell.lblText?.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
        cell.setDisplayData(arrayOptions[indexPath.row])
        cell.lblText?.textColor = UIColor.white
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {var str:String = ""
        if tableView != tblSelectOption{
        }
        else
        {
            str = arrayOptions[indexPath.row]

        }
        switch (tableView)
        {
        case tblSelectOption:
            lblInputServiceName.text = str
            tblSelectOption.isHidden = true
            btnOpenTbl.tag = 0
            if lblInputServiceName.text == "PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                arrayOptions = ["SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
                lblServiceName.text = "CHOSE_PRODUCT_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                lblServiceName.text = "PRODUCT_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                txtTimeInterval.isEnabled = false
                txtTimeInterval.text = ""
                maxConcurrentCustomers.isEnabled = false
                maxConcurrentCustomers.text = ""
                txtTimeOfService.isEnabled = false
                txtTimeOfService.text = ""
                txtPrice.text = ""
                txtServiceName.text = ""
            }
            else
            {
                lblServiceName.text = "CHOOSE_SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                arrayOptions = ["PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
                lblServiceName.text = "SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                txtTimeInterval.isEnabled = true
                txtTimeOfService.isEnabled = true
                txtTimeInterval.text = "0"
                txtTimeOfService.text = ""
                txtPrice.text = ""
                txtServiceName.text = ""
                maxConcurrentCustomers.isEnabled = true
                maxConcurrentCustomers.text = "1"
            }
        default:
            return

        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 }


    //MARK: - text field
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == txtServiceName
        {
            Global.sharedInstance.isValidServiceName = true
        }





        if textField.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || textField.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE) || textField.text == "ALREADY_USED_SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            textField.text = ""
        }
        textField.textColor = UIColor.black
        selectedTextField = textField


    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txtServiceName
        {
            if txtServiceName.text == "" || txtServiceName.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtServiceName.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtServiceName.text == "ALREADY_USED_SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)

            {
                Global.sharedInstance.isValidServiceName = false
                print("txt service name 7 \(Global.sharedInstance.isValidServiceName)")

            }
            else if isValidString(txtServiceName.text!) == false
            {
                txtServiceName.textColor = UIColor.red
                txtServiceName.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                Global.sharedInstance.isValidServiceName = false
                print("txt service name 8 \(Global.sharedInstance.isValidServiceName)")

            }
            else
            {
                Global.sharedInstance.isValidServiceName = true
                print("txt service name 9 \(Global.sharedInstance.isValidServiceName)")

            }
        }


        else if textField == txtPrice
        {
            if txtPrice.text == "" || txtPrice.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || lblInputServiceName.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

            {
                Global.sharedInstance.isValidPrice = false
            }
            else if validationPrice(txtPrice.text!) == false{
                txtPrice.textColor = UIColor.red
                txtPrice.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                Global.sharedInstance.isValidPrice = false
            }
            else
            {
                Global.sharedInstance.isValidPrice = true
            }

            let arrPrice = Global.sharedInstance.cutStringBySpace(txtPrice.text!, strToCutBy: "-")
            if arrPrice.count == 2
            {
                if Int(arrPrice[1]) < Int(arrPrice[0])
                {
                    txtPrice.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    txtPrice.textColor = UIColor.red
                }
            }


        }
        else if textField == txtTimeOfService
        {
            if txtTimeOfService.text == "" || txtTimeOfService.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtTimeOfService.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                // txtTimeOfService.text = "15"
                txtTimeOfService.text = ""
                Global.sharedInstance.isValidTimeOfService = false
            }
            else if validationTimeOfService(txtTimeOfService.text!) == false{
                //     txtTimeOfService.textColor = UIColor.redColor()
                //\\ txtTimeOfService.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                //   txtTimeOfService.text = "15"
                txtTimeOfService.text = ""
                Global.sharedInstance.isValidTimeOfService = false
            }
            else
            {
                Global.sharedInstance.isValidTimeOfService = true
            }
        }

        else if textField == maxConcurrentCustomers
        {
            if maxConcurrentCustomers.text == "" || maxConcurrentCustomers.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || maxConcurrentCustomers.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

            {
                Global.sharedInstance.isValidMaxConcurrent = false
            }
            else
            {
                Global.sharedInstance.isValidMaxConcurrent = true
            }

            if maxConcurrentCustomers.text! != ""
            {
                let mytext =  maxConcurrentCustomers.text
                let num = Int(mytext!)
                if num != nil {
                    print("Valid Integer")
                    if CInt(maxConcurrentCustomers.text!)! < 1  {
                        maxConcurrentCustomers.text = "1"
                    }
                }
                else {
                    print("Not Valid Integer")
                    maxConcurrentCustomers.textColor = UIColor.red
                    maxConcurrentCustomers.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                }

            }

        }
        else if textField == txtTimeInterval //aaaa
        {
            if txtTimeInterval.text == "" || txtTimeInterval.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtTimeInterval.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                Global.sharedInstance.isValidTimeInterval = false
            }
            else
            {
                let mystr = txtTimeInterval.text!
                if mystr.floatValue != nil  {
                    Global.sharedInstance.isValidTimeInterval = true
                } else  {
                    txtTimeInterval.textColor = UIColor.red
                    txtTimeInterval.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                }

            }
        }



    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch(textField){
        case(txtServiceName):
            txtPrice.becomeFirstResponder()
        case(txtPrice):
            txtTimeOfService.becomeFirstResponder()
        case(txtTimeOfService):
            maxConcurrentCustomers.becomeFirstResponder()
        case(maxConcurrentCustomers):
            txtTimeInterval.becomeFirstResponder()
        case(txtTimeInterval):
            txtTimeInterval.resignFirstResponder()
        default:
            txtServiceName.becomeFirstResponder()
        }
        return true
    }


    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        var startString = ""
        if (textField.text != nil)
        {
            startString += textField.text!
        }
        startString += string

        if textField.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            textField.textColor = UIColor.black
            textField.text = ""
        }
        else
        {
            if textField == txtTimeInterval
            {
                if startString.count > 2
                {
                    showAlert("ENTER_ONLY2_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    return false
                }
                else
                {
                    return true
                }
            }

            else if textField == maxConcurrentCustomers
            {
                if startString.count > 3
                {
                    showAlert("ENTER_ONLY3_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    return false
                }
                else
                {
                    return true
                }
            }
            else if textField == txtTimeOfService
            {
                if startString.count > 3
                {
                    if startString.range(of: "-") == nil
                    {
                        showAlert("ENTER_ONLY3_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return false
                    }

                    else if startString.count > (startString.distance(from: startString.startIndex, to: startString.range(of: "-")!.upperBound)) + 3
                    {
                        showAlert("ENTER_ONLY3_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return false
                    }
                    else
                    {
                        return true
                    }
                }
                else
                {
                    return true
                }
            }
            else if textField == txtPrice
            {
                if startString.count > 6
                {
                    if startString.range(of: "-") == nil
                    {
                        showAlert("ENTER_ONLY6_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return false
                    }

                    else if startString.count > (startString.distance(from: startString.startIndex, to: startString.range(of: "-")!.upperBound)) + 6
                    {
                        showAlert("ENTER_ONLY6_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return false
                    }
                    else
                    {
                        return true
                    }
                }
                else
                {
                    return true
                }
            }
//            else if textField == txtServiceName
//            {
//                if (UIDevice.current.model.range(of: "iPad") != nil)
//                {
//                    if startString.count > 10
//                    {
//                        showAlert("ENTER_ONLY10_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        return false
//                    }
//                    else
//                    {
//                        return true
//                    }
//                }
//                else
//                {
//                    if startString.count > 10
//                    {
//                        showAlert("ENTER_ONLY10_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        return false
//                    }
//                    else
//                    {
//                        return true
//                    }
//                }
//
//
//            }
        }
        return true
    }

    //for service Name
    func isValidString(_ name:String)->Bool
    {
        var numSpace = 0
        //        let quotedName = name.quoted
        for chr in name {

            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z")  && !(chr >= "א" && chr <= "ת") && !(chr >= "0" && chr <= "9") && chr != " " && chr != "’" && chr != "‘"  && chr != "“" && chr != "'" && chr != "\"" && chr != "”" && chr != "“" && chr != "”" && chr != "׳" && (name.isRussiantext(title: name) == false) )
            {
                print("chr is \(chr)")
                return false

            }
            if chr == " "
            {
                numSpace += 1
            }
        }
        if numSpace == name.count || numSpace == name.count - 1// אם יש רק רווחים או רק אות אחת והשאר רווחים
        {
            return false

        }
        return true
    }
    //for price
    func validationPrice(_ price:String) -> Bool
    {
        var numOfChar = 0
        var numOfPoints = 0
        fromPrice = 0.0
        untilPrice = 0.0
        for char in price
        {

            if !(char >= "0" && char <= "9") && char != "-" && char != "."
            {
                return false
            }
            if char == "-"
            {
                numOfChar += 1

                if numOfChar > 1
                {
                    return false
                }
            }
            else if char == "."
            {
                numOfPoints += 1
                if numOfPoints > 2
                {
                    return false
                }
            }

        }
        // var arr:Array<String> = []
        if numOfChar == 1
        {
            var arr = price.components(separatedBy: "-")

            if arr.count != 2
            {
                return false
            }
            else if Float(arr[0]) > Float(arr[1]) || Float(arr[0]) > 999999 || Float(arr[1]) > 999999
            {
                return false
            }

            var tok = 0
            while let foundRange = arr[0].range(of: ".", options: .diacriticInsensitive) {
                arr[0] = arr[0].replacingCharacters(in: foundRange, with: "")
                tok += 1
            }
            var tok1 = 0
            while let foundRange = arr[1].range(of: ".", options: .diacriticInsensitive) {
                arr[1] = arr[1].replacingCharacters(in: foundRange, with: "")
                tok1 += 1
            }
            if   arr[0].range(of:".") != nil && tok == 1
                //   if arr[0].range(of: ".") != nil && arr[0].range(of: ".")!.count == 1
            {
                let range: Range<String.Index> = arr[0].range(of: ".")!
                let index: Int = arr[0].distance(from: arr[0].startIndex, to: range.lowerBound)
                if index == 0 || index == arr[0].count
                {
                    return false
                }
            }
            //  if arr[1].range(of: ".") != nil && arr[1].range(of: ".")!.count == 1
            if   arr[0].range(of:".") != nil && tok1 == 1
            {
                let range: Range<String.Index> = arr[1].range(of: ".")!
                let index: Int = arr[0].distance(from: arr[0].startIndex, to: range.lowerBound)
                if index == 0 || index == (arr[1].count - 1)
                {
                    return false
                }
            }

            fromPrice = Float(arr[0])!
            untilPrice = Float(arr[1])!

            return true
        }
        else//אין -
        {
            let mystr = txtPrice.text!
            if let b = mystr.floatValue  {
                fromPrice = b
            } else  {
                return false
            }
            return true
        }

    }
    //for time of service
    func validationTimeOfService(_ timeOfService:String) -> Bool
    {
        fromServiceTime = 0
        untilServiceTime = 0
        var numOfChar = 0
        for char in timeOfService
        {

            if !(char >= "0" && char <= "9") && char != "-"
            {
                return false
            }
            if char == "-"
            {
                numOfChar += 1

                if numOfChar > 1
                {
                    return false
                }
            }
        }
        //var arr:Array<String> = []
        if numOfChar == 1
        {
            let arr = timeOfService.components(separatedBy: "-")

            if arr.count != 2
            {
                return false
            }
            else if Int(arr[0]) > Int(arr[1]) || Int(arr[0]) > 999 || Int(arr[1]) > 999
            {
                return false
            }
            fromServiceTime = Int(arr[0])!
            untilServiceTime = Int(arr[1])!
            return true
        }
        fromServiceTime = Int(txtTimeOfService.text!)!
        // if fromServiceTime < 15 {
        if fromServiceTime < 5 {
            return false
        }
        return true

    }



    func showAlert(_ mess:String)
    {
        let alertController = UIAlertController(title: "", message:
            mess, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default,handler: nil))
     //   Global.sharedInstance.GlobalDataVC!.present(alertController, animated: true, completion: nil)

        if let topController = UIApplication.topViewController() {
            topController.present(alertController, animated: true, completion: nil)
        }


    }

    func  saveDataToWorker()->Bool
    {

        Global.sharedInstance.fIsSaveConBussinesServicesPressed = true
        Global.sharedInstance.selectedCellForEditService.append(false)



        if let _ = lblInputServiceName.text
        {
            if lblInputServiceName.text == "SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                if let _ = txtPrice.text
                {
                    if txtPrice.text == "" || txtPrice.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || lblInputServiceName.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

                    {
                        //txtPrice.textColor = UIColor.redColor()
                        // txtPrice.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        Global.sharedInstance.isValidPrice = false
                    }
                    else if validationPrice(txtPrice.text!) == false{
                        txtPrice.textColor = UIColor.red
                        txtPrice.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        Global.sharedInstance.isValidPrice = false
                    }
                    else
                    {
                        Global.sharedInstance.isValidPrice = true
                    }
                }

                if let _ = txtServiceName.text
                {
                    if txtServiceName.text == "" || txtServiceName.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtServiceName.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtServiceName.text == "ALREADY_USED_SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    {
                        // txtServiceName.textColor = UIColor.redColor()
                        //txtServiceName.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        Global.sharedInstance.isValidServiceName = false
                        print("txt service name 10 \(Global.sharedInstance.isValidServiceName)")

                    }

                    else if isValidString(txtServiceName.text!) == false
                    {
                        txtServiceName.textColor = UIColor.red
                        txtServiceName.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        Global.sharedInstance.isValidServiceName = false
                        print("txt service name 11 \(Global.sharedInstance.isValidServiceName)")

                    }
                    else
                    {
                        Global.sharedInstance.isValidServiceName = true
                        print("txt service name 12 \(Global.sharedInstance.isValidServiceName)")

                    }

                }




                //            if txtTimeInterval.text == "" || txtTimeInterval.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtTimeInterval.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                //            {
                //                txtTimeInterval.textColor = UIColor.redColor()
                //                txtTimeInterval.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                //                Global.sharedInstance.isValidTimeInterval = false
                //            }
                //            else
                //            {//מוסלש כי זה ירד משדה חובה בהתאם לאפיון
                Global.sharedInstance.isValidTimeInterval = true
                //}
                if let _ = txtTimeOfService.text
                {
                    if txtTimeOfService.text == "" || txtTimeOfService.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtTimeOfService.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    {
                        //txtTimeOfService.textColor = UIColor.redColor()
                        // txtTimeOfService.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        Global.sharedInstance.isValidTimeOfService = false
                    }
                    else if validationTimeOfService(txtTimeOfService.text!) == false{
                        txtTimeOfService.textColor = UIColor.red
                        txtTimeOfService.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        Global.sharedInstance.isValidTimeOfService = false
                    }
                    else
                    {
                        Global.sharedInstance.isValidTimeOfService = true
                    }
                }


                if let _ = maxConcurrentCustomers.text
                {
                    if maxConcurrentCustomers.text == "" || maxConcurrentCustomers.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || maxConcurrentCustomers.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)

                    {
                        // maxConcurrentCustomers.textColor = UIColor.redColor()
                        // maxConcurrentCustomers.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        Global.sharedInstance.isValidMaxConcurrent = false
                    }
                    else
                    {
                        Global.sharedInstance.isValidMaxConcurrent = true
                    }
                }


            }
            else
            {
                if let _ = txtPrice.text
                {
                    if txtPrice.text == "" || txtPrice.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtPrice.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    {
                        // txtPrice.textColor = UIColor.redColor()f
                        // txtPrice.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        Global.sharedInstance.isValidPrice = false
                    }
                    else if validationPrice(txtPrice.text!) == false{
                        txtPrice.textColor = UIColor.red
                        txtPrice.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        Global.sharedInstance.isValidPrice = false
                    }

                    else
                    {
                        Global.sharedInstance.isValidPrice = true
                    }
                }

                if let _ = txtServiceName.text
                {
                    if txtServiceName.text == "" || txtServiceName.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtServiceName.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtServiceName.text == "ALREADY_USED_SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    {
                        // txtServiceName.textColor = UIColor.redColor()
                        //txtServiceName.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        Global.sharedInstance.isValidServiceName = false
                        print("txt service name 13 \(Global.sharedInstance.isValidServiceName)")

                    }
                    else if isValidString(txtServiceName.text!) == false
                    {
                        txtServiceName.textColor = UIColor.red
                        txtServiceName.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                        Global.sharedInstance.isValidServiceName = false
                        print("txt service name 14 \(Global.sharedInstance.isValidServiceName)")

                    }

                    else
                    {
                        Global.sharedInstance.isValidServiceName = true
                        print("txt service name 15 \(Global.sharedInstance.isValidServiceName)")
                    }
                }


            }
        }



        if lblInputServiceName.text == "SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE) {
        //    delegateSave.reloadTableForSave(self.tag,btnTag:3)

            if txtServiceName.text == "ALREADY_USED_SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE) {
                Global.sharedInstance.isValidServiceName = false
            }
            if (   Global.sharedInstance.isValidPrice == true &&  Global.sharedInstance.isValidServiceName == true &&  Global.sharedInstance.isValidTimeInterval == true &&  Global.sharedInstance.isValidTimeOfService == true &&  Global.sharedInstance.isValidMaxConcurrent == true )
            {




                var objProviderServicess:objProviderServices = objProviderServices()

                print(txtServiceName.text ?? "")

                objProviderServicess = objProviderServices(
                    _nvServiceName: txtServiceName.text!,
                    _iPrice: fromPrice,
                    _nUntilPrice: untilPrice,
                    _iTimeOfService: fromServiceTime,
                    _iUntilSeviceTime: untilServiceTime,
                    _iTimeInterval: Global.sharedInstance.parseJsonToInt(txtTimeInterval.text! as AnyObject),
                    _iMaxConcurrentCustomers: Global.sharedInstance.parseJsonToInt(maxConcurrentCustomers.text! as AnyObject),
                    _iDiscount: 0,
                    _iServiceType:90,_bDisplayPerCustomer:btnYesSelect.isCecked,
                    _iProviderServiceId: 0,
                    _iMinConcurrentCustomers: 0
                )
                finalname = txtServiceName.text!
                finalprice = txtPrice.text!
                finaltime =   txtTimeOfService.text!
                finallbtnyes = btnYesSelect.isCecked
                finalnumberofcustomers = maxConcurrentCustomers.text!
                finaltimeinterval = txtTimeInterval.text!


                if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0 || txtPrice.tag == -11
                {
                    for element:objProviderServices in Global.sharedInstance.generalDetails.arrObjProviderServices
                    {
                        print("before append: \(element.getDic())")
                    }
                    var ok = true
                    for i in Global.sharedInstance.generalDetails.arrObjProviderServices {
                        print("idescr5 \(i.getDic())")
                        if (objProviderServicess.nvServiceName == i.nvServiceName &&
                            objProviderServicess.iPrice == i.iPrice  &&
                            objProviderServicess.iTimeOfService == i.iTimeOfService &&
                            objProviderServicess.bDisplayPerCustomer  == i.bDisplayPerCustomer &&
                            objProviderServicess.iMaxConcurrentCustomers  == i.iMaxConcurrentCustomers &&
                            objProviderServicess.iTimeInterval  == i.iTimeInterval
                            )  {
                            ok = false
                            if Global.sharedInstance.generalDetails.arrObjProviderServices.count != 0 {
                                showAlert("ALREADY_USED_SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                            break
                        }
                    }
                    if ok == true {
                        Global.sharedInstance.generalDetails.arrObjProviderServices.append(objProviderServicess)
                    }

                    for element:objProviderServices in Global.sharedInstance.generalDetails.arrObjProviderServices
                    {
                        print("after append: \(element.getDic())")
                    }
                    fixcrashinnumberofservicestap()
                }
                else{
                    var ok = true
                    for i in Global.sharedInstance.generalDetails.arrObjProviderServices {
                        print("idescr6 \(i.getDic())")
                        if (objProviderServicess.nvServiceName == i.nvServiceName &&
                            objProviderServicess.iPrice == i.iPrice  &&
                            objProviderServicess.iTimeOfService == i.iTimeOfService &&
                            objProviderServicess.bDisplayPerCustomer  == i.bDisplayPerCustomer &&
                            objProviderServicess.iMaxConcurrentCustomers  == i.iMaxConcurrentCustomers &&
                            objProviderServicess.iTimeInterval  == i.iTimeInterval
                            )  {
                            ok = false

                            if (initialname == finalname &&
                                initialprice == finalprice &&
                                initialtime == finaltime &&
                                initialbtnyes == finallbtnyes &&
                                initialnumberofcustomers == finalnumberofcustomers &&
                                initialtimeinterval == finaltimeinterval
                                ) {
                                //hence no edit was made on cell
                            } else {
                                showAlert("ALREADY_USED_SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                break
                            }
                        }
                    }
                    if ok == true {
                        Global.sharedInstance.generalDetails.arrObjProviderServices.remove(at: txtPrice.tag) 
                        Global.sharedInstance.generalDetails.arrObjProviderServices.insert(objProviderServicess, at: txtPrice.tag)
                    }
                    fixcrashinnumberofservicestap()
                }
                Global.sharedInstance.fIsEmptyBussinesServices = false

                //                serviceNameCopy = ""
                return true
            }
            else
            {

                Global.sharedInstance.fIsEmptyBussinesServices = true
                //                serviceNameCopy = ""
                return false
            }

        }
        else{
            ///// PRODUCTS SECTION NOT USED SOMETIME IN FUTURE YOU MUST USE THE ABOVE MODEL FOR SERVICE ALSO HERE
            if Global.sharedInstance.isValidPrice == true &&  Global.sharedInstance.isValidServiceName == true {

             //   delegateSave.reloadTableForSave(self.tag,btnTag: 3)



                var objProviderServicess:objProviderServices = objProviderServices()
                objProviderServicess = objProviderServices(
                    _nvServiceName: txtServiceName.text!,
                    _iPrice: fromPrice,
                    _nUntilPrice: untilPrice,
                    _iTimeOfService: 0,
                    _iUntilSeviceTime: 0,
                    _iTimeInterval: 0,
                    _iMaxConcurrentCustomers: 0,
                    _iDiscount: 0,
                    _iServiceType:89,_bDisplayPerCustomer:btnYesSelect.isCecked,
                    _iProviderServiceId: 0,
                    _iMinConcurrentCustomers: 0
                )



                if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0 || txtPrice.tag == -11
                {
                    for element:objProviderServices in Global.sharedInstance.generalDetails.arrObjProviderServices
                    {
                        print("before append: \(element.getDic())")
                    }
                    var ok = true
                    for i in Global.sharedInstance.generalDetails.arrObjProviderServices {
                        print("idescr7 \(i.getDic())")
                        if (objProviderServicess.nvServiceName == i.nvServiceName && objProviderServicess.iPrice == i.iPrice  && objProviderServicess.iTimeOfService == i.iTimeOfService) {
                            ok = false
                            showAlert("ALREADY_USED_SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            break
                        }
                    }
                    if ok == true {
                        Global.sharedInstance.generalDetails.arrObjProviderServices.append(objProviderServicess)
                    }



                    for element:objProviderServices in Global.sharedInstance.generalDetails.arrObjProviderServices
                    {
                        print("after append: \(element.getDic())")
                    }
                    for element:objProviderServices in Global.sharedInstance.generalDetails.arrObjProviderServices
                    {
                        print("after append: \(element.getDic())")
                    }
                    fixcrashinnumberofservicestap()
                }
                else{
                    var ok = true
                    for i in Global.sharedInstance.generalDetails.arrObjProviderServices {
                        print("idescr8 \(i.getDic())")
                        if (objProviderServicess.nvServiceName == i.nvServiceName && objProviderServicess.iPrice == i.iPrice  && objProviderServicess.iTimeOfService == i.iTimeOfService) {
                            ok = false
                            showAlert("ALREADY_USED_SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            break
                        }
                    }
                    if ok == true {
                        Global.sharedInstance.generalDetails.arrObjProviderServices.remove(at: txtPrice.tag)
                        Global.sharedInstance.generalDetails.arrObjProviderServices.insert(objProviderServicess, at: txtPrice.tag)
                    }
                    fixcrashinnumberofservicestap()
                }
                Global.sharedInstance.fIsEmptyBussinesServices = false
                return true
            }
            else
            {

                Global.sharedInstance.fIsEmptyBussinesServices = true
                return false
            }

        }
        return false
    }
    func fixcrashinnumberofservicestap() {
        if Global.sharedInstance.generalDetails.arrObjProviderServices.count > Global.sharedInstance.selectedCell.count {
            print("what is the difference \(Global.sharedInstance.generalDetails.arrObjProviderServices.count - Global.sharedInstance.selectedCell.count)")
            let howmanytoadd = Global.sharedInstance.generalDetails.arrObjProviderServices.count - Global.sharedInstance.selectedCell.count
            for _ in 0...howmanytoadd {
                Global.sharedInstance.selectedCell.append(false)
            }

        }
    }
    @IBOutlet weak var viewOpenTable: UIView!

    @IBOutlet weak var btnOpenTbl: UIButton!
    @IBAction func btnOpenTbl(_ sender: UIButton) {
        if sender.tag == 0{
            sender.tag = 1
            tblSelectOption.isHidden = false
            tblSelectOption.reloadData()
        }
        else{
            tblSelectOption.isHidden = true
            sender.tag = 0
        }
    }

   @objc  func openTbl()
    {
        if btnOpenTbl.tag == 0{
            btnOpenTbl.tag = 1
            tblSelectOption.isHidden = false
            tblSelectOption.reloadData()
        }
        else{
            tblSelectOption.isHidden = true
            btnOpenTbl.tag = 0
        }
    }




}
