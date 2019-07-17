//
//  MyAppointmentTableViewCell.swift
//  BThere
//
//  Created by Racheli Kroiz on 30.11.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class MyAppointmentWithImageTableViewCell: UITableViewCell {
    
    //MARK: - Outlet
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var supplierNameLbl: UILabel!
    
    //MARK - Variables
    var hourE = ""
    var hourS = ""
    
    //MARK- Initial
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataMyAppointments(date:String, hour:String, txt:String, supplierName:String)
    {
        let newString = date.replacingOccurrences(of: "/", with: ".", options: .literal, range: nil)
        lblDate.text = newString
        lblHour.text = hour
        lblText.text = txt
        supplierNameLbl.text = supplierName
    }
    
    func setDisplayData(_ img:String, date:String, hour:String, txt:String)
    {
        imgView.contentMode = .scaleAspectFit
        
        //המרת התמונה של הלוגו מהשרת
        let dataDecoded:Data = Data(base64Encoded: (
            img), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        
        var decodedimage:UIImage = UIImage()
        if UIImage(data: dataDecoded) != nil
        {
            decodedimage = UIImage(data: dataDecoded)!
            
            UIGraphicsBeginImageContext(imgView.frame.size)
            decodedimage.draw(in: imgView.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            imgView.image = image
        }
        else
        {
            imgView.backgroundColor = Colors.sharedInstance.color4
            imgView.image = UIImage(named: "clients@x1.png")
            imgView.contentMode = .scaleAspectFit
        }
        
        lblDate.text = date
        lblHour.text = hour
        lblText.text = txt
    }
}
