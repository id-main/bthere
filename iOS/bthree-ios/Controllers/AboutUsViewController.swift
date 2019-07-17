//
//  AboutUsViewController.swift
//  Bthere
//
//  Created by User on 24.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//ספק קיים-דף אודותינו
class AboutUsViewController: NavigationModelViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var txtVAbout: UITextView!
    
    @IBOutlet weak var lblRegulations: UILabel!
    
    @IBOutlet weak var lblGuide: UILabel!
    
    //MARK: - Outlet
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:27)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGuide:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openGuideVideo))
        lblGuide.addGestureRecognizer(tapGuide)
        let tapRegulations:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openRegulations))
        lblRegulations.addGestureRecognizer(tapRegulations)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "client.jpg")!)
         self.view.addBackground()
    }
    
    @objc func openGuideVideo()
    {
        
    }
    
    @objc func openRegulations()
    {
        
    }
}
