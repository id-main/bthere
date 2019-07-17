//
//  EventsWeekViewsCollectionViewCell.swift
//  bthree-ios
//
//  Created by User on 16.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

//לצורך פתיחת פרטי ההזמנה במודל
protocol openDetailsOrderDelegate {
    func openDetailsOrder(_ tag:Int)
}

class EventsWeekViewsCollectionViewCell: UICollectionViewCell{

    //MARK: - Outlet
    
//    @IBOutlet weak var viewTopForFree: UIView!
//    @IBOutlet weak var viewBottumForFree: UIView!
//    @IBOutlet var viewTopInTop: UIView!
//    @IBOutlet var viewButtomInTop: UIView!
//    @IBOutlet var viewMiddleInTop: UIView!
//    @IBOutlet var viewTopInButtom: UIView!
//    @IBOutlet var viewButtominButtom: UIView!
//    @IBOutlet var viewMiddleInButtom: UIView!
//    @IBOutlet weak var viewTop: UIView!
//    @IBOutlet weak var viewBottom: UIView!
//    @IBOutlet weak var lblHoursTop: UILabel!
//    @IBOutlet weak var lblDescTop: UILabel!
//    @IBOutlet weak var lblHoursBottom: UILabel!
//    @IBOutlet weak var lblDescBottom: UILabel!
      @IBOutlet weak var txtviewDesc: UITextView!
//    @IBOutlet weak var txtViewDescBottom: UITextView!
//    @IBOutlet weak var viewTopEvent: UIView!
//    @IBOutlet weak var viewBottomEvent: UIView!
      @IBOutlet weak var eyeImg: UIImageView!
      @IBOutlet weak var patternImg: UIImageView!
      @IBOutlet weak var BthereImg: UIImageView!
       @IBOutlet weak var lineviewTop: UIView!
       @IBOutlet weak var lineviewBottom: UIView!
       @IBOutlet weak var lineviewLeft: UIView!
       @IBOutlet weak var lineviewRight: UIView!
    //NEW 05.10.2017
      @IBOutlet weak var FIRSTLINE: UIView!
     @IBOutlet weak var SECONDLINE: UIView!
     @IBOutlet weak var THIRSLINE: UIView!
      @IBOutlet weak var FOURTHLINE: UIView!
    //MARK: - Properties
    
    var  hastop:Bool = false
    var  hasleft:Bool = false
    var  hasright:Bool = false
    var  hasbottom:Bool = false
//    var  IsMiddleeButtom:Bool = false
//    var  IsButtomButtom:Bool = false
//    var viewInTop:UIView  = UIView()
//    var viewInButtom:UIView  = UIView()
//    var DisplayDataDay:Bool = false
    var hasEvent:Bool = false
    var hasEventBthere:Bool = false
    var hourFree:String = ""
    var dateEvent:Date = Date()
    var hourStart:String = ""
    var hourEnd:String = ""
    var delegate:openDetailsOrderDelegate!=nil
    var delegateClickOnDay:enterOnDayDelegate!=nil
//    var heightViewTop: NSLayoutConstraint?
//    var hightViewButtom: NSLayoutConstraint?
//    var heightViewTopEvent: NSLayoutConstraint?
//    var hightViewButtomEvent: NSLayoutConstraint?
    //JMODE +
    var tagofcell:Int = 0
    var ALLCELLEVENTS:Array<allKindEventsForListDesign> = Array<allKindEventsForListDesign>()
    //MARK: - Initial
    override func prepareForReuse() {
        super.prepareForReuse()
       
    }
    override func awakeFromNib() {
//        self.sendSubviewToBack(viewBottom)
//        self.sendSubviewToBack(viewTop)
       
//        eyeImg.hidden = true
//        BthereImg.hidden = true
      
      
       
       
     //   self.layer.borderColor = UIColor.blackColor().CGColor
     //   self.layer.borderWidth = 0.5
     
        self.layoutMargins = UIEdgeInsets.zero
        self.contentView.frame = self.bounds;
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          self.layer.addBorderx(UIRectEdge.left, color: UIColor.darkGray, thickness: 0.5)
         if UIDevice.current.userInterfaceIdiom == .pad {
         } else {
    self.layer.addBorderx(UIRectEdge.right, color: UIColor.darkGray, thickness: 0.5)
    
        }
    }
   
