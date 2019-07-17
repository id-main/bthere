//
//  ListWorkersTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/6/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
protocol ReloadTableWorkersDelegate{
    func ReloadTableWorkers(_ workersTbl:UITableView)
}
class ListWorkersTableViewCell: UITableViewCell {
    var delegate:ReloadTableWorkersDelegate! = nil
    @IBOutlet var tblWorkers: UITableView!

    override func awakeFromNib() {
        super.awakeFromNib()
        tblWorkers.separatorStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDispalyData(){
        delegate.ReloadTableWorkers(tblWorkers)
    }

}
