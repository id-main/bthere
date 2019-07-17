//
//  TutorialScreenSlider.swift
//  BThere
//
//  Created by Ioan Ungureanu on 06/09/2018 dmy.
//  Copyright © 2018 Bthere-Tech. All rights reserved.
//

import Foundation
import UIKit
//import AACarousel
 class TutorialScreenSlider: UIViewController, AACarouselDelegate {
    @IBOutlet weak var CarrouselTutorial: AACarousel!
    @IBOutlet weak var btnCLOSETUTURIAL: UIButton!

    @IBAction func btnCLOSETUTURIAL(_ sender: AnyObject) {
      self.closeScreen()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rtlRELOAD()
        var titleArray = [String]()
          if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
             var firstimg = ""
                if UIDevice.current.userInterfaceIdiom == .pad {
             firstimg = "ENG1iPADNEW.jpg"
                } else {
                firstimg = "ENG1IPHONENEW.jpg"
            }
            let secondimg = "HE1"
            let thirdimg = "HE2.jpg"
            let fourthimg = "HE3"
            let fifthimg = "HE4"
            let sixthimg = "HE5"
            let pathArray = [firstimg, secondimg,thirdimg,fourthimg,fifthimg,sixthimg]
            titleArray = ["","","","","",""]
            CarrouselTutorial.delegate = self
            
            
            CarrouselTutorial.setCarouselData(paths: pathArray,  describedTitle: titleArray, isAutoScroll: true, timer: 7.0, defaultImage: firstimg)
            //optional methods
            CarrouselTutorial.setCarouselOpaque(layer: true, describedTitle: true, pageIndicator: false)
            CarrouselTutorial.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: .cyan, describedTitleColor: nil, layerColor: nil, language: 0)
           
            self.view.bringSubviewToFront(btnCLOSETUTURIAL)
        } else {
            var firstimg = ""
            if UIDevice.current.userInterfaceIdiom == .pad {
                firstimg = "ENG1iPADNEW.jpg"
            } else {
                firstimg = "ENG1IPHONENEW.jpg"
            }
           
            let secondimg = "ENG1"
            let thirdimg = "ENG2.jpg"
            let fourthimg = "ENG3"
            let fifthimg = "ENG4"
            let sixthimg = "ENG5"
            let pathArray = [firstimg, secondimg,thirdimg,fourthimg,fifthimg,sixthimg]
            titleArray = ["","","","","",""]
            CarrouselTutorial.delegate = self
            
            CarrouselTutorial.setCarouselData(paths: pathArray,  describedTitle: titleArray, isAutoScroll: true, timer: 7.0, defaultImage: firstimg)
            //optional methods
            CarrouselTutorial.setCarouselOpaque(layer: true, describedTitle: true, pageIndicator: false)
            CarrouselTutorial.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: .cyan, describedTitleColor: nil, layerColor: nil,language: 1)
            self.view.bringSubviewToFront(btnCLOSETUTURIAL)
        }
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let USERDEF = UserDefaults.standard
        USERDEF.setValue(1, forKey: "hassowntutorial")
        USERDEF.synchronize()
    }
    override func viewDidLayoutSubviews() {
        btnCLOSETUTURIAL.setTitle("SKIP".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    func startAutoScroll() {
        //optional method
        CarrouselTutorial.startScrollImageView()
        
    }
    
    func stopAutoScroll() {
        //optional method
        CarrouselTutorial.stopScrollImageView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func didSelectCarouselView(_ view:AACarousel, _ index:Int) {
        
    }
    func callBackFirstDisplayView(_ imageView:UIImageView, _ url:[String], _ index:Int) {
        var firstimg = ""
        if UIDevice.current.userInterfaceIdiom == .pad {
            firstimg = "ENG1iPADNEW.jpg"
        } else {
            firstimg = "ENG1IPHONENEW.jpg"
        }
        imageView.image = UIImage.init(named:firstimg)
        
    }
    func downloadImages(_ url:String, _ index:Int) {
        
    }
    func closeScreen() {
        CarrouselTutorial.stopScrollImageView()
        let storyBoard2 = UIStoryboard(name: "Main", bundle: nil)
        let frontviewcontroller = storyBoard2.instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        let vc = storyBoard2.instantiateViewController(withIdentifier: "entranceViewController") as! entranceViewController
        frontviewcontroller?.pushViewController(vc, animated: false)
        Global.sharedInstance.whichReveal = false
        let rearViewController = storyBoard2.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
    }
}
