//
//  NewWorkerTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/2/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
protocol reloadTableForNewWorkerDelegate{
    func reloadTableForNewWorker(_ cell:NewWorkerTableViewCell)
}
class NewWorkerTableViewCell: UITableViewCell {
    var delegate:reloadTableForNewWorkerDelegate! = nil
    var isOpen:Bool = false
    
    @IBAction func btnNewWorker(_ sender: UIButton) {
        delegate.reloadTableForNewWorker(self)
    }
    
    @IBOutlet var addWorker: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addWorker.text = "ADD_WORKER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    }

    override func layoutSubviews() {
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: self.contentView.frame.height - 1, width: self.contentView.frame.size.width + 60, height: 1))
        lineView.backgroundColor = UIColor.white
        self.contentView.addSubview(lineView)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
        // Configure the view for the selected state
    }

}
