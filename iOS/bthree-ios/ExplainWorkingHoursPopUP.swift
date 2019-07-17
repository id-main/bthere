//
//  ExplainWorkingHoursPopUP.swift
//  BThere
//
//  Created by Ioan Ungureanu on 25/10/18.
//  Copyright © 2018 Bthere. All rights reserved.
//

import Foundation
import UIKit

class  ExplainWorkingHoursPopUP:UIViewController {
    @IBOutlet weak var TitleScreen:UILabel!
    @IBOutlet weak var FirstLineTextBold:UILabel!
    @IBOutlet weak var SecondLineTextExplain:UILabel!
    @IBOutlet weak var LineText1:UILabel!
    @IBOutlet weak var LineText2:UILabel!
    @IBOutlet weak var LineText3:UILabel!
    @IBOutlet weak var LineText4:UILabel!
    @IBOutlet weak var ImagesView1:UIView!
    @IBOutlet weak var ImagesView2:UIView!
    @IBOutlet weak var CloseXButton:UIButton!
    @IBOutlet weak var hiddenButtonGuide:UIButton!
     @IBOutlet weak var day1:UIButton!
     @IBOutlet weak var day2:UIButton!
     @IBOutlet weak var day3:UIButton!
     @IBOutlet weak var day4:UIButton!
     @IBOutlet weak var day5:UIButton!
     @IBOutlet weak var day6:UIButton!
     @IBOutlet weak var day7:UIButton!
    @IBOutlet weak var day11:UIButton!
    @IBOutlet weak var day21:UIButton!
    @IBOutlet weak var day31:UIButton!
    @IBOutlet weak var day41:UIButton!
    @IBOutlet weak var day51:UIButton!
    @IBOutlet weak var day61:UIButton!
    @IBOutlet weak var day71:UIButton!
    var FirstImagesArray:Array<UIButton> = Array<UIButton>()
    var SecondImagesArray:Array<UIButton> = Array<UIButton>()
    var MyWeekDayNames:Array<String> = ["SUNDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                        "MONDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                        "TUESDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                        "WEDNSDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                        "THIRTHDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                        "FRIDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                        "SHABAT2".localized(LanguageMain.sharedInstance.USERLANGUAGE)]

    
    @IBAction func CloseXButton(_ sender: AnyObject) {
    self.dismiss(animated: false, completion: nil)
    }

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleScreen.text = "EXPLAINWORKINGHOURSTITLESCREEN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        FirstLineTextBold.text = "EXPLAINWORKINGHOURSFIRSTLINETEXTBOLD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        SecondLineTextExplain.text = "EXPLAINWORKINGHOURSSECONDLINETEXTEXPLAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText1.text = "EXPLAINWORKINGHOURSLINETEXT1".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText2.text = "EXPLAINWORKINGHOURSLINETEXT2".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText3.text = "EXPLAINWORKINGHOURSLINETEXT3".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        LineText4.text = "EXPLAINWORKINGHOURSLINETEXT4".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        FirstImagesArray = [day1,day2,day3,day4, day5,day6,day7]
        SecondImagesArray = [day11,day21,day31,day41, day51,day61,day71]
         for i in 0...6 {
            let mybutton = FirstImagesArray[i]
            mybutton.setTitle(MyWeekDayNames[i], for: UIControlState())
            mybutton.titleLabel?.textColor = .white
            mybutton.titleLabel?.font = UIFont (name: "OpenSansHebrew-Bold", size: 18)
            if i == 0 {
                mybutton.backgroundColor = Colors.sharedInstance.color4 // light blue
            } else {
                mybutton.backgroundColor = Colors.sharedInstance.color5 //dark gray
            }
        }
        for i in 0...6 {
            let mybutton = SecondImagesArray[i]
            mybutton.setTitle(MyWeekDayNames[i], for: UIControlState())
            mybutton.titleLabel?.textColor = .white
            mybutton.titleLabel?.font = UIFont (name: "OpenSansHebrew-Bold", size: 18)
            if i == 0 || i == 1  || i == 3   {
                mybutton.backgroundColor = Colors.sharedInstance.color4 // light blue
            } else {
                mybutton.backgroundColor = Colors.sharedInstance.color5 //dark gray
            }
        }
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
    }
}
