//
//  helpPpopup.swift
//  BThere
//
//  Created by Ioan Ungureanu on 09/11/17 dmy.
//  Copyright © 2017 Bthere-Tech. All rights reserved.
//

import Foundation
import UIKit

class helpPpopup: UIViewController, UIGestureRecognizerDelegate {
    
    // Variables
    @IBOutlet weak var splashimage: UIImageView!
 //   @IBOutlet weak var closebutton:UIButton!
    var indexOfImg:Int = 0
    var HELPSCREENKEYFORNSUSERDEFAULTS = ""
    @objc func closebutton() {
      self.dismiss(animated: false, completion: nil)
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        let USERDEF = UserDefaults.standard
        if  USERDEF.object(forKey: HELPSCREENKEYFORNSUSERDEFAULTS) != nil {
            let imagesarray:NSArray = USERDEF.object(forKey: HELPSCREENKEYFORNSUSERDEFAULTS) as! NSArray
            print("aaa \(imagesarray.description)")
            if let mydict:NSMutableDictionary = imagesarray[indexOfImg] as? NSMutableDictionary {
                if mydict["needimage"] != nil {
                let ImageStr:String = mydict["needimage"] as! String
                if let MYIMG:UIImage = UIImage(named: ImageStr)  {
                    self.splashimage.image = MYIMG
                }
                
            }
            }
        }
       
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGuide:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closebutton))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGuide)
       
    }
    
}
