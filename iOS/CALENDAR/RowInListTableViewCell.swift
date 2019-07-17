//
//  RowInListTableViewCell.swift
//  Bthere
//
//  Created by User on 23.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
//ספק קיים
class RowInListTableViewCell: UITableViewCell {
    var fromSixMonthReport:Bool = false
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
    var isdayevent:Bool = false
    var ClientDict:NSDictionary = NSDictionary()
    var sortArrEvnt:[(String,Array<allKindEventsForListDesign>)] = []//מכיל את כל הארועים הנ״ל בצורה ממויינת לפי תאירך ולפי שעות לכל יום
    var delegate:openDetailsOrderDelegate!=nil
    var event:allKindEventsForListDesign = allKindEventsForListDesign()
    var APPOINMENT_DICT:NSDictionary = NSDictionary()
    var userAPPOINMENT_DICT:NSDictionary = NSDictionary()
    var isHourPast:Bool = false
    var ISBLOCKED:Bool = false
    var isOcasionalCustomer:Bool = false
    @IBOutlet weak var collList: UICollectionView!
    @objc func tapOrderTurn(_ sender:UITapGestureRecognizer)
    {
        let USERDEF = UserDefaults.standard
        USERDEF.set(3 , forKey: "iFirstCalendarViewType") //list view
        USERDEF.synchronize()
       // Global.sharedInstance.whichDesignOpenDetailsAppointment = 3
        
        //בודק האם ה-cell שעליו לחצו הוא תור של ביזר ואז בלחיצה יש להציג את פרטי התור
        if event.tag == 1
        {
            Global.sharedInstance.hourBthereEvent = event.fromHour
            Global.sharedInstance.hourBthereEventEnd = event.toHour
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
             let MyCustom:Dictionary<String, AnyObject> = orderDetailsFoBthereEvent.getDic()
             self.APPOINMENT_DICT = MyCustom as NSDictionary

            Global.sharedInstance.orderDetailsFoBthereEvent = orderDetailsFoBthereEvent
            Global.sharedInstance.dateEventBthereClick = event.dateEvent
            Global.sharedInstance.serviceName = event.nvServiceName
            Global.sharedInstance.dayFreeEvent = DateFormatter().weekdaySymbols[event.iDayInWeek - 1]
            opendetailsSupplierAppoinment()
            
        }
    }

        override func awakeFromNib() {
            super.awakeFromNib()
            
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            let lineView: UIView = UIView(frame: CGRect(x: 0, y: self.contentView.frame.height - 1, width: self.contentView.frame.size.width + 60, height: 1))
            lineView.backgroundColor = Colors.sharedInstance.color6
            self.contentView.addSubview(lineView)
        }
    
    
    func setDisplayData(_ index:Int)
    {
        indexPathRow = index
    }
   
    
    func setDisplayData(_ _hourDesc:String,_desc:String,_EventFrom:Int,_index:Int,_ClientDict:NSDictionary,_servicesdesc:String, _isHourPast:Bool, _isOcasionalCustomer:Bool,_fromSixMonthReport: Bool, _iscancel: Int, _isblocked:Bool, _isdayevent:Bool){
        hourDesc = _hourDesc
        desc = _desc
        eventFrom = _EventFrom
        indexPathRow = _index
        ClientDict = _ClientDict
        servicesdesc = _servicesdesc
        collList.reloadData()
        isHourPast = _isHourPast
        isOcasionalCustomer = _isOcasionalCustomer
        fromSixMonthReport = _fromSixMonthReport
        wascancel = _iscancel
        ISBLOCKED = _isblocked
        isdayevent = _isdayevent
     }
}
//MARK: - CollectionView

extension RowInListTableViewCell : UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (UIScreen.main.bounds.width - 5),height: self.contentView.frame.size.height); //use height whatever you wants.
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0,left: 0,bottom: 0,right: 0)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, UIEdgeInsets indexPath: IndexPath) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 0,bottom: 0,right: 0);
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowInListCollectionViewCell", for: indexPath) as! RowInListCollectionViewCell
            cell.setDisplayData(hourDesc, desc:desc, services: servicesdesc,_isHourPast: isHourPast, _isOcasionalCustomer: isOcasionalCustomer,_fromSixMonthReport: self.fromSixMonthReport, _iscancel: self.wascancel,_isblocked: self.ISBLOCKED, _isdayevent:  self.isdayevent)
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOrderTurn))
            cell.contentView.addGestureRecognizer(tap)
            hourTurn = hourDesc
            return cell
    }
    func opendetailsSupplierAppoinment() {
        if self.isdayevent == false {
    let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
    let frontviewcontroller:UINavigationController? = UINavigationController()
    let viewCon:detailsAppointmetsupplierViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "detailsAppointmetsupplierViewController") as! detailsAppointmetsupplierViewController
        
        let mydic = self.APPOINMENT_DICT
        if let _:String = mydic["nvComment"] as? String {
            let nvcom = mydic["nvComment"] as! String
            if nvcom == "BlockedBySupplier" {
                viewCon.isBLOCKED = true
               viewCon.isFROMALLMEETINGS = false
     
            } else {
                viewCon.isBLOCKED = false
              viewCon.isFROMALLMEETINGS = false
        
            }
        }
        viewCon.APPOINMENT_DICT = self.APPOINMENT_DICT
        viewCon.tag = 2
        viewCon.isfromLIST = true
        viewCon.EVENT_DICT = self.event
        let userdict:NSDictionary = self.ClientDict
        viewCon.userAPPOINMENT_DICT = userdict as! NSMutableDictionary
        viewCon.isOcasionalCustomer = self.isOcasionalCustomer
        //\\JMODE
        
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

}



