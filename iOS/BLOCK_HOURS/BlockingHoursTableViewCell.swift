//
//  BlockingHoursTableViewCell.swift
//  BThere
//
//  Created by Racheli Kroiz on 30.11.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class BlockingHoursTableViewCell: UITableViewCell {
    
    //MARK: - Outlet

    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    //MARK - Variables
    var hourE = ""
    var hourS = ""
    
    //MARK- Initial
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    func setDisplayData( date:String, hour:String)
    {
        lblDate.text = date
        lblHour.text = hour
        
    }
}
