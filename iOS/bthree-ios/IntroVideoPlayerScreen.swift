//
//  IntroVideoPlayerScreen.swift
//  BThere
//
//  Created by Ioan Ungureanu on 29/10/18.
//  Copyright © 2018 Bthere. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class  IntroVideoPlayerScreen:UIViewController, AVPlayerViewControllerDelegate{
    //  @IBOutlet weak var TitleScreen:UILabel!
  
    var wasplayed:Int = 0
    var playerController = AVPlayerViewController()
    var whichvideo:Int = 0 // 0 = providr, 1 = customer
    @IBOutlet weak var btnSkip:UIButton!
    @IBOutlet weak var btnPlay:UIButton!
    @IBOutlet weak var ViewContainer:UIView!
    @IBAction func CloseXButton(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func Play(_ sender: UIButton)
    {
        if whichvideo == 0 {
            let path = Bundle.main.path(forResource: "explanationvideobusiness", ofType: "mp4")
            let url = NSURL(fileURLWithPath: path!)
            let player = AVPlayer(url:url as URL)
            playerController = AVPlayerViewController()
            NotificationCenter.default.addObserver(self, selector: #selector(IntroVideoPlayerScreen.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            playerController.player = player
            playerController.allowsPictureInPicturePlayback = true
            playerController.delegate = self
            playerController.player?.play()
            self.present(playerController,animated:true,completion:nil)
        } else {
            let path = Bundle.main.path(forResource: "explanationvideocustomer", ofType: "mp4")
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

    }

    func didfinishplaying(note : NSNotification)
    {
        playerController.dismiss(animated: true,completion: nil)
//        let alertview = UIAlertController(title:"finished",message:"video finished",preferredStyle: .alert)
//        alertview.addAction(UIAlertAction(title:"Ok",style: .default, handler: nil))
//        self.present(alertview,animated:true,completion: nil)
        self.skipScreen()
    }


    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        let currentviewController =  navigationController?.visibleViewController
        if currentviewController != playerViewController
        {
            currentviewController?.present(playerViewController,animated: true,completion:nil)
        }


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        btnSkip.setTitle("SKIP".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControlState())
        self.view.bringSubview(toFront: btnSkip)

        //    TitleScreen.text = "GETTOKNOWTHESYSTEMSCREENTITLESCREEN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.ViewContainer.addBackground()
        self.view.bringSubview(toFront: btnSkip)
        if self.wasplayed == 1 {
           // self.CloseXButton(self.btnSkip)
            skipScreen()
        }
        if self.wasplayed == 0 {
        self.Play(self.btnPlay)
        self.wasplayed = 1
        }


    }
    func skipScreen() {
        if whichvideo == 0 {
        self.ViewContainer.alpha = 1
        let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
        let abc:AfterVideoPlayerScreen = mainstoryb.instantiateViewController(withIdentifier: "AfterVideoPlayerScreen")as! AfterVideoPlayerScreen
        //    abc.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        abc.view.frame = CGRect(x: 0, y:64, width:self.view.frame.size.width, height: self.view.frame.size.height - 64)
        abc.modalPresentationStyle = .custom
        self.present(abc, animated: true, completion: nil) //GettoKnowtheSystemScreen
        } else {
            gotoEntranceCustomerx()
        }

    }
    func gotoEntranceCustomerx() {
        let storyBoard1 =  UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyBoard1.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyBoard1.instantiateViewController(withIdentifier: "entranceCustomerViewController") as! entranceCustomerViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        Global.sharedInstance.whichReveal = false
        let rearViewController = storyBoard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }

}
