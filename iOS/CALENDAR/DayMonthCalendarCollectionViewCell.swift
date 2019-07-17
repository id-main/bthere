//
//  DayMonthCalendarCollectionViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/16/16.
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

protocol clickToDayDelegate {
    func clickToDay()
}
class DayMonthCalendarCollectionViewCell: UICollectionViewCell {

    //MARK: - Variables

    var dateFormatter = DateFormatter()
    let calendar = Foundation.Calendar.current
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    var isShabat:Bool = Bool()
    var delegate:clickToDayDelegate!
    let underlineAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle): NSUnderlineStyle.single.rawValue]
    var dateDay:Date = Date()
    var whichModelOpenMe:Int = 0// 2 = האם הגיעו מתצוגת חודש של יומן לקוח = 1 או של יומן ספק שהלקוח רואה
    var isSyncWithGoogle = true//שומר את הפלאג המתאים שלפיו צריך לשאול בין אם זה יומן לקוח או ספק שהלקוח רואה

    //MARK: - Outlet

    @IBOutlet var lblBtEvent: UILabel!
    @IBOutlet var lblIsBthereEvent: UILabel!
    @IBOutlet var lblDayDesc: UILabel!

    @IBOutlet weak var viewIsFree: UIView!
    @IBOutlet var imgToday: UIImageView!
    @IBOutlet var btnEnterToDay: UIButton!
    // enter to day design by day selected on free time to orders
    @IBAction func btnEnterToDayClick(_ sender: AnyObject) {


        Global.sharedInstance.dateDayClick = dateDay
        Global.sharedInstance.currDateSelected = dateDay
        Global.sharedInstance.isShowClickDate =  true
        delegate.clickToDay()
    }

    //MARK: - Initial

    func setDisplayData(_ DayInt:Int){

        lblIsBthereEvent.backgroundColor = UIColor(patternImage: UIImage(named: "circle_orange")!)
        btnEnterToDay.isEnabled = true
        btnEnterToDay.backgroundColor =  UIColor.clear

        // להוסיף כפתור  בכל

        Global.sharedInstance.setEventsArray()
        //  print("azzz \( Calendar.sharedInstance.carrentDate)")
        var componentsCurrent = (calendar as NSCalendar).components([.day, .month, .year], from: Calendar.sharedInstance.carrentDate as Date)
        componentsCurrent.day = DayInt

        let date:Date = Calendar.sharedInstance.from(componentsCurrent.year! , month: componentsCurrent.month!, day: DayInt)


        let date1 = Foundation.Calendar.current.date(from: componentsCurrent)!

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let formattedDateString = formatter.string(from: date1)

        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date2:Date = formatter.date(from: formattedDateString)!
        var freeDayString = ""
        var isFound = 0
        // from supplier calander that client see design
        if Global.sharedInstance.model == 2
        {
            for  item in Global.sharedInstance.dateFreeDays{

                freeDayString = formatter.string(from: item as Date)
                //\\  print("a item is gold \(item.description)")
                //\\   print("st     e \(st) si formattedDateString \(formattedDateString)")
                if freeDayString == formattedDateString {

                    self.viewIsFree.backgroundColor = Colors.sharedInstance.color4
                    isFound = 1
                    break
                }
            }

            if isFound == 0
            {
                self.viewIsFree.backgroundColor = UIColor.clear            }
            else
            {
                isFound = 0
            }
        }

        dateDay = date2

        let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)
        dayToday = components.day!


        if small(date, rhs: Date())
        {

            // the date is passed
            btnEnterToDay.isEnabled = false
        }
        //ביומן ספק שהלקוח רואה, אם אין תור פנוי - לא לחיץ
        if whichModelOpenMe == 2 && self.viewIsFree.backgroundColor != Colors.sharedInstance.color4
        {
            btnEnterToDay.isEnabled = false
        }

        if whichModelOpenMe == 2 //== con//יומן ספק שהלקוח רואה
        {
            isSyncWithGoogle = Global.sharedInstance.isSyncWithGoogleCalendarAppointment
        }

        else if whichModelOpenMe == 1 //== con1//לקוח
        {
            isSyncWithGoogle = Global.sharedInstance.isSyncWithGoogelCalendar
        }


        if Global.sharedInstance.arrEventsCurrentMonth.count > 0 && isSyncWithGoogle == true
        {
            for  item in Global.sharedInstance.arrEventsCurrentMonth
            {

                let event = item

                let componentsEvent = (calendar as NSCalendar).components([.day, .month, .year], from: event.startDate)

                let dayEvent = componentsEvent.day

                // if has event in this day
                if dayEvent == dayToday
                {

                    let underlineAttributedString = NSMutableAttributedString(string:String(DayInt))

                    let range = (String(DayInt) as NSString).range(of: String(DayInt))
                    underlineAttributedString.addAttribute(NSAttributedString.Key.underlineStyle , value:NSUnderlineStyle.single.rawValue, range: range)
                    if small(date, rhs: Date())
                    {
                        underlineAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray , range: range)

                    }

                    lblDayDesc.attributedText = underlineAttributedString
                    break
                }
                else{

                    lblDayDesc.text = String(DayInt)
                }

            }
        }
        else{
            lblDayDesc.text = String(DayInt)
        }


        //var str:String = ""
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var currentDateString = dateFormatter.string(from: Calendar.sharedInstance.carrentDate as Date).components(separatedBy: "/")
        var stringDate = dateFormatter.string(from: Date()).components(separatedBy: "/")

        if currentDateString[1] == stringDate[1] && stringDate[2] == currentDateString[2]{
            let characters = currentDateString[0].characters.map { String($0) }
            if characters[0] == String(0){
                if DayInt == Int(characters[1]){
                    imgToday.isHidden = false

                }
                else if DayInt < Int(characters[1]){

                }}
            else if DayInt == Int(currentDateString[0]){
                imgToday.isHidden = false
            }
            else if DayInt < Int(currentDateString[0]){
                if DayInt % 7 == 0
                {

                }
                else{
                    lblDayDesc.alpha = 0.5
                }
            }
        }
        if isShabat
        {
            if self.small(date, rhs: Date())
            {
                lblDayDesc.alpha = 0.5

                btnEnterToDay.isEnabled = false
            }
        }
        if self.small(date, rhs: Date())
        {
            lblDayDesc.textColor
                = UIColor.gray
            lblDayDesc.alpha = 0.5
        }
        if Global.sharedInstance.model == 1
        {
            btnEnterToDay.isEnabled = true
        }

    }

    override func layoutSubviews() {
        self.addSubview(viewIsFree)
        self.sendSubviewToBack(viewIsFree)
    }



    func setNull(){
        lblDayDesc.text = ""
    }
    // func that check if date passed
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



}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
