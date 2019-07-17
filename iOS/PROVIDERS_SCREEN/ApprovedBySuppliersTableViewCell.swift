//
//  ApprovedBySuppliersTableViewCell.swift
//  BThere
//
//  Created by Eduard Stefanescu on 10/18/17.
//  Copyright © 2018 Bthere. All rights reserved.
//
// clean and fixed  Ungureanu Ioan 04.04.2018
import UIKit

class ApprovedBySuppliersTableViewCell: UITableViewCell,getProviderServicesForSupplierDelegate {
    @IBOutlet weak var supplierNameLabel: UILabel!
    @IBOutlet weak var supplierBannerImage: UIImageView!
    @IBOutlet weak var goToSupplier: UIButton!
    var ProviderID:Int = 0
    var ProviderServicesArray:Array<objProviderServices> =  Array<objProviderServices>()
    var allsearch:Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>()
    var bIsAproved:Int = 0
    var PARENTDELEGATE:ParentpresentViewControllerDelegate!=nil
    var index:Int = 0
    var iSupplierStatus:Int = 0
    var iIsApprovedSupplier:Int = 0
    var nvsuppliernaame:String = ""
    var arrayStarsImg:Array<UIImageView> = Array<UIImageView>()
    @IBOutlet weak var oneStarImg: UIImageView!
    @IBOutlet weak var twoStarsImg: UIImageView!
    @IBOutlet weak var threeStarsImg: UIImageView!
    @IBOutlet weak var fourStarsImg: UIImageView!
    @IBOutlet weak var fiveStarsImg: UIImageView!
    @IBOutlet weak var ratePopUpBtn: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var openBusinessProfileBtn: UIButton!
    var generic:Generic = Generic()
    @IBOutlet weak var nrReviews: UILabel!
    @IBOutlet weak var avgReviews: UILabel!
    var nvAddress:String = ""
    var businessRank:Int = 0
    @IBAction func orderAppointmentButton(_ sender: AnyObject) {
        print("ce tag \(String(describing: sender.tag))")
        if self.iSupplierStatus == 0  || self.iSupplierStatus == 2  {
            let nameprovider = supplierNameLabel.text
            let amessage = "ERROR_SUPPLIER_NOT_PAYED_ONE".localized(LanguageMain.sharedInstance.USERLANGUAGE) + nameprovider!  + "ERROR_SUPPLIER_NOT_PAYED_TWO".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            Alert.sharedInstance.showAlertDelegate(amessage)
       return
        }
        Global.sharedInstance.providerID = self.ProviderID
        self.index = sender.tag
        GetCustomerActiveOrdersBySupplier()
    }
    func continuetoscreensorpopup(_ getbIsAproved:Int) {
        if getbIsAproved == 4 || getbIsAproved == 2  {
            PARENTDELEGATE.ParentpresentViewController()
        } else {
            
            self.getProviderServicesForSupplierFunc()
        }
    }
    
