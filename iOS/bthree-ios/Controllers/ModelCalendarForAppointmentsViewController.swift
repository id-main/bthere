//
//  ModelCalendarForAppointmentsViewController.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/22/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import MarqueeLabel
import Kronos

protocol selectWorkerDelegate{

    func selectWorker(_ text:String)
}
protocol openFromMenuDelegate
{
    func openFromMenu(_ con:UIViewController)
}
protocol setDateDelegate {
    func setDateClick(_ date:Date)
}
protocol openMonthDelegte {
    func openMonthFromChooseWorker()
}

protocol goToRegisterDelegate {
    func goToRegister()
}
//מודל תצוגת יומנים - של ספק שהלקוח רואה
class ModelCalendarForAppointmentsViewController: NavigationModelViewController,selectWorkerDelegate,openFromMenuDelegate,UIGestureRecognizerDelegate,clickToDayDelegate,clickToDayInWeekDelegate,openDetailsOrderDelegate,openMonthDelegte,goToRegisterDelegate{
    var SERVERTIME:Date = Date()
    @IBOutlet weak var CentralButton:UIView!
    @IBOutlet weak var  CentralButtonImg:UIImageView!
    @IBOutlet weak var butonwidth: NSLayoutConstraint!
    var isfromSPECIALiCustomerUserId:Int = 0
    var isfromSPECIALSUPPLIER:Bool = false
    @IBOutlet var carousel: iCarousel!
    var delegateSetDate:setDateDelegate!=nil
    var delegateReload:reloadTblDelegate!=nil
    var delegate:hideTableDelegate!=nil
    var HeightView: CGFloat  = CGFloat()
    var storyboard1:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    @IBOutlet weak var lblChooseWorker: UILabel!

    // @IBOutlet weak var lblAdvertising: UILabel!
    @IBOutlet weak var lblName: UILabel!

    @IBOutlet weak var lblLogo: UIImageView!

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet var newsDealsLabel: MarqueeLabel!
    @IBOutlet weak var imgOpenPlusEnglish: UIImageView!

    var btnDayClick:UIButton = UIButton()
    var x = 0
    var view1 : MonthClientForAppointmentDesignViewController!
    var view3 :weekClientForAppointmentDesign12ViewController!//weekClientForAppointmentDesignViewController!
    var view4 :dayClientForAppointment12ViewController!//dayClientForAppointmentDesignViewController!
    var attributedString = NSMutableAttributedString(string:"")
    var subView = UIView()
    var selectedView:UIViewController = UIViewController()
    var filterSubArr:Array<String> = []
    let generic:Generic = Generic()


    var isAuto = false

    var viewCon:ChooseWorkerTableViewController!

