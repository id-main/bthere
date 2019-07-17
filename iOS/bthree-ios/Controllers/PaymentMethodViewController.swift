//
//  PaymentMethodViewController.swift
//  bthree-ios
//
//  Created by Tami wexelbom on 2/10/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

//אמצעי תשלום
class PaymentMethodViewController: NavigationModelViewController,UIGestureRecognizerDelegate,UITextFieldDelegate{

    
    @IBOutlet weak var reqTz: UILabel!
    @IBOutlet weak var reqThreeNums: UILabel!
    @IBOutlet weak var reqTokef: UILabel!
    @IBOutlet weak var reqNumCard: UILabel!
    @IBOutlet weak var numCart: UIView!
    @IBOutlet weak var vie3Nums: UIView!
    @IBOutlet weak var vieTokef: UIView!
    @IBOutlet weak var vieNumCart: UIView!
    @IBOutlet weak var cnlBtn: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var tzLbl: UILabel!
    @IBOutlet weak var tzTxt: UITextField!
    @IBOutlet weak var threeNumsLbl: UILabel!
    @IBOutlet weak var threeNumsTxt: UITextField!
    @IBOutlet weak var tokefLbl: UILabel!
    @IBOutlet weak var tokefTxt: UITextField!
    @IBOutlet weak var numCardLbl: UILabel!
    @IBOutlet weak var numCardTxt: UITextField!
    
    //onClick send, check validity
    @IBAction func btnSend(_ sender: AnyObject)
    {
        var x = 0
        if numCardTxt.text == ""
        {
            x = 1
            reqNumCard.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            reqNumCard.isHidden = false
        }
        if tokefTxt.text == ""
        {
            x = 1
            reqTokef.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            reqTokef.isHidden = false
        }
        else if checkValidityTokek(tokefTxt.text!) == false
        {
            x = 1
            reqTokef.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            reqTokef.isHidden = false
        }
        if threeNumsTxt.text == ""
        {
            x = 1
            reqThreeNums.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            reqThreeNums.isHidden = false
        }
        else if threeNumsTxt.text?.count > 3
        {
            x = 1
            reqThreeNums.text = "NOT_VALID".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            reqThreeNums.isHidden = false
        }
        if tzTxt.text == ""
        {
            x = 1
            reqTz.text = "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            reqTz.isHidden = false
        }
        
        if x == 0
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let frontviewcontroller:UINavigationController = UINavigationController()
            
            let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
            let vc = storyboardCExist.instantiateViewController(withIdentifier: "CustomerSettings") as! CustomerSettings
            
            frontviewcontroller.pushViewController(vc, animated: false)
            
            
            //initialize REAR View Controller- it is the LEFT hand menu.
            
            let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
            
            let mainRevealController = SWRevealViewController()
            
            mainRevealController.frontViewController = frontviewcontroller
            mainRevealController.rearViewController = rearViewController
            
            let window :UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = mainRevealController
        }
    }
    @IBOutlet var tblPaymentMethod: UITableView!
    
    @IBAction func btnCancel(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller:UINavigationController = UINavigationController()
        
        let storyboardCExist = UIStoryboard(name: "ClientExist", bundle: nil)
        let vc = storyboardCExist.instantiateViewController(withIdentifier: "CustomerSettings") as! CustomerSettings
        
        frontviewcontroller.pushViewController(vc, animated: false)
        
        
        //initialize REAR View Controller- it is the LEFT hand menu.
        
        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController

    }
    // MARK: - Initial
   
    //==============================Initial=========================
    

    override func viewDidAppear(_ animated: Bool) {
        
        Colors.sharedInstance.addTopAndBottomBorderWithColor(UIColor.lightGray, width: 1, any: vieNumCart)
        Colors.sharedInstance.addBottomBorderWithColor(UIColor.lightGray, width: 1, any: vieTokef)
        Colors.sharedInstance.addBottomBorderWithColor(UIColor.lightGray, width: 1, any: vie3Nums)
        Colors.sharedInstance.addBottomBorderWithColor(UIColor.lightGray, width: 1, any: numCart)
        Colors.sharedInstance.addTopBorderWithColor(UIColor.lightGray, width: 1, any: viewHeader
        )
        let topBorder: UIView = UIView()
        topBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.width*(8/9), height: 1)
    }

    override func viewWillLayoutSubviews() {
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.bringSubviewToFront(cnlBtn)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PaymentMethodViewController.dismissKeyboard))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        let topBorder: UIView = UIView()
        topBorder.backgroundColor = UIColor.lightGray
        topBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1)
        
        self.view.backgroundColor=UIColor.black.withAlphaComponent(0.87)
        reqNumCard.isHidden = true
        reqThreeNums.isHidden = true
        reqTokef.isHidden = true
        reqTz.isHidden  = true
        
        numCardTxt.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        tokefTxt.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        threeNumsTxt.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        tzTxt.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    //MARK: - gestureRecognizer for dismissKeyboard
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool{
        dismissKeyboard()
        return false
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - TextField
    //=========================TextField==============================
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
   @objc func textFieldDidEndEditing(_ textField: UITextField) {
        switch(textField){
        case numCardTxt:
            reqNumCard.isHidden = true
        case tokefTxt:
            reqTokef.isHidden = true
        case threeNumsTxt:
            reqThreeNums.isHidden = true
        default:
            reqTz.isHidden = true
        }
    }
    
    func checkValidityTokek(_ tokef:String)->Bool
    {
       // 08/16
        let badCharacters = CharacterSet.decimalDigits.inverted
        let tokefArr = tokef.components(separatedBy: "/")
        
        var date: String = tokefArr[0]
        var year: String = tokefArr[1]
        
        if tokefArr.count == 1// "אם אין "/
        {
            return false
        }

        else if date.count > 2 || year.characters.count > 2// אם בחודש יותר מ2 ספרות
        {
            return false
        }
        if  date.rangeOfCharacter(from: badCharacters) != nil || year.rangeOfCharacter(from: badCharacters) != nil//אם התאריך או השנה אינם תקינים - אינם מכילים ספרות
        {
            return false
        }
        else if Int(date) > 12//אם החודש גדול מ-12 - לא תקין
        {
            return false
        }
        
        else
        {
            //אם התאריך או השנה קטן מ10, הוספתי 0
            if date.count == 1
            {
                date = "0\(date)"
                
            }
            if year.count == 1
            {
                year = "0\(year)"
            }
            tokefTxt.text = "\(date)/\(year)"
            return true
            
        }
    }
}
