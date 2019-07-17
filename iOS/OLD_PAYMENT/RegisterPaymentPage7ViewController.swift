//
//  RegisterPaymentPage7ViewController.swift
//  BThere
//
//  Created by Lior Ronen on 2/8/16.
//  Copyright © 2016 Sara Zingul. All rights reserved.
//

import UIKit
protocol dismissPayByCardDelegate
{
    func dismissPayByCard()
}
// תת דף 6 בהרשמה  תשלום באמצעות
class RegisterPaymentPage7ViewController: UIViewController {

    var delegate:dismissPayByCardDelegate!=nil
    var cardTypeFlag = false
    var paymentNumFlag = false
    var monthFlag = false
    var yearFlag = false
    var threeDigitsFlag = false
    

    @IBAction func btnSave(_ sender: AnyObject) {
        delegate.dismissPayByCard()
    }
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var tblNumPayments: UITableView!
    
    @IBOutlet weak var tblCardType: UITableView!
    
    @IBOutlet weak var tblYear: UITableView!
    
    @IBOutlet weak var tblMonth: UITableView!
    @IBOutlet weak var tbl3Digits: UITableView!
    
    @IBOutlet weak var creditCardTitle: UILabel!
    
    @IBOutlet weak var cardOwnerName: UILabel!
    
    @IBOutlet weak var txtfcardOwnerName: UITextField!
    
    @IBOutlet weak var cardType: UILabel!
    
    @IBOutlet weak var btnCardType: UIButton!
    
    @IBAction func btnCardType(_ sender: AnyObject) {
        cardTypeFlag = !cardTypeFlag
        openTable(tblCardType, flag: cardTypeFlag)
    }
    
    @IBOutlet weak var btnCardTypeOpen: UIButton!
    
    //סוג הכרטיס
    @IBAction func btnCardTypeOpen(_ sender: AnyObject) {
        cardTypeFlag = !cardTypeFlag
        openTable(tblCardType, flag: cardTypeFlag)
    }
    
    @IBOutlet weak var txtfNumCard: UITextField!
    
    @IBOutlet weak var cardNum: UILabel!
    
    
    @IBOutlet weak var cardvalidity: UILabel!
    
    @IBOutlet weak var btnCardvalidityMonth: UIButton!
    
 //תוקף -  חודש
    @IBAction func btnCardvalidityMonth(_ sender: AnyObject) {
        monthFlag = !monthFlag
        openTable(tblMonth, flag: monthFlag)
    }
    
    @IBOutlet weak var btnCardvalidMOpen: UIButton!
    
    @IBAction func btnCardvalidMOpen(_ sender: AnyObject) {
        monthFlag = !monthFlag
        openTable(tblMonth, flag: monthFlag)
    }
    

    @IBOutlet weak var btnCardvalidityYear: UIButton!
    //תוקף - שנה
    @IBAction func btnCardvalidityYear(_ sender: AnyObject) {
        yearFlag  = !yearFlag
        openTable(tblYear, flag: yearFlag)
    }
    
    @IBOutlet weak var btnCardvalidYOpen: UIButton!
    
    @IBAction func btnCardvalidYOpen(_ sender: AnyObject) {
        
        yearFlag  = !yearFlag
        openTable(tblYear, flag: yearFlag)
    }
    
    @IBOutlet weak var cardBack3Digits: UILabel!
    
    @IBOutlet weak var btnCardBack3Digits: UIButton!
    
    //3 ספרות בגב הכרטיס
    @IBAction func btnCardBack3Digits(_ sender: AnyObject) {
        
        threeDigitsFlag = !threeDigitsFlag
        openTable(tbl3Digits, flag: threeDigitsFlag)
    }
    
    @IBAction func btn3DigitsOpen(_ sender: AnyObject) {
        
        threeDigitsFlag = !threeDigitsFlag
        openTable(tbl3Digits, flag: threeDigitsFlag)
    }

    @IBOutlet weak var btn3DigitsOpen: UIButton!
    
    @IBOutlet weak var paymentsNum: UILabel!
    
    @IBOutlet weak var btnPaymentsNum: UIButton!
    
    @IBAction func btnPaymentsNum(_ sender: AnyObject) {
        paymentNumFlag = !paymentNumFlag
        openTable(tblNumPayments, flag: paymentNumFlag)
    }
    
    @IBOutlet weak var btnPaymentsNumOpen: UIButton!
    
    @IBAction func btnPaymentsNumOpen(_ sender: AnyObject) {
        paymentNumFlag = !paymentNumFlag
        openTable(tblNumPayments, flag: paymentNumFlag)
    }
    
    // MARK: - Initial

    override func viewDidLoad() {
        super.viewDidLoad()
        btnCardType.setTitle("CARD_TYPE_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        btnCardvalidityMonth.setTitle("MONTH".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnCardvalidityYear.setTitle("YEAR".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        creditCardTitle.text = "PAYMENT_CREDIT_CARD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        cardOwnerName.text = "CARD_OWNER_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        cardType.text = "CARD_TYPE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        cardNum.text = "CARD_NUM".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        cardvalidity.text = "CARD_VALIDITY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        cardBack3Digits.text = "BACK_DIGITS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnSave.setTitle("OK_PAY", for: UIControl.State())
        
        tblCardType.isHidden = true
        tblNumPayments.isHidden = true
        tbl3Digits.isHidden = true
        tblMonth.isHidden = true
        tblYear.isHidden = true
        
        txtfcardOwnerName.borderStyle = UITextField.BorderStyle.none
        txtfNumCard.borderStyle = UITextField.BorderStyle.none
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterPaymentPage7ViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            creditCardTitle.font = UIFont(name: "OpenSansHebrew-Bold", size: 15)
            cardOwnerName.font = UIFont(name: "OpenSansHebrew-Light", size: 13)
            cardType.font = UIFont(name: "OpenSansHebrew-Light", size: 13)
            cardNum.font = UIFont(name: "OpenSansHebrew-Light", size: 13)
            cardvalidity.font = UIFont(name: "OpenSansHebrew-Light", size: 13)
            cardBack3Digits.font = UIFont(name: "OpenSansHebrew-Light", size: 13)
        }
        
        

    }

    override func viewWillLayoutSubviews() {
        let bounds = UIScreen.main.bounds
        
        let width = bounds.size.width
        let height = bounds.size.height
        if DeviceType.IS_IPHONE_6P || DeviceType.IS_IPHONE_6
        {
            self.view.superview!.bounds = CGRect(x:0,y:-169,width:width,height: height)
        }
        else if DeviceType.IS_IPHONE_5
        {
            self.view.superview!.bounds = CGRect(x:0,y:-147,width:width,height: height)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Tabel-View
    //======================Tabel-View===========================

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    @objc func openTable(_ tbl:UITableView,flag:Bool)
    {
     if flag == true
     {
        tbl.isHidden = false
     }
        else
        {
        tbl.isHidden = true
        }
    }

    //MARK: - keyboard
    
    //dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
