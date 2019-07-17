//
//  Generic.swift
//  SafePay3DApp
//
//  Created by Lior Ronen on 12/14/15.
//  Copyright © 2015 racheliKrimalovski. All rights reserved.
//

import UIKit
var controller: UIViewController = UIViewController()

class Generic: UIViewController {
 static let sharedMyManager = Generic()
//    private lazy var __once: () = {() -> Void in
//            sharedMyManager = self.init()
//        }()

    var animatedDistance: CGFloat = 0.0
    let KEYBOARD_ANIMATION_DURATION: CGFloat = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat = 0.8
    let PORTRAIT_KEYBOARD_HEIGHT: CGFloat = 216
    let LANDSCAPE_KEYBOARD_HEIGHT: CGFloat = 162
    var activityIndicatorView:UIActivityIndicatorView = UIActivityIndicatorView()
//    convenience override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
//        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        // Custom initialization
//    }
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func showNativeActivityIndicator(_ cont: UIViewController) {
      
       self.hideNativeActivityIndicator(cont)
        controller = cont
        let avToShow: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        self.activityIndicatorView = avToShow
        avToShow.frame = CGRect(x: 145, y: 160, width: 25, height: 25)
        avToShow.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
        avToShow.tag = 123
        //  avToShow.color = UIColor(red: 213.0, green: 213.0, blue: 231.0 / 255.0, alpha: 1.000)
        avToShow.color = UIColor(red: 230.0 / 255.0, green: 92.0 / 255.0, blue: 1.0 / 255.0, alpha: 1.000)
        controller.view.addSubview(avToShow)
        controller.view.bringSubviewToFront(avToShow)
        avToShow.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    
    
    func showNativeActivityIndicatorInteractionEnabled(_ cont: UIViewController) {
        self.hideNativeActivityIndicator(cont)
        controller = cont
        let avToShow: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        self.activityIndicatorView = avToShow
        avToShow.frame = CGRect(x: 145, y: 160, width: 25, height: 25)
        avToShow.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
        avToShow.tag = 123
        //  avToShow.color = UIColor(red: 213.0, green: 213.0, blue: 231.0 / 255.0, alpha: 1.000)
        avToShow.color = UIColor(red: 230.0 / 255.0, green: 92.0 / 255.0, blue: 1.0 / 255.0, alpha: 1.000)
        controller.view.addSubview(avToShow)
        controller.view.bringSubviewToFront(avToShow)
        avToShow.startAnimating()
//        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hideNativeActivityIndicator(_ cont: UIViewController) {
  
        let v:UIActivityIndicatorView = self.activityIndicatorView
       //
        v.removeFromSuperview()
     if  UIApplication.shared.isIgnoringInteractionEvents {
        UIApplication.shared.endIgnoringInteractionEvents()
        }
      
    }
    
    func hideNativeActivityIndicatorInteractionEnabled(_ cont: UIViewController) {
        
        let v:UIActivityIndicatorView = self.activityIndicatorView
        //
        v.removeFromSuperview()
        if  UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func pushTextField(_ textField: UITextField, controller cont: UIViewController) {
        controller = cont
        let textFieldRect: CGRect = controller.view.convert(textField.bounds, from: textField)
        let viewRect: CGRect = controller.view.convert(controller.view.bounds, from: controller.view)
       let midline: CGFloat = textFieldRect.origin.y + 0.5 * textFieldRect.size.height
    let numerator: CGFloat = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height
    let denominator: CGFloat = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height
    var heightFraction: CGFloat = numerator / denominator
    if heightFraction < 0.0 {
    heightFraction = 0.0
    }
    else {
    if heightFraction > 1.0 {
    heightFraction = 1.0
    }
    }
    let orientation: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
    if orientation == .portrait || orientation == .portraitUpsideDown {
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction)
    }
    else {
    animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction)
    }
    var viewFrame: CGRect = controller.view.frame
    viewFrame.origin.y -= animatedDistance
    UIView.beginAnimations(nil, context: nil)

         UIView.setAnimationBeginsFromCurrentState(true)
    UIView.setAnimationDuration(0.3)
    controller.view.frame = viewFrame
    UIView.commitAnimations()
}
    func returnTextField(_ textField: UITextField, controller cont: UIViewController) {
        controller = cont
        var viewFrame: CGRect = controller.view.frame
        viewFrame.origin.y += animatedDistance
        UIView.beginAnimations(nil, context: nil)
         UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.3)
        controller.view.frame = viewFrame
        UIView.commitAnimations()
    }
    
    class func shareGeneric() -> AnyObject {
        var sharedMyManager: Generic? = nil
        var onceToken: Int = 0
        
     //   _ = self.__once
        return sharedMyManager!
    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
