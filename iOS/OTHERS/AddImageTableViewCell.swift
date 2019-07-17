//
//  AddImageTableViewCell.swift
//  bthree-ios
//
//  Created by User on 10.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit


class AddImageTableViewCell: UITableViewCell{
    
    var delegate:addImage!=nil
    
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var btnImageCamera: UIButton!
    
    @IBAction func btnImageCamera(_ sender: AnyObject) {
        delegate.ImagesCamera()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setDisplayData(_ text: String)
    {
        lblText.text = text
    }
    
}
