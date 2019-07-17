//
//  AddNewWorkerTableViewCell.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu on 06/03/2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit

class AddNewWorkerTableViewCell: UITableViewCell {
    var DELEGATERELOAD:reloadTblDelegateParent!=nil
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
    }

}
