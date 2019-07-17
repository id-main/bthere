//
//  BigWaitingListCollectionViewCell.swift
//  Bthere
//
//  Created by User on 26.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class BigWaitingListCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageLogo: UIImageView!
    
    @IBOutlet weak var viewLogo: UIView!
    
    @IBOutlet weak var lblHour: UILabel!
    
    @IBOutlet weak var txtViewText: UITextView!
    
    @IBOutlet weak var lblDate: UILabel!
    
    let border = CALayer()
    
    let language = Bundle.main.preferredLocalizations.first! as NSString
    var index:Int = 0
    
    override func awakeFromNib() {
        
        border.backgroundColor = UIColor.black.cgColor
        viewLogo.layer.borderWidth = 1
        viewLogo.layer.borderColor = Colors.sharedInstance.color1.cgColor
        //viewLogo.layer.addSublayer(border)
        txtViewText.isEditable = false
    }
    
    func setDisplayData(_ img:String,date:String,hour:String,text:String)
    {
        imageLogo.contentMode = .scaleAspectFit
        
        //המרת התמונה של הלוגו מהשרת
        let dataDecoded:Data = Data(base64Encoded: (
            img), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        
        var decodedimage:UIImage = UIImage()
        if UIImage(data: dataDecoded) != nil
        {
            decodedimage = UIImage(data: dataDecoded)!
            
            UIGraphicsBeginImageContext(imageLogo.frame.size)
            decodedimage.draw(in: imageLogo.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            imageLogo.image = image
        }
        else
        {
            imageLogo.image = UIImage()
        }

        lblDate.text = date
        lblHour.text = hour
        txtViewText.text = text
    }
}