    //cell design
    func setDisplayData(_ a:Int, events:Array<allKindEventsForListDesign>,_hastop:Bool, _hasbottom:Bool, _hasleft:Bool, _hasright:Bool) {
        ALLCELLEVENTS = events
        hastop = _hastop
        hasbottom = _hasbottom
        hasleft = _hasleft
        hasright = _hasright
        if hastop == true {
            lineviewTop.isHidden = false
        } else {
              lineviewTop.isHidden = true
        }
        if hasbottom == true {
            lineviewBottom.isHidden = false
        } else {
              lineviewBottom.isHidden = true
        }
        if hasleft == true {
            lineviewLeft.isHidden = false
        } else {
             lineviewLeft.isHidden = true
        }
        if hasright == true {
            lineviewRight.isHidden = false
        } else {
             lineviewRight.isHidden = true
        }
          print("ALLCELLEVENTS.count \(ALLCELLEVENTS.count)")
        
       
//        lineviewTop.hidden = false
//        lineviewBottom.hidden = false
//        lineviewLeft.hidden = false
//        lineviewRight.hidden = false
//        if a == 3 || a == 8 {
//            BthereImg.hidden = false
//             eyeImg.hidden = false
//          self.layer.addBorder(UIRectEdge.Top, color: UIColor.lightGrayColor(), thickness: 2)
//            self.layer.addBorder(UIRectEdge.Left, color: UIColor.lightGrayColor(), thickness: 2)
//            self.layer.addBorder(UIRectEdge.Right, color: UIColor.lightGrayColor(), thickness: 2)
//        }
//        if a == 31 || a == 10 || a == 17 || a == 24 || a == 15 || a == 22 || a == 29 {
//        
//            self.layer.addBorder(UIRectEdge.Left, color: UIColor.lightGrayColor(), thickness: 2)
//              self.layer.addBorder(UIRectEdge.Right, color: UIColor.lightGrayColor(), thickness: 2)
//        }
//        if a == 38 || a == 36 {
//            self.layer.addBorder(UIRectEdge.Left, color: UIColor.lightGrayColor(), thickness: 2)
//            self.layer.addBorder(UIRectEdge.Right, color: UIColor.lightGrayColor(), thickness: 2)
//
//              self.layer.addBorder(UIRectEdge.Bottom, color: UIColor.lightGrayColor(), thickness: 2)
//        }
//            if ALLCELLEVENTS.count > 0 {
//            txtviewDesc.text = String(a)
//        }
                       if hasEventBthere == true
        {
            txtviewDesc.font = UIFont(name:"OpenSansHebrew-Bold", size: 11)
       //     txtViewDescBottom.font = UIFont(name:"OpenSansHebrew-Bold", size: 11)
            
        }
        else
        {
            txtviewDesc.font =  UIFont(name: "OpenSansHebrew-Regular", size: 11)
         //   txtViewDescBottom.font =  UIFont(name: "OpenSansHebrew-Regular", size: 11)
        }
      //  if ALLCELLEVENTS.count > 0 {
        txtviewDesc.text = String(a)
     //   }
    }
    func setDisplayDatxa(_ numViewsToShow:Int,isTop:Bool,description:String,descTop:Bool, eventStarthour:Int)
    {
          print("eventStarthour\(eventStarthour)")
        if hasEventBthere == true
        {
        txtviewDesc.font = UIFont(name:"OpenSansHebrew-Bold", size: 11)
     //   txtViewDescBottom.font = UIFont(name:"OpenSansHebrew-Bold", size: 11)

        }
        else
        {
        txtviewDesc.font =  UIFont(name: "OpenSansHebrew-Regular", size: 11)
     //   txtViewDescBottom.font =  UIFont(name: "OpenSansHebrew-Regular", size: 11)
        }


//        viewTopInTop.hidden = true
//        viewButtomInTop.hidden  = true
//        viewMiddleInTop.hidden  = true
//        viewTopInButtom.hidden  = true
//        viewButtominButtom.hidden  = true
//        viewMiddleInButtom.hidden  = true
        
        if hasEvent == true || hasEventBthere == true
        {
          //  self.checkWhichValue()
        }
        else
        {
//            viewTopInTop.hidden = true
//            viewButtomInTop.hidden  = true
//            viewMiddleInTop.hidden  = true
//            viewTopInButtom.hidden  = true
//            viewButtominButtom.hidden  = true
//            viewMiddleInButtom.hidden  = true
        }

        if descTop == true
        {
            txtviewDesc.text = description
        }
        else
        {
      //      txtViewDescBottom.text = description
        }
    }
   
//    func setDisplayDataDay(hourTop:String,descTop:String,hourBottom:String,descBottom:String)
//    {
//        DisplayDataDay = true
//        if hourTop != ""
//        {
//            lblHoursTop.text = hourTop
//        }
//        if descTop != ""
//        {
//            lblDescTop.text = descTop
//        }
//        if hourBottom != ""
//        {
//            lblHoursBottom.text = hourBottom
//        }
//        if descBottom != ""
//        {
//            lblDescBottom.text = descBottom
//        }
//    }

