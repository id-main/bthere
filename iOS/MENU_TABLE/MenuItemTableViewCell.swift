//
//  MenuItemTableViewCell.swift
//  bthree-ios
//
//  Created by User on 22.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var di: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        if DeviceType.IS_IPHONE_6{
            di.font = di.font.withSize(12)
        } else
        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
            di.font = UIFont(name: di.font.fontName, size: 12)
        } else {
              di.font = UIFont(name: di.font.fontName, size: 14)
        }
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .pad {
            di.font = UIFont(name: di.font.fontName, size: 22)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var viewButtom: UIView!
    func setDisplayData(_ str:String,image:String){
        di.lineBreakMode = NSLineBreakMode.byWordWrapping
        di.numberOfLines = 0
        di.sizeToFit()
        di.text = str
        img.image = UIImage(named: image)
        img.contentMode = .scaleAspectFit
    }
}
