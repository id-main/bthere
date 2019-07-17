//
//  ContactSyncViewController.swift
//  Bthere
//
//  Created by User on 29.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import PhoneNumberKit
import Contacts
protocol hideChooseAllDelegate {
    func hideChooseAll()
}
//דף 5 בהרשמה סנכרון עם אנשי קשר

class ContactSyncViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,hideChooseAllDelegate,UITextFieldDelegate {
    var view8 : loadingBthere?
    var phone:Array<String> = []
    let phoneNumberKit = PhoneNumberKit()
    var x = 0
    var myArray : NSMutableArray = []
    var issearch:Bool = false
    var contactList:Array<Contact> = Array<Contact>()
    var searchcontactList:Array<Contact> = Array<Contact>()
    var generic:Generic = Generic()
    @IBOutlet weak var lblChooseCustomers: UILabel!
    
    @IBOutlet weak var lblChooseAll: UILabel!
    
    @IBOutlet weak var btnChooseAll: UIButton!
    @IBOutlet weak var viewchooseAll: UIView!
    
    @IBOutlet weak var tblCONTACTS: UITableView!
    @IBOutlet weak var txtSearchCustomer: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var BTNSEARCH : UIButton!
    //MARK: - initial
    @IBAction func btnsearch(_ sender: AnyObject?) {
        self.view.endEditing(true)
        let textX: String = txtSearchCustomer.text!
        if textX != "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE) &&  textX.count > 0  {
            let  mysearchtxt = textX
            issearch = true
            let namePredicate =
                NSPredicate(format: "nvContactName contains[cd] %@",mysearchtxt)
            Global.sharedInstance.searchcontactList =  Global.sharedInstance.contactList.filter { namePredicate.evaluate(with: $0) }
            print("names = \(Global.sharedInstance.searchcontactList)")
            if Global.sharedInstance.searchcontactList.count != Global.sharedInstance.contactList.count {
                btnChooseAll.isHidden = true
            }

                self.tblCONTACTS.reloadData()
            
       
        } else {
            issearch = false
            Global.sharedInstance.searchcontactList =  Global.sharedInstance.contactList
           
                self.tblCONTACTS.reloadData()
           
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
                    print ("phoneNumberCustomDefaultRegion \(phoneNumberCustomDefaultRegion)")
                    let newString = modedphone.stringByReplacingFirstOccurrenceOfString(target: String(phoneNumberCustomDefaultRegion), withString: "0")
                    modedphone = newString
                    print("formated number is \(modedphone)")
                }
            }
            catch {
                print("Generic parser error")
            }
            for char in (modedphone)
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
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:52)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtSearchCustomer.delegate = self
        txtSearchCustomer.text = "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            txtSearchCustomer.textAlignment = .right
            lblChooseCustomers.textAlignment = .right
        } else {
            txtSearchCustomer.textAlignment = .left
        }
        lblChooseAll.text = "SELECT_ALL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblChooseCustomers.text = "CHOOSE_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblChooseCustomers.numberOfLines = 1
        lblChooseCustomers.sizeToFit()
        tblCONTACTS.separatorStyle = .none
        btnChooseAll.isHidden = true
        Global.sharedInstance.searchcontactList = Array<Contact>()
        var contactListclean:Array<Contact> = Array<Contact>()
        for item in Global.sharedInstance.contactList {
            let mynumber =  item.nvPhone
            var cleannumber:String = ""
             cleannumber = self.cleanPhoneNumber(mynumber)
             if cleannumber.count > 2 {

                let numertocompare = cleannumber
                let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
                    //avoid bad number
            } else {
                if !contactListclean.contains(item) {
                    contactListclean.append(item)
                }
            }
             } else {
                //do nothing
            }
        }
         Global.sharedInstance.contactList = contactListclean
        Global.sharedInstance.searchcontactList =  Global.sharedInstance.contactList
        for contact in Global.sharedInstance.contactList
        {
            print("contact gasit \(contact.nvContactName)")
            contact.bIsSync = false
        }
        
        let tapViewAll:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseAll))
        
        viewchooseAll.addGestureRecognizer(tapViewAll)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if x == 0
        {
            let viewCon:PopSyncContactViewController = storyboard.instantiateViewController(withIdentifier: "PopSyncContactViewController") as! PopSyncContactViewController
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        //    viewCon.isfromsettings = false
            //viewCon.delegate = Global.sharedInstance.rgisterModelViewController
            self.present(viewCon, animated: true, completion: nil)
            x = 1
        }
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            lblChooseCustomers.font = UIFont(name: "OpenSansHebrew-Regular", size: 12.5)
            lblChooseAll.font = UIFont(name: "OpenSansHebrew-Regular", size: 12.5)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if issearch == false {
            return Global.sharedInstance.contactList.count
        } else {
            return Global.sharedInstance.searchcontactList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "ContactManSyncTableViewCell")as!ContactManSyncTableViewCell
        cell.delegate = self
        cell.btnISsync.tag = indexPath.row
        cell.btnISsync.isUserInteractionEnabled = false
        if issearch == false {
            cell.setDisplayData(Global.sharedInstance.contactList[indexPath.row].nvContactName)
            cell.btnISsync.isHidden = !Global.sharedInstance.contactList[indexPath.row].bIsSync
        } else {
            cell.setDisplayData(Global.sharedInstance.searchcontactList[indexPath.row].nvContactName)
            cell.btnISsync.isHidden = !Global.sharedInstance.searchcontactList[indexPath.row].bIsSync
        }
        cell.selectionStyle = .none
        if indexPath.row == 0
        {
            cell.viewTOp.isHidden = false
        }
        else{
            cell.viewTOp.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnChooseAll.isHidden = true
        if issearch == false {
            if (tableView.cellForRow(at: indexPath)as!ContactManSyncTableViewCell).btnISsync.isHidden == true//כדי להדליק איש קשר
            {
                (tableView.cellForRow(at: indexPath)as!ContactManSyncTableViewCell).btnISsync.isHidden = false
                Global.sharedInstance.contactList[indexPath.row].bIsSync = true
                
                var isChooseAll = true
                //בדיקה האם להדליק את הכפתור- בחר הכל, אם בחרתי את כולם
                for Item in Global.sharedInstance.contactList
                {
                    if Item.bIsSync == false
                    {
                        isChooseAll = false
                        break
                    }
                }
                if isChooseAll == true
                {
                    btnChooseAll.isHidden = false
                }
            }
            else//כדי לכבות איש קשר
            {
                (tableView.cellForRow(at: indexPath)as!ContactManSyncTableViewCell).btnISsync.isHidden = true
                Global.sharedInstance.contactList[indexPath.row].bIsSync = false
                btnChooseAll.isHidden = true
            }
            Global.sharedInstance.searchcontactList = Global.sharedInstance.contactList
        }
        if issearch == true {
            
            if (tableView.cellForRow(at: indexPath)as!ContactManSyncTableViewCell).btnISsync.isHidden == true//כדי להדליק איש קשר
            {
                (tableView.cellForRow(at: indexPath)as!ContactManSyncTableViewCell).btnISsync.isHidden = false
                Global.sharedInstance.searchcontactList[indexPath.row].bIsSync = true
                
                var isChooseAll = true
                //בדיקה האם להדליק את הכפתור- בחר הכל, אם בחרתי את כולם
                for Item in Global.sharedInstance.searchcontactList
                {
                    if Item.bIsSync == false
                    {
                        isChooseAll = false
                        break
                    }
                }
                if Global.sharedInstance.searchcontactList.count != Global.sharedInstance.contactList.count {
                    isChooseAll = false
                }
                if isChooseAll == true
                {
                    btnChooseAll.isHidden = false
                }
            }
            else//כדי לכבות איש קשר
            {
                (tableView.cellForRow(at: indexPath)as!ContactManSyncTableViewCell).btnISsync.isHidden = true
                Global.sharedInstance.searchcontactList[indexPath.row].bIsSync = false
                btnChooseAll.isHidden = true
            }
            let indexOfA:Int = Global.sharedInstance.contactList.index(of: Global.sharedInstance.searchcontactList[indexPath.row])!
            print("indexOfA \(indexOfA)")
            Global.sharedInstance.contactList[indexOfA].bIsSync = Global.sharedInstance.searchcontactList[indexPath.row].bIsSync
        }
        
        self.tblCONTACTS.reloadData()
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height*0.18
    }
    
    @objc func chooseAll()
    {
        if issearch == false {
            
            if btnChooseAll.isHidden == true
            {
                btnChooseAll.isHidden = false
                for contact in Global.sharedInstance.contactList
                {
                    contact.bIsSync = true
                }
            }
            else
            {
                btnChooseAll.isHidden = true
                for contact in Global.sharedInstance.contactList
                {
                    contact.bIsSync = false
                }
            }
            Global.sharedInstance.searchcontactList = Global.sharedInstance.contactList
            tblCONTACTS.reloadData()
        } else {
            if btnChooseAll.isHidden == true
            {
                btnChooseAll.isHidden = false
                for contact in Global.sharedInstance.searchcontactList
                {
                  
                    contact.bIsSync = true
                  
                   
                    
                }
                for i in 0..<Global.sharedInstance.searchcontactList.count {
                    let z:Contact = Global.sharedInstance.searchcontactList[i]
                    
                    if let _:Int = Global.sharedInstance.contactList.index(of: z) {
                        let indexOfA:Int = Global.sharedInstance.contactList.index(of: z)!
                        print("indexOfA \(indexOfA)")
                        Global.sharedInstance.contactList[indexOfA].bIsSync = z.bIsSync
                    }
                }
            }
            else
            {
                btnChooseAll.isHidden = true
                for contact in Global.sharedInstance.searchcontactList
                {
                    contact.bIsSync = false
                }
                for i in 0..<Global.sharedInstance.searchcontactList.count {
                    let z:Contact = Global.sharedInstance.searchcontactList[i]
                    
                    if let _:Int = Global.sharedInstance.contactList.index(of: z) {
                        let indexOfA:Int = Global.sharedInstance.contactList.index(of: z)!
                        print("indexOfA \(indexOfA)")
                        Global.sharedInstance.contactList[indexOfA].bIsSync = z.bIsSync
                    }
                }
            
            }
            
            //Global.sharedInstance.contactList = Global.sharedInstance.searchcontactList
            tblCONTACTS.reloadData()
        }
    }
    
    
    
    //פונקציה המופעלת בעת לחיצה על כפתור של איש קשר כדי לכבותו,
    //הפונקציה מכבה את הכפתור ״בחר הכל״
    func hideChooseAll()
    {
        btnChooseAll.isHidden = true
    }
    func textFieldDidChange(_ textField: UITextField) {
        //Working code JMODE+
        if textField.text?.count == 0 {
            issearch = false
            dismissKeyBoard()
            btnsearch(nil)
        }
    }
    

    @objc func dismissKeyBoard() {
        
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if textField.text == ""
        {
            textField.text =  "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            issearch = false
            textField.resignFirstResponder()
           
                self.tblCONTACTS.reloadData()
            
        } else if  textField.text ==  "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE) {
            issearch = false
            textField.resignFirstResponder()
           
                self.tblCONTACTS.reloadData()
            
        }
        else {
            issearch = true
            //execute search without tap button keeps selected values
            for i in 0..<Global.sharedInstance.searchcontactList.count {
                let z:Contact = Global.sharedInstance.searchcontactList[i]
                
                if let _:Int = Global.sharedInstance.contactList.index(of: z) {
                    let indexOfA:Int = Global.sharedInstance.contactList.index(of: z)!
                    print("indexOfA \(indexOfA)")
                    Global.sharedInstance.contactList[indexOfA].bIsSync = z.bIsSync
                }
            }
            
            self.btnsearch(nil)
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtSearchCustomer
        {
            if textField.text == "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                textField.text = ""
            }
        }
    }
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        var startString = ""
        if (textField.text != nil)
        {
            startString += textField.text!
        }
        startString += string
    //    if startString.characters.count == 0 ||
        if startString.trimmingCharacters(in: .whitespaces).isEmpty || startString == "" || startString.count == 0 {
            // string contains non-whitespace characters
        
            textField.text = "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            issearch = false
            dismissKeyBoard()
           
                self.tblCONTACTS.reloadData()
        
            return false
        }
        else
        {
            issearch = true
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtSearchCustomer
        {
            var startString = ""
            startString =  textField.text!
            
            if textField.text == "" ||  startString.trimmingCharacters(in: .whitespaces).isEmpty  || startString == "" || startString.count == 0
            {
                textField.text = "SEARCH_CONTACT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                issearch = false
                dismissKeyBoard()
                 Global.sharedInstance.searchcontactList =  Global.sharedInstance.contactList
               
                    self.tblCONTACTS.reloadData()
                
            }
        }
    }
    
}

