//
//  ClientMakeAppoinmentTableViewCell.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu on 07.06.2017
//  Copyright © 2017 Bthere. All rights reserved.
//

import UIKit


class ClientMakeAppoinmentTableViewCell: UITableViewCell {
    var bIsAvailableForNewCustomer = 0
    var iHoursForPreCancelServiceByCustomer = 0
    var isfromSPECIALiCustomerUserId:Int = 0
    @IBOutlet weak var lblmeeting: UILabel! //contains name of meeting and start - end hours
    @IBOutlet weak var startinghour: UILabel! //start hour for service free
    var isfromSPECIALSUPPLIER:Bool = false
    var SELFEVENT:allKindEventsForListDesign = allKindEventsForListDesign() //cell event
    var delegateRegister:goToRegisterDelegate!=nil
    let calendar = Foundation.Calendar.current
    var DelegateAlert:CellShowAlertDelegate!=nil
    var iMaxServiceForCustomer:Int = 0
    var iPeriodInWeeksForMaxServices:Int = 0
    var bLimitSeries:Bool = false
    var iCustomerViewLimit:Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        let USERDEF = Global.sharedInstance.defaults
        if USERDEF.object(forKey: "isfromSPECIALiCustomerUserId") == nil {
            USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
            USERDEF.synchronize()
        } else {
            if let _:Int = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as? Int {
                let myint = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as! Int
                self.isfromSPECIALiCustomerUserId = myint
            }
        }


