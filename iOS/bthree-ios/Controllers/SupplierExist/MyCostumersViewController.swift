////OLDCODE
////
////  MyCostumersViewController.swift
////  bthree-ios
////
////  Created by User on 21.4.2016.
////  Copyright © 2016 Webit. All rights reserved.
////
//
//import UIKit
//protocol reloadall{
//    func reloadTable()
//}
//
//
//class MyCostumersViewController: NavigationModelViewController,UIGestureRecognizerDelegate,UITextFieldDelegate,deleteItemInTableView,closeCollectionDelegate,reloadall {
//    var view8doi : loadingBthere!
//    var refreshControl: UIRefreshControl!
//    var EMPLOYEISMANAGER:Bool = false
//    var generic:Generic = Generic()
//    var myArray : NSMutableArray = []
//    var issearch:Bool = false
//    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
//    var indexRow:Int = 0
//    @IBOutlet weak var tblCustomers: UITableView!
//    @IBOutlet weak var viewAddCustomer: UIView!
//    @IBOutlet weak var txtSearchCustomer: UITextField!
//    @IBOutlet weak var viewSearch: UIView!
//    @IBOutlet weak var BTNSEARCH : UIButton!
//    @IBOutlet weak var titleofScreen: UILabel!
//    @IBOutlet weak var ocasionalcustomer: UILabel!
//    @IBOutlet weak var addcustomer: UILabel!
//
//
//    @IBAction func btnOpenNewCustomer(_ sender: AnyObject?) {
//        let viewCon:AddNewCustomerViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddNewCustomerViewController") as! AddNewCustomerViewController
//        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
//        viewCon.delegate = self
//        self.present(viewCon, animated: true, completion: nil)
//
//    }
//    @IBAction func btnAddOcasional(_ sender: AnyObject?) {
//        let viewCon:OcasionalCustomerPhoneViewController = storyboard?.instantiateViewController(withIdentifier: "OcasionalCustomer") as! OcasionalCustomerPhoneViewController
//        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
//        self.present(viewCon, animated: true, completion: nil)
//    }
//    //JMODE
//    @IBAction func btnsearch(_ sender: AnyObject?) {
//
//        let textX: String = txtSearchCustomer.text!
//        if textX != "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE) &&  textX.characters.count > 0  {
//            let  mysearchtxt = textX
//            Global.sharedInstance.ISSEARCHINGCUSTOMER = true
//            let namePredicate =
//                NSPredicate(format: "nvFullName contains[cd] %@",mysearchtxt)
//            Global.sharedInstance.searchCostumersArray = Global.sharedInstance.nameCostumersArray.filter { namePredicate.evaluate(with: $0) } as! NSMutableArray
//            print("names = \(Global.sharedInstance.searchCostumersArray)")
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.tblCustomers.reloadData()
//            })
//        } else {
//            Global.sharedInstance.ISSEARCHINGCUSTOMER = false
//            Global.sharedInstance.searchCostumersArray = Global.sharedInstance.nameCostumersArray
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.tblCustomers.reloadData()
//            })
//        }
//    }
//
//    func reloadTable() {
//        DispatchQueue.main.async(execute: { () -> Void in
//            self.openProvider()
//        })
//        self.myArray = []
//        self.view.addBackground()
//        self.titleofScreen.text = "MY_CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        Global.sharedInstance.isfromSPECIALiCustomerUserId = 0 //!IMPORTANT so no customer is selected at start
//        getCustomers()
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        DispatchQueue.main.async(execute: { () -> Void in
//            self.openProvider()
//        })
//        self.myArray = []
//        self.view.addBackground()
//        self.titleofScreen.text = "MY_CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        Global.sharedInstance.isfromSPECIALiCustomerUserId = 0 //!IMPORTANT so no customer is selected at start
//        getCustomers()
//
//    }
//    override func viewDidAppear(_ animated: Bool) {
//
//    }
//    func refreshTable(_ sender:AnyObject) {
//        // Code to refresh table view
//        print("merge")
//        self.myArray = []
//        getCustomers()
//        refreshControl.endRefreshing()
//    }
//    //    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
//    //                for cell in self.tblCustomers.visibleCells {
//    //                    let cell1:MyCostumerTableViewCell = cell as! MyCostumerTableViewCell
//    //                                          self.closeCollection(cell1.collItems)
//    //
//    //                }
//    //    }
//    //    func handleSwipes(sender:UISwipeGestureRecognizer) {
//    //        if (sender.direction == .Left) {
//    //                            for cell in self.tblCustomers.visibleCells {
//    //                                let cell1:MyCostumerTableViewCell = cell as! MyCostumerTableViewCell
//    //                                                      self.closeCollection(cell1.collItems)
//    //
//    //                            }
//    //        }
//    //
//    //        if (sender.direction == .Right) {
//    //            for cell in self.tblCustomers.visibleCells {
//    //                let cell1:MyCostumerTableViewCell = cell as! MyCostumerTableViewCell
//    //                self.closeCollection(cell1.collItems)
//    //
//    //            }
//    //        }
//    //    }
//    var viewhelp : helpPpopup!
//    func LOADHELPERS() {
//        var HELPSCREENKEYFORNSUSERDEFAULTS = ""
//        let USERDEF = UserDefaults.standard
//        var imagesarray:NSArray = NSArray()
//        //     returnCURRENTHELPSCREENS() -> (HLPKEY:String, imgs:NSArray)
//        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
//        imagesarray = appDelegate.returnCURRENTHELPSCREENS()
//        HELPSCREENKEYFORNSUSERDEFAULTS = appDelegate.returnCURRENTKEY()
//        if  imagesarray.count > 0 {
//            let fullimgarr:NSMutableArray = imagesarray.mutableCopy() as! NSMutableArray
//            print("aaa \(fullimgarr.description)")
//            if let mydict:NSMutableDictionary = fullimgarr[8] as? NSMutableDictionary {
//                if mydict["seen"] as! Int == 1 { //was not seen
//                    let changedictionary: NSMutableDictionary = NSMutableDictionary()
//                    changedictionary["needimage"] = mydict["needimage"]
//                    changedictionary["seen"] = 0 //seen
//                    fullimgarr[8] = changedictionary
//                    USERDEF.set(fullimgarr, forKey: HELPSCREENKEYFORNSUSERDEFAULTS)
//                    USERDEF.synchronize()
//                    let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
//                    viewhelp = storyboardtest.instantiateViewController(withIdentifier: "helpPpopup") as! helpPpopup
//                    if self.iOS8 {
//                        viewhelp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                    } else {
//                        viewhelp.modalPresentationStyle = UIModalPresentationStyle.currentContext
//                    }
//                    viewhelp.indexOfImg = 8
//                    viewhelp.HELPSCREENKEYFORNSUSERDEFAULTS = HELPSCREENKEYFORNSUSERDEFAULTS
//                    self.present(viewhelp, animated: true, completion: nil)
//                }
//            }
//        }
//    }
//    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
//    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // helpPpopup
//        //\\TOdo
//        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.setHELPSCREENS()
//        self.LOADHELPERS()
//        //        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(MyCostumersViewController.handleSwipes(_:)))
//        //        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(MyCostumersViewController.handleSwipes(_:)))
//        //
//        //        leftSwipe.direction = .Left
//        //        rightSwipe.direction = .Right
//        //
//        //        self.tblCustomers.addGestureRecognizer(leftSwipe)
//        //        self.tblCustomers.addGestureRecognizer(rightSwipe)
//
//        refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "PULL_TO_REFRESH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//        refreshControl.addTarget(self, action: #selector(MyCostumersViewController.refreshTable(_:)), for: UIControlEvents.valueChanged)
//        self.tblCustomers.addSubview(refreshControl)
//        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0 {
//            self.EMPLOYEISMANAGER = false
//        } else {
//            self.EMPLOYEISMANAGER = true
//        }
//        txtSearchCustomer.text = "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
//            txtSearchCustomer.textAlignment = .right
//        } else {
//            txtSearchCustomer.textAlignment = .left
//        }
//
//
//        Global.sharedInstance.mycustomers = self
//        Global.sharedInstance.PresentViewMe = self
//        addcustomer.text = "ADD_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        ocasionalcustomer.text = "OCASIONAL_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        self.titleofScreen.text = "MY_CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        addcustomer.numberOfLines = 1
//        ocasionalcustomer.numberOfLines = 1
//        titleofScreen.numberOfLines = 1
//        titleofScreen.sizeToFit()
//        addcustomer.sizeToFit()
//        ocasionalcustomer.sizeToFit()
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(MyCostumersViewController.viewAddCustomerTapped))
//        viewAddCustomer.isUserInteractionEnabled = true
//        viewAddCustomer.addGestureRecognizer(tapGestureRecognizer)
//        tapGestureRecognizer.delegate = self
//        let tapKeyBoard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
//        tapKeyBoard.delegate = self
//        self.view.addGestureRecognizer(tapKeyBoard)
//
//        //        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MyCostumersViewController.respondToSwipeGesture(_:)))
//        //        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
//        //        self.tblCustomers.addGestureRecognizer(swipeRight)
//        //
//        //        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MyCostumersViewController.respondToSwipeGesture(_:)))
//        //        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
//        //        self.tblCustomers.addGestureRecognizer(swipeLeft)
//        txtSearchCustomer.delegate = self
//        txtSearchCustomer.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
//        self.tblCustomers.reloadData()
//    }
//    func textFieldDidChange(_ textField: UITextField) {
//        //Working code JMODE+
//        if textField.text?.characters.count == 0 {
//            issearch = false
//            dismissKeyBoard()
//            btnsearch(nil)
//        }
//    }
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    func dismissKeyBoard() {
//
//        view.endEditing(true)
//    }
//
//    func viewAddCustomerTapped()  {
//        print("aaaa")
//    }
//    //MARK: - Close Collection
//    func closeCollection(_ collection:UICollectionView)
//    {
//        let index:IndexPath = IndexPath(row:0, section: 0)
//        //        if Global.sharedInstance.isDeleted == true{
//        //collection.reloadData()
//        //        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
//        //             collection.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
//        //        } else {
//        collection.scrollToItem(at: index, at: UICollectionViewScrollPosition.left, animated: false)
//        //       }
//    }
//    //MARK: - Table View
//    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
//        return self.view.frame.height * 0.12
//    }
//
//    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
//        print("Global.sharedInstance.searchCostumersArray.count\(Global.sharedInstance.searchCostumersArray.count)")
//        return Global.sharedInstance.searchCostumersArray.count
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return  1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
//        let cell: MyCostumerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyCostumerTableViewCell") as! MyCostumerTableViewCell
//        cell.row = indexPath.section
//        cell.viewDelegate = self
//        //         var scalingTransform : CGAffineTransform!
//        //        scalingTransform = CGAffineTransformMakeScale(-1, 1)
//        //        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0
//        //        {
//        //            cell.transform = scalingTransform
//        //        }
//        //        let index:NSIndexPath = NSIndexPath(forRow:0, inSection: 0)
//        //JMODE REMOVED LINE   if Global.sharedInstance.isDeleted == true{
//        //
//        //JMODE REMOVED LINE  }
//        //        cell.collItems.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
//        //
//        //        }
//        //
//        cell.setDisplayData(indexPath.section)
//        //
//        let d:NSDictionary = (Global.sharedInstance.searchCostumersArray[indexPath.section]as! NSDictionary) as NSDictionary
//        print("ce are pe aici \(d.description))")
//        if let j:Int = d.object(forKey: "iCustomerUserId") as? Int {
//            cell.tag = j
//        }
//
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showContent(_:)))
//
//        tap.delegate = self
//        cell.addGestureRecognizer(tap)
//
//
//        closeCollection(cell.collItems)
//        cell.collItems.reloadData()
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
//        //  self.getProviderServicesForSupplierFunc()
//
//    }
//    func showContent(_ sender: UITapGestureRecognizer) {
//        // let cell: MyCostumerTableViewCell = sender as! MyCostumerTableViewCell
//        let tag = sender.view!.tag
//        print("sender tag \(tag)")
//        self.getProviderServicesForSupplierFunc(tag)
//    }
//
//    // MARK: - text field
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
//        if textField.text == ""
//        {
//            textField.text =  "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//            issearch = false
//            textField.resignFirstResponder()
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.tblCustomers.reloadData()
//            })
//        } else if  textField.text ==  "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE) {
//            issearch = false
//            textField.resignFirstResponder()
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.tblCustomers.reloadData()
//            })
//        }
//        else {
//            //execute search without tap button
//            self.btnsearch(nil)
//        }
//        return true
//    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == txtSearchCustomer
//        {
//            if textField.text == "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//            {
//                textField.text = ""
//            }
//        }
//    }
//    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
//        var startString = ""
//        if (textField.text != nil)
//        {
//            startString += textField.text!
//        }
//        startString += string
//        if startString.characters.count == 0
//        {
//            textField.text = "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//            issearch = false
//            dismissKeyBoard()
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.tblCustomers.reloadData()
//            })
//            return false
//        }
//        else
//        {
//            return true
//        }
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == txtSearchCustomer
//        {
//            if textField.text == ""
//            {
//                textField.text = "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//                issearch = false
//                dismissKeyBoard()
//                DispatchQueue.main.async(execute: { () -> Void in
//                    self.tblCustomers.reloadData()
//                })
//            }
//        }
//    }
//    /////////////////////////////////          DELETE CUSTOMER IN TABLE    /////////////////////////////////
//    func deleteItem(_ indexPath:Int){
//        Global.sharedInstance.isDeleted = true
//
//        //\\Global.sharedInstance.nameCostumersArray.removeAtIndex(indexPath)
//        //\\find object in search Array -> if is filtered
//        if   let d:NSDictionary = (Global.sharedInstance.searchCostumersArray.object(at: indexPath) as? NSDictionary)! as NSDictionary {
//            print("NSDictionary to delete \(d))")
//            if let i:Int = Global.sharedInstance.nameCostumersArray.index(of: d) as Int{
//                //\\  print("Customer is at index \(i)")
//                Global.sharedInstance.nameCostumersArray.removeObject(at: i)
//                Global.sharedInstance.searchCostumersArray =  Global.sharedInstance.nameCostumersArray
//                //TRY TO DELETE FROM SERVER TOO
//                if let j:Int = d.object(forKey: "iCustomerUserId") as? Int {
//                    deleteCustomer(j)
//                } else {
//                    DispatchQueue.main.async(execute: { () -> Void in
//                        self.tblCustomers.reloadData()
//                    })
//                }
//            }
//        }
//    }
//    /////////////////////////////////          DELETE CUSTOMER ON SERVER SIDE    /////////////////////////////////
//    //  DeleteCustomerFromSupplierCustomers int iCustomerUserId, int iSupplierId
//    func deleteCustomer (_ customerID :Int) {
//        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        dic["iSupplierId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
//        dic["iCustomerUserId"] = customerID as AnyObject
//        if Reachability.isConnectedToNetwork() == false
//        {
//            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//        }
//        else
//        {
//            api.sharedInstance.DeleteCustomerFromSupplierCustomers(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                if let _ = responseObject as? Dictionary<String,AnyObject> {
//                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
//                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
//                        {
//                            print("eroare la DeleteCustomerFromSupplierCustomers \(String(describing: RESPONSEOBJECT["Error"]))")
//                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
//                            {
//                                self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                            }
//                        }
//                        else
//                        {
//                            //DELETE CUSTOMER RESULT comes here
//                            print("ce astepta \(String(describing: RESPONSEOBJECT["Result"]))")
//                            DispatchQueue.main.async(execute: { () -> Void in
//                                self.tblCustomers.reloadData()
//                            })
//                        }
//                    }
//                }
//                self.generic.hideNativeActivityIndicator(self)
//
//            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//            })
//        }
//
//    }
//    /////////////////////////////////          GET CUSTOMER FOR PROVIDER    /////////////////////////////////
//    //  GetCustomersBySupplierId
//    func getCustomers() {
//        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        var providerID:Int = 0
//        if Global.sharedInstance.providerID == 0 {
//            providerID = 0
//            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
//                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//                //  Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//            }
//        } else {
//            providerID = Global.sharedInstance.providerID
//        }
//        dic["iSupplierId"] = providerID as AnyObject
//        //  dic["iSupplierId"] = 7450
//        //\\   print("now verifica \(dic)")
//        self.generic.showNativeActivityIndicator(self)
//        if Reachability.isConnectedToNetwork() == false
//        {
//            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//        }
//        else
//        {
//            api.sharedInstance.GetCustomersBySupplierId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                if let _ = responseObject as? Dictionary<String,AnyObject> {
//                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
//                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
//                        {
//                            print("eroare la getCustomers \(String(describing: RESPONSEOBJECT["Error"]))")
//                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
//                            {
//                                self.generic.hideNativeActivityIndicator(self)
//                                self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                            }
//                        }
//                        else
//                        {
//                            //client list comes here
//                            //\\       print("ce astepta \(responseObject["Result"])")
//                            //array (
//                            if let _: Array<Dictionary<String, AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String, AnyObject>>
//                            {
//
//                                let ARRAYDELUCRU : Array<Dictionary<String, AnyObject>> = (RESPONSEOBJECT["Result"] as! Array<Dictionary<String, AnyObject>>)
//                                //    print("ARRAYDELUCRU \(ARRAYDELUCRU)")
//                                for item in ARRAYDELUCRU {
//                                    let d:NSDictionary = (item as NSDictionary) as NSDictionary
//                                    let MYmutableDictionary:NSMutableDictionary = [:]
//
//                                    var STRbIsVip:Int = 0
//                                    if let somethingelse:Int =  d.object(forKey: "bIsVip") as? Int
//                                    {
//                                        STRbIsVip = somethingelse
//                                    } else if let somethingelse:Bool =  d.object(forKey: "bIsVip") as? Bool {
//
//                                        if somethingelse == true {
//                                            STRbIsVip = 1
//                                        }
//                                    }
//                                    //   print("STRbIsVip \(STRbIsVip)")
//                                    var STRiCustomerUserId:String = ""
//                                    if let somethingelse2:Int =  d.object(forKey: "iCustomerUserId") as? Int
//                                    {
//                                        STRiCustomerUserId = String(somethingelse2)
//                                    }
//                                    //  print("STRiCustomerUserId \(STRiCustomerUserId)")
//                                    var STRinvFirstName:String = ""
//                                    if let somethingelse3 =  d.object(forKey: "nvFirstName") as? String
//                                    {
//                                        STRinvFirstName = somethingelse3
//                                    }
//
//                                    var STRnvLastName:String = ""
//                                    if let somethingelse4 =  d.object(forKey: "nvLastName") as? String
//                                    {
//                                        STRnvLastName = somethingelse4
//                                    }
//                                    let STRnvFullName:String = STRinvFirstName + " " + STRnvLastName
//
//                                    var STRnvMail:String = ""
//                                    if let somethingelse5 =  d.object(forKey: "nvMail") as? String
//                                    {
//                                        STRnvMail = somethingelse5
//                                    }
//
//                                    var STRnvPhone:String = ""
//                                    if let somethingelse6 =  d.object(forKey: "nvPhone") as? String
//                                    {
//                                        STRnvPhone = somethingelse6
//                                    }
//                                    var STRnvImage:String = ""
//
//                                    if let somethingelse =  d.object(forKey: "nvImage") as? String
//                                    {
//                                        STRnvImage = somethingelse
//                                    }
//                                    else
//                                    {
//                                        STRnvImage = ""
//                                    }
//                                    var STRnvSupplierNotes = ""
//                                    if let nvSupplierRemark:String = d.object(forKey: "nvSupplierRemark") as? String {
//                                        //\\print ("nvSupplierRemark \(nvSupplierRemark)")
//                                        if(nvSupplierRemark.characters.count > 0) {
//                                            STRnvSupplierNotes = nvSupplierRemark
//                                        } else {
//                                            STRnvSupplierNotes = ""
//                                        }
//                                    }
//                                    //\\print ("STRnvSupplierNotes \(STRnvSupplierNotes)")
//                                    var STRdBirthdate:Date = Date()
//
//                                    if let somethingelse =  d.object(forKey: "dBirthdate") as? String
//                                    {
//                                        //  STRdBirthdate = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: 3, toDate: somethingelse
//                                        //       , options: [])!
//                                        STRdBirthdate = Global.sharedInstance.getStringFromDateString(somethingelse)
//                                        //      print("STRdBirthdate\(STRdBirthdate)")
//                                    } else {
//
//                                        //    print("no birthdate")
//                                        let dateString = "01/01/1901" // change to your date format
//                                        let dateFormatter = DateFormatter()
//                                        dateFormatter.dateFormat =  "dd/MM/yyyy"
//                                        STRdBirthdate = dateFormatter.date(from: dateString)!
//
//                                    }
//
//                                    var INTiCustomerUserId:Int = 0
//                                    if let somethingelse:Int =  d.object(forKey: "iCustomerUserId") as? Int
//                                    {
//                                        INTiCustomerUserId = somethingelse
//                                    }
//                                    var iStatus:Int = 0
//                                    if let ciStatus =  d.object(forKey: "iStatus") as? Int {
//                                        iStatus = ciStatus
//                                    }
//                                    var nvNickName:String = ""
//                                    if let cnvNickName = d.object(forKey: "nvNickName") as? String {
//                                        nvNickName = cnvNickName
//                                    }
//                                    MYmutableDictionary["bIsVip"] = STRbIsVip
//                                    MYmutableDictionary["nvFirstName"] = STRinvFirstName
//                                    MYmutableDictionary["nvLastName"] = STRnvLastName
//                                    MYmutableDictionary["nvFullName"] = STRnvFullName
//                                    MYmutableDictionary["nvMail"] = STRnvMail
//                                    MYmutableDictionary["nvPhone"] = STRnvPhone
//                                    MYmutableDictionary["nvImage"] = STRnvImage
//                                    MYmutableDictionary["nvSupplierRemark"] = STRnvSupplierNotes
//                                    MYmutableDictionary["dBirthdate"] = STRdBirthdate
//                                    MYmutableDictionary["iCustomerUserId"] = INTiCustomerUserId
//                                    MYmutableDictionary["iStatus"] = iStatus
//                                    MYmutableDictionary["nvNickName"] = nvNickName
//                                    if iStatus == 1 { //only those active
//                                        self.myArray.add(MYmutableDictionary)
//                                    }
//                                }
//                                /*self.myArray \(self.myArray) */
//                                print(" si count \(self.myArray.count)  " )
//                                //  self.myArray = ARRAYDELUCRU as! NSMutableArray
//                                Global.sharedInstance.nameCostumersArray = []
//                                Global.sharedInstance.searchCostumersArray = []
//                                Global.sharedInstance.nameCostumersArray = self.myArray
//                                Global.sharedInstance.searchCostumersArray = self.myArray
//                                Global.sharedInstance.ISSEARCHINGCUSTOMER = false
//                                self.generic.hideNativeActivityIndicator(self)
//                                DispatchQueue.main.async(execute: { () -> Void in
//                                    self.tblCustomers.reloadData()
//                                    //                            let cell: MyCostumerTableViewCell = self.tblCustomers.dequeueReusableCellWithIdentifier("MyCostumerTableViewCell") as! MyCostumerTableViewCell
//                                    //                            cell.row = 0
//                                    //                            cell.collItems.reloadData()
//                                })
//
//                                self.generic.hideNativeActivityIndicator(self)
//                            }
//                        }
//
//
//                    }
//                }
//                self.generic.hideNativeActivityIndicator(self)
//            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//            })
//        }
//
//    }
//
//    func getProviderServicesForSupplierFunc(_ isfromSPECIALiCustomerUserId:Int)
//    {
//        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        //dicSearch["iProviderId"] = Global.sharedInstance.providerID
//        //if Global.sharedInstance.providerID == 0 {
//        //   dicSearch["iProviderId"] = 0
//        if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
//            dicSearch["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
//            Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
//
//        } else {
//            dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject
//        }
//        print("CEEE Global.sharedInstance.providerID \(Global.sharedInstance.providerID)")
//
//        api.sharedInstance.getProviderServicesForSupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//            if let _ = responseObject as? Dictionary<String,AnyObject> {
//                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
//                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
//                    {
//                        self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//
//
//                    }
//                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
//                    {
//
//
//                        if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
//                            let ps:objProviderServices = objProviderServices()
//                            if let _:Array<Dictionary<String,AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String,AnyObject>>
//                            {
//
//                                self.ProviderServicesArray = ps.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
//
//
//                                if self.ProviderServicesArray.count == 0
//                                {
//                                    self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//
//                                }
//                                else
//                                {
//                                    for item in self.ProviderServicesArray {
//
//                                        print("self.ProviderServicesArray \(item.description)")
//                                    }
//                                    //make them optional or it will crash
//
//
//                                    let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
//                                    let frontviewcontroller:UINavigationController? = UINavigationController()
//                                    Global.sharedInstance.arrayServicesKodsToServer = []
//                                    Global.sharedInstance.arrayServicesKods = []
//                                    Global.sharedInstance.viewCon = clientStoryBoard.instantiateViewController(withIdentifier: "SupplierListServicesViewController") as?ListServicesViewController
//                                    if let  Anarray:Array<objProviderServices> =  self.ProviderServicesArray  {
//                                        Global.sharedInstance.viewCon?.ProviderServicesArray   = Anarray
//                                        Global.sharedInstance.viewCon?.indexRow = self.indexRow //it is 0 because we are from own supplier only one row then
//                                        Global.sharedInstance.viewCon?.isfromSPECIALSUPPLIER = true
//                                        Global.sharedInstance.viewCon?.isfromSPECIALiCustomerUserId = isfromSPECIALiCustomerUserId
//                                        print("zzzisfromSPECIALiCustomerUserId  \(isfromSPECIALiCustomerUserId)")
//                                    }
//
//                                    frontviewcontroller!.pushViewController(Global.sharedInstance.viewCon!, animated: false)
//                                    //initialize REAR View Controller- it is the LEFT hand menu.
//                                    let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
//                                    let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//                                    let mainRevealController = SWRevealViewController()
//                                    mainRevealController.frontViewController = frontviewcontroller
//                                    mainRevealController.rearViewController = rearViewController
//                                    let window :UIWindow = UIApplication.shared.keyWindow!
//                                    window.rootViewController = mainRevealController
//                                }
//                            }
//                        } else {
//                            self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        }
//                    }
//                }
//            }
//        },failure: {(AFHTTPRequestOperation, Error) -> Void in
//
//        })
//
//    }
//
//    func openProvider()
//    {
//        var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//
//        if Reachability.isConnectedToNetwork() == false
//        {
//
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//        }
//        else
//        {
//            if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 {
//                dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
//                api.sharedInstance.getProviderAllDetails(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//                    if let _ = responseObject as? Dictionary<String,AnyObject> {
//                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
//
//                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
//                            {
//                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//                            }
//                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
//                            {
//                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
//
//
//                            }
//                            else
//                            {
//                                Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
//                                //  print ("1 -> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName)")
//                                //  print ("2-> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress)")
//                                //  print ("3 -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen)")
//                                //  print ("4 -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage)")
//
//
//
//                            }
//                        }
//                    }
//
//                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
//                })
//            }
//
//            else {
//                tryGetSupplierCustomerUserIdByEmployeeId()
//
//            }
//
//        }
//    }
//
//}
//func tryGetSupplierCustomerUserIdByEmployeeId() {
//    var y:Int = 0
//    var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//
//    let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
//    if let x:Int = a.value(forKey: "currentUserId") as? Int{
//        y = x
//    }
//    dicuser["iUserId"] =  y as AnyObject
//    api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
//        if let _ = responseObject as? Dictionary<String,AnyObject> {
//            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
//            if let _:Int = RESPONSEOBJECT["Result"] as? Int
//            {
//                let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
//                print("sup id e ok ? " + myInt.description)
//                if myInt == 0 {
//                    //NO EMPL NO BUSINESS
//                    //   self.setupdefaults(0)
//                    //\\print ("no business")
//                } else {
//                    //self.setupdefaults(myInt)
//                    callgetprovideralldetails(myInt)
//                }
//            }
//        }
//    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//        if AppDelegate.showAlertInAppDelegate == false
//        {
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//            AppDelegate.showAlertInAppDelegate = true
//        }
//    })
//
//}
//
//
//func callgetprovideralldetails(_ iUseridSupplier:Int) {
//    api.sharedInstance.getProviderAllDetailsbyEmployeID(iUseridSupplier)
//}
////    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
////        if (touch.view!.isDescendantOfView()) {
////
////            return false
////        }
////        return true
////    }
///*
// // MARK: - Navigation
//
// // In a storyboard-based application, you will often want to do a little preparation before navigation
// override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// // Get the new view controller using segue.destinationViewController.
// // Pass the selected object to the new view controller.
// }
// */
///////////////////////////////////          GARBAGE FOR HARD CODED /////////////////////////////////
////        var emptyDictionary = [String: String]()
////        let populatedDictionary0 = ["nvFirstName": "משה IAN", "nvLastName": "IAN"]
////        let populatedDictionary1 = ["nvFirstName": "משה אהרון", "nvLastName": "FEBR"]
////        let populatedDictionary2 = ["nvFirstName": "משה אהרון", "nvLastName": "MAR"]
////        let populatedDictionary3 = ["nvFirstName": "משה אהרון", "nvLastName": "MAY"]
////        let populatedDictionary4 = ["nvFirstName": "משה אהרון", "nvLastName": "IUN"]
////        let populatedDictionary0:String =  "משה IAN IAN"
////        let populatedDictionary1:String = "ןA FEBR"
////        let populatedDictionary2:String = "משה אהרוןMAR"
////        let populatedDictionary3:String = "משה אהרון MAY"
////        let populatedDictionary4:String = "משה אהרוןN IUN"
////
////        myArray.addObject (populatedDictionary0)
////        myArray.addObject(populatedDictionary1)
////        myArray.addObject(populatedDictionary2)
////        myArray.addObject(populatedDictionary3)
////         myArray.addObject(populatedDictionary4)
////        Global.sharedInstance.nameCostumersArray = myArray

