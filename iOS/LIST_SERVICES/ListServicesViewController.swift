//
//  ListServicesViewController.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/23/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol showMoreInfoDelegate
{
    func showMoreInfo(_ index:Int)
    func showOdrerTurn()
    func shownoavalaibleworkers()
}
protocol reloadTblServiceDelegte {
    func reloadTblService()

}

let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
// תת דף רשימת שירותים
class ListServicesViewController:
NavigationModelViewController,UITableViewDelegate,UITableViewDataSource,showMoreInfoDelegate,openSearchResultsDelegate,openFromMenuDelegate,reloadTblServiceDelegte,UIGestureRecognizerDelegate {
    var bIsAvailableForNewCustomer = 0
    var iHoursForPreCancelServiceByCustomer = 0
    @IBOutlet weak var butonwidth: NSLayoutConstraint!
    @IBOutlet weak var BTN_CONTINUE_LIST_SERVICES:UIButton!
    @IBOutlet weak var CentralButton:UIView!
    @IBOutlet weak var  CentralButtonImg:UIImageView!
    var iMaxServiceForCustomer:Int = 0
    var iPeriodInWeeksForMaxServices:Int = 0
    var iCustomerViewLimit:Int = 0
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var viewhelp : helpPpopup!
    var viewpop: PopUpGenericViewController!
    var bLimitSeries:Bool =  false
    //JMODE + special case when supplier make himself appoinment in the name of customer
    var ismultipleappointments:Bool =  false
    var PERMISSIONSArray : NSMutableArray = [] //services with workers and permissions array
    var FULLPERMISSIONSArray = Array<User>() //contains an array with employes who have access at all services in case of multiple services select
    var ALLEMPLOYES:Array<User> = Array<User>()
    var ARIEFINALA:Array<User> = Array<User>()
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var isfromSPECIALSUPPLIER:Bool = false
    var isfromSPECIALiCustomerUserId:Int = 0
    var isfromMYPRVODIERS:Bool = false
    var providersArray:Array<SearchResulstsObj> = Array<SearchResulstsObj>()
    var dicResultsOK:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
    var isFROMSELECTMULTIPLE:Bool = false
    var bIsAproved:Int = 0
    @IBOutlet weak var txtView:UITextView!
    ////////// END JMODE /////
    @IBOutlet weak var lblAdvertising: MarqueeLabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewBlack: UIView!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var imgWaze: UIImageView!
    @IBOutlet weak var openPlusMenu: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblNumKM: UILabel!
    @IBOutlet weak var myPlusImgEnglish: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblNumRuting: UILabel!
    @IBOutlet weak var lblNumVoters: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var goBackImage: UIImageView!
    @IBOutlet weak var serviceImg: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var seriesOfAppImg: UIImageView!
    @IBOutlet weak var seriesOfAppLabel: UILabel!
    @IBOutlet weak var serviceBtn: UIButton!
    @IBOutlet weak var seriesOfAppBtn: UIButton!
    var generic:Generic = Generic()
    var delegateSearch:openSearchResultsDelegate!=nil
    var delegateReloadCol:reloadCollectionDelegate!=nil
    var clientStoryBoard:UIStoryboard?
    var storyboard1:UIStoryboard?
    var delegate:dismissViewControllerDelegate!=nil
    var backFromMyListServices = 0
    var ProviderServicesArray:Array<objProviderServices> = Array<objProviderServices>()
    var iServiceType = 0
    var moreservices = 0
    var x = 0
    var indexRow = 0
    var secondUserID:Int = 0
    var arrayForPermissionsIustin:NSMutableArray = []
    //new 23-01-17
    var getFreeDaysForService:Array<providerFreeDaysObj> =  Array<providerFreeDaysObj>()
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func BTN_CONTINUE_LIST_SERVICES(_ sender: UIButton) {
        if Global.sharedInstance.arrayServicesKodsToServer.count > 0 {
            self.showOdrerTurn()
        } else {
            self.view.makeToast(message: "SELECT_SERVICE_MESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionDefault as AnyObject)
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.hidetoast()
            })
        }
    }
    func hidetoast(){
        view.hideToastActivity()
    }

    @IBAction func pressedService(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            iServiceType = 90
            ismultipleappointments = false
            moreservices = 0
            Global.sharedInstance.ordersOfClientsTemporaryArray = Array<OrderDetailsObj>()
            Global.sharedInstance.ISFROMMULTIPLEAPPOINTMENTS = false
            reeenableall()
            serviceImg.image = UIImage(named:"fullCircle.png")
            seriesOfAppImg.image = UIImage(named:"empty_circle.png")
            sender.tag = 1
            seriesOfAppBtn.tag = 0
        }

    }

    @IBAction func pressedSeriesOfApp(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            serviceImg.image = UIImage(named:"empty_circle.png")
            seriesOfAppImg.image = UIImage(named:"fullCircle.png")
            sender.tag = 1
            serviceBtn.tag = 0

            let numberofmaxAppointmentspermited = read_iMaxServiceForCustomer()
            Global.sharedInstance.canselectmultiple = true
            if numberofmaxAppointmentspermited == 0 {
                ismultipleappointments = false
                Global.sharedInstance.canselectmultiple = false
                iServiceType = 90
                ismultipleappointments = false
                moreservices = 0
                reeenableall()
                self.view.makeToast(message: "SUPPLIER_NOT_ALLOW_MULTIPLE_APPOINTMENTS".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionTop as AnyObject)
                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                    self.hidetoast()
                })
            } else
            {

                iServiceType = 90
                moreservices = 1
                if isfromSPECIALSUPPLIER == true
                {
                    ismultipleappointments = true
                    Global.sharedInstance.ordersOfClientsTemporaryArray = Array<OrderDetailsObj>()
                    Global.sharedInstance.ISFROMMULTIPLEAPPOINTMENTS = true
                } else
                {
                    //first check if user was approved by supplier
                    if verifyifcanmakemultipleappoinments() == false
                    {
                        ismultipleappointments = false
                        Global.sharedInstance.canselectmultiple = false
                        iServiceType = 90
                        ismultipleappointments = false
                        moreservices = 0
                        reeenableall()
                        self.pressedService(self.serviceBtn)
                        Global.sharedInstance.ordersOfClientsTemporaryArray = Array<OrderDetailsObj>()
                        Global.sharedInstance.ISFROMMULTIPLEAPPOINTMENTS = false
                        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                        if self.bIsAproved == 0
                        {

                        }
                        viewpop = storyboardtest.instantiateViewController(withIdentifier: "PopUpGenericViewController") as? PopUpGenericViewController
                        if self.iOS8 {
                            viewpop.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        } else {
                            viewpop.modalPresentationStyle = UIModalPresentationStyle.currentContext
                        }
                        viewpop.isfromWhichScreen = 1
                        viewpop.delegateReloadTbl = self
                        self.present(viewpop, animated: true, completion: nil)

                    }
                    else
                    {
                        //then allow it to make multiple appointments
                        ismultipleappointments = true
                        //                        showhidebtnselectmutiple()
                        Global.sharedInstance.ordersOfClientsTemporaryArray = Array<OrderDetailsObj>()
                        Global.sharedInstance.ISFROMMULTIPLEAPPOINTMENTS = true
                    }

                }
            }
        }

    }

    @IBAction func btnClose(_ sender: AnyObject) {

        let USERDEF = Global.sharedInstance.defaults
        //no userdef stored
        if USERDEF.object(forKey: "backFromMyListServices") != nil {
            if let _:Int = USERDEF.value(forKey: "backFromMyListServices") as? Int {
                let isBackFromListSrv = USERDEF.value(forKey: "backFromMyListServices") as! Int
                if isBackFromListSrv == 1 {
                    openGiveMyService()
                } else if isBackFromListSrv == 0 {
                    openSearchResults()
                } else if isBackFromListSrv == 2 {
                    openentrance()
                } else if isBackFromListSrv == 3 {
                    openmycustomers()
                }
            }
        } else {
            if backFromMyListServices == 1 {
                print("tralala case 2")
                openGiveMyService()
            } else if backFromMyListServices == 0 {
                print("tralala case 3")
                openSearchResults()
            } else  if  backFromMyListServices == 2 {
                openentrance()
            }   else if x == 3 {
                openmycustomers()
            }

        }


    }
    func openentrance() {
        Global.sharedInstance.isProvider = false
        Global.sharedInstance.whichReveal = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyboard.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let viewController = storyboard.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        viewController.isSearching = false
        frontviewcontroller?.pushViewController(viewController, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
        return
    }
    func openmycustomers() {
        Global.sharedInstance.whichReveal = true
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let viewCon = storyBoard.instantiateViewController(withIdentifier: "MyCostumersViewController") as!  MyCostumersViewController
        Global.sharedInstance.isProvider = true
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

    //    var arrayServices:Array<String> = ["SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SERIES_TURNS".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var arrayServices:Array<String> = ["SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SERIES_TURNS".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    //    @IBOutlet weak var tblDropDownList: UITableView!
    @IBOutlet var tblServices: UITableView!

    //MARK: - Initial

    func reeenableall(){
        Global.sharedInstance.canselectmultiple = true
        tblServices.reloadData()
    }

    /////////////////// JMODE  /////////////////////////
    //     j1. array with all employees -> Global.sharedInstance.giveServicesArray
    //     j2 .array with employees permissions -> PERMISSIONSArray
    //     j3. service id (s) -> Global.sharedInstance.arrayServicesKodsToServer
    //    So read 2, search 3 in it-> j4.array with employes with permission on 3. then parse 1. If contains elements from 4 -> add to 5.final array func COMBINEARRAYS()


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Global.sharedInstance.iServiceTimeSUM = 0 // important
        GoogleAnalyticsSendEvent(x:6)
        Global.sharedInstance.giveServicesArray = []
        PERMISSIONSArray = []
        Global.sharedInstance.arrayServicesKodsToServer = []
        Global.sharedInstance.arrayWorkers = []

        Global.sharedInstance.isInMeetingProcess = 1
        
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
        if USERDEF.object(forKey: "listservicesindexRow") != nil {
            let myx = USERDEF.value(forKey: "listservicesindexRow") as! Int
            self.indexRow = myx
        }
        print("index rrr \(indexRow) ")
//        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0 && Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil
//        {
//            GetSecondUserIdByFirstUserIdThree()
//        }
//        else if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 && Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
//        {
//                GetSecondUserIdByFirstUserIdThree()
//        }
//        else
//        {
//            GetServicesPermissionForUsersBySupplier()
//            GetCustomerActiveOrdersBySupplier()
//            GetProviderSettingsForCalendarmanagement()
//        }
        if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1 && Global.sharedInstance.isProvider
        {
            GetSecondUserIdByFirstUserIdThree()
        }
        else
        {
            GetServicesPermissionForUsersBySupplier()
            GetCustomerActiveOrdersBySupplier()
            GetProviderSettingsForCalendarmanagement()
        }
        

    }

    override func viewWillDisappear(_ animated: Bool)
    {
        Global.sharedInstance.isInMeetingProcess = 0
        
    }

    override func viewDidLoad() {

        print("is manager?: \(Global.sharedInstance.defaults.integer(forKey: "ismanager"))")
        for i:User in Global.sharedInstance.giveServicesArray
        {
            print("useeeeer: \(i.iUserId)")
        }
        print("my user id: \(Global.sharedInstance.currentUser.iUserId)")
        

        super.viewDidLoad()
        tblServices.tableFooterView = UIView(frame: CGRect.zero)
        if UIDevice.current.userInterfaceIdiom == .pad {
            butonwidth.constant = 80
        } else {
            butonwidth.constant = 70
        }
        Global.sharedInstance.ordersOfClientsTemporaryArray = Array<OrderDetailsObj>() //always clean temporary array of multiple appointments
        Global.sharedInstance.ISFROMMULTIPLEAPPOINTMENTS = false //close multiple appointments case
        serviceBtn.tag = 1
        seriesOfAppBtn.tag = 0
        serviceImg.image = UIImage(named:"fullCircle.png")
        seriesOfAppImg.image = UIImage(named:"empty_circle.png")
        serviceLabel.text = "SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        seriesOfAppLabel.text = "SERIES_TURNS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        Global.sharedInstance.canselectmultiple = true
        self.getnews()
        self.lblAdvertising.restartLabel()
        print("is from \(isfromSPECIALSUPPLIER)")
        if isfromSPECIALSUPPLIER == false {
            getProvidersList()
        }
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            goBackImage.transform = scalingTransform
            btnBack.transform = scalingTransform
        }

        btnBack.imageView!.contentMode = .scaleAspectFit

        if isfromSPECIALSUPPLIER == false {
            lblRating.text = "LEVEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)

        }
        lblTitle.text = "WANT_ORDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        BTN_CONTINUE_LIST_SERVICES.setTitle("BTN_CONTINUE_LIST_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        iServiceType = 90

        storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
        tblServices.separatorStyle = .singleLine
        tblServices.estimatedRowHeight = 0
        tblServices.estimatedSectionHeaderHeight = 0
        tblServices.estimatedSectionFooterHeight = 0
        tblServices.separatorColor = .black
        Global.sharedInstance.numCellsCellected = 0
        Global.sharedInstance.arrCellsMultiple = []
        for _ in 0..<ProviderServicesArray.count
        {
            Global.sharedInstance.arrCellsMultiple.append(false)
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func GetSecondUserIdByFirstUserIdThree()  {
        
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var y:Int = 0
        if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
            let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
            if let x:Int = a.value(forKey: "currentUserId") as? Int{
                y = x
            }
        }
        if y != 0
        {
            dictionaryForServer["iUserId"] =  y as AnyObject
            print("\n********************************* GetSecondUserIdByFirstUserId  ********************\n")
            if Reachability.isConnectedToNetwork() == false
            {
                
            }
            else
            {
                api.sharedInstance.GetSecondUserIdByFirstUserId(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                            {
                                print("eroare la GetSecondUserIdByFirstUserId \(String(describing: RESPONSEOBJECT["Error"]))")
                            }
                            else
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2 || RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                                {
                                    print("eroare la GetSecondUserIdByFirstUserId \(String(describing: RESPONSEOBJECT["Error"]))")
                                }
                                else
                                {
                                    if let _:Int = RESPONSEOBJECT["Result"] as? Int
                                    {
                                        let integerResult :Int = (RESPONSEOBJECT["Result"] as? Int)!
                                        print("SECOND USER ID \(integerResult)")
                                        if integerResult > 0 {
                                            self.secondUserID = integerResult
                                            self.GetServicesPermissionForUsersBySupplier()
                                            self.GetCustomerActiveOrdersBySupplier()
                                            self.GetProviderSettingsForCalendarmanagement()
                                        }
                                    }
                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    
                })
            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addBackground2()

        if isfromSPECIALSUPPLIER == false {

            let USERDEF = Global.sharedInstance.defaults
            USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
            USERDEF.synchronize()
            self.isfromSPECIALiCustomerUserId = 0
            Global.sharedInstance.currentProviderToCustomer = SearchResulstsObj(
                _nvProviderName: (Global.sharedInstance.dicResults[indexRow]["nvProviderName"]?.description)!,
                _nvAdress: Global.sharedInstance.dicResults[indexRow]["nvAdress"]!.description,
                _nvProviderSlogan: Global.sharedInstance.dicResults[indexRow]["nvProviderSlogan"]!.description,
                _nvProviderLogo: (Global.sharedInstance.dicResults[indexRow]["nvProviderLogo"]?.description)!)

            Global.sharedInstance.providerID = Int(Global.sharedInstance.dicResults[indexRow]["iProviderId"]! as! NSNumber)

            lblName.text = Global.sharedInstance.dicResults[indexRow]["nvProviderName"]?.description
            lblDesc.text = Global.sharedInstance.dicResults[indexRow]["nvProviderSlogan"]!.description
            lblCity.text = Global.sharedInstance.dicResults[indexRow]["nvAdress"]!.description + " " + Global.sharedInstance.dicResults[indexRow]["nvCity"]!.description

            if let mydRankAvg = Global.sharedInstance.dicResults[indexRow]["dRankAvg"] as? Float
            {
                if ceilf(mydRankAvg) == mydRankAvg
                {
                    lblNumRuting.text = String(format: "%.1f", mydRankAvg)
                }
                else
                {
                    lblNumRuting.text = String(mydRankAvg)
                }
            }

            lblNumKM.text = Global.sharedInstance.dicResults[indexRow]["iDistance"]!.description + " km"
            if let myiRankCount = Global.sharedInstance.dicResults[indexRow]["iRankCount"] as? Int
            {
                if myiRankCount == 1
                {
                    lblNumVoters.text = String(myiRankCount) + " " + "REVIEW_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                }
                else
                {
                    lblNumVoters.text = String(myiRankCount) + " " + "REVIEWS_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)

                }
            }
            var decodedimage:UIImage = UIImage()
            let dataDecoded:Data = Data(base64Encoded: (Global.sharedInstance.dicResults[indexRow]["nvProviderLogo"]?.description)!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
            if UIImage(data: dataDecoded) != nil
            {
                decodedimage = UIImage(data: dataDecoded)!
                imgLogo.image = decodedimage
                imgLogo.contentMode = .scaleAspectFit
            }
            else
            {
                imgLogo.backgroundColor = Colors.sharedInstance.color4
                imgLogo.image = UIImage(named: "clients@x1.png")
                imgLogo.contentMode = .scaleAspectFit
            }


        } else {
            Global.sharedInstance.currentProviderToCustomer = SearchResulstsObj(
                _nvProviderName: (Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName),
                _nvAdress: (Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress),
                _nvProviderSlogan: (Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen),
                _nvProviderLogo: (Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage))
            if Global.sharedInstance.providerID == 0 {
                if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                    Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                }
            }
            if let _:String = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as String? {
                lblName.text = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName as String
            }
            if let _:String = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen as String? {
                lblDesc.text = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen as String
            }

            if let _:String = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress as String? {
                lblCity.text = Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress as String + Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvCity as String
            }

            lblNumRuting.text = ""
            lblNumVoters.text = ""

            if let _:String = Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage as String? {
                var decodedimage:UIImage = UIImage()
                let dataDecoded:Data = Data(base64Encoded: (Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
                if UIImage(data: dataDecoded) != nil
                {
                    decodedimage = UIImage(data: dataDecoded)!
                    imgLogo.image = decodedimage
                    imgLogo.contentMode = .scaleAspectFit
                }
                else
                {
                    imgLogo.backgroundColor = Colors.sharedInstance.color4
                    imgLogo.image = UIImage(named: "clients@x1.png")
                    imgLogo.contentMode = .scaleAspectFit
                }
            }

        }
        lblNumKM.text = ""
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom != .pad {
            lblDesc.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
            lblName.font = UIFont(name: "OpenSansHebrew-Bold", size: 15)
        }

    }

    // MARK: - TabelView
    //=========================TabelView=================


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblServices
        {
            return self.ProviderServicesArray.count

        }
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblServices
        {
            return 1
        }

        return arrayServices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesTableViewCell") as! ServicesTableViewCell
        delegateReloadCol = cell
        cell.index = indexPath.section
        cell.selectionStyle = .none
        cell.delegateMoreInfo = self
        cell.ProviderServicesArray = self.ProviderServicesArray
        cell.parent_ListServicesViewController = self
        var canbecheckedFix:Bool = false
    
        

//        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0 && self.secondUserID != 0
//        {
//            for i in 0..<PERMISSIONSArray.count
//            {
//                if let dic = PERMISSIONSArray.object(at: i) as? NSDictionary
//                {
//                    if let _ = dic["iUserId"] as? Int
//                    {
//                        if dic["iUserId"] as! Int != self.secondUserID
//                        {
//                            myarr.remove(at: i)
//                        }
//                    }
//                }
//            }
        
//            for (i,num) in myarr.enumerated().reversed()
//            {
//                if let dic = myarr[i] as? Dictionary
//                {
//                    if let _ = dic["iUserId"] as? Int
//                    {
//                        if dic["iUserId"] as! Int != self.secondUserID
//                        {
//                            myarr.remove(at: i)
//                        }
//                    }
//                }
//
//            }
            
            
//            for dic:Dictionary in myarr
//            {
//                if let _ = dic["iUserId"] as? Int
//                {
//                    if dic["iUserId"] as! Int != self.secondUserID
//                    {
//
//                    }
//                }
//            }
        
        
        print("PERMISSIONSArray ius: \(PERMISSIONSArray)")
        var whatservice:objProviderServices = objProviderServices()
        whatservice = ProviderServicesArray[indexPath.section]
        print("asdasdasd: \(whatservice.getDic())")
        if arrayForPermissionsIustin.count > 0 {
            for permission in arrayForPermissionsIustin {
                if let _:NSDictionary = permission as? NSDictionary {
                    let mydictionary = permission as! NSDictionary
                    if let _:Int = mydictionary["iSupplierServiceId"] as? Int {
                        let supplierServiceID = mydictionary["iSupplierServiceId"] as! Int
                        print("permission service id \(supplierServiceID) and provider serviceid \(whatservice.iProviderServiceId)")
                        if  whatservice.iProviderServiceId == supplierServiceID  {
                            canbecheckedFix = true
                            break
                        } else {
                            canbecheckedFix = false
                        }
                    }
                }
            }
        }

        print("AAAAAAAA \(canbecheckedFix)")
        cell.setDisplayData(indexPath.section, _ismultipleactive:  moreservices, _ismoresessions: Global.sharedInstance.canselectmultiple, _canbechecked: canbecheckedFix)
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tblServices.reloadData()
        x = 0
    }

    override func viewWillLayoutSubviews() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Search Result Hairdresser.jpg")!)
    }

    // COMMIT COMMENT again


    func showOdrerTurn()
    {
        self.getServicesProviderForSupplierfunc()
    }

    func getServicesProviderForSupplierfunc()
    {
        Global.sharedInstance.giveServiceName = ""
        print("zzGlobal.sharedInstance.arrayGiveServicesKods \(Global.sharedInstance.arrayGiveServicesKods)")
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if isfromSPECIALSUPPLIER == true {
            dictionaryForServer["iProviderId"] = 0 as AnyObject
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                dictionaryForServer["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
            }
        } else {
            dictionaryForServer["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        }
        print("providerIDzzzz \(Global.sharedInstance.providerID)")
        var arrUsers:Array<User> = Array<User>()

        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.getServicesProviderForSupplierfunc(dictionaryForServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in

                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {


                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            let alertController = UIAlertController(title: "", message:
                                "NO_GIVES_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                            alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)

                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {


                            if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                                print("getServicesProviderForSupplierfunc response: \(RESPONSEOBJECT["Result"] as! NSArray)")
                                let u:User = User()
                                arrUsers = u.usersToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                Global.sharedInstance.giveServicesArray = arrUsers
                                Global.sharedInstance.arrayGiveServicesKods = []

                                for  item in arrUsers
                                {
                                    print ("ce am \(item.description)")
                                    Global.sharedInstance.arrayGiveServicesKods.append(item.iUserId)//אחסון הקודים של נותני השרות לצורך השליחה לשרת כדי לקבל את השעות הפנויות
                                }
                                Global.sharedInstance.dicGetFreeDaysForServiceProvider = Dictionary<String,AnyObject>()
                                Global.sharedInstance.dicGetFreeDaysForServiceProvider["lServiseProviderId"] = Global.sharedInstance.arrayGiveServicesKods as AnyObject


                                if arrUsers.count == 0
                                {
                                    Global.sharedInstance.arrayWorkers = []
                                    let alertController = UIAlertController(title: "", message:
                                        "NO_GIVES_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                                    alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default,handler: nil))
                                    self.present(alertController, animated: true, completion: nil)
                                    self.COMBINEARRAYS()
                                }
                                else
                                {
                                    Global.sharedInstance.arrayWorkers = []
                                    //j1
                                    for user:User in arrUsers
                                    {
                                        let fullName = user.nvFirstName + " " + user.nvLastName
                                        Global.sharedInstance.arrayWorkers.append(fullName)
                                    }
                                    print("Global.sharedInstance.arrayWorkers in listservices \(Global.sharedInstance.arrayWorkers)")
                                    if Global.sharedInstance.arrayWorkers.count > 0 {
                                        //JMODE FIX SELECT FIRST WORKER
                                        Global.sharedInstance.giveServiceName = Global.sharedInstance.arrayWorkers[0]
                                    }
                                    self.COMBINEARRAYS()
                                }
                            }
                        }
                    }
                }

            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }

    }
    func GetServicesPermissionForUsersBySupplier() {
        var dictionaryForServer:Dictionary<String,AnyObject> =  Dictionary<String,AnyObject>()
        ////  self.myArray = [] //empty first
        /////  //JMODE in order to get services permissions for current provider and not all of them
        var providerID:Int = 0
        if isfromSPECIALSUPPLIER == true {
            dictionaryForServer["iSupplierId"] = 0 as AnyObject
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as Int
            }
            else {
                providerID = Global.sharedInstance.providerID as Int
            }
        } else {
            providerID = Global.sharedInstance.providerID as Int
        }
        print("providerIDzzzz \(Global.sharedInstance.providerID)")

        print("provider id to send: \(providerID)")
        dictionaryForServer["iSupplierId"] = providerID as AnyObject
//        dic["iSupplierId"] = 28877 as AnyObject
        api.sharedInstance.GetServicesPermissionForUsersBySupplier(dictionaryForServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        if let _ = RESPONSEOBJECT["Result"] as? NSArray {
                            let REZULTATE:NSArray = RESPONSEOBJECT["Result"] as! NSArray
                            print("services permissions result: \(REZULTATE)")
                            self.procesxsMYARRAY(REZULTATE)
                        }
                    } else {
                        self.view.makeToast(message: "NO_PERMISSION_FOR_SERVICES_SET".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionTop as AnyObject)
                        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                            self.hidetoast()
                        })
                        let REZULTATE:NSArray = NSArray()
                        self.procesxsMYARRAY(REZULTATE)
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            let REZULTATE:NSArray = NSArray()
            self.procesxsMYARRAY(REZULTATE)
        })
    }
    func procesxsMYARRAY(_ REZULTATE:NSArray) {
        self.PERMISSIONSArray  = REZULTATE.mutableCopy() as! NSMutableArray
        print("PERMISSIONSArray \(PERMISSIONSArray)")
        
    
        
        if (self.secondUserID != 0 && Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil && Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1 && Global.sharedInstance.isProvider)
        {
            arrayForPermissionsIustin = []
            for permission in PERMISSIONSArray
            {
                if let _:NSDictionary = permission as? NSDictionary
                {
                    let mydictionary = permission as! NSDictionary
                    if let _:Int = mydictionary["iUserId"] as? Int
                    {
                        let userID = mydictionary["iUserId"] as! Int
                        if userID == self.secondUserID
                        {
                            arrayForPermissionsIustin.add(mydictionary)
                        }
                    }
                }
            }
        }
        else
        {
            arrayForPermissionsIustin = PERMISSIONSArray
        }
        
        getProviderServicesForSupplierFunc()


    }
    func getProviderServicesForSupplierFunc()
    {
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dictionaryForServer["iProviderId"] = Global.sharedInstance.providerID as AnyObject

        api.sharedInstance.getProviderServicesForSupplier(dictionaryForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                        self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {


                        if let _  :NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                            let emptyServicesObj:objProviderServices = objProviderServices()

                            self.ProviderServicesArray = emptyServicesObj.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            if self.ProviderServicesArray.count == 0
                            {
                                self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                self.tblServices.reloadData()
                            }
                            else
                            {
                                //nothing
                                self.tblServices.reloadData()

                            }
                        }
                    }
                }

            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            self.tblServices.reloadData()
        })

    }


    func COMBINEARRAYS(){
        //     j1. array with all employees -> Global.sharedInstance.giveServicesArray
        //     j2 .array with employees permissions -> PERMISSIONSArray
        /*  {
         iServicePermissionId = 140;
         iSupplierServiceId = 1330;
         iUserId = 569;
         }*/
        //     j3. service id (s) -> Global.sharedInstance.arrayServicesKodsToServer
        
        if (self.secondUserID != 0 && Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil && Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1 && Global.sharedInstance.isProvider && Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0)
        {
            var OWNgiveServicesArray = Array<User>()
//            if  Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 {
//
//            for y in Global.sharedInstance.giveServicesArray {
//                let myWorker:User = y
//                    OWNgiveServicesArray.append(myWorker)
//                }
//            }
//                else {
                 
                    for userObj in Global.sharedInstance.giveServicesArray {
                        let myWorker:User = userObj
                        if myWorker.iUserId == secondUserID {
                        OWNgiveServicesArray.append(myWorker)
                         }
                    }
              //  }
            Global.sharedInstance.giveServicesArray = OWNgiveServicesArray
            Global.sharedInstance.arrayWorkers = []
            for userObj:User in Global.sharedInstance.giveServicesArray
            {
                //\\     api.sharedInstance.PREETYJSON_J(u.getDic(), pathofweb: "FILTERED worker details")
                let fullName = userObj.nvFirstName + " " + userObj.nvLastName
                Global.sharedInstance.arrayWorkers.append(fullName)
            }
        }
        
        else if (Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 && Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil && Global.sharedInstance.isProvider)
        {
            
        }
        

        
        
        ARIEFINALA = []
        if Global.sharedInstance.arrayServicesKodsToServer.count != 0 {
            //case 1: one service
            //   j4. array with employes with permission on 3-> TEMPARRAY
            if Global.sharedInstance.arrayServicesKodsToServer.count == 1 {
                let TEMPARRAY:NSMutableArray = []
                var SERVICECODE:Int = 0
                let USERDEF = UserDefaults.standard
                if USERDEF.object(forKey: "Global.sharedInstance.arrayServicesKodsToServer") != nil {
                    print("testest \(String(describing: USERDEF.object(forKey: "Global.sharedInstance.arrayServicesKodsToServer")))")
                }
                SERVICECODE = Global.sharedInstance.arrayServicesKodsToServer[0]
                if PERMISSIONSArray.count > 0 {
                    for i in 0..<PERMISSIONSArray.count {
                        if let _:NSDictionary = PERMISSIONSArray[i] as? NSDictionary {
                            let PERMISSIONDICT:NSDictionary = PERMISSIONSArray[i] as! NSDictionary
                            if let _:Int = PERMISSIONDICT["iSupplierServiceId"] as? Int {
                                let ISERVICE:Int = PERMISSIONDICT["iSupplierServiceId"] as! Int

                                print("ISERVICE \(ISERVICE)")
                                if ISERVICE == SERVICECODE {
                                    if let _:Int = PERMISSIONDICT["iUserId"] as? Int {
                                        let userID:Int = PERMISSIONDICT["iUserId"] as! Int
                                        if !TEMPARRAY.contains(userID) {
                                            TEMPARRAY.add(userID)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    //now J4 ENDS with results then parse 1. If contains elements from j4 TEMPARRAY -> add to 5.final array -> ARIEFINALA
                    //  Global.sharedInstance.arrayWorkers
                    if TEMPARRAY.count > 0 {
                        for y in 0..<Global.sharedInstance.giveServicesArray.count {
                            let myWorker:User = Global.sharedInstance.giveServicesArray[y]
                            for i in 0..<TEMPARRAY.count {
                                if let _:Int = TEMPARRAY[i] as? Int {
                                    let whattosearch:Int = TEMPARRAY[i] as! Int
                                    if myWorker.iUserId == whattosearch {
                                        if !ARIEFINALA.contains(myWorker) {
                                            ARIEFINALA.append(myWorker)
                                        }
                                    }
                                }
                            }
                        }

                        if ARIEFINALA.count > 0 {
                            Global.sharedInstance.giveServicesArray = []
                            Global.sharedInstance.giveServicesArray = ARIEFINALA
                            Global.sharedInstance.arrayWorkers = []
                            //J5
                            for userObj:User in Global.sharedInstance.giveServicesArray
                            {
                                //\\     api.sharedInstance.PREETYJSON_J(u.getDic(), pathofweb: "FILTERED worker details")
                                let fullName = userObj.nvFirstName + " " + userObj.nvLastName
                                Global.sharedInstance.arrayWorkers.append(fullName)
                            }
                        }
                    } else {
                        Global.sharedInstance.giveServicesArray = []
                        Global.sharedInstance.arrayWorkers = []
                    }
                }
                else {
                    Global.sharedInstance.giveServicesArray = []
                    Global.sharedInstance.arrayWorkers = []
                }

                print("J1MODE -> \(Global.sharedInstance.giveServicesArray) \n  J2MODE -> \(PERMISSIONSArray) \n J3MODE -> \(Global.sharedInstance.arrayServicesKodsToServer) \n J4MODE -> \(TEMPARRAY) \n J5MODE \(Global.sharedInstance.arrayWorkers)")
                if  Global.sharedInstance.arrayWorkers.count > 0 {
                    Global.sharedInstance.whichDesignOpenDetailsAppointment = 0
                    if isfromSPECIALSUPPLIER == true {
                        Global.sharedInstance.whichReveal = true
                    }
                    Global.sharedInstance.multipleAppointmentsSupplierIDs = []
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                    let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                    let modelclendar:ModelCalendarForAppointmentsViewController = clientStoryBoard.instantiateViewController(withIdentifier: "ModelCalendarForAppointments") as! ModelCalendarForAppointmentsViewController
                    modelclendar.modalPresentationStyle = UIModalPresentationStyle.custom
                    let USERDEF = Global.sharedInstance.defaults
                    USERDEF.set(self.isfromSPECIALiCustomerUserId, forKey: "isfromSPECIALiCustomerUserId")
                    USERDEF.synchronize()
                    modelclendar.isfromSPECIALiCustomerUserId = self.isfromSPECIALiCustomerUserId
                    print("self.isfromSPECIALiCustomerUserId \(self.isfromSPECIALiCustomerUserId)")
                    modelclendar.isfromSPECIALSUPPLIER = self.isfromSPECIALSUPPLIER
                    if Global.sharedInstance.giveServicesArray.count > 0 {
                        Global.sharedInstance.giveServiceName = Global.sharedInstance.arrayWorkers[0]
                    } else {
                        Global.sharedInstance.idWorker = -1
                    }
                    frontViewController.pushViewController(modelclendar, animated: false)
                    let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.frontViewController = frontViewController
                    mainRevealController.rearViewController = rearViewController
                    self.view.window!.rootViewController = mainRevealController
                    self.view.window?.makeKeyAndVisible()

                } else {
                    //NO_EMPLOYE_AVALAIBLE
                    self.view.makeToast(message: "NO_EMPLOYE_AVALAIBLEnow".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionDefault as AnyObject)
                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    Global.sharedInstance.giveServicesArray = []
                    Global.sharedInstance.arrayWorkers = []
                    ARIEFINALA = []
//                    Global.sharedInstance.arrayServicesKodsToServer = []
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        self.hidetoast()
                    })
                }
            }
            //case 2: multiple services selected -> we select only employes which have access to all services
//            if Global.sharedInstance.arrayServicesKodsToServer.count > 1 {
//                let TEMPARRAY:NSMutableArray = []
//                if PERMISSIONSArray.count > 0 {
//                    for i in 0..<PERMISSIONSArray.count {
//                        if let _:NSDictionary = PERMISSIONSArray[i] as? NSDictionary {
//                            let PERMISSIONDICT:NSDictionary = PERMISSIONSArray[i] as! NSDictionary
//                            if let _:Int = PERMISSIONDICT["iUserId"] as? Int {
//                                let ax:Int = PERMISSIONDICT["iUserId"] as! Int
//
//                                if !TEMPARRAY.contains(ax) {
//                                    TEMPARRAY.add(ax)
//                                }
//                            }
//                        }
//                    }
            if Global.sharedInstance.arrayServicesKodsToServer.count > 1
            {
                let employeesIDsArray:NSMutableArray = []
                var moreTemporaryArray:NSMutableArray = []
                var alsoTemporaryDictionary:NSDictionary = [:]
                let TEMPARRAY:NSMutableArray = []
                if PERMISSIONSArray.count > 0
                {
                    for i in 0..<PERMISSIONSArray.count
                    {
                        if let PERMISSIONDICT:NSDictionary = PERMISSIONSArray[i] as? NSDictionary
                        {
                            if let employeeID:Int = PERMISSIONDICT["iUserId"] as? Int
                            {
                                employeesIDsArray.add(employeeID)
                            }
                        }
                    }
                var counts: [String: Int] = [:]
                for item in employeesIDsArray
                {
                    var itemString = "\(item)"
                    counts[itemString] = (counts[itemString] ?? 0) + 1
                }
                    for item in counts
                    {
                            moreTemporaryArray.add(item.key.integerValue)
                    }
                    for employeeID in moreTemporaryArray
                    {
                        if let employeeIdInteger = employeeID as? Int
                        {
                            var arrayForKeepingServices:NSMutableArray = []
                            for servicePermission in PERMISSIONSArray
                            {
                                 if let PERMISSIONDICT:NSDictionary = servicePermission as? NSDictionary
                                 {
                                    if let serviceID:Int = PERMISSIONDICT["iSupplierServiceId"] as? Int, let userID:Int = PERMISSIONDICT["iUserId"] as? Int
                                    {
                                        if userID == employeeIdInteger
                                        {
                                            arrayForKeepingServices.add(serviceID)
                                        }
                                    }
                                }
                            }
                            let listSet = NSSet(array: Global.sharedInstance.arrayServicesKodsToServer)
                            let findListSet = NSSet(array: arrayForKeepingServices as! Array)
                            var allElementsEqual:Bool = true
                            // we guess that we have all the rights and this var will go false if even one is not
                            for element:Int in (listSet as! Set<Int>)
                            {
                                if findListSet.contains(element)
                                {
                                    
                                }
                                else
                                {
                                    allElementsEqual = false
                                }
                            }
                            
                            if allElementsEqual
                            {
                                TEMPARRAY.add(employeeIdInteger)
                            }
                        }
                    }
                    
                    
                    
                    print("temparray: \(TEMPARRAY)")
                    print("counts in services: \(counts)")

                    
//                }
//            }
            
            
            
                    // iustin trying hard, don't judge
//                    if Global.sharedInstance.arrayServicesKodsToServer.count > 1
//                    {
//                        let TEMPARRAY:NSMutableArray = []
//                        if PERMISSIONSArray.count > 0
//                        {
//                           for i in 0..<PERMISSIONSArray.count
//                           {
//                                if let _:NSDictionary = PERMISSIONSArray[i] as? NSDictionary
//                                {
//                                    let PERMISSIONDICT:NSDictionary = PERMISSIONSArray[i] as! NSDictionary
//                                    if let _:Int = PERMISSIONDICT["iSupplierServiceId"] as? Int
//                                    {
//                                        let employeeID:Int = PERMISSIONDICT["iSupplierServiceId"] as! Int
//                                        if Global.sharedInstance.arrayServicesKodsToServer.contains(employeeID)
//                                        {
//                                            if let _:Int = PERMISSIONDICT["iUserId"] as? Int
//                                            {
//                                                let userID:Int = PERMISSIONDICT["iUserId"] as! Int
//                                                if !TEMPARRAY.contains(userID) {
//                                                    TEMPARRAY.add(userID)
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
                    
//                    print("full rights array \(TEMPARRAY)")
//                    for i:User in Global.sharedInstance.giveServicesArray
//                    {
//                        print("id de employee: \(i.iUserId)")
//                    }
                    
                    if TEMPARRAY.count > 0 {
                        for y in 0..<Global.sharedInstance.giveServicesArray.count {
                            let myWorker:User = Global.sharedInstance.giveServicesArray[y]
                            //iustin
                            
                            for i in 0..<TEMPARRAY.count {
                                if let _:Int = TEMPARRAY[i] as? Int {
                                    let whattosearch:Int = TEMPARRAY[i] as! Int
                                    if myWorker.iUserId == whattosearch {
                                        if !ARIEFINALA.contains(myWorker) {
                                            ARIEFINALA.append(myWorker)
                                        }
                                    }
                                }
                            }
                        }


                        if ARIEFINALA.count > 0 {
                            Global.sharedInstance.giveServicesArray = []
                            Global.sharedInstance.giveServicesArray = ARIEFINALA
                            Global.sharedInstance.arrayWorkers = []
                            //J5
                            for userObj:User in Global.sharedInstance.giveServicesArray
                            {
                                //\\     api.sharedInstance.PREETYJSON_J(u.getDic(), pathofweb: "FILTERED worker details")
                                let fullName = userObj.nvFirstName + " " + userObj.nvLastName
                                Global.sharedInstance.arrayWorkers.append(fullName)
                            }

                        } else {
                            Global.sharedInstance.giveServicesArray = []
                            Global.sharedInstance.arrayWorkers = []
                        }
                    }
                    else {
                        Global.sharedInstance.giveServicesArray = []
                        Global.sharedInstance.arrayWorkers = []
                    }
                }
                else {
                    Global.sharedInstance.giveServicesArray = []
                    Global.sharedInstance.arrayWorkers = []
                }
                print("J1MODE -> \(Global.sharedInstance.giveServicesArray) \n  J2MODE -> \(PERMISSIONSArray) \n J3MODE -> \(Global.sharedInstance.arrayServicesKodsToServer) \n J4MODE -> \(TEMPARRAY) \n J5MODE \(Global.sharedInstance.arrayWorkers)")
                if  Global.sharedInstance.arrayWorkers.count > 0 {
                    Global.sharedInstance.whichDesignOpenDetailsAppointment = 0
                    if isfromSPECIALSUPPLIER == true {
                        Global.sharedInstance.isProvider = true
                    }
                    if self.isfromSPECIALSUPPLIER == true {
                        Global.sharedInstance.whichReveal = true
                    }
                    let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "ModelCalendarForAppointments") as! ModelCalendarForAppointmentsViewController

                    let USERDEF = Global.sharedInstance.defaults
                    USERDEF.set(self.isfromSPECIALiCustomerUserId, forKey: "isfromSPECIALiCustomerUserId")
                    USERDEF.synchronize()
                    viewCon.isfromSPECIALiCustomerUserId = self.isfromSPECIALiCustomerUserId
                    viewCon.isfromSPECIALSUPPLIER = self.isfromSPECIALSUPPLIER
                    if Global.sharedInstance.giveServicesArray.count > 0 {
                        Global.sharedInstance.giveServiceName = Global.sharedInstance.arrayWorkers[0]
                    } else {
                        Global.sharedInstance.idWorker = -1
                    }
                    print("full rights array again \(TEMPARRAY)")
                    self.navigationController?.pushViewController(viewCon, animated: false)
                } else {
                    //NO_EMPLOYE_AVALAIBLE
                    self.generic.hideNativeActivityIndicator(self)
                    ARIEFINALA = []
                    Global.sharedInstance.giveServicesArray = []
                    Global.sharedInstance.arrayWorkers = []
//                    Global.sharedInstance.arrayServicesKodsToServer = []
                    self.view.makeToast(message: "NO_EMPLOYE_AVALAIBLEnow".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionDefault as AnyObject)
                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        self.hidetoast()
                    })

                }
                
            }
        }
    }








    /////CLEAN AND CLEAR 05.02.2019

    //1 detect if is aproved GetCustomerActiveOrdersBySupplier()
    //2 GetProviderSettingsForCalendarmanagement()
    //3  getProvidersList() -> GetProviderListForCustomerAuthorizedFromSupplier
    func GetCustomerActiveOrdersBySupplier() {
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var userID:Int = 0
        if  Global.sharedInstance.currentUser.iUserId == 0 {
            if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                let currentUserDictionary:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                if let userIdInteger:Int = currentUserDictionary.value(forKey: "currentUserId") as? Int{
                    userID = userIdInteger
                }
            }
        } else {
            userID = Global.sharedInstance.currentUser.iUserId
        }
        dictionaryForServer["iCustomerUserId"] = userID as AnyObject
        dictionaryForServer["iSupplierId"] = Global.sharedInstance.providerID as AnyObject
        print("aicie \(Global.sharedInstance.providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetCustomerActiveOrdersBySupplier(dictionaryForServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if  let _ = RESPONSEOBJECT["Result"] as? Int {
                                let possiblerezult = RESPONSEOBJECT["Result"] as! Int
                                self.bIsAproved = possiblerezult
                            }
                        } else {
                            //error user not found
                            self.bIsAproved = 0
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                self.bIsAproved = 0

            })
        }
    }

    func getProvidersList() {
        self.providersArray  = []
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Global.sharedInstance.currentUser.iUserId != 0  {
            dictionaryForServer["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject

            self.generic.showNativeActivityIndicator(self)

            if Reachability.isConnectedToNetwork() == false {
                self.generic.hideNativeActivityIndicator(self)
                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            } else {
                api.sharedInstance.GetProviderListForCustomerAuthorizedFromSupplier(dictionaryForServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3 {
                                //  self.showAlertDelegateX("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            } else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                                //\\   Global.sharedInstance.dicResults  = Array<Dictionary<String,AnyObject>>()
                                self.dicResultsOK = Array<Dictionary<String,AnyObject>>()
                                let searchObj:SearchResulstsObj = SearchResulstsObj()
                                self.dicResultsOK = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>

                                self.providersArray = searchObj.objProvidersToArray(self.dicResultsOK)
                                //       print("dicResultsOK \(self.providersArray)")
                                //                                for a in self.providersArray {
                                //                                    print("dicResultsOK \(a.nvProviderHeader)")
                                //                                    print("dicResultsOK \(a.nvProviderLogo)")
                                //                                }

                            }
                        }
                    }
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                })

            }
        } else if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil {
            print("need currentUserId \(String(describing: Global.sharedInstance.defaults.value(forKey: "currentUserId")))")
            var iUserId = 0
            var  DICTGET:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            DICTGET = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            if DICTGET["currentUserId"] != nil {
                iUserId = DICTGET["currentUserId"] as! Int
            }
            if iUserId > 0 {
                //dic["iUserId"] = Global.sharedInstance.defaults.valueForKey("currentUserId")
                dictionaryForServer["iUserId"] = iUserId as AnyObject
                if Reachability.isConnectedToNetwork() == false {
                    self.generic.hideNativeActivityIndicator(self)
                    Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                } else {
                    api.sharedInstance.GetProviderListForCustomerAuthorizedFromSupplier(dictionaryForServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3 {
                                    //     self.showAlertDelegateX("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                } else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                                    //\\   Global.sharedInstance.dicResults  = Array<Dictionary<String,AnyObject>>()
                                    self.dicResultsOK = Array<Dictionary<String,AnyObject>>()
                                    let searchObj:SearchResulstsObj = SearchResulstsObj()
                                    if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                        self.dicResultsOK = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                    }
                                    self.providersArray = searchObj.objProvidersToArray(self.dicResultsOK)
                                    print("providersArray \(self.providersArray.count)")
                                }
                            }
                        }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                    })
                }
            }
        }
    }
    func GetProviderSettingsForCalendarmanagement() {
        let USERDEF = UserDefaults.standard
        var providerID:Int = 0
        if isfromSPECIALSUPPLIER == true {

            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as Int
            }
        } else {
            providerID = Global.sharedInstance.providerID as Int
        }
        print("providerIDzzzz \(Global.sharedInstance.providerID)")
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dictionaryForServer["iProviderId"] = providerID as AnyObject
        print("aicie \(providerID)")
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetProviderSettingsForCalendarmanagement(dictionaryForServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
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
                                    if let _:Int = possiblerezult["iPeriodInWeeksForMaxServices"] as? Int {
                                        self.iPeriodInWeeksForMaxServices = possiblerezult["iPeriodInWeeksForMaxServices"] as! Int
                                        if  self.iPeriodInWeeksForMaxServices == 0 {
                                            self.iPeriodInWeeksForMaxServices  = 6
                                        }
                                    } else {
                                        self.iPeriodInWeeksForMaxServices = 6
                                    }
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
                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
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
    func shownoavalaibleworkers() {
        //presumtive fix    self.view.makeToast(message: "NO_EMPLOYE_AVALAIBLEnow".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionDefault as AnyObject)
    }
    func showMoreInfo(_ index:Int)
    {
        let viewCon:ServiceInformationViewController = self.storyboard!.instantiateViewController(withIdentifier: "ServiceInformation") as! ServiceInformationViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        viewCon.serviceName = ProviderServicesArray[index].nvServiceName
        viewCon.sumOfService = String(ProviderServicesArray[index].iPrice)
        viewCon.durationOfService = String(ProviderServicesArray[index].iTimeOfService)
        viewCon.name = lblName.text!
        viewCon.desc = lblDesc.text!
        viewCon.address = lblCity.text!
        viewCon.km = lblNumKM.text!
        viewCon.imageLogo = imgLogo.image!
        viewCon.numRuting = lblNumRuting.text!
        viewCon.numVoters = lblNumVoters.text!
        var decodedimage:UIImage = UIImage()
        var dataDecoded:Data = Data()
        if isfromSPECIALSUPPLIER == false {
            dataDecoded = Data(base64Encoded: (Global.sharedInstance.dicResults[indexRow]["nvProviderHeader"]?.description)!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        } else {
            dataDecoded = Data(base64Encoded: (Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        }
        if UIImage(data: dataDecoded) != nil
        {
            decodedimage = UIImage(data: dataDecoded)!
            viewCon.img = decodedimage
        }
        else
        {
            viewCon.img = UIImage(named: "cover_pic.jpg")!
        }
        self.present(viewCon, animated: true, completion: nil)
    }
    func openMultiple() {
        //MultipleAppontmentsViewController
        let frontviewcontroller = storyboard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let testStoryBoard = UIStoryboard(name: "Testing", bundle: nil)
        let multipleAppointments:MultipleAppointmentsViewController = testStoryBoard.instantiateViewController(withIdentifier: "MultipleAppointmentsViewController")as! MultipleAppointmentsViewController
        let USERDEF = Global.sharedInstance.defaults
        USERDEF.set(self.isfromSPECIALiCustomerUserId, forKey: "isfromSPECIALiCustomerUserId")
        USERDEF.synchronize()
        multipleAppointments.isfromSPECIALiCustomerUserId = self.isfromSPECIALiCustomerUserId
        frontviewcontroller?.pushViewController(multipleAppointments,animated: false)
        let rearViewController = storyboard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }

    func read_iMaxServiceForCustomer() -> Int {
        let need_Int = self.iMaxServiceForCustomer
        return need_Int
    }


    func openFromMenu(_ con:UIViewController)
    {
        self.present(con, animated: true, completion: nil)
    }

    func reloadTblService()
    {
        tblServices.reloadData()
    }
    func verifyifcanmakemultipleappoinments() -> Bool {
        var canmakemultipleappoinments:Bool = false
        let whattocheck =  Global.sharedInstance.providerID
        for item in self.providersArray {
            if item.iProviderId == whattocheck {
                canmakemultipleappoinments = true
                break
            }
        }
        return canmakemultipleappoinments
    }
    func openSearchResults()
    {
        let frontviewcontroller = storyboard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SearchResults") as! SearchResultsViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        let rearViewController = storyboard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }

    func openGiveMyService()
    {
        let frontviewcontroller = storyboard1!.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
        let giveMyServices:giveMyServicesViewController = clientStoryBoard.instantiateViewController(withIdentifier: "giveMyServicesViewController")as! giveMyServicesViewController
        frontviewcontroller?.pushViewController(giveMyServices, animated: false)
        let rearViewController = storyboard1!.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    func getnews(){
        var dictionaryForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            var userID:Int = 0
            if let _:NSDictionary =  (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary) {
                let currentUserDictionary:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as! NSDictionary
                if let currentUserID:Int = currentUserDictionary.value(forKey: "currentUserId") as? Int{
                    userID = currentUserID
                }
                dictionaryForServer["iUserId"] = userID as AnyObject
            }
            api.sharedInstance.GetNewsAndUpdates(dictionaryForServer,  success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Result"] as? NSNull {
                        Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else{
                        if let response = RESPONSEOBJECT["Result"] as? String {
                            self.lblAdvertising.tag = 101
                            self.lblAdvertising.type = .continuous
                            self.lblAdvertising.animationCurve = .linear
                            self.lblAdvertising.type = .leftRight
                            self.lblAdvertising.text  = response
                            self.lblAdvertising.restartLabel()
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                if AppDelegate.showAlertInAppDelegate == false
                {
                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    AppDelegate.showAlertInAppDelegate = true
                }
            })
        }
    }
    //NOT USED ANYMORE
   @objc  func imageTapped(){
        if self.isfromSPECIALSUPPLIER {
            let storyBoard = UIStoryboard(name:"SupplierExist", bundle: nil)
            let viewCon:PLUSMENUSupplier = storyBoard.instantiateViewController(withIdentifier: "PLUSMENUSupplier") as! PLUSMENUSupplier
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            viewCon.delegate = self
            self.present(viewCon, animated: true, completion: nil)
        } else {
            let storyboard1:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewCon:MenuPlusViewController = storyboard1.instantiateViewController(withIdentifier: "MenuPlusViewController") as! MenuPlusViewController
            viewCon.delegate = self
            viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(viewCon, animated: true, completion: nil)
        }
    }
    //    if isfromSPECIALSUPPLIER == true { //
    //    Global.sharedInstance.canselectmultiple = true
    //    let USERDEF = UserDefaults.standard
    //    USERDEF.set(1, forKey: "isfromSPECIALSUPPLIER")
    //    USERDEF.synchronize()
    //    let tapOpenPlusMenuNewProvider:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPlusMenuNewProvider))
    //    tapOpenPlusMenuNewProvider.delegate = self
    //    CentralButton.addGestureRecognizer(tapOpenPlusMenuNewProvider)
    //    CentralButtonImg.image = UIImage(named: "Plus menu icon - Supplier")
    //    } else {
    //    let USERDEF = UserDefaults.standard
    //    USERDEF.set(0, forKey: "isfromSPECIALSUPPLIER")
    //    USERDEF.synchronize()
    //    let tapOpenPlusMenuNewCustomer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPlusMenuNewCustomer))
    //    tapOpenPlusMenuNewCustomer.delegate = self
    //    CentralButton.addGestureRecognizer(tapOpenPlusMenuNewCustomer)
    //    CentralButtonImg.image = UIImage(named: "Plus menu icon - Customer")
    //    }
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
}
