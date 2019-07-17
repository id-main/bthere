//
//  EleventhHourTableViewCell.swift
//  bthree-ios
//
//  Created by User on 14.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class EleventhHourTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageLogo: UIImageView!
    
    @IBOutlet weak var viewLogo: UIView!
    
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var txtViewText: UITextView!
    
    @IBOutlet weak var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        viewLogo.layer.borderWidth = 1
//        viewLogo.layer.borderColor = UIColor.blackColor().CGColor
        
        let border = CALayer()
        
      // let language = NSBundle.mainBundle().preferredLocalizations.first! as NSString
       // if language == "he"
                if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 1
        {
            border.frame = CGRect(x: 0, y: 0, width: 1, height: viewLogo.layer.frame.height + (self.contentView.frame.width * 0.0328))
        }
        else
        {
            border.frame = CGRect(x: (self.contentView.frame.width * 0.033) + viewLogo.layer.frame.width , y: 0, width: 1, height: viewLogo.layer.frame.height + 16)
        }
        border.backgroundColor = UIColor.black.cgColor
        
        viewLogo.layer.addSublayer(border)
        txtViewText.isEditable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplayData(_ img:String,date:String,text:String)
    {
        let url : NSString = img as NSString
        let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString//addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        if let url = URL(string: urlStr as String) {
            if let data = try? Data(contentsOf: url as URL) {
                imageLogo.image = UIImage(data: data as Data)
            }
        }
        
        //imageLogo.image = UIImage(named: img)
        lblDate.text = date
        txtViewText.text = text
    }

}
