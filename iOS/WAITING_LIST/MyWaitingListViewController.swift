//
//  MyWaitingListViewController.swift
//  bthree-ios
//
//  Created by User on 29.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

protocol deleteFromWaitingListDelegate {
    func deleteFromWaitingList()
}

//לקוח - רשימת המתנה שלי
class MyWaitingListViewController: UIViewController,deleteFromWaitingListDelegate {

    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblWaitingList: UITableView!
    
    var generic:Generic = Generic()
    var isFromDelegate = false
    //MARK: - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isFromDelegate = false
        addTopBorder(tblWaitingList, color: UIColor.black)
        tblWaitingList.separatorStyle = .none
        
        var dic:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dic["iUserId"] = Global.sharedInstance.currentUser.iUserId as AnyObject
        
       self.generic.showNativeActivityIndicator(self)
        if Reachability.isConnectedToNetwork() == false
        {
             self.generic.hideNativeActivityIndicator(self)
//            Alert.sharedInstance.showAlert("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
        else
        {
            api.sharedInstance.getWaitingListForCustomer(dic, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                 self.generic.hideNativeActivityIndicator(self)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {

                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                {
                      //\\print(responseObject["Error"])
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                        self.showAlertDelegateX("NO_TURNS_INMYLISTWAITING".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else
                    {
                        self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                }
                else
                {
                    let waitingList:WaitingListObj = WaitingListObj()
                    if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String, AnyObject>> {
                    Global.sharedInstance.arrWaitingList = waitingList.dicToArrayWaitingList(RESPONSEOBJECT["Result"] as! Array<Dictionary<String, AnyObject>>)
                    }
                    self.tblWaitingList.reloadData()
                    
                }
                    }
                }
                
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                     self.generic.hideNativeActivityIndicator(self)
//                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            })
        }
        
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table View
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        
        return Global.sharedInstance.arrWaitingList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyWaitingList")as! MyWaitingListTableViewCell
        
        let separatorView: UIView = UIView(frame: CGRect(x: 0, y: cell.frame.height + cell.frame.height * 0.0325, width: cell.frame.width + (cell.frame.width / 3), height: 1))
        separatorView.layer.borderColor = UIColor.black.cgColor
        separatorView.layer.borderWidth = 1
        cell.contentView.addSubview(separatorView)
        cell.delegate = self
        if isFromDelegate == true
        {
        cell.colWaitingList.reloadData()
        }
        
        cell.setDisplayData(indexPath.section)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.1125
    }
    
    func addTopBorder(_ any:UIView,color:UIColor)
    {
        let borderTop = CALayer()
        
        borderTop.frame = CGRect(x: 0, y: 0, width: any.layer.frame.width + (any.layer.frame.width / 3), height: 1)
        
        borderTop.backgroundColor = color.cgColor;
        
        any.layer.addSublayer(borderTop)
    }
    
    func deleteFromWaitingList() {
        isFromDelegate = true
        tblWaitingList.reloadData()
    }

}
