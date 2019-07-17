//
//  JoEditServiceViewController.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 29/03/2018
//  Copyright © 2018 Bthere. All rights reserved.
//

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



class JoEditServiceViewController: NavigationModelViewController, UIGestureRecognizerDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    var delegateReloadTbl:reloadTblServiceDelegte!=nil
    var minusHEIGHT:CGFloat = 120
    var originframe:CGFloat = 0
   
    var arrayOptions:Array<String> = ["PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var currenttextfieldtag:Int = 10
    var DELEGATERELOAD:reloadTblDelegateParent!=nil
    @IBOutlet weak var NEWSCROLLVIEW: UIScrollView!
    @IBOutlet weak var tblSelectOption: UITableView!
    @IBOutlet weak var lblServiceProduct: UILabel!
    @IBOutlet weak var lblDuringTime: TTTAttributedLabel!
    @IBOutlet weak var lblSale: TTTAttributedLabel!
    @IBOutlet weak var lblRangTime: UILabel!
    @IBOutlet weak var lblNumCustomers: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var txtServiceName: UITextField!
    @IBOutlet weak var lblInputServiceName: UILabel!
    @IBOutlet weak var lblShowPrice: UILabel!
    @IBOutlet weak var txtTimeInterval: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var maxConcurrentCustomers: UITextField!
    @IBOutlet weak var txtTimeOfService: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var btnclose: UIButton!
    @IBOutlet weak var blackview: UIView!
    var SERVICETOEDIT:objProviderServices = objProviderServices()
    var INDEXPATHFROMARRAYOTEDIT:Int = 0
    var selectedTextField:UITextField?
    var fromPrice:Float = 0
    var untilPrice:Float = 0
    var fromServiceTime:Int = 0
    var untilServiceTime:Int = 0
    @IBOutlet weak var btnNoSelect: checkBoxForDetailsWorker!
    @IBAction func btnNoSelect(_ sender: AnyObject) {
        btnYesSelect.isCecked = false
        btnNoSelect.isCecked = true
    }
    
    @IBOutlet weak var btnYesSelect: CheckBoxForDetailsWorker2!
    @IBAction func btnYesSelect(_ sender: AnyObject) {
        btnYesSelect.isCecked = true
        btnNoSelect.isCecked = false
    }

    @IBAction func btnclose(_ sender: AnyObject) {
       dismissKeyboard()
       dimissViewController()
        
    }
    func saveService()->Bool  {
 
        dismissKeyboard()
        Global.sharedInstance.fIsSaveConBussinesServicesPressed = true
        Global.sharedInstance.selectedCellForEditService.append(false)
        
        if txtDiscount.text == "" || txtDiscount.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtDiscount.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            Global.sharedInstance.isValidDiscount = false
        }
        else
        {
            Global.sharedInstance.isValidDiscount = true
            
            if Global.sharedInstance.fDiscount == false
            {
                Global.sharedInstance.fDiscount = true
                if txtDiscount.text != "0%"
                {
                    txtDiscount.text = txtDiscount.text! + "%"
                }
            }
        }
        if lblInputServiceName.text == "SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
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
            
            if txtServiceName.text == "" || txtServiceName.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtServiceName.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                
            {
                
            
                Global.sharedInstance.isValidServiceName = false
            }
            else if isValidString(txtServiceName.text!) == false
            {
                txtServiceName.textColor = UIColor.red
                txtServiceName.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                Global.sharedInstance.isValidServiceName = false
            }
            else
            {
                Global.sharedInstance.isValidServiceName = true
            }
            
            
            Global.sharedInstance.isValidTimeInterval = true
            
            if txtTimeOfService.text == "" || txtTimeOfService.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtTimeOfService.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                
          
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
            
            if maxConcurrentCustomers.text == "" || maxConcurrentCustomers.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || maxConcurrentCustomers.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                
            {
                
                Global.sharedInstance.isValidMaxConcurrent = false
            }
            else
            {
                Global.sharedInstance.isValidMaxConcurrent = true
            }
        }
        else{
            if txtPrice.text == "" || txtPrice.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtPrice.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
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
            
            if txtServiceName.text == "" || txtServiceName.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtServiceName.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                
               
             
                Global.sharedInstance.isValidServiceName = false

            }
            else if isValidString(txtServiceName.text!) == false
            {
                txtServiceName.textColor = UIColor.red
                txtServiceName.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                Global.sharedInstance.isValidServiceName = false
            }
                
            else
            {
                Global.sharedInstance.isValidServiceName = true
            }
            
        }
        
        if lblInputServiceName.text == "SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE){
            if Global.sharedInstance.isValidDiscount == true &&  Global.sharedInstance.isValidPrice == true &&  Global.sharedInstance.isValidServiceName == true &&  Global.sharedInstance.isValidTimeInterval == true &&  Global.sharedInstance.isValidTimeOfService == true &&  Global.sharedInstance.isValidMaxConcurrent == true
            {
                
                
                let discount = Global.sharedInstance.cutStringBySpace(txtDiscount.text!, strToCutBy: "%")
                
                var objProviderServicess:objProviderServices = objProviderServices()
                
                
                
                objProviderServicess = objProviderServices(
                    _nvServiceName: txtServiceName.text!,
                    _iPrice: fromPrice,
                    _nUntilPrice: untilPrice,
                    _iTimeOfService: fromServiceTime,
                    _iUntilSeviceTime: untilServiceTime,
                    _iTimeInterval: Global.sharedInstance.parseJsonToInt(txtTimeInterval.text! as AnyObject),
                    _iMaxConcurrentCustomers: Global.sharedInstance.parseJsonToInt(maxConcurrentCustomers.text! as AnyObject),
                    _iDiscount: Global.sharedInstance.parseJsonToInt(discount[0] as AnyObject),
                    _iServiceType:90,_bDisplayPerCustomer:btnYesSelect.isCecked,
                    _iProviderServiceId: SERVICETOEDIT.iProviderServiceId,
                    _iMinConcurrentCustomers: 0
                )
                
                 Global.sharedInstance.generalDetails.arrObjProviderServices[INDEXPATHFROMARRAYOTEDIT] = objProviderServicess
               //  Global.sharedInstance.generalDetails.arrObjProviderServices.insert(objProviderServicess, atIndex: INDEXPATHFROMARRAYOTEDIT)
                    
               
                Global.sharedInstance.fIsEmptyBussinesServices = false
                
                return true
            }
            else
            {
                
                Global.sharedInstance.fIsEmptyBussinesServices = true
                return false
            }
            
        }
        else{
            if Global.sharedInstance.isValidPrice == true &&  Global.sharedInstance.isValidServiceName == true {
                
                
                
                let discount = Global.sharedInstance.cutStringBySpace(txtDiscount.text!, strToCutBy: "%")
                
                var objProviderServicess:objProviderServices = objProviderServices()
                objProviderServicess = objProviderServices(
                    _nvServiceName: txtServiceName.text!,
                    _iPrice: fromPrice,
                    _nUntilPrice: untilPrice,
                    _iTimeOfService: 0,
                    _iUntilSeviceTime: 0,
                    _iTimeInterval: 0,
                    _iMaxConcurrentCustomers: 0,
                    _iDiscount: Global.sharedInstance.parseJsonToInt(discount[0] as AnyObject),
                    _iServiceType:89,_bDisplayPerCustomer:btnYesSelect.isCecked,
                    _iProviderServiceId: 0,
                    _iMinConcurrentCustomers: 0
                )
                
                
               
                 Global.sharedInstance.generalDetails.arrObjProviderServices[INDEXPATHFROMARRAYOTEDIT] = objProviderServicess
              // Global.sharedInstance.generalDetails.arrObjProviderServices.insert(objProviderServicess, atIndex: INDEXPATHFROMARRAYOTEDIT)
                
             
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
    @IBAction func btnsave(_ sender: AnyObject){
        dismissKeyboard()
        if saveService() == true {
           
            let USERDEF = UserDefaults.standard
                USERDEF.set(1, forKey: "RELOADAFTERSERVICEADD")
                USERDEF.synchronize()
                DELEGATERELOAD.reloadTbl()
             dimissViewController()

        } else {
            showAlert("COMPLETE_REQUIRED_FIELDS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
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
    
    @objc func openTbl()
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
       override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        setDisplayDataNull()
        NEWSCROLLVIEW.delegate = self
        NEWSCROLLVIEW.isScrollEnabled = true
         let Screenheight = UIScreen.main.bounds.size.height
        let contentsize:CGSize = CGSize ( width: self.view.frame.size.width, height: Screenheight * 1.2)
        print("contentsize \(contentsize.height) si \(self.NEWSCROLLVIEW.contentInset)")
        print("SERVICETOEDIT \(SERVICETOEDIT.getDic()) and indexrow in great array \(INDEXPATHFROMARRAYOTEDIT)")
        //SERVICETOEDIT ["nUntilPrice": 0, "iUntilSeviceTime": 0, "iMaxConcurrentCustomers": 1, "iTimeOfService": 90, "iServiceType": 90, "iPrice": 150, "bDisplayPerCustomer": 1, "iProviderServiceId": 2943, "iMinConcurrentCustomers": 0, "nvServiceName": אימון ראשון כולל ייעוץ תזונתי, "iTimeInterval": 0, "iDiscount": 0] and indexrow in great array 0
        self.NEWSCROLLVIEW.contentSize = contentsize
        originframe = NEWSCROLLVIEW.frame.origin.y
        drawelements()
      
    }
      func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOptions.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //func to dismiss the popUp
    @objc  func dimissViewController()  {
  
        self.dismiss(animated: false, completion: nil)
        
    }
    func drawelements(){
    if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
    lblServiceProduct.textAlignment = .right
    lblDuringTime.textAlignment = .right
    lblSale.textAlignment = .right
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
    txtDiscount.textAlignment = .right
    
    
    } else {
    lblServiceProduct.textAlignment = .left
    lblDuringTime.textAlignment = .left
    lblSale.textAlignment = .left
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
    txtDiscount.textAlignment = .left
    }
    if UIDevice.current.userInterfaceIdiom == .pad {
    lblServiceProduct.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
    lblDuringTime.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
    lblSale.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
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
    txtDiscount.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
    } else {
    if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
    {
    lblServiceProduct.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
    lblDuringTime.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
    lblSale.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
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
    txtDiscount.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
    }
    else
    {
    lblServiceProduct.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
    lblDuringTime.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
    lblSale.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
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
    txtDiscount.font = UIFont(name: "OpenSansHebrew-Light", size: 16)

    }
        
    }
    lblServiceProduct.textColor = UIColor.lightGray
    lblDuringTime.numberOfLines = 2
   
    lblServiceProduct.text = "SERVICE_PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    lblServiceProduct.sizeToFit()
    lblServiceName.text = "CHOOESE_SERVICE_PRDUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    lblServiceName.sizeToFit()
    lblPrice.text = "PRICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    lblShowPrice.text = "SHOW_PRICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    lblDuringTime.text = "DURING_TIME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    lblNumCustomers.text = "NUM_IN_PARALLEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    lblRangTime.text = "TIME_SPACE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    lblSale.text = "DISCOUNT_ENTER_SOME_TURN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    lblSale.numberOfLines = 0
    lblSale.verticalAlignment = TTTAttributedLabelVerticalAlignment.top
    lblInputServiceName.text = "SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    lblServiceName.text = "SERVICE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    tblSelectOption.isHidden = true
    txtDiscount.delegate = self
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
    let closeallkeys:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    closeallkeys.cancelsTouchesInView = false
    self.view.addGestureRecognizer(closeallkeys)
    btnclose.setTitle("CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
    btnsave.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
   // let tapOpenTbl:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openTbl))

   // viewOpenTable.addGestureRecognizer(tapOpenTbl)
    self.view.bringSubviewToFront(viewOpenTable)
    self.view.bringSubviewToFront(tblSelectOption)
    setDisplayData(self.SERVICETOEDIT)
    }
    //txtfields
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
         self.NEWSCROLLVIEW.frame.origin.y = originframe
        //because nsnotif for keyboard show is not working anymore need this hc fix
               return true;
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let calculateheight:CGFloat = textField.superview!.superview!.frame.origin.y
                          
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: calculateheight, right: 0.0)
        
        self.NEWSCROLLVIEW.contentInset = contentInsets
        self.NEWSCROLLVIEW.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = UIScreen.main.bounds
        aRect.size.height -= calculateheight
    
            
            if (!aRect.contains(textField.superview!.superview!.frame.origin))
            {
                self.NEWSCROLLVIEW.scrollRectToVisible(textField.superview!.superview!.frame, animated: true)
            }
        

        if textField.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || textField.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            textField.text = ""
        }
        textField.textColor = UIColor.black
        selectedTextField = textField
        
        if textField == txtDiscount
        {
            if textField.text == "0%"
            {
                Global.sharedInstance.fDiscount = false
                textField.text = ""
            }
            else if textField.text == ""
            {
                Global.sharedInstance.fDiscount = false
            }
            else if txtDiscount.text!.range(of: "%") != nil
            {
                Global.sharedInstance.fDiscount = false
                txtDiscount.text =  txtDiscount.text!.substring(to: txtDiscount.text!.characters.index(before: txtDiscount.text!.endIndex))
            }
        }

    }
    //for service Name
    func isValidString(_ name:String)->Bool
    {
        var numSpace = 0
        for chr in name.characters {
             if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z")  && !(chr >= "א" && chr <= "ת") && !(chr >= "0" && chr <= "9") && chr != " " && chr != "’" && chr != "‘"  && chr != "“" && chr != "'" && chr != "\"" && chr != "”" && chr != "“" && chr != "”" && chr != "׳" && (name.isRussiantext(title: name) == false) )
            {
                return false
            }
            if chr == " "
            {
                numSpace += 1
            }
        }
        if numSpace == name.characters.count || numSpace == name.characters.count - 1// אם יש רק רווחים או רק אות אחת והשאר רווחים
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
        for char in (price.characters)
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
                let index: Int = arr[0].characters.distance(from: arr[0].startIndex, to: range.lowerBound)
                if index == 0 || index == arr[0].characters.count
                {
                    return false
                }
            }
          //  if arr[1].range(of: ".") != nil && arr[1].range(of: ".")!.count == 1
             if   arr[0].range(of:".") != nil && tok1 == 1
            {
                let range: Range<String.Index> = arr[1].range(of: ".")!
                let index: Int = arr[0].characters.distance(from: arr[0].startIndex, to: range.lowerBound)
                if index == 0 || index == (arr[1].characters.count - 1)
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
            fromPrice = Float(txtPrice.text!)!
            return true
        }
        
    }
    //for time of service
    func validationTimeOfService(_ timeOfService:String) -> Bool
    {
        fromServiceTime = 0
        untilServiceTime = 0
        var numOfChar = 0
        for char in (timeOfService.characters)
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
       self.present(alertController, animated: true, completion: nil)
        
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
                if startString.characters.count > 2
                {
                    showAlert("ENTER_ONLY2_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    return false
                }
                else
                {
                    return true
                }
            }
            else if textField == txtDiscount
            {
                if startString.range(of: "%") == nil
                {
                    Global.sharedInstance.fDiscount = false
                }
                if startString.characters.count > 2
                {
                    if string == ""
                    {
                        return true
                    }
                    else
                    {
                        showAlert("ENTER_ONLY2_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return false
                    }
                }
                else
                {
                    return true
                }
                
            }
            else if textField == maxConcurrentCustomers
            {
                if startString.characters.count > 3
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
                if startString.characters.count > 3
                {
                    if startString.range(of: "-") == nil
                    {
                        showAlert("ENTER_ONLY3_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return false
                    }
                        
                    else if startString.characters.count > (startString.characters.distance(from: startString.startIndex, to: startString.range(of: "-")!.upperBound)) + 3
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
                if startString.characters.count > 6
                {
                    if startString.range(of: "-") == nil
                    {
                        showAlert("ENTER_ONLY6_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return false
                    }
                        
                    else if startString.characters.count > (startString.characters.distance(from: startString.startIndex, to: startString.range(of: "-")!.upperBound)) + 6
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
            else if textField == txtServiceName
            {
                if startString.characters.count > 30
                {
                    showAlert("ENTER_ONLY30_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
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

//
//    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//        dismissKeyboard()
//         let Screenheight = UIScreen.mainScreen().bounds.size.height
//        let contentsize:CGSize = CGSizeMake ( self.view.frame.size.width, Screenheight * 1.2)
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
//        self.NEWSCROLLVIEW.contentInset = contentInsets
//        self.NEWSCROLLVIEW.scrollIndicatorInsets = contentInsets
//        self.NEWSCROLLVIEW.contentSize = contentsize
//         self.NEWSCROLLVIEW.frame.origin.y = originframe
//      
//        return true
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtServiceName
        {
            if txtServiceName.text == "" || txtServiceName.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtServiceName.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                
            {
                Global.sharedInstance.isValidServiceName = false
            }
            else if isValidString(txtServiceName.text!) == false
            {
                txtServiceName.textColor = UIColor.red
                txtServiceName.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                Global.sharedInstance.isValidServiceName = false
            }
            else
            {
                Global.sharedInstance.isValidServiceName = true
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
    
                txtTimeOfService.text = ""
                Global.sharedInstance.isValidTimeOfService = false
            }
            else if validationTimeOfService(txtTimeOfService.text!) == false{
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
                if CInt(maxConcurrentCustomers.text!)! < 1  {
                    maxConcurrentCustomers.text = "1"
                }
            }
            
        }
        else if textField == txtTimeInterval
        {
            if txtTimeInterval.text == "" || txtTimeInterval.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE) || txtTimeInterval.text == "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                Global.sharedInstance.isValidTimeInterval = false
            }
            else
            {
                Global.sharedInstance.isValidTimeInterval = true
            }
        }
            
        else if textField == txtDiscount
        {
            if textField.text == ""
            {
                Global.sharedInstance.fDiscount = false
            }
            else if textField.text != "" && ((textField.textColor != UIColor.red && Global.sharedInstance.fDiscount == false) || textField.text?.range(of: "%") == nil)
            {
                Global.sharedInstance.fDiscount = true
                if txtDiscount.text != "0%" {
                    textField.text = textField.text! + "%"
                }
            }
        }
        dismissKeyboard()
        let Screenheight = UIScreen.main.bounds.size.height
        let contentsize:CGSize = CGSize ( width: self.view.frame.size.width, height: Screenheight * 1.2)
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.NEWSCROLLVIEW.contentInset = contentInsets
        self.NEWSCROLLVIEW.scrollIndicatorInsets = contentInsets
        self.NEWSCROLLVIEW.contentSize = contentsize
        self.NEWSCROLLVIEW.frame.origin.y = originframe

    }

    

    @objc func dismissKeyboard() {
      
        self.NEWSCROLLVIEW.frame.origin.y = originframe
        blackview.frame.origin.y = self.NEWSCROLLVIEW.frame.origin.y
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarDesignTableViewCell")as!CalendarDesignTableViewCell
        cell.selectionStyle = .none
        if UIDevice.current.userInterfaceIdiom == .pad {
           cell.lblText?.font = UIFont(name: "OpenSansHebrew-Light", size: 22)
         
        } else {
            if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
            {
               cell.lblText?.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            }
            else
            {
               cell.lblText?.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
        }
        }

        cell.setDisplayData(arrayOptions[indexPath.row])
        cell.lblText?.textColor = UIColor.white
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func setDisplayDataNull()
    {
        lblServiceProduct.sizeToFit()
        txtTimeInterval.text = "0"
        txtDiscount.text = "0%"
        txtPrice.text = ""
        txtServiceName.text = ""
        txtTimeOfService.text = ""
        maxConcurrentCustomers.text = "1"
        btnYesSelect.isCecked = true
        btnNoSelect.isCecked = false
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func setDisplayData(_ service:objProviderServices){
        lblServiceProduct.sizeToFit()
        txtServiceName.textColor = UIColor.black
        txtPrice.textColor = UIColor.black
        txtDiscount.textColor = UIColor.black
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
        
        txtDiscount.text = String(service.iDiscount) + "%"
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

        
        
    }
  
}
