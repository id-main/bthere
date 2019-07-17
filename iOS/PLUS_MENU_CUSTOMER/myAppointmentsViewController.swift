//
//  myAppointmentsViewController.swift
//  BThere
//
//  Created by Racheli Kroiz on 30.11.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class myAppointmentsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    // Outlets

    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    @IBOutlet var topBorderView: UIView!
    @IBOutlet var popConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblAppointments: UITableView!
    var ordersSlightLateOfClientsArray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>()
    var pastAppointmentsFilter:Array<OrderDetailsObj> = Array<OrderDetailsObj>()
    var iHoursForPreCancelServiceByCustomer:Int = 0
    var bIsAvailableForNewCustomer:Int = 1

    // Variables
    var generic:Generic = Generic()
    var whichOpenMe = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (whichOpenMe == 3) {
            GoogleAnalyticsSendEvent(x:17)
        } else if (whichOpenMe == 1) {
            GoogleAnalyticsSendEvent(x:20)
        }else {
            GoogleAnalyticsSendEvent(x:19)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      //  var userCalendar =  Foundation.Calendar.current // user calendar

        //print(" \(daylightSavingTimeOffset(for:Global.sharedInstance.ordersOfClientsArray[indexPath.row].dtDateOrder)")
//        userCalendar.timeZone =  NSTimeZone.local // TimeZone(abbreviation: "UTC")!
//        let daylightSavingTimeOffset1 = userCalendar.timeZone.daylightSavingTimeOffset()
//        let mydifferenceoftime = daylightSavingTimeOffset1/60 // (1h)
//        if mydifferenceoftime == 60 {
//            userCalendar.timeZone =  TimeZone(abbreviation: "GMT+03")!
//        } else if mydifferenceoftime == 0 {
//            userCalendar.timeZone =  TimeZone(abbreviation: "GMT+02")!
//        }
        tblAppointments.separatorStyle = .none
        tblAppointments.separatorColor = .lightGray
        if UIDevice.current.userInterfaceIdiom == .pad {
            popConstraint.constant = 75 // 139
        } else {
            popConstraint.constant = 75
        }

        if (whichOpenMe == 3)
        {
            lblTitle.text = "SLAIGHT_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            ordersSlightLateOfClientsArray = Array<OrderDetailsObj>()
            if Global.sharedInstance.ordersOfClientsArray.count > 0 {
                for orderClient in Global.sharedInstance.ordersOfClientsArray {
                    //                    let comparDateInSeconds = orderClient.dtDateOrder.timeIntervalSince(Date())
                    //                    print(comparDateInSeconds)
                    //                    if comparDateInSeconds > 0 {
                    //                        let secondsasint = (comparDateInSeconds / 60).rounded(.up)
                    //
                    //                        print(secondsasint)
                    //                        if secondsasint <= 10 {
                    let datetoadd10minutes = orderClient.dtDateOrder.addingTimeInterval(10.0 * 60.0) //10 minutes from event start hour
                    if  datetoadd10minutes >= Date() {
                        let comparDateInSeconds = datetoadd10minutes.timeIntervalSince(Date())
                        let secondsasint = (comparDateInSeconds / 60).rounded(.up)
                        print(secondsasint)
                        if !ordersSlightLateOfClientsArray.contains(orderClient) {
                            ordersSlightLateOfClientsArray.append(orderClient)
                        }
                    }
                }
                Global.sharedInstance.ordersOfClientsArray = Array<OrderDetailsObj>()
                Global.sharedInstance.ordersOfClientsArray = ordersSlightLateOfClientsArray
            }


        }
        else if (whichOpenMe == 1)
        {

            lblTitle.text = "LBLAPPOINTMENT_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        else
        {
            lblTitle.text = "CANCEL_APPOINTMENT_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }

        tblAppointments.reloadData()

        self.tblAppointments.separatorStyle = UITableViewCell.SeparatorStyle.none

        //        for chestie:OrderDetailsObj in Global.sharedInstance.ordersOfClientsArray
        //        {
        //            print("orderClientsArray: \(chestie)")
        //        }
        //        tblAppointments.rowHeight = UITableViewAutomaticDimension
        //        tblAppointments.estimatedRowHeight = 150
        //        self.view.backgroundColor = UIColor(red:0.96, green:0.94, blue:0.91, alpha:1.0)
        tblAppointments.backgroundColor = UIColor(red:0.96, green:0.94, blue:0.91, alpha:1.0)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return Global.sharedInstance.ordersOfClientsArray.count
        }
        else
        {
            return self.pastAppointmentsFilter.count
        }

    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }


    func numberOfSections(in tableView: UITableView) -> Int {

        if (Global.sharedInstance.ordersOfClientsArray.count > 0) {
            self.topBorderView.isHidden = false
        } else {
            self.topBorderView.isHidden = true
        }

        if whichOpenMe == 3 || whichOpenMe == 2
        {
            return 1
        }
        else
        {
            return 2
        }

    }

    //    func tableView(_ tableView: UITableView,
    //                   titleForHeaderInSection section: Int) -> String?
    //    {
    //        if section == 0
    //        {
    //            return "present"
    //        }
    //        else
    //        {
    //            return "past"
    //        }
    //    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            if whichOpenMe == 3 || whichOpenMe == 2
            {
                return 0
            }
            else
            {
                return 10
            }

        }
        else
        {
            return 0
        }


    }

    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView?
    {
        if let _ =  Bundle.main.loadNibNamed("myAppointmentsSeparator", owner: self, options: nil)?.first as? UIView
        {
            let separatorView = Bundle.main.loadNibNamed("myAppointmentsSeparator", owner: self, options: nil)?.first as! UIView
            separatorView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:30)
            return separatorView



        }
        else
        {
            return UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:30))
        }
    }

    //commit comment 2
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAppointmentTableViewCell") as! MyAppointmentTableViewCell
        let cell1 =  tableView.dequeueReusableCell(withIdentifier: "MyAppointmentWithImageTableViewCell") as! MyAppointmentWithImageTableViewCell

        if whichOpenMe == 1 {
        if indexPath.section == 0
        {
            if Global.sharedInstance.ordersOfClientsArray.indices.contains(indexPath.row) {
            var txtOrder = ""
            for order in Global.sharedInstance.ordersOfClientsArray[indexPath.row].objProviderServiceDetails
            {
                if txtOrder == ""
                {
                    txtOrder = order.nvServiceName
                }
                else
                {
                    txtOrder += ",\(order.nvServiceName)"
                }
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            var userCalendar =  Foundation.Calendar.current // user calendar
//                if let _:Int = Global.sharedInstance.ordersOfClientsArray[indexPath.row].orderTimeZone as? Int{
//                    var x = Global.sharedInstance.ordersOfClientsArray[indexPath.row].orderTimeZone
//                    if x == 3 {
//                        x = 2
//                    }
//                    let mystring = "GMT+0" + String(x)
//                    userCalendar.timeZone =  TimeZone(abbreviation: mystring)!
//
//                }
            //print(" \(daylightSavingTimeOffset(for:Global.sharedInstance.ordersOfClientsArray[indexPath.row].dtDateOrder)")
          //  userCalendar.timeZone =   TimeZone(abbreviation: "UTC")!
//             let daylightSavingTimeOffset1 = userCalendar.timeZone.daylightSavingTimeOffset()
//            // let mydifferenceoftime = daylightSavingTimeOffset1/60 // (1h)
//          //  if mydifferenceoftime == 60 {
//                userCalendar.timeZone =  TimeZone(abbreviation: "GMT+02")!
////            } else if mydifferenceoftime == 0 {
////                userCalendar.timeZone =  TimeZone(abbreviation: "GMT+03")!
////            }
                let desireddate = Global.sharedInstance.getStringFromDateString(Global.sharedInstance.ordersOfClientsArray[indexPath.row].nvFromHour)
            let dateComponents = userCalendar.dateComponents([.day, .month, .year], from: desireddate)
            var stringFormatter:String = ""
            let ENDDATE = userCalendar.date(from: dateComponents as DateComponents)!
            stringFormatter = dateFormatter.string(from:ENDDATE)

            let dateFormatterHours = DateFormatter()
            dateFormatterHours.dateFormat = "HH:mm"

            let hourS:String = dateFormatterHours.string(from: Global.sharedInstance.getStringFromDateString(Global.sharedInstance.ordersOfClientsArray[indexPath.row].nvFromHour))
            let hourE:String = dateFormatterHours.string(from: Global.sharedInstance.getStringFromDateString(Global.sharedInstance.ordersOfClientsArray[indexPath.row].nvToHour))
            cell.hourE = hourE
            // cell.hourS = hourS
            let supplierName:String = Global.sharedInstance.ordersOfClientsArray[indexPath.row].nvSupplierName
            cell.setDataMyAppointments(date: stringFormatter, hour: hourS, txt: txtOrder, supplierName: supplierName)
            cell.lblDate.textColor = .black
            cell.lblHour.textColor = .black
            cell.supplierNameLbl.textColor = .black
            cell.lblText.textColor = .black
        }
        }
        else
        {
            if pastAppointmentsFilter.indices.contains(indexPath.row) {
            var txtOrder = ""
            for order in pastAppointmentsFilter[indexPath.row].objProviderServiceDetails
            {
                if txtOrder == ""
                {
                    txtOrder = order.nvServiceName
                }
                else
                {
                    txtOrder += ",\(order.nvServiceName)"
                }
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            var userCalendar =  Foundation.Calendar.current // user calendar
//                if let _:Int = pastAppointmentsFilter[indexPath.row].orderTimeZone as? Int {
//                    var x = pastAppointmentsFilter[indexPath.row].orderTimeZone
//                    if x == 3 {
//                        x = 2
//                    }
//                    let mystring = "GMT+0" + String(x)
//                    userCalendar.timeZone =  TimeZone(abbreviation: mystring)!
//                }
                let desireddate = Global.sharedInstance.getStringFromDateString(pastAppointmentsFilter[indexPath.row].nvFromHour)
                let dateComponents = userCalendar.dateComponents([.day, .month, .year], from: desireddate)
         //   let dateComponents = userCalendar.dateComponents([.day, .month, .year], from: pastAppointmentsFilter[indexPath.row].dtDateOrder)
            var stringFormatter:String = ""
            let ENDDATE = userCalendar.date(from: dateComponents as DateComponents)!
            stringFormatter = dateFormatter.string(from:ENDDATE)


            let dateFormatterHours = DateFormatter()
            dateFormatterHours.dateFormat = "HH:mm"

            let hourS:String = dateFormatterHours.string(from: Global.sharedInstance.getStringFromDateString(pastAppointmentsFilter[indexPath.row].nvFromHour))
            let hourE:String = dateFormatterHours.string(from: Global.sharedInstance.getStringFromDateString(pastAppointmentsFilter[indexPath.row].nvToHour))
            cell.hourE = hourE
            // cell.hourS = hourS
            let supplierName:String = pastAppointmentsFilter[indexPath.row].nvSupplierName
            cell.setDataMyAppointments(date: stringFormatter, hour: hourS, txt: txtOrder, supplierName: supplierName)
            cell.lblDate.textColor = Colors.sharedInstance.color3
            cell.supplierNameLbl.textColor = Colors.sharedInstance.color3
            cell.lblText.textColor = Colors.sharedInstance.color3
            cell.lblHour.textColor = Colors.sharedInstance.color3

        }
        }
        }
        cell.backgroundColor = UIColor(red:0.96, green:0.94, blue:0.91, alpha:1.0)
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        if whichOpenMe == 2 || whichOpenMe == 3 {
           // MyAppointmentWithImageTableViewCell
                if indexPath.section == 0
                {
                    if Global.sharedInstance.ordersOfClientsArray.indices.contains(indexPath.row) {
                    var txtOrder = ""
                    for order in Global.sharedInstance.ordersOfClientsArray[indexPath.row].objProviderServiceDetails
                    {
                        if txtOrder == ""
                        {
                            txtOrder = order.nvServiceName
                        }
                        else
                        {
                            txtOrder += ",\(order.nvServiceName)"
                        }
                    }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                   // let date = dateFormatter.string(from: Global.sharedInstance.ordersOfClientsArray[indexPath.row].dtDateOrder as Date)
                    var userCalendar =  Foundation.Calendar.current // user calendar
//         //           userCalendar.timeZone = TimeZone(abbreviation: "UTC")!
//                    userCalendar.timeZone =  TimeZone(abbreviation: "GMT+02")!
//                        if let _:Int = Global.sharedInstance.ordersOfClientsArray[indexPath.row].orderTimeZone as? Int {
//                            var x = Global.sharedInstance.ordersOfClientsArray[indexPath.row].orderTimeZone
//                            if x == 3 {
//                                x = 2
//                            }
//                            let mystring = "GMT+0" + String(x)
//                            userCalendar.timeZone =  TimeZone(abbreviation: mystring)!
//                        }
//                    let dateComponents = userCalendar.dateComponents([.day, .month, .year], from: Global.sharedInstance.ordersOfClientsArray[indexPath.row].dtDateOrder)
                        let desireddate = Global.sharedInstance.getStringFromDateString(Global.sharedInstance.ordersOfClientsArray[indexPath.row].nvFromHour)
                        let dateComponents = userCalendar.dateComponents([.day, .month, .year], from: desireddate)
                    var stringFormatter:String = ""
                    if let _:Int = dateComponents.day
                    {
                        let dayInt = dateComponents.day!
                        if let _:Int = dateComponents.month
                        {
                            let monthInt = dateComponents.month!
                            if let _:Int = dateComponents.year
                            {
                                let yearInt =  dateComponents.year!
                                stringFormatter = String(dayInt) + "-" + String(monthInt) + "-" + String(yearInt)
                            }
                        }
                    }
                    let dateFormatterHours = DateFormatter()
                    dateFormatterHours.dateFormat = "HH:mm"

                    let hourS:String = dateFormatterHours.string(from: Global.sharedInstance.getStringFromDateString(Global.sharedInstance.ordersOfClientsArray[indexPath.row].nvFromHour))
                    let hourE:String = dateFormatterHours.string(from: Global.sharedInstance.getStringFromDateString(Global.sharedInstance.ordersOfClientsArray[indexPath.row].nvToHour))
                    cell1.hourE = hourE
                    // cell.hourS = hourS
                    let supplierName:String = Global.sharedInstance.ordersOfClientsArray[indexPath.row].nvSupplierName
                    cell1.setDataMyAppointments(date: stringFormatter, hour: hourS, txt: txtOrder, supplierName: supplierName)
                    cell1.lblDate.textColor = .black
                }
            if let _ = Global.sharedInstance.ordersOfClientsArray[indexPath.row].nvLogo as String? {
            let img:String = Global.sharedInstance.ordersOfClientsArray[indexPath.row].nvLogo

            let dataDecoded:Data = Data(base64Encoded: (img), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!

            var decodedimage:UIImage = UIImage()
            if UIImage(data: dataDecoded) != nil
            {
                decodedimage = UIImage(data: dataDecoded)!

                UIGraphicsBeginImageContext(cell1.imgView.frame.size)
                decodedimage.draw(in: cell1.imgView.bounds)
                let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                cell1.imgView.image = image
            }
            else
            {
                cell1.imgView.backgroundColor = Colors.sharedInstance.color4
                cell1.imgView.image = UIImage(named: "clients@x1.png")
                cell1.imgView.contentMode = .scaleAspectFit
            }
            }
            }
            return cell1
        }

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var whichArray: Array<OrderDetailsObj> = Array<OrderDetailsObj>()
        var isPastAppointment:Bool = false
        if indexPath.section == 0
        {
            whichArray = Global.sharedInstance.ordersOfClientsArray
        }
        else
        {
            whichArray = pastAppointmentsFilter
            isPastAppointment = true
        }
        switch whichOpenMe {
        case 1:
            // Format date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let theEventDate = (tableView.cellForRow(at: indexPath) as! MyAppointmentTableViewCell).lblDate.text!
            let viewCon:detailsAppointmetClientViewController = storyboard?.instantiateViewController(withIdentifier: "detailsAppointmetClientViewController") as! detailsAppointmetClientViewController
            viewCon.cancelOrderID = whichArray[indexPath.row].iCoordinatedServiceId
            viewCon.fromHour = (tableView.cellForRow(at: indexPath) as! MyAppointmentTableViewCell).lblHour.text!
            viewCon.supplierName = whichArray[indexPath.row].nvSupplierName
            viewCon.serviceName = (tableView.cellForRow(at: indexPath) as! MyAppointmentTableViewCell).lblText.text!
            viewCon.dateEvent = dateFormatter.date(from: theEventDate)!
            viewCon.specialdateEvent = whichArray[indexPath.row].dtDateOrder as Date
            viewCon.appointmentTime = "\((tableView.cellForRow(at: indexPath) as! MyAppointmentTableViewCell).lblHour.text!) - \((tableView.cellForRow(at: indexPath) as! MyAppointmentTableViewCell).hourE)"
            viewCon.appointmentLocation = whichArray[indexPath.row].nvAddress
            viewCon.isFromMyAppointments = true
            viewCon.isPastAppointment = isPastAppointment
            viewCon.iSupplierId  = whichArray[indexPath.row].iSupplierId
            viewCon.nvPhone =  whichArray[indexPath.row].nvPhone

            //  viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            if self.iOS8 {
                viewCon.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            } else {
                viewCon.modalPresentationStyle = UIModalPresentationStyle.currentContext
            }
            self.present(viewCon, animated: true, completion: nil)

            break
        case 2:
             print("hhhhhhhhh \(whichArray[indexPath.row].dtDateOrder as Date)")
             let eventdateday:Date = whichArray[indexPath.row].dtDateOrder as Date
             let distanceBetweenDates: TimeInterval? = eventdateday.timeIntervalSince(Date())
             let secondsInAnHour: Double = 3600
             let hoursBetweenDates = Int((distanceBetweenDates! / secondsInAnHour))
             print(hoursBetweenDates,"hours")//120 hours
             let newObj = DetailsAppointmentObj()
             newObj.service = (tableView.cellForRow(at: indexPath) as! MyAppointmentWithImageTableViewCell).lblText.text!
             newObj.date = (tableView.cellForRow(at: indexPath) as! MyAppointmentWithImageTableViewCell).lblDate.text!
             newObj.hour = "\((tableView.cellForRow(at: indexPath) as! MyAppointmentWithImageTableViewCell).lblHour.text!) - \((tableView.cellForRow(at: indexPath) as! MyAppointmentWithImageTableViewCell).hourE)"
             newObj.serviceName = whichArray[indexPath.row].nvSupplierName

             Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName = newObj.serviceName
             newObj.idTurn = whichArray[indexPath.row].iCoordinatedServiceId
             newObj.tag = 1
             newObj.iSupplierId  = whichArray[indexPath.row].iSupplierId
             newObj.nvPhone =  whichArray[indexPath.row].nvPhone
             if hoursBetweenDates < 24 {
                GetProviderSettingsForCalendarmanagement(_ORDEROBJ: newObj)
             } else {
                opencancel(_ORDEROBJ: newObj)
            }
            break
        case 3:
            let viewCon:slaightLateViewController = storyboard?.instantiateViewController(withIdentifier: "slaightLateViewController") as! slaightLateViewController
            viewCon.service = (tableView.cellForRow(at: indexPath) as! MyAppointmentWithImageTableViewCell).lblText.text!
            viewCon.date = (tableView.cellForRow(at: indexPath) as! MyAppointmentWithImageTableViewCell).lblDate.text!
            viewCon.hour = "\((tableView.cellForRow(at: indexPath) as! MyAppointmentWithImageTableViewCell).lblHour.text!) - \((tableView.cellForRow(at: indexPath) as! MyAppointmentWithImageTableViewCell).hourE)"
            viewCon.serviceName = whichArray[indexPath.row].nvSupplierName
            Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName = viewCon.serviceName
            viewCon.iCoordinatedServiceId = whichArray[indexPath.row].iCoordinatedServiceId
            viewCon.iSupplierId  = whichArray[indexPath.row].iSupplierId
            viewCon.nvPhone =  whichArray[indexPath.row].nvPhone
            self.present(viewCon, animated: false, completion: nil)
            break
        default:
            break
        }
    }

    func GetProviderSettingsForCalendarmanagement(_ORDEROBJ:DetailsAppointmentObj)  {
        var x:Int = 0
        let newDetailsAppointmentObj = _ORDEROBJ
        let providerID:Int = _ORDEROBJ.iSupplierId
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        self.generic.showNativeActivityIndicator(self)
        dicSearch["iProviderId"] = providerID as AnyObject
        print("aicie \(providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
            self.iHoursForPreCancelServiceByCustomer = 0
        }
        else
        {
            api.sharedInstance.GetProviderSettingsForCalendarmanagement(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    self.generic.hideNativeActivityIndicator(self)
                    print("responseObject \(responseObject ??  1 as AnyObject)")
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                            {
                                let possiblerezult:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>

                                if let _:Int = possiblerezult["iHoursForPreCancelServiceByCustomer"] as? Int {
                                    let myint:Int =  possiblerezult["iHoursForPreCancelServiceByCustomer"] as! Int
                                    if myint == 1 {
                                       x = 1
                                        self.presentPopUp24Hours(_ORDEROBJ: newDetailsAppointmentObj)
                                    } else {
                                       x = 0
                                        self.opencancel(_ORDEROBJ: newDetailsAppointmentObj)
                                    }
                                } else {
                                    x = 0
                                    self.opencancel(_ORDEROBJ: newDetailsAppointmentObj)
                                }


                            }
                        }
                    }
                    print("firstx \(x)")
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                x = 0
                 self.opencancel(_ORDEROBJ: newDetailsAppointmentObj)

            })
        }

    }
    func presentPopUp24Hours(_ORDEROBJ:DetailsAppointmentObj)
    {
        let newlistservices = UIStoryboard(name: "newlistservices", bundle: nil)
        let viewCon:PopUp24HoursViewController = newlistservices.instantiateViewController(withIdentifier: "PopUp24HoursViewController") as! PopUp24HoursViewController
        viewCon.nvPhone =  _ORDEROBJ.nvPhone
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
        return
    }
    func opencancel(_ORDEROBJ:DetailsAppointmentObj) {
        let viewCon:CancelAppointmentClientViewController = storyboard?.instantiateViewController(withIdentifier: "CancelAppointmentClientViewController") as! CancelAppointmentClientViewController
        viewCon.service = _ORDEROBJ.service
        viewCon.date = _ORDEROBJ.date
        viewCon.hour = _ORDEROBJ.hour
        viewCon.serviceName = _ORDEROBJ.serviceName
        Global.sharedInstance.orderDetailsFoBthereEvent.nvSupplierName = viewCon.serviceName
        viewCon.idTurn = _ORDEROBJ.idTurn
        viewCon.tag = 1
        viewCon.iSupplierId  = _ORDEROBJ.iSupplierId
        viewCon.nvPhone =  _ORDEROBJ.nvPhone
        self.present(viewCon, animated: false, completion: nil)
        return
    }

    
}
