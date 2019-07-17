//
//  EleventhHourViewController.swift
//  bthree-ios
//
//  Created by User on 14.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
// לקוח דף הדקה ה-90
class EleventhHourViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tblSales: UITableView!
    
    var today:Date = Date()
    var imagesArray:Array <String> = ["22.png","26.png","28.png"]
    var datesArray:Array <Date> = [Date(),Date(timeIntervalSinceReferenceDate: -12345.0),Date(timeIntervalSinceReferenceDate: +123000089.0)]
    //"12/05/16","היום","15/03/16"
    var textArray:Array <String> = ["תספורת אישה בחצי מחיר",
                                    "1 + 1 על מסיכות השיער",
                                    "גוונים ב₪200 /n עד השעה 2:00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSales.separatorStyle = UITableViewCell.SeparatorStyle.none
        addTopBorder(tblSales, color: UIColor.black)
        tblSales.separatorStyle = .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.sharedInstance.arrDiscount90Obj.count
        //return imagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EleventhHour")as! EleventhHourTableViewCell
        
        /*let separatorView: UIView = UIView(frame: CGRectMake(0, cell.frame.height, cell.frame.width + (cell.frame.width / 3), 1))
         separatorView.layer.borderColor = UIColor.blackColor().CGColor
         separatorView.layer.borderWidth = 1
         cell.contentView.addSubview(separatorView)*/
        
        //new 23-01-17
        cell.setDisplayData(Global.sharedInstance.arrDiscount90Obj[indexPath.row].nvImageFilePath, date: shortDate(Global.sharedInstance.arrDiscount90Obj[indexPath.row].dtDateDscount), text: Global.sharedInstance.arrDiscount90Obj[indexPath.row].nvDescription)
        
        //        cell.setDisplayData(imagesArray[indexPath.row], date: shortDate(datesArray[indexPath.row]), text: textArray[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.15
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func addTopBorder(_ any:UIView,color:UIColor)
    {
        let borderTop = CALayer()
        
        borderTop.frame = CGRect(x: 0, y: 0, width: any.layer.frame.width + (any.layer.frame.width / 3), height: 1)
        
        borderTop.backgroundColor = color.cgColor;
        
        any.layer.addSublayer(borderTop)
    }
    
    func shortDate(_ date:Date) -> String {
        
        let calendar = Foundation.Calendar.current
        
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
