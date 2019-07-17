//
//  GenericWebView.swift
//  BThere
//
//  Created by Ioan Ungureanu on 05/09/2018 dmy
//  Copyright © 2018 BThere. All rights reserved.
//

import UIKit

class GenericWebView: NavigationModelViewController, UIWebViewDelegate {
    // Outlets
    @IBOutlet weak var titlescreen:UILabel!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet var liveChatWebView: UIWebView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var loadingWebActivity: UIActivityIndicatorView!
    @IBOutlet weak var btnback:UIButton!
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated:true, completion:nil)
    }
    
    var userphone:String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
       
            self.btnback.isHidden = false
            self.btnback.isUserInteractionEnabled = true
            self.backImg.isHidden = false
            var scalingTransform : CGAffineTransform!
            scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        
            if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
                {
                    self.btnback.transform = scalingTransform
                    self.backImg.transform = scalingTransform
                }
    
        titlescreen.text = "BTN_CUSTOMER_RECOMANDATION".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        liveChatWebView.delegate = self
        liveChatWebView.scrollView.bounces = false
        var stringURL = ""
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            stringURL = "https://bthere-tech.com/landing-page-4/"
        } else {
            stringURL = "https://bthere-tech.com/landing-page-5/"
        }
    let finalurl = stringURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
    liveChatWebView.loadRequest(URLRequest(url: URL(string:finalurl!)!))
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
       
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingWebActivity.stopAnimating()
        loadingWebActivity.isHidden = true
    }
   
}

