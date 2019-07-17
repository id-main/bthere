//
//  YourMindAboutBussinesViewController.swift
//  Bthere
//
//  Created by User on 13.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class YourMindAboutBussinesViewController: UIViewController {

    @IBOutlet weak var txtInputText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
txtInputText.layer.borderColor =  Colors.sharedInstance.color2.cgColor//צריך צבע כתום לא יודעת איזה מספר זה
    txtInputText.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnContinus(_ sender: UIButton) {
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
