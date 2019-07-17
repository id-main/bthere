//
//  RegisterContactsPage6ViewController.swift
//  BThere
//
//  Created by Lior Ronen on 2/8/16.
//  Copyright © 2016 Sara Zingul. All rights reserved.
//

import UIKit
import Contacts
import PhoneNumberKit
//דף 5 בהרשמה סנכרון עם אנשי קשר (לבדוק אם משתמשים)
class RegisterContactsPage6ViewController: UIViewController {
    var generic:Generic = Generic()
    let phoneNumberKit = PhoneNumberKit()
    var phone:Array<String> = []
    let imageV:UIImage = UIImage(named: "OK-select-strock-black.png")! //"34.png"
    let imageX:UIImage = UIImage(named: "cancel-select-strock.png")!
    let imageV1:UIImage = UIImage(named: "OK-strock-black.png")!//34-.png
    let imageX1:UIImage = UIImage(named: "35-.png")!
    var flagSync = false
    var flagApproval = false
    var isFirst1 = true
    var isFirst2 = true
    var phones:Array<String> = []

    @IBOutlet weak var btnSyncV: UIButton!
    
    @IBAction func btnSyncV(_ sender: AnyObject) {
        
        if flagSync == false
        {
            for con in Global.sharedInstance.contactList
            {
                if con.nvPhone.count > 2 {
        
                    let numertocompare = con.nvPhone
                    let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                    let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                    if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
                    //ignore all bad numbers
                } else {

                phones.append(con.nvPhone)
                }
                } else {
                    //do nothing
                }
            }
            Global.sharedInstance.dicSyncContacts["nvPhoneList"] = phones as AnyObject
            flagSync = true
            btnSyncV.setBackgroundImage(imageV, for: UIControl.State())
            btnSyncX.setBackgroundImage(imageX1, for: UIControl.State())
            isFirst2 = false
            flagApproval = false
            btnApprovalX.setBackgroundImage(imageX, for: UIControl.State())
            btnApprovalV.setBackgroundImage(imageV1, for: UIControl.State())
            
            ////סימון הכפתור השני בהתאם למה שנבחר פה
            for con in Global.sharedInstance.contactList
            {
                if con.nvPhone.count > 2 {
                    
                    let numertocompare = con.nvPhone
                    let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                    let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                    if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
                        //ignore all bad numbers
                } else {
                    
                    phones.append(con.nvPhone)
                }
                } else {
                    //do nothing
                }
               
            }
            
