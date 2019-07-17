//
//  PersonalDetailsViewController.swift
//  BThereMy
//
//  Created by User on 8.2.2016.
//  Copyright © 2016 Gili. All rights reserved.
//
import UIKit
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion
import Foundation

    protocol changeBackgroundDelegate{
    func changeBackground()
    }
@available(iOS 8.0, *)
class PersonalDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,changeBackgroundDelegate,GPPSignInDelegate {

    var googleSignIn: GPPSignIn!
    
    //MARK - Outlet
    
    @IBOutlet weak var btn_googlePlus: UIButton!
    
    //when click on GooglePlush button
    @IBAction func btnGooglePlus(sender: AnyObject)
    {
        //connect to GooglePlush-this method call to the "openUrl" method in the appDelegate
        googleSignIn!.authenticate()
    }
    @IBOutlet weak var tblDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAlert: UIView!
    
    @IBOutlet weak var tblDetails: UITableView!

    @IBOutlet weak var lblRead: UILabel!
    
    @IBOutlet weak var lblGetAdverties: UILabel!
    
    @IBOutlet weak var btnGetAdverties: UIButton!
    
    @IBOutlet weak var btnRead: UIButton!

    var signIn: GPPSignIn?
    let kClientId:NSString = "147757724922-vcuje28bsm320u76n198pob94sjrluae.apps.googleusercontent.com"
    
    var flagRead = false
    var flagGetAdvetises = false
    var arr:Array<String> = Array<String>()
    var enterAlert:EnterAlertViewController!
    let line:UILabel = UILabel()
    
    let imageEmpty:UIImage = UIImage(named: "circleEmpty.png")!
    
     let imageFill:UIImage = UIImage(named: "circleFill.png")!
    
    @IBAction func btnRead(sender: AnyObject) {
       if flagRead == true
       {
        flagRead = false
        let image:UIImage = UIImage(named: "circleEmpty.png")!
        btnRead.setBackgroundImage(image, forState: .Normal)
        }
       else
        {
            flagRead = true
            let image:UIImage = UIImage(named: "circleFill.png")!
            btnRead.setBackgroundImage(image, forState: .Normal)
        }
    }
    
    @IBAction func btnGetAdvertises(sender: AnyObject) {
        
        if flagGetAdvetises == true
        {
            flagGetAdvetises = false
            let image:UIImage = UIImage(named: "circleEmpty.png")!
            btnGetAdverties.setBackgroundImage(image, forState: .Normal)
        }
        else
        {
            flagGetAdvetises = true
            
            let image:UIImage = UIImage(named: "circleFill.png")!
            btnGetAdverties.setBackgroundImage(image, forState: .Normal)
        }
        
    }
    
    //MARK - Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init properties to connect to google+
        googleSignIn = GPPSignIn.sharedInstance()
        googleSignIn.shouldFetchGooglePlusUser = true
        googleSignIn.clientID = "147757724922-vcuje28bsm320u76n198pob94sjrluae.apps.googleusercontent.com"
        googleSignIn.shouldFetchGoogleUserEmail = true
        googleSignIn.shouldFetchGoogleUserID = true
        googleSignIn.scopes = [kGTLAuthScopePlusLogin]
        googleSignIn.delegate = self
        
        view.bringSubviewToFront(btn_googlePlus)

        line.text = "___________"
        for(var i = 0; i < (Int)(self.view.frame.width/8); i++) {
            line.text = line.text! + "_"
        }
        line.textColor = UIColor.blackColor()
        line.frame = CGRectMake(0, 112, self.view.frame.width + 60, 15)
        self.view.addSubview(line)

        
        self.view.bringSubviewToFront(viewAlert)
        viewAlert.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        viewAlert.hidden = true
        
        tblDetails.alwaysBounceVertical = false
        
      arr = ["שם פרטי","שם משפחה","מספר טלפון","אימייל","תאריך לידה"]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        enterAlert = storyboard.instantiateViewControllerWithIdentifier("enterAlert") as! EnterAlertViewController
        
        enterAlert.modalPresentationStyle = UIModalPresentationStyle.Custom
        let v:UIView = enterAlert.view;
        
        var f:CGRect = v.frame;
        f.origin.x = self.view.frame.size.width/2
        f.origin.y = self.view.frame.size.height/2
        
        v.frame = f;
        
        UIView.animateWithDuration(1.5 ,animations:{
            v.frame = self.view.frame;
            } , completion: {finished in
                self.presentViewController(self.enterAlert, animated: false, completion: nil)
        })
        enterAlert.delegate = self
        viewAlert.hidden = false
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("detailsCell") as! PersonalDetailsTableViewCell
        
        let lineView: UIView = UIView(frame: CGRectMake(0, tblDetails.frame.size.height / 10 , cell.contentView.frame.size.width + 60, 1))
        lineView.backgroundColor = UIColor.darkGrayColor()
        cell.contentView.addSubview(lineView)

    cell.setDisplayData(arr[indexPath.row])
        
     return cell
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return tblDetails.frame.size.height / 10
        //(tblDetailsHeight.constant / 5 )

    }
    
    //MARK - Alert
    
    func showAlert(alertBudy:String){
        let alert:UIAlertController = UIAlertController(title: "", message: alertBudy, preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok:UIAlertAction=UIAlertAction(title: "אישור", style: UIAlertActionStyle.Default, handler: nil)
        let cancel:UIAlertAction=UIAlertAction(title: "ביטול", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func changeBackground() {
        self.viewAlert.hidden = true
    }
    
    //MARK - GooglePlus
    
     // GooglePlush Delegate Methods
    //the method called from the func in appDelegate:"openURL" after clicked on "allow" button in the screen and it retrieve the details of the user from GooglePlush
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        
        if (GPPSignIn.sharedInstance().userID != nil)
        {
            //יצירת cell מסוג PersonalDetailsTableViewCell
            var cellPersonal:PersonalDetailsTableViewCell?
            let user = GPPSignIn.sharedInstance().googlePlusUser
            
            //init the first name(at indexPath 0)
            cellPersonal = tblDetails.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? PersonalDetailsTableViewCell
            cellPersonal!.txtfDetails.text = user.name.givenName
            
            //init the last name(at indexPath 1)
            cellPersonal = tblDetails.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as? PersonalDetailsTableViewCell
            cellPersonal!.txtfDetails.text = user.name.familyName
            
            if (user.emails != nil){
            //init the e-mail(at indexPath 3)
            cellPersonal = tblDetails.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as? PersonalDetailsTableViewCell
            cellPersonal?.txtfDetails.text = user.emails.first?.value
                
            } else {
                
                print("no email")
                
            }
            
        } else {
            
            print("User ID is nil")
            
        }
    }
    func didDisconnectWitherror(error:NSError?){
    
    }
}