    @IBOutlet var imgPlusMenu: UIImageView!
    var attrs = [
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Bold", size: 23)!,
        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black,
        convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : 1] as [String : Any]
    var attrsDeselect = [
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) :UIFont(name: "OpenSansHebrew-Light", size: 23)!]
    @IBOutlet var imgMenu: UIImageView!

    @objc func tick() {
        print(Clock.now) // Note that this clock will get more accurate as
        // more NTP servers respond.
    }
    //לחיצה על הלשונית חודש
    @IBAction func btnMonth(_ sender: UIButton) {

        if sender.tag == 0 || selectedView == view1
        {
            Clock.sync { date, offset in
                // This is the first sync (note that this is the fastest but not the
                // most accurate run
//                print(date)
                print(Date())
                let timeZone = NSTimeZone.system
                if let _ = date
                {
                     let timeZoneOffset = timeZone.secondsFromGMT(for: date!) / 3600
                    print(timeZoneOffset, "hours offset for timezone", timeZone)
                }
               
                

            }
            //            Timer.scheduledTimer(timeInterval: 1.0, target: self,
            //                                                   selector: #selector(self.tick),
            //                                                   userInfo: nil, repeats: true)

            //            print(Date())
            //            let date = Date()
            //            let dateFormatter = DateFormatter()
            //        //    dateFormatter.timeZone = TimeZone.current
            //            dateFormatter.timeZone  = TimeZone(abbreviation: "GMT+02")!
            //           // dateFormatter.locale = NSLocale.current
            //            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Specify your format that you want
            //          //  dateFormatter.
            //            let strDate = dateFormatter.string(from: date)
            //            let mydate = dateFormatter.date(from: strDate)
            //            let mycalendar = Foundation.Calendar.current
            //            let componentsCurrent = mycalendar.dateComponents([.hour], from: mydate!)
            //            if componentsCurrent.hour! < 22 {
            //            let anotherdate = mycalendar.date(byAdding: .minute, value: 120, to: mydate!)
            //            Calendar.sharedInstance.carrentDate = anotherdate! //.getrealdate()
            //            } else {
            //  Calendar.sharedInstance.carrentDate = mydate! //.getrealdate()
            //    }
            Calendar.sharedInstance.carrentDate = self.SERVERTIME/*Date()*/
            SelectDesighnedBtn(sender)
            sender.tag = 1
            SelectSingleForMonthly()
            //  selectedView.view.removeFromSuperview()
            //   self.view.addSubview(view1.view)

            //\\

            view1.view.isHidden = false
            view3.view.isHidden = true
            view4.view.isHidden = true
            self.view.bringSubviewToFront(view1.view)
            selectedView = view1
            DispatchQueue.main.async(execute: { () -> Void in
                self.view1.bestmode()
                self.view1.view.setNeedsDisplay()
            })
        }
        else
        {
            sender.tag = 0
            sender.backgroundColor = Colors.sharedInstance.color7
            DeSelectDesighnedBtn(sender)
            //selectedView = view2
        }

    }
    @IBOutlet var btnMonth: UIButton!
    //לחיצה על הלשונית שבוע
    @IBAction func btnWeek(_ sender: UIButton)
    {
        if sender.tag == 0 || selectedView == view3
        {
            SelectDesighnedBtn(sender)
            sender.tag = 1
            SelectSingleForWeek()
            if selectedView == view1//חודש
            {
                Global.sharedInstance.currDateSelected = self.SERVERTIME/*Date()*/
                view3.initDateOfWeek(Global.sharedInstance.currDateSelected)

            }
            else//יום
            {
                //j+
                Global.sharedInstance.currDateSelected = self.SERVERTIME/*Date()*/
                //j-
                view3.initDateOfWeek(Global.sharedInstance.currDateSelected)
            }

            view1.view.isHidden = true
            view3.view.isHidden = false
            view4.view.isHidden = true
            self.view.bringSubviewToFront(view3.view)
            selectedView = view3
            DispatchQueue.main.async(execute: { () -> Void in
                self.view3.bestmode()
                self.view3.view.setNeedsDisplay()
            })


        }
        else{
            sender.tag = 0
            DeSelectDesighnedBtn(sender)
            sender.backgroundColor = Colors.sharedInstance.color8
        }
    }
    @IBOutlet var btnWeek: UIButton!
    //לחיצה על הלשונית יום
    @IBAction func btnDay(_ sender: UIButton) {

        if sender.tag == 0 || selectedView == view4{
            SelectDesighnedBtn(sender)
            sender.tag = 1
            btnDayClick = sender
            SelectSingleForDay()
            Global.sharedInstance.dateDayClick = self.SERVERTIME/*Date()*/
            Global.sharedInstance.currDateSelected = self.SERVERTIME/*Date()*/
            view4.initDate(Global.sharedInstance.currDateSelected)
            view1.view.isHidden = true
            view3.view.isHidden = true
            view4.view.isHidden = false
            self.view.bringSubviewToFront(view4.view)
            selectedView = view4
            DispatchQueue.main.async(execute: { () -> Void in
                self.view4.bestmode()
                self.view4.view.setNeedsDisplay()
            })
            self.delegateSetDate = Global.sharedInstance.dayDesigncalendarAppointment12
            delegateSetDate.setDateClick(Global.sharedInstance.dateDayClick as Date)
        }
        else{
            sender.tag = 0
            DeSelectDesighnedBtn(sender)
            sender.backgroundColor = Colors.sharedInstance.color9
        }
    }
    @IBOutlet var btnDay: UIButton!

    //  @IBOutlet weak var btnOpenTbl: UIButton!

    //MARK: - Initial
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Global.sharedInstance.isInMeetingProcess = 1
        GoogleAnalyticsSendEvent(x:12)
        self.getnews()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        Global.sharedInstance.isInMeetingProcess = 0
        
    }
    func getnews(){
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            var y:Int = 0
            if let _:NSDictionary =  (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary) {
                let a:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
                dic["iUserId"] = y as AnyObject
            }
            api.sharedInstance.GetNewsAndUpdates(dic,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                        Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else{
                        if let abcd = RESPONSEOBJECT["Result"] as? String {
                            self.newsDealsLabel.tag = 101
                            self.newsDealsLabel.type = .continuous
                            self.newsDealsLabel.animationCurve = .linear
                            self.newsDealsLabel.type = .leftRight
                            self.newsDealsLabel.text  = abcd
                            self.newsDealsLabel.restartLabel()
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                if AppDelegate.showAlertInAppDelegate == false
//                {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
            })
        }
    }
    @objc func openPlusMenuNewCustomer(){
        if let _ =  Bundle.main.loadNibNamed("PlusMenu3CirclesNewCustomer", owner: self, options: nil)?.first as? PlusMenuNewCustomer
        {
            let openpopmenu = Bundle.main.loadNibNamed("PlusMenu3CirclesNewCustomer", owner: self, options: nil)?.first as! PlusMenuNewCustomer
            openpopmenu.frame = self.view.frame
            self.view.addSubview(openpopmenu)
            self.view.bringSubviewToFront(openpopmenu)
        }
    }
    @objc func openPlusMenuNewProvider(){
        if let _ =  Bundle.main.loadNibNamed("PlusMenuNewSupplier", owner: self, options: nil)?.first as? PlusMenuNewSupplier
        {
            let openpopmenu = Bundle.main.loadNibNamed("PlusMenuNewSupplier", owner: self, options: nil)?.first as! PlusMenuNewSupplier
            openpopmenu.frame = self.view.frame
            self.view.addSubview(openpopmenu)
            self.view.bringSubviewToFront(openpopmenu)
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad {
            butonwidth.constant = 80
        } else {
            butonwidth.constant = 70
        }
        changeSizeAdjastDevice()
        HeightView = 90

        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
            HeightView = 70
        }
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
        print("ce user global id avem \(self.isfromSPECIALiCustomerUserId)")
        print("e din suplier special \(self.isfromSPECIALSUPPLIER)")

        //  if Global.sharedInstance.rtl
        // let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ModelCalendarForAppointmentsViewController.imageTapped))

        if isfromSPECIALSUPPLIER == true {
            let tapOpenPlusMenuNewProvider:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPlusMenuNewProvider))
            tapOpenPlusMenuNewProvider.delegate = self
            CentralButton.addGestureRecognizer(tapOpenPlusMenuNewProvider)
            CentralButtonImg.image = UIImage(named: "Plus menu icon - Supplier")

            //            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
            //            {
            //                imgPlusMenu.image = UIImage(named: "plushebrewsupplier.png")
            //                imgPlusMenu.isHidden = false
            //                imgPlusMenu.isUserInteractionEnabled = true
            //                imgOpenPlusEnglish.isHidden = true
            //                imgOpenPlusEnglish.isUserInteractionEnabled = false
            //                imgPlusMenu.addGestureRecognizer(tapGestureRecognizer)
            //
            //            }
            //            else
            //            {
            //                imgOpenPlusEnglish.image = UIImage(named: "plushebrewsupplier.png")
            //                imgOpenPlusEnglish.isHidden = false
            //                imgOpenPlusEnglish.isUserInteractionEnabled = true
            //                imgPlusMenu.isHidden = true
            //                imgPlusMenu.isUserInteractionEnabled = true
            //                imgOpenPlusEnglish.addGestureRecognizer(tapGestureRecognizer)
            //
            //            }
        } else {
            let tapOpenPlusMenuNewCustomer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPlusMenuNewCustomer))
            tapOpenPlusMenuNewCustomer.delegate = self
            CentralButton.addGestureRecognizer(tapOpenPlusMenuNewCustomer)
            CentralButtonImg.image = UIImage(named: "Plus menu icon - Customer")

            //            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
            //            {
            //
            //                imgPlusMenu.image = UIImage(named: "plushebrewcustomer.png")
            //                imgPlusMenu.isHidden = false
            //                imgPlusMenu.isUserInteractionEnabled = true
            //                imgOpenPlusEnglish.isHidden = true
            //                imgOpenPlusEnglish.isUserInteractionEnabled = false
            //                imgPlusMenu.addGestureRecognizer(tapGestureRecognizer)
            //
            //            }
            //            else
            //            {
            //                imgOpenPlusEnglish.image = UIImage(named: "plushebrewcustomer.png")
            //                imgOpenPlusEnglish.isHidden = false
            //                imgOpenPlusEnglish.isUserInteractionEnabled = true
            //                imgPlusMenu.isHidden = true
            //                imgPlusMenu.isUserInteractionEnabled = true
            //                imgOpenPlusEnglish.addGestureRecognizer(tapGestureRecognizer)
            //            }
        }

        if Global.sharedInstance.giveServiceName != ""{
            lblChooseWorker.text = Global.sharedInstance.giveServiceName
        }
        else
        {
            lblChooseWorker.text = "CHOOSE_GIVE_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }

        Global.sharedInstance.isSyncWithGoogleCalendarAppointment = Global.sharedInstance.currentUser.bIsGoogleCalendarSync
        btnMonth.setTitle("DESIGN_MONTH".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnWeek.setTitle("DESIGN_WEEK".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay.setTitle("DESIGN_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        Global.sharedInstance.calendarAppointment = self
        btnDayClick.titleLabel?.text = "יום"
        lblName.text = Global.sharedInstance.currentProviderToCustomer.nvProviderName
        lblDescription.text = Global.sharedInstance.currentProviderToCustomer.nvProviderSlogan

        var decodedimage:UIImage = UIImage()
        let dataDecoded:Data = Data(base64Encoded: (Global.sharedInstance.currentProviderToCustomer.nvProviderLogo), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        if UIImage(data: dataDecoded) != nil
        {
            decodedimage = UIImage(data: dataDecoded)!
            lblLogo.image = decodedimage
            lblLogo.contentMode = .scaleAspectFit
        }
        else
        {
            lblLogo.backgroundColor = Colors.sharedInstance.color4
            lblLogo.image = UIImage(named: "clients@x1.png")
            lblLogo.contentMode = .scaleAspectFit
        }
        //  self.GetServerTime()
        getnews()
        newsDealsLabel.restartLabel()

        //newDealsLabel.text = Global.sharedInstance.newslabel


        Global.sharedInstance.currDateSelected = self.SERVERTIME/*Date()*/
        Calendar.sharedInstance.carrentDate = self.SERVERTIME/*Date()*/






        Global.sharedInstance.model = 2//סימן שהגעתי ממודל של היומן תורים מול לקוח
        //    Global.sharedInstance.whichReveal = false



        subView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + self.navigationController!.navigationBar.frame.size.height , width: view.frame.width, height: view.frame.height * 0.2)
        view1 = self.storyboard?.instantiateViewController(withIdentifier: "MonthClientForAppointmentDesignViewController") as! MonthClientForAppointmentDesignViewController
        view1.view.frame = CGRect(x: 0, y: subView.frame.height + (self.navigationController!.navigationBar.frame.size.height * 0.21) , width: view.frame.width, height: view.frame.height - subView.frame.height - self.navigationController!.navigationBar.frame.size.height - HeightView)
        view1.delegate = self
        view1.isfromSPECIALiCustomerUserId = self.isfromSPECIALiCustomerUserId
        view1.isfromSPECIALSUPPLIER = self.isfromSPECIALSUPPLIER

        view3 = self.storyboard?.instantiateViewController(withIdentifier: "weekClientForAppointmentDesign12ViewController") as! weekClientForAppointmentDesign12ViewController

        view3.view.frame = CGRect(x: 0, y: subView.frame.height + (self.navigationController!.navigationBar.frame.size.height * 0.21) , width: view.frame.width, height: view.frame.height - subView.frame.height - self.navigationController!.navigationBar.frame.size.height - HeightView - 25)
        view3.isfromSPECIALSUPPLIER = self.isfromSPECIALSUPPLIER
        view3.isfromSPECIALiCustomerUserId = self.isfromSPECIALiCustomerUserId

        view4 = self.storyboard?.instantiateViewController(withIdentifier: "dayClientForAppointment12ViewController") as! dayClientForAppointment12ViewController
        view4.initDate(Global.sharedInstance.currDateSelected)
        view4.isfromSPECIALiCustomerUserId = self.isfromSPECIALiCustomerUserId
        view4.isfromSPECIALSUPPLIER = self.isfromSPECIALSUPPLIER
        if UIDevice.current.userInterfaceIdiom == .pad {
            view4.view.frame = CGRect(x: 0, y: subView.frame.height + (self.navigationController!.navigationBar.frame.size.height * 0.21) , width: view.frame.width, height: view.frame.height - subView.frame.height - self.navigationController!.navigationBar.frame.size.height - 90)
        } else {
            view4.view.frame = CGRect(x: 0, y: subView.frame.height + (self.navigationController!.navigationBar.frame.size.height * 0.21) , width: view.frame.width, height: view.frame.height - subView.frame.height - self.navigationController!.navigationBar.frame.size.height - 34)
        }

        Global.sharedInstance.dayDesigncalendarAppointment12 = view4
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ModelCalendarForAppointmentsViewController.dismissKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)

        view1.view.isHidden = true
        view3.view.isHidden = true
        view4.view.isHidden = true
        self.addChild(view1)
        self.addChild(view3)
        self.addChild(view4)
        self.view.addSubview(view1.view)
        self.view.addSubview(view3.view)
        self.view.addSubview(view4.view)
        //  self.view.sendSubview(toBack: imgPlusMenu)





        if Global.sharedInstance.isCancelAppointmentClick == true//לחצו על ביטול תור
        {
            Global.sharedInstance.isCancelAppointmentClick = false
        }
        if Global.sharedInstance.whichDesignOpenDetailsAppointment == 1//הגיעו מיום day
        {
            SelectDesighnedBtn(btnDay)
            btnDay.tag = 1
            btnDayClick = btnDay
            SelectSingleForDay()
            view4.initDate(Global.sharedInstance.currDateSelected)
            view1.view.isHidden = true
            view3.view.isHidden = true
            view4.view.isHidden = false
            self.view.bringSubviewToFront(view4.view)
            selectedView = view4

            self.delegateSetDate = Global.sharedInstance.dayDesigncalendarAppointment12
            delegateSetDate.setDateClick(Global.sharedInstance.dateDayClick as Date)
            DispatchQueue.main.async(execute: { () -> Void in
                self.view4.bestmode()
                self.view4.view.setNeedsDisplay()
            })
        }
        else if Global.sharedInstance.whichDesignOpenDetailsAppointment == 2//הגיעו משבוע week
        {
            SelectDesighnedBtn(btnWeek)
            btnWeek.tag = 1
            SelectSingleForWeek()
            view1.view.isHidden = true
            view3.view.isHidden = false
            view4.view.isHidden = true
            view3.initDateOfWeek(Global.sharedInstance.currDateSelected)
            view3.delegate = self
            self.view.bringSubviewToFront(view3.view)
            selectedView = view3
            DispatchQueue.main.async(execute: { () -> Void in
                self.view3.bestmode()
                self.view3.view.setNeedsDisplay()
            })
        }
        else
        {
            switch (Global.sharedInstance.currentUser.iCalendarViewType)
            {
            case 2: //month
                selectedView = view1
                SelectDesighnedBtn(btnMonth)
                self.view1.view.isHidden = false
                self.view3.view.isHidden = true
                self.view4.view.isHidden = true
                self.view.bringSubviewToFront(self.view1.view)
                DispatchQueue.main.async(execute: { () -> Void in
                    self.view1.bestmode()
                    self.view1.view.setNeedsDisplay()
                })

                break
                //hide week view
//            case 1: //week
//                SelectDesighnedBtn(btnWeek)
//                btnWeek.tag = 1
//                SelectSingleForWeek()
//                view1.view.isHidden = true
//                view3.view.isHidden = false
//                view4.view.isHidden = true
//                view3.initDateOfWeek(Global.sharedInstance.currDateSelected)
//                view3.delegate = self
//                self.view.bringSubview(toFront: view3.view)
//                selectedView = view3
//                DispatchQueue.main.async(execute: { () -> Void in
//                    self.view3.bestmode()
//                    self.view3.view.setNeedsDisplay()
//                })
//                break
            case 1: //day again
                SelectDesighnedBtn(btnDay)
                btnDay.tag = 1
                btnDayClick = btnDay
                SelectSingleForDay()
                view4.initDate(Global.sharedInstance.currDateSelected)
                view1.view.isHidden = true
                view3.view.isHidden = true
                view4.view.isHidden = false
                self.view.bringSubviewToFront(view4.view)
                selectedView = view4
                
                self.delegateSetDate = Global.sharedInstance.dayDesigncalendarAppointment12
                delegateSetDate.setDateClick(Global.sharedInstance.dateDayClick as Date)
                DispatchQueue.main.async(execute: { () -> Void in
                    self.view4.bestmode()
                    self.view4.view.setNeedsDisplay()
                })
                break
            case 0: //day
                SelectDesighnedBtn(btnDay)
                btnDay.tag = 1
                btnDayClick = btnDay
                SelectSingleForDay()
                view4.initDate(Global.sharedInstance.currDateSelected)
                view1.view.isHidden = true
                view3.view.isHidden = true
                view4.view.isHidden = false
                self.view.bringSubviewToFront(view4.view)
                selectedView = view4

                self.delegateSetDate = Global.sharedInstance.dayDesigncalendarAppointment12
                delegateSetDate.setDateClick(Global.sharedInstance.dateDayClick as Date)
                DispatchQueue.main.async(execute: { () -> Void in
                    self.view4.bestmode()
                    self.view4.view.setNeedsDisplay()
                })
                break
            default:
                print("moded")
                view1.view.isHidden = false
                view3.view.isHidden = true
                view4.view.isHidden = true
                self.view.bringSubviewToFront(view1.view)
                selectedView = view1
                DispatchQueue.main.async(execute: { () -> Void in
                    self.view1.bestmode()
                    self.view1.view.setNeedsDisplay()
                })
                SelectDesighnedBtn(btnMonth)
                break
            }

        }






        let currentDate:Date = Global.sharedInstance.currDateSelected as Date
        let dayOfWeekToday = Calendar.sharedInstance.getDayOfWeek(currentDate)!

        //אתחול מערך השעות הפנויות לשבוע
        for i in 0 ..< 7 {

            let curDate = Calendar.sharedInstance.reduceAddDay_Date(currentDate, reduce: dayOfWeekToday, add: i + 1)

            Global.sharedInstance.setFreeHours(curDate, dayOfWeek: i)
            Global.sharedInstance.getBthereEvents(curDate, dayOfWeek: i)
        }

    }

    func aftergettime() {


    }

    override func viewDidAppear(_ animated: Bool) {
        self.view.addBackground2()
        lblName.text = Global.sharedInstance.currentProviderToCustomer.nvProviderName
        lblDescription.text = Global.sharedInstance.currentProviderToCustomer.nvProviderSlogan
    }

    //    func imageTappedWorkersMenu(){
    //        if x == 0{
    //
    //            viewCon.view.frame = CGRectMake(viewContactMan.frame.origin.x, btnWeek.frame.origin.y, viewContactMan.frame.width ,self.view.frame.size.height * 0.2)
    //            viewCon.tableView.reloadData()
    //            self.view.addSubview(viewCon.view)
    //            self.view.bringSubviewToFront(viewCon.workertable)
    //
    //
    //            viewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
    //            self.delegate = viewCon
    //            viewCon.delegate = self
    //            x = 1
    //        }
    //        else{
    //
    //            delegate.hideTable()
    //
    //            x = 0
    //        }
    //    }
    //
    @objc func imageTapped(){
        if self.isfromSPECIALSUPPLIER {
            let storyBoard = UIStoryboard(name:"SupplierExist", bundle: nil)
            let viewCon:PLUSMENUSupplier = storyBoard.instantiateViewController(withIdentifier: "PLUSMENUSupplier") as! PLUSMENUSupplier
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            viewCon.delegate = self
            self.present(viewCon, animated: true, completion: nil)
        } else {
            Global.sharedInstance.currentOpenedMenu = self

            let viewCon:MenuPlusViewController = storyBoard1?.instantiateViewController(withIdentifier: "MenuPlusViewController") as! MenuPlusViewController
            viewCon.delegate = self
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(viewCon, animated: true, completion: nil)
        }
    }
    //פונקציה זו מקבלת כפתור ועושה לו תצוגה בחורה ז״א קו מתחת וכתב מודגש
    func SelectDesighnedBtn(_ btn:UIButton){
        //btn.titleLabel?.font = UIFont (name: "OpenSansHebrew-Bold", size: 23)
        btn.backgroundColor = UIColor.clear
        //  btn.titleLabel?.font = ui
        underlineButton(btn, text: (btn.titleLabel?.text)!)
    }

    func underlineButton(_ button : UIButton, text: String) {
        attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:text, attributes:convertToOptionalNSAttributedStringKeyDictionary(attrs))
        attributedString.append(buttonTitleStr)
        button.setAttributedTitle(attributedString, for: UIControl.State())
    }
    //פונקציה זו מקבלת כפתור והופכת אותו מתצוגה בחורה לתצוגה לא בחורה
    func DeSelectDesighnedBtn(_ btn:UIButton){
        //btn.titleLabel?.font = UIFont (name: "OpenSansHebrew-Light", size: 23)
        attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string: (btn.titleLabel?.text)!, attributes:convertToOptionalNSAttributedStringKeyDictionary(attrsDeselect))
        attributedString.append(buttonTitleStr)
        btn.setAttributedTitle(attributedString, for: UIControl.State())
        //btn.titleLabel?.font = UIFont.preferredFontForTextStyle(uifontt)
        //btn.backgroundColor = UIColor.clearColor()
        //  btn.titleLabel?.font = ui
        //underlineButton(btn, text: (btn.titleLabel?.text)!)
    }
    //ברגע שלוחצים על תצוגה מסוימת שרק היא תהיה בחורה בפונקציה זו זה בלחיצה על חודש  אח״כ יש גם בעת לחיצה על שבוע או יום
    func SelectSingleForMonthly(){
        btnWeek.tag = 0
        DeSelectDesighnedBtn(btnWeek)
        btnWeek.backgroundColor = Colors.sharedInstance.color8
        btnDay.tag = 0
        btnDay.backgroundColor = Colors.sharedInstance.color9
        DeSelectDesighnedBtn(btnDay)
    }

    func SelectSingleForWeek(){
        btnMonth.tag = 0
        btnMonth.backgroundColor = Colors.sharedInstance.color7
        DeSelectDesighnedBtn(btnMonth)

        btnDay.tag = 0
        btnDay.backgroundColor = Colors.sharedInstance.color9
        DeSelectDesighnedBtn(btnDay)
    }

    func SelectSingleForDay(){
        btnMonth.tag = 0
        btnMonth.backgroundColor = Colors.sharedInstance.color7
        DeSelectDesighnedBtn(btnMonth)
        btnWeek.tag = 0
        DeSelectDesighnedBtn(btnWeek)
        btnWeek.backgroundColor = Colors.sharedInstance.color8
    }

    @objc func dismissKeyboard() {
        if x == 1
        {
            delegate.hideTable()
            x = 0
        }
        self.view.endEditing(true)
    }

    func selectWorker(_ text:String)
    {
        Global.sharedInstance.giveServiceName = text
        lblChooseWorker.text = text
        x = 1
        //     imageTappedWorkersMenu()
    }

    func openFromMenu(_ con:UIViewController)
    {
        self.present(con, animated: true, completion: nil)
    }

    //    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    //        if (touch.view!.isDescendantOfView(self.viewCon.view)) {
    //
    //            return false
    //        }
    //        return true
    //    }

    //enter to current date
    func clickToDay(){//open the day design when click one day in the month design
        SelectDesighnedBtn(btnDay)
        SelectSingleForDay()
        self.delegateSetDate = Global.sharedInstance.dayDesigncalendarAppointment12
        view4.initDate(Global.sharedInstance.currDateSelected)
        view1.view.isHidden = true
        view3.view.isHidden = true
        view4.view.isHidden = false
        self.view.bringSubviewToFront(view4.view)
        selectedView = view4
        delegateSetDate.setDateClick(Global.sharedInstance.dateDayClick as Date)
        DispatchQueue.main.async(execute: { () -> Void in
            self.view4.bestmode()
            self.view4.view.setNeedsDisplay()
        })
    }
    //enter to current date in week design
    func clickToDayInWeek()
    {
        self.generic.showNativeActivityIndicator(self)
        SelectDesighnedBtn(btnDay)
        SelectSingleForDay()
        self.delegateSetDate = Global.sharedInstance.dayDesigncalendarAppointment12
        view4.initDate(Global.sharedInstance.currDateSelected)
        view1.view.isHidden = true
        view3.view.isHidden = true
        view4.view.isHidden = false
        self.view.bringSubviewToFront(view4.view)
        selectedView = view4
        delegateSetDate.setDateClick(Global.sharedInstance.dateDayClick as Date)
        DispatchQueue.main.async(execute: { () -> Void in
            self.view4.bestmode()
            self.view4.view.setNeedsDisplay()
        })
        self.generic.hideNativeActivityIndicator(self)

    }

    //openDetailsOrderDelegate
    func openDetailsOrder(_ tag:Int)  {//פונקציה דליגטית שנקראת בעת לחיצה על רבוע פנוי או תפוס(לפי הטאג) ביומן ופותחת את פרטי ההזמנה במודל

        let storyboard = UIStoryboard(name: "ClientExist", bundle: nil)

        let frontviewcontroller = storyBoard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyboard.instantiateViewController(withIdentifier: "detailsAppointmetClientViewController") as! detailsAppointmetClientViewController
        vc.tag = tag
        vc.fromViewMode = false
        frontviewcontroller?.pushViewController(vc, animated: false)


        //initialize REAR View Controller- it is the LEFT hand menu.

        let rearViewController = storyBoard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController

        let mainRevealController = SWRevealViewController()

        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController

        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }



    func changeSizeAdjastDevice()
    {
        lblChooseWorker.font = UIFont(name: (lblChooseWorker.font?.fontName)!, size: 13.0)
    }
    func GetServerTime() {
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {

//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            self.SERVERTIME = Date()
            self.aftergettime()
        }
        else
        {
            api.sharedInstance.GetServerTime(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    print("GetServerTime \(RESPONSEOBJECT)")
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {

                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if let _ = RESPONSEOBJECT["Result"] as? String {
                                let mystr =   RESPONSEOBJECT["Result"] as! String

                                let myd = Global.sharedInstance.getDateFromString(mystr)
                                //add 2 h because +0200s
                                let onedate = Foundation.Calendar.current.date(byAdding: .hour, value: 2, to: myd)
                                print("onedate \(onedate) decoded date \(myd) AND DATE \(Date())")
                                self.SERVERTIME  = onedate!
                                self.aftergettime()
                            }
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE),vc:self)
                self.SERVERTIME = Date()
                self.aftergettime()
            })
        }
    }
    func openMonthFromChooseWorker()
    {
        //\\   Calendar.sharedInstance.carrentDate = NSDate()
        SelectDesighnedBtn(btnMonth)
        btnMonth.tag = 1
        SelectSingleForMonthly()
        view1.view.isHidden = false
        view3.view.isHidden = true
        view4.view.isHidden = true
        self.view.bringSubviewToFront(view1.view)
        selectedView = view1

        DispatchQueue.main.async(execute: { () -> Void in
            //     self.view1.bestmode()
            self.view1.view.setNeedsDisplay()
        })
    }

    //בלחיצה על תור פנוי ממצב צפיה מוצגת הודעה אם מעונין להרשם כלקוח ומעבירו להרשמה
    func goToRegister()
    {
        let alert = UIAlertController(title: "", message:
            "REGISTER_NOW".localized(LanguageMain.sharedInstance.USERLANGUAGE).localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: { (action: UIAlertAction!) in

            Global.sharedInstance.isFromViewMode = true
            let viewCon = self.storyboard1.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            self.navigationController?.pushViewController(viewCon, animated: false)
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel , handler: nil))

        self.present(alert, animated: true, completion: nil)
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

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
