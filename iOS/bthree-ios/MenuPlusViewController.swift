//
//  MenuPlusViewController.swift
//  bthree-ios
//
//  Created by User on 22.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class MenuPlusViewController: UIViewController {
    
    
    var delegate:openFromMenuDelegate!=nil
    
    @IBAction func btnClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var viewNewAppointment: UIView!
    
    @IBOutlet weak var imgNewAppointment: UIImageView!
    
    
    @IBOutlet weak var viewBusinessPage: UIView!
    
    @IBOutlet weak var imgBisnesPage: UIImageView!
    
    
    @IBOutlet weak var viewLittleLate: UIView!
    
    @IBOutlet weak var imgLittleLate: UIImageView!
    
    @IBOutlet weak var viewListWait: UIView!
    
    @IBOutlet weak var imgListWait: UIImageView!
    
    @IBOutlet weak var viewI: UIView!
    
    @IBOutlet weak var imgI: UIImageView!
    
    @IBOutlet weak var viewNotArrive: UIView!
    
    @IBOutlet weak var imgNotArrive: UIImageView!
    
    @IBOutlet weak var viewHelp: UIView!
    
    @IBOutlet weak var imgHelp: UIImageView!
    
    @IBOutlet weak var viewUpdateTurn: UIView!
    
    @IBOutlet weak var imgUpdateTurn: UIImageView!
    
    @IBOutlet weak var viewLastMinute: UIView!
    
    @IBOutlet weak var imgLastMinute: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "openviewBusinessPage")
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "openviewHelp")
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewI")
        let tap4: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "openViewLastMinute")
        let tap5: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "openViewListWait")
        let tap6: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewLittleLate")
        let tap7: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewNewAppointment")
        let tap8: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewNotArrive")
        let tap9: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewUpdateTurn")
        
        viewBusinessPage.addGestureRecognizer(tap1)
        viewHelp.addGestureRecognizer(tap2)
        viewI.addGestureRecognizer(tap3)
        viewLastMinute.addGestureRecognizer(tap4)
        viewListWait.addGestureRecognizer(tap5)
        viewLittleLate.addGestureRecognizer(tap6)
        viewNewAppointment.addGestureRecognizer(tap7)
        viewNotArrive.addGestureRecognizer(tap8)
        viewUpdateTurn.addGestureRecognizer(tap9)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func openviewBusinessPage()
    {
       
    }
    
    func openViewHelp()
    {}
    
    func openViewI()
    {}
    
    func openViewLastMinute()
    {
        let viewCon:EleventhHourViewController = storyboard?.instantiateViewControllerWithIdentifier("EleventhHourViewController") as! EleventhHourViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate.openFromMenu(viewCon)
        
    }
    
    func openViewListWait()
    {
        let viewCon:MyWaitingListViewController = storyboard?.instantiateViewControllerWithIdentifier("MyWaitingListViewController") as! MyWaitingListViewController
        viewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate.openFromMenu(viewCon) 
    }
    
    func openViewLittleLate()
    {}
    
    func openViewNewAppointment()
    {}
    
    func openViewNotArrive()
    {}
    
    func openViewUpdateTurn()
    {}
    
    
    
}