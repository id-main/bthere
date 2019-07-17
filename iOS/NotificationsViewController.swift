//
//  NotificationsViewController.swift
//  bthere.git
//
//  Created by User on 9.2.2016.
//
//

import UIKit

protocol reloadTableInCellDelegate{
    func openTable(btn:UIButton,cell:UITableViewCell)
    func closeTbl()
    func scrollExternalTbl()
}

protocol closeInTableDelegate {
    func closeInTable()
}

class NotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,reloadTableInCellDelegate, openInCellDelegate,closeInTableDelegate{
    
    @IBOutlet weak var layoutTblButtom: NSLayoutConstraint!
    @IBOutlet weak var inCellTbl: UITableView!
    
    @IBOutlet weak var externalTbl: UITableView!
    
    @IBOutlet weak var conTopInCellTbl: NSLayoutConstraint!
    
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
    ["עדכוני פגישה","10 דקות לפני פגישה","מעקב אחר לקוחות","אירועים של לקוחות"]
    var headersForTblInCell:Array<String> = []
    var selectedCell:Array<Bool> = [false,false,false,false,false,false]
    var selectedSection:Int = 0
    var selectedRow:Int = 0
    var arrayDicForHeaders:Dictionary<Int,Array<String>> =
    [0:["","סוג התראה"],2:["","סוג התראה","תדירות"],3:["","סוג עדכון","תדירות"],4:["","זמן התראה לפני זמן הארוע"]]
    //    [0:[," ""סוג התראה"],2:[," ""סוג התראה","תדירות"],3:[," ""סוג עדכון","תדירות"],4:[," ""זמן התראה לפני שעת הארוע"]]
    
    //    var arrayDicForTableViewInCell:Array<String> =
    //    ["הכל","פגישה נכנסת","שנוי פגישה","בטול פגישה"]

    
//    var arrayDicForTableViewInCell1:Dictionary<Int,Array<Array<String>>> =
//    [0:[["","","",""],["בטול פגישה","שנוי פרטי פגישה","פגישה נכנסת","הכל"]]
//        ,2:[[],["הודעה","התראה","צלצול","פעמון"],["שבועי","אחת ליומיים","יומי","חודשי"]]
//        ,3:[[],["בר מצווה","חתונה","מסיבה","יום הולדת"],["","יומי","שבועי","חודשי"]]
//        ,4:[[],["30 דק","20 דק","שעה","שעתים"]]]
//    
    //MARK: - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        externalTblHeight = externalTbl.contentSize.height
        
        Global.sharedInstance.rgisterModelViewController!.delgateNotif = self
        
