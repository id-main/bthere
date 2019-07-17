//
//  DegreeBussinesViewController.swift
//  Bthere
//
//  Created by User on 13.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class DegreeBussinesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnContinue(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnChangeImage(_ sender: UIButton) {//בגלל שאין עדין את החתוכים סתם שמתי תמונות בשביל לראות את הרעיון צריך להחליף את התמונות למה שמתאים
    
        if sender.tag == 0{//האם זה לא בחור ז״א שצריך לההפך לבחור
         sender.setImage(UIImage(named: "15a.png"), for:UIControl.State())
            sender.tag = 1
        }
        else{
            sender.setImage(UIImage(named: "16a.png"), for:UIControl.State())
            sender.tag = 0//נהפך לא בחור
        }
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
