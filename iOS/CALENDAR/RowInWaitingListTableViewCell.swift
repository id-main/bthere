//
//  RowInWaitingListTableViewCell.swift
//  Bthere
//
//  Created by User on 5.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class RowInWaitingListTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var viewButtom: UIView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplayData(_ name:String,desc:String,hour:String,myImage:String)  {
        lblDesc.text = desc
       self.name.text = name
        lblHour.text = hour
        img.image = UIImage(named: myImage)
    }
    
    

}
