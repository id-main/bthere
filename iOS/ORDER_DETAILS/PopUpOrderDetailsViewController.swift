//
//  PopUpOrderDetailsViewController.swift
//  bthree-ios
//
//  Created by User on 15.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//פופאפ בקשתך נשלחה לאישור
class PopUpOrderDetailsViewController: UIViewController {

    //MARK: - varibals
    @IBOutlet weak var view1: UIView!
    
    
    @IBOutlet weak var lblThanks: UILabel!
    
    @IBOutlet weak var lblFirstName: UILabel!
    
    @IBOutlet weak var lblRequestSent: UILabel!
    
    @IBOutlet weak var lblApproval: UILabel!
    
    @IBOutlet weak var lblProviderName: UILabel!
    //MARK: - initials
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - PopUpOrderDetailsViewController
        
        lblThanks.text = "THANKS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblRequestSent.text = "YOUR_REQUEST_SENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblApproval.text = "TO_APPROVAL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblProviderName.text = "PROVIDER_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblFirstName.text = "F_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE)

        addTopBottomBorder(view1, color: Colors.sharedInstance.color3)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - design func
    //design func that get color and view and add Bottom border

    func addTopBottomBorder(_ any:UIView,color:UIColor)
    {
        let borderTop = CALayer()
        let borderBottom = CALayer()
        
        borderTop.frame = CGRect(x: 0, y: 0, width: any.layer.frame.width + (any.layer.frame.width / 3), height: 1)
        
        borderBottom.frame = CGRect(x: 0, y: any.layer.frame.height + (any.layer.frame.height / 3) , width: any.layer.frame.width + (any.layer.frame.width / 3) , height: 1)
        
        borderTop.backgroundColor = color.cgColor;
        borderBottom.backgroundColor = color.cgColor;
        
        any.layer.addSublayer(borderTop)
        any.layer.addSublayer(borderBottom)
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
