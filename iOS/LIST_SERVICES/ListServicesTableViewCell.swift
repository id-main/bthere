//
//  ListServicesTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/7/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
protocol reloadServicesTableDelegate{
    func reloadServicesTable(_ tbl:UITableView)
}
class ListServicesTableViewCell: UITableViewCell {
    var delegate:reloadServicesTableDelegate! = nil
    @IBOutlet var tblServices: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //ttSprint4 alpha2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        tblServices.separatorStyle = .singleLine
        tblServices.separatorColor = .black
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        // Configure the view for the selected state
    }

    func setDisplayData(){
        delegate.reloadServicesTable(tblServices)
    }

}
