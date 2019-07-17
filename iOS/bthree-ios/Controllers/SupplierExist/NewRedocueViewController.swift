//
//  NewRedocueViewController.swift
//  Bthere
//
//  Created by User on 2.6.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//דף מבצע חדש-ספק קיים
class NewRedocueViewController: NavigationModelViewController {

    //MARK - Properties
    
    var generic:Generic = Generic()
    
    
    //MARK: - Outlet
    
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var txvtComment: UITextView!
    @IBOutlet weak var lblKindService: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    //MARK: - Actions
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnAddReduce(_ sender: UIButton) {
        
       self.generic.showNativeActivityIndicator(self)
        
        let dicNewCoupon:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        //2do
        api.sharedInstance.addNewCoupon(dicNewCoupon, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(self)
            },failure: {
                (AFHTTPRequestOperation, Error) -> Void in
                 self.generic.hideNativeActivityIndicator(self)
//                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        })
        
         self.dismiss(animated: true, completion:nil)
    }
    
    //MARK: - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
