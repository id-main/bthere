//
//  MessageTableViewCell.swift
//  Bthere
//
//  Created by User on 1.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var viewButtom: UIView!
    @IBOutlet weak var viewTop: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescMess: UILabel!
    func setDisplayData(_ desc:String,dateMes:Date) {
        lblDescMess.text = desc
    }

}
