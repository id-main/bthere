//
//  GetToKnowTheSystemXib.swift
//  Bthere
//
//  Created by Iustin Bthere on 11/13/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Foundation

class GetToKnowTheSystemXib: NavigationModelViewController,AVPlayerViewControllerDelegate
{
    var playerController = AVPlayerViewController()
    @IBOutlet weak var TitleScreen:UILabel!
    @IBOutlet weak var LineText1:UILabel!
    @IBOutlet weak var ViewButtonProvider:UIView!
    @IBOutlet weak var ViewButtonCustomer:UIView!
    @IBOutlet weak var LineTextButtonProvider:UILabel!
    @IBOutlet weak var LineTextButtonCustomer:UILabel!
    @IBOutlet weak var CloseXButton:UIButton!
    @IBOutlet weak var lefmargintalign:NSLayoutConstraint!
    @IBOutlet weak var rightmargintalign:NSLayoutConstraint!
    @IBOutlet weak var ViewContainer:UIView!
    @IBAction func CloseXButton(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIDevice.current.userInterfaceIdiom == .pad {
            lefmargintalign.constant = 80
            rightmargintalign.constant = 80
        } else {
            lefmargintalign.constant = 30
            rightmargintalign.constant = 30
        }
    }
    override func viewWillLayoutSubviews() {
//                self.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tapProvider:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openVideoProviderScreen))
        ViewButtonProvider.addGestureRecognizer(tapProvider)
        let tapCustomer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openVideoCustomerScreen))
        ViewButtonCustomer.addGestureRecognizer(tapCustomer)
        ViewButtonCustomer.backgroundColor = Colors.sharedInstance.color4
        ViewButtonCustomer.backgroundColor = Colors.sharedInstance.color3
        TitleScreen.text = "GETTOKNOWTHESYSTEMSCREENTITLESCREEN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText1.text = "GETTOKNOWTHESYSTEMSCREENLINE1TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineTextButtonProvider.text = "GETTOKNOWTHESYSTEMSCREENTEXTBUTTONPROVIDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineTextButtonCustomer.text = "GETTOKNOWTHESYSTEMSCREENTEXTBUTTONCUSTOMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addBackground()
    }
    
//    func openVideoProviderScreen() {
//        let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
//        let abc:IntroVideoPlayerScreen = mainstoryb.instantiateViewController(withIdentifier: "IntroVideoPlayerScreen")as! IntroVideoPlayerScreen
//        abc.view.frame = CGRect(x: 0, y:64, width:self.view.frame.size.width, height: self.view.frame.size.height - 64)
//        abc.modalPresentationStyle = .custom
//        abc.whichvideo = 0
//        self.present(abc, animated: true, completion: nil)
//
//    }
    @objc func openVideoCustomerScreen()
        
    {
        playWhichVideo(videoPath: "explanationvideocustomer")
        
    }
    
    @objc func openVideoProviderScreen()
        
    {
        playWhichVideo(videoPath: "explanationVideoBusiness")
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
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void)
    {
        let currentviewController =  navigationController?.visibleViewController
        if currentviewController != playerViewController
        {
            currentviewController?.present(playerViewController,animated: true,completion:nil)
        }
        
        
    }

}
