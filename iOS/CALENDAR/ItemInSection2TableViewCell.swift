import UIKit
protocol ReloadTableDelegate{
    func ReloadTable(_ tblHoursActive:UITableView,tblHoursRest:UITableView)
}
protocol reloadTableForSaveDelegate{
    func reloadTableForSave(_ tag:Int,btnTag:Int)
}
protocol setDatePickerRestDelegate
{
    func setDatePickerRest(_ index:Int)
    func setDatePickerHoursBySelected(_ index:Int)
    func setDatePickerHoursRestBySelected(_ index:Int)
}
protocol validSection1Delegate{
    
    func validSection1()
}

class ItemInSection2TableViewCell: UITableViewCell ,UITableViewDelegate,UITableViewDataSource,setDatePickerRestDelegate
{
    
    var delegate:reloadTableForSaveDelegate! = nil
    var saveData:saveDataDelegate!=nil
    //var isOwner:Bool = false
    var isOpen:Bool = false
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var viewButtom: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBAction func btnSave(_ sender: UIButton)
    {
        Global.sharedInstance.fromEdit = false
        Global.sharedInstance.fIsRestBefore = false
        Global.sharedInstance.fIsSaveConHoursPressed = true
        
        //שמירת הנתונים בגלובל שיהיו מוכנים לשליחה לשרת
        
        var workingHours:objWorkingHours = objWorkingHours()
        
        if Global.sharedInstance.isOwner == true
        {
          
            //עובר על השעות של כל הימים בשבוע של הספק
            for i in 0 ..< Global.sharedInstance.arrWorkHours.count {
                //יש הפסקות
                if Global.sharedInstance.arrIsRestChecked[i]
                {
                    checkValidityHours(i,isRest: 0)
                    
                    workingHours = objWorkingHours(
                        _iDayInWeekType: Global.sharedInstance.arrWorkHours[i].iDayInWeekType,
                        _nvFromHour: Global.sharedInstance.arrWorkHours[i].nvFromHour,
                        _nvToHour: Global.sharedInstance.arrWorkHoursRest[i].nvFromHour)
                    
                    Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHours)
                    //---------------------------
                    workingHours = objWorkingHours(
                        _iDayInWeekType: Global.sharedInstance.arrWorkHours[i].iDayInWeekType,
                        _nvFromHour: Global.sharedInstance.arrWorkHoursRest[i].nvToHour,
                        _nvToHour: Global.sharedInstance.arrWorkHours[i].nvToHour)
                    
                    Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHours)
                    
                    //   Global.sharedInstance.arrIsRestChecked[i] = false //איפוס המשתנה
                }
                else //אין הפסקות
                {
                    checkValidityHours(i,isRest: 1)
                    if  Global.sharedInstance.fIsValidHours[i] == true
                    {
                        workingHours = objWorkingHours(_iDayInWeekType: Global.sharedInstance.arrWorkHours[i].iDayInWeekType,
                                                       _nvFromHour: Global.sharedInstance.arrWorkHours[i].nvFromHour,
                                                       _nvToHour: Global.sharedInstance.arrWorkHours[i].nvToHour)
                        
                        if workingHours.iDayInWeekType != 0 && workingHours.nvFromHour != "" && workingHours.nvToHour != "" {
                            
                            Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHours)
                        }
                    }
                }
            }
            //עובר על כל השעות ובודק האם יש יום שהשעות לא חוקיות
            var isBreak = false
            for bool in Global.sharedInstance.fIsValidHours
            {
                if bool == false
                {
                    Global.sharedInstance.isValidHours = false
                    isBreak = true
                    break
                }
            }
            if Global.sharedInstance.isValidHours == false
                && isBreak == true
            {
                Global.sharedInstance.headersCellRequired[1] = false//ע״מ לדעת האם להציג את הכוכבית של השדות חובה
            }
            else
            {
                Global.sharedInstance.isValidHours = true
                Global.sharedInstance.headersCellRequired[1] = true
            }
        }
        else
        {
            self.saveData = Global.sharedInstance.itemInSection3TableViewCell
            //שמירת נתוני העובד
            if saveData.saveData() == true
            {
                
                //עובר על השעות של כל הימים בשבוע של העובד
                for i in 0 ..< Global.sharedInstance.arrWorkHoursChild.count {
                    
                    //יש הפסקות
                    if Global.sharedInstance.arrIsRestCheckedChild[i]
                    {
                        //checkValidityHours()
                        
                        workingHours = objWorkingHours(
                            _iDayInWeekType: Global.sharedInstance.arrWorkHours[i].iDayInWeekType,
                            _nvFromHour: Global.sharedInstance.arrWorkHours[i].nvFromHour,
                            _nvToHour: Global.sharedInstance.arrWorkHoursRest[i].nvFromHour)
                        
                        Global.sharedInstance.serviceProvider.arrObjWorkingHours.append(workingHours)
                        
                        //---------------------------
                        workingHours = objWorkingHours(_iDayInWeekType: Global.sharedInstance.arrWorkHours[i].iDayInWeekType,
                                                       _nvFromHour: Global.sharedInstance.arrWorkHoursRest[i].nvToHour,
                                                       _nvToHour: Global.sharedInstance.arrWorkHours[i].nvToHour)
                        
                        Global.sharedInstance.serviceProvider.arrObjWorkingHours.append(workingHours)
                        
                        Global.sharedInstance.arrIsRestCheckedChild[i] = false //איפוס המשתנה
                    }
                    else //אין הפסקות
                    {
                        workingHours = objWorkingHours(_iDayInWeekType: Global.sharedInstance.arrWorkHours[i].iDayInWeekType,
                                                       _nvFromHour: Global.sharedInstance.arrWorkHours[i].nvFromHour,
                                                       _nvToHour: Global.sharedInstance.arrWorkHours[i].nvToHour)
                        if workingHours.iDayInWeekType != 0 && workingHours.nvFromHour != "" && workingHours.nvToHour != "" {
                            Global.sharedInstance.serviceProvider.arrObjWorkingHours.append(workingHours)
                        }
                    }
                }
                
            }
            else{
                return
            }
        }
        delegate.reloadTableForSave(self.tag,btnTag: btnSave.tag)
        //איפוס המשתנה כדי שיהיה מוכן להוספת עובד נוסף מחדש
        Global.sharedInstance.serviceProvider = objServiceProviders()
    }
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var viewSave: UIView!
    @IBOutlet var viewDp: UIView!
    @IBOutlet var toHour: UIDatePicker!
    @IBOutlet var fromHour: UIDatePicker!
    
    @IBOutlet var viewColorRest: UIView!
    @IBOutlet var viewRest: UIView!
    @IBOutlet var fromHourRest: UIDatePicker!
    @IBOutlet var toHourRest: UIDatePicker!
    
    @IBOutlet weak var vTop: UIView!
    
    //@IBOutlet weak var viewTopCell: UIView!
    
    @IBOutlet weak var vieTop: UIView!
    @IBOutlet var lblRest: UILabel!
    var subMenuTable:UITableView?
    var delegat:ReloadTableDelegate! = nil
    var days:Array<String> = ["יום א׳","יום ב׳","יום ג׳","יום ד׳","יום ה׳","יום ו׳"]
    
    @IBOutlet var tblHours: UITableView!
    @IBOutlet var tblDays: UITableView!
    
    //MARK: - Initial
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if DeviceType.IS_IPHONE_5{
            btnSave.titleLabel?.font = Colors.sharedInstance.fontText3
        }
        //איפוס הflags של הבדיקות תקינות
        
        Global.sharedInstance.isValidHours = true
        Global.sharedInstance.fIsEmptyOwnerHours = true
        
        Global.sharedInstance.fIsSaveConHoursPressed = false
        
        Global.sharedInstance.GlobalDataVC?.delegateDP = self
        
        Global.sharedInstance.itemInSection2TableViewCell?.saveData = Global.sharedInstance.itemInSection3TableViewCell
        
        toHour.addTarget(self, action: #selector(ItemInSection2TableViewCell.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        fromHour.addTarget(self, action: #selector(ItemInSection2TableViewCell.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
        fromHourRest.addTarget(self, action: #selector(ItemInSection2TableViewCell.handleDatePickerRest(_:)), for: UIControl.Event.valueChanged)
        toHourRest.addTarget(self, action: #selector(ItemInSection2TableViewCell.handleDatePickerRest(_:)), for: UIControl.Event.valueChanged)
        
        tblDays.separatorStyle = .none
        tblHours.separatorStyle = .none
        
        //setMaxMinDateRest()
        dateFormatter.dateFormat = "HH:mm:00"
        fromHour.date = dateFormatter.date(from: "00:00:00")!
        toHour.date = dateFormatter.date(from: "00:00:00")!

        fromHourRest.date = dateFormatter.date(from: "00:00:00")!
        toHourRest.date = dateFormatter.date(from: "00:00:00")!
        
        fromHourRest.setDate(fromHourRest.date, animated: false)
        toHourRest.setDate(toHourRest.date, animated: false)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        fromHour.backgroundColor = Colors.sharedInstance.color1
        fromHour.setValue(UIColor.white, forKeyPath: "textColor")
        //fromHour.setValue(0.8, forKeyPath: "alpha")
        toHour.backgroundColor = Colors.sharedInstance.color1
        toHour.setValue(UIColor.white, forKeyPath: "textColor")
        //        toHour.setValue(UIFont(name: "OpenSansHebrew-Light", size: 15), forKeyPath: "font")
        fromHourRest.backgroundColor = Colors.sharedInstance.color1
        fromHourRest.setValue(UIColor.white, forKeyPath: "textColor")
        //dp.setValue(UIFontWeightLight, forKeyPath: "font")
        //fromHour.setValue(0.8, forKeyPath: "alpha")
        toHourRest.backgroundColor = Colors.sharedInstance.color1
        toHourRest.setValue(UIColor.white, forKeyPath: "textColor")
        
        //fromHour.layer.borderColor = UIColor.whiteColor().CGColor
        //fromHour.layer.borderWidth = 1
        //toHour.layer.borderColor = UIColor.whiteColor().CGColor
        //toHour.layer.borderWidth = 1
        //addTopBottomBorder(viewDp, color: UIColor.whiteColor())
        //fromHourRest.layer.borderColor = UIColor.whiteColor().CGColor
        //fromHourRest.layer.borderWidth = 1
        //toHourRest.layer.borderColor = UIColor.whiteColor().CGColor
        // toHourRest.layer.borderWidth = 1
        //addTopBottomBorder(viewRest, color: UIColor.whiteColor())
        //addBottomBorder(viewSave, color: UIColor.blackColor())
        //        if AppDelegate.isOpenHoursWhichCell == false{
        //            viewColorRest.backgroundColor = UIColor.clearColor()
        //            lblRest.textColor = Colors.sharedInstance.color1
        //
        //        }
        //        else{
        //            viewColorRest.backgroundColor = UIColor.blackColor()
        //            lblRest.textColor = UIColor.whiteColor()
        //      viewTop.backgroundColor = UIColor.whiteColor()
        //            viewButtom.backgroundColor = UIColor.whiteColor()
        //AppDelegate.isOpenHoursWhichCell = false
        
        
        // AppDelegate.isOpenHoursWhichCell = false
        
        // }
        //toHour.setValue(Colors.sharedInstance.color4, forKeyPath: "textColor")
        
        //        Colors.sharedInstance.addBottomBorderWithColor(Colors.sharedInstance.color1, width: 1, any: viewSave)
        self.reloadInputViews()
        
        //let index:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        //tblDays.selectRowAtIndexPath(index, animated: true, scrollPosition: .Middle)
        //        tblDays.cellForRowAtIndexPath(index) as! DayInWeekTableViewCell).contentView.backgroundColor = Colors.sharedInstance.color4
    }
    
    func setDisplayData(){
        
        delegat.ReloadTable(tblDays,tblHoursRest: tblHours)
    }
    
    //MARK: - DatePicker
    ///בלחיצה על ה datePicker של השעות פעילות
    @objc func handleDatePicker(_ sender: UIDatePicker)
    {
       // let language = NSBundle.mainBundle().preferredLocalizations.first! as NSString
        
        Global.sharedInstance.fIsEmptyOwnerHours = false
        
        Global.sharedInstance.flagIfValidSection1 = true
        
        let outputFormatter: DateFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm:00"
        
        if Global.sharedInstance.isOwner == true
        {
            Global.sharedInstance.workingHours = objWorkingHours()
            
       //     if language == "he"
                if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
            {
                Global.sharedInstance.workingHours.nvFromHour = outputFormatter.string(from: fromHour.date)
                
                Global.sharedInstance.workingHours.nvToHour = outputFormatter.string(from: toHour.date)
            }
            else
            {
                Global.sharedInstance.workingHours.nvFromHour = outputFormatter.string(from: toHour.date)
                
                Global.sharedInstance.workingHours.nvToHour = outputFormatter.string(from: fromHour.date)
            }
            
//            if Global.sharedInstance.currentIndexPath == -1{
//                Global.sharedInstance.currentIndexPath = 0
//            }
            
//            Global.sharedInstance.workingHours.iDayInWeekType = Global.sharedInstance.currentIndexPath + 1
            
            ///שמירת שעה ליום מסויים ,השמירה דווקא כך ולא ע״י append כדי שיוכל לשנות את השעה וזה יתעדכן
//            Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentIndexPath] = Global.sharedInstance.workingHours
            //setMaxMinDateRest()
        }
        else
        {
            Global.sharedInstance.workingHoursChild = objWorkingHours()
            
        //    if language == "he"
                if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
            {
                Global.sharedInstance.workingHoursChild.nvFromHour = outputFormatter.string(from: fromHour.date)
                
                Global.sharedInstance.workingHoursChild.nvToHour = outputFormatter.string(from: toHour.date)
            }
            else
            {
                Global.sharedInstance.workingHoursChild.nvFromHour = outputFormatter.string(from: toHour.date)
                
                Global.sharedInstance.workingHoursChild.nvToHour = outputFormatter.string(from: fromHour.date)
            }
            
//            if Global.sharedInstance.currentIndexPathChild == -1{
//                Global.sharedInstance.currentIndexPathChild = 0
//            }
//            
//            Global.sharedInstance.workingHoursChild.iDayInWeekType = Global.sharedInstance.currentIndexPathChild + 1
//            
//            ///השמירה דווקא כך ולא ע״י append כדי שיוכל לשנות את השעה ליום מסויים וזה יתעדכן
//            Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentIndexPathChild] = Global.sharedInstance.workingHoursChild
            
            //setMaxMinDateRest()
        }
    }
    
    ///בלחיצה על ה datePicker של ההפסקות
    @objc func handleDatePickerRest(_ sender: UIDatePicker)
    {
//        if Global.sharedInstance.currentIndexPathRest == -1
//        {
//            Global.sharedInstance.currentIndexPathRest = 0
//        }
       // setDatePickerRest(Global.sharedInstance.currentIndexPathRest)
        
        let outputFormatter: DateFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm:00"
        
        if Global.sharedInstance.isOwner == true
        {
            Global.sharedInstance.workingHoursRest = objWorkingHours()
            
            Global.sharedInstance.workingHoursRest.nvFromHour = outputFormatter.string(from: fromHourRest.date)
            
            Global.sharedInstance.workingHoursRest.nvToHour = outputFormatter.string(from: toHourRest.date)
            
//            if Global.sharedInstance.currentIndexPathRest == -1
//            {
//                Global.sharedInstance.currentIndexPathRest = 0
//                setMaxMinDateRest()//בגלל שזה הפעם הראשונה ואין לו didSelect
//            }
            
//            Global.sharedInstance.workingHoursRest.iDayInWeekType = Global.sharedInstance.currentIndexPathRest + 1
            
            ///השמירה דווקא כך ולא ע״י append כדי שיוכל לשנות את השעה ליום מסויים וזה יתעדכן
//            Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentIndexPathRest] = Global.sharedInstance.workingHoursRest
            ///עדכון שיש הפסקה ביום הזה
//            Global.sharedInstance.arrIsRestChecked[Global.sharedInstance.currentIndexPathRest] = true
            
//            if Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentIndexPathRest].iDayInWeekType == 0 || Global.sharedInstance.fIsRestBefore == true
//            {
//                
//                Global.sharedInstance.fIsRestBefore = true
//
//                Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentIndexPathRest].iDayInWeekType = Global.sharedInstance.workingHoursRest.iDayInWeekType
//                
//                Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentIndexPathRest].nvFromHour =  outputFormatter.stringFromDate( NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: -5, toDate: fromHourRest.date
//                    , options: [])!)
//
//                
//                Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentIndexPathRest].nvToHour = outputFormatter.stringFromDate( NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: 5, toDate: toHourRest.date, options: [])!)
//                
//                Global.sharedInstance.fIsEmptyOwnerHours = false
//                
//            }
            
            
        }
        else
        {
            Global.sharedInstance.workingHoursRestChild.nvFromHour = outputFormatter.string(from: fromHourRest.date)
            
            Global.sharedInstance.workingHoursRestChild.nvToHour = outputFormatter.string(from: toHourRest.date)
            
//            if Global.sharedInstance.currentIndexPathRestChild == -1{
//                Global.sharedInstance.currentIndexPathRestChild = 0
//            }
//            
//            Global.sharedInstance.workingHoursRestChild.iDayInWeekType = Global.sharedInstance.currentIndexPathRestChild + 1
//            
//            ///השמירה דווקא כך ולא ע״י append כדי שיוכל לשנות את השעה ליום מסויים וזה יתעדכן
//            Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentIndexPathRestChild] = Global.sharedInstance.workingHoursRestChild
//            ///עדכון שיש הפסקה ביום הזה
//            Global.sharedInstance.arrIsRestCheckedChild[Global.sharedInstance.currentIndexPathRestChild] = true
        }
    }
    
    //isRest=0 יש הפסקות,isRest
    func checkValidityHours(_ index:Int,isRest:Int)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:00"
        
        if Global.sharedInstance.arrWorkHours[index].iDayInWeekType != 0
        {
            
            let hhFromHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvFromHour)!
            
            let hhToHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvToHour)!
            
            
            //hours and minutes from hour - working
            var hhFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourDate))
            let mmFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourDate))
            
            //hours and minutes to hour - working
            var hhToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourDate))
            let mmToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourDate))
            
            
            if isRest == 0 //יש הפסקות
            {
                let hhFromHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index].nvFromHour)!
                
                //hours and minutes from hour - rest
                var hhFromHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourRestDate))
                let mmFromHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourRestDate))
                
                
                let hhToHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index].nvToHour)!
                
                //hours and minutes to hour - rest
                var hhToHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourRestDate))
                let mmToHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourRestDate))
                
                if mmFromHour != 0//== 30
                {
                    hhFromHour = hhFromHour + mmFromHour / 60 //+ 0.5
                }
                
                if mmToHour != 0//== 30
                {
                    hhToHour = hhToHour + mmToHour / 60//0.5
                }
                
                if mmFromHourRest != 0 //== 30
                {
                    hhFromHourRest = hhFromHourRest + mmFromHourRest / 60//0.5
                }
                
                if mmToHourRest != 0 //== 30
                {
                    hhToHourRest = hhToHourRest + mmToHourRest/60//0.5
                }
                
                if hhFromHour > hhToHour || hhFromHourRest > hhToHourRest || hhFromHour > hhFromHourRest || hhToHour < hhToHourRest
                {
                    Global.sharedInstance.fIsValidHours[index] = false
                }
                else
                {
                    Global.sharedInstance.fIsValidHours[index] = true
                }
            }
                
            else
            {
                if mmFromHour != 0//== 30
                {
                    hhFromHour = hhFromHour + mmFromHour / 60 //+ 0.5
                }
                if mmToHour != 0//== 30
                {
                    hhToHour = hhToHour + mmToHour / 60//0.5
                }
                
                if hhFromHour > hhToHour
                {
                    Global.sharedInstance.fIsValidHours[index] = false
                }
                else
                {
                    Global.sharedInstance.fIsValidHours[index] = true
                }
            }
        }
        //            //נבחרו הפסקות, ללא שעות עבודה
        //        else  if Global.sharedInstance.arrIsRestChecked[index] == true
        //        {
        //
        //
        //        }
    }
    
    func setMaxMinDateRest()
    {
        fromHourRest.minimumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .minute, value: 5, to: fromHour.date, options: [])!
        
        fromHourRest.maximumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .minute, value: -10, to: toHour.date, options: [])!
        
        toHourRest.minimumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .minute, value: 10, to: fromHour.date, options: [])!
        
        toHourRest.maximumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .minute, value: -10, to: toHour.date, options: [])!
    }
    
    func setDatePickerRest(_ index:Int)
    {
        var flag = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:00"
        
        var toHourD:Date?
        var fromHourD:Date?
        
        for item in Global.sharedInstance.arrWorkHours
        {
            if item.iDayInWeekType == index + 1
            {
                fromHourD = dateFormatter.date(from: item.nvFromHour)
                toHourD = dateFormatter.date(from: item.nvToHour)
                
                fromHourRest.minimumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .minute, value: 5, to: fromHourD!, options: [])!
                
                fromHourRest.maximumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .minute, value: -10, to: toHourD!, options: [])!
                
                toHourRest.minimumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .minute, value: 10, to: fromHourD!, options: [])!
                
                toHourRest.maximumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .minute, value: -5, to: toHourD!
                    , options: [])!
                if Global.sharedInstance.arrIsRestChecked[index] == false
                {
                let hhFromHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: fromHourD!))
                //let mmFromHourRest:Float = Float(NSCalendar.currentCalendar().component(.Minute, fromDate: fromHourD!))
                
                let hhToHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: toHourD!))
                //let mmToHourRest:Float = Float(NSCalendar.currentCalendar().component(.Minute, fromDate: toHourD!))
                
                let from = hhFromHourRest
                let to = hhToHourRest
                let currentRest:Int = Int((from + to) / 2)
                let nvCurrentRest = currentRest.description + ":00:00"
                fromHourRest.date = dateFormatter.date(from: nvCurrentRest)!
                toHourRest.date = dateFormatter.date(from: nvCurrentRest)!
                }
                flag = true
            }
        }
        if !flag
        {


            //פקודות אלו מאפשרות לו לגלול את השעות ללא הגבלה של מקסימום ומינימום שנבחרו ליום אחר
           
            fromHourRest.maximumDate = .none
            fromHourRest.minimumDate = .none
            toHourRest.maximumDate = .none
            toHourRest.minimumDate = .none
            

            fromHourRest.date = dateFormatter.date(from: "00:00:00")!
            toHourRest.date = dateFormatter.date(from: "00:00:00")!
            fromHourRest.setDate(fromHourRest.date, animated: false)
            toHourRest.setDate(toHourRest.date, animated: false)

        }
    }
    
    
    //מאתחל את השעות ליום מסויים לפי מה שהמשתמש בחר
    func setDatePickerHoursBySelected(_ index:Int)
    {
        var flag = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:00"
        
        var toHourD:Date?
        var fromHourD:Date?
        
        if Global.sharedInstance.isOwner == true
        {
            for item in Global.sharedInstance.arrWorkHours
            {
                if item.iDayInWeekType == index + 1
                {
                    fromHourD = dateFormatter.date(from: item.nvFromHour)
                    toHourD = dateFormatter.date(from: item.nvToHour)
                    
                    fromHour.date = fromHourD!
                    toHour.date = toHourD!
                    
                    flag = true
                }
            }
            
            if !flag
            {
                fromHour.date = dateFormatter.date(from: "00:00:00")!
                toHour.date = dateFormatter.date(from: "00:00:00")!
            }
        }
        else
        {
            for item in Global.sharedInstance.arrWorkHoursChild
            {
                if item.iDayInWeekType == index + 1
                {
                    fromHourD = dateFormatter.date(from: item.nvFromHour)
                    toHourD = dateFormatter.date(from: item.nvToHour)
                    
                    fromHour.date = fromHourD!
                    toHour.date = toHourD!
                    
                    flag = true
                }
            }
            
            if !flag
            {
                fromHour.date = dateFormatter.date(from: "00:00:00")!
                toHour.date = dateFormatter.date(from: "00:00:00")!
            }
        }
    }
    
    //מאתחל את ההפסקות ליום מסויים לפי מה שהמשתמש בחר
    func setDatePickerHoursRestBySelected(_ index:Int)
    {
        var flag = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:00"
        
        var toHourD:Date?
        var fromHourD:Date?
        
        for item in Global.sharedInstance.arrWorkHoursRest
        {
            if item.iDayInWeekType == index + 1
            {
                fromHourD = dateFormatter.date(from: item.nvFromHour)
                toHourD = dateFormatter.date(from: item.nvToHour)
                
                fromHourRest.date = fromHourD!
                toHourRest.date = toHourD!
                
                flag = true
            }
        }
        if !flag
        {
            fromHourRest.date = dateFormatter.date(from: "00:00:00")!
            toHourRest.date = dateFormatter.date(from: "00:00:00")!
            fromHourRest.setDate(fromHourRest.date, animated: false)
            toHourRest.setDate(toHourRest.date, animated: false)
        }
    }
    
    //MARK: - Border Frame
    
    func addTopBottomBorder(_ any:UIView,color:UIColor)
    {
        let borderTop = CALayer()
        let borderBottom = CALayer()
        
        borderTop.frame = CGRect(x: 0, y: 0, width: any.layer.frame.width + (any.layer.frame.width / 3), height: 1)
        
        borderBottom.frame = CGRect(x: 0, y: any.layer.frame.height + 98 , width: any.layer.frame.width + (any.layer.frame.width / 3) , height: 1)
        
        borderTop.backgroundColor = color.cgColor;
        borderBottom.backgroundColor = color.cgColor;
        
        any.layer.addSublayer(borderTop)
        any.layer.addSublayer(borderBottom)
    }
    
    func addBottomBorder(_ any:UIView,color:UIColor)
    {
        
        let borderBottom = CALayer()
        borderBottom.frame = CGRect(x: 0, y: any.layer.frame.height + 18, width: any.layer.frame.width + (any.layer.frame.width / 3) , height: 1)
        
        borderBottom.backgroundColor = color.cgColor;
        
        any.layer.addSublayer(borderBottom)
    }
    
    
    //    func addBorderBottom(size size: CGFloat, color: UIColor) {
    //        addBorderUtility(x: 0, y:viewSave.frame.height - size, width: viewSave.frame.width, height: size, color: color)
    //    }
    
    fileprivate func addBorderUtility(_ x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        viewSave.layer.addSublayer(border)
    }
    
    func addBorderLeft(_ size: CGFloat, color: UIColor) {
        addBorderUtility( 0, y: 0, width: size, height: viewDp.frame.height, color: color)
    }
    func addBorderRight(_ size: CGFloat, color: UIColor) {
        addBorderUtility(viewDp.frame.width - size, y: 0, width: size, height: viewDp.frame.height, color: color)
    }
    
    func addRightBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: viewDp.frame.size.width - width, y: 0, width: width, height: viewDp.frame.size.height)
        viewDp.layer.addSublayer(border)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpTable()
    {
        subMenuTable = UITableView(frame: CGRect.zero, style:UITableView.Style.plain)
        subMenuTable?.delegate = self
        subMenuTable?.dataSource = self
        self.addSubview(subMenuTable!)
    }
    
    //MARK: -table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // var cell: DayInWeekTableViewCell = (tableView.dequeueReusableCellWithIdentifier("DayInWeekTableViewCell") as? DayInWeekTableViewCell)!
        
        // cell.setDisplayData(days[indexPath.row])
        //return cell
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "DayInWeekTableViewCell")! as  UITableViewCell
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellID")
        }
        cell!.textLabel!.text = days[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblDays{
            return toHour.layer.frame.height / 7
        }
        return toHourRest.layer.frame.height / 7
    }
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        if tableView == tblHours
    //        {
    //            let dateFormatter = NSDateFormatter()
    //            dateFormatter.dateFormat = "dd/MM/yyyy"
    //
    //            var toHourD:NSDate?
    //            var fromHourD:NSDate?
    //
    //
    //            for item in Global.sharedInstance.arrWorkHours
    //            {
    //            if item.iDayInWeekType == indexPath.row + 1
    //            {
    //               fromHourD = dateFormatter.dateFromString(item.nvFromHour)
    //               toHourD = dateFormatter.dateFromString(item.nvToHour)
    //
    //
    //                fromHourRest.minimumDate = NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: 30, toDate: fromHourD!, options: [])!
    //
    //                fromHourRest.maximumDate = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: -1, toDate: toHourD!, options: [])!
    //
    //                toHourRest.minimumDate = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: 1, toDate: fromHourD!, options: [])!
    //
    //                toHourRest.maximumDate = NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: -30, toDate: toHourD!
    //                    , options: [])!
    //
    //                }
    //            }
    //
    //        }
    //    }
    
}
