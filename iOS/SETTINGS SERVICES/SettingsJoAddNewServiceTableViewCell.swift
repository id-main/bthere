//
//  SettingsJoAddNewServiceTableViewCell.swift
//  bthree-ios
//
//  Created byIoan Ungureanu on 12/02/2019
//  Copyright © 2019 Bthere. All rights reserved.
//

import UIKit

class SettingsJoAddNewServiceTableViewCell: UITableViewCell {
    @IBOutlet weak var lblAddServiceProduct: UILabel!
    var isClosed:Bool = true
    var delegate:isOpenRowDelegate3!=nil
    override func awakeFromNib() {
        super.awakeFromNib()
        lblAddServiceProduct.text = "ADD_SERVICE_PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    }
    @IBAction func newService(_ sender: UIButton) {
        if isClosed == true {
            //add new
            delegate.openRow(_WHICHCELL: 0, _WHICHSTATE: true)
        } else {
            //try to save and close
            delegate.closeandclearcell(_WHICHCELL:0)
        }
      //  delegate.reloadTableForNewService(self)
    }
    override func layoutSubviews() {
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: self.contentView.frame.height - 1, width: self.contentView.frame.size.width + 60, height: 1))
        lineView.backgroundColor = UIColor.white
        self.contentView.addSubview(lineView)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setState(_isClosed: Bool) {
        self.isClosed = _isClosed
    }

}
