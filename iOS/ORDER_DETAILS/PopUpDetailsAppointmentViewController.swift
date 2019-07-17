//
//  PopUpDetailsAppointmentViewController.swift
//  Bthere
//
//  Created by Racheli Kroiz on 1.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

//פופאפ מלחיצה על אישור בהזמנת תור-הצגת פרטי התור ומודיע על שליחת התור לשרת
class PopUpDetailsAppointmentViewController: UIViewController {
    var isfromSPECIALiCustomerUserId:Int = 0
    //MARK: - Outlet
    
    @IBOutlet weak var txtView: UITextView!
    
    //MARK: - Variables
    
    var delegate:openCustomerDelegate!=nil
    
    //MARK: - Initial
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //tap on the page dismiss it
        let touchOnView:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimissViewController))
        self.view.addGestureRecognizer(touchOnView)
        //אם לא לוחצים על הויו זה יורד לאחר מספר שניות
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            self.dimissViewController()
        })
        
        if Global.sharedInstance.giveServiceName == "" || Global.sharedInstance.giveServiceName == "NOT_CARE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            txtView.text = "\("THX".localized(LanguageMain.sharedInstance.USERLANGUAGE)) \(" ") \(Global.sharedInstance.currentUser.nvFirstName),\n\("ASK_SEND_TO_GIVE_SERVICE".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
        }
        else
        {
            
            txtView.text = "\("THX".localized(LanguageMain.sharedInstance.USERLANGUAGE)) \(" ") \(Global.sharedInstance.currentUser.nvFirstName),\n\("ASK_SEND".localized(LanguageMain.sharedInstance.USERLANGUAGE))\(Global.sharedInstance.giveServiceName) \("TO_OK".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //func to dismiss the popUp
    @objc func dimissViewController()  {
        self.dismiss(animated: false, completion: nil)
        if(self.isfromSPECIALiCustomerUserId != 0) {
            
            //now go to my customer
            delegate.openMycustomers()
            
        } else {
            delegate.openCustomer()
        }
    }
    
}
