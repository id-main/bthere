//
//  ReportsViewController.swift
//  Bthere
//
//  Created by User on 31.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
protocol PushReportDelegate {
    func PushReport(_ viewCon:UIViewController)
}

// ספק קים דף רשימת של כל הדוחות הקימים
class ReportsViewController: NavigationModelViewController,UITableViewDelegate,UITableViewDataSource{
    var arrayNameReports:Array<String> = ["ניצולת תפעולית","מס׳ לקוחות"]
    var delegate:PushReportDelegate!=nil
    @IBOutlet weak var tblReports: UITableView!
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tblReports.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayNameReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportInListTableViewCell")as!ReportInListTableViewCell
        cell.setDisplayData(arrayNameReports[indexPath.row])
        if indexPath.row == 0{
            cell.viewTop.isHidden = false
        }
        else{
            cell.viewTop.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.dismiss(animated: true, completion: {
                let storyboard = UIStoryboard(name: "SupplierExist", bundle: nil)
                let viewCon:OperationalUtilizationViewController = storyboard.instantiateViewController(withIdentifier: "OperationalUtilizationViewController") as! OperationalUtilizationViewController
                self.delegate.PushReport(viewCon)
            })
        default:

      print("asdaaaa")

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height * 0.06
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
