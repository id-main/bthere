//
//  MultipleAppointmentsViewController.swift
//  BThere
//
//  Created by Ioan Ungureanu on 28/02/2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit
import MarqueeLabel
class MultipleAppointmentsViewController: UIViewController {
    // Outlets
    @IBOutlet var topBorderView: UIView!
    @IBOutlet var popConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblAppointments: UITableView!
    @IBOutlet weak var btnBACK:UIButton!
    @IBOutlet var newsDealsLabel: MarqueeLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getnews()
        self.newsDealsLabel.restartLabel()
        let leftarrowback = UIImage(named: "sageata2.png")
        self.btnBACK.setImage(leftarrowback, forState: .Normal)
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransformMakeScale(-1, 1)
        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
            self.btnBACK.transform = scalingTransform
        }
        btnBACK.imageView!.contentMode = .ScaleAspectFit
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            popConstraint.constant = 75 // 139
        } else {
            popConstraint.constant = 75
        }

            lblTitle.text = "LBLAPPOINTMENT_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        tblAppointments.reloadData()
        
        self.tblAppointments.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    @IBAction func btnBACK(sender: AnyObject) {
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if (Global.sharedInstance.ordersOfClientsArray.count > 0) {
            self.topBorderView.hidden = false
        } else {
            self.topBorderView.hidden = true
        }
        
        return Global.sharedInstance.ordersOfClientsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(" MultipleAppointmentTableViewCell") as!  MultipleAppointmentTableViewCell
        cell.setDisplayData(Global.sharedInstance.ordersOfClientsArray[indexPath.section], _whatindex:  indexPath.row)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func getnews(){
        let dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //    dic["iLanguageId"] = finalIntforlang
        
        if Reachability.isConnectedToNetwork() == false
        {
            Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetNewsAndUpdates(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) -> Void in
                print("getnewsfavorite \(responseObject)")
                if let _ = responseObject["Result"] as? NSNull {
                    Alert.sharedInstance.showAlertAppDelegate("NO_CONNECTION".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                }
                else{
                    if let abcd = responseObject["Result"] as? String {
                        self.newsDealsLabel.tag = 101
                        self.newsDealsLabel.type = .Continuous
                        self.newsDealsLabel.animationCurve = .Linear
                        self.newsDealsLabel.type = .LeftRight
                        self.newsDealsLabel.text  = abcd
                        self.newsDealsLabel.restartLabel()
                    }
                }
                
                
                },failure: {(AFHTTPRequestOperation, NSError) -> Void in
                    if AppDelegate.showAlertInAppDelegate == false
                    {
                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        AppDelegate.showAlertInAppDelegate = true
                    }
            })
        }
    }
       func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "dd/MM/yyyy"
//            let theEventDate = (tableView.cellForRowAtIndexPath(indexPath) as! MyAppointmentTableViewCell).lblDate.text!
//            let viewCon:detailsAppointmetClientViewController = storyboard?.instantiateViewControllerWithIdentifier("detailsAppointmetClientViewController") as! detailsAppointmetClientViewController
//            viewCon.cancelOrderID = Global.sharedInstance.ordersOfClientsArray[indexPath.section].iCoordinatedServiceId
//            viewCon.fromHour = (tableView.cellForRowAtIndexPath(indexPath) as! MyAppointmentTableViewCell).lblHour.text!
//            viewCon.supplierName = Global.sharedInstance.ordersOfClientsArray[indexPath.section].nvSupplierName
//            viewCon.serviceName = (tableView.cellForRowAtIndexPath(indexPath) as! MyAppointmentTableViewCell).lblText.text!
//            viewCon.dateEvent = dateFormatter.dateFromString(theEventDate)!
//            viewCon.appointmentTime = "\((tableView.cellForRowAtIndexPath(indexPath) as! MyAppointmentTableViewCell).lblHour.text!) - \((tableView.cellForRowAtIndexPath(indexPath) as! MyAppointmentTableViewCell).hourE)"
//            viewCon.appointmentLocation = Global.sharedInstance.ordersOfClientsArray[indexPath.section].nvAddress
//            viewCon.isFromMyAppointments = true
//            viewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
//            self.presentViewController(viewCon, animated: true, completion: nil)
    }
}
