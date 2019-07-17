//
//  Colors.swift
//  Bthere
//
//  Created by Tami wexelbom on 9.2.2016.
//  Converted to Swift 3.x - clean by Ungureanu Ioan 11/04/2018
//  Copyright © 2018 Bthere. All rights reserved.


import UIKit

class Colors: NSObject {
    static let sharedInstance = Colors()
    var color1:UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)                   //  black color
    var grey:UIColor =  UIColor(red: 77/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1.0)     //  gray color
    var color2:UIColor = UIColor(red: 245/255.0, green: 240/255.0, blue: 239/255.0, alpha: 1.0) //  light A gray color
    var color3:UIColor = UIColor(red: 244/255.0, green: 148/255.0, blue: 113/255.0, alpha: 1.0) //  orange color
    var color4:UIColor = UIColor(red: 146/255.0, green: 203/255.0, blue: 216/255.0, alpha: 1.0) //  light blue color
    var color5:UIColor = UIColor(red: 76/255.0, green: 76/255.0, blue: 76/255.0, alpha: 1.0)    //  dark gray color
    var color6:UIColor = UIColor(red: 203/255.0, green: 197/255.0, blue: 190/255.0, alpha: 1.0) //  light E gray color
    var color7:UIColor = UIColor(red: 217/255.0, green: 211/255.0, blue: 204/255.0, alpha: 1.0) //  light D gray color
    var color8:UIColor = UIColor(red: 231/255.0, green: 225/255.0, blue: 218/255.0, alpha: 1.0) //  light C gray color
    var color9:UIColor = UIColor(red: 245/255.0, green: 239/255.0, blue: 232/255.0, alpha: 1.0) //  light B gray color
    var darkred:UIColor = UIColor(red: 255/255.0, green: 93/255.0, blue: 78/255.0, alpha: 1.0)  //  light Red R: 255	G: 93	B: 78 / see darker : R: 148	G: 21	B: 21
    var morcovorange:UIColor = UIColor(red: 244/255.0, green: 102/255.0, blue: 27/255.0, alpha: 1.0)
    var redforblockinghours:UIColor = UIColor(red: 207/255.0, green: 10/255.0, blue: 29/255.0, alpha: 1.0)
    var greenforsyncedincalendar:UIColor = UIColor(red: 77/255.0, green: 163/255.0, blue: 71/255.0, alpha: 1.0) //#4da347
    var redlightforblocked:UIColor = UIColor(red: 247/255.0, green: 75/255.0, blue: 87/255.0, alpha: 1.0) //#4da347
    var fontMainHeader:UIFont = UIFont(name: "OpenSansHebrew-Bold", size: 32)!
    var fontSecondHeader:UIFont = UIFont(name: "OpenSansHebrew-Bold", size: 23)!
    var fontSmallHeader:UIFont = UIFont(name: "OpenSansHebrew-Bold", size: 18)!
    var fontText1:UIFont = UIFont(name: "OpenSansHebrew-Light", size: 23)!
    var fontText2:UIFont = UIFont(name: "OpenSansHebrew-Regular", size: 23)!
    var fontText3:UIFont = UIFont(name: "OpenSansHebrew-Light", size: 16)!
    var fontText4:UIFont = UIFont(name: "OpenSansHebrew-Light", size: 12)!

    func addTopAndBottomBorderWithColor(_ color: UIColor, width: CGFloat,any :AnyObject) {
        self.addTopBorderWithColor(color, width: width, any: any as! UIView)
        self.addBottomBorderWithColor(color, width: width, any: any as! UIView)
    }
    //design func that get color, width and view and add top border
    func addTopBorderWithColor(_ color: UIColor, width: CGFloat,any :UIView) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: any.frame.size.width , height: width)
        any.layer.addSublayer(border)
    }
        //design func that get color, width and view and add buttom  border
    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat,any :UIView) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: any.frame.size.height - width, width: any.frame.size.width , height: width)
        any.layer.addSublayer(border)
    }

    func addRightBorderWithColor(_ color: UIColor, width: CGFloat,any :UIView) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: any.frame.size.width - width, y: 0, width: width, height: any.frame.size.height)
        any.layer.addSublayer(border)
    }
        //design func that get color, width and view and add Left border
    func addLeftBorderWithColor(_ color: UIColor, width: CGFloat,any :UIView) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: any.frame.size.height)
        any.layer.addSublayer(border)
    }
}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}
