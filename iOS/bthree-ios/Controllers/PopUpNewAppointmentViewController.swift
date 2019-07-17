//
//  PopUpNewAppointmentViewController.swift
//  Bthere
//
//  Created by User on 31.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//(לא בשימוש)
class PopUpNewAppointmentViewController: UIViewController {

    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnWaitingList(_ sender: AnyObject) {
    }
    
    @IBAction func btnNearbyVacantQueues(_ sender: AnyObject) {
    }
    
    @IBAction func btnChangeDay(_ sender: AnyObject) {
    }
    
    @IBAction func btnSearchSupplier(_ sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
