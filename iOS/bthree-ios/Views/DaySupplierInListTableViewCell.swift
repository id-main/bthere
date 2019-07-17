//
//  DaySupplierInListTableViewCell
//  Bthere
//
//  Created by Ioan Ungureanu on 01.03.2017
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
//ספק קיים
class DaySupplierInListTableViewCell: UITableViewCell {
    
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
    var ClientDict:NSDictionary = NSDictionary()
    var sortArrEvnt:[(String,Array<allKindEventsForListDesign>)] = []//מכיל את כל הארועים הנ״ל בצורה ממויינת לפי תאירך ולפי שעות לכל יום
    var delegate:openDetailsOrderDelegate!=nil
    var event:allKindEventsForListDesign = allKindEventsForListDesign()
    var APPOINMENT_DICT:NSDictionary = NSDictionary()
    var userAPPOINMENT_DICT:NSDictionary = NSDictionary()
    var isexpanded:Bool = false
    var islastrow:Bool = false
    var isBthereEvent:Bool = false
    var isHourPast:Bool = false
    var isBlocked:Bool = false
    var ISOCASSIONAL:Bool = false
    @IBOutlet weak var collList: UICollectionView!
    
    @objc func tapOrderTurn(_ sender:UITapGestureRecognizer)
    {
//        Global.sharedInstance.whichDesignOpenDetailsAppointment = 3
        
        
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
                _iDayInWeek: event.iDayInWeek,
                _dtDateOrder: event.dateEvent,
                _nvFromHour: event.fromHour,
                _nvToHour: event.toHour,
                _nvAddress: event.nvAddress,
                _nvComment: event.nvComment,
                _nvLogo: "",
                _iUserId: event.iUserId,
                _title: "",
                _chServiceColor: "",
                _iSupplierId: 0,
                _iCoordinatedServiceStatusType: 1,
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
            let USERDEF = UserDefaults.standard
            USERDEF.set(0 , forKey: "iFirstCalendarViewType") //day view
            USERDEF.synchronize()
            opendetailsSupplierAppoinment()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //            let lineView: UIView = UIView(frame: CGRectMake(0, self.contentView.frame.height - 1, self.contentView.frame.size.width + 60, 1))
        //            lineView.backgroundColor = Colors.sharedInstance.color6
        //            self.contentView.addSubview(lineView)
        // Configure the view for the selected state
    }
    
    
    func setDisplayData(_ index:Int)
    {
        indexPathRow = index
    }
    
    func setDisplayData(_ _hourDesc:String,_desc:String,_EventFrom:Int,_index:Int,_ClientDict:NSDictionary,_servicesdesc:String,_isexpanded:Bool, _islastrow:Bool, _isBthereEvent:Bool, _isHourPast:Bool,_isBlocked:Bool,_isocassional:Bool){
        
        
        hourDesc = _hourDesc
        desc = _desc
        print("what to need \(desc)")
        eventFrom = _EventFrom
        indexPathRow = _index
        ClientDict = _ClientDict
        servicesdesc = _servicesdesc
        //\\   print("client dict \(ClientDict)")
        isexpanded = _isexpanded
        islastrow = _islastrow
        isBthereEvent = _isBthereEvent
        isHourPast = _isHourPast
        isBlocked = _isBlocked
        ISOCASSIONAL = _isocassional
        collList.reloadData()
        
    }
    
    
}
//MARK: - CollectionView

extension DaySupplierInListTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (UIScreen.main.bounds.width - 5),height: self.contentView.frame.size.height); //use height whatever you wants.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        //        if indexPath.row == 0
        //        {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaySupplierRowInListCollectionViewCell", for: indexPath) as! DaySupplierRowInListCollectionViewCell
        cell.setDisplayData(hourDesc, desc:desc, services: servicesdesc,_isexpanded:isexpanded, _islastrow:islastrow, _isBthereEvent: isBthereEvent, _isHourPast:  isHourPast,_isBlocked: self.isBlocked,_isocassional: ISOCASSIONAL )
        if isBlocked == true {
            self.event.title = "BlockedBySupplier"
            self.backgroundColor = Colors.sharedInstance.redlightforblocked


        } else {
           self.backgroundColor = .clear
        }
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOrderTurn))
        cell.contentView.addGestureRecognizer(tap)
        hourTurn = hourDesc
        return cell
        //}
        //        else
        //        {
        //            let cell1 = collectionView.dequeueReusableCellWithReuseIdentifier("OpenRowListCollectionViewCell", forIndexPath: indexPath) as! OpenRowListCollectionViewCell
        //            cell1.dateTurn = dateTurn
        //            cell1.hourTurn = hourTurn
        //            cell1.setDisplayData(arrText[indexPath.row - 1],img: arrImg[indexPath.row - 1],index: indexPath.row, MYClientDict: ClientDict,cancelEVENT_DICT: self.event)
        //            return cell1
        //        }
    }
    func opendetailsSupplierAppoinment() {
        let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let viewCon:detailsAppointmetsupplierViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "detailsAppointmetsupplierViewController") as! detailsAppointmetsupplierViewController
        viewCon.isBLOCKED = self.isBlocked
        viewCon.APPOINMENT_DICT = self.APPOINMENT_DICT
        viewCon.isOcasionalCustomer = self.ISOCASSIONAL
        viewCon.isfromLIST = true
        if isBlocked == true {
            self.event.title = "BlockedBySupplier"
            viewCon.isBLOCKED = true
        }
        viewCon.EVENT_DICT = self.event
        let userdict:NSDictionary = self.ClientDict
        viewCon.userAPPOINMENT_DICT = userdict as! NSMutableDictionary
        
        
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

