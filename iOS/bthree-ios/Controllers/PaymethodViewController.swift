//
//  PaymethodViewController.swift
//  bthree-ios
//
//  Created by User on 14.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
protocol presentPaymentByCardDelegate{
    func presentPaymentByCard()
}
//  דף 6 בהרשמה  תשלום באמצעות
class PaymethodViewController: UIViewController {
    var delegate:presentPaymentByCardDelegate!=nil
    @IBOutlet weak var lblPaymentBy: UILabel!
    
    @IBOutlet weak var txtVExplain: UITextView!

   
    
    @IBAction func btnPhonPay(_ sender: UIButton) {
    }
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBAction func btnCreditCard(_ sender: AnyObject) {
        delegate.presentPaymentByCard()
    }
    
    @IBOutlet weak var btnCreditCard: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPaymentBy.text = "PAYMENT_BY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        txtVExplain.text = "PAYMENT_METHOD_EXPLAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtVExplain.isSelectable = false
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            lblPaymentBy.font = UIFont(name: "OpenSansHebrew-Bold", size: 15)
        }
    }


    override func viewDidAppear(_ animated: Bool) {
    //    Colors.sharedInstance.addTopAndBottomBorderWithColor(Colors.sharedInstance.color5, width: 1, any: titleView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
