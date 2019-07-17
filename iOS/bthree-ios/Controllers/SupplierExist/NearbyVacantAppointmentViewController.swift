//
//  NearbyVacantAppointmentViewController.swift
//  Bthere
//
//  Created by User on 1.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//ספק קיים-תורים פנויים קרובים
class NearbyVacantAppointmentViewController: UIViewController{
    
    //MARK: - Outlet
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBAction func btnClose(_ sender: AnyObject) {
    }
    
    @IBOutlet weak var tblAppointments: UITableView!
    
    //MARK: - Properties
    
    let calendar = Foundation.Calendar.current
    var datesArray:Array <Date> = [Date(timeIntervalSinceReferenceDate: -12345.0),Date(timeIntervalSinceReferenceDate: -12345.0),Date(timeIntervalSinceReferenceDate: +123000089.0)]
    var textArray:Array <String> =
        ["תספורת אישה בחצי מחיר",
         "1 + 1 על מסיכות השיער",
         "גוונים ב₪200 עד השעה 2:00"]
    
    //MARK: - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTopBorder(tblAppointments, color: UIColor.black)
        tblAppointments.separatorStyle = .none
        
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Search Result Hairdresser.jpg")!)
        self.view.addBackground2()
        
        if DeviceType.IS_IPHONE_6{
            lblTitle.font = UIFont(name: "OpenSansHebrew-Bold", size: 28)!
        }
        else
        { 
            if DeviceType.IS_IPHONE_6P
            {
                lblTitle.font = UIFont(name: "OpenSansHebrew-Bold", size: 30)!
            }
            else
            {
                if DeviceType.IS_IPHONE_5
                {
                    lblTitle.font =  UIFont(name: "OpenSansHebrew-Bold", size: 24)!
                }
                else
                {
                    lblTitle.font = Colors.sharedInstance.fontSecondHeader
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentNearByTableViewCell")as! AppointmentNearByTableViewCell
        
        
        let separatorView: UIView = UIView(frame: CGRect(x: 0, y: cell.frame.height + cell.frame.height * 0.0325, width: cell.frame.width + (cell.frame.width / 3), height: 1))
        separatorView.layer.borderColor = UIColor.black.cgColor
        separatorView.layer.borderWidth = 1
        cell.contentView.addSubview(separatorView)
        
        cell.setDisplayData(shortDate(datesArray[indexPath.row]),hour:  getHour(datesArray[indexPath.row]), text: textArray[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.1125
    }
    
    func addTopBorder(_ any:UIView,color:UIColor)
    {
        let borderTop = CALayer()
        
        borderTop.frame = CGRect(x: 0, y: 0, width: any.layer.frame.width + (any.layer.frame.width / 3), height: 1)
        
        borderTop.backgroundColor = color.cgColor;
        
        any.layer.addSublayer(borderTop)
    }
    
    func getHour(_ date:Date)-> String
    {
        let components = (calendar as NSCalendar).components([.hour,.minute], from: date)
        let hour =  components.hour
        let minute =  components.minute
        return "\(hour):\(minute)"
    }
    
    func shortDate(_ date:Date) -> String {
        
        let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)
        
        let components1 = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        let yearToday =  components1.year
        let monthToday = components1.month
        let dayToday = components1.day
        
        if year == yearToday && month == monthToday && day == dayToday
        {
            return "TODAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
    
}