            Global.sharedInstance.dicSyncContacts["nvPhoneList"] = phones as AnyObject
            flagSync = true
            btnSyncV.setBackgroundImage(imageV, for: UIControl.State())
            btnSyncX.setBackgroundImage(imageX1, for: UIControl.State())
        }
        else
        {
            Global.sharedInstance.dicSyncContacts["nvPhoneList"] = [] as AnyObject
            flagSync = false
            btnSyncV.setBackgroundImage(imageV1, for: UIControl.State())
            btnSyncX.setBackgroundImage(imageX, for: UIControl.State())
            Global.sharedInstance.dicSyncContacts["bAutoApproval"] = true as AnyObject
            flagApproval = true
            btnApprovalV.setBackgroundImage(imageV, for: UIControl.State())
            btnApprovalX.setBackgroundImage(imageX1, for: UIControl.State())
        }
    }
    
    @IBOutlet weak var btnSyncX: UIButton!
    
    @IBAction func btnSyncX(_ sender: AnyObject) {
        
        if flagSync == true || isFirst1 == true
        {
            Global.sharedInstance.dicSyncContacts["nvPhoneList"] = [] as AnyObject
            isFirst1 = false
            flagSync = false
            btnSyncX.setBackgroundImage(imageX, for: UIControl.State())
            btnSyncV.setBackgroundImage(imageV1, for: UIControl.State())
            
            ////סימון השני בהתאם למה שנבחר פה
            Global.sharedInstance.dicSyncContacts["bAutoApproval"] = true as AnyObject
            flagApproval = true
            btnApprovalV.setBackgroundImage(imageV, for: UIControl.State())
            btnApprovalX.setBackgroundImage(imageX1, for: UIControl.State())
        }
        else
        {
            for con in Global.sharedInstance.contactList
            {
                if con.nvPhone.count > 2 {
                    let numertocompare = con.nvPhone
                    let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                    let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                    if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
                        //ignore all bad numbers
                } else {
                    
                    phones.append(con.nvPhone)
                }
                } else {
                 //do nothing
                }
            }
            
            Global.sharedInstance.dicSyncContacts["nvPhoneList"] = phones as AnyObject
            flagSync = true
            btnSyncX.setBackgroundImage(imageX1, for: UIControl.State())
            btnSyncV.setBackgroundImage(imageV, for: UIControl.State())
            ////סימון הכפתור השני בהתאם למה שנבחר פה
            Global.sharedInstance.dicSyncContacts["bAutoApproval"] = false as AnyObject
            isFirst2 = false
            flagApproval = false
            btnApprovalX.setBackgroundImage(imageX, for: UIControl.State())
            btnApprovalV.setBackgroundImage(imageV1, for: UIControl.State())
        }
    }
    
    @IBOutlet weak var btnApprovalV: UIButton!
    
    
    @IBAction func btnApprovalV(_ sender: AnyObject) {
        btnApprovalV.setBackgroundImage(imageV, for: UIControl.State())

        if flagApproval == false
        {
            Global.sharedInstance.dicSyncContacts["bAutoApproval"] = true as AnyObject
            flagApproval = true
            btnApprovalV.setBackgroundImage(imageV, for: UIControl.State())
            btnApprovalX.setBackgroundImage(imageX1, for: UIControl.State())
            ////סימון בחירה ידנית ב-x
            Global.sharedInstance.dicSyncContacts["nvPhoneList"] = [] as AnyObject
            isFirst1 = false
            flagSync = false
            btnSyncX.setBackgroundImage(imageX, for: UIControl.State())
            btnSyncV.setBackgroundImage(imageV1, for: UIControl.State())
        }
        else
        {
            Global.sharedInstance.dicSyncContacts["bAutoApproval"] = false as AnyObject
            flagApproval = false
            btnApprovalV.setBackgroundImage(imageV1, for: UIControl.State())
            btnApprovalX.setBackgroundImage(imageX, for: UIControl.State())
            for con in Global.sharedInstance.contactList
            {
                if con.nvPhone.count > 2 {
                    
                    let numertocompare = con.nvPhone
                    let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                    let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                    if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
                        //ignore all bad numbers
                } else {
                    
                    phones.append(con.nvPhone)
                }
                } else {
                    //do nothing
                }
            
            }
            
            Global.sharedInstance.dicSyncContacts["nvPhoneList"] = phones as AnyObject
            flagSync = true
            btnSyncV.setBackgroundImage(imageV, for: UIControl.State())
            btnSyncX.setBackgroundImage(imageX1, for: UIControl.State())
            isFirst2 = false
            flagApproval = false
            btnApprovalX.setBackgroundImage(imageX, for: UIControl.State())
            btnApprovalV.setBackgroundImage(imageV1, for: UIControl.State())
            
        }
    }
    
    @IBOutlet weak var btnApprovalX: UIButton!
    
    @IBAction func btnApprovalX(_ sender: AnyObject)
    {
        if flagApproval == true || isFirst2 == true
        {
            Global.sharedInstance.dicSyncContacts["bAutoApproval"] = false as AnyObject
            
            isFirst2 = false
            flagApproval = false
            btnApprovalX.setBackgroundImage(imageX, for: UIControl.State())
            btnApprovalV.setBackgroundImage(imageV1, for: UIControl.State())
            
            ////
            for con in Global.sharedInstance.contactList
            {
                if con.nvPhone.count > 2 {
                    
                    let numertocompare = con.nvPhone
                    let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                    let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                    if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
                        //ignore all bad numbers
                } else {
                    
                    phones.append(con.nvPhone)
                }
                } else {
                    //do nothing
                }
            }
            
            Global.sharedInstance.dicSyncContacts["nvPhoneList"] = phones as AnyObject
            
            flagSync = true
            btnSyncV.setBackgroundImage(imageV, for: UIControl.State())
            btnSyncX.setBackgroundImage(imageX1, for: UIControl.State())
        }
        else
        {
            Global.sharedInstance.dicSyncContacts["bAutoApproval"] = true as AnyObject
            
            flagApproval = true
            btnApprovalX.setBackgroundImage(imageX1, for: UIControl.State())
            btnApprovalV.setBackgroundImage(imageV, for: UIControl.State())
            
            ////סימון בחירה ידנית ב-x
            Global.sharedInstance.dicSyncContacts["nvPhoneList"] = [] as AnyObject
            isFirst1 = false
            flagSync = false
            btnSyncX.setBackgroundImage(imageX, for: UIControl.State())
            btnSyncV.setBackgroundImage(imageV1, for: UIControl.State())
        }
    }
    
    @IBOutlet weak var lblSync: UILabel!
    
    @IBOutlet weak var lblApprovalAll: UILabel!
    
    
    @IBOutlet var textViewExplain: UITextView!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    
    
    // MARK: - initial
    func cleanPhoneNumber(_ nvPhone:String) -> String {
        var  cleanphonenumber:String = ""
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
                //\\    print("Generic parser error")
            }
            for char in (modedphone)
            {
                if (char >= "0" && char <= "9") || char == "*"
                {
                    let c:Character = char
                    cleanphonenumber = cleanphonenumber + String(c)
                }
            }
        }
        return cleanphonenumber
    }
    func setContacts() {
        Global.sharedInstance.contactList = []
        let store = CNContactStore()
        print(CNContactStore.authorizationStatus(for: .contacts).hashValue)
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .denied:
            self.generic.hideNativeActivityIndicator(self)
            print("ask")
            let alert = UIAlertController(title: nil, message: "REQUEST_CONTACTS_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
            })
            var rootViewController = UIApplication.shared.keyWindow?.rootViewController
            if let navigationController = rootViewController as? UINavigationController {
                rootViewController = navigationController.viewControllers.first
            }
            if let tabBarController = rootViewController as? UITabBarController {
                rootViewController = tabBarController.selectedViewController
            }
            rootViewController?.present(alert, animated: true, completion: nil)
        case .authorized:
            print("access granted")
            // getContactNames()
            // print("lazy \(self.contacts)")
            var contactsFull: [CNContact] = []
            contactsFull = self.contacts
            /////// JMODE PLUS NEW iOS 10 CONTACT LOCATIONS ////////
            
            var indexForUserid : Int = 0
            
            for record:CNContact in contactsFull
            {
                phone = []
                let contactPerson: CNContact = record
                var givenName = ""
                var familyName = ""
                var numecompus = ""
                var MobNumVar = ""
                
                givenName = contactPerson.givenName;
                familyName = contactPerson.familyName;
                numecompus = givenName + " " + familyName
                if contactPerson.phoneNumbers.count > 0 {
                    //person has 1 or more numbers
                    for i in 0..<contactPerson.phoneNumbers.count {
                        MobNumVar = (contactPerson.phoneNumbers[i].value ).value(forKey: "digits") as! String
                        let cleaned =  cleanPhoneNumber(MobNumVar)
                        if cleaned.count > 2 {
                            let numertocompare = cleaned
                            let index0 = numertocompare.index(numertocompare.startIndex, offsetBy: 0)
                            let index1 = numertocompare.index(numertocompare.startIndex, offsetBy: 1)
                            if numertocompare.count != 10 || (numertocompare[index0] != "0" || numertocompare[index1] != "5") {
                                
                                //ignore all bad numbers
                                print("bad number? \(numertocompare)")
                            } else {
                                //all this person numbers go to _allPHONES:phone array see below
                                if !phone.contains(cleaned)   {
                                    phone.append(cleaned)
                                }
                            }
                        }
                    }
                    if phone.count > 0 {
                        indexForUserid = indexForUserid + 1
                        let firstvalidphone = phone[0] // only first valid number found is added to _nvPhone
                        let c:Contact = Contact(_iUserId: indexForUserid, _iUserStatusType: 1565, _nvContactName: numecompus, _nvPhone: firstvalidphone as String, _bIsVCheckMamber: false, _bIsNegotiableOnly: false, _bPostdatedCheck: false,_bIsSync: false, _nvFirstName: givenName, _nvLastName: familyName,_allPHONES:phone,_nvNickName:numecompus)
                            Global.sharedInstance.contactList.append(c)
                    }
                }
            }
            let sortedByFirstNameSwifty =  Global.sharedInstance.contactList.sorted(by: { $0.nvLastName < $1.nvLastName })
            Global.sharedInstance.contactList = sortedByFirstNameSwifty
            
