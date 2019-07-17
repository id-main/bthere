
//
//  WorkerTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/7/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class WorkerTableViewCell: UITableViewCell {

    @IBOutlet var lblWorker: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnEditWorker(_ sender: AnyObject) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplayData(_ str:String){
        lblWorker.text = str
    }

}
