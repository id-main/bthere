//
//  Alert.swift
//  Bthere
//
//  Created by User on 24.11.2015.
//  Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
//  Copyright © 2018 Bthere. All rights reserved.

import UIKit

@available(iOS 8.0, *)
var selfController:UIViewController = UIViewController()


class Alert: NSObject,UIAlertViewDelegate {
    static let sharedInstance = Alert()
    let generic:Generic = Generic()
    ////simple alert to show
    ///get 2 variables: "mess" = content of the alert,"vc" = viewController to show the alert
    func showAlert(_ mess:String,vc:UIViewController)
    {
        let alertController = UIAlertController(title: "", message:
            mess, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default,handler: nil))
        vc.present(alertController, animated: true, completion: nil)
    }
    func  showAlertDelegate(_ mess:String)
    {
        
//        let alertController = UIAlertController(title: "", message:
//            mess, preferredStyle: UIAlertControllerStyle.Alert)
//        alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertActionStyle.Default,handler: nil))
//        selfController.presentViewController(alertController, animated: true, completion: nil)
        
//
        let alertController = UIAlertController(title: "", message:mess, preferredStyle: .alert)
      //  alertController.addAction(UIAlertAction(title:  "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default, handler: nil))
         alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { (action:UIAlertAction!) in
            print("Selected")
//            alertController.dismissAll(animated: true)
//            alertController.view.isHidden = true
//            alertController.removeFromParent()
//            alertController.SELFremoveFromParent()
            })

        alertController.presentInOwnWindow(animated: true, completion: {
            print("completed")

        })
//        let text: UILabel = UILabel()
//        text.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
//
//        text.text = mess
//        text.textAlignment = NSTextAlignment.center
//        var frame:CGRect = CGRect()
//        frame.size = CGSize(width: 100, height: 100)
//        frame.origin = CGPoint(x: 30,y: 30)
//        text.frame = frame
//        text.backgroundColor = UIColor.red
//        let alert = UIAlertView()
//        alert.addButton(withTitle: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE))
//        alert.title = ""
//        alert.message = mess
//        alert.addSubview(text)
//        alert.show()
    }
    
    func showAlertAppDelegate(_ mess:String)
    {
        if Global.sharedInstance.viewConNoInternet != nil
        {
           generic.hideNativeActivityIndicator(Global.sharedInstance.viewConNoInternet!) 
        }
        
        let text: UILabel = UILabel()
        text.font = UIFont(name: "OpenSansHebrew-Light", size: 15)
        
        text.text = mess
        text.textAlignment = NSTextAlignment.center
        var frame:CGRect = CGRect()
        frame.size = CGSize(width: 100, height: 100)
        frame.origin = CGPoint(x: 30,y: 30)
        text.frame = frame
        text.backgroundColor = UIColor.red
        let alert = UIAlertView()
        //alert.setValue(text, forKey: "accessoryView")
        alert.delegate = self
        alert.addButton(withTitle: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        alert.title = ""
        alert.message = mess
        alert.addSubview(text)
        alert.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        if buttonIndex == 0
        {
         exit(0)
        }
        }

    
///פונקציה זו מופעלת מדף הכניסה בלחיצה על כפתור הרשמה דרך גוגל או פייסבוק
    /// ומציגה אלרט עם 2 כפתורים של אישור וביטול
    ///בלחיצה על אישור:מקבל את הנתונים מגוגל או מפייסבוק
    //בביטול-מוריד את האלרט
   ///מקבלת:קונטרולר עליו להציג את האלרט,דגל לדעת על האם לחצו על גוגל=1 או פייסבוק=2
   
    
}
