//
//  HelpLiveChatViewController.swift
//  BThere
//
//  Created by Eduard Stefanescu on 12/4/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import UIKit

class HelpLiveChatViewController: NavigationModelViewController, UIWebViewDelegate {
    // Outlets
    @IBOutlet var liveChatWebView: UIWebView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var loadingWebActivity: UIActivityIndicatorView!
    @IBOutlet var liveChatLabel: UILabel!
    @IBOutlet var goBackButton: UIButton!
    @IBOutlet var backImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:21)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        
        self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 400)
        
        liveChatWebView.delegate = self
        liveChatWebView.scrollView.bounces = false
        let stringURL = "https://tawk.to/chat/5a1eba1c198bd56b8c03e08c/default/?$_tawk_popout=true&$_tawk_sk=5a1f2bb684673f690b197e1a&$_tawk_tk=6d3375dec99fadc99230f038e9401242&v=570".addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        liveChatWebView.loadRequest(URLRequest(url: URL(string:stringURL!)!))
        
        liveChatLabel.text = "LIVE_CHAT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        //        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
        //            topConstraint.constant = 75
        //        } else {
        //            topConstraint.constant = 75
        //        }
        
        
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            // Hebrew
            goBackButton.transform = scalingTransform
            backImage.transform = scalingTransform
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func goBackButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingWebActivity.stopAnimating()
        loadingWebActivity.isHidden = true
    }
}
