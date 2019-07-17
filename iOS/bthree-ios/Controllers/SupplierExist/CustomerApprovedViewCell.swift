//
//  CustomerApprovedViewCell.swift
//  Pods
//
//  Created by Eduard Stefanescu on 9/19/17.
//
//

import Foundation
import UIKit
protocol reloadTableparentDelegate{
    func CONFIRM_OR_DELETE_APROVED_CUSTOMER(_ myCustomerUserId:Int, statusServer:Int)
    
}
class CustomerApprovedViewCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerImage: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var viewDelegate:CustomerApproval!
    var delegate:reloadTableparentDelegate! = nil
    // Variables
    var oneUSERBUN:NSDictionary = NSDictionary()
    var iCustomerUserId:Int = 0
    var iCustomerFullName: String = ""
    var iCustomerPhone: String = ""
    var iCustomerEmail: String = ""
    var iCustomerImage: String = ""
    var iCustomerBirthday: String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    
    
    // Confirm customer approval sends true 1  to server
    @IBAction func confirmButton(_ sender: AnyObject) {
        // send to server something like userid
        delegate.CONFIRM_OR_DELETE_APROVED_CUSTOMER(self.iCustomerUserId, statusServer:1)
    }
    
    
    // Delete customer approval  sends false 0 to server
    @IBAction func deleteButton(_ sender: AnyObject) {
        // print("todelete \(oneUSERBUN.iUserId)")
        delegate.CONFIRM_OR_DELETE_APROVED_CUSTOMER(self.iCustomerUserId, statusServer:2)
    }
    
    
    @IBAction func viewCustomerButton(_ sender: AnyObject) {
        self.viewDelegate.seeCustomerDetais(iCustomerUserId, _nvFullName:iCustomerFullName, _nvPhone:iCustomerPhone, _nvMail:iCustomerEmail, _nvImage:iCustomerImage, _dBirthdate:iCustomerBirthday)
    }
    
    
    // Precomplete data
    func PrecompleteUser(_ myuser:NSDictionary) {
        let d:NSDictionary = myuser
        print("d \(d.description)")
        
        // Name
        if let dicFullName = d.object(forKey: "nvFullName") as? String {
            iCustomerFullName = dicFullName
        }
        
        // Phone
        if let dicPhone = d.object(forKey: "nvPhone") as? String {
            iCustomerPhone = dicPhone
        }
        
        // Mail
        if let dicMail = d.object(forKey: "nvMail") as? String {
            iCustomerEmail = dicMail
        }
        
        // Date
        if let dicBirthday = d.object(forKey: "dBirthdate") as? String {
            let someDate = Global.sharedInstance.getStringFromDateString(dicBirthday)
            let dateFormatter1 = DateFormatter()
            
            dateFormatter1.dateFormat = "dd/MM/yyyy"
            iCustomerBirthday = dateFormatter1.string(from: someDate)
            
        }
        
        // Photo
        if let somethingelse =  d.object(forKey: "nvImage") as? String {
            iCustomerImage = somethingelse
        } else{
            iCustomerImage = ""
        }
        
        var INTiCustomerUserId:Int = 0
        if let somethingelse:Int =  d.object(forKey: "iCustomerUserId") as? Int {
            INTiCustomerUserId = somethingelse
        }
        
        customerName.text = iCustomerFullName
        iCustomerUserId = INTiCustomerUserId
        
        // Set photo
        if (iCustomerImage.characters.count == 0) {
            customerImage.image = UIImage(named:"clientphoto.jpg")
        } else {
            let encodedImageData = iCustomerImage
            let dataDecoded:Data = Data(base64Encoded: encodedImageData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
            let CONVERTEDimage = UIImage(data: dataDecoded)
            customerImage.image = CONVERTEDimage
        }
    }
}
