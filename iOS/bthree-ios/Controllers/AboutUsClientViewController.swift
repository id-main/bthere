//
//  AboutUsClientViewController.swift
//  Bthere
//
//  Created by Racheli Kroiz on 25.10.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class AboutUsClientViewController: NavigationModelViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnRegulation: UIButton!
    @IBOutlet weak var txtVAbout: UITextView!
    //לתקנון ותנאי השימוש
    @IBAction func btnRegulation(_ sender: AnyObject) {
        
        let clientStoryBoard = UIStoryboard(name: "ClientExist", bundle: nil)
        
        let viewRegulation: RegulationClientViewController = clientStoryBoard.instantiateViewController(withIdentifier: "RegulationClientViewController")as! RegulationClientViewController
        viewRegulation.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        //        self.view.addSubview(viewRegulation.view)
        viewRegulation.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewRegulation, animated: true, completion: nil)
        //        self.presentViewController(viewRegulation, animated: true, completion: nil)
    }
    //MARK: - Outlet
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:27)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRegulation.setTitle("VIEW_TERMS_OF_USE".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        lblTitle.text = "ABOUT_US".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        txtVAbout.text = "VIEW_ABOUT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        // Set terms of use text
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            if   let rtf = Bundle.main.url(forResource: "About_HE", withExtension: "rtf", subdirectory: nil, localization: nil) {
                
                do {
                    let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType):convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.rtf)]), documentAttributes: nil)
                    self.txtVAbout.attributedText  = attributedString
                    self.txtVAbout.textAlignment = .right
                } catch let error {
                    print("Got an error \(error)")
                    
                }
            }
        } else {
            // Other
            if   let rtf = Bundle.main.url(forResource: "About_EN", withExtension: "rtf", subdirectory: nil, localization: nil) {
                
                do {
                    let attributedString: NSAttributedString =  try NSAttributedString(url: rtf, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType):convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.rtf)]), documentAttributes: nil)
                    self.txtVAbout.attributedText  = attributedString
                    self.txtVAbout.textAlignment = .left
                } catch let error {
                    print("Got an error \(error)")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //  self.view.backgroundColor = UIColor(patternImage: UIImage(named: "client.jpg")!)
        self.view.addBackground()
        
    }
}
extension UIView {
    func addBackground() {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "client.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }}
extension UIView {
    func addBackground2() {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "Search Result Hairdresser.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }}
extension UIViewController {
    func showAlertDelegateX(_ mess:String) {
        let alertController = UIAlertController(title: "", message:
            mess, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
        }
}
extension UIViewController {
    func showthePopupDelegate() {
            let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
            let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
            let viewpop:PopUpGenericViewController = storyboardtest.instantiateViewController(withIdentifier: "PopUpGenericViewController") as! PopUpGenericViewController
            if iOS8 == true {
                viewpop.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            } else {
                viewpop.modalPresentationStyle = UIModalPresentationStyle.currentContext
            }
            viewpop.isfromWhichScreen = 3
            self.present(viewpop, animated: true, completion: nil)
    }
}
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
extension UIAlertController {
    
    func show() {
        present(true, completion: nil)
    }
    
    func present(_ animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(rootVC, animated: animated, completion: completion)
        }
    }
    
    fileprivate func presentFromController(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(visibleVC, animated: animated, completion: completion)
        } else
            if let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(selectedVC, animated: animated, completion: completion)
            } else {
                controller.present(self, animated: animated, completion: completion);
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringDocumentReadingOptionKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.DocumentReadingOptionKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.DocumentReadingOptionKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentAttributeKey(_ input: NSAttributedString.DocumentAttributeKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentType(_ input: NSAttributedString.DocumentType) -> String {
	return input.rawValue
}