    //פונקציה זו מקבלת ארבעה פרמטרים
    //  whichViewמשתנה זה מסמל את איזה ויו צריך לצבוע בכחול
    //fromPage = 1 אם מגיע לכאן מתצוגת יום
    //fromPage = 0 אם מגיע לכאן מתצוגת שבוע   
    //ועוד שתי משתנים של הגבהים של היו שמשתנים בהתאם לדקות
//    func setDisplayViews(whichView:Bool,fromPage:Int,heightTop:CGFloat ,heightButtom:CGFloat)  {
//        
//        //הקוד לתצוגת שבוע ויום זהה, אך ה views שאותם עורכים שונים בהם
//        
//        if fromPage == 0//אם הגעתי מתצוגת שבוע
//        {
//            if whichView == true{//סימן שצריך לצבוע את הטופ
//                viewTopForFree.backgroundColor = Colors.sharedInstance.color4
//                //viewBottumForFree.backgroundColor = UIColor.clearColor()
//                
//                if heightViewTop != nil{
//                    self.removeConstraint(heightViewTop!)
//                    
//                }
//                heightViewTop = NSLayoutConstraint(item: viewTopForFree, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: heightTop, constant: 0)
//                self.addConstraint(heightViewTop!)
//          
//                if hightViewButtom != nil{
//                    self.removeConstraint(hightViewButtom!)
//                    
//                }
//                hightViewButtom = NSLayoutConstraint(item: viewBottumForFree, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: heightButtom, constant:0)
//                self.addConstraint(hightViewButtom!)
//     
//                viewTopForFree.alpha = 0.6
//            }
//            else{
//                viewBottumForFree.backgroundColor = Colors.sharedInstance.color4
//                
//                if heightViewTop != nil{
//                    self.removeConstraint(heightViewTop!)
//                    
//                }
//                heightViewTop = NSLayoutConstraint(item: viewTopForFree, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: heightTop, constant: 0)
//                self.addConstraint(heightViewTop!)
//     
//                if hightViewButtom != nil{
//                    self.removeConstraint(hightViewButtom!)
//                    
//                }
//                hightViewButtom = NSLayoutConstraint(item: viewBottumForFree, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: heightButtom, constant: 0)
//                self.addConstraint(hightViewButtom!)
//
//                viewBottumForFree.alpha = 0.6
//            }
//        }
//        else//הגעתי מתצוגת יום
//        {
//            if whichView == true{//סימן שצריך לצבוע את הטופ
//                viewTop.backgroundColor = Colors.sharedInstance.color4
//                
//                if heightViewTop != nil{
//                    self.removeConstraint(heightViewTop!)
//                    
//                }
//                heightViewTop = NSLayoutConstraint(item: viewTop, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: heightTop, constant: 0)
//                self.addConstraint(heightViewTop!)
//      
//                if hightViewButtom != nil{
//                    self.removeConstraint(hightViewButtom!)
//                    
//                }
//                hightViewButtom = NSLayoutConstraint(item: viewBottom, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: heightButtom, constant:0)
//                self.addConstraint(hightViewButtom!)
//                               viewTop.alpha = 0.6
//            }
//            else{
//                viewBottom.backgroundColor = Colors.sharedInstance.color4
//                                if heightViewTop != nil{
//                    self.removeConstraint(heightViewTop!)
//                    
//                }
//                heightViewTop = NSLayoutConstraint(item: viewTop, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: heightTop, constant: 0)
//                self.addConstraint(heightViewTop!)
//                               if hightViewButtom != nil{
//                    self.removeConstraint(hightViewButtom!)
//                    
//                }
//                hightViewButtom = NSLayoutConstraint(item: viewBottom, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: heightButtom, constant: 0)
//                self.addConstraint(hightViewButtom!)
//                             viewBottom.alpha = 0.6
//            }
//        }
//    }
//    
////לארועים של המכשיר
//    //פונקציה זו מקבלת שלושה פרמטרים
//    // whichView משתנה זה מסמל את איזה ויו צריך לצבוע באפור -
//    //ועוד שתי משתנים של הגבהים של היו שמשתנים בהתאם לדקות
//    func setDisplayViewsEvents(whichView:Bool,heightTop:CGFloat ,heightButtom:CGFloat,fromPage:Int,eventKind:Int)
//        //eventKind = 0 - ארוע אישי
//        //eventKind = 1 - ארוע של ביזר
//    {
//
//        if fromPage == 0//אם הגעתי מימן ספק שהלקוח רואה
//        {
//        
//            if whichView == true{//סימן שצריך לצבוע את הטופ
//                viewTopEvent.backgroundColor = Colors.sharedInstance.color6
//                viewBottomEvent.backgroundColor = UIColor.clearColor()
//                
//                if heightViewTopEvent != nil{
//                    self.removeConstraint(heightViewTopEvent!)
//                    
//                }
//                heightViewTopEvent = NSLayoutConstraint(item: viewTopEvent, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: heightTop, constant: 0)
//                self.addConstraint(heightViewTopEvent!)
//                if hightViewButtomEvent != nil{
//                    self.removeConstraint(hightViewButtomEvent!)
//                    
//                }
//                hightViewButtomEvent = NSLayoutConstraint(item: viewBottomEvent, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: heightButtom, constant:0)
//                self.addConstraint(hightViewButtomEvent!)
//                viewTopEvent.alpha = 0.6
//            }
//            else{
//                viewBottomEvent.backgroundColor = Colors.sharedInstance.color6
//                viewTopEvent.backgroundColor = UIColor.clearColor()
//                
//                if heightViewTopEvent != nil{
//                    self.removeConstraint(heightViewTopEvent!)
//                    
//                }
//                heightViewTopEvent = NSLayoutConstraint(item: viewTopEvent, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: heightTop, constant: 0)
//                self.addConstraint(heightViewTopEvent!)
//                
//                if hightViewButtomEvent != nil{
//                    self.removeConstraint(hightViewButtomEvent!)
//                }
//                
//                hightViewButtomEvent = NSLayoutConstraint(item: viewBottomEvent, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: heightButtom, constant: 0)
//                self.addConstraint(hightViewButtomEvent!)
//                viewBottomEvent.alpha = 0.6
//            }
//        }
//        else//הגעתי מיומן לקוח
//        {
//            if eventKind == 0//ארוע אישי
//            {
//                lblHoursTop.font = UIFont (name: "OpenSansHebrew-Light", size: 17)
//                lblDescTop.font = UIFont (name: "OpenSansHebrew-Light", size: 17)
//                lblHoursBottom.font = UIFont (name: "OpenSansHebrew-Light", size: 17)
//                lblDescBottom.font = UIFont (name: "OpenSansHebrew-Light", size: 17)
//            }
//            else if eventKind == 1//ארוע של ביזר
//            {
//                lblHoursTop.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
//                lblDescTop.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
//                lblHoursBottom.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
//                lblDescBottom.font = UIFont (name: "OpenSansHebrew-Bold", size: 17)
//            }
//
//            
//            
//        }
//    }
    
    @IBOutlet var btnOPenOrderOutlet: UIButton!
    @IBAction func btnOpenOrder(_ sender: UIButton) {


        delegateClickOnDay.enterOnDay(7 - sender.tag)

     }
    //show device by flag
}
extension CALayer {
    
    func addBorderx(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}
