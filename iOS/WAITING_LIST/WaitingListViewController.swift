//
//  WaitingListViewController.swift
//  Bthere
//
//  Created by User on 5.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

//רשימת המתנה לספק
class WaitingListViewController:NavigationModelViewController, UITableViewDelegate,UITableViewDataSource {
    var namesArray:Array<String> = ["קארין סופרו","לירון חזיז","משה סבח","צפורה יסמין"]
    var headersArray:Array<String> = ["2015 אוק׳ 23ו׳,  ","2015 אוק׳ 23ו׳,  ","2015 אוק׳ 23ו׳,  "]
    var arrImg:Array<String> = ["18@x1.png","5@x1.png","Phone.png","Phone.png"]

    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    var RowsArrayHours:Array<String> = ["08:00-09:30","08:00-09:30","08:00-09:30","08:00-09:30"]
    var RowsArrayDescs:Array<String> = ["מירב כהן )פסיכולוגית(","מירב כהן )פסיכולוגית(","מירב כהן )פסיכולוגית("]
    let calendar = Foundation.Calendar.current
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    
    //MARK: - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
        Global.sharedInstance.setAllEventsArray()
        AppDelegate.i = 0
        tblData.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var tblData: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Global.sharedInstance.arrEvents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event =  Global.sharedInstance.arrEvents[indexPath.section]
        
        let componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Calendar.sharedInstance.carrentDate as Date)
        let componentsToday = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
        let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: event.startDate)
        //   //\\print(event.startDate)
        yearToday =  componentsCurrent.year!
        monthToday = componentsCurrent.month!
        dayToday = componentsCurrent.day!
        
        let yearEvent =  componentsEvent.year
        let monthEvent = componentsEvent.month
        let monthName = DateFormatter().shortStandaloneMonthSymbols[monthEvent! - 1]
        
        let dayEvent = componentsEvent.day
        
        if indexPath.row == 0
        {
            let cell:HeaderRecordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HeaderRecordTableViewCell")as!HeaderRecordTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let dayWeek = Calendar.sharedInstance.getDayOfWeek(event.startDate)
            let dayInWeek = DateFormatter().veryShortWeekdaySymbols[dayWeek! - 1]
            if componentsToday.day == dayEvent{
                cell.imgToday.isHidden = false
            }
            else{
                cell.imgToday.isHidden = true
            }
            let str =  "," + String(describing: dayEvent) + " " + String(monthName) + " " + String(describing: yearEvent)
            cell.setDisplayData(str,daydesc: dayInWeek)
            return cell
        }
        let cell:RowInWaitingListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RowInWaitingListTableViewCell")as!RowInWaitingListTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: event.startDate)
        
        let componentsEnd = (calendar as NSCalendar).components([.hour, .minute], from: event.endDate)
        
        let hourS = componentsStart.hour
        let minuteS = componentsStart.minute
        
        let hourE = componentsEnd.hour
        let minuteE = componentsEnd.minute
        
        var hourS_Show:String = hourS!.description
        var hourE_Show:String = hourE!.description
        var minuteS_Show:String = minuteS!.description
        var minuteE_Show:String = minuteE!.description
        
        if hourS! < 10
        {
            hourS_Show = "0" + hourS_Show
        }
        if hourE! < 10
        {
            hourE_Show = "0" + hourE_Show
        }
        if minuteS! < 10
        {
            minuteS_Show = "0" +   minuteS_Show
        }
        if minuteE! < 10
        {
            minuteE_Show = "0" + minuteE_Show
        }
        let st =  "\(hourS_Show):\(minuteS_Show) - \(hourE_Show):\(minuteE_Show)"
        cell.setDisplayData(namesArray[indexPath.row],  desc:event.title,hour: st,myImage: arrImg[indexPath.row])
        if indexPath.row == 2{
            cell.viewButtom.isHidden = true
        }
        else{
            cell.viewButtom.isHidden = false

        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 25
        }
        return 50
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
