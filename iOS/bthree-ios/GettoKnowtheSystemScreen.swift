//
//  GettoKnowtheSystemScreen.swift
//  BThere
//
//  Created by Ioan Ungureanu on 29/10/18.
//  Copyright © 2018 Bthere. All rights reserved.
//

import Foundation
import UIKit

class  GettoKnowtheSystemScreen:UIViewController {
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
    
    override func viewDidLoad() {
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
    func openVideoProviderScreen() {
        let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
        let abc:IntroVideoPlayerScreen = mainstoryb.instantiateViewController(withIdentifier: "IntroVideoPlayerScreen")as! IntroVideoPlayerScreen
        abc.view.frame = CGRect(x: 0, y:64, width:self.view.frame.size.width, height: self.view.frame.size.height - 64)
        abc.modalPresentationStyle = .custom
        abc.whichvideo = 0
        self.present(abc, animated: true, completion: nil)

    }
    func openVideoCustomerScreen() {
        let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
        let abc:IntroVideoPlayerScreen = mainstoryb.instantiateViewController(withIdentifier: "IntroVideoPlayerScreen")as! IntroVideoPlayerScreen
        abc.view.frame = CGRect(x: 0, y:64, width:self.view.frame.size.width, height: self.view.frame.size.height - 64)
        abc.modalPresentationStyle = .custom
        abc.whichvideo = 1
        self.present(abc, animated: true, completion: nil)

    }


}
