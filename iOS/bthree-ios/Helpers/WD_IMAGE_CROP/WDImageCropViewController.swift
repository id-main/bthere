//
//  WDImageCropViewController.swift
//  WDImagePicker
//
//  Created by Wu Di on 27/8/15.
//  Copyright (c) 2015 Wu Di. All rights reserved.
//

import UIKit
import CoreGraphics

internal protocol WDImageCropControllerDelegate {
    func imageCropController(_ imageCropController: WDImageCropViewController, didFinishWithCroppedImage croppedImage: UIImage)
}

internal class WDImageCropViewController: UIViewController {
    var sourceImage: UIImage!
    var delegate: WDImageCropControllerDelegate?
    var cropSize: CGSize!
    var resizableCropArea = false
    var lockAspectRatio = false
    
    fileprivate var croppedImage: UIImage!
    
    fileprivate var imageCropView: WDImageCropView!
    fileprivate var toolbar: UIToolbar!
    fileprivate var useButton: UIButton!
    fileprivate var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let bounds = UIScreen.mainScreen().bounds
        //
        //        let width = bounds.size.width
        //        let height = bounds.size.height
        //        self.view.bounds = bounds
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.title = "CHOOSE_IMAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        self.setupNavigationBar()
        self.setupCropView()
        self.setupToolbar()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationController?.isNavigationBarHidden = true
        } else {
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    //JMOD 09.11.2018
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.title = "CHOOSE_IMAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    }
    //end JMOD
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.imageCropView.frame = self.view.bounds
        self.toolbar?.frame = CGRect(x: 0, y: self.view.frame.height - 54,
                                         width: self.view.frame.size.width, height: 54)
    }

    
    @objc func actionCancel(_ sender: AnyObject) {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        let myimg = UIImage()
        self.delegate?.imageCropController(self, didFinishWithCroppedImage: myimg)


        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
       //self.navigationController?.popViewController(animated: true)
    }
    
    @objc func actionUse(_ sender: AnyObject) {
        croppedImage = self.imageCropView.croppedImage()
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        self.delegate?.imageCropController(self, didFinishWithCroppedImage: croppedImage)
        print("croppedImage \(croppedImage.size)")
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    fileprivate func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,target: self, action: #selector(actionCancel))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "USE_IMAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .plain,
                                                                target: self, action: #selector(actionUse))
        
    }
    
    fileprivate func setupCropView() {
        
        self.imageCropView = WDImageCropView(frame: self.view.bounds)
        self.imageCropView.imageToCrop = sourceImage
        self.imageCropView.resizableCropArea = self.resizableCropArea
        //jmode + GIT
        self.imageCropView.lockAspectRatio = self.lockAspectRatio
        self.imageCropView.cropSize = cropSize
        
        
        self.view.addSubview(self.imageCropView)
        
    }
    
    fileprivate func setupCancelButton() {
        self.cancelButton = UIButton()
        
        self.cancelButton.titleLabel?.font =  UIFont(name: "OpenSansHebrew-Bold", size: 16)//UIFont.boldSystemFontOfSize(16)
        self.cancelButton.titleLabel?.shadowOffset = CGSize(width: 0, height: -1)
        self.cancelButton.frame = CGRect(x: 0, y: 0, width: 58, height: 30)
        self.cancelButton.setTitle("CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        self.cancelButton.setTitleShadowColor(
            UIColor(red: 0.118, green: 0.247, blue: 0.455, alpha: 1), for: UIControl.State())
        self.cancelButton.addTarget(self, action: #selector(actionCancel), for: .touchUpInside)
        
        self.cancelButton.setTitle("CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())

        
    }
    
    fileprivate func setupUseButton() {
        self.useButton = UIButton()
        self.useButton.titleLabel?.font = UIFont(name: "OpenSansHebrew-Bold", size: 16)//UIFont.boldSystemFontOfSize(16)
        self.useButton.titleLabel?.shadowOffset = CGSize(width: 0, height: -1)
        self.useButton.frame = CGRect(x: 0, y: 0, width: 58, height: 30)
        self.useButton.setTitle("USE_IMAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        self.useButton.setTitleShadowColor(
            UIColor(red: 0.118, green: 0.247, blue: 0.455, alpha: 1), for: UIControl.State())
        self.useButton.addTarget(self, action: #selector(actionUse), for: .touchUpInside)
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        self.useButton.setTitle("USE_IMAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
    }
    
    fileprivate func toolbarBackgroundImage() -> UIImage {
        let components: [CGFloat] = [1, 1, 1, 1, 123.0 / 255.0, 125.0 / 255.0, 132.0 / 255.0, 1]
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 320, height: 54), true, 0)
        
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: nil, count: 2)
        
        context!.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 54), options: [])
        
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return viewImage!
    }
    
    fileprivate func setupToolbar() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.toolbar = UIToolbar(frame: CGRect.zero)
            self.toolbar.isTranslucent = true
            self.toolbar.barStyle = .black
            self.view.addSubview(self.toolbar)
            
            self.setupCancelButton()
            self.setupUseButton()
            
            let info = UILabel(frame: CGRect.zero)
            info.text = ""
            info.textColor = UIColor(red: 0.173, green: 0.173, blue: 0.173, alpha: 1)
            info.backgroundColor = UIColor.clear
            info.shadowColor = UIColor(red: 0.827, green: 0.731, blue: 0.839, alpha: 1)
            info.shadowOffset = CGSize(width: 0, height: 1)
            info.font = UIFont(name: "OpenSansHebrew-Bold", size: 18)//UIFont.boldSystemFontOfSize(18)
            info.sizeToFit()
            
            let cancel = UIBarButtonItem(customView: self.cancelButton)
            let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let label = UIBarButtonItem(customView: info)
            let use = UIBarButtonItem(customView: self.useButton)
            
            self.toolbar.setItems([cancel, flex, label, flex, use], animated: false)
        }
    }
}
