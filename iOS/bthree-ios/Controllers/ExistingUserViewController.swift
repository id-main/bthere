//
//  ExistingUserViewController.swift
//  bthree-ios
//
//  Created by User on 3.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//דף לקוח קיים(לבדוק אם משתמשים)
class ExistingUserViewController: UIViewController {
    
    @IBOutlet weak var existUser: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var passwosd: UILabel!
    

    @IBOutlet weak var txtFName: UITextField!
    
    @IBOutlet weak var txtFPassword: UITextField!
    
    @IBOutlet weak var btnConnect: UIButton!
    
    @IBAction func btnConnect(_ sender: AnyObject) {
        
        let viewCon:CustomerOrDistributorViewController = storyboard?.instantiateViewController(withIdentifier: "CustomerOrDistributorViewController") as! CustomerOrDistributorViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewCon, animated: true, completion: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        txtFName.borderStyle = .None
        txtFPassword.borderStyle = .none
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ExistingUserViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        
        name.text = "NAME_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        passwosd.text = "PASSWORD_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        existUser.text = "EXISTS_USER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnConnect.setTitle("BTN_CONNECT".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - keyboard
    
    ///dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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
