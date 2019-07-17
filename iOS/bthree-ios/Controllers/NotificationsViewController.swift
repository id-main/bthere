//
//  NotificationsViewController.swift
//  bthere.git
//
//  Created by User on 9.2.2016.
//
//

import UIKit

protocol reloadTableInCellDelegate{
    func openTable(_ btn:UIButton,cell:UITableViewCell)
    func closeTbl()
    func scrollExternalTbl()
    func reloadTblIn()
}

protocol closeInTableDelegate {
    func closeInTable()
}
//דף 3 בהרשמת ספק - דף התראות
class NotificationsViewController: NavigationModelViewController,UITableViewDelegate,UITableViewDataSource,reloadTableInCellDelegate, openInCellDelegate,closeInTableDelegate{
    var INITIALSETTINGS:NSDictionary = NSDictionary()
    //MARK: - Outlet
    @IBOutlet weak var btnSaveNotifs: UIButton!
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    @IBOutlet weak var layoutTblButtom: NSLayoutConstraint!
    @IBOutlet weak var TOPOFTBL: NSLayoutConstraint!
    @IBOutlet weak var inCellTbl: UITableView!
    var view8doi : loadingBthere!
    @IBOutlet weak var externalTbl: UITableView!
    @IBOutlet weak var conTopInCellTbl: NSLayoutConstraint!
    @IBOutlet weak var mainview: UIView!
    //MARK: - Properties
    var generic = Generic()
    var textOnItemSelectedForCase0 = ""
    // variable to save the last position visited, initially setted to zero
    var lastContentOffset: CGFloat = 0
    var inTblOpen = false
    var pushClicked:Bool = false
    var miniute90:Bool = false
    var flag = false
    var yOfInTblBase:CGFloat?
    var yAfterScrolled:CGFloat = 0.0
    var isScrolld = false
    var numScrolled = 0//
    var didSelect = false
    var case0OpenedInTbl = false
    var cellinTblIsOpen = false
    var openOrCloseTblDel:openOrCloseTblDelegate!=nil
    
    //גובה הסלים
    var cellHeight = 61
    var selectedItemHeight = 36
    
    var externalTblHeight:CGFloat = 0
    
    var numberOfRowInTable:Int = 0
    let notificationsRowsInSection:Dictionary<Int,Int> = [0:2,1:0,2:3,3:3,4:2]
    
    var headersCell:Array<String> =
        ["MEETING_UPDATES".localized(LanguageMain.sharedInstance.USERLANGUAGE),"TEN_MINUTES_BEFORE_MEETING".localized(LanguageMain.sharedInstance.USERLANGUAGE),"FOLLW_CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"CUSTOMERS_EVENTS".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var headersForTblInCell:Array<String> = []//מכיל את הנתונים להצגה בשביל הטבלה הפנימית שנפתחת
    var selectedCell:Array<Bool> = [false,false,false,false,false,false]
    var selectedSection:Int = 0
    var selectedRow:Int = 0
    
    var arrayDicForHeaders:Dictionary<Int,Array<String>> =
        [0:["","KIND_NOTIFICATION".localized(LanguageMain.sharedInstance.USERLANGUAGE)],2:["","KIND_NOTIFICATION".localized(LanguageMain.sharedInstance.USERLANGUAGE),"FREQUNCY".localized(LanguageMain.sharedInstance.USERLANGUAGE)],3:["","KIND_UPDATE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"FREQUNCY".localized(LanguageMain.sharedInstance.USERLANGUAGE)],4:["","TIME_BEFORE_EVENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)]]
    //jmode plus
    @IBOutlet weak var titleofScreen: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBAction func btnClose(_ sender: AnyObject) {
        let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
        frontviewcontroller!.pushViewController(viewcon, animated: false)
        //initialize REAR View Controller- it is the LEFT hand menu.
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
        
    }
    @IBAction func btnSaveNotifs(_ sender: AnyObject) {
        print("whatosave \(Global.sharedInstance.addProviderAlertSettings.getDic())")
        self.UpdateProviderAlertSettings()
    }
    
    //MARK: - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetProviderAlertSettings()
        //  self.view.backgroundColor = UIColor(patternImage: UIImage(named: "client.jpg")!)
        self.view.addBackground()
        self.titleofScreen.text = "NOTIFICATIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        let leftarrowback = UIImage(named: "sageata2.png")
        
