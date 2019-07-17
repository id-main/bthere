//
//  AddNewServiceTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/7/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
protocol reloadTableForNewServiceDelegate{
    func reloadTableForNewService(_ cell:AddNewServiceTableViewCell)
}
class AddNewServiceTableViewCell: UITableViewCell {
    var delegate:reloadTableForNewServiceDelegate! = nil
    var isOpen:Bool = false
    @IBAction func newService(_ sender: UIButton) {
        delegate.reloadTableForNewService(self)
    }
    @IBOutlet weak var lblAddServiceProduct: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblAddServiceProduct.text = "ADD_SERVICE_PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
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
