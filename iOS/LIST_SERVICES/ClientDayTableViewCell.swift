//
//  ClientDayTableViewCell.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu on 24.09.2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit


class ClientDayTableViewCell: UITableViewCell {
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
        self.selectionStyle = .none
        let tapCell: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOrderTurn))
        self.addGestureRecognizer(tapCell)
        
    }
  
    
    @objc func tapOrderTurn()
    {
        print("SELFEVENT \(SELFEVENT.getDic())")
        if SELFEVENT.iDayInWeek != -1 {
        //1 selected free hour
        Global.sharedInstance.whichDesignOpenDetailsAppointment = 1 //day
       
            //2 selected existing bthere event or calendar event
            //////////  is calendar event
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
            
            self.openDetailsOrderNEW(2)
        }
    }
    
    // A function that is called when a free or busy square is clicked (according to the tag) in the log and opens the order details in the model
    func openDetailsOrderNEW(_ tag:Int)  {
        let storyboard = UIStoryboard(name: "ClientExist", bundle: nil)
        let storyBoard1:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyBoard1.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let viewController = storyboard.instantiateViewController(withIdentifier: "detailsAppointmetClientViewController") as! detailsAppointmetClientViewController
        viewController.tag = tag
        viewController.fromViewMode = false
        viewController.isfromSPECIALSUPPLIER = self.isfromSPECIALSUPPLIER
        if tag == 2 {
        viewController.iSupplierId = Global.sharedInstance.orderDetailsFoBthereEvent.iSupplierId
        viewController.nvPhone = Global.sharedInstance.orderDetailsFoBthereEvent.nvPhone
        }
        frontviewcontroller?.pushViewController(viewController, animated: false)
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
                for v in scalars {
                    // print(v.value)
                    let unicodeValue = v.value
                    if unicodeValue > 1487 && unicodeValue < 1515   {
                        print("hebr.... \(unicodeValue)")
                        isHebrewtext = true
                        break
                    }
                }

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
            self.startinghour.text = ""

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
        if (cString.count != 6) {
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
   
   
   
    
}