        self.btnClose.setImage(leftarrowback, for: UIControl.State())
        
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.btnClose.transform = scalingTransform
        }
        self.btnClose.imageView!.contentMode = .scaleAspectFit
        
        self.TOPOFTBL.constant = -40
        
        
        externalTblHeight = externalTbl.contentSize.height
        self.btnSaveNotifs.setTitle("SAVE_BTN".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        // UpdateProviderAlertSettings()
        
        
        //\\JMODE NOT NEED      Global.sharedInstance.rgisterModelViewController!.delgateNotif = self
        
        inCellTbl.isScrollEnabled = false
        
        if  DeviceType.IS_IPHONE_6P {
            Global.sharedInstance.heightForNotificationCell = 60
        }
        else{
            if    DeviceType.IS_IPHONE_6 {
                Global.sharedInstance.heightForNotificationCell = 54.5
            }
            else{
                if DeviceType.IS_IPHONE_5{
                    
                    Global.sharedInstance.heightForNotificationCell = 46
                    
                }
                else{
                    Global.sharedInstance.heightForNotificationCell = 39.1
                }
            }
        }
        view.bringSubviewToFront(inCellTbl)
        inCellTbl.isHidden = true
        
        externalTbl.separatorStyle = .none
        inCellTbl.separatorStyle = .none
    }
    func reloadfirst() {
        Global.sharedInstance.arrNotificationsV = [true,true,true,true,true]
        Global.sharedInstance.arrNotificationsX = [false,false,false,false,false]
        /*
         Result =     {
         b10minutesBeforeService = 0;
         iCustomerEventsFreqId = 0;
         iCustomerEventsId = "<null>";
         iCustomerResvFreqId = 0;
         iCustomerResvId = "<null>";
         iIncomingAlertsId =         (
         30
         );
         iProviderId = 32;
         };
         */
        print(" Global.sharedInstance.addProviderAlertSettings.b10minutesBeforeService \( Global.sharedInstance.addProviderAlertSettings.b10minutesBeforeService)")
        //JMODE first row -> no appoimnet allert is setup up
        
        for _ in Global.sharedInstance.dicSysAlerts["8"]!
        {
            Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId.append(-1)//אתחול המערך לפי ה-count של תוכן הטבלה
        }
        
        for _ in Global.sharedInstance.dicSysAlerts["9"]! {
            Global.sharedInstance.addProviderAlertSettings.iCustomerResvId.append(-1)//אתחול המערך לפי ה-count של תוכן הטבלה
        }
        
        var i = 0
        for _ in Global.sharedInstance.dicSysAlerts["10"]!
        {
            Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId.append(-1)//אתחול המערך לפי ה-count של תוכן הטבלה
            
            i += 1
        }
        
        //---------------------אתחול דיפולטיבי לשליחה לשרת למקרה שלא לוחצים על שום דבר לבחירה
        Global.sharedInstance.addProviderAlertSettings.iProviderId = Global.sharedInstance.currentUser.iUserId
        
        Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[0] = SysTableRowId(8, str:  Global.sharedInstance.arrayDicForTableViewInCell[0]![1][0])
        
        Global.sharedInstance.addProviderAlertSettings.iCustomerResvId[1] = SysTableRowId(9, str: Global.sharedInstance.arrayDicForTableViewInCell[2]![1][1])
        
        Global.sharedInstance.addProviderAlertSettings.iCustomerResvFreqId = SysTableRowId(12, str: Global.sharedInstance.arrayDicForTableViewInCell[2]![2][0])
        
        Global.sharedInstance.addProviderAlertSettings.iCustomerEventsFreqId = SysTableRowId(12, str: Global.sharedInstance.arrayDicForTableViewInCell[3]![2][0])
        
        (Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId)[0] = SysTableRowId(10, str:  Global.sharedInstance.arrayDicForTableViewInCell[3]![1][0])
        
        //----------------------------
        let ax:NSDictionary = self.INITIALSETTINGS
        print("ce ver1 \(ax["iIncomingAlertsId"])")
        // if   ax["iIncomingAlertsId"] != nil  {
        if let _ = ax["iIncomingAlertsId"] as? NSNull {
            Global.sharedInstance.arrNotificationsX[0] = true
            Global.sharedInstance.arrNotificationsV[0] = false
        } else {
            Global.sharedInstance.arrNotificationsX[0] = false
            Global.sharedInstance.arrNotificationsV[0] = true
            //  return
        }
        //        Global.sharedInstance.arrNotificationsX[0] = true
        //        Global.sharedInstance.arrNotificationsV[0] = false
        //        } else {
        //        Global.sharedInstance.arrNotificationsX[0] = false
        //        Global.sharedInstance.arrNotificationsV[0] = true
        //        }
        
        //        if Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId.count > 0  ||  (Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[0]).description != "<null>" {
        //            for a in Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId {
        //                  print("ldzzz \(a.description)")
        //            }
        //
        //            Global.sharedInstance.arrNotificationsX[0] = false
        //            Global.sharedInstance.arrNotificationsV[0] = true
        //
        //        } else {
        //
        //            Global.sharedInstance.arrNotificationsX[0] = true
        //            Global.sharedInstance.arrNotificationsV[0] = false
        //        }
        //second row - 10 minutes before was (un) / checked
        if Global.sharedInstance.addProviderAlertSettings.b10minutesBeforeService == true {
            Global.sharedInstance.addProviderAlertSettings.b10minutesBeforeService = true
            Global.sharedInstance.arrNotificationsX[1] = false
            Global.sharedInstance.arrNotificationsV[1] = true
            
        } else {
            Global.sharedInstance.addProviderAlertSettings.b10minutesBeforeService = false
            Global.sharedInstance.arrNotificationsX[1] = true
            Global.sharedInstance.arrNotificationsV[1] = false
        }
        //third row iCustomerEventsId
        if let _ = ax["iCustomerResvId"] as? NSNull {
            Global.sharedInstance.arrNotificationsX[2] = true
            Global.sharedInstance.arrNotificationsV[2] = false
        } else {
            
            Global.sharedInstance.arrNotificationsX[2] = false
            Global.sharedInstance.arrNotificationsV[2] = true
            
        }
        
        //last row
        //  if Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId.count > 0 ||   String(Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId[0]) != "<null>" {
        if let _ = ax["iCustomerEventsId"] as? NSNull {
            Global.sharedInstance.arrNotificationsX[3] = true
            Global.sharedInstance.arrNotificationsV[3] = false
        } else {
            Global.sharedInstance.arrNotificationsX[3] = false
            Global.sharedInstance.arrNotificationsV[3] = true
            
        }
        
        
        
        externalTbl.reloadData()
        for sys in 0..<Global.sharedInstance.dicSysAlerts.count
        {
            
            print("dicSysAlerts \(sys.description)")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "client.jpg")!)
        self.titleofScreen.text = "NOTIFICATIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        let leftarrowback = UIImage(named: "sageata2.png")
        
        self.btnClose.setImage(leftarrowback, for: UIControl.State())
        
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.btnClose.transform = scalingTransform
        }
        self.btnClose.imageView!.contentMode = .scaleAspectFit
    }
    
    override func viewWillLayoutSubviews() {
        externalTbl.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        switch (tableView){
        case externalTbl:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (tableView){
        case externalTbl:
            if selectedCell[section] == true{
                return notificationsRowsInSection[section]!
            }
            return 1
        default:
            return headersForTblInCell.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = UITableViewCell()
        if tableView == externalTbl
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "DiscreptionNotificationTableViewCell")as!DiscreptionNotificationTableViewCell
            cell.selectionStyle = .none
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "DescTableViewCell")! as! DescTableViewCell
            cell.selectionStyle = .none
            
        }
        switch (tableView){
        case externalTbl:
            switch (indexPath.row){
            case 0:
                let cell:DiscreptionNotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DiscreptionNotificationTableViewCell")as!DiscreptionNotificationTableViewCell
                
                cell.delegate = self
                cell.selectionStyle = .none
                cell.tag = indexPath.section
                cell.lblDiscreption.tag = indexPath.row
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                numberOfRowInTable += 1
                cell.btnOk.tag = 1
                cell.btnCancel.tag = 0
                
                cell.setDisplayData(headersCell[indexPath.section])
                
                if indexPath.section == 0{
                    cell.viewTop.isHidden = false
                }
                else
                {
                    cell.viewTop.isHidden =  true
                }
                if indexPath.section == 3
                {
                    if pushClicked == true//עכשיו לחצו על וי-כדי שלא יעשה את זה תמיד כשזה מסומן בוי ויתקע את הגלילה
                    {
                        let indexPath = IndexPath(row: 2, section: 3)
                        let indexes = externalTbl.indexPathsForVisibleRows!
                        if indexes.contains(indexPath)
                        {
                            self.externalTbl.scrollToRow(at: indexPath, at: .bottom, animated: false)
                        }
                        else
                        {
                            let bottomOffset = CGPoint(x: 0, y: self.externalTbl.contentSize.height - self.externalTbl.bounds.size.height)
                            self.externalTbl.setContentOffset(bottomOffset, animated: true)
                            
                        }
                        if inCellTbl.isHidden == false
                        {
                            inCellTbl.isHidden = true
                            externalTbl.isScrollEnabled = true
                        }
                        pushClicked = false
                    }
                }
                return cell
            default:
                
                let cell:KindNotificationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "KindNotificationsTableViewCell")as!KindNotificationsTableViewCell
                Global.sharedInstance.kindNotificationsTableViewCell = cell
                var itemSelected = ""
                cell.sectionCell = indexPath.section
                cell.rowCell = indexPath.row
                openOrCloseTblDel = cell
                cell.selectionStyle = .none
                switch indexPath.section
                {
                case 0://עדכוני פגישה
                    itemSelected = SysTableRowString(8, id: Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[0] )
                    break
                case 2://מעקב אחר לקוחות
                    
                    if indexPath.row == 1//סוג התראה
                    {
                        itemSelected = SysTableRowString(9, id: Global.sharedInstance.addProviderAlertSettings.iCustomerResvId[1])
                    }
                    else//תדירות
                    {
                        itemSelected = SysTableRowString(12, id: Global.sharedInstance.addProviderAlertSettings.iCustomerResvFreqId)
                    }
                    break
                case 3://אירועים של לקוחות
                    if indexPath.row == 1//סוג עדכון
                    {
                        //אתחול ה-itemSelected לפי הכל
                        for iCustEventId in Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId
                        {
                            if itemSelected == ""
                            {
                                itemSelected = SysTableRowString(10, id: iCustEventId)
                            }
                            else
                            {
                                if iCustEventId != -1 && iCustEventId != 41
                                {
                                    itemSelected = itemSelected + "," + SysTableRowString(10, id: iCustEventId)
                                }
                            }
                        }
                    }
                    else//תדירות
                    {
                        itemSelected = SysTableRowString(12, id: Global.sharedInstance.addProviderAlertSettings.iCustomerEventsFreqId)
                    }
                    break
                case 4://דקה 90
                    //                        let indexPath = NSIndexPath(forRow: 1, inSection: 4)
                    //                        self.externalTbl.scrollToRowAtIndexPath(indexPath,atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                    //itemSelected = SysTableRowString(12, id: Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId)
                    
                    break
                default:
                    break
                }
                
                cell.setDisplayData(arrayDicForHeaders[indexPath.section]![indexPath.row],_itemSelected: itemSelected)
                
                cell.tag = indexPath.section
                cell.btnOpenTbl.tag = indexPath.section
                cell.textLabel?.tag = indexPath.section
                cell.descLblInCell.tag = indexPath.row
                cell.delegate = self
                cell.openTbl.tag = indexPath.section
                cell.tag = indexPath.row
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                numberOfRowInTable += 1
                if indexPath.section == 4{
                    cell.descLblInCell.font = UIFont(name: "OpenSansHebrew-Light", size: 14)!
                    
                }
                else{
                    cell.descLblInCell.font = UIFont(name: "OpenSansHebrew-Light", size: 18)!
                }
                if indexPath.section == 2 && indexPath.row == 0
                {
                    cell.itemSelected.text = "POPUP".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                }
                return cell
                
            }
        default:
            //הסל של הטבלה הפנימית שנפתחת
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "DescTableViewCell")! as! DescTableViewCell
            
            cell2.btnSelect.tag = indexPath.section
            
            cell2.sectionKindCell = Global.sharedInstance.sectionKind
            cell2.rowCell = indexPath.row
            cell2.rowKindCell = Global.sharedInstance.rowKind
            if (cell2.sectionKindCell == 0 && cell2.rowKindCell == 1) || (cell2.sectionKindCell == 3 && cell2.rowKindCell == 1) || (cell2.sectionKindCell == 2 && cell2.rowKindCell == 1)
            {
                if Global.sharedInstance.flagsHeadersForTblInCell[cell2.sectionKindCell]![cell2.rowKindCell][indexPath.row] == 1
                {
                    cell2.btnSelect.isCecked = true
                    cell2.btnSelect.isHidden = false
                    cell2.btnSelect.isEnabled = true
                }
                else
                {
                    if Global.sharedInstance.flagsHeadersForTblInCell[cell2.sectionKindCell]![cell2.rowKindCell][indexPath.row] == 1//עוזר כדי להציג את  הדיפולטיבי בוי(פופאפ)
                    {
                        cell2.btnSelect.isCecked = true
                    }
                    else
                    {
                        cell2.btnSelect.isCecked = false
                    }
                    cell2.btnSelect.isHidden = false
                    cell2.btnSelect.isEnabled = true
                }
            }
            else
            {
                cell2.btnSelect.isHidden = true
                cell2.btnSelect.isEnabled = false
            }
            cell2.setDisplayData(headersForTblInCell[indexPath.row])
            cell2.selectionStyle = .none
            if cell2.sectionKindCell == 0 && Global.sharedInstance.lastChooseIndex != 0 && indexPath.row == 0 && Global.sharedInstance.lastChooseIndex != -1
            {
                cell2.btnSelect.isCecked = false
            }
            return cell2
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == inCellTbl
        {
            if (inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).sectionKindCell == 0//אם נמצאים בסקשין הראשון- עדכוני פגישה
            {
                if Global.sharedInstance.headersForTblInCell[indexPath.row] != Global.sharedInstance.headersForTblInCell[0]//"הכל"
                {
                    if (inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).btnSelect.isCecked == true
                    {
                        Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).rowKindCell][(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).rowCell] = 0//לא בחור
                        (inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).btnSelect.isCecked = false
                    }
                    else
                    {
                        Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).rowKindCell][(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).rowCell] = 1//בחור
                        
                        Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).rowCell] = SysTableRowId(8, str: (inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).lblDesc.text!)
                        
                        Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[0] = -1
                        (inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).btnSelect.isCecked = true
                    }
                }
            }
            else if (inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).sectionKindCell == 3//סקשין של ארועים ללקוחות
            {
                let index:IndexPath = IndexPath(row: selectedRow, section: selectedSection)
                
                if (externalTbl.cellForRow(at: index) as! KindNotificationsTableViewCell).descLblInCell.text! == "KIND_UPDATE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                    //if indexPath.row == 1// סוג עדכון שאז יש בחירה מרובה
                {
                    if (inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).btnSelect.isCecked == true
                    {
                        Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).rowKindCell][(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).rowCell] = 0//לא בחור
                        
                        (inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).btnSelect.isCecked = false
                    }
                    else
                    {
                        Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).rowKindCell][(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).rowCell] = 1//בחור
                        
                        Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId[(inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).rowCell] = SysTableRowId(10, str: (inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).lblDesc.text!)
                        
                        (inCellTbl.cellForRow(at: indexPath)as!DescTableViewCell).btnSelect.isCecked = true
                    }
                }
            }
            
            didSelect = true
            numScrolled = 0
            
            let index:IndexPath = IndexPath(row: selectedRow, section: selectedSection)
            (externalTbl.cellForRow(at: index) as! KindNotificationsTableViewCell).itemSelected.text = headersForTblInCell[indexPath.row]
            
            //מכיל את הטקסט שכתוב על הסל,לדוג:סוג התראה וכו׳
            let a:String = (externalTbl.cellForRow(at: index) as! KindNotificationsTableViewCell).descLblInCell.text!
            
            let b = (externalTbl.cellForRow(at: index) as! KindNotificationsTableViewCell).tag
            
            let c:IndexPath = IndexPath(row: 0, section: index.section)
            
            var d:String = ""
            
            //כדי שלא יקרוס כשהטבלה הפנימית בסל הראשון פתוח ומסים לגלול את זה
            if externalTbl.cellForRow(at: c) != nil
            {
                d = (externalTbl.cellForRow(at: c) as! DiscreptionNotificationTableViewCell).lblDiscreption.text!
            }
            else
            {
                d = "MEETING_UPDATES".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            }
            
            switch(d)
            {
            case "MEETING_UPDATES".localized(LanguageMain.sharedInstance.USERLANGUAGE):
                
                let r = (tableView.cellForRow(at: indexPath) as! DescTableViewCell).lblDesc.text!
                
                Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[indexPath.row] = SysTableRowId(8, str: r)
                
                break
                
            case "FOLLW_CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE):
                if a == "KIND_NOTIFICATION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                {
                    let r = (tableView.cellForRow(at: indexPath) as! DescTableViewCell).lblDesc.text!
                    
                    Global.sharedInstance.addProviderAlertSettings.iCustomerResvId[indexPath.row] = SysTableRowId(9, str: r)
                }
                else // תדירות
                {
                    let r = (tableView.cellForRow(at: indexPath) as! DescTableViewCell).lblDesc.text!
                    
                    Global.sharedInstance.addProviderAlertSettings.iCustomerResvFreqId = SysTableRowId(12, str: r)
                    
                    //                    for i in 0 ..< Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowKindCell].count {
                    //                        Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowKindCell][i] = -1
                    //                    }
                    //
                    //                    Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowKindCell][(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowCell] = 1//בחור
                }
                
                break
            case "CUSTOMERS_EVENTS".localized(LanguageMain.sharedInstance.USERLANGUAGE):
                
                if a == "KIND_UPDATE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                {
                    let r = (tableView.cellForRow(at: indexPath) as! DescTableViewCell).lblDesc.text!
                    
                    Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId[indexPath.row] = SysTableRowId(10, str: r)
                }
                else // תדירות
                {
                    let r = (tableView.cellForRow(at: indexPath) as! DescTableViewCell).lblDesc.text!
                    
                    Global.sharedInstance.addProviderAlertSettings.iCustomerEventsFreqId = SysTableRowId(12, str: r)
                    
                    //                    for i in 0 ..< Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowKindCell].count {
                    //                        Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowKindCell][i] = -1
                    //                    }
                    //
                    //                    Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowKindCell][(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowCell] = 1//בחור
                }
                
                break
                
            case "דקה 90":
                
                //לשלוח את מה שמכניס ל-textField
                
                
                break
                
            default:
                break
            }
            
            if (c.section == 3 && b == 2) || (c.section == 2 && b == 2)
            {
                openOrCloseTblDel.openOrCloseTbl()
            }
            Global.sharedInstance.isOpen = false
            Global.sharedInstance.isOpen = false
        }
        else
        {
            if inCellTbl.isHidden == true
            {
                if indexPath.row == 0
                {
                    if selectedCell[indexPath.section] == false{
                        
                        switch indexPath.section {
                        case 0:
                            headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[indexPath.section]![1]
                            Global.sharedInstance.headersForTblInCell = headersForTblInCell
                            ///אתחול דיפולטיבי בערך הראשון
                            
                            for _ in Global.sharedInstance.dicSysAlerts["8"]! {
                                Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId.append(-1)//אתחול המערך לפי ה-count של תוכן הטבלה
                            }
                            
                            (Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId)[0]  =
                                SysTableRowId(8, str:  headersForTblInCell[0])
                        case 1: //כניסה/יציאה מהתור....
                            Global.sharedInstance.addProviderAlertSettings.b10minutesBeforeService = true
                            break
                        case 2://מעקב אחר לקוחות
                            
                            headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[indexPath.section]![1]
                            Global.sharedInstance.headersForTblInCell = headersForTblInCell
                            
                            //אתחול דיפולטיבי בערך הראשון
                            (Global.sharedInstance.addProviderAlertSettings.iCustomerResvId )[0]  =
                                SysTableRowId(9, str:  headersForTblInCell[0])
                            
                            
                            headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[2]![2]
                            Global.sharedInstance.headersForTblInCell = headersForTblInCell
                            Global.sharedInstance.addProviderAlertSettings.iCustomerResvFreqId = SysTableRowId(12, str: headersForTblInCell[0])
                            
                            break
                        case 3://אירועים של לקוחות
                            
                            pushClicked = true
                            
                            headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[indexPath.section]![1]
                            
                            Global.sharedInstance.headersForTblInCell = headersForTblInCell
                            
                            for _ in Global.sharedInstance.dicSysAlerts["10"]! {
                                Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId.append(-1)//אתחול המערך לפי ה-count של תוכן הטבלה
                            }
                            //אתחול דיפולטיבי בערך הראשון
                            (Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId )[0]  =
                                SysTableRowId(10, str:  headersForTblInCell[0])
                            
                            headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[2]![2]
                            
                            Global.sharedInstance.headersForTblInCell = headersForTblInCell
                            
                            
                            Global.sharedInstance.addProviderAlertSettings.iCustomerEventsFreqId = SysTableRowId(12, str: headersForTblInCell[0])
                            break
                            
                        default:
                            break
                        }
                        
                        
                        Global.sharedInstance.arrNotificationsV[indexPath.section] = true
                        Global.sharedInstance.arrNotificationsX[indexPath.section] = false
                        
                        if indexPath.section != 1 && indexPath.section != 5 {
                            selectedCell[indexPath.section] = true
                            //                externalTbl.reloadData()
                        }
                        externalTbl.reloadData()
                    }
                    else{
                        if indexPath.section == 1
                        {
                            Global.sharedInstance.addProviderAlertSettings.b10minutesBeforeService = false
                        }
                        
                        Global.sharedInstance.arrNotificationsV[indexPath.section] = false
                        Global.sharedInstance.arrNotificationsX[indexPath.section] = true
                        
                        selectedCell[indexPath.section] = false
                        externalTbl.isScrollEnabled = true
                        
                        externalTbl.reloadData()
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == externalTbl{
            return Global.sharedInstance.heightForNotificationCell
        }
        return inCellTbl.frame.size.height / 5
    }
    
    //MARK: - ScrollView
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if (self.lastContentOffset < externalTbl.contentOffset.y)
        {
            // moved up
            if inCellTbl.isHidden == false
            {
                inCellTbl.frame.origin.y = yOfInTblBase! - lastContentOffset
            }
        }
        else if (self.lastContentOffset > externalTbl.contentOffset.y) {
            // moved down
            if inCellTbl.isHidden == false
            {
                inCellTbl.frame.origin.y = yOfInTblBase! + lastContentOffset
            }
        }
        else
        {
            // didn't move
        }
        
        yAfterScrolled = inCellTbl.frame.origin.y
        if isScrolld == false
        {
            isScrolld = true
        }
        else
        {
            numScrolled += 1
        }
        if externalTbl.contentOffset.y == 120
        {
            isScrolld = false
            numScrolled = 0
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = externalTbl.contentOffset.y
    }
    
    // MARK: - reloadTableInCellDelegate
    
    //close in table
    func closeTbl()
    {
        Global.sharedInstance.isOpen = false
        didSelect = true
        inCellTbl.isHidden = true
        externalTbl.isScrollEnabled = true
    }
    //open in table
    @objc func openTable(_ btn:UIButton,cell:UITableViewCell){
        
        //self.cellinTblIsOpen = true
        didSelect = false
        Global.sharedInstance.isOpen = true
        
        switch(btn.tag)
        {
        case 0: //עדכוני פגישה
            inCellTbl.translatesAutoresizingMaskIntoConstraints = false
            ///מיקום הטבלה הפנימית בהתאם לcell שיתאים גם כשגוללים את המסך
            let result = (cell as! KindNotificationsTableViewCell).frame.origin.y + (cell as! KindNotificationsTableViewCell).frame.height
            print("wha res \(result)")
            inCellTbl.frame.origin.y = externalTbl.frame.origin.y + result + (cell as! KindNotificationsTableViewCell).openTbl.frame.origin.y - externalTbl.contentOffset.y
            externalTbl.isScrollEnabled = false
            
            yOfInTblBase = inCellTbl.frame.origin.y
            
            case0OpenedInTbl = true
            break
            
        case 2: //"מעקב אחר לקוחות"
            inCellTbl.translatesAutoresizingMaskIntoConstraints = false
            
            let bottomOffset: CGPoint = CGPoint(x: 0, y: 0.13513 * externalTbl.frame.height)
            self.externalTbl.setContentOffset(bottomOffset, animated: false)
            
            let result = (cell as! KindNotificationsTableViewCell).frame.origin.y + (cell as! KindNotificationsTableViewCell).frame.height
            print("wha2 res \(result)")
            inCellTbl.frame.origin.y = externalTbl.frame.origin.y + result + (cell as! KindNotificationsTableViewCell).openTbl.frame.origin.y - externalTbl.contentOffset.y
            externalTbl.isScrollEnabled = false
            
            yOfInTblBase = inCellTbl.frame.origin.y
            
            case0OpenedInTbl = false
            
            break
        case 3: //אירועים של לקוחות
            
            externalTbl.contentSize.height += 60//הגדלת גודל הטבלה החיצונית כדי שיוכלו לגלול את הפנימית ללמעלה ולבחור בתוך הטבלה הפנימית
            Global.sharedInstance.isExtTblHeightAdded60 = true
            externalTbl.contentOffset = CGPoint(x: 0, y: self.externalTbl.contentSize.height - self.externalTbl.frame.size.height)
            
            ///מיקום הטבלה הפנימית בהתאם לcell שיתאים גם כשגוללים את המסך
            let result = (cell as! KindNotificationsTableViewCell).frame.origin.y + (cell as! KindNotificationsTableViewCell).frame.height
            print("wha3 res \(result)")
            inCellTbl.frame.origin.y = externalTbl.frame.origin.y + result + (cell as! KindNotificationsTableViewCell).openTbl.frame.origin.y - externalTbl.contentOffset.y
            externalTbl.isScrollEnabled = false
            
            yOfInTblBase = inCellTbl.frame.origin.y
            
            case0OpenedInTbl = false
            
            break
        default:
            break
        }
        
        selectedSection = btn.tag
        selectedRow = cell.tag
        Global.sharedInstance.sectionKind = btn.tag
        Global.sharedInstance.rowKind  = cell.tag
        headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[btn.tag]![cell.tag]
        Global.sharedInstance.headersForTblInCell = headersForTblInCell
        
        inCellTbl.reloadData()
        inCellTbl.isHidden = false
    }
    
    func reloadTblIn()
    {
        inCellTbl.reloadData()
    }
    
    // MARK: - openInCellDelegate
    
    //אם לחצו על פתיחת הסל
    func openCellsUnder(_ cell:UITableViewCell,btn:UIButton){
        //Global.sharedInstance.isOpen = false
        if btn.tag == 1 //√
        {
            switch(cell.tag)
            {
            //שמירת הערכים הדיפולטיביים לשליחה לשרת
            case 0:
                
                headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[cell.tag]![btn.tag]
                Global.sharedInstance.headersForTblInCell = headersForTblInCell
                
                for _ in Global.sharedInstance.dicSysAlerts["8"]!
                {
                    Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId.append(-1)//אתחול המערך לפי ה-count של תוכן הטבלה
                }
                //כדי שיחזור להיות לפי הדיפולטיבי
                Global.sharedInstance.selectedItemsForSaveData[cell.tag]![btn.tag] = ""
                Global.sharedInstance.lastChooseIndex = -1
                
                //אתחול דיפולטיבי בערך הראשון
                (Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId )[0] = SysTableRowId(8, str:  headersForTblInCell[0])
                for i in 0 ..< Global.sharedInstance.flagsHeadersForTblInCell[cell.tag]![btn.tag].count {
                    Global.sharedInstance.flagsHeadersForTblInCell[cell.tag]![btn.tag][i] = 1
                }
                
                break
            case 1: //כניסה/יציאה מהתור....
                Global.sharedInstance.addProviderAlertSettings.b10minutesBeforeService = true
                break
            case 2://"מעקב אחר לקוחות"
                
                for _ in Global.sharedInstance.dicSysAlerts["9"]!
                {
                    Global.sharedInstance.addProviderAlertSettings.iCustomerResvId.append(-1)//אתחול המערך לפי ה-count של תוכן הטבלה
                }
                //בשביל סוג עדכון
                headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[cell.tag]![btn.tag]
                
                Global.sharedInstance.headersForTblInCell = headersForTblInCell
                
                (Global.sharedInstance.addProviderAlertSettings.iCustomerResvId)[1] = SysTableRowId(9, str:  headersForTblInCell[1])
                for i in 0 ..< Global.sharedInstance.flagsHeadersForTblInCell[cell.tag]![btn.tag].count
                {
                    Global.sharedInstance.flagsHeadersForTblInCell[cell.tag]![btn.tag][i] = 0
                }
                Global.sharedInstance.flagsHeadersForTblInCell[cell.tag]![btn.tag][1] = 1
                Global.sharedInstance.selectedItemsForSaveData[cell.tag]![btn.tag] = ""
                
                //בשביל תדירות
                headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[2]![2]
                Global.sharedInstance.headersForTblInCell = headersForTblInCell
                Global.sharedInstance.addProviderAlertSettings.iCustomerResvFreqId = SysTableRowId(12, str: headersForTblInCell[0])
                // בשביל אתחול דיפולטיבי
                Global.sharedInstance.flagsHeadersForTblInCell[cell.tag]![btn.tag][1] = 1
                
                break
            case 3://אירועים של לקוחות
                
                pushClicked = true
                
                var i = 0
                for _ in Global.sharedInstance.dicSysAlerts["10"]!
                {
                    Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId.append(-1)//אתחול המערך לפי ה-count של תוכן הטבלה
                    
                    i += 1
                }
                //בשביל סוג עדכון
                headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[cell.tag]![btn.tag]
                
                Global.sharedInstance.headersForTblInCell = headersForTblInCell
                
                (Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId)[0] = SysTableRowId(10, str:  headersForTblInCell[0])
                for i in 0 ..< Global.sharedInstance.flagsHeadersForTblInCell[cell.tag]![btn.tag].count
                {
                    Global.sharedInstance.flagsHeadersForTblInCell[cell.tag]![btn.tag][i] = 0
                }
                Global.sharedInstance.flagsHeadersForTblInCell[cell.tag]![btn.tag][0] = 1
                Global.sharedInstance.selectedItemsForSaveData[cell.tag]![btn.tag] = ""
                
                //בשביל תדירות
                headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[2]![2]
                Global.sharedInstance.headersForTblInCell = headersForTblInCell
                Global.sharedInstance.addProviderAlertSettings.iCustomerEventsFreqId = SysTableRowId(12, str: headersForTblInCell[0])
                
                break
            case 4://הדקה ה-90
                
                miniute90 = true
                
                break
            default:
                break
            }
            
            
            Global.sharedInstance.arrNotificationsV[cell.tag] = true
            Global.sharedInstance.arrNotificationsX[cell.tag] = false
            
            if cell.tag != 1 && cell.tag != 5{
                selectedCell[cell.tag] = true
            }
            externalTbl.reloadData()
        }
        else //x
        {
            Global.sharedInstance.isExtTblHeightAdded60 = false
            Global.sharedInstance.tagCellOpenedInTbl = -1//סגירת הטבלה
            if cell.tag == 1
            {
                Global.sharedInstance.addProviderAlertSettings.b10minutesBeforeService = false
            }
            switch(cell.tag)
            {
            //שמירת הערכים לשליחה לשרת
            case 0:
                
                Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId = []
                break
                
            case 1: //כניסה/יציאה מהתור....
                Global.sharedInstance.addProviderAlertSettings.b10minutesBeforeService = false
                break
                
            case 2://"מעקב אחר לקוחות"
                
                Global.sharedInstance.addProviderAlertSettings.iCustomerResvId = []
                Global.sharedInstance.addProviderAlertSettings.iCustomerResvFreqId = 0
                break
                
            case 3://אירועים של לקוחות
                
                //בשביל סוג עדכון
                Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId = []
                //בשביל תדירות
                Global.sharedInstance.addProviderAlertSettings.iCustomerEventsFreqId = 0
                break
                
            case 4://הדקה ה-90
                miniute90 = true
                //לשלוח ערך דיפולטיבי 0
                break
                
            default:
                break
            }
            
            Global.sharedInstance.arrNotificationsV[cell.tag] = false
            Global.sharedInstance.arrNotificationsX[cell.tag] = true
            
            selectedCell[cell.tag] = false
            
            inCellTbl.isHidden = true
            externalTbl.isScrollEnabled = true
            
            externalTbl.reloadData()
        }
    }
    
    //add border to top of view
    //get:color & width to the border,any=to which view to do the border
    func addTopBorder(_ color: UIColor, width: CGFloat,any :UIView) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0,y: 0, width: any.layer.frame.width + (any.layer.frame.width / 3) , height: 1)
        any.layer.addSublayer(border)
    }
    
    //add border to bottom of view
    //get:color to the border,any=to which view to do the border
    func addBottomBorder(_ any:UIView,color:UIColor)
    {
        let borderBottom = CALayer()
        
        borderBottom.frame = CGRect(x: 0, y: any.layer.frame.height + 8 , width: any.layer.frame.width + (any.layer.frame.width / 3) , height: 1)
        
        borderBottom.backgroundColor = color.cgColor;
        
        any.layer.addSublayer(borderBottom)
    }
    
    //מחזיר את הקוד לשורה מסויימת מהטבלה שנבחרה-בשביל השליחה לשרת
    //מקבלת את קוד הטבלה אליה לגשת ואת הסטרינג שנבחר
    func SysTableRowId(_ iTableRowId:Int,str:String)->Int
    {
        for sys in Global.sharedInstance.dicSysAlerts[iTableRowId.description]!
        {
            if sys.iTableId == iTableRowId && sys.nvAletName == str
            {
                return sys.iSysTableRowId
            }
        }
        return 0
    }
    
    //מחזיר את ה-string לשורה מסויימת מהטבלה שנבחרה
    //מקבלת את קוד הטבלה אליה לגשת ואת קוד ה-string
    func SysTableRowString(_ iTableRowId:Int,id:Int)->String
    {
        
        for sys in Global.sharedInstance.dicSysAlerts[iTableRowId.description]!
        {
            
            if sys.iTableId == iTableRowId && sys.iSysTableRowId == id
            {
                return sys.nvAletName
                
            }
        }
        return ""
    }
    
    func closeInTable()
    {
        inCellTbl.isHidden = true
        Global.sharedInstance.isOpen = false
        Global.sharedInstance.tagCellOpenedInTbl = -1
    }
    
    //החזרת גודל הטבלה החיצונית לגודלה הרגיל(הטבלה החיצונית גדלה בעת פתיחת הטבלה הפנימית כדי שיהיה אפשר לגלול את הפנימית לצורך בחירה)
    func scrollExternalTbl()
    {
        externalTbl.contentSize.height -= 60
        Global.sharedInstance.isExtTblHeightAdded60 = false
    }
    //JMODE PLUS
    //GetProviderAlertSettings(int iProviderId)
    func GetProviderAlertSettings() {
        if Global.sharedInstance.dicSysAlerts.count == 0
        {
            self.generic.showNativeActivityIndicator(self)
            if Reachability.isConnectedToNetwork() == false
            {
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                self.generic.hideNativeActivityIndicator(self)
            }
            else
            {
                let dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                api.sharedInstance.GetSysAlertsList(dic,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        
                        //  print("sysalerts \(RESPONSEOBJECT["Result"])")
                        let sysAlert:SysAlerts = SysAlerts()
                        if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                            Global.sharedInstance.arrSysAlerts = sysAlert.sysToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                        }
                        if Global.sharedInstance.arrSysAlerts.count != 0
                        {
                            Global.sharedInstance.dicSysAlerts = sysAlert.sysToDic(Global.sharedInstance.arrSysAlerts)
                            Global.sharedInstance.arrayDicForTableViewInCell[0]![1] = sysAlert.SysnvAletName(8)
                            Global.sharedInstance.arrayDicForTableViewInCell[2]![1] = sysAlert.SysnvAletName(9)
                            Global.sharedInstance.arrayDicForTableViewInCell[2]![2] = sysAlert.SysnvAletName(12)
                            Global.sharedInstance.arrayDicForTableViewInCell[3]![1] = sysAlert.SysnvAletName(10)
                            Global.sharedInstance.arrayDicForTableViewInCell[3]![2] = sysAlert.SysnvAletName(12)
                            
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
                })
                
            }
        }
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        if Global.sharedInstance.providerID == 0 {
            dic["iProviderId"] = 0 as AnyObject
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                dic["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
            }
        } else {
            dic["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        }
        print("dic iProviderId \(dic["iProviderId"])")
        //\\nu uita dic["iProviderId"] = 68
        api.sharedInstance.GetProviderAlertSettings(dic,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _:NSDictionary = RESPONSEOBJECT["Result"] as? NSDictionary {
                    self.INITIALSETTINGS = RESPONSEOBJECT["Result"] as! NSDictionary
                    self.reloadfirst()
                }
            }
            
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        })
        externalTbl.reloadData()
        //   self.reloadfirst()
    }
    //new in iOS  //int iProviderId in ProviderAlertsSettingsObj
    func UpdateProviderAlertSettings(){
        var dic:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        var dicupdate:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        dic = Global.sharedInstance.addProviderAlertSettings.getDic()
        if Global.sharedInstance.providerID == 0 {
            dic["iProviderId"] = 0 as AnyObject
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                dic["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
            }
        } else {
            dic["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        }

        dicupdate["obj"] = dic as AnyObject
        print("dic update iProviderId \(dicupdate)")
        //\\nu uita dic["iProviderId"] = 68
        api.sharedInstance.UpdateProviderAlertSettings(dicupdate,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                
                if let _ = RESPONSEOBJECT["Result"] as? Int {
                    let REZULTATE:Int = RESPONSEOBJECT["Result"] as! Int
                    if REZULTATE > 0 {
                        //
                        self.finalandclosed()
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        })
        
        
    }
    func finalandclosed() {
        var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 {
                dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
                api.sharedInstance.getProviderAllDetails(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            
                            
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                            {
                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            }
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                            {
                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            }
                            else
                            {
                                if let _ = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                                    print("responseee \(RESPONSEOBJECT["Result"] )")
                                    Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                }
                                //\\ print ("1 -> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName)")
                                //\\ print ("2-> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress)")
                                //\\ print ("3 -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen)")
                                //\\ print ("4 -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage)")
                                let storybrd: UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
                                let frontviewcontroller:UINavigationController? = UINavigationController()
                                let viewcon: SupplierSettings = storybrd.instantiateViewController(withIdentifier: "SupplierSettings")as! SupplierSettings
                                frontviewcontroller!.pushViewController(viewcon, animated: false)
                                //initialize REAR View Controller- it is the LEFT hand menu.
                                let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                                let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                let mainRevealController = SWRevealViewController()
                                mainRevealController.frontViewController = frontviewcontroller
                                mainRevealController.rearViewController = rearViewController
                                let window :UIWindow = UIApplication.shared.keyWindow!
                                window.rootViewController = mainRevealController
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
                })
            }
        }
    }
    
}