//NEWDEVELOP

//
//  MyCostumersViewController.swift
//  bthree-ios
//
//  Created by User on 21.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
protocol reloadall{
    func reloadTable()
}


class MyCostumersViewController: NavigationModelViewController,UIGestureRecognizerDelegate,UITextFieldDelegate,deleteItemInTableView,closeCollectionDelegate,reloadall,UITableViewDelegate,UITableViewDataSource {

    var numberofCustomers:Int = 0
    var numberofpages:Int = 0
    var searchiPacket:Int = 0
    var iPacket:Int = 0
    var view8doi : loadingBthere!
    var refreshControl: UIRefreshControl!
    var EMPLOYEISMANAGER:Bool = false
    var generic:Generic = Generic()
    var myArray : NSMutableArray = []
    var issearch:Bool = false
    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
    var indexRow:Int = 0
    var searcharray: NSMutableArray = []
    @IBOutlet weak var lbnumberofcustomers: UILabel!
    @IBOutlet weak var tblCustomers: UITableView!
    @IBOutlet weak var viewAddCustomer: UIView!
    @IBOutlet weak var txtSearchCustomer: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var BTNSEARCH : UIButton!
    @IBOutlet weak var titleofScreen: UILabel!
    @IBOutlet weak var ocasionalcustomer: UILabel!
    @IBOutlet weak var addcustomer: UILabel!
    @IBOutlet weak var exceptionalAppointmentLabel: UILabel!
    @IBOutlet weak var btnOpenNEWCUSTOMER: UIButton!
    @IBOutlet weak var btnExceptionalAPPOINTMENT: UIButton!
    