        GetProviderSettingsForCalendarmanagement()
        self.selectionStyle = .none
        let tapCell: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn))
        self.addGestureRecognizer(tapCell)
        
    }
    func read_iMaxServiceForCustomer() -> Int {
        
        let need_Int = self.iMaxServiceForCustomer
        return need_Int
    }
    
    @objc func tapOrderTurn()
    {
        print("SELFEVENT \(SELFEVENT.getDic())")
        //1 selected free hour
         if SELFEVENT.iDayInWeek != -1 {
        Global.sharedInstance.whichDesignOpenDetailsAppointment = 1 //day
        if SELFEVENT.iDayInWeek == 1000 {
            //     var strDate:String = ""
            Global.sharedInstance.hourFreeEvent = SELFEVENT.fromHour
            Global.sharedInstance.hourFreeEventEnd = SELFEVENT.toHour
            //   strDate = Global.sharedInstance.convertNSDateToString(SELFEVENT.dateEvent)
            
            if Global.sharedInstance.idWorker == -1
            {
                Global.sharedInstance.arrayGiveServicesKods = SELFEVENT.ARRAYiProviderUserId
            }
            
            if Global.sharedInstance.currentUser.iUserId == 0
            {
                delegateRegister.goToRegister()
            }
            else
            {
                if Global.sharedInstance.ISFROMMULTIPLEAPPOINTMENTS == false {
                    self.openDetailsOrderNEW(1)
                } else {
                    //popup multiple
                    for iten in SELFEVENT.objProviderServiceDetails {
                        
                        print ("extrage service name \(iten.getDic())")
                    }
                    let myCalendar = Foundation.Calendar(identifier: .gregorian)
                    let myComponents = (myCalendar as NSCalendar).components(.weekday, from: SELFEVENT.dateEvent)
                    let weekDay = myComponents.weekday
                    //     let uniqueVals = uniq(Global.sharedInstance.arrayServicesKodsToServer) //Global.sharedInstance.arrayServicesKodsToServer contains all ids for selected services
              //      let uniqueNames = uniq(Global.sharedInstance.multipleServiceName)
                    var titleservices = ""
                    for i in 0..<Global.sharedInstance.multipleServiceName.count  {
                        if titleservices == "" {
                            titleservices = Global.sharedInstance.multipleServiceName[i]
                        } else {
                            titleservices += ",\(Global.sharedInstance.multipleServiceName[i])"
                        }
                    }
                    var userID = Global.sharedInstance.currentUser.iUserId
                    if self.isfromSPECIALiCustomerUserId != 0 {
                        userID = self.isfromSPECIALiCustomerUserId
                    }
                    //iustin modified
                    
//                    let orderdetails:OrderDetailsObj = OrderDetailsObj(
//                        _iCoordinatedServiceId : SELFEVENT.iCoordinatedServiceId,
//                        _iProviderUserId : SELFEVENT.iProviderUserId,
//                        _nvFirstName: SELFEVENT.ClientnvFullName,
//                        _nvSupplierName :  Global.sharedInstance.currentProviderToCustomer.nvProviderName,
//                        _objProviderServiceDetails : SELFEVENT.objProviderServiceDetails,
//                        _iDayInWeek : weekDay!,//SELFEVENT.iDayInWeek
//                        _dtDateOrder : SELFEVENT.dateEvent,
//                        _nvFromHour : SELFEVENT.fromHour,
//                        _nvToHour : SELFEVENT.toHour,
//                        _nvAddress :  Global.sharedInstance.currentProviderToCustomer.nvAdress,
//                        _nvComment : SELFEVENT.nvComment,
//                        _nvLogo : SELFEVENT.nvLogo,
//                        _iUserId : userID,
//                        _title: titleservices,
//                        _chServiceColor:"",
//                        _iSupplierId: Global.sharedInstance.providerID,
//                        _iCoordinatedServiceStatusType:  1,
//                        _nvLastName: "",
//                        _nvPhone: SELFEVENT.nvPhone
//                    )
                    var orderdetails:OrderDetailsObj = OrderDetailsObj()
                    if Global.sharedInstance.arrayGiveServicesKods.count > 0
                    {
                         orderdetails = OrderDetailsObj(
                            _iCoordinatedServiceId : SELFEVENT.iCoordinatedServiceId,
                            _iProviderUserId : Global.sharedInstance.arrayGiveServicesKods[0],
                            _nvFirstName: SELFEVENT.ClientnvFullName,
                            _nvSupplierName :  Global.sharedInstance.currentProviderToCustomer.nvProviderName,
                            _objProviderServiceDetails : SELFEVENT.objProviderServiceDetails,
                            _iDayInWeek : weekDay!,//SELFEVENT.iDayInWeek
                            _dtDateOrder : SELFEVENT.dateEvent,
                            _nvFromHour : SELFEVENT.fromHour,
                            _nvToHour : SELFEVENT.toHour,
                            _nvAddress :  Global.sharedInstance.currentProviderToCustomer.nvAdress,
                            _nvComment : SELFEVENT.nvComment,
                            _nvLogo : SELFEVENT.nvLogo,
                            _iUserId : userID,
                            _title: titleservices,
                            _chServiceColor:"",
                            _iSupplierId: Global.sharedInstance.providerID,
                            _iCoordinatedServiceStatusType:  1,
                            _nvLastName: "",
                            _nvPhone: SELFEVENT.nvPhone
                        )
                    }
                    else
                    {
                                             orderdetails = OrderDetailsObj(
                                                _iCoordinatedServiceId : SELFEVENT.iCoordinatedServiceId,
                                                _iProviderUserId : SELFEVENT.iProviderUserId,
                                                _nvFirstName: SELFEVENT.ClientnvFullName,
                                                _nvSupplierName :  Global.sharedInstance.currentProviderToCustomer.nvProviderName,
                                                _objProviderServiceDetails : SELFEVENT.objProviderServiceDetails,
                                                _iDayInWeek : weekDay!,//SELFEVENT.iDayInWeek
                                                _dtDateOrder : SELFEVENT.dateEvent,
                                                _nvFromHour : SELFEVENT.fromHour,
                                                _nvToHour : SELFEVENT.toHour,
                                                _nvAddress :  Global.sharedInstance.currentProviderToCustomer.nvAdress,
                                                _nvComment : SELFEVENT.nvComment,
                                                _nvLogo : SELFEVENT.nvLogo,
                                                _iUserId : userID,
                                                _title: titleservices,
                                                _chServiceColor:"",
                                                _iSupplierId: Global.sharedInstance.providerID,
                                                _iCoordinatedServiceStatusType:  1,
                                                _nvLastName: "",
                                                _nvPhone: SELFEVENT.nvPhone
                                            )
                    }
                    //  let nameservicex = self.try_to_get_all_names_of_services(uniqueVals)

                    
                    let numberofmaxAppointmentspermited = read_iMaxServiceForCustomer()
                    if Global.sharedInstance.ordersOfClientsTemporaryArray.count == numberofmaxAppointmentspermited {
                        DelegateAlert.showalertx()
                    } else {
                        
                        if !Global.sharedInstance.ordersOfClientsTemporaryArray.contains(orderdetails) {
                            Global.sharedInstance.ordersOfClientsTemporaryArray.append(orderdetails)
                        }
                    }
                    
                    var filteredarray:Array<OrderDetailsObj> =  Array<OrderDetailsObj>()
                    filteredarray =   Global.sharedInstance.ordersOfClientsTemporaryArray.sorted(by: { ($1 ).dtDateOrder  > ($0 ).dtDateOrder })
                    Global.sharedInstance.ordersOfClientsTemporaryArray = filteredarray
                    
                    
                    openMultiple()
                }
                
            }
        }
        else
        {
            //2 selected existing bthere event o calendar event
            //////////  is calendar event will not reach anyway this because of upper != -1
            if SELFEVENT.iDayInWeek == -1 && SELFEVENT.objProviderServiceDetails.count == 0{
                let emptyfottitle:ProviderServiceDetailsObj = ProviderServiceDetailsObj(
                    _iProviderServiceId: 0,
                    _nvServiceName: SELFEVENT.title,
                    _chServiceColor:""
                    
                )
                if !SELFEVENT.objProviderServiceDetails.contains(emptyfottitle) {
                    SELFEVENT.objProviderServiceDetails.append(emptyfottitle)
                }
            }
            ///////// is bthere event
            for iten in SELFEVENT.objProviderServiceDetails {
                
                print ("extrage service name \(iten.getDic())")
            }
            Global.sharedInstance.hourBthereEvent = SELFEVENT.fromHour
            Global.sharedInstance.hourBthereEventEnd = SELFEVENT.toHour
            Global.sharedInstance.dateEventBthereClick = SELFEVENT.dateEvent
            let orderdetails:OrderDetailsObj = OrderDetailsObj(
                _iCoordinatedServiceId : SELFEVENT.iCoordinatedServiceId,
                _iProviderUserId : SELFEVENT.iProviderUserId,
                _nvFirstName: SELFEVENT.ClientnvFullName,
                _nvSupplierName : SELFEVENT.nvSupplierName,
                _objProviderServiceDetails : SELFEVENT.objProviderServiceDetails,
                _iDayInWeek : SELFEVENT.iDayInWeek,
                _dtDateOrder : SELFEVENT.dateEvent,
                _nvFromHour : SELFEVENT.fromHour,
                _nvToHour : SELFEVENT.toHour,
                _nvAddress : SELFEVENT.nvAddress,
                _nvComment : SELFEVENT.nvComment,
                _nvLogo : SELFEVENT.nvLogo,
                _iUserId : SELFEVENT.iUserId,
                _title:"",
                _chServiceColor:"",
                _iSupplierId: SELFEVENT.iSupplierId,
                _iCoordinatedServiceStatusType:  1,
                _nvLastName: "",
                _nvPhone: SELFEVENT.nvPhone
            )
            Global.sharedInstance.orderDetailsFoBthereEvent = orderdetails
            print("order details here: \(orderdetails.getDic())")
            self.openDetailsOrderNEW(2)
            
        }
        }
    }
    
    // A function that is called when a free or busy square is clicked (according to the tag) in the log and opens the order details in the model
    func openDetailsOrderNEW(_ tag:Int)  {
        let USERDEF = Global.sharedInstance.defaults
        print("aici userdef: \(String(describing: USERDEF.value(forKey: "isfromSPECIALiCustomerUserId")))")
        let storyboard = UIStoryboard(name: "ClientExist", bundle: nil)
        let storyBoard1:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyBoard1.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let viewController = storyboard.instantiateViewController(withIdentifier: "detailsAppointmetClientViewController") as! detailsAppointmetClientViewController
        viewController.tag = tag
        viewController.fromViewMode = false
        viewController.isfromSPECIALSUPPLIER = self.isfromSPECIALSUPPLIER
        if let _ = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as? Int
        {
            viewController.isfromSPECIALiCustomerUserId = USERDEF.value(forKey: "isfromSPECIALiCustomerUserId") as! Int
        }
        if tag == 2 {
            viewController.iSupplierId = Global.sharedInstance.orderDetailsFoBthereEvent.iSupplierId
            viewController.nvPhone = Global.sharedInstance.orderDetailsFoBthereEvent.nvPhone
        }
        frontviewcontroller?.pushViewController(viewController, animated: false)
        //initialize REAR View Controller- it is the LEFT hand menu.
        let rearViewController = storyBoard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    func goToRegister(){
        
    }
    func setDisplayData(_ st:String, aPERMISSIONSArray:NSMutableArray, myuser:User,myservice:objProviderServices){
        
    }
    func setEventData(_ myeventis:allKindEventsForListDesign) {
        print("myeventis  \(myeventis.getDic())")
        SELFEVENT = myeventis
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .pad {
            self.lblmeeting.font = UIFont (name: "OpenSansHebrew-Bold", size: 21)

        } else {
            self.lblmeeting.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)

        }
        /*
         myeventis  ["title": , "nvComment": , "nvAddress": , "dateEvent": 2017-06-10 21:00:00 +0000, "iCoordinatedServiceId": 0, "iCancelalliUserId": <Swift._SwiftDeferredNSArray 0x170230100>(
         
         )
         , "tag": 0, "ClientnvFullName": , "nvServiceName": , "specialDate": /Date(1497128400000+0300)/, "iProviderUserId": 0, "nvSupplierName": , "toHour": 16:28, "ARRAYiProviderUserId": <Swift._SwiftDeferredNSArray 0x17082cc80>(
         569
         )
         "iDayInWeek": 1000, "fromHour": 16:14, "isCancelGroup": 0, "iCancelallCoordinatedServiceIds": <Swift._SwiftDeferredNSArray 0x17083f8a0>
         */
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            self.startinghour.textAlignment = .right
        }

        if myeventis.iDayInWeek == 1000 {
            //this is free time of appointment
            self.lblmeeting.text = ""
            self.backgroundColor = Colors.sharedInstance.color4
            self.startinghour.text = myeventis.fromHour
        }
        /*   eventPhone ["title": Alt evebt ddgg, "nvComment": , "nvAddress": , "dateEvent": 2017-06-11 12:00:00 +0000, "iCoordinatedServiceId": 0, "iCancelalliUserId": <Swift._SwiftDeferredNSArray 0x1708386c0>(
         
         )
         , "tag": 2, "ClientnvFullName": , "nvServiceName": , "specialDate": , "iProviderUserId": 0, "nvSupplierName": , "toHour": 16:00, "ARRAYiProviderUserId": <Swift._SwiftDeferredNSArray 0x1708386a0>(
         
         )
         , "iDayInWeek": -1, "fromHour": 15:00, "isCancelGroup": 0, "iCancelallCoordinatedServiceIds": <Swift._SwiftDeferredNSArray 0x1708394e0>(
         
         )
         */
        //this is calendar
        if myeventis.iDayInWeek == -1 {
            var isHebrewtext:Bool = false
            let scalars = myeventis.title.unicodeScalars
            for element in scalars {
                // print(v.value)
                let unicodeValue = element.value
                if unicodeValue > 1487 && unicodeValue < 1515   {
                    print("hebr.... \(unicodeValue)")
                    isHebrewtext = true
                    break
                }
            }
            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                if isHebrewtext == false {
                    self.lblmeeting.text = myeventis.title + " " +  myeventis.fromHour + "- " + myeventis.toHour
                } else {
                    self.lblmeeting.text =   myeventis.toHour +  " - "  + myeventis.fromHour +  " " + myeventis.title
                }
            } else {
                if isHebrewtext == false {
                    self.lblmeeting.text = myeventis.fromHour + " - "  + myeventis.toHour + " " +  myeventis.title
                } else {
                    self.lblmeeting.text =    myeventis.title   +  " " + myeventis.toHour +  " - "  + myeventis.fromHour
                }
            }
            self.lblmeeting.textColor = Colors.sharedInstance.greenforsyncedincalendar
            self.backgroundColor = UIColor.clear
            self.startinghour.text = ""
        }
        /*
         "title": , "nvComment": , "nvAddress": Golani Street, 12, "dateEvent": 2017-06-11 16:06:00 +0000, "iCoordinatedServiceId": 266, "iCancelalliUserId": <Swift._SwiftDeferredNSArray 0x17083be20>(
         
         )
         , "tag": 1, "ClientnvFullName": , "nvServiceName": , "specialDate": , "iProviderUserId": 569, "nvSupplierName": Maayan Fitness, "toHour": 19:20, "ARRAYiProviderUserId": <Swift._SwiftDeferredNSArray 0x17083be60>(
         
         )
         , "iDayInWeek": 1, "fromHour": 19:06, "isCancelGroup": 0, "iCancelallCoordinatedServiceIds": <Swift._SwiftDeferredNSArray 0x17083bde0>(
         
         )
         */
        if myeventis.iDayInWeek > 0 &&   myeventis.iDayInWeek != 1000 {
            //this is bthere meeting
            
            
            
            if myeventis.nvComment == "BlockedBySupplier" {
                myeventis.title  = "BlockedBySupplier"
                if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                    self.lblmeeting.text = myeventis.title + " " +  myeventis.fromHour + "- " + myeventis.toHour
                } else {
                    self.lblmeeting.text = myeventis.fromHour + " - " + myeventis.toHour + " "  + myeventis.title
                }

                self.lblmeeting.textColor = Colors.sharedInstance.redforblockinghours
            } else {
                let currentDateTime = Date()
                //                print("current date: \(currentDateTime)")
                if currentDateTime >  myeventis.dateEvent
                {
                    self.lblmeeting.textColor = .orange
                }
                else
                {
                    self.lblmeeting.textColor = .black
                }
                var isHebrewtext:Bool = false
                let scalars = myeventis.nvServiceName.unicodeScalars
                for element in scalars {
                    // print(v.value)
                    let unicodeValue = element.value
                    if unicodeValue > 1487 && unicodeValue < 1515   {
                        print("hebr.... \(unicodeValue)")
                        isHebrewtext = true
                        break
                    }
                }
//good
                if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                    if isHebrewtext == false {
                        self.lblmeeting.text = myeventis.nvServiceName + " " +  myeventis.fromHour + "- " + myeventis.toHour
                    } else {
                        self.lblmeeting.text =   myeventis.toHour +  " - "  + myeventis.fromHour +  " " + myeventis.nvServiceName
                    }
                } else {
                    if isHebrewtext == false {
                        self.lblmeeting.text = myeventis.fromHour + " - "  + myeventis.toHour + " " +  myeventis.nvServiceName
                    } else {
                        self.lblmeeting.text =    myeventis.nvServiceName   +  " " + myeventis.toHour +  " - "  + myeventis.fromHour
                    }
                }
            }
            
            self.backgroundColor = UIColor.clear
            // self.backgroundColor = colorWithHexString(myeventis.chServiceColor)
            self.startinghour.text = ""
            // self.lblmeeting.textColor = getComplementaryForColor(self.backgroundColor!)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func layoutSubviews() {
        
        
    }
    func getComplementaryForColor(_ color: UIColor) -> UIColor {
        
        let ciColor = CIColor(color: color)
        
        // get the current values and make the difference from white:
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue
        
        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
    }
    func colorWithHexString (_ hex:String) -> UIColor {

        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        print("cString \(cString)")
        if String(cString) == "#EAEAEA" || String(cString) == "EAEAEA" {
            
            cString = "#FF3300"
        }
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        if (cString.characters.count != 6) {
            // return UIColor.grayColor()
            cString = "#E60073"
        }
        
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    //JMOD ADD 02/02/2018
    func openMultiple() {
        //MultipleAppontmentsViewController
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyboard1.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        
        let testStoryBoard = UIStoryboard(name: "Testing", bundle: nil)
        let multipleAppointments:MultipleAppointmentsViewController = testStoryBoard.instantiateViewController(withIdentifier: "MultipleAppointmentsViewController")as! MultipleAppointmentsViewController
        multipleAppointments.ISFROMSPECIALSUPPLIER = self.isfromSPECIALSUPPLIER
        let USERDEF = Global.sharedInstance.defaults
        USERDEF.set(self.isfromSPECIALiCustomerUserId, forKey: "isfromSPECIALiCustomerUserId")
        USERDEF.synchronize()
    //\\    multipleAppointments.isfromSPECIALiCustomerUserId = self.isfromSPECIALiCustomerUserId
        frontviewcontroller?.pushViewController(multipleAppointments,animated: false)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
        
    }
    //an ideea left here for future
    func try_to_get_all_names_of_services(_ arrayCodesOfServices:Array<Int>) -> String {
        var nameofservices:String = ""
        let aarrayCodesOfServicesrecived:Array<Int> = arrayCodesOfServices
        let ARRAYOFSERVICESFORPROVIDER = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjProviderServices
        //  let ARRAYNAMESOFSERVICESFORPROVIDER = Global.sharedInstance.multipleServiceName
        for item in ARRAYOFSERVICESFORPROVIDER {
            print("sony \(item.iProviderServiceId)")
            if aarrayCodesOfServicesrecived.contains(item.iProviderServiceId) {
                if nameofservices == ""
                {
                    nameofservices = item.nvServiceName
                }
                else
                {
                    nameofservices += ",\(item.nvServiceName)"
                }
            }
        }
        return nameofservices
    }
    func GetProviderSettingsForCalendarmanagement() {
        let USERDEF = UserDefaults.standard
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dictionaryForServer["iProviderId"] = providerID as AnyObject
        print("aicie \(providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetProviderSettingsForCalendarmanagement(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in       //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject>
                            {
                                let possiblerezult:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                                if let _:Bool = possiblerezult["bLimitSeries"] as? Bool {
                                    self.bLimitSeries = possiblerezult["bLimitSeries"] as! Bool
                                }
                                if self.bLimitSeries == false { //defaults 26 in 52 weeks...means multiple once
                                    self.iMaxServiceForCustomer = 26
                                    self.iPeriodInWeeksForMaxServices = 52
                                } else {
                                    if let _:Int = possiblerezult["iMaxServiceForCustomer"] as? Int {
                                        self.iMaxServiceForCustomer = possiblerezult["iMaxServiceForCustomer"] as! Int
                                        if self.iMaxServiceForCustomer == 0 {
                                            self.iMaxServiceForCustomer = 3
                                        }
                                    } else {
                                        self.iMaxServiceForCustomer = 3
                                    }
                                    //                                    var  calset:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                    //                                    calset = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.calendarProperties.getDic()
                                    //                                    print(") what cal \(calset)")
                                    //                                    if let _:Int = calset["iPeriodInWeeksForMaxServices"] as? Int {
                                    //                                       self.iPeriodInWeeksForMaxServices = calset["iPeriodInWeeksForMaxServices"] as! Int
                                    //                                            if  self.iPeriodInWeeksForMaxServices == 0 {
                                    //                                                self.iPeriodInWeeksForMaxServices  = 6
                                    //                                            }
                                    //                                        }
                                    //                                    else {
                                    if let _:Int = possiblerezult["iPeriodInWeeksForMaxServices"] as? Int {
                                        self.iPeriodInWeeksForMaxServices = possiblerezult["iPeriodInWeeksForMaxServices"] as! Int
                                        if  self.iPeriodInWeeksForMaxServices == 0 {
                                            self.iPeriodInWeeksForMaxServices  = 6
                                        }
                                    } else {
                                        self.iPeriodInWeeksForMaxServices = 6
                                    }
                                    //                                    }
                                }
                                if let _:Int = possiblerezult["iCustomerViewLimit"] as? Int {
                                    self.iCustomerViewLimit = possiblerezult["iCustomerViewLimit"] as! Int
                                }
                                if self.iCustomerViewLimit == 0 {
                                    self.iCustomerViewLimit = 52
                                }
                                if let _:Bool = possiblerezult["bIsAvailableForNewCustomer"] as? Bool {
                                    let myint:Bool =  possiblerezult["bIsAvailableForNewCustomer"] as! Bool
                                    if myint == true {
                                        self.bIsAvailableForNewCustomer = 1
                                    } else {
                                        self.bIsAvailableForNewCustomer = 0
                                    }
                                }
                                if let _:Int = possiblerezult["iHoursForPreCancelServiceByCustomer"] as? Int {
                                    let myint:Int =  possiblerezult["iHoursForPreCancelServiceByCustomer"] as! Int
                                    if myint == 1 {
                                        self.iHoursForPreCancelServiceByCustomer = 1
                                    } else {
                                        self.iHoursForPreCancelServiceByCustomer = 0
                                    }
                                }
                                USERDEF.set(self.iCustomerViewLimit, forKey: "CALENDARWEEKSFORSUPPLIER")
                                USERDEF.set(self.iMaxServiceForCustomer, forKey: "MAXSERVICEFORCUSTOMER")
                                USERDEF.set(self.iPeriodInWeeksForMaxServices , forKey: "WEEKSFORSUPPLIER")
                                USERDEF.set(self.bIsAvailableForNewCustomer, forKey: "bIsAvailableForNewCustomer")
                                USERDEF.set(self.iHoursForPreCancelServiceByCustomer, forKey: "iHoursForPreCancelServiceByCustomer")
                                USERDEF.synchronize()
                            }
                        } else {
                            //user was not found
                            self.SETUPDEFAULTSINCASEOFFAILURE()
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.SETUPDEFAULTSINCASEOFFAILURE()
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    func SETUPDEFAULTSINCASEOFFAILURE() {
        let USERDEF = UserDefaults.standard
        self.iMaxServiceForCustomer = 3
        self.iPeriodInWeeksForMaxServices = 6
        self.iCustomerViewLimit = 52
        USERDEF.set(self.iCustomerViewLimit, forKey: "CALENDARWEEKSFORSUPPLIER")
        USERDEF.set(self.iMaxServiceForCustomer, forKey: "MAXSERVICEFORCUSTOMER")
        USERDEF.set(self.iPeriodInWeeksForMaxServices , forKey: "WEEKSFORSUPPLIER")
        USERDEF.synchronize()
    }
    
}

