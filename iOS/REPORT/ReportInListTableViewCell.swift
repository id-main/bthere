//
//  ReportInListTableViewCell.swift
//  Bthere
//
//  Created by User on 31.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class ReportInListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewbuttom: UIView!
    @IBOutlet weak var viewTop: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var lblReportName: UILabel!
    func setDisplayData(_ st:String)  {
        lblReportName.text = st
    }

}
