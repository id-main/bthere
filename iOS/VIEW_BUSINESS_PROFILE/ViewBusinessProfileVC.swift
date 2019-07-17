//
//  ViewBusinessProfileVC.swift
//  BThere
//
//  Created by Eduard Stefanescu on 10/3/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import UIKit
import CoreLocation
import Font_Awesome_Swift

class ViewBusinessProfileVC: NavigationModelViewController,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var dayOneLabel: UILabel!
    @IBOutlet weak var dayTwoLabel: UILabel!
    @IBOutlet weak var dayThreeLabel: UILabel!
    @IBOutlet weak var dayFourLabel: UILabel!
    @IBOutlet weak var dayFiveLabel: UILabel!
    @IBOutlet weak var daySixLabel: UILabel!
    @IBOutlet weak var daySevenLabel: UILabel!
    @IBOutlet weak var hoursOneLabel: UILabel!
    @IBOutlet weak var hoursTwoLabel: UILabel!
    @IBOutlet weak var hoursThreeLabel: UILabel!
    @IBOutlet weak var hoursFourLabel: UILabel!
    @IBOutlet weak var hoursFiveLabel: UILabel!
    @IBOutlet weak var hoursSixLabel: UILabel!
    @IBOutlet weak var hoursSevernLabel: UILabel!
    @IBOutlet weak var openOrClosedLabel: UILabel!
    @IBOutlet weak var geseata: UIImageView!
    @IBOutlet weak var expandHoursBtn: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var abouTextView: UIView!
    @IBOutlet var bannerImageView: UIView!
    @IBOutlet var saleImageView: UIView!
    @IBOutlet var businessProfilePageTitleLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var ratingScoreLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet var star1BusinessLabel: UILabel!
    @IBOutlet var star2BusinessLabel: UILabel!
    @IBOutlet var star3BusinessLabel: UILabel!
    @IBOutlet var star4BusinessLabel: UILabel!
    @IBOutlet var star5BusinessLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var reviewsListLabel: UILabel!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet var aboutBusinessTextView: UITextView!
    @IBOutlet var reviewTextView: UITextView!
    @IBOutlet var sendTextView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet var saleImage: UIImageView!
    @IBOutlet weak var rateOurBusinessButton: UIButton!
    @IBOutlet var sendReviewButton: UIButton!
    @IBOutlet var rate1StarButton: UIButton!
    @IBOutlet var rate2StarButton: UIButton!
    @IBOutlet var rate3StarButton: UIButton!
    @IBOutlet var rate4StarButton: UIButton!
    @IBOutlet var rate5StarButton: UIButton!
    @IBOutlet var loadBusinessIndicator: UIActivityIndicatorView!
    @IBOutlet var bannerImaveViewHeight: NSLayoutConstraint!
    @IBOutlet var saleImageViewHeight: NSLayoutConstraint!
    @IBOutlet var loadingBusinessActivity: UIActivityIndicatorView!
    @IBOutlet var goBackButton: UIButton!
    @IBOutlet var reteourbusinessLabel: UILabel!
    @IBOutlet var btnorder:UIButton!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var reviewsTable: UITableView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var heightAboutView: NSLayoutConstraint!
    @IBOutlet weak var aboutUsButton: UIButton!
    @IBOutlet weak var bckgroundReview: UIView!
    @IBOutlet weak var bckgroundReview2: UIView!
    @IBOutlet weak var bckgroundReview3: UIView!
    @IBOutlet weak var heightReviewView: NSLayoutConstraint!
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewsView: UIView!
    @IBOutlet weak var reviewsWrapView: UIView!
    @IBOutlet weak var hoursLabel: UILabel!
    // Variables
    var delegate2:businessProfileBackDelegate!=nil
    var businessRatingValue: Int! = 0
    var businessReviewValue: String! = ""
    var DayFlagArr:Array<Int> = [0,0,0,0,0,0,0]
    var hourShow:String = ""
    var currentProviderfromSearch:AddProviderBusinessProfile = AddProviderBusinessProfile()
    var buisnessName = ""
    var mydRankAvg = ""
    var myiRankCount = ""
    var address = ""
    var delegate:getProviderServicesForSupplierDelegate!=nil
    var stantardHeight:CGFloat = 1420
    var arrWorkingHours:Array<Array<objWorkingHours>> = [Array<objWorkingHours>(),Array<objWorkingHours>(),Array<objWorkingHours>(),Array<objWorkingHours>(),Array<objWorkingHours>(),Array<objWorkingHours>(),Array<objWorkingHours>()]
    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
    var indexRow:Int = 0
    var generic:Generic = Generic()
    var starsarray:Array<Bool> = [false, false, false, false, false]
    var reviewsArray:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
    var userDidReview:Int = 0
    var arrayDaysNames:Array<UILabel> = Array<UILabel>()
    var arrayHoursIntervals:Array<UILabel> = Array<UILabel>()
    var dictionaryIndexes:Dictionary<Int,Int> = Dictionary<Int,Int>()
    var backDelegate:reloadFromBackBusiness?
    var iSupplierStatusVC:Int = -1
    override func viewDidLayoutSubviews()
    {
    }
    
    func bettercode() {
        var arrayStars:Array<UILabel> = Array<UILabel>()
        arrayStars.append(star1BusinessLabel)
        arrayStars.append(star2BusinessLabel)
        arrayStars.append(star3BusinessLabel)
        arrayStars.append(star4BusinessLabel)
        arrayStars.append(star5BusinessLabel)
        
        for item in arrayStars {
            let indexofitem = arrayStars.index(of: item)
            if starsarray[indexofitem!] == false {
                item.setFAText("",icon: FAType.faStarO, postfixText: "", size: 8)
            } else {
                item.setFAText("",icon: FAType.faStar, postfixText: "", size: 8)
            }
        }
    }
    
    @IBAction func toExpandOrNotToExpand(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            heightConstraint.constant = 190
            openOrClosedLabel.isHidden = true
            geseata.isHidden = true
            sender.tag = 1
        }
        else if sender.tag == 1
        {
            heightConstraint.constant = 40
            openOrClosedLabel.isHidden = false
            geseata.isHidden = false
            sender.tag = 0
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
        {
            reteourbusinessLabel.textAlignment = .right
        }
        else
        {
            reteourbusinessLabel.textAlignment = .left
        }
        reviewsTable.register(UINib(nibName: "businessProfileSeparatorCell", bundle: nil), forCellReuseIdentifier: "separatorBusinessProfile")
        reviewsTable.separatorStyle = .none
        heightConstraint.constant = 40
        openOrClosedLabel.isHidden = false
        geseata.isHidden = false
        expandHoursBtn.tag = 0
        bckgroundReview.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        bckgroundReview2.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        bckgroundReview3.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        reviewsView.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        reviewsTable.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        reviewsWrapView.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        loadBusinessIndicator.startAnimating()
        loadBusinessIndicator.hidesWhenStopped = true
        actionsView.layer.borderWidth = 2
        actionsView.layer.borderColor = UIColor.gray.cgColor
        self.reviewTextView.delegate = self
        aboutUsButton.tag = 0
        heightAboutView.constant = 75
        if Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            var scalingTransform : CGAffineTransform!
            scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
            goBackButton.transform = scalingTransform
            backImg.transform = scalingTransform
            self.reviewTextView.textAlignment = .right
        }
        businessProfilePageTitleLabel.text = "BUSINESS_PROPHIL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        aboutLabel.text  = "ABOUT_US".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnorder.setTitle("ORDER_APPOINTMENT".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        sendReviewButton.setTitle("SEND_BT".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        reteourbusinessLabel.text = "RATE_OUR_BUSINESS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        reviewsListLabel.text = "REVIEWS_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        //HARDCODED
        reviewsLabel.text = "999 " + "REVIEWS_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        //OPINION
        
        
        print("text rate 5 button in view did load \(String(describing: rate5StarButton.title(for: UIControl.State())))")
        
        //     print("global search view did load \( Global.sharedInstance.dicResults)")
        
        rate1StarButton.setFATitleColor(UIColor(red:1.00, green:0.50, blue:0.00, alpha:1.0))
        rate2StarButton.setFATitleColor(UIColor(red:1.00, green:0.50, blue:0.00, alpha:1.0))
        rate3StarButton.setFATitleColor(UIColor(red:1.00, green:0.50, blue:0.00, alpha:1.0))
        rate4StarButton.setFATitleColor(UIColor(red:1.00, green:0.50, blue:0.00, alpha:1.0))
        rate5StarButton.setFATitleColor(UIColor(red:1.00, green:0.50, blue:0.00, alpha:1.0))
        reviewsTable.rowHeight = UITableView.automaticDimension
        reviewsTable.estimatedRowHeight = 40
        btnorder.isHidden = true;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    @IBAction func aboutUsBtnAction(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            heightAboutView.constant = 220
            sender.tag = 1
        }
        else if sender.tag == 1
        {
            heightAboutView.constant = 75
            sender.tag = 0
        }
    }

    
    func processreviewsArray(_ arr:Array<Dictionary<String, AnyObject>>) {
        self.reviewsArray = arr
        DispatchQueue.main.async {
            self.reviewsTable.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
        super.viewDidAppear(animated)
        print("cache user \(String(describing: Global.sharedInstance.defaults.value(forKey: "currentUserId")))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        print("did disappear")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:40)
        reviewTextView.text = ""
        rate1StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: UIControl.State.normal)
        rate2StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: UIControl.State.normal)
        rate3StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: UIControl.State.normal)
        rate4StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: UIControl.State.normal)
        rate5StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: UIControl.State.normal)
        businessRatingValue = 0
        rate1StarButton.setFATitleColor(UIColor(red:1.00, green:0.50, blue:0.00, alpha:1.0))
        rate2StarButton.setFATitleColor(UIColor(red:1.00, green:0.50, blue:0.00, alpha:1.0))
        rate3StarButton.setFATitleColor(UIColor(red:1.00, green:0.50, blue:0.00, alpha:1.0))
        rate4StarButton.setFATitleColor(UIColor(red:1.00, green:0.50, blue:0.00, alpha:1.0))
        rate5StarButton.setFATitleColor(UIColor(red:1.00, green:0.50, blue:0.00, alpha:1.0))
        
        
        let workingHours:objWorkingHours = objWorkingHours()
        arrWorkingHours = workingHours.sortHoursArrayByDays(currentProviderfromSearch.ProviderWorkingHoursObj)
        
        
        print("/////////////////////////////")
        for i:objWorkingHours in currentProviderfromSearch.ProviderWorkingHoursObj
        {
            print(i.getDic())
        }
        print("/////////////////////////////")
        
        print("curreny day ius: \(String(describing: Calendar.sharedInstance.getDayOfWeek(Date())))")
        arrayDaysNames = [dayOneLabel,dayTwoLabel,dayThreeLabel,dayFourLabel,dayFiveLabel,daySixLabel,daySevenLabel]
        arrayHoursIntervals = [hoursOneLabel,hoursTwoLabel,hoursThreeLabel,hoursFourLabel,hoursFiveLabel,hoursSixLabel,hoursSevernLabel]
        var days:Array<String> = ["SUNDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"MONDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"TUESDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"WEDNSDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"THIRTHDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"FRIDAY_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SHABAT_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
        hoursLabel.text = "HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        var workingHoursDay:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        for i in 0...6
        {
            if let _ = Calendar.sharedInstance.getDayOfWeek(Date())
            {
                var index:Int = Calendar.sharedInstance.getDayOfWeek(Date())! - 1 + i
                if index > 6
                {
                    index -= 7
                }
                arrayDaysNames[i].text = days[index]
            }
            arrayHoursIntervals[i].text = "CLOSED_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            if let _ = Calendar.sharedInstance.getDayOfWeek(Date())
            {
                var realKey:Int = Calendar.sharedInstance.getDayOfWeek(Date())! + i
                if realKey > 7
                {
                    realKey -= 7
                }
                dictionaryIndexes[realKey] = i
            }
            print("dictionaryIndexes: \(dictionaryIndexes)")
            
            
        }
        
        //        currentProviderfromSearch.ProviderWorkingHoursObj
        
        for i in 0..<currentProviderfromSearch.ProviderWorkingHoursObj.count
        {
            workingHoursDay = currentProviderfromSearch.ProviderWorkingHoursObj[i].getDic()
            if let _ = workingHoursDay["iDayInWeekType"] as? Int
            {
                let indexWrkObj:Int = workingHoursDay["iDayInWeekType"] as! Int
                if let _ = workingHoursDay["nvFromHour"] as? String
                {
                    if let _ = workingHoursDay["nvToHour"] as? String
                    {
                        let fromHour = workingHoursDay["nvFromHour"] as! String
                        let toHour = workingHoursDay["nvToHour"] as! String
                        let endIndex = fromHour.index(fromHour.endIndex, offsetBy: -3)
//                        let newStr = str.substring(to: index) // Swift 3
//                        let newStr = String(str[..<index]) // Swift 4
                        let truncatedFromHour = String(fromHour[..<endIndex])
                        let truncatedToHour = String(toHour[..<endIndex])
                        
                        let indexForHour = dictionaryIndexes[indexWrkObj]
                        print("index array ore: \(String(describing: dictionaryIndexes[indexWrkObj]))")
                        print("index zile ale saptamanii: \(indexWrkObj)")
                        if let _ = indexForHour
                        {
                            if arrayHoursIntervals[indexForHour!].text == "" || arrayHoursIntervals[indexForHour!].text == "CLOSED_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                            {
                                arrayHoursIntervals[indexForHour!].text = truncatedFromHour + "-" + truncatedToHour
                                //                                print("ziua: \(arrayDaysNames[i])")
                                //                                print("ora: \(String(describing: arrayHoursIntervals[indexForHour!].text ))")
                            }
                            else
                            {
                                if let _ = arrayHoursIntervals[indexForHour!].text
                                {
                                    let firstInterval:String = (arrayHoursIntervals[indexForHour!].text as! String)
                                    if  Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0
                                    {
                                        arrayHoursIntervals[indexForHour!].text =  truncatedFromHour + "-" + truncatedToHour + " ," + firstInterval
                                    }
                                    else
                                    {
                                        arrayHoursIntervals[indexForHour!].text = firstInterval + ", " + truncatedFromHour + "-" + truncatedToHour
                                    }
                                    print("ora: \(String(describing: arrayHoursIntervals[indexForHour!].text ))")
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
            }
        }
        if arrayHoursIntervals[0].text == "CLOSED_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        {
            openOrClosedLabel.text = "CLOSED_TODAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        else
        {
            openOrClosedLabel.text = "OPEN_TODAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        heightConstraint.constant = 40
        openOrClosedLabel.isHidden = false
        geseata.isHidden = false
        expandHoursBtn.tag = 0
        heightAboutView.constant = 75
        aboutUsButton.tag = 0
        myviews()
        
    }
    
    
    func myviews() {
        // Console
        print ("c\(currentProviderfromSearch)")
        
        if Reachability.isConnectedToNetwork() == false
        {
            
            //            showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            var dicGetReview:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            DispatchQueue.main.async
                {
                    if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
                    {
                        var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                        if dicUserId["currentUserId"] as! Int != 0
                        {
                            dicGetReview["iProviderUserId"] = self.currentProviderfromSearch.iProviderUserId as AnyObject
                            
                            api.sharedInstance.getReviewsByProviderID(dicGetReview, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                                
                                print("response get reviews \(String(describing: responseObject))")
                                if let _ = responseObject as? Dictionary<String,AnyObject> {
                                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 {
                                            
                                            //  Alert.sharedInstance.showAlert("אירעה תקלה בשמירת הפרטים",vc: self)
                                        }
                                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -4
                                        {
                                            let myresponsearray:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
                                            self.processreviewsArray(myresponsearray)
                                            
                                        }
                                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                                        {
                                            if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                                let myresponsearray = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                                self.processreviewsArray(myresponsearray)
                                                
                                            }
                                        }
                                    }
                                }
                                
                            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            })
                            
                        }
                    }
            }
        }
        
        
        
        // Logo image
        if !(currentProviderfromSearch.nvILogoImage == "" || currentProviderfromSearch.nvILogoImage == "<null>" ) {
            let dataDecoded:Data = Data(base64Encoded: (currentProviderfromSearch.nvILogoImage), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
            var decodedimage:UIImage = UIImage()
            
            if UIImage(data: dataDecoded) != nil {
                decodedimage = UIImage(data: dataDecoded)!
                UIGraphicsBeginImageContext(logoImage.frame.size)
                decodedimage.draw(in: logoImage.bounds)
                let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                logoImage.image = image
            }
        }else {
            logoImage.image = UIImage(named: "clients@x1.png")
        }
        
        // 2. Banner photo
        if !(currentProviderfromSearch.nvHeaderImage == "" || currentProviderfromSearch.nvHeaderImage == "<null>") {
            
            let dataDecoded:Data = Data(base64Encoded: (
                currentProviderfromSearch.nvHeaderImage), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
            var decodedimage:UIImage = UIImage()
            
            if UIImage(data: dataDecoded) != nil {
                decodedimage = UIImage(data: dataDecoded)!
                // bannerImage.contentMode = .ScaleAspectFit
                bannerImage.image = decodedimage
                print("Business Profile Page banner image loaded")
            }
        } else {
            //   bannerImage.image = UIImage(named: "IMG_05072016_131013.png") cover_pic.jpg
            bannerImage.image = UIImage(named: "cover_pic.jpg")
            print("Business Profile Page banner image not loaded")
        }
        
        // Sale image
        if !(currentProviderfromSearch.nvCampaignImage == "" || currentProviderfromSearch.nvCampaignImage == "<null>") {
            
            let dataDecoded:Data = Data(base64Encoded: (
                currentProviderfromSearch.nvCampaignImage), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
            var decodedimage:UIImage = UIImage()
            
            if UIImage(data: dataDecoded) != nil {
                decodedimage = UIImage(data: dataDecoded)!
                // saleImage.contentMode = .ScaleAspectFit
                saleImage.image = decodedimage
                print("Business Profile Page sale image loaded")
            }
        } else {
            // saleImage.image = UIImage(named: "IMG_05072016_131013.png")
            print("Business Profile Page sale image not loaded")
            saleImage.image = nil
        }
        
        
        //rate
        // Set default values
        print("currentProviderfromSearch did load \(currentProviderfromSearch)")
        print("dot rank avg \(mydRankAvg)")
        
        if let _ = mydRankAvg.doubleValue
        {
            ratingScoreLabel.text = mydRankAvg.doubleValue?.description
        }
        
        if myiRankCount.integerValue == 1
        {
            reviewsLabel.text = String(myiRankCount) + " " + "REVIEW_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
            
        else
        {
            reviewsLabel.text = String(myiRankCount) + " " + "REVIEWS_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            
        }
        
        
        // Business info
        companyNameLabel.text = buisnessName
        sloganLabel.text = currentProviderfromSearch.nvSlogen
        aboutBusinessTextView.text = currentProviderfromSearch.nvAboutComment
        addressLabel.text = "\("ADDRESS_CITY".localized(LanguageMain.sharedInstance.USERLANGUAGE))\(address) / \(currentProviderfromSearch.nvCity)"
        

        
        // Round corners
        abouTextView.layer.cornerRadius = 8
        sendTextView.layer.cornerRadius = 8
        sendReviewButton.layer.cornerRadius = 8


        self.calculateStars()
        self.reviewsTable.reloadData()
        
        
        self.loadBusinessIndicator.stopAnimating()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // Go back home
    @IBAction func goBackButton(_ sender: AnyObject)
    {
        if  Global.sharedInstance.isFromSearchResults == true
        {
            self.dismiss(animated: true, completion:
                {
                    self.delegate2.reloadSearch(didReview: self.userDidReview)
                    self.userDidReview = 0
                    
            })
        }
        else if Global.sharedInstance.isFromEntranceOrProviders == 1
        {
            self.dismiss(animated: true, completion:
                {
                    self.backDelegate?.getProvidersList()
                    
            })
            
        }
        else
        {
            self.dismiss(animated: true, completion:nil)
        }

    }
    
    
    // Rate our business
    @IBAction func rateOurBusinessButton(_ sender: AnyObject)
    {
        
    }
    
    
    // Open location
    @IBAction func locationButton(_ sender: AnyObject) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            // UIApplication.sharedApplication().openURL(NSURL(string: "comgooglemaps://?saddr=&daddr=\(place.latitude),\(place.longitude)&directionsmode=driving")!)
        }
        else
        {
            // Redirec to get Google Maps app
            UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id585027354")!, options: [:], completionHandler: nil)
      //      UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/us/app/id585027354")!)
        }
    }
    
    
    // Open Waze app
    @IBAction func wazeButton(_ sender: AnyObject) {
        let wazeAPP:String = "waze://"
        let wazeURL = URL(string: wazeAPP)
        let strinAddress = "\(address),\(currentProviderfromSearch.nvCity)"
        
        
        
        //let wazeLocation = (strinAddress as NSString).stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        
        
        
        
        
        
        
        //        var allowedQueryParamAndKey =  NSCharacterSet(charactersInString: ";/?:@&=+$, ").invertedSet
        //        wazeHook.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)
        
        
        
        // let wazeTestURL = NSURL(string: wazeHook)
        
        if UIApplication.shared.canOpenURL(wazeURL!) {
            let wazeHook:String = "\(strinAddress)"
            let allowedQueryParamAndKey =  CharacterSet(charactersIn: ";/?:@&=+$, ").inverted
            let cleanstring:String =  wazeHook.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)!
            
            print("This is waze: \(cleanstring)")
            if cleanstring.count > 0 {
                  UIApplication.shared.open(URL(string: "waze://?q=" + cleanstring)!, options: [:], completionHandler: nil)
             //   UIApplication.shared.openURL(URL(string: "waze://?q=" + cleanstring)!)
            } else {
                Alert.sharedInstance.showAlert("BUSINESS_PROFILE_ALERT_NO_LOCATION".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            }
        } else {
            // Redirec to get Wazess
          //  UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/us/app/id323229106")!)
            UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id323229106")!, options: [:], completionHandler: nil)
        }
        
    }
    
    
    // Call
    @IBAction func callButton(_ sender: AnyObject) {
        if let url = URL(string: "tel://\(currentProviderfromSearch.nvPhone)"), UIApplication.shared.canOpenURL(url) {
           // UIApplication.shared.openURL(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            
        }
    }
    
    
    // Open website
    // Open website
    @IBAction func websiteButton(_ sender: AnyObject) {
        if (currentProviderfromSearch.nvSiteAddress != "" && currentProviderfromSearch.nvSiteAddress != " " && currentProviderfromSearch.nvSiteAddress != "<null>") {
            var businessWebsite = URL(string: currentProviderfromSearch.nvSiteAddress)
            //    print("business url before \(businessWebsite)")
            var businessWebsiteString = businessWebsite?.absoluteString
            
            if !((businessWebsiteString?.lowercased().hasPrefix("http://"))! || (businessWebsiteString?.lowercased().hasPrefix("https://"))!)
            {
                businessWebsiteString! = "http://" + businessWebsiteString!
                businessWebsite = URL(string: businessWebsiteString!)
            }
            //            print("business url after \(businessWebsite)")
            if UIApplication.shared.canOpenURL(businessWebsite!) {
             //   UIApplication.shared.openURL(businessWebsite!)
                UIApplication.shared.open(businessWebsite!, options: [:], completionHandler: nil)
            } else {
                Alert.sharedInstance.showAlert("BUSINESS_PROFILE_ALERT_CRASH_WEBISTE".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
            }
        } else {
            Alert.sharedInstance.showAlert("BUSINESS_PROFILE_ALERT_NO_WEBISTE".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc:self)
        }
    }
    
    // Open calendar
    @IBAction func calendarButton(_ sender: AnyObject) {
        
    }
    
    
    // Rate 1 star
    @IBAction func rate1StarButton(_ sender: AnyObject) {
        rate1StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate2StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: .normal)
        rate3StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: .normal)
        rate4StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: .normal)
        rate5StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: .normal)
        
        businessRatingValue = 1
    }
    
    
    // Rate 2 stars
    @IBAction func rate2StarsButton(_ sender: AnyObject) {
        rate1StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate2StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate3StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: .normal)
        rate4StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: .normal)
        rate5StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: .normal)
        
        businessRatingValue = 2
    }
    
    
    // Rate 3 stars
    @IBAction func rate3StarsButton(_ sender: AnyObject) {
        rate1StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate2StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate3StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate4StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: .normal)
        rate5StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: .normal)
        
        businessRatingValue = 3
    }
    
    
    // Rate 4 stars
    @IBAction func rate4StarsButton(_ sender: AnyObject) {
        rate1StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate2StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate3StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate4StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate5StarButton.setFAText("", icon: FAType.faStarO, postfixText: "", size: 26, forState: .normal)
        
        businessRatingValue = 4
    }
    
    
    // Rate 5 stars
    @IBAction func rate5StarsButton(_ sender: AnyObject) {
        rate1StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate2StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate3StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate4StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        rate5StarButton.setFAText("", icon: FAType.faStar, postfixText: "", size: 26, forState: .normal)
        
        businessRatingValue = 5
    }
    
    
    // Send business review
    @IBAction func sendBusinessreview(_ sender: AnyObject) {
        
        //        NotificationCenter.default.post(name: Notification.Name.UIKeyboardWillHide, object: nil)
        //        view.endEditing(true)
        
        if self.iSupplierStatusVC == 0 || self.iSupplierStatusVC == 2  {
            if let nameprovider = self.companyNameLabel.text
            {
                let amessage = "NO_REVIEW_INACTIVE_BUSINESS1".localized(LanguageMain.sharedInstance.USERLANGUAGE) + nameprovider  + "NO_REVIEW_INACTIVE_BUSINESS2".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                Alert.sharedInstance.showAlertDelegate(amessage)
            }

        }
        else
        {
            businessReviewValue = reviewTextView.text
            
            var myProviderId:Int = 0
            var notMyProviderId:Int = 0
            
            if Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails != 0
            {
                //mine
                myProviderId =  Global.sharedInstance.currentProviderDetailsObj.providerBuisnessDetailsObj.iIdBuisnessDetails
            }
            if Global.sharedInstance.providerID != 0
            {
                //not mine
                notMyProviderId = Global.sharedInstance.providerID
            }
            print("my provider iddd \(myProviderId)")
            print("not my provider iddd \(notMyProviderId)")
            
            
            if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
            {
                var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                var dicSendToServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                if dicUserId["currentUserId"] as! Int != 0
                {
                    self.generic.showNativeActivityIndicator(self)
                    var dicID:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                    dicSendToServer["iCustomerUserId"] = dicID["currentUserId"]
                    dicSendToServer["iProviderUserId"] = currentProviderfromSearch.iProviderUserId as AnyObject
                    
                    api.sharedInstance.CheckCustomerReviewedProvider(dicSendToServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        //                    self.generic.hideNativeActivityIndicator(self)
                        print("response send review \(String(describing: responseObject))")
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 {
                                    self.generic.hideNativeActivityIndicator(self)
                                    //  Alert.sharedInstance.showAlert("אירעה תקלה בשמירת הפרטים",vc: self)
                                } else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                                {
                                    self.generic.hideNativeActivityIndicator(self)
                                    ///////////////////////
                                    
                                    if let _ = RESPONSEOBJECT["Result"] as? Int
                                    {
                                        if RESPONSEOBJECT["Result"] as! Int == 1
                                        {
                                            if Global.sharedInstance.defaults.integer(forKey: "isemploye") == 1
                                            {
                                                self.generic.hideNativeActivityIndicator(self)
                                                
                                                if Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil
                                                {
                                                    self.generic.hideNativeActivityIndicator(self)
                                                    self.GetSupplierIdByEmployeeId(notMyProviderId, true)
                                                }
                                                else
                                                {
                                                    self.generic.hideNativeActivityIndicator(self)
                                                    self.updateReview()
                                                }
                                                
                                            }
                                            else
                                            {
                                                self.generic.hideNativeActivityIndicator(self)
                                                self.updateReview()
                                            }
                                            
                                            
                                            
                                            
                                        }
                                            
                                        else if notMyProviderId == 0
                                        {
                                            //not a valid business
                                            self.generic.hideNativeActivityIndicator(self)
                                            //                                            NotificationCenter.default.post(name: Notification.Name.UIKeyboardWillHide, object: nil)
                                            Alert.sharedInstance.showAlertDelegate("NOT_A_VALID_SUPPLIER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                        }
                                        else if myProviderId == notMyProviderId
                                        {
                                            self.generic.hideNativeActivityIndicator(self)
                                            //                                       NotificationCenter.default.post(name: Notification.Name.UIKeyboardWillHide, object: nil)
                                            Alert.sharedInstance.showAlertDelegate("REVIEW_YOURSELF_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                            // you can't review your own business
                                        }
                                        else if Global.sharedInstance.defaults.integer(forKey: "ismanager") == 0
                                        {
                                            self.generic.hideNativeActivityIndicator(self)
                                            
                                            if Global.sharedInstance.defaults.value(forKey: "supplierNameRegistered") != nil
                                            {
                                                self.GetSupplierIdByEmployeeId(notMyProviderId, false)
                                            }
                                            else
                                            {
                                                self.sendRatingAfterValidation()
                                            }
                                            
                                            
                                            
                                        }
                                        else
                                        {
                                            //e bine
                                            self.generic.hideNativeActivityIndicator(self)
                                            self.sendRatingAfterValidation()
                                        }
                                    }
                                    
                                    
                                }
                            }
                        }
                        
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                        //                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    })
                    
                }
            }
            
            
        }

        

    }
    
    
    func sendRatingAfterValidation()
    {
        self.generic.hideNativeActivityIndicator(self)
        if (self.businessRatingValue == 0) {
            let alertController = UIAlertController(title: "No_Rating".localized(LanguageMain.sharedInstance.USERLANGUAGE), message:
                "Please_rate_the_business".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.view.endEditing(true)
            print("Send review to server")
            self.generic.showNativeActivityIndicator(self)
            var dicSendReviewToServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            if Reachability.isConnectedToNetwork() == false
            {
                self.generic.hideNativeActivityIndicator(self)
                //                                                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            else
            {
                if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
                {
                    var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                    if dicUserId["currentUserId"] as! Int != 0
                    {
                        self.generic.showNativeActivityIndicator(self)
                        dicSendReviewToServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                        dicSendReviewToServer["reviewText"] = self.businessReviewValue as AnyObject
                        dicSendReviewToServer["rateStars"] = self.businessRatingValue as AnyObject
                        dicSendReviewToServer["iProviderUserId"] = self.currentProviderfromSearch.iProviderUserId as AnyObject
                        
                        api.sharedInstance.sendRatingForBusiness(dicSendReviewToServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
                            print("response send review \(String(describing: responseObject))")
                            if let _ = responseObject as? Dictionary<String,AnyObject> {
                                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 {
                                        self.generic.hideNativeActivityIndicator(self)
                                        //  Alert.sharedInstance.showAlert("אירעה תקלה בשמירת הפרטים",vc: self)
                                    } else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                                    {
                                        self.generic.hideNativeActivityIndicator(self)
                                        //                                                                            Alert.sharedInstance.showAlert("SENT_REVIEW_SUCCESS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                                        let alertController = UIAlertController(title: "SENT_REVIEW_SUCCESS".localized(LanguageMain.sharedInstance.USERLANGUAGE), message:
                                            "", preferredStyle: UIAlertController.Style.alert)
                                        alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                                        })
                                        self.userDidReview = 1
                                        self.present(alertController, animated: true, completion: nil)
                                        self.getProviderDetailsAgain()
                                        //reload that damn table
                                        if Reachability.isConnectedToNetwork() == false
                                        {
                                            
                                            //                                                                                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                        }
                                        else
                                        {
                                            var dicGetReview:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                            //   DispatchQueue.global(qos: .background).async
                                            DispatchQueue.main.async
                                                {
                                                    if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
                                                    {
                                                        var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                                                        if dicUserId["currentUserId"] as! Int != 0
                                                        {
                                                            dicGetReview["iProviderUserId"] = self.currentProviderfromSearch.iProviderUserId as AnyObject
                                                            
                                                            api.sharedInstance.getReviewsByProviderID(dicGetReview, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                                                                
                                                                print("response get reviews \(String(describing: responseObject))")
                                                                if let _ = responseObject as? Dictionary<String,AnyObject> {
                                                                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                                                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                                                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 {
                                                                            
                                                                            //  Alert.sharedInstance.showAlert("אירעה תקלה בשמירת הפרטים",vc: self)
                                                                        }
                                                                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -4
                                                                        {
                                                                            let myresponsearray:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
                                                                            self.processreviewsArray(myresponsearray)
                                                                            
                                                                        }
                                                                        else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                                                                        {
                                                                            if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                                                                let myresponsearray = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                                                                self.processreviewsArray(myresponsearray)
                                                                                
                                                                            }
                                                                            //
                                                                            
                                                                        }
                                                                    }
                                                                }
                                                                
                                                            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                                                                
                                                                //                                                                                                    self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                                            })
                                                            
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                }
                            }
                            
                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
                            self.generic.hideNativeActivityIndicator(self)
                            //                                                                self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        })
                        
                    }
                }
            }
        }
    }
    
    func GetSupplierIdByEmployeeId(_ notMyProviderID:Int, _ forUpdate:Bool) {
        self.generic.showNativeActivityIndicator(self)
        //        Global.sharedInstance.whichReveal = true
        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {
            var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
            if dicUserId["currentUserId"] as! Int != 0
            {
                var dicForServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                dicForServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                api.sharedInstance.GetSupplierIdByEmployeeId(dicForServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                    if let _ = responseObject as? Dictionary<String,AnyObject> {
                        let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                        
                        if let _:Int = RESPONSEOBJECT["Result"] as? Int
                        {
                            let myInt :Int = (RESPONSEOBJECT["Result"] as? Int)!
                            print("sup id e ok ? " + myInt.description)
                            if myInt == 0
                            {
                                self.showAlertDelegateX("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                
                            }
                            else
                            {
                                if notMyProviderID == myInt
                                {
                                    Alert.sharedInstance.showAlertDelegate("REVIEW_YOURSELF_ALERT".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                }
                                else
                                {
                                    if forUpdate
                                    {
                                        self.updateReview()
                                    }
                                    else
                                    {
                                        self.sendRatingAfterValidation()
                                    }

                                }
                            }
                        }
                    }
                    
                    self.generic.hideNativeActivityIndicator(self)
                },failure: {(AFHTTPRequestOperation, Error) -> Void in
                    self.generic.hideNativeActivityIndicator(self)
                })
            }
        }
    }
    
    
    func updateReview()
    {
        
        //                                        NotificationCenter.default.post(name: Notification.Name.UIKeyboardWillHide, object: nil)
        if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
        {
            if (self.businessRatingValue == 0) {
                let alertController = UIAlertController(title: "No_Rating".localized(LanguageMain.sharedInstance.USERLANGUAGE), message:
                    "Please_rate_the_business".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
                
            else
            {
                var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                var dicSendReviewToServer:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                if dicUserId["currentUserId"] as! Int != 0
                {
                    //                                                self.disableBtns()
                    self.generic.showNativeActivityIndicator(self)
                    dicSendReviewToServer["iUserId"] = dicUserId["currentUserId"] as! Int as AnyObject
                    dicSendReviewToServer["reviewText"] = self.businessReviewValue as AnyObject
                    dicSendReviewToServer["rateStars"] = self.businessRatingValue as AnyObject
                    dicSendReviewToServer["iProviderUserId"] = self.currentProviderfromSearch.iProviderUserId as AnyObject
                    
                    api.sharedInstance.updateRatingForBusiness(dicSendReviewToServer, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                        //                                                    self.enableBtns()
                        print("response send review \(String(describing: responseObject))")
                        if let _ = responseObject as? Dictionary<String,AnyObject> {
                            let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                            if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 {
                                    print("nu e bine")
                                    self.generic.hideNativeActivityIndicator(self)
                                    //  Alert.sharedInstance.showAlert("אירעה תקלה בשמירת הפרטים",vc: self)
                                } else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                                {
                                    //                                                                        Alert.sharedInstance.showAlertDelegate("SENT_REVIEW_SUCCESS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                    self.generic.hideNativeActivityIndicator(self)
                                    let alertController = UIAlertController(title: "SENT_REVIEW_SUCCESS".localized(LanguageMain.sharedInstance.USERLANGUAGE), message:
                                        "", preferredStyle: UIAlertController.Style.alert)
                                    alertController.addAction(UIAlertAction(title: "OK".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                                        //                                                                    self.removeFromSuperview()
                                    })
                                    self.userDidReview = 1
                                    self.present(alertController, animated: true, completion: nil)
                                    self.getProviderDetailsAgain()
                                    
                                    ////reload that damn table
                                    if Reachability.isConnectedToNetwork() == false
                                    {
                                        
                                        //                                                                        self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                    }
                                    else
                                    {
                                        var dicGetReview:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
                                        //   DispatchQueue.global(qos: .background).async
                                        DispatchQueue.main.async
                                            {
                                                if Global.sharedInstance.defaults.value(forKey: "currentUserId") != nil
                                                {
                                                    var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
                                                    if dicUserId["currentUserId"] as! Int != 0
                                                    {
                                                        dicGetReview["iProviderUserId"] = self.currentProviderfromSearch.iProviderUserId as AnyObject
                                                        
                                                        api.sharedInstance.getReviewsByProviderID(dicGetReview, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                                                            
                                                            print("response get reviews \(String(describing: responseObject))")
                                                            if let _ = responseObject as? Dictionary<String,AnyObject> {
                                                                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                                                                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                                                                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 {
                                                                        
                                                                        //  Alert.sharedInstance.showAlert("אירעה תקלה בשמירת הפרטים",vc: self)
                                                                    }
                                                                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -4
                                                                    {
                                                                        let myresponsearray:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
                                                                        self.processreviewsArray(myresponsearray)
                                                                        
                                                                    }
                                                                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                                                                    {
                                                                        if let _ = RESPONSEOBJECT["Result"] as? Array<Dictionary<String,AnyObject>> {
                                                                            let myresponsearray = RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>
                                                                            self.processreviewsArray(myresponsearray)
                                                                            
                                                                        }
                                                                        //
                                                                        
                                                                    }
                                                                }
                                                            }
                                                            
                                                        },failure: {(AFHTTPRequestOperation, Error) -> Void in
                                                            
                                                            //                                                                                            self.showAlertDelegateX("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                                        })
                                                        
                                                    }
                                                }
                                        }
                                    }

                                }
                            }
                        }
                        
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
                        self.generic.hideNativeActivityIndicator(self)
                    })
                }
            }
        }
        
        
    }
    
    // Order appointment
    @IBAction func orderAppointmentButton(_ sender: AnyObject) {
        Global.sharedInstance.providerID = currentProviderfromSearch.iProviderUserId
        
        getProviderServicesForSupplierFunc()
    }
    func getProviderServicesForSupplierFunc()
    {
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = Global.sharedInstance.providerID as AnyObject
        
        api.sharedInstance.getProviderServicesForSupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                        self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        
                        
                        if let _  :NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                            let ps:objProviderServices = objProviderServices()
                            
                            self.ProviderServicesArray = ps.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            if self.ProviderServicesArray.count == 0
                            {
                                self.showAlertDelegateX("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                            else
                            {
                                Global.sharedInstance.viewCon!.ProviderServicesArray = self.ProviderServicesArray
                                Global.sharedInstance.viewCon!.indexRow = self.indexRow
                                let USERDEF = Global.sharedInstance.defaults
                                USERDEF.set(self.indexRow, forKey: "listservicesindexRow")
                                USERDEF.synchronize()
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let frontviewcontroller:UINavigationController = UINavigationController()
                                frontviewcontroller.pushViewController(Global.sharedInstance.viewCon!, animated: false)
                                
                                //initialize REAR View Controller- it is the LEFT hand menu.
                                
                                let rearViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                                
                                let mainRevealController = SWRevealViewController()
                                
                                mainRevealController.frontViewController = frontviewcontroller
                                mainRevealController.rearViewController = rearViewController
                                
                                let window :UIWindow = UIApplication.shared.keyWindow!
                                window.rootViewController = mainRevealController
                                
                            }
                        }
                    }
                }
                
            }
        },failure: {(AFHTTPRequestOperation, Error) -> Void in
            
        })
        
    }
    
    
    func convertDays(_ day:Int) -> String {
        switch day {
        case 0:
            return "SUNDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 1:
            return "MONDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 2:
            return "TUESDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 3:
            return "WEDNSDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 4:
            return "THIRTHDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 5:
            return "FRIDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        case 6:
            return "SHABAT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        default:
            return "SUNDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
    }
    
    
    func cutHour(_ hour:String) -> String {
        var fixedHour = String(hour.dropLast())
        fixedHour = String(fixedHour.dropLast())
        fixedHour = String(fixedHour.dropLast())
        return fixedHour
    }
    
    
    func navigateToLatitude(toLatitude latitude: Double, longitude: Double) {
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            // Waze is installed. Launch Waze and start navigation
            let urlStr = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
            if #available(iOS 10, *) {
                
                UIApplication.shared.open(URL(string: urlStr)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: {
                    (success) in
                    print("succes open settings")
                })
            } else {
                let wazeUrl = URL(string: urlStr)
                UIApplication.shared.openURL(wazeUrl!)
            }
        } else {
            // Waze is not installed. Launch AppStore to install Waze app
            if #available(iOS 10, *) {
                
                UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id323229106")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: {
                    (success) in
                    print("succes open settings")
                })
            } else {
                let MYitunesURL = URL(string: "http://itunes.apple.com/us/app/id323229106")
                UIApplication.shared.openURL(MYitunesURL!)
            }
        }
    }
    
    
    func getProviderDetailsAgain()
    {
        var dicToSend:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var dicUserId:Dictionary<String,AnyObject> = Global.sharedInstance.defaults.value(forKey: "currentUserId") as! Dictionary<String,AnyObject>
        if dicUserId["currentUserId"] as! Int != 0
        {
            //                                                self.disableBtns()
            self.generic.showNativeActivityIndicator(self)
            
            dicToSend["iProviderUserId"] = self.currentProviderfromSearch.iProviderUserId as AnyObject
            api.sharedInstance.GetRatingForBusiness(dicToSend, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                //                                                    self.enableBtns()
                print("response send review \(String(describing: responseObject))")
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -1 {
                            print("nu e bine")
                            self.generic.hideNativeActivityIndicator(self)
                            //  Alert.sharedInstance.showAlert("אירעה תקלה בשמירת הפרטים",vc: self)
                        } else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            
                            self.generic.hideNativeActivityIndicator(self)
                            print("raspuns aici\(RESPONSEOBJECT["Result"]!)")
                            
                            if let _ = RESPONSEOBJECT["Result"]!["dRankAvg"] as? Float
                            {
                                let dRank = RESPONSEOBJECT["Result"]!["dRankAvg"] as! Float
                                print("valoare rank: \(self.mydRankAvg)")
                                print("valoare label rank:\(String(describing: self.ratingScoreLabel.text))")
                                self.ratingScoreLabel.text = String(dRank)
                                self.mydRankAvg = self.ratingScoreLabel.text!
                                
                            }
                            else if let _ = RESPONSEOBJECT["Result"]!["dRankAvg"] as? Double
                            {
                                let dRank = RESPONSEOBJECT["Result"]!["dRankAvg"] as! Double
                                print("valoare rank: \(self.mydRankAvg)")
                                print("valoare label rank:\(String(describing: self.ratingScoreLabel.text))")
                                self.ratingScoreLabel.text = String(dRank)
                                self.mydRankAvg = self.ratingScoreLabel.text!
                            }
                            
                            if let _ = RESPONSEOBJECT["Result"]!["iRankCount"] as? Int
                            {
                                let myiRankCount = RESPONSEOBJECT["Result"]!["iRankCount"] as! Int
                                if myiRankCount == 1
                                {
                                    self.reviewsLabel.text = String(myiRankCount) + " " + "REVIEW_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                }
                                    
                                else
                                {
                                    self.reviewsLabel.text = String(myiRankCount) + " " + "REVIEWS_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                                }
                                
                                
                            }
                            self.calculateStars()
                        }
                    }
                }
                
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(self)
                
                
            })
            
        }
    }
    
    
    func calculateStars()
    {
        if let floatRank = mydRankAvg.floatValue
        {
            
            print("float value \(floatRank)")
            if floatRank == 0
            {
                star1BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
                star2BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
                star3BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
                star4BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
                star5BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
            }
            else if floatRank > 0 && floatRank < 1.6
            {
                star1BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star2BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
                star3BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
                star4BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
                star5BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
            }
            else if floatRank >= 1.6 && floatRank < 2.6
            {
                star1BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star2BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star3BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
                star4BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
                star5BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
            }
            else if floatRank >= 2.6 && floatRank < 3.6
            {
                star1BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star2BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star3BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star4BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
                star5BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
            }
            else if floatRank >= 3.6 && floatRank < 4.6
            {
                star1BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star2BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star3BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star4BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star5BusinessLabel.setFAText("", icon: FAType.faStarO, postfixText: "", size: 17)
            }
            else
            {
                star1BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star2BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star3BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star4BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
                star5BusinessLabel.setFAText("", icon: FAType.faStar, postfixText: "", size: 17)
            }
            
        }
        
        
        
        
    }
    
    
    class func viewFromNibName(_ name: String) -> UIView? {
        let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        return views!.first as? UIView
    }
    
    //    "dtCreateDate": "/Date(1536318745540+0300)/",
    //    "dtLastModifyDate": null,
    //    "iCustomerUserId": 25420,
    //    "iRank": 1,
    //    "iSupplierId": 1005,
    //    "iSupplierReviewId": 3,
    //    "iSysRowStatus": 1,
    //    "nvComment": "Not good.",
    //    "nvCustomerName": "Alpha Android"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "businessReviewCell",
                                                     for: indexPath) as! businessProfileReviewsCell
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            cell.reportView.backgroundColor = Colors.sharedInstance.color4
            if let _:Dictionary<String,AnyObject> = reviewsArray[indexPath.row / 2] as Dictionary<String,AnyObject>?
            {
                let myDic = reviewsArray[indexPath.row / 2]
                print("myDic review: \(myDic)")
                if let _ = myDic["nvCustomerName"] as? String
                {
                    cell.usernameReview.text = myDic["nvCustomerName"] as? String
                    cell.usernameReview.font =  UIFont.boldSystemFont(ofSize: 18.0)
                    cell.usernameReview.textColor = Colors.sharedInstance.color3
                }

                if let _ = myDic["nvComment"] as? String
                {
                    cell.textReview.text = myDic["nvComment"] as? String
                }
                else
                {
                    cell.textReview.text = ""
                }
            }

            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "separatorBusinessProfile", for: indexPath) as! businessProfileSeparatorCell
            cell.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row % 2 == 1
        {
            return 20
        }
        else
        {
            tableView.estimatedRowHeight = 40
            return UITableView.automaticDimension
            
        }
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
        
    {
        return reviewsArray.count * 2
        //        return 1
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if textView.text.count > 160 {
//            textView.resignFirstResponder()
    Alert.sharedInstance.showAlertDelegate("ENTER_ONLY160_CHARACTERS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            let result = String(textView.text.dropLast((textView.text.count - 160)))
            textView.text = result
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.count > 160
        {
            let result = String(textView.text.dropLast((textView.text.count - 160)))
            textView.text = result
        }
        
    }
    
    
    
    @IBAction func instagramAction(_ sender: UIButton)
    {
        let instagramLink:String = currentProviderfromSearch.nvInstagramLink
        let snippet = instagramLink
        
        if let range = snippet.range(of: ".com/")
        {
            let profileName = snippet[range.upperBound...]
            if let urlInstagram:URL = URL.init(string: ("instagram://user?username=" + profileName))
            {
                if UIApplication.shared.canOpenURL(urlInstagram)
                {
                    UIApplication.shared.open(urlInstagram, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary(["asdad":"Asdasd"]), completionHandler: nil)
                }
                else
                {
                    if let urlForBrowserInstagram:URL = URL.init(string: instagramLink)
                    {
                        if UIApplication.shared.canOpenURL(urlForBrowserInstagram)
                        {
                            UIApplication.shared.open(urlForBrowserInstagram, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary(["asdad":"Asdasd"]), completionHandler: nil)
                        }
                        else
                        {
                            print("ghinion1")
                            Alert.sharedInstance.showAlertDelegate("THIS_BUSSINESS_NO_INSTAGRAM".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        }
                    }
                    
                }
            }
            else
            {
                Alert.sharedInstance.showAlertDelegate("THIS_BUSSINESS_NO_INSTAGRAM".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                print("ghinion2")
            }
        }
        else
        {
            if let urlInstagram:URL = URL.init(string: instagramLink)
            {
                if UIApplication.shared.canOpenURL(urlInstagram)
                {
                    UIApplication.shared.open(urlInstagram, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary(["asdad":"Asdasd"]), completionHandler: nil)
                }
                else
                {
                    Alert.sharedInstance.showAlertDelegate("THIS_BUSSINESS_NO_INSTAGRAM".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    print("ghinion3")
                }
            }
            else
            {
                Alert.sharedInstance.showAlertDelegate("THIS_BUSSINESS_NO_INSTAGRAM".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            }
            
            
        }
    }
    
    @IBAction func facebookAction(_ sender: UIButton)
    {
        let facebookLink:String = currentProviderfromSearch.nvFacebookLink
        if let urlFacebook:URL = URL.init(string: facebookLink)
        {
            if UIApplication.shared.canOpenURL(urlFacebook)
            {
                UIApplication.shared.open(urlFacebook, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary(["asdad":"Asdasd"]), completionHandler: nil)
            }
            else
            {
                Alert.sharedInstance.showAlertDelegate("THIS_BUSINESS_NO_FACEBOOK".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                print("ghinion")
            }
        }
        else
        {
            Alert.sharedInstance.showAlertDelegate("THIS_BUSINESS_NO_FACEBOOK".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        
        
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
