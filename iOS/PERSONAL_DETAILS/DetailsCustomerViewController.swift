//
//  DetailsCustomerViewController.swift
//  Bthere
//
//  Created by User on 24.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//ספק קיים דף פרטי לקוח
class DetailsCustomerViewController: UIViewController , WDImagePickerDelegate, UITextViewDelegate {
    
    //MARK: - Outlet
    var row:Int = 0
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblMail: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    // @IBOutlet weak var customerNotesLabel: UILabel!
    
    @IBOutlet weak var customerNotesLabel: UITextView!
    
    @IBOutlet weak var lblUpdate: UILabel!
    
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var blueView: UIView!
    
    @IBOutlet weak var viewLogo: UIView!
    @IBOutlet weak var lblLogo: UILabel!
    @IBOutlet weak var lblCameraLogo: UILabel!
    @IBOutlet weak var lblAddFromAlbum: UILabel!
    @IBOutlet weak var imgFromAlbom: UIImageView!
    @IBOutlet weak var imgFromCamera: UIImageView!
    @IBOutlet weak var viewCameraLogo: UIView!
    @IBOutlet weak var viewAlbumLogo: UIView!
    @IBOutlet weak var star_IS_VIP: UIImageView!
    @IBOutlet weak var USERIMAGE: UIImageView!
    var tapGestureRecognizerForAlbom = UIGestureRecognizer()//logo
    var tapGestureRecognizerForCamera = UITapGestureRecognizer()//logo
    
    var MYiCustomerUserId:Int = 0
    
    var tapGestureRecognizer2 = UITapGestureRecognizer()
    var changeImage:String = ""
    
    var isFromCustomerApproval = false
    var customerFullName: String = ""
    var customerPhone: String = ""
    var customerEmail: String = ""
    var customerImage: String = ""
    var customerBirthday: String = ""
    
    
    fileprivate var iimagePicker: WDImagePicker!
    fileprivate var imagePickerWD: WDImagePicker!
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var d:NSDictionary = NSDictionary()
    //MARK: - Initial
    func showcameraoralbum() {
        viewLogo.isHidden = false
    }
    @IBAction func btnCloseViewLogo(_ sender: AnyObject) {
        viewLogo.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:45)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLogo.isHidden = true
        //clients@x1.pngupdateDetails
        lblCameraLogo.text = "TAKE_PICTURE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblAddFromAlbum.text = "ATTACH_PHOTO".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        let tapUpdate:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateDetails))
        lblUpdate.addGestureRecognizer(tapUpdate)
        
        lblUpdate.text = "LBL_UPDATE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        
        
