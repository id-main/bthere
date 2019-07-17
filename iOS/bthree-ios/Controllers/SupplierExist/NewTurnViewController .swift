//
//  NewTurnViewController.swift
//  bthree-ios
//
//  Created by User on 1.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//ספק קיים -להוסיף תור חדש   
class NewTurnViewController: NavigationModelViewController
,UITextViewDelegate{
    
    @IBOutlet weak var lblNameServicer: UILabel!

    @IBOutlet weak var lblServiceTypeSelected: UILabel!
    @IBOutlet weak var lblNameCustomer: UILabel!
    let language = Bundle.main.preferredLocalizations.first! as NSString
    //MARK: - connections
    
    
    @IBOutlet weak var lblTitleNewTurn: UILabel!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var lblCostumer: UILabel!
    
    @IBOutlet weak var viewCostumer: UIView!
    
    @IBAction func btnOpenCostumer(_ sender: AnyObject) {
        if tblCostumers.tag == 0
        {
            tblCostumers.tag = 1
            tblCostumers.isHidden = false
        }
        else
        {
            tblCostumers.tag = 0
            tblCostumers.isHidden = true
        }
        
    }
    
    @IBOutlet weak var tblCostumers: UITableView!
    
    
    @IBOutlet weak var lblServiceProvider: UILabel!
    
    @IBOutlet weak var viewServiceProvider: UIView!
    
    @IBAction func btnOpenServiceProvider(_ sender: AnyObject) {
        
        if tblServiceProvider.tag == 0
        {
            tblServiceProvider.tag = 1
            tblServiceProvider.isHidden = false
        }
        else
        {
            tblServiceProvider.tag = 0
            tblServiceProvider.isHidden = true
        }
    }
    
    @IBOutlet weak var tblServiceProvider: UITableView!
    
    
    
    @IBOutlet weak var lblServiceType: UILabel!
    
    @IBOutlet weak var viewServiceType: UIView!
    
    @IBAction func btnOpenServiceType(_ sender: AnyObject) {
        
        if tblServiceType.tag == 0
        {
            tblServiceType.tag = 1
            tblServiceType.isHidden = false
        }
        else
        {
            tblServiceType.tag = 0
            tblServiceType.isHidden = true
        }
    }
    
    @IBOutlet weak var tblServiceType: UITableView!
    
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var viewDate: UIView!
    
    @IBOutlet weak var btnOpenDate: UIButton!
    
    @IBAction func btnOpenDate(_ sender: AnyObject) {
    }
    
    
    
    @IBOutlet weak var lblHour: UILabel!
    
    @IBOutlet weak var viewHour: UIView!
    
    @IBAction func btnOpenHour(_ sender: AnyObject) {
    }
    
    @IBOutlet weak var lblRemark: UILabel!
    
    @IBOutlet weak var txtVRemark: UITextView!
    
    
    
    @IBOutlet weak var btnMakeAppointment: UIButton!
    
    @IBAction func btnMakeAppointment(_ sender: AnyObject) {
    }
    
    
    @IBOutlet weak var lblSendMessage: UILabel!
    
    @IBOutlet weak var btnSendMessage: UIButton!
    
    @IBAction func btnSendMessage(_ sender: AnyObject) {
        var image:UIImage = UIImage()
        if btnSendMessage.tag == 0
        {
            btnSendMessage.tag = 1
            image = UIImage(named: "15a.png")!
        }
        else
        {
            btnSendMessage.tag = 0
            image = UIImage(named: "16a.png")!
        }
        
        UIGraphicsBeginImageContext(btnSendMessage.frame.size)
        image.draw(in: btnSendMessage.bounds)
        let image1: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        btnSendMessage.backgroundColor = UIColor(patternImage: image1)
    }
    
    var arrProviders:Array<String> = ["David","Moshe","Levi","Daniel"]
    var arrSeviceProviders:Array<String> = ["Avi","Uri","Simcha","Meir"]
    var arrSeviceTypes:Array<String> = ["רפואה אלטרנטיבית","ספרות","פסיכולוגיה","יעוץ"]
    
    //MARK: - initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

         //if language != "he"
           if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") != 0
            && (DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P) {
            
            lblTitleNewTurn.font = UIFont(name: "OpenSansHebrew-Bold", size: 21)
            
            lblCostumer.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblServiceProvider.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblServiceType.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblDate.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblHour.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblRemark.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblSendMessage.font = UIFont(name: "OpenSansHebrew-Light", size: 13)
            btnMakeAppointment.titleLabel!.font =  UIFont(name: "OpenSansHebrew-Light", size: 13)
        }
         else  /* if language != "he"  */
            if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") != 0 && (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS) {
            
            lblTitleNewTurn.font = UIFont(name: "OpenSansHebrew-Bold", size: 18)
            
            lblCostumer.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblServiceProvider.font = UIFont(name: "OpenSansHebrew-Light", size: 12)
            lblServiceType.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblDate.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblHour.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblRemark.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            lblSendMessage.font = UIFont(name: "OpenSansHebrew-Light", size: 12)
            btnMakeAppointment.titleLabel!.font =  UIFont(name: "OpenSansHebrew-Light", size: 11)
         }

         else if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS{
            
            lblTitleNewTurn.font = UIFont(name: "OpenSansHebrew-Bold", size: 22)
            
            lblCostumer.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblServiceProvider.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblServiceType.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblDate.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblHour.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblRemark.font = UIFont(name: "OpenSansHebrew-Light", size: 16)
            lblSendMessage.font = UIFont(name: "OpenSansHebrew-Light", size: 14)
            btnMakeAppointment.titleLabel!.font =  UIFont(name: "OpenSansHebrew-Light", size: 17)
        }
        
        
        txtVRemark.delegate = self
        
        tblCostumers.separatorStyle = .none
        tblServiceProvider.separatorStyle = .none
        tblServiceType.separatorStyle = .none
        
        tblCostumers.isHidden = true
        tblServiceProvider.isHidden = true
        tblServiceType.isHidden = true
        
        //the table is closed
        tblCostumers.tag = 0
        tblServiceProvider.tag = 0
        tblServiceType.tag = 0
        
        btnSendMessage.tag = 0
        
        lblTitleNewTurn.text = "NEW_TURN_TITLE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblCostumer.text = "COSTUMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblServiceProvider.text = "SERVICE_PROVIDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblServiceType.text = "SERVICE_TYPE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblDate.text = "DATE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblHour.text = "HOUR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblRemark.text = "REMARK".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblSendMessage.text = "SEND_MESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnMakeAppointment.setTitle("MAKE_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        tblCostumers.separatorStyle = .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - dismiss key board
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            txtVRemark.resignFirstResponder()
        }
        super.touchesBegan(touches, with:event)
    }
    
    //    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    //        if text == "\n" {
    //            textView.resignFirstResponder()
    //            return false
    //        }
    //        return true
    //    }
    
    
    //MARK: - table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblCostumers{
            return arrProviders.count
        }
        else if tableView == tblServiceProvider
        {
            return arrSeviceProviders.count
        }
        else
        {
            return arrSeviceTypes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell =
        tableView.dequeueReusableCell(withIdentifier: "newTurnTableViewCell")as!newTurnTableViewCell
        
        if tableView == tblCostumers{
            cell.setDisplayData(arrProviders[indexPath.row])
        }
        else if tableView == tblServiceProvider
        {
            cell.setDisplayData(arrSeviceProviders[indexPath.row])
        }
        else
        {
            cell.setDisplayData(arrSeviceTypes[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if tableView == tblCostumers{
         lblNameCustomer.text = arrProviders[indexPath.row]
            tblCostumers.isHidden = true
            tblCostumers.tag = 0
        }
        if tableView == tblServiceProvider{
            lblNameServicer.text = arrSeviceProviders[indexPath.row]
            tblServiceProvider.isHidden = true
            tblServiceProvider.tag = 0
        }
        if tableView == tblServiceType{
            lblServiceTypeSelected.text = arrSeviceTypes[indexPath.row]
            tblServiceType.isHidden = true
            tblServiceType.tag = 0
        }
        
    }
    
    func tableView(_ tableView: UITableView!, heightForRowAtIndexPath indexPath: IndexPath!) -> CGFloat {
        return self.view.frame.size.height * 0.07
    }

    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