//            print("ce are aici iar \(Global.sharedInstance.contactList )")
        ////    END PARSING ////
        case .notDetermined:
            self.generic.hideNativeActivityIndicator(self)
            print("requesting access...")
            store.requestAccess(for: .contacts){succeeded, err in
                guard err == nil && succeeded
                    else{
                        print("error")
                        return
                }
                print("no try access granted")
                //  self.getContactNames()
                let alert = UIAlertController(title: nil, message: "REQUEST_CONTACTS_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
                })
                var rootViewController = UIApplication.shared.keyWindow?.rootViewController
                if let navigationController = rootViewController as? UINavigationController {
                    rootViewController = navigationController.viewControllers.first
                }
                if let tabBarController = rootViewController as? UITabBarController {
                    rootViewController = tabBarController.selectedViewController
                }
                rootViewController?.present(alert, animated: true, completion: nil)
                
            }
        default:
            print("Not handled")
        }
        self.generic.hideNativeActivityIndicator(self)
    }
    
    lazy var contacts: [CNContact] = {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        return results
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generic.showNativeActivityIndicator(self)
        setContacts()
        lblSync.text = "ASK_FOR_SYNC".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblApprovalAll.text = "APPROVAL_ALL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        textViewExplain.text = "SYNC_EXPLAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        textViewExplain.isSelectable = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //בחירה דיפולטיבית
        Global.sharedInstance.dicSyncContacts["bAutoApproval"] = true as AnyObject
        
        flagApproval = true
        btnApprovalV.setBackgroundImage(imageV, for: UIControl.State())
        btnApprovalX.setBackgroundImage(imageX1, for: UIControl.State())
        
        ////סימון בחירה ידנית ב-x
        Global.sharedInstance.dicSyncContacts["nvPhoneList"] = [] as AnyObject
        isFirst1 = false
        flagSync = false
        btnSyncX.setBackgroundImage(imageX, for: UIControl.State())
        btnSyncV.setBackgroundImage(imageV1, for: UIControl.State())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
