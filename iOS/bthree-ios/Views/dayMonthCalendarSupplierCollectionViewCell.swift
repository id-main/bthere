
//
//  dayMonthCalendarSupplierCollectionViewCell.swift
//  Bthere
//
//  Created by User on 22.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

//cell of day in month in supplier design
class dayMonthCalendarSupplierCollectionViewCell: UICollectionViewCell {
    var dateFormatter = DateFormatter()
    @IBOutlet var lblDayDesc: UILabel!
    @IBOutlet var patternImg: UIImageView!
    @IBOutlet weak var lblisbhtere: UILabel!
    @IBOutlet weak var lbhasblockedhours: UILabel!
    let calendar = Foundation.Calendar.current
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    var isShabat:Bool = Bool()
    var delegate:clickToDayDelegate!
    let underlineAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle): NSUnderlineStyle.single.rawValue]

    @IBOutlet weak var viewIsFree: UIView!
    @IBOutlet var imgToday: UIImageView!
    var dateDay:Date = Date()
    @IBOutlet weak var btnEnterToDay: UIButton!
    var mylineundercell:UIView = UIView()

    //func cell
    func setDisplayData(_ DayInt:Int, HasEvent: Bool, isinrange:Bool, HasBlockedHoures:Bool, SameHours:Bool){
        // lblisbhtere.backgroundColor = UIColor.clearColor()
        // clean to avoid duplicate underline
        btnEnterToDay.isUserInteractionEnabled = true

        let mycircle = UIImageView()
        mycircle.image = UIImage(named: "bluecircleon.png")!
        mycircle.frame.size = CGSize(width: 10, height: 10)
        mycircle.contentMode = .scaleAspectFit

        let myredcircle = UIImageView()
        myredcircle.image = UIImage(named: "redcircleon.png")!
        myredcircle.frame.size = CGSize(width: 10, height: 10)
        myredcircle.contentMode = .scaleAspectFit
        //  lblisbhtere.addSubview(mycircle)
        //  UIColor(patternImage: UIImage(named: "bluecircleon.png")!)
        if HasBlockedHoures == true {
            lbhasblockedhours.isHidden = false
            lbhasblockedhours.addSubview(myredcircle)
            lbhasblockedhours.bringSubviewToFront(myredcircle)
        } else {
            lbhasblockedhours.isHidden = true
        }
        if HasEvent == true  && isinrange == true{
            lblisbhtere.isHidden = false
            lblisbhtere.addSubview(mycircle)
            lblisbhtere.bringSubviewToFront(mycircle)
        } else {
            lblisbhtere.isHidden = true
        }

        btnEnterToDay.isEnabled = true
        btnEnterToDay.backgroundColor =  UIColor.clear

        // להוסיף כפתור  בכל

        //    Global.sharedInstance.setEventsArray()
        var componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Calendar.sharedInstance.carrentDate as Date)
        componentsCurrent.day = DayInt
        let date:Date = Calendar.sharedInstance.from(componentsCurrent.year! , month: componentsCurrent.month!, day: DayInt)

        let date1 = Foundation.Calendar.current.date(from: componentsCurrent)!

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let formattedDateString = formatter.string(from: date1)

        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date2:Date = formatter.date(from: formattedDateString)!
        

        lblDayDesc?.font = UIFont(name: "OpenSansHebrew-Bold", size: 16)
        //            }//הועתק מיומן תורים אם לא צריך את זה ביומן ספק או משהו ברעיון של זה צריך למחק
        /////    print("Global.sharedInstance.dateFreeDays \(Global.sharedInstance.dateFreeDays)")
        
        //        if isBlocked == true {
        //       //     self.viewIsFree.backgroundColor = Colors.sharedInstance.color4
        //            //self.viewIsFree.backgroundColor =   UIColor(patternImage: UIImage(named: "hash anca.png")!)
        //          //  self.viewIsFree.hidden = false
        //
        //            self.patternImg.image = UIImage(named: "hash anca.png")!
        //          //   self.patternImg.hidden = false
        //
        //        }
        //    else {
        //           // self.viewIsFree.backgroundColor = UIColor.clearColor()
        //             // self.viewIsFree.hidden = true
        //              self.patternImg.image = nil
        //          //  self.patternImg.hidden = true
        //            }
        
        //        if isFound == 0
        //            {
        //                self.viewIsFree.backgroundColor = UIColor.clearColor()//check
        //            }
        //            else{
        //                isFound = 0
        //            }

        dateDay = date2
        let dayWeek:Int = Calendar.sharedInstance.getDayOfWeek(date2)!
        //     print("dateDay \(dateDay) si day week \(dayWeek)")
        
        if Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker") == -1 {

            if Global.sharedInstance.NOWORKINGDAYS.contains(dayWeek) &&  HasEvent == false {

                self.patternImg.image = UIImage(named: "hash anca.png")!
            } else {

                self.patternImg.image = nil
            }
        }
        else {
            /*
             {
             FREEDAYS =         (
             4,
             5,
             7
             );
             WORKERID = 225;
             bSameWH = 0;
             },
             */
            //take in case worker has same hours as business
            if SameHours == true {
            if Global.sharedInstance.NOWORKINGDAYS.contains(dayWeek) &&  HasEvent == false {

                self.patternImg.image = UIImage(named: "hash anca.png")!
            } else {

                self.patternImg.image = nil
            }
            } else {
            let delucru:NSMutableArray =  Global.sharedInstance.FREEDAYSALLWORKERS
            for item in delucru {
                if let _:NSDictionary = item as? NSDictionary {
                    let workerdic:NSDictionary = item as! NSDictionary
                    let diciuserid:Int = workerdic["WORKERID"] as! Int
                    let iuseridselect:Int = Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker")
                    if diciuserid == iuseridselect {
                        if let _ = workerdic["bSameWH"] as? Int {
                            let whatint =  workerdic["bSameWH"] as! Int
                            if whatint == 1 {
                                if Global.sharedInstance.NOWORKINGDAYS.contains(dayWeek) &&  HasEvent == false {

                                    self.patternImg.image = UIImage(named: "hash anca.png")!
                                } else {

                                    self.patternImg.image = nil
                                }
                            }
                            else {
                                let FREEDAYS:NSArray = workerdic["FREEDAYS"] as! NSArray
                                if   FREEDAYS.contains(dayWeek) &&  HasEvent == false {
                                    self.patternImg.image = UIImage(named: "hash anca.png")!
                                } else {
                                    self.patternImg.image = nil
                                }
                            }
                        }
                        else {
                            let FREEDAYS:NSArray = workerdic["FREEDAYS"] as! NSArray
                            if   FREEDAYS.contains(dayWeek) &&  HasEvent == false {
                                self.patternImg.image = UIImage(named: "hash anca.png")!
                            } else {
                                self.patternImg.image = nil
                            }
                        }
                        break
                    }
                }
            }
                //now complete for not found employee meaning calendars
                //  Global.sharedInstance.FREEDAYSALLCALENDARS
                let delucru2:NSMutableArray =  Global.sharedInstance.FREEDAYSALLCALENDARS
                for item in delucru2 {
                    if let _:NSDictionary = item as? NSDictionary {
                        let workerdic:NSDictionary = item as! NSDictionary
                        let diciuserid:Int = workerdic["WORKERID"] as! Int
                        let iuseridselect:Int = Global.sharedInstance.defaults.integer(forKey: "idSupplierWorker")
                        if diciuserid == iuseridselect {
                            if let _ = workerdic["bSameWH"] as? Int {
                                let whatint =  workerdic["bSameWH"] as! Int
                                if whatint == 1 {
                                    if Global.sharedInstance.NOWORKINGDAYS.contains(dayWeek) &&  HasEvent == false {

                                        self.patternImg.image = UIImage(named: "hash anca.png")!
                                    } else {

                                        self.patternImg.image = nil
                                    }
                                }
                                else {
                                    let FREEDAYS:NSArray = workerdic["FREEDAYS"] as! NSArray
                                    if   FREEDAYS.contains(dayWeek) &&  HasEvent == false {
                                        self.patternImg.image = UIImage(named: "hash anca.png")!
                                    } else {
                                        self.patternImg.image = nil
                                    }
                                }
                            }
                            else {
                                let FREEDAYS:NSArray = workerdic["FREEDAYS"] as! NSArray
                                if   FREEDAYS.contains(dayWeek) &&  HasEvent == false {
                                    self.patternImg.image = UIImage(named: "hash anca.png")!
                                } else {
                                    self.patternImg.image = nil
                                }
                            }
                            break
                        }
                    }
                }

        }

        }

        let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)
        dayToday = components.day!

        //check if date is passed
        if small(date, rhs: Date())
        {
            lblDayDesc?.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            if !self.isShabat
            {
                lblDayDesc.textColor = UIColor.gray
            }

            btnEnterToDay.isEnabled = true

        }

        
        if Global.sharedInstance.arrEventsCurrentMonth.count > 0 && Global.sharedInstance.isSyncWithGoogelCalendarSupplier == true
        {

            for  item in Global.sharedInstance.arrEventsCurrentMonth
            {
                let event = item

                let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: event.startDate)
                //\\      print(" event.startDate \(event.startDate)")


                let dayEvent = componentsEvent.day
                if small(date, rhs: Date())

                {
                    lblDayDesc.textColor = UIColor.gray
                    lblDayDesc?.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                    btnEnterToDay.isEnabled = true
                }

                if dayEvent == dayToday
                {


                    let underlineAttributedString = NSMutableAttributedString(string:String(DayInt))
                    
                    let range = (String(DayInt) as NSString).range(of: String(DayInt))
                    underlineAttributedString.addAttribute(NSAttributedString.Key.underlineStyle , value:NSUnderlineStyle.single.rawValue, range: range)
                    if small(date, rhs: Date())
                    {
                        underlineAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray , range: range)

                        btnEnterToDay.isEnabled = true

                    }
                    lblDayDesc.attributedText = underlineAttributedString
                    break
                }
                else{
                    if small(date, rhs: Date())
                    {

                        lblDayDesc.textColor = UIColor.gray
                        lblDayDesc?.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
                        btnEnterToDay.isEnabled = true

                    }
                    lblDayDesc.text = String(DayInt)
                }

            }
        }
        else{
            lblDayDesc.text = String(DayInt)

            //  lblDayDesc?.font = UIFont(name: "OpenSansHebrew-Bold", size: 16)
        }



        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var s1 = dateFormatter.string(from: Calendar.sharedInstance.carrentDate as Date).components(separatedBy: "/")
        var s2 = dateFormatter.string(from: Date()).components(separatedBy: "/")
        if s1[1] == s2[1] && s2[2] == s1[2]{
            let characters = s1[0].characters.map { String($0) }
            if characters[0] == String(0){
                if DayInt == Int(characters[1]){
                    imgToday.isHidden = false

                }
                else if DayInt < Int(characters[1]){
                    lblDayDesc.alpha = 0.7
                }}
            else if DayInt == Int(s1[0]){
                imgToday.isHidden = false
            }
            else if DayInt < Int(s1[0]){
                if DayInt % 7 == 0
                {

                    lblDayDesc.alpha = 1

                }
                else{
                    lblDayDesc.alpha = 0.8
                }
            }
        }
        if isShabat
        {
            if self.small(date, rhs: Date())
            {
                lblDayDesc.alpha = 0.9
                lblDayDesc?.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            }
        }
        if self.small(date, rhs: Date())
        {
            lblDayDesc?.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblDayDesc.alpha = 0.7
        }

    }
    /// if click on day
    @IBAction func btnEnterToDayClick(_ sender: AnyObject) {
        Global.sharedInstance.dateDayClick = dateDay
        print("datedayclick \(dateDay)")
        Global.sharedInstance.currDateSelected = dateDay
        Global.sharedInstance.isShowClickDate =  true
        delegate.clickToDay()
    }

    func setNull(){
        lblDayDesc.text = ""
        lblisbhtere.isHidden = true
        lbhasblockedhours.isHidden = true
        //   self.viewIsFree.backgroundColor = UIColor.clearColor()
        self.patternImg.image = nil
        btnEnterToDay.isUserInteractionEnabled = false
        //    self.patternImg.hidden = true

    }
    
    // func that check if date is passed
    internal func small(_ lhs: Date, rhs: Date) -> Bool {
        let calendar:Foundation.Calendar = Foundation.Calendar.current

        let isToday:Bool = calendar.isDateInToday(lhs);
        if isToday
        {
            return false
        }
        else
        {
            return lhs.compare(rhs) == .orderedAscending
        }
    }
    override func layoutSubviews() {
        for itemView in self.subviews {
            for subview in itemView.subviews as [UIView] {
                if let myView:UIView = subview {
                    if myView.tag == 7777 {
                        myView.removeFromSuperview()
                    }
                }
            }
        }
        mylineundercell = UIView()
        mylineundercell.tag = 7777
        mylineundercell.frame.size = CGSize(width: self.frame.size.width, height: 1)
        mylineundercell.backgroundColor = Colors.sharedInstance.color6
        mylineundercell.frame.origin.y = self.frame.size.height - 1 //test it on different screens
        mylineundercell.clipsToBounds = true
        self.addSubview(mylineundercell)
        self.bringSubviewToFront(mylineundercell)
        self.addSubview(viewIsFree)
        self.sendSubviewToBack(viewIsFree)
        self.bringSubviewToFront(btnEnterToDay)




    }



    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