        if (isFromCustomerApproval == true) {
            lblUpdate.isHidden = true
            blueView.isHidden = true
            star_IS_VIP.isHidden = true
            customerNotesLabel.isHidden = true
            
            // Labels
            lblName.text = customerFullName
            lblPhone.text = customerPhone
            lblMail.text = customerEmail
            lblDate.text = customerBirthday
            
            // Image
            if (customerImage.count == 0) {
                USERIMAGE.image = UIImage(named:"clients@x1.png")
            } else {
                let encodedImageData = customerImage
                let dataDecoded:Data = Data(base64Encoded: encodedImageData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
                let CONVERTEDimage = UIImage(data: dataDecoded)
                USERIMAGE.image = CONVERTEDimage
            }
        } else {
            d = (Global.sharedInstance.searchCostumersArray.object(at: row) as! NSDictionary) as NSDictionary
            tapGestureRecognizerForAlbom = UITapGestureRecognizer(target:self, action:#selector(self.openAlbom(_:)))
            viewAlbumLogo.isUserInteractionEnabled = true
            viewAlbumLogo.addGestureRecognizer(tapGestureRecognizerForAlbom)
            customerNotesLabel.delegate = self
            customerNotesLabel.isEditable = false
            tapGestureRecognizerForCamera = UITapGestureRecognizer(target:self, action:#selector(self.openCamera(_:)))
            viewCameraLogo.isUserInteractionEnabled = true
            viewCameraLogo.addGestureRecognizer(tapGestureRecognizerForCamera)
            
            
            if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                customerNotesLabel.textAlignment = .right
            } else {
                customerNotesLabel.textAlignment = .left
            }
            
            print("ce lucreaza \(d.description)")
            
            // Name
            if let nvFullName:String = d.object(forKey: "nvFullName") as? String {
                lblName.text = nvFullName
            } else {
                lblName.text = ""
            }
            
            // Phone
            if let nvPhone:String = d.object(forKey: "nvPhone") as? String {
                lblPhone.text = nvPhone
            } else {
                lblPhone.text = ""
            }
            
            // Mail
            if let nvMail:String = d.object(forKey: "nvMail") as? String {
                lblMail.text = nvMail
            } else {
                lblMail.text = ""
            }
            
            // VIP star
            if let somethingelse:Int = d.object(forKey: "bIsVip") as? Int {
                if (somethingelse == 0) {
                    star_IS_VIP.isHidden = true
                }
            } else {
                star_IS_VIP.isHidden = false
            }
            
            //2nd check for bool anyway
            if let somethingelseb:Bool = d.object(forKey: "bIsVip") as? Bool {
                if (somethingelseb == false) {
                    star_IS_VIP.isHidden = true
                }
            } else {
                star_IS_VIP.isHidden = false
            }

            
            // Notes
            if let nvSupplierNotes:String = d.object(forKey: "nvSupplierRemark") as? String {
                if(nvSupplierNotes.count == 0) {
                    customerNotesLabel.text = ""
                } else {
                    customerNotesLabel.text = nvSupplierNotes
                }
            }
            
            if let userimg:String = d.object(forKey: "nvImage") as? String {
                if(userimg.count == 0) {
                    USERIMAGE.image = UIImage(named:"clients@x1.png")
                } else {
                    let encodedImageData = userimg
                    let dataDecoded:Data = Data(base64Encoded: encodedImageData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
                    let CONVERTEDimage = UIImage(data: dataDecoded)
                    USERIMAGE.image = CONVERTEDimage
                }
            }
            
            // Birthday
            if let dBirthdate:Date = d.object(forKey: "dBirthdate") as? Date {
                let aBIRTHDATE:String = getCurrentShortDate(dBirthdate)
                if aBIRTHDATE ==  "01/01/1901" {
                    lblDate.text  = ""
                } else {
                    lblDate.text = aBIRTHDATE
                }
            } else {
                lblDate.text = ""
            }
            
            // Nickname
            var nvNickName = ""
            if let cnvNickName:String = d.object(forKey: "nvNickName") as? String {
                nvNickName = cnvNickName
                print(nvNickName)
            }
            
            // ID
            if let iCustomerUserId:Int = d.object(forKey: "iCustomerUserId") as? Int {
                MYiCustomerUserId = iCustomerUserId
            }
        }
        
        if lblName.text == "OCCASIONAL_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            blueView.isHidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateDetails()
    {
        print("update")
        let parent = self.presentingViewController
      //  print("parent\(parent)")
        parent!.dismiss(animated: true, completion: {
            let viewCon:UpdateCustomerViewController = self.storyboard?.instantiateViewController(withIdentifier: "UpdateCustomerViewController") as! UpdateCustomerViewController
            viewCon.delegate = Global.sharedInstance.mycustomers
            viewCon.row = self.row
            viewCon.newiUserId = self.MYiCustomerUserId
            viewCon.SalvatnvSupplierRemark = self.customerNotesLabel.text!
            viewCon.d = self.d //it is current dictionary
            if self.iOS8 {
                viewCon.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            } else {
                viewCon.modalPresentationStyle = UIModalPresentationStyle.currentContext
            }
            parent!.present(viewCon, animated: true, completion: nil)
        })
        
        //        if let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("UpdateCustomerViewController") as? UpdateCustomerViewController {
        //             viewCon.row = self.row
        //            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //            appDelegate.window?.rootViewController!.presentViewController(viewCon, animated: true, completion: nil)
        //        }
        
        
        
        //  Alert.sharedInstance.showAlertDelegate("Same screen as in Add with precompleted and editable fields")
        //    let navigationController:UINavigationController = UINavigationController()
        //        let viewCon:UpdateCustomerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UpdateCustomerViewController") as! UpdateCustomerViewController
        //        viewCon.row = self.row
        //        navigationController.viewControllers = [viewCon]
        //        self.dismissViewControllerAnimated(true, completion: nil)
        //        self.presentViewController(navigationController, animated: true, completion: nil)
        /*
         There's a field in the db of whom added this user so you can allow changes also in the other fields on this 2 conditions : this user is not yet active, this user was added by this supplier.  This week some most of the problems.
         pass userid and call getalldetails in that view in order to have updated infos
         */
    }
    
    func DeleteCustomer()
    {
        print("Delete")
    }
    @objc func openAlbom(_ img: AnyObject)
    {
        
        if img as! UITapGestureRecognizer == tapGestureRecognizerForAlbom
        {
            changeImage = "logo"
        }
        
        let settingsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertController.Style.actionSheet)
        
        /// to open images file
        settingsActionSheet.addAction(UIAlertAction(title:"LOOK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style:UIAlertAction.Style.default, handler:{ (UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                self.showResizablePicker(self.USERIMAGE,galleryorcamera: 0)
                
            }
            }
            
            ))
        settingsActionSheet.addAction(UIAlertAction(title:"CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style:UIAlertAction.Style.cancel, handler:nil))
        self.present(settingsActionSheet, animated:true, completion:nil)
        
    }
    
    //MARK:-------cropImage; int
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
        let widthofview = self.view.frame.size.width * 0.9// keep space for corners
        let heightofimage = widthofview * 0.70
        self.imagePickerWD.cropSize = CGSize(width: widthofview, height: heightofimage)
        self.imagePickerWD.delegate = self
        self.imagePickerWD.resizableCropArea = true
        //JMODE MODE:D
        self.imagePickerWD.lockAspectRatio = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            Global.sharedInstance.detailsCustomerViewController!.present(self.imagePickerWD.imagePickerController, animated: true, completion: nil)
        } else {
            
            Global.sharedInstance.detailsCustomerViewController!.present(self.imagePickerWD.imagePickerController, animated: true, completion: nil)
            
        }
    }
    
