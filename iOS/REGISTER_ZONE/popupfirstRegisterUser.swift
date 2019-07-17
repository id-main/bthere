//
//  popupfirstRegisterUser
//  BThere
//
//  Created by Ioan Ungureanu on 08/05/19 dmy.
//  Copyright © 2018 Bthere-Tech. All rights reserved.
//

import Foundation
import UIKit

class popupfirstRegisterUser: UIViewController {
    
    @IBOutlet weak var popUPPASSWORD:UIView!
    @IBOutlet weak var imageGirl:UIImageView!
    @IBOutlet weak var btnhebrewclose:UIButton!
    @IBOutlet weak var btnclose:UIButton!
    @IBAction func btnCloseX(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            imageGirl.image =    UIImage(named: "newintroscreenpophebrew.jpg")

        } else{
            imageGirl.image =    UIImage(named: "newintroscreenpop.jpg")

        }
        btnclose.setTitle("SKIP".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        self.view.bringSubviewToFront(btnclose)
        //keep in mind we don't have image for russian
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