    @IBAction func btnOpenNewCustomer(_ sender: AnyObject?) {
        let viewCon:AddNewCustomerViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddNewCustomerViewController") as! AddNewCustomerViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        viewCon.delegate = self
        self.present(viewCon, animated: true, completion: nil)
        
    }
    @IBAction func btnAddOcasional(_ sender: AnyObject?) {
        let viewCon:OcasionalCustomerPhoneViewController = storyboard?.instantiateViewController(withIdentifier: "OcasionalCustomer") as! OcasionalCustomerPhoneViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
    }
    @IBAction func exceptionalAction(_ sender: Any)
    {
        let myViewController = AdjustYourCalendarViewController(nibName: "AdjustYourCalendarViewController", bundle: nil)
        myViewController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        myViewController.isFromCustomersMenu = true
        myViewController.modalPresentationStyle = .overCurrentContext
        self.present(myViewController, animated: true, completion: nil)
    }
    //JMODE searcharray
    //16.01.2019
    func GetCustomerPacketForSupplierIdByKeyword() {
        searcharray = []
        let textX: String = txtSearchCustomer.text!
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        dic["iSupplierId"] = providerID as AnyObject
        dic["nvKeyword"] = textX as AnyObject
        dic["iPacket"] = self.searchiPacket as AnyObject
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCustomerPacketForSupplierIdByKeyword(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    self.dismissKeyBoard()
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                        {
                            print("eroare la getCustomers \(String(describing: RESPONSEOBJECT["Error"]))")
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                self.generic.hideNativeActivityIndicator(self)
                                self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                        }
                        else
                        {
                            //client list comes here
                               print("ce astepta \(RESPONSEOBJECT["Result"])")
                            //array (
                            if let _: Array<Dictionary<String, AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String, AnyObject>>
                            {

                                let ARRAYDELUCRU : Array<Dictionary<String, AnyObject>> = (RESPONSEOBJECT["Result"] as! Array<Dictionary<String, AnyObject>>)
                                //    print("ARRAYDELUCRU \(ARRAYDELUCRU)")
                                for item in ARRAYDELUCRU {
                                    let d:NSDictionary = (item as NSDictionary) as NSDictionary
                                    let MYmutableDictionary:NSMutableDictionary = [:]

                                    var STRbIsVip:Int = 0
                                    if let somethingelse:Int =  d.object(forKey: "bIsVip") as? Int
                                    {
                                        STRbIsVip = somethingelse
                                    } else if let somethingelse:Bool =  d.object(forKey: "bIsVip") as? Bool {

                                        if somethingelse == true {
                                            STRbIsVip = 1
                                        }
                                    }
                                    //   print("STRbIsVip \(STRbIsVip)")


                                    //  print("STRiCustomerUserId \(STRiCustomerUserId)")
                                    var STRinvFirstName:String = ""
                                    if let somethingelse3 =  d.object(forKey: "nvFirstName") as? String
                                    {
                                        STRinvFirstName = somethingelse3
                                    }

                                    var STRnvLastName:String = ""
                                    if let somethingelse4 =  d.object(forKey: "nvLastName") as? String
                                    {
                                        STRnvLastName = somethingelse4
                                    }
                                    let STRnvFullName:String = STRinvFirstName + " " + STRnvLastName

                                    var STRnvMail:String = ""
                                    if let somethingelse5 =  d.object(forKey: "nvMail") as? String
                                    {
                                        STRnvMail = somethingelse5
                                    }

                                    var STRnvPhone:String = ""
                                    if let somethingelse6 =  d.object(forKey: "nvPhone") as? String
                                    {
                                        STRnvPhone = somethingelse6
                                    }
                                    var STRnvImage:String = ""

                                    if let somethingelse =  d.object(forKey: "nvImage") as? String
                                    {
                                        STRnvImage = somethingelse
                                    }
                                    else
                                    {
                                        STRnvImage = ""
                                    }
                                    var STRnvSupplierNotes = ""
                                    if let nvSupplierRemark:String = d.object(forKey: "nvSupplierRemark") as? String {
                                        //\\print ("nvSupplierRemark \(nvSupplierRemark)")
                                        if(nvSupplierRemark.characters.count > 0) {
                                            STRnvSupplierNotes = nvSupplierRemark
                                        } else {
                                            STRnvSupplierNotes = ""
                                        }
                                    }
                                    //\\print ("STRnvSupplierNotes \(STRnvSupplierNotes)")
                                    var STRdBirthdate:Date = Date()

                                    if let somethingelse =  d.object(forKey: "dBirthdate") as? String
                                    {
                                        //  STRdBirthdate = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: 3, toDate: somethingelse
                                        //       , options: [])!
                                        STRdBirthdate = Global.sharedInstance.getStringFromDateString(somethingelse)
                                        //      print("STRdBirthdate\(STRdBirthdate)")
                                    } else {

                                        //    print("no birthdate")
                                        let dateString = "01/01/1901" // change to your date format
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat =  "dd/MM/yyyy"
                                        STRdBirthdate = dateFormatter.date(from: dateString)!

                                    }

                                    var INTiCustomerUserId:Int = 0
                                    if let somethingelse:Int =  d.object(forKey: "iCustomerUserId") as? Int
                                    {
                                        INTiCustomerUserId = somethingelse
                                    }
                                    var iStatus:Int = 0
                                    if let ciStatus =  d.object(forKey: "iStatus") as? Int {
                                        iStatus = ciStatus
                                    }
                                    var nvNickName:String = ""
                                    if let cnvNickName = d.object(forKey: "nvNickName") as? String {
                                        nvNickName = cnvNickName
                                    }
                                    MYmutableDictionary["bIsVip"] = STRbIsVip
                                    MYmutableDictionary["nvFirstName"] = STRinvFirstName
                                    MYmutableDictionary["nvLastName"] = STRnvLastName
                                    MYmutableDictionary["nvFullName"] = STRnvFullName
                                    MYmutableDictionary["nvMail"] = STRnvMail
                                    MYmutableDictionary["nvPhone"] = STRnvPhone
                                    MYmutableDictionary["nvImage"] = STRnvImage
                                    MYmutableDictionary["nvSupplierRemark"] = STRnvSupplierNotes
                                    MYmutableDictionary["dBirthdate"] = STRdBirthdate
                                    MYmutableDictionary["iCustomerUserId"] = INTiCustomerUserId
                                    MYmutableDictionary["iStatus"] = iStatus
                                    MYmutableDictionary["nvNickName"] = nvNickName
                                    if iStatus == 1 { //only those active
                                        self.searcharray.add(MYmutableDictionary)
                                    }
                                }

                                print(" si count \(self.searcharray.count)  " )
                                //  self.myArray = ARRAYDELUCRU as! NSMutableArray
                                Global.sharedInstance.nameCostumersArray = []
                                Global.sharedInstance.searchCostumersArray = []
                                Global.sharedInstance.nameCostumersArray = self.searcharray
                                Global.sharedInstance.searchCostumersArray = self.searcharray
                                Global.sharedInstance.ISSEARCHINGCUSTOMER = true
                                self.generic.hideNativeActivityIndicator(self)
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.tblCustomers.reloadData()
                                })

                                self.generic.hideNativeActivityIndicator(self)
                            }
                        }


                    }
                }
                self.generic.hideNativeActivityIndicator(self)
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.dismissKeyBoard()
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    func SearchCustomersForSupplierIdByKeyword() {
        searcharray = []
        let textX: String = txtSearchCustomer.text!
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        dic["iSupplierId"] = providerID as AnyObject
        dic["nvKeyword"] = textX as AnyObject
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.SearchCustomersForSupplierIdByKeyword(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    self.dismissKeyBoard()
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                        {
                            print("eroare la getCustomers \(String(describing: RESPONSEOBJECT["Error"]))")
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                self.generic.hideNativeActivityIndicator(self)
                                self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                        }
                        else
                        {
                            //client list comes here
                            //\\       print("ce astepta \(responseObject["Result"])")
                            //array (
                            if let _: Array<Dictionary<String, AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String, AnyObject>>
                            {
                                
                                let ARRAYDELUCRU : Array<Dictionary<String, AnyObject>> = (RESPONSEOBJECT["Result"] as! Array<Dictionary<String, AnyObject>>)
                                //    print("ARRAYDELUCRU \(ARRAYDELUCRU)")
                                for item in ARRAYDELUCRU {
                                    let d:NSDictionary = (item as NSDictionary) as NSDictionary
                                    let MYmutableDictionary:NSMutableDictionary = [:]
                                    
                                    var STRbIsVip:Int = 0
                                    if let somethingelse:Int =  d.object(forKey: "bIsVip") as? Int
                                    {
                                        STRbIsVip = somethingelse
                                    } else if let somethingelse:Bool =  d.object(forKey: "bIsVip") as? Bool {
                                        
                                        if somethingelse == true {
                                            STRbIsVip = 1
                                        }
                                    }
                                    //   print("STRbIsVip \(STRbIsVip)")
                                    
                                    
                                    //  print("STRiCustomerUserId \(STRiCustomerUserId)")
                                    var STRinvFirstName:String = ""
                                    if let somethingelse3 =  d.object(forKey: "nvFirstName") as? String
                                    {
                                        STRinvFirstName = somethingelse3
                                    }
                                    
                                    var STRnvLastName:String = ""
                                    if let somethingelse4 =  d.object(forKey: "nvLastName") as? String
                                    {
                                        STRnvLastName = somethingelse4
                                    }
                                    let STRnvFullName:String = STRinvFirstName + " " + STRnvLastName
                                    
                                    var STRnvMail:String = ""
                                    if let somethingelse5 =  d.object(forKey: "nvMail") as? String
                                    {
                                        STRnvMail = somethingelse5
                                    }
                                    
                                    var STRnvPhone:String = ""
                                    if let somethingelse6 =  d.object(forKey: "nvPhone") as? String
                                    {
                                        STRnvPhone = somethingelse6
                                    }
                                    var STRnvImage:String = ""
                                    
                                    if let somethingelse =  d.object(forKey: "nvImage") as? String
                                    {
                                        STRnvImage = somethingelse
                                    }
                                    else
                                    {
                                        STRnvImage = ""
                                    }
                                    var STRnvSupplierNotes = ""
                                    if let nvSupplierRemark:String = d.object(forKey: "nvSupplierRemark") as? String {
                                        //\\print ("nvSupplierRemark \(nvSupplierRemark)")
                                        if(nvSupplierRemark.characters.count > 0) {
                                            STRnvSupplierNotes = nvSupplierRemark
                                        } else {
                                            STRnvSupplierNotes = ""
                                        }
                                    }
                                    //\\print ("STRnvSupplierNotes \(STRnvSupplierNotes)")
                                    var STRdBirthdate:Date = Date()
                                    
                                    if let somethingelse =  d.object(forKey: "dBirthdate") as? String
                                    {
                                        //  STRdBirthdate = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: 3, toDate: somethingelse
                                        //       , options: [])!
                                        STRdBirthdate = Global.sharedInstance.getStringFromDateString(somethingelse)
                                        //      print("STRdBirthdate\(STRdBirthdate)")
                                    } else {
                                        
                                        //    print("no birthdate")
                                        let dateString = "01/01/1901" // change to your date format
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat =  "dd/MM/yyyy"
                                        STRdBirthdate = dateFormatter.date(from: dateString)!
                                        
                                    }
                                    
                                    var INTiCustomerUserId:Int = 0
                                    if let somethingelse:Int =  d.object(forKey: "iCustomerUserId") as? Int
                                    {
                                        INTiCustomerUserId = somethingelse
                                    }
                                    var iStatus:Int = 0
                                    if let ciStatus =  d.object(forKey: "iStatus") as? Int {
                                        iStatus = ciStatus
                                    }
                                    var nvNickName:String = ""
                                    if let cnvNickName = d.object(forKey: "nvNickName") as? String {
                                        nvNickName = cnvNickName
                                    }
                                    MYmutableDictionary["bIsVip"] = STRbIsVip
                                    MYmutableDictionary["nvFirstName"] = STRinvFirstName
                                    MYmutableDictionary["nvLastName"] = STRnvLastName
                                    MYmutableDictionary["nvFullName"] = STRnvFullName
                                    MYmutableDictionary["nvMail"] = STRnvMail
                                    MYmutableDictionary["nvPhone"] = STRnvPhone
                                    MYmutableDictionary["nvImage"] = STRnvImage
                                    MYmutableDictionary["nvSupplierRemark"] = STRnvSupplierNotes
                                    MYmutableDictionary["dBirthdate"] = STRdBirthdate
                                    MYmutableDictionary["iCustomerUserId"] = INTiCustomerUserId
                                    MYmutableDictionary["iStatus"] = iStatus
                                    MYmutableDictionary["nvNickName"] = nvNickName
                                    if iStatus == 1 { //only those active
                                        self.searcharray.add(MYmutableDictionary)
                                    }
                                }
                                
                                print(" si count \(self.searcharray.count)  " )
                                //  self.myArray = ARRAYDELUCRU as! NSMutableArray
                                Global.sharedInstance.nameCostumersArray = []
                                Global.sharedInstance.searchCostumersArray = []
                                Global.sharedInstance.nameCostumersArray = self.searcharray
                                Global.sharedInstance.searchCostumersArray = self.searcharray
                                Global.sharedInstance.ISSEARCHINGCUSTOMER = true
                                self.generic.hideNativeActivityIndicator(self)
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.tblCustomers.reloadData()
                                })
                                
                                self.generic.hideNativeActivityIndicator(self)
                            }
                        }
                        
                        
                    }
                }
                self.generic.hideNativeActivityIndicator(self)
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.dismissKeyBoard()
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
        
        
        
    }
    
    @IBAction func btnsearch(_ sender: AnyObject?) {
        
        let textX: String = txtSearchCustomer.text!
        if textX != "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE) &&  textX.characters.count > 0  {
            if textX.characters.count < 2 {
                self.showAlertDelegateX("SEARCHLESS3LETTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                
            } else {
                Global.sharedInstance.ISSEARCHINGCUSTOMER = true
                searchiPacket = 1
                GetCustomerPacketForSupplierIdByKeyword()
            //    SearchCustomersForSupplierIdByKeyword()
            }
            //            let namePredicate =
            //                NSPredicate(format: "nvFullName contains[cd] %@",mysearchtxt)
            //            Global.sharedInstance.searchCostumersArray = Global.sharedInstance.nameCostumersArray.filter { namePredicate.evaluate(with: $0) } as! NSMutableArray
            //            print("names = \(Global.sharedInstance.searchCostumersArray)")
            //            DispatchQueue.main.async(execute: { () -> Void in
            //                self.tblCustomers.reloadData()
            //            })
        } else {
            //            Global.sharedInstance.ISSEARCHINGCUSTOMER = false
            //            Global.sharedInstance.nameCostumersArray = []
            //            Global.sharedInstance.searchCostumersArray = []
            //            Global.sharedInstance.nameCostumersArray = self.myArray
            //            Global.sharedInstance.searchCostumersArray = self.myArray
            //            Global.sharedInstance.ISSEARCHINGCUSTOMER = false
            //            Global.sharedInstance.searchCostumersArray = Global.sharedInstance.nameCostumersArray
            //            DispatchQueue.main.async(execute: { () -> Void in
            //                self.tblCustomers.reloadData()
            //            })
            //!IMPORTANT so no customer is selected at start
            let USERDEF = Global.sharedInstance.defaults
            USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
            USERDEF.synchronize()
            self.myArray = []
            self.searcharray = []
            GetMaxPacketsForSupplierId()
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.openProvider()
        })
        self.myArray = []
        self.view.addBackground()
        self.titleofScreen.text = "MY_CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
       //!IMPORTANT so no customer is selected at start
        let USERDEF = Global.sharedInstance.defaults
        USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
        USERDEF.synchronize()
        GetCustomerCountBySupplier()
        GetMaxPacketsForSupplierId()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:39)
        DispatchQueue.main.async(execute: { () -> Void in
            self.openProvider()
        })
        
        self.view.addBackground()
        self.titleofScreen.text = "MY_CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    //!IMPORTANT so no customer is selected at start
        let USERDEF = Global.sharedInstance.defaults
        USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
        USERDEF.synchronize()
        self.myArray = []
        self.searcharray = []
        GetCustomerCountBySupplier()
        GetMaxPacketsForSupplierId()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offset:CGPoint = scrollView.contentOffset
        let bounds:CGRect = scrollView.bounds
        let size:CGSize = scrollView.contentSize
        let inset:UIEdgeInsets = scrollView.contentInset
        let y:CGFloat = offset.y + bounds.size.height - inset.bottom
        let h:CGFloat = size.height
        let reload_distance:CGFloat = 70
        if(y > h + reload_distance) {
            print("load more rows")
            if Global.sharedInstance.ISSEARCHINGCUSTOMER == true {
                 if searchiPacket < numberofpages {
                searchiPacket = searchiPacket + 1
                    GetCustomerPacketForSupplierIdByKeyword()
                }
            } else {
                if iPacket < numberofpages {
                    iPacket = iPacket + 1
                    GetCustomerPacketForSupplierId()
                }
            }
        }
        
    }
    
    func GetCustomerPacketForSupplierId() {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        dic["iSupplierId"] = providerID as AnyObject
        dic["iPacket"] = iPacket as AnyObject
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCustomerPacketForSupplierId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                        {
                            print("eroare la GetCustomerPacketForSupplierId \(String(describing: RESPONSEOBJECT["Error"]))")
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                self.generic.hideNativeActivityIndicator(self)
                                self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                        }
                        else
                        {
                            //client list comes here
                            //\\       print("ce astepta \(responseObject["Result"])")
                            //array (
                            if let _: Array<Dictionary<String, AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String, AnyObject>>
                            {
                                
                                let ARRAYDELUCRU : Array<Dictionary<String, AnyObject>> = (RESPONSEOBJECT["Result"] as! Array<Dictionary<String, AnyObject>>)
                        //\\        print("ARRAYDELUCRUGetCustomerPacketForSupplierId \(ARRAYDELUCRU)")
                                for item in ARRAYDELUCRU {
                                    let d:NSDictionary = (item as NSDictionary) as NSDictionary
                                    let MYmutableDictionary:NSMutableDictionary = [:]
                                    
                                    var STRbIsVip:Int = 0
                                    if let somethingelse:Int =  d.object(forKey: "bIsVip") as? Int
                                    {
                                        STRbIsVip = somethingelse
                                    } else if let somethingelse:Bool =  d.object(forKey: "bIsVip") as? Bool {
                                        
                                        if somethingelse == true {
                                            STRbIsVip = 1
                                        }
                                    }
                                    //   print("STRbIsVip \(STRbIsVip)")
                                    var STRinvFirstName:String = ""
                                    if let somethingelse3 =  d.object(forKey: "nvFirstName") as? String
                                    {
                                        STRinvFirstName = somethingelse3
                                    }
                                    
                                    var STRnvLastName:String = ""
                                    if let somethingelse4 =  d.object(forKey: "nvLastName") as? String
                                    {
                                        STRnvLastName = somethingelse4
                                    }
                                    let STRnvFullName:String = STRinvFirstName + " " + STRnvLastName
                                    
                                    var STRnvMail:String = ""
                                    if let somethingelse5 =  d.object(forKey: "nvMail") as? String
                                    {
                                        STRnvMail = somethingelse5
                                    }
                                    
                                    var STRnvPhone:String = ""
                                    if let somethingelse6 =  d.object(forKey: "nvPhone") as? String
                                    {
                                        STRnvPhone = somethingelse6
                                    }
                                    var STRnvImage:String = ""
                                    
                                    if let somethingelse =  d.object(forKey: "nvImage") as? String
                                    {
                                        STRnvImage = somethingelse
                                    }
                                    else
                                    {
                                        STRnvImage = ""
                                    }
                                    var STRnvSupplierNotes = ""
                                    if let nvSupplierRemark:String = d.object(forKey: "nvSupplierRemark") as? String {
                                        //\\print ("nvSupplierRemark \(nvSupplierRemark)")
                                        if(nvSupplierRemark.characters.count > 0) {
                                            STRnvSupplierNotes = nvSupplierRemark
                                        } else {
                                            STRnvSupplierNotes = ""
                                        }
                                    }
                                    //\\print ("STRnvSupplierNotes \(STRnvSupplierNotes)")
                                    var STRdBirthdate:Date = Date()
                                    
                                    if let somethingelse =  d.object(forKey: "dBirthdate") as? String
                                    {
                                        //  STRdBirthdate = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: 3, toDate: somethingelse
                                        //       , options: [])!
                                        STRdBirthdate = Global.sharedInstance.getStringFromDateString(somethingelse)
                                        //      print("STRdBirthdate\(STRdBirthdate)")
                                    } else {
                                        
                                        //    print("no birthdate")
                                        let dateString = "01/01/1901" // change to your date format
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat =  "dd/MM/yyyy"
                                        STRdBirthdate = dateFormatter.date(from: dateString)!
                                        
                                    }
                                    
                                    var INTiCustomerUserId:Int = 0
                                    if let somethingelse:Int =  d.object(forKey: "iCustomerUserId") as? Int
                                    {
                                        INTiCustomerUserId = somethingelse
                                    }
                                    var iStatus:Int = 0
                                    if let ciStatus =  d.object(forKey: "iStatus") as? Int {
                                        iStatus = ciStatus
                                    }
                                    var nvNickName:String = ""
                                    if let cnvNickName = d.object(forKey: "nvNickName") as? String {
                                        nvNickName = cnvNickName
                                    }
                                    MYmutableDictionary["bIsVip"] = STRbIsVip
                                    MYmutableDictionary["nvFirstName"] = STRinvFirstName
                                    MYmutableDictionary["nvLastName"] = STRnvLastName
                                    MYmutableDictionary["nvFullName"] = STRnvFullName
                                    MYmutableDictionary["nvMail"] = STRnvMail
                                    MYmutableDictionary["nvPhone"] = STRnvPhone
                                    MYmutableDictionary["nvImage"] = STRnvImage
                                    MYmutableDictionary["nvSupplierRemark"] = STRnvSupplierNotes
                                    MYmutableDictionary["dBirthdate"] = STRdBirthdate
                                    MYmutableDictionary["iCustomerUserId"] = INTiCustomerUserId
                                    MYmutableDictionary["iStatus"] = iStatus
                                    MYmutableDictionary["nvNickName"] = nvNickName
                                    if iStatus == 1 { //only those active
                                        self.myArray.add(MYmutableDictionary)
                                    }
                                }
                                /*self.myArray \(self.myArray) */
                                print(" si count \(self.myArray.count)  " )
                                //  self.myArray = ARRAYDELUCRU as! NSMutableArray
                                Global.sharedInstance.nameCostumersArray = []
                                Global.sharedInstance.searchCostumersArray = []
                                Global.sharedInstance.nameCostumersArray = self.myArray
                                Global.sharedInstance.searchCostumersArray = self.myArray
                                Global.sharedInstance.ISSEARCHINGCUSTOMER = false
                                self.generic.hideNativeActivityIndicator(self)
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.tblCustomers.reloadData()
                                    //                            let cell: MyCostumerTableViewCell = self.tblCustomers.dequeueReusableCellWithIdentifier("MyCostumerTableViewCell") as! MyCostumerTableViewCell
                                    //                            cell.row = 0
                                    //                            cell.collItems.reloadData()
                                })
                                
                                self.generic.hideNativeActivityIndicator(self)
                            }
                        }
                        
                        
                    }
                }
                self.generic.hideNativeActivityIndicator(self)
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    func GetCustomerCountBySupplier() {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        dic["iSupplierId"] = providerID as AnyObject
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.lbnumberofcustomers.text = self.numberofCustomers.description + " " + "COSTUMERS_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCustomerCountBySupplier(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                            self.generic.hideNativeActivityIndicator(self)
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int {
                                let nrcustomers =  RESPONSEOBJECT["Result"] as! Int
                                self.numberofCustomers = nrcustomers
                                print("numberofCustomers \(self.numberofCustomers)")
                                self.lbnumberofcustomers.text = self.numberofCustomers.description + " " + "COSTUMERS_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                            }
                        }
                        else {
                            self.generic.hideNativeActivityIndicator(self)
                            self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            self.lbnumberofcustomers.text = self.numberofCustomers.description + " " + "COSTUMERS_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)

                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.lbnumberofcustomers.text = self.numberofCustomers.description + " " + "COSTUMERS_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    func GetMaxPacketsForSupplierId() {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        dic["iSupplierId"] = providerID as AnyObject
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetMaxPacketsForSupplierId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1 {
                            self.generic.hideNativeActivityIndicator(self)
                            if let _:Int = RESPONSEOBJECT["Result"] as? Int {
                                let nrpags =  RESPONSEOBJECT["Result"] as! Int
                                self.numberofpages = nrpags
                                if self.numberofpages > 0 {
                                    self.iPacket = 1
                                    self.GetCustomerPacketForSupplierId()
                                }
                            }
                        }
                        else {
                            self.generic.hideNativeActivityIndicator(self)
                            self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
    }
    
        @objc func refreshTable(_ sender:AnyObject) {
        // Code to refresh table view
        print("merge")
        // self.myArray = []
        getCustomers()
        // refreshControl.endRefreshing()
    }
    //    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    //                for cell in self.tblCustomers.visibleCells {
    //                    let cell1:MyCostumerTableViewCell = cell as! MyCostumerTableViewCell
    //                                          self.closeCollection(cell1.collItems)
    //
    //                }
    //    }
    //    func handleSwipes(sender:UISwipeGestureRecognizer) {
    //        if (sender.direction == .Left) {
    //                            for cell in self.tblCustomers.visibleCells {
    //                                let cell1:MyCostumerTableViewCell = cell as! MyCostumerTableViewCell
    //                                                      self.closeCollection(cell1.collItems)
    //
    //                            }
    //        }
    //
    //        if (sender.direction == .Right) {
    //            for cell in self.tblCustomers.visibleCells {
    //                let cell1:MyCostumerTableViewCell = cell as! MyCostumerTableViewCell
    //                self.closeCollection(cell1.collItems)
    //
    //            }
    //        }
    //    }
    var viewhelp : helpPpopup!
    func LOADHELPERS() {
        var HELPSCREENKEYFORNSUSERDEFAULTS = ""
        let USERDEF = UserDefaults.standard
        var imagesarray:NSArray = NSArray()
        //     returnCURRENTHELPSCREENS() -> (HLPKEY:String, imgs:NSArray)
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        imagesarray = appDelegate.returnCURRENTHELPSCREENS()
        HELPSCREENKEYFORNSUSERDEFAULTS = appDelegate.returnCURRENTKEY()
        if  imagesarray.count > 0 {
            let fullimgarr:NSMutableArray = imagesarray.mutableCopy() as! NSMutableArray
            print("aaa \(fullimgarr.description)")
            if let mydict:NSMutableDictionary = fullimgarr[8] as? NSMutableDictionary {
                if mydict["seen"] as! Int == 1 { //was not seen
                    let changedictionary: NSMutableDictionary = NSMutableDictionary()
                    changedictionary["needimage"] = mydict["needimage"]
                    changedictionary["seen"] = 0 //seen
                    fullimgarr[8] = changedictionary
                    USERDEF.set(fullimgarr, forKey: HELPSCREENKEYFORNSUSERDEFAULTS)
                    USERDEF.synchronize()
                    let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                    viewhelp = storyboardtest.instantiateViewController(withIdentifier: "helpPpopup") as! helpPpopup
                    if self.iOS8 {
                        viewhelp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    } else {
                        viewhelp.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    }
                    viewhelp.indexOfImg = 8
                    viewhelp.HELPSCREENKEYFORNSUSERDEFAULTS = HELPSCREENKEYFORNSUSERDEFAULTS
                    self.present(viewhelp, animated: true, completion: nil)
                }
            }
        }
    }
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    override func viewDidLoad() {
        super.viewDidLoad()
         print("   Global.sharedInstance.employeesPermissionsArray \(Global.sharedInstance.employeesPermissionsArray)")
//        for element in Global.sharedInstance.searchCostumersArray
//        {
//            print("my customer: \(element)")
//        }
        // helpPpopup
        //\\TOdo
//        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.setHELPSCREENS()
//        self.LOADHELPERS()
        //        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(MyCostumersViewController.handleSwipes(_:)))
        //        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(MyCostumersViewController.handleSwipes(_:)))
        //
        //        leftSwipe.direction = .Left
        //        rightSwipe.direction = .Right
        //
        //        self.tblCustomers.addGestureRecognizer(leftSwipe)
        //        self.tblCustomers.addGestureRecognizer(rightSwipe)
        
        //        refreshControl = UIRefreshControl()
        //        refreshControl.attributedTitle = NSAttributedString(string: "PULL_TO_REFRESH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        //        refreshControl.addTarget(self, action: #selector(MyCostumersViewController.refreshTable(_:)), for: UIControlEvents.valueChanged)
        //        self.tblCustomers.addSubview(refreshControl)
        if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0 {
            self.EMPLOYEISMANAGER = false
        } else {
            self.EMPLOYEISMANAGER = true
        }
        txtSearchCustomer.text = "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            txtSearchCustomer.textAlignment = .right
        } else {
            txtSearchCustomer.textAlignment = .left
        }
        
        
        Global.sharedInstance.mycustomers = self
        Global.sharedInstance.PresentViewMe = self
        addcustomer.text = "ADD_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ocasionalcustomer.text = "OCASIONAL_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        self.titleofScreen.text = "MY_CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        exceptionalAppointmentLabel.text = "EXCEPTIONAL_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        addcustomer.numberOfLines = 1
        ocasionalcustomer.numberOfLines = 0
        titleofScreen.numberOfLines = 1
        titleofScreen.sizeToFit()
        addcustomer.sizeToFit()
        ocasionalcustomer.sizeToFit()
        

        let tapKeyBoard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
        tapKeyBoard.delegate = self
        self.view.addGestureRecognizer(tapKeyBoard)
        
        //        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MyCostumersViewController.respondToSwipeGesture(_:)))
        //        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        //        self.tblCustomers.addGestureRecognizer(swipeRight)
        //
        //        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MyCostumersViewController.respondToSwipeGesture(_:)))
        //        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        //        self.tblCustomers.addGestureRecognizer(swipeLeft)
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(MyCostumersViewController.viewAddCustomerTapped))
        tapGestureRecognizer.delegate = self
        if self.EMPLOYEISMANAGER == true {
            //all buttons on and interactive
            viewAddCustomer.isUserInteractionEnabled = true
            viewAddCustomer.addGestureRecognizer(tapGestureRecognizer)
            viewAddCustomer.backgroundColor = Colors.sharedInstance.color3
            btnOpenNEWCUSTOMER.backgroundColor = Colors.sharedInstance.color3
            btnExceptionalAPPOINTMENT.backgroundColor = Colors.sharedInstance.color3
        } else {
             if Global.sharedInstance.employeesPermissionsArray.contains(4) && !Global.sharedInstance.employeesPermissionsArray.contains(1) { // only Invite Customers this was modifyed so not cleaning garbage
                viewAddCustomer.backgroundColor = Colors.sharedInstance.color6
                viewAddCustomer.isUserInteractionEnabled = false

                btnOpenNEWCUSTOMER.backgroundColor = Colors.sharedInstance.color3
                btnOpenNEWCUSTOMER.isUserInteractionEnabled = true

                btnExceptionalAPPOINTMENT.backgroundColor = Colors.sharedInstance.color6
                btnExceptionalAPPOINTMENT.isUserInteractionEnabled = false

            }  else if Global.sharedInstance.employeesPermissionsArray.contains(1) && !Global.sharedInstance.employeesPermissionsArray.contains(4) { // only Appointment Scheduling
                viewAddCustomer.isUserInteractionEnabled = true
                viewAddCustomer.addGestureRecognizer(tapGestureRecognizer)
                viewAddCustomer.backgroundColor = Colors.sharedInstance.color3

                btnOpenNEWCUSTOMER.backgroundColor = Colors.sharedInstance.color6
                btnOpenNEWCUSTOMER.isUserInteractionEnabled = false

                btnExceptionalAPPOINTMENT.backgroundColor = Colors.sharedInstance.color3
                btnExceptionalAPPOINTMENT.isUserInteractionEnabled = true

            } else if Global.sharedInstance.employeesPermissionsArray.contains(1) && Global.sharedInstance.employeesPermissionsArray.contains(4)  { // only Appointment Scheduling && Invite Customers
                viewAddCustomer.isUserInteractionEnabled = true
                viewAddCustomer.addGestureRecognizer(tapGestureRecognizer)
                viewAddCustomer.backgroundColor = Colors.sharedInstance.color3
                btnOpenNEWCUSTOMER.backgroundColor = Colors.sharedInstance.color3
                btnExceptionalAPPOINTMENT.backgroundColor = Colors.sharedInstance.color3

            } else //if Global.sharedInstance.employeesPermissionsArray.count == 0
             {
                viewAddCustomer.backgroundColor = Colors.sharedInstance.color6
                viewAddCustomer.isUserInteractionEnabled = false

                btnOpenNEWCUSTOMER.backgroundColor = Colors.sharedInstance.color6
                btnOpenNEWCUSTOMER.isUserInteractionEnabled = false

                btnExceptionalAPPOINTMENT.backgroundColor = Colors.sharedInstance.color6
                btnExceptionalAPPOINTMENT.isUserInteractionEnabled = false

            }
        }
        txtSearchCustomer.delegate = self
        txtSearchCustomer.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.tblCustomers.reloadData()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        //Working code JMODE+
        if textField.text?.count == 0 {
            issearch = false
            dismissKeyBoard()
            btnsearch(nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func dismissKeyBoard() {
        
        view.endEditing(true)
    }
    
    @objc func viewAddCustomerTapped()  {
        print("aaaa")
    }
    //MARK: - Close Collection
    func closeCollection(_ collection:UICollectionView)
    {
        let index:IndexPath = IndexPath(row:0, section: 0)
        //        if Global.sharedInstance.isDeleted == true{
        //collection.reloadData()
        //        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
        //             collection.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
        //        } else {
        collection.scrollToItem(at: index, at: UICollectionView.ScrollPosition.left, animated: false)
        //       }
    }
    //MARK: - Table View
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.12
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("Global.sharedInstance.searchCostumersArray.count\(Global.sharedInstance.searchCostumersArray.count)")
        return Global.sharedInstance.searchCostumersArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyCostumerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyCostumerTableViewCell") as! MyCostumerTableViewCell
        cell.row = indexPath.section
        cell.viewDelegate = self
        //         var scalingTransform : CGAffineTransform!
        //        scalingTransform = CGAffineTransformMakeScale(-1, 1)
        //        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0
        //        {
        //            cell.transform = scalingTransform
        //        }
        //        let index:NSIndexPath = NSIndexPath(forRow:0, inSection: 0)
        //JMODE REMOVED LINE   if Global.sharedInstance.isDeleted == true{
        //
        //JMODE REMOVED LINE  }
        //        cell.collItems.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        //
        //        }
        //
        cell.setDisplayData(indexPath.section)
        //

        
        let d:NSDictionary = (Global.sharedInstance.searchCostumersArray[indexPath.section]as! NSDictionary) as NSDictionary
       //\\   print("ce are pe aici \(d.description))")
        if let j:Int = d.object(forKey: "iCustomerUserId") as? Int {
            cell.tag = j
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showContent(_:)))
        tap.delegate = self
        if self.EMPLOYEISMANAGER == true  {
        cell.addGestureRecognizer(tap)
        }
        else {
            if (Global.sharedInstance.employeesPermissionsArray.contains(1))  || ( Global.sharedInstance.employeesPermissionsArray.contains(1) && Global.sharedInstance.employeesPermissionsArray.contains(4)) {
                cell.addGestureRecognizer(tap)
            }
        }

        
        
        closeCollection(cell.collItems)
        cell.collItems.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //  self.getProviderServicesForSupplierFunc()

    }
    @objc func showContent(_ sender: UITapGestureRecognizer) {
        // let cell: MyCostumerTableViewCell = sender as! MyCostumerTableViewCell
        let tag = sender.view!.tag
        print("sender tag \(tag)")
        getNameOfCustomer(iCustomerUserId:tag)
        self.getProviderServicesForSupplierFunc(tag)
    }
    
    func getNameOfCustomer(iCustomerUserId:Int)
    {
        Global.sharedInstance.nameOfCustomer = ""
        for dictionary in Global.sharedInstance.searchCostumersArray
        {
            if let dict = dictionary as? NSDictionary
            {
                if let id = dict.object(forKey: "iCustomerUserId") as? Int
                {
                    if id == iCustomerUserId
                    {
                        if let name:String = dict.object(forKey: "nvFullName") as? String
                        {
                            if name != ""
                            {
                                Global.sharedInstance.nameOfCustomer = name
                            }
                            
                        }
                        else if let name:String = dict.object(forKey: "nvFirstName") as? String
                        {
                            if name != ""
                            {
                                Global.sharedInstance.nameOfCustomer = name
                            }
                        }
                        else if let name:String = dict.object(forKey: "nvFirstName") as? String
                        {
                            if name != ""
                            {
                                Global.sharedInstance.nameOfCustomer = name
                            }
                        }
                    }
                }
            }
        
        }

    }
    
    // MARK: - text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if textField.text == ""
        {
            textField.text =  "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            issearch = false
            textField.resignFirstResponder()
            DispatchQueue.main.async(execute: { () -> Void in
                self.tblCustomers.reloadData()
            })
        } else if  textField.text ==  "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE) {
            issearch = false
            textField.resignFirstResponder()
            DispatchQueue.main.async(execute: { () -> Void in
                self.tblCustomers.reloadData()
            })
        }
        else {
            //execute search without tap button
            self.btnsearch(nil)
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtSearchCustomer
        {
            if textField.text == "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            {
                textField.text = ""
            }
        }
    }
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        var startString = ""
        if (textField.text != nil)
        {
            startString += textField.text!
        }
        startString += string
        if startString.characters.count == 0
        {
            textField.text = "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            issearch = false
            dismissKeyBoard()
            DispatchQueue.main.async(execute: { () -> Void in
                self.tblCustomers.reloadData()
            })
            return false
        }
        else
        {
            return true
        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtSearchCustomer
        {
            if textField.text == ""
            {
                textField.text = "SEARCH_CUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                issearch = false
                dismissKeyBoard()
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tblCustomers.reloadData()
                })
            }
        }
    }
    /////////////////////////////////          DELETE CUSTOMER IN TABLE    /////////////////////////////////
    func deleteItem(_ indexPath:Int){
        Global.sharedInstance.isDeleted = true
        
        //\\Global.sharedInstance.nameCostumersArray.removeAtIndex(indexPath)
        //\\find object in search Array -> if is filtered
        if   let d:NSDictionary = (Global.sharedInstance.searchCostumersArray.object(at: indexPath) as? NSDictionary)! as NSDictionary {
            print("NSDictionary to delete \(d))")
            if let i:Int = Global.sharedInstance.nameCostumersArray.index(of: d) as? Int{
                //\\  print("Customer is at index \(i)")
                Global.sharedInstance.nameCostumersArray.removeObject(at: i)
                Global.sharedInstance.searchCostumersArray =  Global.sharedInstance.nameCostumersArray
                //TRY TO DELETE FROM SERVER TOO
                if let j:Int = d.object(forKey: "iCustomerUserId") as? Int {
                    deleteCustomer(j)
                } else {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.tblCustomers.reloadData()
                    })
                }
            }
        }
        GetCustomerCountBySupplier()
    }
    /////////////////////////////////          DELETE CUSTOMER ON SERVER SIDE    /////////////////////////////////
    //  DeleteCustomerFromSupplierCustomers int iCustomerUserId, int iSupplierId
    func deleteCustomer (_ customerID :Int) {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iSupplierId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
        dic["iCustomerUserId"] = customerID as AnyObject
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.DeleteCustomerFromSupplierCustomers(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                        {
                            print("eroare la DeleteCustomerFromSupplierCustomers \(String(describing: RESPONSEOBJECT["Error"]))")
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                        }
                        else
                        {
                            //DELETE CUSTOMER RESULT comes here
                            print("ce astepta \(String(describing: RESPONSEOBJECT["Result"]))")
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.tblCustomers.reloadData()
                            })
                        }
                    }
                }
                self.generic.hideNativeActivityIndicator(self)
                
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
        GetCustomerCountBySupplier()
    }
    /////////////////////////////////          GET CUSTOMER FOR PROVIDER    /////////////////////////////////
    //  GetCustomersBySupplierId
    func getCustomers() {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var providerID:Int = 0
        if Global.sharedInstance.providerID == 0 {
            providerID = 0
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
                providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
                //  Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
        } else {
            providerID = Global.sharedInstance.providerID
        }
        dic["iSupplierId"] = providerID as AnyObject
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCustomersBySupplierId(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                        {
                            print("eroare la getCustomers \(String(describing: RESPONSEOBJECT["Error"]))")
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                            {
                                self.generic.hideNativeActivityIndicator(self)
                                self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                        }
                        else
                        {
                            //client list comes here
                            //\\       print("ce astepta \(responseObject["Result"])")
                            //array (
                            if let _: Array<Dictionary<String, AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String, AnyObject>>
                            {
                            //\\    print ("response get customers by supplier id \(RESPONSEOBJECT)")
                                let ARRAYDELUCRU : Array<Dictionary<String, AnyObject>> = (RESPONSEOBJECT["Result"] as! Array<Dictionary<String, AnyObject>>)
                                //    print("ARRAYDELUCRU \(ARRAYDELUCRU)")
                                for item in ARRAYDELUCRU {
                                    let d:NSDictionary = (item as NSDictionary) as NSDictionary
                                    let MYmutableDictionary:NSMutableDictionary = [:]
                                    
                                    var STRbIsVip:Int = 0
                                    if let somethingelse:Int =  d.object(forKey: "bIsVip") as? Int
                                    {
                                        STRbIsVip = somethingelse
                                    } else if let somethingelse:Bool =  d.object(forKey: "bIsVip") as? Bool {
                                        
                                        if somethingelse == true {
                                            STRbIsVip = 1
                                        }
                                    }
                                    //   print("STRbIsVip \(STRbIsVip)")
                                    
                                    
                                    //  print("STRiCustomerUserId \(STRiCustomerUserId)")
                                    var STRinvFirstName:String = ""
                                    if let somethingelse3 =  d.object(forKey: "nvFirstName") as? String
                                    {
                                        STRinvFirstName = somethingelse3
                                    }
                                    
                                    var STRnvLastName:String = ""
                                    if let somethingelse4 =  d.object(forKey: "nvLastName") as? String
                                    {
                                        STRnvLastName = somethingelse4
                                    }
                                    let STRnvFullName:String = STRinvFirstName + " " + STRnvLastName
                                    
                                    var STRnvMail:String = ""
                                    if let somethingelse5 =  d.object(forKey: "nvMail") as? String
                                    {
                                        STRnvMail = somethingelse5
                                    }
                                    
                                    var STRnvPhone:String = ""
                                    if let somethingelse6 =  d.object(forKey: "nvPhone") as? String
                                    {
                                        STRnvPhone = somethingelse6
                                    }
                                    var STRnvImage:String = ""
                                    
                                    if let somethingelse =  d.object(forKey: "nvImage") as? String
                                    {
                                        STRnvImage = somethingelse
                                    }
                                    else
                                    {
                                        STRnvImage = ""
                                    }
                                    var STRnvSupplierNotes = ""
                                    if let nvSupplierRemark:String = d.object(forKey: "nvSupplierRemark") as? String {
                                        //\\print ("nvSupplierRemark \(nvSupplierRemark)")
                                        if(nvSupplierRemark.characters.count > 0) {
                                            STRnvSupplierNotes = nvSupplierRemark
                                        } else {
                                            STRnvSupplierNotes = ""
                                        }
                                    }
                                    //\\print ("STRnvSupplierNotes \(STRnvSupplierNotes)")
                                    var STRdBirthdate:Date = Date()
                                    
                                    if let somethingelse =  d.object(forKey: "dBirthdate") as? String
                                    {
                                        //  STRdBirthdate = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: 3, toDate: somethingelse
                                        //       , options: [])!
                                        STRdBirthdate = Global.sharedInstance.getStringFromDateString(somethingelse)
                                        //      print("STRdBirthdate\(STRdBirthdate)")
                                    } else {
                                        
                                        //    print("no birthdate")
                                        let dateString = "01/01/1901" // change to your date format
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat =  "dd/MM/yyyy"
                                        STRdBirthdate = dateFormatter.date(from: dateString)!
                                        
                                    }
                                    
                                    var INTiCustomerUserId:Int = 0
                                    if let somethingelse:Int =  d.object(forKey: "iCustomerUserId") as? Int
                                    {
                                        INTiCustomerUserId = somethingelse
                                    }
                                    var iStatus:Int = 0
                                    if let ciStatus =  d.object(forKey: "iStatus") as? Int {
                                        iStatus = ciStatus
                                    }
                                    var nvNickName:String = ""
                                    if let cnvNickName = d.object(forKey: "nvNickName") as? String {
                                        nvNickName = cnvNickName
                                    }
                                    MYmutableDictionary["bIsVip"] = STRbIsVip
                                    MYmutableDictionary["nvFirstName"] = STRinvFirstName
                                    MYmutableDictionary["nvLastName"] = STRnvLastName
                                    MYmutableDictionary["nvFullName"] = STRnvFullName
                                    MYmutableDictionary["nvMail"] = STRnvMail
                                    MYmutableDictionary["nvPhone"] = STRnvPhone
                                    MYmutableDictionary["nvImage"] = STRnvImage
                                    MYmutableDictionary["nvSupplierRemark"] = STRnvSupplierNotes
                                    MYmutableDictionary["dBirthdate"] = STRdBirthdate
                                    MYmutableDictionary["iCustomerUserId"] = INTiCustomerUserId
                                    MYmutableDictionary["iStatus"] = iStatus
                                    MYmutableDictionary["nvNickName"] = nvNickName
                                    if iStatus == 1 { //only those active
                                        self.myArray.add(MYmutableDictionary)
                                    }
                                }
                                /*self.myArray \(self.myArray) */
                                print(" si count \(self.myArray.count)  " )
                                //  self.myArray = ARRAYDELUCRU as! NSMutableArray
                                Global.sharedInstance.nameCostumersArray = []
                                Global.sharedInstance.searchCostumersArray = []
                                Global.sharedInstance.nameCostumersArray = self.myArray
                                Global.sharedInstance.searchCostumersArray = self.myArray
                                Global.sharedInstance.ISSEARCHINGCUSTOMER = false
                                self.generic.hideNativeActivityIndicator(self)
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.tblCustomers.reloadData()
                                    //                            let cell: MyCostumerTableViewCell = self.tblCustomers.dequeueReusableCellWithIdentifier("MyCostumerTableViewCell") as! MyCostumerTableViewCell
                                    //                            cell.row = 0
                                    //                            cell.collItems.reloadData()
                                })
                                
                                self.generic.hideNativeActivityIndicator(self)
                            }
                        }
                        
                        
                    }
                }
                self.generic.hideNativeActivityIndicator(self)
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
        
    }
    
    func getProviderServicesForSupplierFunc(_ isfromSPECIALiCustomerUserId:Int)
    {
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //dicSearch["iProviderId"] = Global.sharedInstance.providerID
        //if Global.sharedInstance.providerID == 0 {
        //   dicSearch["iProviderId"] = 0
        if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0 {
            dicSearch["iProviderId"] =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails as AnyObject
            Global.sharedInstance.providerID =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            
        } else {
            dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        }
        print("CEEE Global.sharedInstance.providerID \(Global.sharedInstance.providerID)")
        
        api.sharedInstance.getProviderServicesForSupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                        self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        
                        
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        
                        
                        if let _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                            let ps:objProviderServices = objProviderServices()
                            if let _:Array<Dictionary<String,AnyObject>> = RESPONSEOBJECT["Result"] as?  Array<Dictionary<String,AnyObject>>
                            {
                                
                                self.ProviderServicesArray = ps.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                                
                                
                                if self.ProviderServicesArray.count == 0
                                {
                                    self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                    
                                }
                                else
                                {
                                    for item in self.ProviderServicesArray {
                                        
                                        print("self.ProviderServicesArray \(item.description)")
                                    }
                                    //make them optional or it will crash
//                                    Global.sharedInstance.searchCostumersArray[indexPath.section
  
//                                    for dictionary:NSDictionary in Global.sharedInstance.searchCostumersArray
//                                    {
//
//                                    }
                                    
                                    let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
                                    let frontviewcontroller:UINavigationController? = UINavigationController()
                                    Global.sharedInstance.isProvider = true
                                    Global.sharedInstance.whichReveal = true
                                    Global.sharedInstance.arrayServicesKodsToServer = []
                                    Global.sharedInstance.arrayServicesKods = []
                                    Global.sharedInstance.viewCon = clientStoryBoard.instantiateViewController(withIdentifier: "SupplierListServicesViewController") as?ListServicesViewController
                                    let USERDEF = Global.sharedInstance.defaults
                                    USERDEF.set(3,forKey: "backFromMyListServices")
                                    USERDEF.synchronize()
                                    let  Anarray:Array<objProviderServices> = self.ProviderServicesArray
                                    Global.sharedInstance.viewCon?.ProviderServicesArray   = Anarray
                                    Global.sharedInstance.viewCon?.indexRow = self.indexRow //it is 0 because we are from own supplier only one row then
                                    USERDEF.set(self.indexRow, forKey: "listservicesindexRow")
                                    USERDEF.synchronize()
                                    Global.sharedInstance.viewCon?.isfromSPECIALSUPPLIER = true
                                    Global.sharedInstance.viewCon?.isfromSPECIALiCustomerUserId = isfromSPECIALiCustomerUserId
                                    USERDEF.set(isfromSPECIALiCustomerUserId, forKey: "isfromSPECIALiCustomerUserId")
                                    USERDEF.synchronize()
                                    print("zzzisfromSPECIALiCustomerUserId  \(isfromSPECIALiCustomerUserId)")
                                    
                                    
                                    frontviewcontroller!.pushViewController(Global.sharedInstance.viewCon!, animated: false)
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
                        } else {
                            self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                    }
                }
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            
        })
        
    }
    
    func openProvider()
    {
        var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        if Reachability.isConnectedToNetwork() == false
        {
            
//            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            if !(Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1) {
                dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
                api.sharedInstance.getProviderAllDetails(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                            
                            if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1
                            {
                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            }
                            else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -2//ספק לא קיים
                            {
                                Alert.sharedInstance.showAlert("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                
                                
                            }
                            else
                            {
                                Global.sharedInstance.currentProviderDetailsObj = Global.sharedInstance.currentProviderDetailsObj.dicToProviderDetailsObj(RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>)
                                //  print ("1 -> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvSupplierName)")
                                //  print ("2-> \(Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.nvAddress)")
                                //  print ("3 -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvSlogen)")
                                //  print ("4 -> \(Global.sharedInstance.currentProviderDetailsObj.providerProfileObj.nvILogoImage)")
                                
                                
                                
                            }
                        }
                    }
                    
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                    if AppDelegate.showAlertInAppDelegate == false
//                    {
//                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//                        AppDelegate.showAlertInAppDelegate = true
//                    }
                })
            }
                
            else {
                tryGetSupplierCustomerUserIdByEmployeeId()
                
            }
            
        }
    }
    
}
func tryGetSupplierCustomerUserIdByEmployeeId() {
    var y:Int = 0
    var dicuser:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
        let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
        if let x:Int = a.value(forKey: "currentUserId") as? Int{
            y = x
        }
    }
    dicuser["iUserId"] =  y as AnyObject
    api.sharedInstance.GetSupplierCustomerUserIdByEmployeeId(dicuser, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
        if let _ = responseObject as? Dictionary<String,AnyObject> {
            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
            if let _:Int = RESPONSEOBJECT["Result"] as? Int
            {
                let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                print("sup id e ok ? " + myInt.description)
                if myInt == 0 {
                    //NO EMPL NO BUSINESS
                    //   self.setupdefaults(0)
                    //\\print ("no business")
                } else {
                    //self.setupdefaults(myInt)
                    callgetprovideralldetails(myInt)
                }
            }
        }
    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//        if AppDelegate.showAlertInAppDelegate == false
//        {
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//            AppDelegate.showAlertInAppDelegate = true
//        }
    })
    
}


func callgetprovideralldetails(_ iUseridSupplier:Int) {
//    api.sharedInstance.getProviderAllDetailsbyEmployeID(iUseridSupplier)
    
    if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
    {
        api.sharedInstance.getProviderAllDetailsbySimpleUserID(iUseridSupplier)
    }
    else
    {
        api.sharedInstance.getProviderAllDetails(iUseridSupplier)
    }
    
//    if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 1 {
//        api.sharedInstance.getProviderAllDetails(iUseridSupplier)
//    }
//    else if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0 && Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
//    {
//        api.sharedInstance.getProviderAllDetailsbySimpleUserID(iUseridSupplier)
//    }
//    else {
//        api.sharedInstance.getProviderAllDetailsbyEmployeID(iUseridSupplier)
//    }
}

