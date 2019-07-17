//
//  ServiceInformationViewController.swift
//  bthree-ios
//
//  Created by User on 27.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//מידע על  שירות מגיע מתוצאות חיפוש
class ServiceInformationViewController: UIViewController {
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var lblSum: UILabel!
    
    @IBOutlet weak var txtViewoInformation: UITextView!
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var viewBlack: UIView!
    
    @IBOutlet weak var imgImage: UIImageView!
    
    //עפולה 2 ק״מ ממיקומך
    @IBOutlet weak var imgWaze: UIImageView!
    
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblNumKM: UILabel!
    
    @IBOutlet weak var lblKMFromYou: UILabel!
    
    // דירוג: 8.9 | 32 מדרגים
    
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var lblNumRuting: UILabel!
    
    @IBOutlet weak var lblNumVoters: UILabel!
    
    @IBOutlet weak var lblVoters: UILabel!
    
    var name:String = ""
    var desc:String = ""
    var address:String = ""
    var km:String = ""
    var serviceName:String = ""
    var numRuting:String = ""
    var numVoters:String = ""
    var imageLogo:UIImage = UIImage()
    var img:UIImage = UIImage()
    
    var sumOfService:String = ""
    var untilSum:Float = 0.0
    var durationOfService:String = ""
    var untilDuration:Int = 0
    
    // MARK: - Initial
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(btnClose)
        
        txtViewoInformation.text = "VIEW_INFORMATION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        lblName.text = name
        lblDesc.text = desc
        lblCity.text = address
        lblNumVoters.text = numVoters
        lblNumRuting.text = numRuting
        imgLogo.image = imageLogo
        imgImage.image = img
        
        lblTitle.text = serviceName
        if sumOfService == "0.0"
        {
            lblSum.text = ""
        }
        else
        {
            lblSum.text = "₪ \(sumOfService)"
        }
        /*if (Int(durationOfService)! / 60) > 0
         {
         let hours = Int(durationOfService)! / 60
         let minutes  = Int(durationOfService)! % 60
         lblDuration.text = "\(hours).\(minutes) \("HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
         }
         else
         {*/
        lblDuration.text = "\(Int(durationOfService)!) \("MINUTES".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
        //}
        
        if km != ""
        {
            lblNumKM.text = " \(km)"
            //lblKMFromYou.text = "KILOMETER_FROM_YOU".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        else
        {
            lblNumKM.text = ""
            lblKMFromYou.text = ""
        }
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            lblDesc.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
            lblName.font = UIFont(name: "OpenSansHebrew-Bold", size: 15)
            lblTitle.font = UIFont(name: "OpenSansHebrew-Bold", size: 21)
            lblSum.font = UIFont(name: "OpenSansHebrew-Light", size: 19)
            lblDuration.font = UIFont(name: "OpenSansHebrew-Light", size: 18)
            txtViewoInformation.font = UIFont(name: "OpenSansHebrew-Light", size: 18)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        let bounds = UIScreen.main.bounds
        
        let width = bounds.size.width
        let height = bounds.size.height
        //let y = bounds.origin.y
        self.view.superview!.bounds = CGRect(x:0,y:-64,width:width,height: height)
        
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
