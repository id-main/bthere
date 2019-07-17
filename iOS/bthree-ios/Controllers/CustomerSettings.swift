//
//  CustomerSettings.swift -> replaces  DefinationsClientViewController Implementing more clear and elegant Collectionview to avoid 40 views....
//  Bthere
//
//  Created by Ioan Ungureanu on 30.08.2017 /d/m/y
//  Copyright © 2017 Bthere. All rights reserved.
//
/*
 Settings
 1. Personal details
 2. Notifications
 3. Payment
 4. Delete user
 5. Language
 */
import UIKit

class CustomerSettings: NavigationModelViewController, UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout  {
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    @IBOutlet weak var titlescreen:UILabel!
    @IBOutlet weak var ttil:UICollectionView! //our items
    @IBOutlet weak var containerttil:UIView!
    var itemuri:[String] = []
    var generic:Generic = Generic()
    var subView:UIView = UIView()
    var view1 : NotificationsViewController!
    var view3 :RegisterBuisnessProphielViewController!
    var view2 :SupplierBusinessDetailViewController!
    var view4 :GlobalDataViewController!
    var view5 :SupplierContactSyncViewController!
    var viewnew: SupplierSettingsCalendar!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:23)  
        self.itemuri = [
            "PERSONAL_DETAILS_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "NOTIFICATIONS".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            // "PAYMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            // "DELETE_USER_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "LANG".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ]
        self.ttil.delegate = self
        self.ttil.dataSource = self
        self.ttil.layer.shadowColor = UIColor.black.cgColor
        self.ttil.layer.shadowOpacity = 0.4
        self.ttil.layer.shadowOffset = CGSize.zero
        self.ttil.layer.shadowRadius = 1.5
    }
    
    //MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemuri.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell:CellSettingscustomer = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSettingscustomer",for: indexPath) as! CellSettingscustomer
        //  Aligning right to left on UICollectionView when RTL language
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            cell.transform = scalingTransform
        }
        let i:Int = indexPath.row
        cell.rowDIfferent = i
        DispatchQueue.main.async {
            cell.setDisplayDatax(self.itemuri[i])
        }
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout
//        collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt
        indexPath: IndexPath) {
        let i:Int = indexPath.row
        self.goToScreens(i + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0,left: 0,bottom: 0,right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, UIEdgeInsets indexPath: IndexPath?) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0,bottom: 0,right: 0);
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let totalHeight: CGFloat = (self.view.frame.width / 3)
        let totalWidth: CGFloat = (self.view.frame.width / 3)
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath?) -> CGSize {
//        let totalHeight: CGFloat = (self.view.frame.width / 3)
//        let totalWidth: CGFloat = (self.view.frame.width / 3)
//        return CGSize(width: totalWidth, height: totalHeight)
//    }
    

    
    func goToScreens(_ screen:Int) {
        switch screen {
        case 1:
            openPersonDetails()
            break
        case 2:
            openNotifications()
            break
//        case 3:
//            openPayments()
//            break
//        case 4:
//            deleteUser()
//            break
        case 3:
            openLanguage()
            break
        default:
            //nothing
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        self.titlescreen.text = "SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            self.ttil.transform = scalingTransform
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func addShaddow(_ view:UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 1.5
    }
    //1.
    func openPersonDetails(){
        if Global.sharedInstance.arrayDicForTableViewInCell[2]![2].count == 0
        {
            if Reachability.isConnectedToNetwork() == false
            {
//                Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {
                let dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                api.sharedInstance.GetSysAlertsList(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    let sysAlert:SysAlerts = SysAlerts()
                    Global.sharedInstance.arrSysAlerts = sysAlert.sysToArray(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                    if Global.sharedInstance.arrSysAlerts.count != 0
                    {
                        Global.sharedInstance.dicSysAlerts = sysAlert.sysToDic(Global.sharedInstance.arrSysAlerts)
                        Global.sharedInstance.arrayDicForTableViewInCell[0]![1] = sysAlert.SysnvAletName(8)
                        Global.sharedInstance.arrayDicForTableViewInCell[2]![1] = sysAlert.SysnvAletName(9)
                        Global.sharedInstance.arrayDicForTableViewInCell[2]![2] = sysAlert.SysnvAletName(12)
                        Global.sharedInstance.arrayDicForTableViewInCell[3]![1] = sysAlert.SysnvAletName(10)
                        Global.sharedInstance.arrayDicForTableViewInCell[3]![2] = sysAlert.SysnvAletName(12)
                    }
                        self.openCustomer()
                    }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                        if AppDelegate.showAlertInAppDelegate == false
//                        {
//                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                            AppDelegate.showAlertInAppDelegate = true
//                        }
                })
            }
        }
        else
        {
            self.openCustomer()
        }
    }
    //2.
    @objc func openNotifications(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller:UINavigationController = UINavigationController()
        let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
        let vc = storyboardCExist.instantiateViewController(withIdentifier: "notificationsForDefinationsViewController") as! notificationsForDefinationsViewController
        frontviewcontroller.pushViewController(vc, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    //3.
    func openPayments(){
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let frontviewcontroller:UINavigationController = UINavigationController()
         let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
         let vc = storyboardCExist.instantiateViewControllerWithIdentifier("PaymentMethodViewController") as! PaymentMethodViewController
         frontviewcontroller.pushViewController(vc, animated: false)
         let rearViewController = storyboard.instantiateViewControllerWithIdentifier("MenuTableViewController") as? MenuTableViewController
         let mainRevealController = SWRevealViewController()
         mainRevealController.frontViewController = frontviewcontroller
         mainRevealController.rearViewController = rearViewController
         let window :UIWindow = UIApplication.sharedApplication().keyWindow!
         window.rootViewController = mainRevealController*/
    }
    //4.
    func deleteUser(){
        /*let mainstoryb = UIStoryboard(name: "Main", bundle: nil)
         let viewCon: DeleteProvider = mainstoryb.instantiateViewControllerWithIdentifier("DeleteProvider")as! DeleteProvider
         viewCon.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
         viewCon.isProvider = false
         viewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
         if self.iOS8 {
         viewCon.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
         } else {
         viewCon.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
         }
         self.presentViewController(viewCon, animated: true, completion: nil)*/
    }
    //5.
    @objc func openLanguage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller:UINavigationController = UINavigationController()
        let storyboardClientExist = UIStoryboard(name: "ClientExist", bundle: nil)
        let vc = storyboardClientExist.instantiateViewController(withIdentifier: "langForClientViewController") as! langForClientViewController
        vc.isfromsettings = true
        frontviewcontroller.pushViewController(vc, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    func openCustomer() {
        var dicGetCustomerDetails:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicGetCustomerDetails["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject

        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false {
            self.generic.hideNativeActivityIndicator(self)
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            api.sharedInstance.GetCustomerDetails(dicGetCustomerDetails, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in

                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _:Dictionary<String,AnyObject> = RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                        let FULLDICTIONARY = RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                    //\\    print(FULLDICTIONARY)
                        var dicForDefault:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                        if let _ = FULLDICTIONARY["bIsGoogleCalendarSync"] as? Int {
                            let x = FULLDICTIONARY["bIsGoogleCalendarSync"] as! Int
                            if x == 0 {
                                Global.sharedInstance.currentUser.bIsGoogleCalendarSync = false
                            } else {
                                Global.sharedInstance.currentUser.bIsGoogleCalendarSync = true
                            }
                            print("personal informations calendar \(Global.sharedInstance.currentUser.bIsGoogleCalendarSync)")

                        }
                        dicForDefault["nvClientName"] = FULLDICTIONARY["nvFirstName"]
                        dicForDefault["nvPhone"] = FULLDICTIONARY["nvPhone"]
                        Global.sharedInstance.defaults.set(dicForDefault, forKey: "currentClintName")
                        var dicUserId:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                        dicUserId["currentUserId"] = FULLDICTIONARY["iUserId"]
                        Global.sharedInstance.defaults.set(dicUserId, forKey: "currentUserId")
                        Global.sharedInstance.currentUser = Global.sharedInstance.currentUser.dicToUser(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                        Global.sharedInstance.currentUser.dBirthdate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dBirthdate
                            , options: [])!
                        Global.sharedInstance.currentUser.dMarriageDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 3, to: Global.sharedInstance.currentUser.dMarriageDate
                            , options: [])!
                        self.readpersonaldetails()
                    }
                }
                self.generic.hideNativeActivityIndicator(self)
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                if AppDelegate.showAlertInAppDelegate == false {
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                    AppDelegate.showAlertInAppDelegate = true
//                }
                self.readpersonaldetails()
            })
        }
    }
    func readpersonaldetails() {

        Global.sharedInstance.isProvider = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller:UINavigationController = UINavigationController()
        let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
        let vc = storyboardCExist.instantiateViewController(withIdentifier: "personalDetailsViewController") as! personalDetailsViewController
        frontviewcontroller.pushViewController(vc, animated: false)
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
    
}
