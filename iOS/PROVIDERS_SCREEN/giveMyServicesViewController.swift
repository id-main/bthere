//
//  giveMyServicesViewController.swift
//  Bthere
//
//  Created by User on 10.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

protocol deleteItemDelegate {
    func deleteItem(_ indexPath:Int)
}
protocol GiveServicesParentpresentViewControllerDelegate {
    func ParentpresentViewController()
}
//לקוח קיים: נותני השרות שלי-מתפריט פלוס
class giveMyServicesViewController: NavigationModelViewController,dismissViewControllerDelegate,UIGestureRecognizerDelegate ,deleteItemDelegate,closeCollectionDelegate,GiveServicesParentpresentViewControllerDelegate,UITableViewDelegate,UITableViewDataSource{
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    var generic:Generic = Generic()
    var storyboard1:UIStoryboard?
    //the sorted array by rating
    var dicResultSorted:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var tblResults: UITableView!
    
    // MARK: - Initial
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:22)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let USERDEF = Global.sharedInstance.defaults
        USERDEF.set(0, forKey: "isfromSPECIALiCustomerUserId")
        USERDEF.synchronize()

        Global.sharedInstance.dicResults =   Array<Dictionary<String,AnyObject>>()
        lblTitle.text = "MY_GIVESERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        Global.sharedInstance.arrayServicesKods = []
        getProviders()
        Global.sharedInstance.giveMyServices = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(giveMyServicesViewController.dismissKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        Global.sharedInstance.giveServices = self
        tblResults.separatorStyle = .none
        // Do any additional setup after loading the view.
        Global.sharedInstance.viewCon2 = storyboard1!.instantiateViewController(withIdentifier: "ViewBusinessProfileVC") as? ViewBusinessProfileVC
        Global.sharedInstance.viewCon2!.modalPresentationStyle = UIModalPresentationStyle.custom
        Global.sharedInstance.giveMyServicesForBusinessProfile = self
        Global.sharedInstance.viewCon = self.storyboard?.instantiateViewController(withIdentifier: "ListServicesViewController") as? ListServicesViewController
        Global.sharedInstance.viewCon!.backFromMyListServices = 1
        USERDEF.set(1,forKey: "backFromMyListServices")
        USERDEF.synchronize()
        Global.sharedInstance.viewCon!.delegate = self
        Global.sharedInstance.isFromEntranceOrProviders = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.addBackground2()
    }
    
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func ParentpresentViewController() {
        let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
        let viewpop:PopUpGenericViewController = storyboardtest.instantiateViewController(withIdentifier: "PopUpGenericViewController") as! PopUpGenericViewController
        if self.iOS8 {
            viewpop.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            viewpop.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        viewpop.isfromWhichScreen = 3
        self.present(viewpop, animated: true, completion: nil)
    }
    
    
    //MARK: - Table View
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if DeviceType.IS_IPHONE_5 ||  DeviceType.IS_IPHONE_4_OR_LESS{
            let bounds = UIScreen.main.bounds
            let widthscr = bounds.size.width
            var heightscr:CGFloat = 0
            heightscr = 60 + (widthscr * 0.26 )
            return heightscr
        }
        
        let bounds = UIScreen.main.bounds
        let widthscr = bounds.size.width
        var heightscr:CGFloat = 0
        heightscr = 60 + (widthscr * 0.26 )
        return heightscr
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("all providers total \(Global.sharedInstance.dicResults.count)")
        return Global.sharedInstance.dicResults.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: giveMyServiceTableViewCell = self.tblResults.dequeueReusableCell(withIdentifier: "giveMyServiceTableViewCell") as! giveMyServiceTableViewCell
        cell.PARENTDELEGATE = self
        cell.setDisplayData(indexPath.section)
        cell.colViewResult.setContentOffset(CGPoint(x: 0 , y: 0), animated: false)
        cell.colViewResult.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func dismissViewController()
    {
        Global.sharedInstance.whichDesignOpenDetailsAppointment = 0
        let viewCon = self.storyboard?.instantiateViewController(withIdentifier: "ModelCalendarForAppointments") as! ModelCalendarForAppointmentsViewController
        self.navigationController?.pushViewController(viewCon, animated: false)
    }
    
    @objc func dismissKeyboard() {
        
        self.view.endEditing(true)
    }
    
    //קבלת רשימת ספקים ללקוח
    func getProviders()
    {
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        dic["nvLong"] = Global.sharedInstance.currentLong as AnyObject
        dic["nvLat"] = Global.sharedInstance.currentLat as AnyObject
        Generic.sharedMyManager.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
              Generic.sharedMyManager.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetProviderListForCustomer(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            self.showAlertDelegateX("NO_SUPPLIERS_MATCH".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            var dicResultsfull:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
                            if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                let mydicarray = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                for element in mydicarray {
                                    if let _ = element["iIsApprovedSupplier"] as? Int {
                                        let isaproved = element["iIsApprovedSupplier"] as! Int
                                        if isaproved != 2 {
                                          dicResultsfull.append(element)
                                        }
                                    }
                                }
                                 Global.sharedInstance.dicResults = dicResultsfull
                            }

                            Generic.sharedMyManager.hideNativeActivityIndicator(self)
                            self.tblResults.reloadData()
                            
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                  Generic.sharedMyManager.hideNativeActivityIndicator(self)
            })
        }
    }
    
    //מחיקת נותן שרות
    func deleteItem(_ indexPath:Int){
        
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iCustomerUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        dic["iProviderId"] = Global.sharedInstance.dicResults[indexPath]["iProviderId"]
        
        
        if Reachability.isConnectedToNetwork() == false
        {
            
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            // מחיקה מהשרת
            api.sharedInstance.RemoveProviderFromCustomer(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    print("RemoveProviderFromCustomer \(RESPONSEOBJECT)")
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1// לא הצליחה המחיקה
                        {
                            self.showAlertDelegateX("לא ניתן למחוק ספק זה")
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1//הצליחה המחיקה
                        {
                            Global.sharedInstance.dicResults.remove(at: indexPath)
                            Global.sharedInstance.isDeletedGiveMyService = true
                            self.tblResults.reloadData()
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                
            })
        }
    }
    
    func closeCollection(_ collection:UICollectionView)
    {
        let index:IndexPath = IndexPath(row:0, section: 0)
        collection.scrollToItem(at: index, at: UICollectionView.ScrollPosition.left, animated: false
        )
    }
}
