//
//  AdjustCalendarServicesCustomCell.swift
//  Bthere
//
//  Created by Iustin Bthere on 12/20/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit

class AdjustCalendarServicesCustomCell: UITableViewCell {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }
    
}
