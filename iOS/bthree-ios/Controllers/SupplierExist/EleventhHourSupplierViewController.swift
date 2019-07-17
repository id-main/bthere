
//  EleventhHourSupplierViewController.swift
//  bthree-ios
//
//  Created by User on 8.5.2016.
//  Copyright © 2016 Webit. All rights reserved.


import UIKit
//ספק קיים - דף הדקה ה90
class EleventhHourSupplierViewController: NavigationModelViewController
    ,UITableViewDelegate,UITableViewDataSource
{
    
    //MARK: - Outlet
    var delegate:openFromMenuDelegate! = nil
    var generic = Generic()
    
    @IBOutlet weak var viewAddReduce: UIView!
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    ///הוסף מבצע
    @IBAction func btnAddRedude(_ sender: UIButton) {
        
        let navigationController:UINavigationController = UINavigationController()
        //            let storyboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let viewCon:NewRedocueViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewRedocueViewController") as! NewRedocueViewController
        navigationController.viewControllers = [viewCon]
        self.dismiss(animated: false, completion: { () -> Void in
            self.delegate.openFromMenu(navigationController)
            
        })
        
        
        
    }
    @IBOutlet weak var tblCampaigns: UITableView!
    //MARK: - Properties
    
    //    var datesArray:Array <NSDate> = [NSDate(),NSDate(timeIntervalSinceReferenceDate: -12345.0),NSDate(timeIntervalSinceReferenceDate: +123000089.0),NSDate()]
    
    //MARK: - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTopBorder(tblCampaigns, color: UIColor.black)
        tblCampaigns.separatorStyle = .none
        
        var dicListReduces:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicListReduces["iProviderId"] = Global.sharedInstance.currentProvider.iIdBuisnessDetails as AnyObject
        
        self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
            self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.GetCouponsForProvider(dicListReduces, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                        {
                            self.showAlertDelegateX("לא קיימים מבצעים לספק זה")
                        }
                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            let coupon:CouponObj = CouponObj()
                            if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                Global.sharedInstance.couponsForProvider = coupon.arrayToCouponObj(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            }
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.sharedInstance.couponsForProvider.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EleventhHourSupplierTableViewCell")as! EleventhHourSupplierTableViewCell
        
        let separatorView: UIView = UIView(frame: CGRect(x: 0, y: cell.frame.height + 0.1095 * (cell.frame.height) , width: cell.frame.width + (cell.frame.width / 3), height: 1))
        separatorView.layer.borderColor = UIColor.black.cgColor
        separatorView.layer.borderWidth = 1
        cell.contentView.addSubview(separatorView)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.setDisplayData(Global.sharedInstance.couponsForProvider[indexPath.row].dDate, campaign: Global.sharedInstance.couponsForProvider[indexPath.row].nvCouponName)
        
        //cell.setDisplayData(imagesArray[indexPath.row], date: shortDate(datesArray[indexPath.row]), text: arrString[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.1125
    }
    
    func shortDate(_ date:Date) -> String {
        
        //       let calendar = NSCalendar.currentCalendar()
        //let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        //let components1 = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        
        //        let year =  components.year
        //        let month = components.month
        //        let day = components.day
        //
        //        let yearToday =  components1.year
        //        let monthToday = components1.month
        //        let dayToday = components1.day
        
        //        if year == yearToday && month == monthToday && day == dayToday
        //        {
        //            return "היום"
        //        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
    
    func addTopBorder(_ any:UIView,color:UIColor)
    {
        let borderTop = CALayer()
        
        borderTop.frame = CGRect(x: 0, y: 0, width: any.layer.frame.width + (any.layer.frame.width / 3), height: 1)
        
        borderTop.backgroundColor = color.cgColor;
        
        any.layer.addSublayer(borderTop)
    }
}
