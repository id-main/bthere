//
//  ServiceTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/23/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {

    @IBOutlet var topBorder: UIView!
    @IBOutlet var lblDesc: UILabel!
    
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var buttomBorder: UIView!
    
    @IBOutlet var lblTime: UILabel!
    
    ///MARK: - Initial
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setDisplayData(_ descService:String,time:String,price:String){
        lblDesc.text = descService
        lblPrice.text = price
        lblTime.text = time
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        for subview in self.subviews {
            
            for subview2 in subview.subviews {
                if (String(describing: subview2).range(of: "UITableViewCellActionButton") != nil) {
                    for view in subview2.subviews {
                        if (String(describing: view).range(of: "UIButtonLabel") != nil) {
                            
                            if let label = view as? UILabel {
                                
                                label.textColor = UIColor.black
                                label.font = UIFont (name: "OpenSansHebrew-Light", size: 22)
                            }
                            
                        }
                    }
                }
            }
        }
        
    }


}
