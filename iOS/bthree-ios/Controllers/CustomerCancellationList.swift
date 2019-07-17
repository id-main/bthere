//
//  CustomerCancellationList.swift
//  BThere
//
//  Created by Eduard Stefanescu on 12/11/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import UIKit

class CustomerCancellationList: UIViewController {
    // Outlets
    @IBOutlet var topBorderView: UIView!
    @IBOutlet var popConstraint: NSLayoutConstraint!
    
    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tblAppointments: UITableView!
    
    //MARK: - Variables
    var generic:Generic = Generic()
    var whichOpenMe = 0//מציין על מי לחצו בתפריט פלוס כדי להגיע לפה:עדכון=1,לא מגיע=2,איחור בקטנה=3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            popConstraint.constant = 75 // 139
        } else {
            popConstraint.constant = 75
        }
        
        lblTitle.text = "PLUS_MENU_CANCELLATON".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        tblAppointments.reloadData()
        
        self.tblAppointments.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        
        if (Global.sharedInstance.ordersOfClientsArray.count > 0) {
            self.topBorderView.isHidden = false
        } else {
            self.topBorderView.isHidden = true
        }
        
        return Global.sharedInstance.ordersOfClientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "MyAppointmentTableViewCell") as! MyAppointmentTableViewCell
        var txtOrder = ""
        for order in Global.sharedInstance.ordersOfClientsArray[indexPath.section].objProviderServiceDetails
        {
            if txtOrder == ""
            {
                txtOrder = order.nvServiceName
            }
            else
            {
                txtOrder += ",\(order.nvServiceName)"
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var userCalendar =  Foundation.Calendar.current // user calendar
        userCalendar.timeZone =  TimeZone(abbreviation: "UTC")! // NSTimeZone.local // 
        let daylightSavingTimeOffset1 = userCalendar.timeZone.daylightSavingTimeOffset()
        userCalendar.timeZone =  TimeZone(abbreviation: "GMT+03")!
        let dateComponents = userCalendar.dateComponents([.day, .month, .year], from: Global.sharedInstance.ordersOfClientsArray[indexPath.row].dtDateOrder)
        var stringFormatter:String = ""
        let ENDDATE = userCalendar.date(from: dateComponents as DateComponents)!
        stringFormatter = dateFormatter.string(from:ENDDATE)


        let dateFormatterHours = DateFormatter()
        dateFormatterHours.dateFormat = "HH:mm"
        
        let hourS:String = dateFormatterHours.string(from: Global.sharedInstance.getStringFromDateString(Global.sharedInstance.ordersOfClientsArray[indexPath.section].nvFromHour))
        let hourE:String = dateFormatterHours.string(from: Global.sharedInstance.getStringFromDateString(Global.sharedInstance.ordersOfClientsArray[indexPath.section].nvToHour))
        cell.hourE = hourE
        // cell.hourS = hourS
        cell.setDisplayData(Global.sharedInstance.ordersOfClientsArray[indexPath.section].nvLogo, date: stringFormatter, hour: hourS, txt: txtOrder)
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        switch whichOpenMe {
        case 1:
            break
        case 2://לא מגיע
            let viewCon:CancelAppointmentClientViewController = storyboard?.instantiateViewController(withIdentifier: "CancelAppointmentClientViewController") as! CancelAppointmentClientViewController
            viewCon.service = (tableView.cellForRow(at: indexPath) as! MyAppointmentTableViewCell).lblText.text!
            viewCon.date = (tableView.cellForRow(at: indexPath) as! MyAppointmentTableViewCell).lblDate.text!
            viewCon.hour = "\((tableView.cellForRow(at: indexPath) as! MyAppointmentTableViewCell).lblHour.text!) - \((tableView.cellForRow(at: indexPath) as! MyAppointmentTableViewCell).hourE)"
            // viewCon.hourS = "\((tableView.cellForRowAtIndexPath(indexPath) as! MyAppointmentTableViewCell).lblHour.text!) - \((tableView.cellForRowAtIndexPath(indexPath) as! MyAppointmentTableViewCell).hourS)"
            
            
            // print("\(viewCon.hourS)")
            
            
            viewCon.serviceName = Global.sharedInstance.ordersOfClientsArray[indexPath.section].nvSupplierName
            viewCon.idTurn = Global.sharedInstance.ordersOfClientsArray[indexPath.section].iCoordinatedServiceId
            self.present(viewCon, animated: false, completion: nil)
            
            break
        case 3://איחור בקטנה
            let viewCon:slaightLateViewController = storyboard?.instantiateViewController(withIdentifier: "slaightLateViewController") as! slaightLateViewController
            viewCon.service = (tableView.cellForRow(at: indexPath) as! MyAppointmentTableViewCell).lblText.text!
            viewCon.date = (tableView.cellForRow(at: indexPath) as! MyAppointmentTableViewCell).lblDate.text!
            viewCon.hour = "\((tableView.cellForRow(at: indexPath) as! MyAppointmentTableViewCell).lblHour.text!) - \((tableView.cellForRow(at: indexPath) as! MyAppointmentTableViewCell).hourE)"
            viewCon.serviceName = Global.sharedInstance.ordersOfClientsArray[indexPath.section].nvSupplierName
            viewCon.iCoordinatedServiceId = Global.sharedInstance.ordersOfClientsArray[indexPath.section].iCoordinatedServiceId
            self.present(viewCon, animated: false, completion: nil)
            break
        default:
            break
        }
    }
}
