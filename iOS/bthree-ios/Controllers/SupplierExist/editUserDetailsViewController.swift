//
//  editUserDetailsViewController.swift
//  Bthere
//
//  Created by User on 1.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//ספק קיים-(הגדרות) דף עריכת פרטי לקוח
class editUserDetailsViewController: NavigationModelViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //JMODE PLUS
    var EDITUSER:User = User()
     @IBOutlet weak var dP: UIDatePicker!
    //END JMODE
    var language = Bundle.main.preferredLocalizations.first! as NSString
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var txtFName: UITextField!
    
    @IBOutlet weak var txtLName: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtBirthDate: UITextField!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var btnImgAlbum: UIButton!
    
    @IBAction func btnImgAlbum(_ sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var btnImgCamera: UIButton!
    
    @IBAction func btnImgCamera(_ sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(imagePicker, animated: true, completion: nil)
        }
            
        else {
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    @IBOutlet weak var viewHebrew: UIView!
    
    @IBOutlet weak var lblHebrew: UILabel!
    
    @IBOutlet weak var viewArabic: UIView!
    
    @IBOutlet weak var lblArabic: UILabel!
    
    @IBOutlet weak var viewEnglish: UIView!
    
    @IBOutlet weak var lblEnglish: UILabel!
    
    @IBOutlet weak var viewRussian: UIView!
    
    @IBOutlet weak var lblRussian: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBAction func btnSave(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//          print("Global.sharedInstance.currentUse \(Global.sharedInstance.currentUser.getDic())")
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Search Result Hairdresser.jpg")!)
        self.view.addBackground2()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        txtEmail.delegate = self
        txtFName.delegate = self
        txtLName.delegate = self
        txtPhone.delegate = self
        txtBirthDate.delegate = self
        self.lblTitle.text = "PERSONAL_INFORMATION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        //SAVE_BTN
        self.btnSave.setTitle( "SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        let tapLng1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.changeToHebrew))
        self.viewHebrew.addGestureRecognizer(tapLng1)
        
        let tapLng2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.changeToArabic))
        self.viewArabic.addGestureRecognizer(tapLng2)
        
        let tapLng3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.changeToEnglish))
        self.viewEnglish.addGestureRecognizer(tapLng3)
        
        let tapLng4: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.changeToRussian))
        self.viewRussian.addGestureRecognizer(tapLng4)
 
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
     EDITUSER =   Global.sharedInstance.currentUser
        /*
 ["nvFirstName": Final, "bAutomaticUpdateApproval": 0, "iLastModifyUserId": 0, "nvPassword": 2201, "iUserId": 230, "nvUserName": el@b.ccbhfgg, "iCityType": 1, "nvVerification": 2201, "bAdvertisingApproval": 0, "iCreatedByUserId": 1, "bIsManager": 0, "nvImage": /9j/4AAQSkZJRgABAQAASABIAAD/4QBYRXhpZgAATU0AKgAAAAgAAgESAAMAAAABAAEAAIdpAAQAAAABAAAAJgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAABqADAAQAAAABAAAABgAAAAD/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+/8AAEQgABgAGAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/bAEMAFhYWFhYWJhYWJjYmJiY2STY2NjZJXElJSUlJXG9cXFxcXFxvb29vb29vb4aGhoaGhpycnJycr6+vr6+vr6+vr//bAEMBGx0dLSktTCkpTLd8Zny3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t//dAAQAAf/aAAwDAQACEQMRAD8A6WNCp5qbFIKdQM//2Q==, "nvMail": el@b.ccbhfgg, "dBirthdate": /Date(-2177794800000)/, "iUserStatusType": 24, "bIsGoogleCalendarSync": 0, "bDataDownloadApproval": 0, "nvLastName": Good, "iSysRowStatus": 0, "nvPhone": 0524022010, "bTermOfUseApproval": 0]
 */
        var firstname = ""
        var lastname = ""
        var phone = ""
        var mail = ""
        var dBirthdate:Date = Date()
        var oneBIRTHDATETEXT = ""
        if let _:String = EDITUSER.nvFirstName {
            firstname = EDITUSER.nvFirstName
        }
        if let _:String = EDITUSER.nvLastName {
            lastname = EDITUSER.nvLastName
        }
        if let _:String = EDITUSER.nvPhone {
            phone = EDITUSER.nvPhone
        }
        if let _:String = EDITUSER.nvMail {
            mail = EDITUSER.nvMail
        }
        
        
        
        self.txtFName.text = firstname + "" + lastname
        self.txtLName.text = lastname
        self.txtPhone.text = phone
        self.txtEmail.text  = mail
        dP.backgroundColor = Colors.sharedInstance.color1
        dP.setValue(UIColor.white, forKeyPath: "textColor")
        dP.setValue(0.8, forKeyPath: "alpha")
        dP.datePickerMode = UIDatePicker.Mode.date
        // self.NEWSCROLLVIEW.bringSubviewToFront(dP)
       //\\ dP.hidden = true
        self.view.bringSubviewToFront(dP)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.txtBirthDate.text = dateFormatter.string(from: EDITUSER.dBirthdate as Date)
        self.dP.date = EDITUSER.dBirthdate as Date
        
        
    }
    func getCurrentShortDate(_ dateTOConvert:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let DateInFormat = dateFormatter.string(from: dateTOConvert)
          print("formatted date is =  \(DateInFormat)")
        return DateInFormat
    }
    
    func getDateFromString(_ dateString: String)->Date
    {
        var datAMEA:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.dateStyle = .short
//          print("crASH \(dateString)")
        if let  _ = dateFormatter.date(from: dateString) {
            datAMEA = dateFormatter.date(from: dateString)!
              print("datestring \(getDateFromString) si data \(datAMEA)")
        }
        return datAMEA
    }

    func convertNSDateToString(_ dateTOConvert:Date)-> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //let dateStr = dateFormatter.stringFromDate(dateTOConvert)
        
        var myDateString = String(Int64(dateTOConvert.timeIntervalSince1970 * 1000))
        myDateString = "/Date(\(myDateString))/"
        
        
        return myDateString
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @objc func changeToHebrew()
    {
        language = "he"
        viewHebrew.backgroundColor = Colors.sharedInstance.color3
        viewEnglish.backgroundColor = UIColor.clear
        viewArabic.backgroundColor = UIColor.clear
        viewRussian.backgroundColor = UIColor.clear
        changeLanguage(language as String)
        
    }
    
    @objc func changeToArabic()
    {
        language = "ar"
        viewArabic.backgroundColor = Colors.sharedInstance.color3
        
        viewEnglish.backgroundColor = UIColor.clear
        viewHebrew.backgroundColor = UIColor.clear
        viewRussian.backgroundColor = UIColor.clear
        changeLanguage(language as String)

    }
    
    @objc func changeToEnglish()
    {
        language = "en"
        viewEnglish.backgroundColor = Colors.sharedInstance.color3
        
        viewArabic.backgroundColor = UIColor.clear
        viewHebrew.backgroundColor = UIColor.clear
        viewRussian.backgroundColor = UIColor.clear
        changeLanguage(language as String)
    }
    
    @objc func changeToRussian()
    {
        language = "ru"
        viewRussian.backgroundColor = Colors.sharedInstance.color3
        viewEnglish.backgroundColor = UIColor.clear
        viewHebrew.backgroundColor = UIColor.clear
        viewArabic.backgroundColor = UIColor.clear
         changeLanguage(language as String)
        
    }
    func changeLanguage(_ iLang:String)
    {
      //  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            //\\dd   appDelegate.changeLanguage(iLang)
        
            Alert.sharedInstance.showAlert("LANG_CHANGE_NEXR_ENTRANCE".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc: self)
    }
    
    
    //MARK: - Images
    
    /// ImagesCamera() - this function open images file
    /// or camera to get an image.

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //place the image that selected from the library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        let img:UIImage = Global.sharedInstance.resizeImage(image, newWidth: image.size.width*0.5)
        let base64String = Global.sharedInstance.setImageToString(img)
        
            UIGraphicsBeginImageContext(imgUser.frame.size)
            image.draw(in: imgUser.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            imgUser.image = image
            
            //Global.sharedInstance.addProviderBuisnessProfile.nvHeaderImage = base64String
        
        picker.dismiss(animated: true, completion: nil)
    }


}
