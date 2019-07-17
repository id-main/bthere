//
//  WorkerNameTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/23/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class WorkerNameTableViewCell: UITableViewCell {
    @IBOutlet weak var viewButtom: UIView!

    @IBOutlet var lblDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplayData(_ str:String){
        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
        lblDesc.font = UIFont(name: lblDesc.font.fontName, size: 16)
        }

              lblDesc.text = str
    }

}
