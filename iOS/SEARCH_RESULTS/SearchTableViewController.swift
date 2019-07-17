//
//  SearchTableViewController.swift
//  bthree-ios
//
//  Created by User on 28.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
// טבלת החיפוש מיומן לקוח
class SearchTableViewController: UITableViewController{

    var filterSubArr:NSArray = NSArray()//fix 2.3 from nsmutbleArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        if filterSubArr.count == 0
        {
            self.view.removeFromSuperview()
        }
        
        if filterSubArr.count < 4
        {
            return filterSubArr.count
        }
        
        return  4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search")as! SearchTableViewCell
        cell.setDisplayData(filterSubArr[indexPath.row] as! String)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     Global.sharedInstance.modelCalender!.txtSearch.text = filterSubArr[indexPath.row] as? String
        self.view.removeFromSuperview()
        let ax:UIButton = UIButton()
        Global.sharedInstance.modelCalender!.btnSearch(ax)
    }
}