    //save the chosen picture - album
    func imagePicker(_ imagePicker: WDImagePicker, pickedImage: UIImage) {
        //\\print ("hhh \(pickedImage.size.width)")
        if pickedImage.size.height > 0 || pickedImage.size.width > 0 {
            //JMODE   let img:UIImage = Global.sharedInstance.resizeImage(pickedImage, newWidth: pickedImage.size.width*0.5)
            //     let img:UIImage = Global.sharedInstance.resizeImage(pickedImage, newWidth: pickedImage.size.width)
            
        //    let img:UIImage = Global.sharedInstance.resizeImage(pickedImage, newWidth:500)
          //\\  let base64String = Global.sharedInstance.setImageToString(img)
            if changeImage=="logo"
            {
                USERIMAGE.contentMode = .scaleAspectFit
                UIGraphicsBeginImageContext(USERIMAGE.frame.size)
                pickedImage.draw(in: USERIMAGE.bounds)
                let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                USERIMAGE.image = image
                
            }
            
            self.hideImagePicker()
        } else {
            
        }
    }
    
    func hideImagePicker() {
        viewLogo.isHidden = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            self.imagePickerWD.imagePickerController.dismiss(animated: true, completion: nil)
        } else {
            self.imagePickerWD.imagePickerController.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //open the camera
    @objc func openCamera(_ img: AnyObject)
    {
        if img as! UITapGestureRecognizer  == tapGestureRecognizerForCamera
        {
            changeImage="logo"
        }
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            //            let imagePicker = UIImagePickerController()
            //            imagePicker.delegate = self
            //            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            //            imagePicker.allowsEditing = false
            //
            //            imagePicker.modalPresentationStyle = UIModalPresentationStyle.Custom
            //            self.presentViewController(imagePicker, animated: true, completion: nil)
            self.showResizablePicker(self.USERIMAGE, galleryorcamera: 1)
            
            
        }
            
        else {
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //save the chosen image - camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
      //  let img:UIImage = Global.sharedInstance.resizeImage(image, newWidth: image.size.width*0.5)
       //\\ let base64String = Global.sharedInstance.setImageToString(img)
        
        //------------------------
        
        if changeImage=="ligtyBlue3"
        {
            UIGraphicsBeginImageContext(USERIMAGE.frame.size)
            image.draw(in: USERIMAGE.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            USERIMAGE.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func getCurrentShortDate(_ dateTOConvert:Date) -> String {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let DateInFormat = dateFormatter.string(from: dateTOConvert)
        print("formatted date is =  \(DateInFormat)")
        return DateInFormat
    }
}
