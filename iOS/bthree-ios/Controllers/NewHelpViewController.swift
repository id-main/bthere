//
//  NewHelpViewController.swift
//  BThere
//
//  Created by Eduard Stefanescu on 11/28/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Foundation

class NewHelpViewController: NavigationModelViewController, UITableViewDelegate, UITableViewDataSource,AVPlayerViewControllerDelegate {
    // Outlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var popConstraint: NSLayoutConstraint!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var callButton: UIButton!
    @IBOutlet var qaLabel: UILabel!
    @IBOutlet var guidanceVideoButton: UIButton!
    @IBOutlet var QATable: UITableView!
    // @IBOutlet var cellBorderView: UIView!
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    
    // Constants
    let questionsStrings: Array<String> = ["HELP_Q1".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q2".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q3".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q4".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q5".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q6".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q7".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q8".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q9".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_Q10".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    let answersStrings: Array<String> = ["HELP_A1".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_A2".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_A3".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_A4".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_A5".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_A6".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_A7".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_A8".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_A9".localized(LanguageMain.sharedInstance.USERLANGUAGE), "HELP_A10".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var questionExpanded: Array<Bool> = [false,false,false,false,false,false,false,false,false,false]
    
    var playerController = AVPlayerViewController()


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:18)
        
        print(" Global.sharedInstance.isProvider \(Global.sharedInstance.isProvider)")
    }

    
    @IBAction func openChat(_ sender: Any)
    {
        openlivechat()
    }
    
    
    @objc func openlivechat(){
        let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let helpLiveChatViewController:HelpLiveChatViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "HelpLiveChatViewController") as! HelpLiveChatViewController
        helpLiveChatViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        
        if self.iOS8 {
            helpLiveChatViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            helpLiveChatViewController.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        
        self.present(helpLiveChatViewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
         if Global.sharedInstance.isProvider
         {
           if UIDevice.current.userInterfaceIdiom == .pad
           {
            popConstraint.constant = 24
            }
            else
           {
            popConstraint.constant = 24
            }
         }
        else
         {
            if UIDevice.current.userInterfaceIdiom == .pad
            {
                popConstraint.constant = 64
            }
            else
            {
                popConstraint.constant = 64
            }
         }
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            popConstraint.constant = 25
//        } else {
//            popConstraint.constant = 10
//        }
        //64
        
        // Language
        titleLabel.text = "HELP_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        messageLabel.text = "HELP_MESSAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        qaLabel.text = "HELP_QA".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        guidanceVideoButton.setTitle("HELP_GUIDANCE_VIDEO".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        self.QATable.delegate = self
        self.QATable.dataSource = self
        self.QATable.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.QATable.rowHeight = UITableView.automaticDimension
        self.QATable.estimatedRowHeight = 140
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Close
    @IBAction func closeButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func playVideoAction(_ sender: UIButton)
//    {
//        Global.sharedInstance.isProvider ? playWhichVideo(videoPath: "explanationvideobusiness") : playWhichVideo(videoPath: "explanationvideocustomer")
//    }
    
    @IBAction func instantiatePopUp(_ sender: UIButton)
    {
        let myViewController = GetToKnowTheSystemXib(nibName: "GetToKnowTheSystemXib", bundle: nil)
        myViewController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        self.present(myViewController, animated: true, completion: nil)

        
        
        
//        Global.sharedInstance.isProvider = false
//        Global.sharedInstance.whichReveal = true
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let frontViewController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
//
//        let myViewController = GetToKnowTheSystemXib(nibName: "GetToKnowTheSystemXib", bundle: nil)
//        myViewController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
//        myViewController.modalPresentationStyle = UIModalPresentationStyle.custom
//        frontViewController.pushViewController(myViewController, animated: false)
//
//        let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
//
//        let mainRevealController = SWRevealViewController()
//
//        mainRevealController.frontViewController = frontViewController
//        mainRevealController.rearViewController = rearViewController
//
//        self.view.window!.rootViewController = mainRevealController
//        self.view.window?.makeKeyAndVisible()
        
//        let myViewController = GetToKnowTheSystemXib(nibName: "GetToKnowTheSystemXib", bundle: nil)
//        myViewController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        

        
        
        
        
    }
    
    func playWhichVideo(videoPath:String)
    {
        let path = Bundle.main.path(forResource: videoPath, ofType: "mp4")
        let url = NSURL(fileURLWithPath: path!)
        let player = AVPlayer(url:url as URL)
        playerController = AVPlayerViewController()
        NotificationCenter.default.addObserver(self, selector: #selector(IntroVideoPlayerScreen.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        playerController.player = player
        playerController.allowsPictureInPicturePlayback = true
        playerController.delegate = self
        playerController.player?.play()
        self.present(playerController,animated:true,completion:nil)
    }
    
    @objc func didfinishplaying(note : NSNotification)
    {
        playerController.dismiss(animated: true,completion: nil)
        //        let alertview = UIAlertController(title:"finished",message:"video finished",preferredStyle: .alert)
        //        alertview.addAction(UIAlertAction(title:"Ok",style: .default, handler: nil))
        //        self.present(alertview,animated:true,completion: nil)
//        self.skipScreen()
        print("done with video baby")
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        let currentviewController =  navigationController?.visibleViewController
        if currentviewController != playerViewController
        {
            currentviewController?.present(playerViewController,animated: true,completion:nil)
        }
        
        
    }
    
    
    // Email
    @IBAction func emailButton(_ sender: AnyObject) {
        let toEmail = "btherecompany@bthere-tech.com"
        let urlString = ("mailto:\(toEmail)")
        let mailURL = URL(string:urlString)
        UIApplication.shared.openURL(mailURL!)
    }
    
    
    // Call
    @IBAction func callButton(_ sender: AnyObject) {
        if let url = URL(string: "tel://0795740780"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        } else {
            Alert.sharedInstance.showAlert("HELP_COULD_NOT_CALL".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
        }
    }
    
    
    // Guidance video
    @IBAction func guidanceVideoButton(_ sender: AnyObject) {
        let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let helpLiveChatViewController:HelpLiveChatViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "HelpLiveChatViewController") as! HelpLiveChatViewController
        helpLiveChatViewController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        
        if self.iOS8 {
            helpLiveChatViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            helpLiveChatViewController.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        
        self.present(helpLiveChatViewController, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionuse:Int = section
        
        if  questionExpanded[sectionuse] == true  {
            return 2
        }
        return 1
    }
    
    
    @objc func refreshtable() {
        self.QATable.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.questionsStrings.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewHelpQATableViewCell", for: indexPath) as! NewHelpQATableViewCell
        let sectionuse:Int = indexPath.section
        let rowinuse:Int = indexPath.row
        cell.borderView.isHidden = false
        
        if  questionExpanded[sectionuse] == true  {
            if rowinuse == 0 {
                cell.borderView.isHidden = true
            }
        }
        
        if rowinuse == 0 {
            cell.setDisplayData(questionsStrings[sectionuse], answer: "")
        } else {
            cell.setDisplayData(answersStrings[sectionuse], answer: "")
        }
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        if (self.questionsStrings.count > 0) {
            if (rowinuse == 1 || rowinuse == 0) && sectionuse == self.questionsStrings.count - 1 {
                cell.borderView.isHidden = true
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //questionExpanded
        let sectionuse:Int = indexPath.section
        let rowinuse:Int = indexPath.row
        
        if rowinuse == 0 {
            if questionExpanded[sectionuse] == true {
                questionExpanded = [false,false,false,false,false,false,false,false,false,false]
                
            } else {
                questionExpanded = [false,false,false,false,false,false,false,false,false,false]
                questionExpanded[sectionuse] = true
            }
        }
        
        refreshtable()
    }
}
