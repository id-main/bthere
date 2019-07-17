//
//  EventsForWeek12ViewsCollectionViewCell.swift
//  Bthere
//
//  Created by User on 15.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class EventsForWeek12ViewsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var view0to5: UIView!
    
    @IBOutlet weak var view5to10: UIView!
    
    @IBOutlet weak var view10to15: UIView!
    
    @IBOutlet weak var view15to20: UIView!
    
    @IBOutlet weak var view20to25: UIView!
    
    @IBOutlet weak var view25to30: UIView!
    
    @IBOutlet weak var view30to35: UIView!
    
    @IBOutlet weak var view35to40: UIView!
    
    @IBOutlet weak var view40to45: UIView!
    
    @IBOutlet weak var view45to50: UIView!
    
    @IBOutlet weak var view50to55: UIView!
    
    @IBOutlet weak var view55to60: UIView!
    
    @IBOutlet weak var lblHours1: UILabel!
    
    @IBOutlet weak var lblHours2: UILabel!
    
    @IBOutlet weak var lblHours3: UILabel!
    
    @IBOutlet weak var lblHours4: UILabel!
    
    @IBOutlet weak var lblHours5: UILabel!
    
    @IBOutlet weak var lblHours6: UILabel!
    
    @IBOutlet weak var lblHours7: UILabel!
    
    @IBOutlet weak var lblHours8: UILabel!
    
    @IBOutlet weak var lblHours9: UILabel!
    
    @IBOutlet weak var lblHours10: UILabel!
    
    @IBOutlet weak var lblHours11: UILabel!
    
    @IBOutlet weak var lblHours12: UILabel!

    @IBOutlet var viewTopInTop: UIView!
    @IBOutlet var viewButtomInTop: UIView!
    @IBOutlet var viewMiddleInTop: UIView!
    @IBOutlet var viewTopInButtom: UIView!
    @IBOutlet var viewButtominButtom: UIView!
    @IBOutlet var viewMiddleInButtom: UIView!
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBottom: UIView!
    

    @IBOutlet weak var txtviewDesc: UITextView!
    @IBOutlet weak var txtViewDescBottom: UITextView!
    

    
    //MARK: - Properties
    
    let dateFormatterHours = DateFormatter()
    let calendar = Foundation.Calendar.current
    
    var  IsToppTop:Bool = false
    var  IsMiddleeTop:Bool = false
    var  IsButtomTop:Bool = false
    var  IsToppButtom:Bool = false
    var  IsMiddleeButtom:Bool = false
    var  IsButtomButtom:Bool = false
    var viewInTop:UIView  = UIView()
    var viewInButtom:UIView  = UIView()
    
    var DisplayDataDay:Bool = false
    var hasEvent:Bool = false
    var hasBthereEvent:Bool = false
    var hourFree:String = ""
    var dateEvent:Date = Date()
    var hourStart:String = ""
    var hourEnd:String = ""
    var delegate:openDetailsOrderDelegate!=nil
    var delegateClickOnDay:enterOnDayDelegate!=nil
    var heightViewTop: NSLayoutConstraint?
    var hightViewButtom: NSLayoutConstraint?
    
    var heightViewTopEvent: NSLayoutConstraint?
    var hightViewButtomEvent: NSLayoutConstraint?
    
    var indexDayOfWeek:Int = -1
    var indexHourOfDay:Int = -1
    
    var delegateRegister:goToRegisterDelegate!=nil
    
    override func awakeFromNib() {
        
        dateFormatterHours.dateFormat = "HH:mm"
        // add UITapGestureRecognizer to views on order to recognize  the touch them

        let tapFree1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn(_:)))
        self.view0to5.addGestureRecognizer(tapFree1)
        let tapFree2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn(_:)))
        self.view5to10.addGestureRecognizer(tapFree2)
        let tapFree3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn(_:)))
        self.view10to15.addGestureRecognizer(tapFree3)
        let tapFree4: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn(_:)))
        self.view15to20.addGestureRecognizer(tapFree4)
        let tapFree5: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn(_:)))
        self.view20to25.addGestureRecognizer(tapFree5)
        let tapFree6: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn(_:)))
        self.view25to30.addGestureRecognizer(tapFree6)
        let tapFree7: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn(_:)))
        self.view30to35.addGestureRecognizer(tapFree7)
        let tapFree8: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn(_:)))
        self.view35to40.addGestureRecognizer(tapFree8)
        let tapFree9: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn(_:)))
        self.view40to45.addGestureRecognizer(tapFree9)
        let tapFree10: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn(_:)))
        self.view45to50.addGestureRecognizer(tapFree10)
        let tapFree11: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn(_:)))
        self.view50to55.addGestureRecognizer(tapFree11)
        let tapFree12: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn(_:)))
        self.view55to60.addGestureRecognizer(tapFree12)
    }
    
    //MARK: - Cell Design
    func setDisplayData(_ numViewsToShow:Int,isTop:Bool,description:String,descTop:Bool,isBthereEvent:Bool)
    {
        
        self.txtviewDesc.scrollRangeToVisible(NSMakeRange(0, 0))
        self.txtViewDescBottom.scrollRangeToVisible(NSMakeRange(0, 0))
        
        
        
        viewTopInTop.isHidden = true
        viewButtomInTop.isHidden  = true
        viewMiddleInTop.isHidden  = true
        viewTopInButtom.isHidden  = true
        viewButtominButtom.isHidden  = true
        viewMiddleInButtom.isHidden  = true
        
        if hasEvent == true && hasBthereEvent == false//(hasEvent && isBthereEvent == false) || (hasBthereEvent && isBthereEvent == true)
        {
            checkWhichValue()
        }
        else
        {
            viewTopInTop.isHidden = true
            viewButtomInTop.isHidden  = true
            viewMiddleInTop.isHidden  = true
            viewTopInButtom.isHidden  = true
            viewButtominButtom.isHidden  = true
            viewMiddleInButtom.isHidden  = true
        }
        if isBthereEvent == true
        {
            txtviewDesc.font = UIFont(name: "OpenSansHebrew-Bold", size: 9)
            txtViewDescBottom.font = UIFont(name: "OpenSansHebrew-Bold", size: 9)
        }
        else
        {
            txtviewDesc.font = UIFont(name: "OpenSansHebrew-Regular", size: 9)
            txtViewDescBottom.font = UIFont(name: "OpenSansHebrew-Regular", size: 9)
        }
        if descTop == true
        {
            self.txtviewDesc.scrollRangeToVisible(NSMakeRange(0, 0))
            txtviewDesc.text = description
        }
        else
        {
            self.txtViewDescBottom.scrollRangeToVisible(NSMakeRange(0, 0))
            txtViewDescBottom.text = description
        }
    }
    
    
    //לארועים של המכשיר
    //פונקציה זו מקבלת שלושה פרמטרים
    // whichView משתנה זה מסמל את איזה ויו צריך לצבוע באפור -
    //ועוד שתי משתנים של הגבהים של היו שמשתנים בהתאם לדקות
    func setDisplayViewsEvents(_ whichView:Bool,heightTop:CGFloat ,heightButtom:CGFloat,eventKind:Int)  {

//        if eventKind == 0//ארוע אישי
//        {
//            lblHoursTop.font = UIFont (name: "OpenSansHebrew-Light", size: 17)
//            lblDescTop.font = UIFont (name: "OpenSansHebrew-Light", size: 17)
//            lblHoursBottom.font = UIFont (name: "OpenSansHebrew-Light", size: 17)
//            lblDescBottom.font = UIFont (name: "OpenSansHebrew-Light", size: 17)
//        }
//        else if eventKind == 1//ארוע של ביזר
//        {
//            lblHoursTop.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
//            lblDescTop.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
//            lblHoursBottom.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
//            lblDescBottom.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
//        }
    }
    
    
    //        @IBOutlet var btnOPenOrderOutlet: UIButton!
    //        @IBAction func btnOpenOrder(sender: UIButton) {
    //
    //            Global.sharedInstance.hourFreeEvent = self.hourFree
    //            delegate.openDetailsOrder()
    //        }
    
    func showLblHours(_ tag:Int,hourS_Show:String,hourE_Show:String)
    {
        switch tag {
        case 0:
            lblHours1.backgroundColor = Colors.sharedInstance.color6
        case 5:
            lblHours2.backgroundColor = Colors.sharedInstance.color6
        case 10:
            lblHours3.backgroundColor = Colors.sharedInstance.color6
        case 15:
            lblHours4.backgroundColor = Colors.sharedInstance.color6
        case 20:
            lblHours5.backgroundColor = Colors.sharedInstance.color6
        case 25:
            lblHours6.backgroundColor = Colors.sharedInstance.color6
        case 30:
            lblHours7.backgroundColor = Colors.sharedInstance.color6
        case 35:
            lblHours8.backgroundColor = Colors.sharedInstance.color6
        case 40:
            lblHours9.backgroundColor = Colors.sharedInstance.color6
        case 45:
            lblHours10.backgroundColor = Colors.sharedInstance.color6
        case 50:
            lblHours11.backgroundColor = Colors.sharedInstance.color6
        case 55:
            lblHours12.backgroundColor = Colors.sharedInstance.color6
            
        default:
            lblHours1.backgroundColor = Colors.sharedInstance.color6
        }
    }
    
    @objc func tapOrderTurn(_ sender:UITapGestureRecognizer)
    {
        Global.sharedInstance.whichDesignOpenDetailsAppointment = 2
        
        let view = sender.view
        let loc = sender.location(in: view)
        let subview = view?.hitTest(loc, with: nil)
        var strDate:String = ""
        //צבוע בתכלת
        if subview?.backgroundColor == Colors.sharedInstance.color4
        {
            switch subview!.tag// swich the range of minute is selected
            {
            case 0:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours1.tag].objProviderHour.nvFromHour

                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours1.tag].objProviderHour.nvToHour
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours1.tag].iProviderUserId
                }
                strDate = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours1.tag].dtDate
                
            case 5:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours2.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours2.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours2.tag].dtDate
                
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours2.tag].iProviderUserId
                }
                
            case 10:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours3.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours3.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours3.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours3.tag].iProviderUserId
                }
                
            case 15:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours4.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours4.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours4.tag].dtDate
                
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours4.tag].iProviderUserId
                }
                
            case 20:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours5.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours5.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours5.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours5.tag].iProviderUserId
                }
                
            case 25:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours6.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours6.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours6.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours6.tag].iProviderUserId
                }
                
            case 30:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours7.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours7.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours7.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours7.tag].iProviderUserId
                }
                
                
            case 35:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours8.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours8.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours8.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours8.tag].iProviderUserId
                }
                
            case 40:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours9.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours9.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours9.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours9.tag].iProviderUserId
                }
            case 45:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours10.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours10.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours10.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours10.tag].iProviderUserId
                }
            case 50:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours11.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours11.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours11.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours11.tag].iProviderUserId
                }
                
            case 55:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours12.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours12.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours12.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours12.tag].iProviderUserId
                }
            default:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours1.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours1.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours1.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForWeek[indexDayOfWeek][lblHours1.tag].iProviderUserId
                }
            }
            Global.sharedInstance.dateDayClick = Global.sharedInstance.getStringFromDateString(strDate)

            Global.sharedInstance.currDateSelected = Global.sharedInstance.getStringFromDateString(strDate)
            
            let calendar = Foundation.Calendar.current
            //the day of week from date - (int)
            let day:Int = Calendar.sharedInstance.getDayOfWeek(Global.sharedInstance.currDateSelected)! - 1
            //the day of week from date - (string)
            Global.sharedInstance.dayFreeEvent = DateFormatter().weekdaySymbols[day]
            
            let hourStart = Global.sharedInstance.getStringFromDateString(Global.sharedInstance.hourFreeEvent)
            let hourEnd = Global.sharedInstance.getStringFromDateString(Global.sharedInstance.hourFreeEventEnd)
            
            let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: hourStart)
            
            let hourS = componentsStart.hour
            let minuteS = componentsStart.minute
            
            let componentsEnd = (calendar as NSCalendar).components([.hour, .minute], from: hourEnd)
            
            Global.sharedInstance.eventBthereDate = Global.sharedInstance.getStringFromDateString(strDate)
            
            Global.sharedInstance.eventBthereDateStart = Calendar.sharedInstance.getPartsOfDate(Global.sharedInstance.eventBthereDate , to: componentsStart)
            Global.sharedInstance.eventBthereDateEnd = Calendar.sharedInstance.getPartsOfDate(Global.sharedInstance.eventBthereDate , to: componentsEnd)
            
            var hourS_Show:String = hourS!.description
            var minuteS_Show:String = minuteS!.description
            
            if hourS! < 10
            {
                hourS_Show = "0" + hourS_Show
            }
            
            if minuteS! < 10
            {
                minuteS_Show = "0" +   minuteS_Show
            }
           
            
            let fullHourS = "\(hourS_Show):\(minuteS_Show)"
            Global.sharedInstance.hourFreeEvent = fullHourS
            
            if Global.sharedInstance.currentUser.iUserId == 0
            {
               delegateRegister.goToRegister()
            }
            else
            {
            delegate.openDetailsOrder(1)//פנוי
            }
        }
        else//בשביל לחיצה על ארוע של ביזר להצגת פרטי התור
        {
            var dateFrom:Date = Date()
            var dateTo:Date = Date()
            
            //מעבר על ארועי ביזר ליום מסויים(שעליו לחצו)
            for item in Global.sharedInstance.bthereEventsForWeek[indexDayOfWeek]
            {
                dateFrom = Global.sharedInstance.getStringFromDateString(item.nvFromHour)
                let componentsFrom = (calendar as NSCalendar).components([.hour, .minute], from: dateFrom) //year month day
                let strFromHour = componentsFrom.hour
                let strFromMinute = componentsFrom.minute
                
                dateTo = Global.sharedInstance.getStringFromDateString(item.nvToHour)
                let componentsTo = (calendar as NSCalendar).components([.hour, .minute], from: dateTo) //year month day
                let strToHour = componentsTo.hour
                let strToMinute = componentsTo.minute
                //בודק האם ה-view שעליו לחצו הוא תור של ביזר ואז בלחיצה יש להציג את פרטי התור
                
                
                if strFromHour == strToHour && strFromHour == indexHourOfDay//התחלה וסיום זהות - אירוע של שעה
                {
                    if subview!.tag >= strFromMinute! && subview!.tag <= strToHour!//אם הדקות בטווח
                    {
                        showDetailsOrder(item)
                    }
                }
                else if indexHourOfDay > strFromHour! && indexHourOfDay < strToHour!//לחצתי באמצע האירוע (יש פער של מינימום שעה בין ההתחלה לסיום)
                {
                    showDetailsOrder(item)
                }
                else if indexHourOfDay == strFromHour//שעת התחלה וסיום שונות ולחצתי בשעת ההתחלה
                {
                    if subview!.tag >= strFromMinute!
                    {
                        showDetailsOrder(item)
                    }
                }
                else if indexHourOfDay == strToHour//שעת התחלה וסיום שונות ולחצתי בשעת הסיום
                {
                    if subview!.tag <= strToMinute!
                    {
                        showDetailsOrder(item)
                    }
                }
            }
        }
    }
    //set details of order that selected
    func showDetailsOrder(_ item:OrderDetailsObj)
    {
        Global.sharedInstance.hourBthereEvent = item.nvFromHour
        Global.sharedInstance.hourBthereEventEnd = item.nvToHour
        
        Global.sharedInstance.dateEventBthereClick = item.dtDateOrder
        
        //the day of week from date - (int)
        let day:Int = Calendar.sharedInstance.getDayOfWeek(Global.sharedInstance.dateEventBthereClick)! - 1
        
        //the day of week from date - (string)
        Global.sharedInstance.dayFreeEvent = DateFormatter().weekdaySymbols[day]
        
        
        let hourStart = Global.sharedInstance.getStringFromDateString(Global.sharedInstance.hourBthereEvent)
        
        let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: hourStart)
        
        let hourS = componentsStart.hour
        let minuteS = componentsStart.minute
        
        var hourS_Show:String = hourS!.description
        var minuteS_Show:String = minuteS!.description
        
        if hourS! < 10
        {
            hourS_Show = "0" + hourS_Show
        }
       
        if minuteS! < 10
        {
            minuteS_Show = "0" +   minuteS_Show
        }
        
        
        let fullHourS = "\(hourS_Show):\(minuteS_Show)"
        Global.sharedInstance.hourBthereEvent = fullHourS
        let hourEnd = Global.sharedInstance.getStringFromDateString(Global.sharedInstance.hourBthereEventEnd)
        
        let componentsEnd = (calendar as NSCalendar).components([.hour, .minute], from: hourEnd)
        
        let hourE = componentsEnd.hour
        let minuteE = componentsEnd.minute
        
        var hourE_Show:String = hourE!.description
        var minuteE_Show:String = minuteE!.description
        
        
        if hourE! < 10
        {
            hourE_Show = "0" + hourE_Show
        }
        if minuteE! < 10
        {
            minuteE_Show = "0" + minuteE_Show
        }
    
        let fullHourE = "\(hourE_Show):\(minuteE_Show)"
      
        Global.sharedInstance.hourBthereEventEnd = fullHourE

        Global.sharedInstance.orderDetailsFoBthereEvent = item
        
        delegate.openDetailsOrder(2)//תפוס
    }
    //show views by flags
    func checkWhichValue()
    {
        viewTopInTop.isHidden = true
        viewButtomInTop.isHidden  = true
        viewMiddleInTop.isHidden  = true
        viewTopInButtom.isHidden  = true
        viewButtominButtom.isHidden  = true
        viewMiddleInButtom.isHidden  = true
        if IsToppTop
        {
            viewTopInTop.isHidden = false
            viewInTop = viewTopInTop
        }
        if IsMiddleeTop
        {
            viewMiddleInTop.isHidden = false
            
            viewInTop = viewMiddleInTop
        }
        
        if IsButtomTop
        {
            viewButtomInTop.isHidden = false
            
            viewInTop = viewButtomInTop
        }
        if IsToppButtom
        {
            viewTopInButtom.isHidden = false
            
            viewInButtom = viewTopInButtom
        }
        if IsMiddleeButtom
        {
            viewMiddleInButtom.isHidden = false
            
            viewInButtom = viewMiddleInButtom
        }
        
        if IsButtomButtom
        {
            viewButtominButtom.isHidden = false
            
            viewInButtom = viewButtominButtom
        }
        
        
    }
    
    

}