        inCellTbl.scrollEnabled = false
        
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
        let dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertDelegate("לא נמצא חיבור לאינטרנט")
        }
        else
        {
            api.sharedInstance.GetSysAlertsList(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) -> Void in
                
                },failure: {(AFHTTPRequestOperation, NSError) -> Void in
            })
        }
        
        view.bringSubviewToFront(inCellTbl)
        inCellTbl.hidden = true
        
        externalTbl.separatorStyle = .None
        inCellTbl.separatorStyle = .None
       // self.automaticallyAdjustsScrollViewInsets =  false
        //inCellTbl.removeConstraint(layoutTblButtom)
        //
        //let verticalConstraint = NSLayoutConstraint(item: inCellTbl, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        //        view.addConstraint(verticalConstraint)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        externalTbl.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
         externalTbl.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        switch (tableView){
        case externalTbl:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch (tableView){
        case externalTbl:
            //if section != 5{
                if selectedCell[section] == true{
                    return notificationsRowsInSection[section]!
                }
                return 1
           // }
        default:
            return headersForTblInCell.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = UITableViewCell()
        if tableView == externalTbl
        {
          cell = tableView.dequeueReusableCellWithIdentifier("DiscreptionNotificationTableViewCell")as!DiscreptionNotificationTableViewCell
         cell.selectionStyle = .None
        }
        else{
        cell = tableView.dequeueReusableCellWithIdentifier("DescTableViewCell")! as! DescTableViewCell
            cell.selectionStyle = .None
            
        }
        switch (tableView){
        case externalTbl:
         // if indexPath.section != 5{
                switch (indexPath.row){
                case 0:
                    let cell:DiscreptionNotificationTableViewCell = tableView.dequeueReusableCellWithIdentifier("DiscreptionNotificationTableViewCell")as!DiscreptionNotificationTableViewCell
                    
                    cell.delegate = self
                    cell.selectionStyle = .None
                    cell.tag = indexPath.section
                    cell.lblDiscreption.tag = indexPath.row
                     cell.selectionStyle = UITableViewCellSelectionStyle.None
                    numberOfRowInTable += 1
                    cell.btnOk.tag = 1
                    cell.btnCancel.tag = 0
//                    if Global.sharedInstance.arrNotificationsV[indexPath.row] == true
//                    {
//                        cell.btnOk.tag = 1
//                    }
//                    else
//                    {
//                        cell.btnOk.tag = 0
//                    }
//                    if Global.sharedInstance.arrNotificationsX[indexPath.row] == true
//                    {
//                        cell.btnCancel.tag = 1
//                    }
//                    else
//                    {
//                        cell.btnCancel.tag = 0
//                    }
                    
                    cell.setDisplayData(headersCell[indexPath.section])

                    if indexPath.section == 0{
                        cell.viewTop.hidden = false
                       
                    }
                    else
                    {
                        cell.viewTop.hidden =  true
                    }
//                    if indexPath.section == 4
//                    {
////                        if selectedCell[4] == true
////                        {
//                        if miniute90 == true//עכשיו לחצתי על וי
//                        {
//                            let indexPath = NSIndexPath(forRow: 1, inSection: 4)
//                            self.externalTbl.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
//                            if inCellTbl.hidden == false
//                            {
//                                inCellTbl.frame.origin.y -= externalTbl.contentOffset.y
//                            }
//                            miniute90 = false
//                        }
//                    }
                    if indexPath.section == 3
                    {
                        //if selectedCell[0] == true && selectedCell[2] == true && selectedCell[3] == true
                        if pushClicked == true//עכשיו לחצו על וי-כדי שלא יעשה את זה תמיד כשזה מסומן בוי ויתקע את הגלילה
                        {
                            let indexPath = NSIndexPath(forRow: 2, inSection: 3)
                            self.externalTbl.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
                            if inCellTbl.hidden == false
                            {
                                inCellTbl.hidden = true
                                externalTbl.scrollEnabled = true
                            }
                            pushClicked = false
                        }
                    }

                    // cell.layer.borderColor = Colors.sharedInstance.color1.CGColor
                   //cell.layer.borderWidth = 1
                    return cell
                default:
                    
                    let cell:KindNotificationsTableViewCell = tableView.dequeueReusableCellWithIdentifier("KindNotificationsTableViewCell")as!KindNotificationsTableViewCell
                   // cell.isOpen = cellinTblIsOpen
                    var itemSelected = ""
                    cell.sectionCell = indexPath.section
                    cell.rowCell = indexPath.row
                    openOrCloseTblDel = cell
                    cell.selectionStyle = .None
                    switch indexPath.section
                    {
                    case 0://עדכוני פגישה
                        itemSelected = SysTableRowString(8, id: Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[0] as! Int)
                        break
                    case 2://מעקב אחר לקוחות
                      
                       if indexPath.row == 1//סוג התראה
                       {
                        //2do - לבטל את ההסלשה ולמחוק את ״Global.sharedInstance.selectedSavedCustomer״
                        itemSelected = Global.sharedInstance.selectedSavedCustomer//SysTableRowString(9, id: Global.sharedInstance.addProviderAlertSettings.iCustomerResvId)
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
                                {if iCustEventId != -1 && iCustEventId != 41{
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
                    
                    
//                    headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[indexPath.section]![indexPath.row]
//                    
//                    cell.itemSelected.text = headersForTblInCell[0]
                    cell.tag = indexPath.section
                    cell.btnOpenTbl.tag = indexPath.section
                    cell.textLabel?.tag = indexPath.section
                    cell.descLblInCell.tag = indexPath.row
                    cell.delegate = self
                    cell.openTbl.tag = indexPath.section
                    cell.tag = indexPath.row
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    
                    numberOfRowInTable += 1
                    if indexPath.section == 4{
                        cell.descLblInCell.font = UIFont(name: "OpenSansHebrew-Light", size: 14)!

                    }
                    else{
                         cell.descLblInCell.font = UIFont(name: "OpenSansHebrew-Light", size: 18)!
                    }
                    if indexPath.section == 2 && indexPath.row == 0{
cell.itemSelected.text = "פופאפ"                    }
                    return cell
                    
                }
        default:
            let cell2 = tableView.dequeueReusableCellWithIdentifier("DescTableViewCell")! as! DescTableViewCell
           
            cell2.btnSelect.tag = indexPath.section
            
            cell2.sectionKindCell = Global.sharedInstance.sectionKind
            cell2.rowCell = indexPath.row
            cell2.rowKindCell = Global.sharedInstance.rowKind
            if (cell2.sectionKindCell == 0 && cell2.rowKindCell == 1) || (cell2.sectionKindCell == 3 && cell2.rowKindCell == 1) || (cell2.sectionKindCell == 2 && cell2.rowKindCell == 1)
            {
                if Global.sharedInstance.flagsHeadersForTblInCell[cell2.sectionKindCell]![cell2.rowKindCell][indexPath.row] == 1
                {
                    cell2.btnSelect.isCecked = true
                    cell2.btnSelect.hidden = false
                    cell2.btnSelect.enabled = true
                }
                else
                {
                    if Global.sharedInstance.isDescCellOpenFirst == true
                    {
                        cell2.btnSelect.isCecked = true
                    }
                    else
                    {
                        cell2.btnSelect.isCecked = false
                    }
                    cell2.btnSelect.hidden = false
                    cell2.btnSelect.enabled = true
//                    cell2.btnSelect.isCecked = false
//                    cell2.btnSelect.hidden = false
//                    cell2.btnSelect.enabled = true
                }
            }
            else
            {
                 cell2.btnSelect.hidden = true
                cell2.btnSelect.enabled = false
            }
            cell2.setDisplayData(headersForTblInCell[indexPath.row])
            cell2.selectionStyle = .None
            if cell2.sectionKindCell == 0 && Global.sharedInstance.lastChooseIndex == 0{
                cell2.btnSelect.isCecked = true
            }
            else if cell2.sectionKindCell == 0 && Global.sharedInstance.lastChooseIndex != 0 && indexPath.row == 0 && Global.sharedInstance.lastChooseIndex != -1{
            cell2.btnSelect.isCecked = false
            }
            return cell2
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if tableView == inCellTbl
        {
            if (inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).sectionKindCell == 0//אם נמצאים בסקשין הראשון- עדכוני פגישה
            {
                if Global.sharedInstance.headersForTblInCell[indexPath.row] != "הכל"
                {
                    if (inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).btnSelect.isCecked == true
                    {
                        Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowKindCell][(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowCell] = 0//לא בחור
                        (inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).btnSelect.isCecked = false
                        
                    }
                    else{
                        Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowKindCell][(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowCell] = 1//בחור
                        
                        Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowCell] = SysTableRowId(8, str: (inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).lblDesc.text!)
                        
                        Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[0] = -1
                        (inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).btnSelect.isCecked = true
                    }
                }
            }
            else if (inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).sectionKindCell == 3//סקשין של ארועים ללקוחות
            {
                if indexPath.row == 1// סוג התראה שאז יש בחירה מרובה
                {
                    if (inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).btnSelect.isCecked == true
                    {
                        Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowKindCell][(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowCell] = 0//לא בחור
                        
                        (inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).btnSelect.isCecked = false
                    }
                    else
                    {
                        Global.sharedInstance.flagsHeadersForTblInCell[(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).sectionKindCell]![(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowKindCell][(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowCell] = 1//בחור
                        
                        Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId[(inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).rowCell] = SysTableRowId(10, str: (inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).lblDesc.text!)
                        
                        (inCellTbl.cellForRowAtIndexPath(indexPath)as!DescTableViewCell).btnSelect.isCecked = true
                    }
                }
            }
            
            didSelect = true
            numScrolled = 0
            
            let index:NSIndexPath = NSIndexPath(forRow: selectedRow, inSection: selectedSection)
            (externalTbl.cellForRowAtIndexPath(index) as! KindNotificationsTableViewCell).itemSelected.text = headersForTblInCell[indexPath.row]
            
            //מכיל את הטקסט שכתוב על הסל,לדוג:סוג התראה וכו׳
            let a:String = (externalTbl.cellForRowAtIndexPath(index) as! KindNotificationsTableViewCell).descLblInCell.text!
            
            let b = (externalTbl.cellForRowAtIndexPath(index) as! KindNotificationsTableViewCell).tag
            
            let c:NSIndexPath = NSIndexPath(forRow: 0, inSection: index.section)
            
            var d:String = ""
            
            //כדי שלא יקרוס כשהטבלה הפנימית בסל הראשון פתוח ומסים לגלול את זה
            if externalTbl.cellForRowAtIndexPath(c) != nil
            {
                d = (externalTbl.cellForRowAtIndexPath(c) as! DiscreptionNotificationTableViewCell).lblDiscreption.text!
            }
            else
            {
                d = "עדכוני פגישה"
            }
            
            switch(d)
            {
            case "עדכוני פגישה":
                
                let r = (tableView.cellForRowAtIndexPath(indexPath) as! DescTableViewCell).lblDesc.text!
                
                Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId[indexPath.row] = SysTableRowId(8, str: r)
                //.append(SysTableRowId(8, str: r))
                
                //Global.sharedInstance.dicSysAlerts["8"]!.iSysTableRowId
                
                break
                
            case "מעקב אחר לקוחות":
                if a == "סוג התראה"
                {
                    let r = (tableView.cellForRowAtIndexPath(indexPath) as! DescTableViewCell).lblDesc.text!
                    
                    Global.sharedInstance.addProviderAlertSettings.iCustomerResvId = SysTableRowId(9, str: r)
                    //2do - למחוק בהשך כשזה יהיה בשרת
                    Global.sharedInstance.selectedSavedCustomer = r
                }
                else // תדירות
                {
                    let r = (tableView.cellForRowAtIndexPath(indexPath) as! DescTableViewCell).lblDesc.text!
                    
                    Global.sharedInstance.addProviderAlertSettings.iCustomerResvFreqId = SysTableRowId(12, str: r)
                }
                
                break
            case "אירועים של לקוחות":
                
                if a == "סוג עדכון"
                {
                    let r = (tableView.cellForRowAtIndexPath(indexPath) as! DescTableViewCell).lblDesc.text!
                    
                     Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId[indexPath.row] = SysTableRowId(10, str: r)
                }
                else // תדירות
                {
                    let r = (tableView.cellForRowAtIndexPath(indexPath) as! DescTableViewCell).lblDesc.text!
                    
                    Global.sharedInstance.addProviderAlertSettings.iCustomerEventsFreqId = SysTableRowId(12, str: r)
                }
                
                break
                
            case "דקה 90":
                
                //2do
                //לשלוח את מה שמכניס ל-textField
                
                
                break
                
            default:
                break
            }
            
            if (c.section == 3 && b == 2) || (c.section == 2 && b == 2)
            {
                openOrCloseTblDel.openOrCloseTbl()
            }
            //inCellTbl.hidden = true
            Global.sharedInstance.isOpen = false
//            Global.sharedInstance.tagCellOpenedInTbl = -1
            //
            
            Global.sharedInstance.isOpen = false
        }
        else
        {
            if inCellTbl.hidden == true
            {
                if indexPath.row == 0
                {
                    if selectedCell[indexPath.section] == false{
                        
                        switch indexPath.section {
                        case 0:
                            headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[indexPath.section]![1]
                            Global.sharedInstance.headersForTblInCell = headersForTblInCell
                            ///אתחול דיפולטיבי בערך הראשון
                            
                            //let index:NSIndexPath = NSIndexPath(forRow: cell.tag, inSection: selectedSection)
                            
                            for sys in Global.sharedInstance.dicSysAlerts["8"]! {
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
                            Global.sharedInstance.addProviderAlertSettings.iCustomerResvId = SysTableRowId(9, str: headersForTblInCell[0])
                            
                            headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[2]![2]
                            Global.sharedInstance.headersForTblInCell = headersForTblInCell
                            Global.sharedInstance.addProviderAlertSettings.iCustomerResvFreqId = SysTableRowId(12, str: headersForTblInCell[0])
                            
                            break
                        case 3://אירועים של לקוחות
                            
                            pushClicked = true
                            
                            headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[indexPath.section]![1]
                            
                            Global.sharedInstance.headersForTblInCell = headersForTblInCell
                            
                            for sys in Global.sharedInstance.dicSysAlerts["10"]! {
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
                        //btn.setBackgroundImage(image, forState: .Normal)
                        
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
                        
                        //inCellTbl.hidden = true
                        externalTbl.scrollEnabled = true
                        
                        externalTbl.reloadData()
                    }
                }
            }
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == externalTbl{
            return Global.sharedInstance.heightForNotificationCell        }
        return inCellTbl.frame.size.height / 5
    }
    
    //MARK: - ScrollView
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        if (self.lastContentOffset < externalTbl.contentOffset.y)
        {
            // moved up
            if inCellTbl.hidden == false
            {
                inCellTbl.frame.origin.y = yOfInTblBase! - lastContentOffset
            }
        }
        else if (self.lastContentOffset > externalTbl.contentOffset.y) {
            // moved down
            if inCellTbl.hidden == false
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
        if externalTbl.contentOffset.y == 0
        {
            isScrolld = false
            numScrolled = 0
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.lastContentOffset = externalTbl.contentOffset.y
    }
    
    // MARK: - reloadTableInCellDelegate
    
//     func closeTbl(btn:UIButton,cell:UITableViewCell)
    func closeTbl()
    {
        Global.sharedInstance.isOpen = false
        didSelect = true
        inCellTbl.hidden = true
        externalTbl.scrollEnabled = true
    }
    
    func openTable(btn:UIButton,cell:UITableViewCell){
        
            //self.cellinTblIsOpen = true
            didSelect = false
            Global.sharedInstance.isOpen = true
            
            switch(btn.tag)
            {
            case 0: //עדכוני פגישה
                inCellTbl.translatesAutoresizingMaskIntoConstraints = false
                ///מיקום הטבלה הפנימית בהתאם לcell שיתאים גם כשגוללים את המסך
                let result = (cell as! KindNotificationsTableViewCell).frame.origin.y + (cell as! KindNotificationsTableViewCell).frame.height
                inCellTbl.frame.origin.y = result + (cell as! KindNotificationsTableViewCell).openTbl.frame.origin.y - externalTbl.contentOffset.y
                externalTbl.scrollEnabled = false
                
                yOfInTblBase = inCellTbl.frame.origin.y
                
                case0OpenedInTbl = true
                break
                
            case 2: //"מעקב אחר לקוחות"
                inCellTbl.translatesAutoresizingMaskIntoConstraints = false
                
                let bottomOffset: CGPoint = CGPointMake(0, 0.13513 * externalTbl.frame.height)
                self.externalTbl.setContentOffset(bottomOffset, animated: false)
                
                let result = (cell as! KindNotificationsTableViewCell).frame.origin.y + (cell as! KindNotificationsTableViewCell).frame.height
                inCellTbl.frame.origin.y = result + (cell as! KindNotificationsTableViewCell).openTbl.frame.origin.y - externalTbl.contentOffset.y
                externalTbl.scrollEnabled = false
                
                yOfInTblBase = inCellTbl.frame.origin.y
                
                case0OpenedInTbl = false
                
                break
            case 3: //אירועים של לקוחות
                
               externalTbl.contentSize.height += 60//הגדלת גודל הטבלה החיצונית כדי שיוכלו לגלול את הפנימית ללמעלה ולבחור בתוך הטבלה הפנימית
               Global.sharedInstance.isExtTblHeightAdded60 = true
               externalTbl.contentOffset = CGPointMake(0, self.externalTbl.contentSize.height - self.externalTbl.frame.size.height)
               
                ///מיקום הטבלה הפנימית בהתאם לcell שיתאים גם כשגוללים את המסך
                let result = (cell as! KindNotificationsTableViewCell).frame.origin.y + (cell as! KindNotificationsTableViewCell).frame.height
                inCellTbl.frame.origin.y = result + (cell as! KindNotificationsTableViewCell).openTbl.frame.origin.y - externalTbl.contentOffset.y
                externalTbl.scrollEnabled = false
                
                yOfInTblBase = inCellTbl.frame.origin.y
                
                case0OpenedInTbl = false
                
                break
//            case 4: //דקה 90
//                
//                ///מיקום הטבלה הפנימית בהתאם לcell שיתאים גם כשגוללים את המסך
//                let result = (cell as! KindNotificationsTableViewCell).frame.origin.y + (cell as! KindNotificationsTableViewCell).frame.height
//                inCellTbl.frame.origin.y = result + (cell as! KindNotificationsTableViewCell).openTbl.frame.origin.y - externalTbl.contentOffset.y
//                externalTbl.scrollEnabled = false
//                
//                yOfInTblBase = inCellTbl.frame.origin.y
//                
//                case0OpenedInTbl = false
//                
//                break
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
            inCellTbl.hidden = false
    }
    
    // MARK: - openInCellDelegate
    
     //אם לחצו על פתיחת הסל
    func openCellsUnder(cell:UITableViewCell,btn:UIButton){
       //Global.sharedInstance.isOpen = false
        if btn.tag == 1 //√
        {
            switch(cell.tag)
            {
                //שמירת הערכים הדיפולטיביים לשליחה לשרת
            case 0:
                
                 headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[cell.tag]![btn.tag]
                 Global.sharedInstance.headersForTblInCell = headersForTblInCell
                 ///אתחול דיפולטיבי בערך הראשון
                 
                  for sys in Global.sharedInstance.dicSysAlerts["8"]!
                  {
                    Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId.append(-1)//אתחול המערך לפי ה-count של תוכן הטבלה
                  }
                 //אתחול דיפולטיבי בערך הראשון
                (Global.sharedInstance.addProviderAlertSettings.iIncomingAlertsId )[0] = SysTableRowId(8, str:  headersForTblInCell[0])
           
                break
            case 1: //כניסה/יציאה מהתור....
                Global.sharedInstance.addProviderAlertSettings.b10minutesBeforeService = true
                break
            case 2://"מעקב אחר לקוחות"
                
                headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[cell.tag]![btn.tag]
                 Global.sharedInstance.headersForTblInCell = headersForTblInCell
                Global.sharedInstance.addProviderAlertSettings.iCustomerResvId = SysTableRowId(9, str: headersForTblInCell[0])
               
                headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[2]![2]
                 Global.sharedInstance.headersForTblInCell = headersForTblInCell
                 Global.sharedInstance.addProviderAlertSettings.iCustomerResvFreqId = SysTableRowId(12, str: headersForTblInCell[0])
                
                break
            case 3://אירועים של לקוחות
                
                pushClicked = true
                //בשביל סוג עדכון
                headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[cell.tag]![btn.tag]
                
                 Global.sharedInstance.headersForTblInCell = headersForTblInCell
                var i = 0
                for sys in Global.sharedInstance.dicSysAlerts["10"]!
                {
                    Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId.append(-1)//אתחול המערך לפי ה-count של תוכן הטבלה
                    
                    //אתחול בערך של כולם
                    (Global.sharedInstance.addProviderAlertSettings.iCustomerEventsId)[i] = SysTableRowId(10, str:  headersForTblInCell[i])
                    i += 1
                }
                
           
                //בשביל תדירות
                  headersForTblInCell = Global.sharedInstance.arrayDicForTableViewInCell[2]![2]
                 Global.sharedInstance.headersForTblInCell = headersForTblInCell
                  Global.sharedInstance.addProviderAlertSettings.iCustomerEventsFreqId = SysTableRowId(12, str: headersForTblInCell[0])
                break
            case 4://הדקה ה-90
                
                miniute90 = true
                
//                let index = NSIndexPath(forRow: 1, inSection: 3)
//                if selectedCell[3] == true
//                {
//                    externalTbl.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
//                }
//                else if selectedCell[2] == true
//                {
//                    let index = NSIndexPath(forRow: 1, inSection: 2)
//                     externalTbl.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Top,
//                                                        animated: false)
//                }
//                else if selectedCell[0] == true
//                {
//                    let index = NSIndexPath(forRow: 0, inSection: 1)
//                    externalTbl.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
//                }
                
                
                //לשלוח ערך דיפולטיבי 0
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
            
            Global.sharedInstance.arrNotificationsV[cell.tag] = false
            Global.sharedInstance.arrNotificationsX[cell.tag] = true
            
            selectedCell[cell.tag] = false
            
            inCellTbl.hidden = true
            externalTbl.scrollEnabled = true
            
            externalTbl.reloadData()
        }
        //externalTbl.reloadData()
    }
  
    func addTopBorder(color: UIColor, width: CGFloat,any :UIView) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0,0, CGRectGetWidth(any.layer.frame) + (any.layer.frame.width / 3) , 1)
        any.layer.addSublayer(border)
    }
    
    func addBottomBorder(any:UIView,color:UIColor)
    {
        let borderBottom = CALayer()
        
        borderBottom.frame = CGRectMake(0, CGRectGetHeight(any.layer.frame) + 8 , CGRectGetWidth(any.layer.frame) + (any.layer.frame.width / 3) , 1)
        
        borderBottom.backgroundColor = color.CGColor;
        
        any.layer.addSublayer(borderBottom)
    }
    
    //מחזיר את הקוד לשורה מסויימת מהטבלה שנבחרה-בשביל השליחה לשרת
    //מקבלת את קוד הטבלה אליה לגשת ואת הסטרינג שנבחר
    func SysTableRowId(iTableRowId:Int,str:String)->Int
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
    func SysTableRowString(iTableRowId:Int,id:Int)->String
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
        inCellTbl.hidden = true
        Global.sharedInstance.isOpen = false
        Global.sharedInstance.tagCellOpenedInTbl = -1
    }
    
    //החזרת גודל הטבלה החיצונית לגודלה הרגיל(הטבלה החיצונית גדלה בעת פתיחת הטבלה הפנימית כדי שיהיה אפשר לגלול את הפנימית לצורך בחירה)
    func scrollExternalTbl()
    {
        externalTbl.contentSize.height -= 60
        Global.sharedInstance.isExtTblHeightAdded60 = false
    }
}