    @IBAction func openBusinessProfileAction(_ sender: UIButton)
    {
            self.parentViewController?.view.endEditing(true)
            self.generic.showNativeActivityIndicator(Global.sharedInstance.entranceCustomer!)
            Global.sharedInstance.isFromSearchResults = false
            
            Global.sharedInstance.providerID = self.ProviderID
        
            var dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            
            dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­["iProviderId"] = ProviderID as AnyObject
            
            //קבלת נתונים לדף פרופיל העסק
            api.sharedInstance.GetProviderProfile(dic­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­GetProviderProfile­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                self.generic.hideNativeActivityIndicator(Global.sharedInstance.entranceCustomer!)
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    
                    if let _ =  RESPONSEOBJECT["Result"] as? Dictionary<String,AnyObject> {
                        let dic:Dictionary<String,AnyObject> =
                            RESPONSEOBJECT["Result"] as! Dictionary<String,AnyObject>
                        
                        Global.sharedInstance.providerBusinessProfile = Global.sharedInstance.providerBusinessProfile.dicToAddProviderBusinessProfile(dic)
                        if let _ = self.supplierNameLabel.text
                        {
                            Global.sharedInstance.viewCon2?.buisnessName = self.supplierNameLabel.text!
                        }
                        
                        Global.sharedInstance.viewCon2?.address = self.nvAddress
                        if let _ = self.avgReviews.text
                        {
                            Global.sharedInstance.viewCon2?.mydRankAvg = self.avgReviews.text!
                        }

                            Global.sharedInstance.viewCon2?.myiRankCount = String(self.businessRank)

                        
                        Global.sharedInstance.viewCon2!.currentProviderfromSearch = Global.sharedInstance.providerBusinessProfile.dicToAddProviderBusinessProfile(dic)
                        
                        Global.sharedInstance.viewCon2?.iSupplierStatusVC = self.iSupplierStatus
                        
                        Global.sharedInstance.entranceCustomer?.present(Global.sharedInstance.viewCon2!, animated: true, completion: nil)
                        
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
                self.generic.hideNativeActivityIndicator(Global.sharedInstance.entranceCustomer!)
            })

    }
    
    
    func GetCustomerActiveOrdersBySupplier() {       //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
        self.PARENTDELEGATE.showindicator()
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        var y:Int = 0
        if  Global.sharedInstance.currentUser.iUserId == 0 {
            if let _:NSDictionary = Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary {
                let a:NSDictionary = (Global.sharedInstance.defaults.object(forKey: "currentUserId") as? NSDictionary)!
                if let x:Int = a.value(forKey: "currentUserId") as? Int{
                    y = x
                }
            }
        } else {
            y = Global.sharedInstance.currentUser.iUserId
        }
        dicSearch["iCustomerUserId"] = y as AnyObject
        dicSearch["iSupplierId"] = self.ProviderID as AnyObject
        print("aicie \(self.ProviderID)")
        if Reachability.isConnectedToNetwork() == false
        {
             self.PARENTDELEGATE.hideindicator()
//            Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        }
        else
        {
            api.sharedInstance.GetCustomerActiveOrdersBySupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                        {
                            if  let _ = RESPONSEOBJECT["Result"] as? Int {
                                let possiblerezult = RESPONSEOBJECT["Result"] as! Int
                                self.bIsAproved = possiblerezult
                                self.PARENTDELEGATE.hideindicator()
                                self.continuetoscreensorpopup(self.bIsAproved )
                            }
                        } else {
                            //error user not found
                            self.bIsAproved = 0
                            self.PARENTDELEGATE.hideindicator()
                            self.continuetoscreensorpopup(self.bIsAproved )
                        }
                    }
                }
            },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                 self.PARENTDELEGATE.hideindicator()
                self.bIsAproved = 0
                self.continuetoscreensorpopup(self.bIsAproved)
            })
        }
    }
    
    func getProviderServicesForSupplierFunc()       //  Converted to Swift 3.x - clean by Ungureanu Ioan 12/04/2018
    {
        print("self.index \(self.index)")
        var dicSearch:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        dicSearch["iProviderId"] = self.ProviderID as AnyObject
        self.ProviderServicesArray = []
        api.sharedInstance.getProviderServicesForSupplier(dicSearch, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
            if let _ = responseObject as? Dictionary<String,AnyObject> {
                let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                    if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == -3
                    {
                        Alert.sharedInstance.showAlertDelegate("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int == 1
                    {
                        if let    _:NSArray = RESPONSEOBJECT["Result"] as? NSArray {
                            let ps:objProviderServices = objProviderServices()
                            
                            self.ProviderServicesArray = ps.objProviderServicesToArrayGet(RESPONSEOBJECT["Result"] as! Array<Dictionary<String,AnyObject>>)
                            if self.ProviderServicesArray.count == 0
                            {
                                Alert.sharedInstance.showAlertDelegate("NO_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            }
                            else
                            {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let storyboard2 = UIStoryboard(name: "ClientExist", bundle: nil)
                                Global.sharedInstance.viewCon = storyboard2.instantiateViewController(withIdentifier: "ListServicesViewController") as?
                                ListServicesViewController
                                Global.sharedInstance.viewCon!.backFromMyListServices = 1
                                let USERDEF = Global.sharedInstance.defaults
                                USERDEF.set(1,forKey: "backFromMyListServices")
                                USERDEF.synchronize()
                                Global.sharedInstance.arrayServicesKods = []
                                Global.sharedInstance.arrayServicesKodsToServer = []
                                Global.sharedInstance.viewCon!.ProviderServicesArray = self.ProviderServicesArray
                                print("self.index \(self.tag)")
                                Global.sharedInstance.viewCon!.indexRow =  self.tag
                                USERDEF.set(self.tag, forKey: "listservicesindexRow")
                                USERDEF.synchronize()
                                USERDEF.set(self.tag, forKey: "listservicesindexRow")
                                USERDEF.synchronize()
                                Global.sharedInstance.viewCon!.isfromMYPRVODIERS = true
                                Global.sharedInstance.viewCon!.backFromMyListServices = 2
                                USERDEF.set(2,forKey: "backFromMyListServices")
                                let frontviewcontroller:UINavigationController = UINavigationController()
                                frontviewcontroller.pushViewController(Global.sharedInstance.viewCon!, animated: false)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ProviderID = 0
        
        arrayStarsImg = [oneStarImg,twoStarsImg, threeStarsImg, fourStarsImg, fiveStarsImg]
    }
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func setSupplierData(_ result:SearchResulstsObj, allsearch:Array<Dictionary<String,AnyObject>>, indexRow:Int)
    {
        print("result obj: \(result.printSearchResultObject(obj: result))")
        self.allsearch = allsearch
        Global.sharedInstance.dicResults = allsearch
        supplierNameLabel.text = result.nvProviderName
        self.nvsuppliernaame = result.nvProviderName
        self.avgReviews.text = String(describing: result.dRankAvg)
        cityLabel.text = result.nvCity
        nvAddress = result.nvAdress
        businessRank = result.iRankCount
        print("result.iDistance.description: \(result.iDistance.description)")
        if (result.iDistance.description != "-1.0" && result.iDistance.description != "-1")
        {
            if let _:Float = result.iDistance as? Float
            {
                distanceLabel.text = "\(String(format: "%.1f", (result.iDistance ))) km"
            }
            else if let _:Double = result.iDistance as? Double
            {
                distanceLabel.text = "\(String(format: "%.1f", (result.iDistance as! Double))) km"
            }
            
            //commit comment
        }
        else
        {
            distanceLabel.text = "0 km"
        }
//        distanceLabel.text = String(result.iDistance)
        if result.iRankCount == 1
        {
            self.nrReviews.text = String(describing: result.iRankCount) + " " + "REVIEWS_LABEL_SINGULAR".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        else
        {
            self.nrReviews.text = String(describing: result.iRankCount) + " " + "REVIEWS_LABEL_PLURAL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        
//        self.nrReviews.text = String(describing: result.iRankCount)
        changeStars(avgRank: result.dRankAvg)
        ProviderID = result.iProviderId
        let dataDecoded:Data = Data(base64Encoded: (result.nvProviderHeader), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        var decodedimage:UIImage = UIImage()
        if (UIImage(data: dataDecoded) != nil) {
            decodedimage = UIImage(data: dataDecoded)!
            supplierBannerImage.image = decodedimage
        } else {
           // supplierBannerImage.image = UIImage(named: "IMG_05072016_131013.png") cover_pic.jpg
            supplierBannerImage.image = UIImage(named: "cover_pic.jpg")
        }
//        print("crashed \(result.iIsApprovedSupplier)")
        switch (result.iIsApprovedSupplier) {
//            100 - nu are relatie cu supplier-ul
//            0/4 - a facut o comanda catre supplier (pending request)
//            1 - a fost aprobat de supplier
//            2 - a fost respins de supplier
        case 0 :
              self.contentView.alpha = 0.6
        case 100:
              self.contentView.alpha = 1
        case 1:
              self.contentView.alpha = 1
        case 2:
              self.contentView.alpha = 0.6
        case 4:
              self.contentView.alpha = 0.6
        default:
            print("result.iIsApprovedSupplier")
        }
        
            self.iIsApprovedSupplier = result.iIsApprovedSupplier
            self.iSupplierStatus = result.iSupplierStatus
        if self.iSupplierStatus == 0 || self.iSupplierStatus == 2 {
            self.contentView.alpha = 0.6
        }
    }
    
    func setDisplayData(_ myresult:SearchResulstsObj, allsearch:Array<Dictionary<String,AnyObject>>, elindexRow:Int) {
//        print("myres \(myresult)")
        self.index = elindexRow
        self.tag = elindexRow
        setSupplierData(myresult, allsearch: allsearch, indexRow: elindexRow)
        print("self tag \(elindexRow)")
    }
    
    func changeStars(avgRank:Float)
    {
        
        let intValue:Int = Int(avgRank)
        for i in 1...arrayStarsImg.count
        {
            if i <= intValue
            {
                //full star
                arrayStarsImg[i-1].image = UIImage(named: "whiteStarEntrance.png")
            }
            else
            {
                //empty star
                arrayStarsImg[i-1].image = UIImage(named: "whiteStarEntrance2.png")
            }
          
        }
    }
    
    
    @IBAction func loadPopUpStars(_ sender: UIButton)
    {
        print("provider id: \(ProviderID) + nameSupplier: \(supplierNameLabel.text ?? "")")
        if let myViewController = parentViewController! as? UIViewController
        {
            print("title of parent view controller in approved: \(myViewController.title ?? "")")
            //            myViewController.rateBusiness(idBusiness: Global.sharedInstance.providerID, business)
            print("supplier name load pop up: \(self.nvsuppliernaame)")
            myViewController.rateBusiness(idBusiness:ProviderID, businessName:supplierNameLabel.text!)

        }

    }
    
}

