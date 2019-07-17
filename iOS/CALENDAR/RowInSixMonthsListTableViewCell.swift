//
//  RowInSixMonthsListTableViewCell.swift
//  Bthere
//
//  Created by User on 23.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
//ספק קיים
class RowInSixMonthsListTableViewCell: UITableViewCell {

    var dateTurn:String = ""
    var arrImg:Array<String> = ["List_icon.png","X_Icon.png","Phone_icon.png"]
    var isfromLIST:Bool = false
    //NEWCALL CANCEL INFO_ORDER
    var arrText:Array<String> = ["INFO_ORDER".localized(LanguageMain.sharedInstance.USERLANGUAGE), "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE),"NEWCALL".localized(LanguageMain.sharedInstance.USERLANGUAGE) ]
    let calendar = Foundation.Calendar.current
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    var hourTurn:String = ""
    var indexPathRow:Int = 0
    var hourDesc = ""
    var desc = ""
    var servicesdesc = ""
    var eventFrom = 0
    var wascancel:Int = 1
    var ClientDict:NSDictionary = NSDictionary()
    var sortArrEvnt:[(String,Array<allKindEventsForListDesign>)] = []//מכיל את כל הארועים הנ״ל בצורה ממויינת לפי תאירך ולפי שעות לכל יום
    var delegate:openDetailsOrderDelegate!=nil
    var event:allKindEventsForListDesign = allKindEventsForListDesign()
    var APPOINMENT_DICT:NSDictionary = NSDictionary()
    var userAPPOINMENT_DICT:NSDictionary = NSDictionary()
    var isHourPast:Bool = false
    var isOcasionalCustomer:Bool = false
    @IBOutlet weak var collList: UICollectionView!
    @objc func tapOrderTurn(_ sender:UITapGestureRecognizer)
    {
        let USERDEF = UserDefaults.standard
        USERDEF.set(3 , forKey: "iFirstCalendarViewType") //list view
        USERDEF.synchronize()
      //  Global.sharedInstance.whichDesignOpenDetailsAppointment = 3
        
        //בודק האם ה-cell שעליו לחצו הוא תור של ביזר ואז בלחיצה יש להציג את פרטי התור
        if event.tag == 1
        {
            Global.sharedInstance.hourBthereEvent = event.fromHour
             Global.sharedInstance.hourBthereEvent = event.toHour
            let orderDetailsFoBthereEvent:OrderDetailsObj = OrderDetailsObj(
                _iCoordinatedServiceId: event.iCoordinatedServiceId,
                _iProviderUserId: event.iProviderUserId,
                _nvFirstName: "",
                _nvSupplierName: event.nvSupplierName,
                _objProviderServiceDetails: [],
                _iDayInWeek: 0,
                _dtDateOrder: event.dateEvent,
                _nvFromHour: event.fromHour,
                _nvToHour: event.toHour,
                _nvAddress: event.nvAddress,
                _nvComment: event.nvComment,
                _nvLogo: "",
                _iUserId: event.iUserId,
                _title:"",
                _chServiceColor: "",
                _iSupplierId: 0,
                _iCoordinatedServiceStatusType:  wascancel,
                _nvLastName: "",
                _nvPhone: ""
            )
            if let _:Dictionary<String,AnyObject> = orderDetailsFoBthereEvent.getDic() {
            let MyCustom:Dictionary<String,AnyObject> = orderDetailsFoBthereEvent.getDic()
                
            self.APPOINMENT_DICT = MyCustom as NSDictionary
            }
            Global.sharedInstance.orderDetailsFoBthereEvent = orderDetailsFoBthereEvent
            Global.sharedInstance.dateEventBthereClick = event.dateEvent
            Global.sharedInstance.serviceName = event.nvServiceName
            Global.sharedInstance.dayFreeEvent = DateFormatter().weekdaySymbols[event.iDayInWeek - 1]
            
            
            //delegate.openDetailsOrder(3)//רשימה של יומן לקוח
            opendetailsSupplierAppoinment()
            
        }
    }

        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
         

        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            let lineView: UIView = UIView(frame: CGRect(x: 0, y: self.contentView.frame.height - 1, width: self.contentView.frame.size.width + 60, height: 1))
            lineView.backgroundColor = Colors.sharedInstance.color6
            self.contentView.addSubview(lineView)
            // Configure the view for the selected state
        }
    
    
    func setDisplayData(_ index:Int)
    {
        indexPathRow = index
    }
   
    
    func setDisplayData(_ _hourDesc:String,_desc:String,_EventFrom:Int,_index:Int,_ClientDict:NSDictionary,_servicesdesc:String, _isHourPast:Bool, _isOcasionalCustomer:Bool){
        
        
        hourDesc = _hourDesc
        desc = _desc
        eventFrom = _EventFrom
        indexPathRow = _index
        ClientDict = _ClientDict
        servicesdesc = _servicesdesc
        collList.reloadData()
        isHourPast = _isHourPast
        isOcasionalCustomer = _isOcasionalCustomer

    
    
}


    func opendetailsSupplierAppoinment() {
    let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
    let frontviewcontroller:UINavigationController? = UINavigationController()
    let viewCon:detailsAppointmetsupplierViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "detailsAppointmetsupplierViewController") as! detailsAppointmetsupplierViewController
   
    viewCon.APPOINMENT_DICT = self.APPOINMENT_DICT
        
          viewCon.isfromLIST = true
            viewCon.EVENT_DICT = self.event
            let userdict:NSDictionary = self.ClientDict
           viewCon.userAPPOINMENT_DICT = userdict as! NSMutableDictionary
       
   //\\JMODE 
    viewCon.isOcasionalCustomer = self.isOcasionalCustomer
            frontviewcontroller!.pushViewController(viewCon, animated: false)
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


