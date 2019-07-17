//
//  EventsWeek12ViewsCollectionViewCell.swift
//  Bthere
//
//  Created by User on 4.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class EventsWeek12ViewsCollectionViewCell: UICollectionViewCell {
    //JMODE PLUS
    @IBOutlet weak var SERVICESTARTHOUR: UILabel!
    //MARK: - Outlet
    
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
   
    
        @IBOutlet weak var lblHoursTop: UILabel!
        @IBOutlet weak var lblDescTop: UILabel!
        @IBOutlet weak var lblHoursBottom: UILabel!
        @IBOutlet weak var lblDescBottom: UILabel!

        @IBOutlet weak var viewTopEvent: UIView!
        
        @IBOutlet weak var viewBottomEvent: UIView!
    

       //MARK: - Properties
    
        let calendar = Foundation.Calendar.current
    
        var DisplayDataDay:Bool = false
        var hasEvent:Bool = false
        var hourFree:String = ""
        var dateEvent:Date = Date()
        var hourStart:String = ""
        var hourEnd:String = ""
        var delegate:openDetailsOrderDelegate!=nil
        var heightViewTop: NSLayoutConstraint?
        var hightViewButtom: NSLayoutConstraint?
    
        var heightViewTopEvent: NSLayoutConstraint?
        var hightViewButtomEvent: NSLayoutConstraint?
    
        var arrBThereEventsCurrentDay:Array<OrderDetailsObj> = []
        var indexHourOfDay:Int = -1
    
        var delegateRegister:goToRegisterDelegate!=nil
    
        //MARK: - Initial
    
        override func awakeFromNib() {
            
            if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
                lblHours1.font = UIFont(name: lblHours1.font.fontName, size: 15)
                lblHours2.font = UIFont(name: lblHours2.font.fontName, size: 15)
                lblHours3.font = UIFont(name: lblHours3.font.fontName, size: 15)
                lblHours4.font = UIFont(name: lblHours4.font.fontName, size: 15)
                lblHours5.font = UIFont(name: lblHours5.font.fontName, size: 15)
                lblHours6.font = UIFont(name: lblHours6.font.fontName, size: 15)
                lblHours7.font = UIFont(name: lblHours7.font.fontName, size: 15)
                lblHours8.font = UIFont(name: lblHours8.font.fontName, size: 15)
                lblHours9.font = UIFont(name: lblHours9.font.fontName, size: 15)
                lblHours10.font = UIFont(name: lblHours10.font.fontName, size: 15)
                lblHours11.font = UIFont(name: lblHours11.font.fontName, size: 15)
                lblHours12.font = UIFont(name: lblHours12.font.fontName, size: 15)
            }
            
            
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

        func setDisplayDataDay(_ hourTop:String,descTop:String,hourBottom:String,descBottom:String)
        {
            DisplayDataDay = true
            if hourTop != ""
            {
            lblHoursTop.text = hourTop
            }
            if descTop != ""
            {
            lblDescTop.text = descTop
            }
            if hourBottom != ""
            {
            lblHoursBottom.text = hourBottom
            }
            if descBottom != ""
            {
              lblDescBottom.text = descBottom
            }
        }
    
        //לארועים של המכשיר
        //פונקציה זו מקבלת שלושה פרמטרים
        // whichView משתנה זה מסמל את איזה ויו צריך לצבוע באפור -
        //ועוד שתי משתנים של הגבהים של היו שמשתנים בהתאם לדקות
    func setDisplayViewsEvents(_ whichView:Bool,heightTop:CGFloat ,heightButtom:CGFloat,eventKind:Int)  {
        lblHoursTop.textColor =  .black
        lblDescTop.textColor =  .black
        lblHoursBottom.textColor =  .black
        lblDescBottom.textColor =  .black
        if eventKind == 0//ארוע אישי
        {
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            if deviceIdiom == .pad {
                lblHoursTop.font = UIFont (name: "OpenSansHebrew-Bold", size: 21)
                lblDescTop.font = UIFont (name: "OpenSansHebrew-Bold", size: 21)
                lblHoursBottom.font = UIFont (name: "OpenSansHebrew-Bold", size: 21)
                lblDescBottom.font = UIFont (name: "OpenSansHebrew-Bold", size: 21)
            } else {
            lblHoursTop.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
            lblDescTop.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
            lblHoursBottom.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
            lblDescBottom.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
            }
            lblHoursTop.textColor =  Colors.sharedInstance.greenforsyncedincalendar
            lblDescTop.textColor =  Colors.sharedInstance.greenforsyncedincalendar
            lblHoursBottom.textColor =  Colors.sharedInstance.greenforsyncedincalendar
            lblDescBottom.textColor =  Colors.sharedInstance.greenforsyncedincalendar
        }
        else if eventKind == 1//ארוע של ביזר
        {
            lblHoursTop.textColor =  .black
            lblDescTop.textColor =  .black
            lblHoursBottom.textColor =  .black
            lblDescBottom.textColor =  .black
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            if deviceIdiom == .pad {
                lblHoursTop.font = UIFont (name: "OpenSansHebrew-Bold", size: 21)
                lblDescTop.font = UIFont (name: "OpenSansHebrew-Bold", size: 21)
                lblHoursBottom.font = UIFont (name: "OpenSansHebrew-Bold", size: 21)
                lblDescBottom.font = UIFont (name: "OpenSansHebrew-Bold", size: 21)
            } else {
            lblHoursTop.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
            lblDescTop.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
            lblHoursBottom.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
            lblDescBottom.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
            }
    
        }
    }
    
    func showLblHours(_ tag:Int,hourS_Show:String,hourE_Show:String)
    {
        switch tag {
        case 0:
            lblHours1.backgroundColor = Colors.sharedInstance.color6
            //lblHours1.text = "\(hourS_Show)-\(hourE_Show)"
        case 5:
            lblHours2.backgroundColor = Colors.sharedInstance.color6
            //lblHours2.text = "\(hourS_Show)-\(hourE_Show)"
        case 10:
            lblHours3.backgroundColor = Colors.sharedInstance.color6
            //lblHours3.text = "\(hourS_Show)-\(hourE_Show)"
        case 15:
            lblHours4.backgroundColor = Colors.sharedInstance.color6
            //lblHours4.text = "\(hourS_Show)-\(hourE_Show)"
        case 20:
            lblHours5.backgroundColor = Colors.sharedInstance.color6
            //lblHours5.text = "\(hourS_Show)-\(hourE_Show)"
        case 25:
            lblHours6.backgroundColor = Colors.sharedInstance.color6
            //lblHours6.text = "\(hourS_Show)-\(hourE_Show)"
        case 30:
            lblHours7.backgroundColor = Colors.sharedInstance.color6
            //lblHours7.text = "\(hourS_Show)-\(hourE_Show)"
        case 35:
            lblHours8.backgroundColor = Colors.sharedInstance.color6
            //lblHours8.text = "\(hourS_Show)-\(hourE_Show)"
        case 40:
            lblHours9.backgroundColor = Colors.sharedInstance.color6
            //lblHours9.text = "\(hourS_Show)-\(hourE_Show)"
        case 45:
            lblHours10.backgroundColor = Colors.sharedInstance.color6
            //lblHours10.text = "\(hourS_Show)-\(hourE_Show)"
        case 50:
            lblHours11.backgroundColor = Colors.sharedInstance.color6
            //lblHours11.text = "\(hourS_Show)-\(hourE_Show)"
        case 55:
            lblHours12.backgroundColor = Colors.sharedInstance.color6
            //lblHours12.text = "\(hourS_Show)-\(hourE_Show)"

        default:
            lblHours1.backgroundColor = Colors.sharedInstance.color6
            //lblHours1.text = "\(hourS_Show)-\(hourE_Show)"
        }
        
    }
    //func  on touch //
    @objc func tapOrderTurn(_ sender:UITapGestureRecognizer)
    {
        Global.sharedInstance.whichDesignOpenDetailsAppointment = 1
        
        let view = sender.view
        let loc = sender.location(in: view)
        let subview = view?.hitTest(loc, with: nil)
        var strDate:String = ""
        if subview?.backgroundColor == Colors.sharedInstance.color4
        {
            switch subview!.tag
            {
            case 0:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForCurrentDay[lblHours1.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForCurrentDay[lblHours1.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForCurrentDay[lblHours1.tag].dtDate
                
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForCurrentDay[lblHours1.tag].iProviderUserId
                }
            case 5:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForCurrentDay[lblHours2.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForCurrentDay[lblHours2.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForCurrentDay[lblHours2.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForCurrentDay[lblHours2.tag].iProviderUserId
                }
            case 10:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForCurrentDay[lblHours3.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForCurrentDay[lblHours3.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForCurrentDay[lblHours3.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForCurrentDay[lblHours3.tag].iProviderUserId
                }
            case 15:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForCurrentDay[lblHours4.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForCurrentDay[lblHours4.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForCurrentDay[lblHours4.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForCurrentDay[lblHours4.tag].iProviderUserId
                }
            case 20:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForCurrentDay[lblHours5.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForCurrentDay[lblHours5.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForCurrentDay[lblHours5.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForCurrentDay[lblHours5.tag].iProviderUserId
                }
            case 25:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForCurrentDay[lblHours6.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForCurrentDay[lblHours6.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForCurrentDay[lblHours6.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForCurrentDay[lblHours6.tag].iProviderUserId
                }
            case 30:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForCurrentDay[lblHours7.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForCurrentDay[lblHours7.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForCurrentDay[lblHours7.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForCurrentDay[lblHours7.tag].iProviderUserId
                }
            case 35:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForCurrentDay[lblHours8.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForCurrentDay[lblHours8.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForCurrentDay[lblHours8.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForCurrentDay[lblHours8.tag].iProviderUserId
                }
            case 40:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForCurrentDay[lblHours9.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForCurrentDay[lblHours9.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForCurrentDay[lblHours9.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForCurrentDay[lblHours9.tag].iProviderUserId
                }
            case 45:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForCurrentDay[lblHours10.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForCurrentDay[lblHours10.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForCurrentDay[lblHours10.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForCurrentDay[lblHours10.tag].iProviderUserId
                }
            case 50:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForCurrentDay[lblHours11.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForCurrentDay[lblHours11.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForCurrentDay[lblHours11.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForCurrentDay[lblHours11.tag].iProviderUserId
                }
                
            case 55:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForCurrentDay[lblHours12.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForCurrentDay[lblHours12.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForCurrentDay[lblHours12.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForCurrentDay[lblHours12.tag].iProviderUserId
                }
            default:
                Global.sharedInstance.hourFreeEvent = Global.sharedInstance.freeHoursForCurrentDay[lblHours1.tag].objProviderHour.nvFromHour
                Global.sharedInstance.hourFreeEventEnd = Global.sharedInstance.freeHoursForCurrentDay[lblHours1.tag].objProviderHour.nvToHour
                strDate = Global.sharedInstance.freeHoursForCurrentDay[lblHours1.tag].dtDate
                if Global.sharedInstance.idWorker == -1//לא נבחר אף נותן שרות או נבחר לא משנה לי
                {
                    Global.sharedInstance.arrayGiveServicesKods = Global.sharedInstance.freeHoursForCurrentDay[lblHours1.tag].iProviderUserId
                }
            }
            
            let calendar = Foundation.Calendar.current
            
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
            for item in arrBThereEventsCurrentDay
            {
                dateFrom = Global.sharedInstance.getStringFromDateString(item.nvFromHour)
                let componentsFrom = (calendar as NSCalendar).components([.hour,.minute], from: dateFrom) //year month day
                let strFromHour = componentsFrom.hour
                let strFromMinute = componentsFrom.minute
                
                dateTo = Global.sharedInstance.getStringFromDateString(item.nvToHour)
                let componentsTo = (calendar as NSCalendar).components([.hour,.minute], from: dateTo) 
                let strToHour = componentsTo.hour
                let strToMinute = componentsTo.minute
                //בודק האם ה-view שעליו לחצו הוא תור של ביזר ואז בלחיצה יש להציג את פרטי התור
                if (indexHourOfDay > strFromHour! && indexHourOfDay < strToHour!) || (indexHourOfDay == strFromHour! && subview!.tag >= strFromMinute!) || (indexHourOfDay == strToHour! &&  subview!.tag <= strToMinute!)
                {
                    Global.sharedInstance.hourBthereEvent = item.nvFromHour
                    Global.sharedInstance.hourBthereEventEnd = item.nvToHour
                    Global.sharedInstance.dateEventBthereClick = item.dtDateOrder
                    
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
                    let fullHourS = "\(hourS_Show):\(minuteS_Show)"
                    let fullHourE = "\(hourE_Show):\(minuteE_Show)"
                    Global.sharedInstance.hourBthereEvent = fullHourS
                    Global.sharedInstance.hourBthereEventEnd = fullHourE
                    Global.sharedInstance.orderDetailsFoBthereEvent = item
                    
                    delegate.openDetailsOrder(2)//תפוס
                    
                }
            }
        }
    }
}
