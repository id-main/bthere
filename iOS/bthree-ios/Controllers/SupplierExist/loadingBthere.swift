//
//  loadingBthere.swift
//  BThere
//
//  Created by Eduard Stefanescu on 8/21/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
class loadingBthere: UIViewController {
    
    // Variables
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var viewunu:UIView!
    @IBOutlet weak var ballShape:UIImageView!
    
    // let modelName = UIDevice.currentDevice().modelName
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewDidLayoutSubviews() {
        let a:CGRect = CGRect(x: logoImage.frame.origin.x - 40, y: logoImage.frame.origin.y - 40 , width: logoImage.frame.size.width + 80, height: logoImage.frame.size.height + 80)
        let myview = NVActivityIndicatorView(frame: a, type: .ballRotateChase , color: UIColor.white, padding: 0)
        self.view.addSubview(myview)
        self.view.bringSubviewToFront(myview)
        myview.startAnimating()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Spin ball on circle function
    func spinBall() {
        // Draw circle around the logo function
        let padding : CGFloat = 40
        let x = logoImage.layer.position.x - (logoImage.frame.width / 2)
        var y:CGFloat = 0
        var circlePath : UIBezierPath!
        var translation : CGSize!
        
        if (UIDevice.current.model.range(of: "iPad") != nil) {
            // iPad device detected
            // Logo position
            y = logoImage.layer.position.y  - (logoImage.frame.height / 1.5)
            
            // Set oval position
            circlePath = UIBezierPath(ovalIn: CGRect(
                x: x - padding,
                y: y -  60 ,
                width: self.logoImage.frame.size.width + (2 * padding),
                height: self.logoImage.frame.size.height +  self.logoImage.frame.size.height / 2
                ))
            circlePath.apply (CGAffineTransform(rotationAngle: 65 * CGFloat(M_PI) / 90))
            
            // Adapt based on iPad version
            if (UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0) {
                // iPad Pro, iPad Retina
                translation = CGSize(width: self.logoImage.frame.origin.x + 3.7 * self.logoImage.frame.size.width, height: self.logoImage.frame.origin.y + 0.5 * self.logoImage.frame.size.height)
                print("Device: iPad Pro, iPad Retina")
            } else {
                // iPad 2, iPad Air, iPad Air 2
                translation = CGSize(width: self.logoImage.frame.origin.x + 3.6 * self.logoImage.frame.size.width, height: self.logoImage.frame.origin.y + 0.5 * self.logoImage.frame.size.height)
                print("Device: iPad 2, iPad Air, iPad Air 2")
            }
        } else {
            // iPhone device detected
            // Logo position
            y = logoImage.layer.position.y  - (logoImage.frame.height / 3)
            
            // Set oval position
            circlePath = UIBezierPath(ovalIn: CGRect(
                x: x - padding,
                y: y -  60 ,
                width: self.logoImage.frame.size.width + (2 * padding),
                height: self.logoImage.frame.size.height +  self.logoImage.frame.size.height / 2
            ))
            circlePath.apply (CGAffineTransform(rotationAngle: 30 * CGFloat(M_PI) / 180))
    
            
            // Adapt based on iPhone version
            if (UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0) {
                // iPhone 6 Plus, iPhone 6s, iPhone 7, iPone 7 Plus
                translation = CGSize(width:  self.logoImage.frame.origin.x + self.logoImage.frame.size.width / 2, height: self.logoImage.frame.origin.y - 2.4 * self.logoImage.frame.size.height)
            } else if (UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0) {
                // iPhone 6
                translation = CGSize(width:  self.logoImage.frame.origin.x + self.logoImage.frame.size.width / 2, height: self.logoImage.frame.origin.y - 2.1 * self.logoImage.frame.size.height)
            } else {
                // iPhone 5, iPhone 5s
                translation = CGSize(width:  self.logoImage.frame.origin.x + self.logoImage.frame.size.width / 2, height: self.logoImage.frame.origin.y - 1.70 * self.logoImage.frame.size.height)
            }
        }
        
        circlePath.apply(CGAffineTransform(translationX: translation.width, y: translation.height))

        let animation = CAKeyframeAnimation(keyPath: "position");
        animation.duration = 0.75
        animation.repeatCount = MAXFLOAT
        animation.path = circlePath.cgPath
        let circlesPath = UIBezierPath(arcCenter: CGPoint(x: 5,y: 5), radius: CGFloat(15), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlesPath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.white.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.white.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        shapeLayer.add(animation, forKey: nil)
        view.layer.addSublayer(shapeLayer)
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.opacity = 0.5
        view.layer.addSublayer(circleLayer)

        
    }
}

