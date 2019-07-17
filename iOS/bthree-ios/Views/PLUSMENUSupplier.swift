//
//  PLUSMENUSupplier.swift-> replaces  MenuPlusSupplierViewController Implementing more clear and elegant Collectionview to avoid 80 views....
//  Bthere
//
//  Created by Ioan Ungureanu on 12.06.2017 /d/m/y
//  Copyright © 2017 Bthere. All rights reserved.
//
/*
 PLUSMENUSupplier
 1. New appointment
 2. New event
 3. Customers in an hour
 4. Block hours
 5. Waiting list
 6. Last minute
 7. Help
 NEW_APP_PLUSMENU = "New appointment";
 NEW_EVENT_PLUSMENU = "New event";
 CUSTOMERS_IN_A_HOUR_PLUSMENU = "Customers in a hour";
 BLOCK_HOURS_PLUSMENU = "Block hours";
 WAITING_LIST_PLUSMENU = "Waiting list";
 LAST_MINUTE_PLUSMENU = "Last minute";
 HELP_PLUSMENU = "Help";
 */
import UIKit

class PLUSMENUSupplier: NavigationModelViewController, UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout  {
    var delegate:openFromMenuDelegate! = nil
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    @IBOutlet weak var titlescreen:UILabel!
    @IBOutlet weak var ttil:UICollectionView! //our items
    @IBOutlet weak var containerttil:UIView!
    @IBOutlet weak var btncancel:UIButton!
    var itemuri:[String] = []
    var generic:Generic = Generic()
    var subView:UIView = UIView()
    var storyBoard:UIStoryboard?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsSendEvent(x:30)
        //old
//        self.itemuri = [
//            "NEW_APP_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE),
//            "NEW_EVENT_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE),
//            "CUSTOMERS_IN_A_HOUR_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE),
//            "BLOCK_HOURS_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE),
//            "CANCEL_BLOCK_HOURES".localized(LanguageMain.sharedInstance.USERLANGUAGE),
//            "WAITING_LIST_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE),
//            "LAST_MINUTE_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE),
//            "HELP_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE),
//            "SEND_NOTIFICATION_TO_ALL_CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),
//            "LIVE_CHAT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        ]
        self.itemuri = [
            "NEW_APP_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "NEW_EVENT_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "WAITING_LIST_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "BLOCK_HOURS_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "CANCEL_BLOCK_HOURES".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "SEND_NOTIFICATION_TO_ALL_CUSTOMERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "LIVE_CHAT".localized(LanguageMain.sharedInstance.USERLANGUAGE),
            "HELP_PLUSMENU".localized(LanguageMain.sharedInstance.USERLANGUAGE)
            ]
        
        self.ttil.delegate = self
        self.ttil.dataSource = self
        self.ttil.layer.shadowColor = UIColor.black.cgColor
        self.ttil.layer.shadowOpacity = 0.4
        self.ttil.layer.shadowOffset = CGSize.zero
        self.ttil.layer.shadowRadius = 1.5
    }
    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.itemuri.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        //Aligning right to left on UICollectionView
        
        
        let cell:PlusSettingssupplier = collectionView.dequeueReusableCell(withReuseIdentifier: "PlusSettingssupplier",for: indexPath) as! PlusSettingssupplier
        let i:Int = indexPath.row
        cell.rowDIfferent = i
            cell.setDisplayDatax(self.itemuri[i])
        cell.backgroundColor = UIColor.clear
        
        //old
//        if indexPath.row % 2 == 0 {
//            if indexPath.row == 2 ||  indexPath.row == 6 {
//                cell.rectangleVIEW.backgroundColor = Colors.sharedInstance.color6
//            } else {
//                cell.rectangleVIEW.backgroundColor = Colors.sharedInstance.color3
//            }
//        } else {
//                cell.rectangleVIEW.backgroundColor = Colors.sharedInstance.color4
//        }
        
        if indexPath.row % 2 == 0
        {
            cell.rectangleVIEW.backgroundColor = Colors.sharedInstance.color3
        }
        else
        {
            cell.rectangleVIEW.backgroundColor = Colors.sharedInstance.color4
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex indexPath: IndexPath?) -> Int {
//
//        return 0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex indexPath: IndexPath?) -> Int {
//
//        return 0
//    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    //    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0,left: 0,bottom: 0,right: 0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt
        indexPath: IndexPath) {
        let i:Int = indexPath.row
        //   var selectedCell:UICollectionViewCell = self.ttil.cellForItemAtIndexPath(indexPath)!
        // selectedCell.contentView.backgroundColor = UIColor(red: 102/256, green: 255/256, blue: 255/256, alpha: 0.66)
        
        print("my item \(i)")
        self.goToScreens(i + 1)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, UIEdgeInsets indexPath: IndexPath) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 0,bottom: 0,right: 0);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalHeight: CGFloat = (self.view.frame.width / 3)
        let totalWidth: CGFloat = (self.view.frame.width / 3)
        print("mod")
        
        return CGSize(width: totalWidth, height: totalHeight)
    }
    //old
//    func goToScreens(_ screen:Int) {
//        switch screen {
//        case 1:
//            // ramane 1
//            imageTappedNewAppointment()
//            break
//        case 2:
//            //ramane 2
//            imageTappedUpdateTurn()
//            break
//
//        case 3:
//            // vine 6
//            //   imageTappedNumCustomers()
//            break
//
//        case 4:
//            //ramane 4
//            imageTappedBlockHours()
//            break
//
//        case 5:
//            //ramane 5
//            imageTappedcancelBlock()
//            break
//
//        case 6:
//            //vine 9
//            imageTappedListWait()
//            break
//
////
////        case 7:
//            //vine 10
////        imageTappedLastMinute()
////
////            break
//
//        case 8:
//            //ramane 8
//            imageTappedViewHelp()
//            break
//        case 9:
//            opensendmassnotification()
//        case 10:
//            openlivechat()
//        default:
//            //nothing
//            break
//        }
//
//    }
    
    func goToScreens(_ screen:Int) {
        switch screen {
        case 1:
            imageTappedNewAppointment()
            break
        case 2:
            imageTappedUpdateTurn()
            break
            
        case 3:
            imageTappedListWait()
            break
            
        case 4:
            imageTappedBlockHours()
            break
            
        case 5:
            imageTappedcancelBlock()
            break
            
        case 6:
            opensendmassnotification()
            break
            
            
        case 7:
            openlivechat()
            break
            
        case 8:
            imageTappedViewHelp()
            break
            
        default:
            //nothing
            break
        }
        
    }

    @objc func openlivechat(){
        let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let helpLiveChatViewController:HelpLiveChatViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "HelpLiveChatViewController") as! HelpLiveChatViewController
        helpLiveChatViewController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        
        if self.iOS8 {
            helpLiveChatViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        } else {
            helpLiveChatViewController.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        
        self.present(helpLiveChatViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyBoard = UIStoryboard(name:"SupplierExist", bundle: nil)
        //    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-pic-supplier@x1.jpg")!)
        // self.titlescreen.text = "Settings".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addShaddow(_ view:UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 1.5
    }
    
    
    @objc func opensendmassnotification(){
        let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
        let navigationController:UINavigationController = UINavigationController()
        let viewCon:SendMassNotification = mainstoryb.instantiateViewController(withIdentifier: "SendMassNotification") as! SendMassNotification
        navigationController.viewControllers = [viewCon]
        self.dismiss(animated: false, completion: { () -> Void in
            self.delegate.openFromMenu(navigationController)
            
        })
    }
    @objc func imageTappedViewHelp()  {
        let navigationController:UINavigationController = UINavigationController()
        let clientStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let viewCon:NewHelpViewController = clientStoryBoard.instantiateViewController(withIdentifier: "NewHelpViewController") as! NewHelpViewController
        
        navigationController.viewControllers = [viewCon]
        self.dismiss(animated: false, completion: { () -> Void in
            self.delegate.openFromMenu(navigationController)
            
        })
        
        //
        
        //        let viewCon:NewHelpViewController = clientStoryBoard?.instantiateViewControllerWithIdentifier("NewHelpViewController") as! NewHelpViewController
        //        viewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
        //        self.dismissViewControllerAnimated(true, completion: nil)
        //        delegate.openFromMenu(viewCon)
        //
    }
    
    @objc func imageTappedNewAppointment()  {
          self.dismiss(animated: false, completion: { () -> Void in
        Global.sharedInstance.whichReveal = true
        let frontviewcontroller:UINavigationController? = UINavigationController()
        let storyBoard:UIStoryboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let viewCon = storyBoard.instantiateViewController(withIdentifier: "MyCostumersViewController") as!  MyCostumersViewController
        Global.sharedInstance.isProvider = true
        frontviewcontroller!.pushViewController(viewCon, animated: false)
        //initialize REAR View Controller- it is the LEFT hand menu.
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        let mainRevealController = SWRevealViewController()
        mainRevealController.frontViewController = frontviewcontroller
        mainRevealController.rearViewController = rearViewController
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = mainRevealController
        })
    }
    
    @objc func imageTappedLastMinute()  {
        let navigationController:UINavigationController = UINavigationController()
        let viewCon:LastMinuteViewController = self.storyboard?.instantiateViewController(withIdentifier: "LastMinuteViewController") as! LastMinuteViewController
        viewCon.delegate = Global.sharedInstance.eleventCon
        
        
        navigationController.viewControllers = [viewCon]
        self.dismiss(animated: false, completion: { () -> Void in
            self.delegate.openFromMenu(navigationController)
            
        })
    }
    
    @objc func imageTappedI()  {
        let navigationController:UINavigationController = UINavigationController()
        let viewCon:InformationViewController = self.storyboard?.instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController
        navigationController.viewControllers = [viewCon]
        self.dismiss(animated: false, completion: { () -> Void in
            self.delegate.openFromMenu(navigationController)
            
        })
    }
    
    @objc func imageTappedMessagesViewController()  {
        let navigationController:UINavigationController = UINavigationController()
        let viewCon:MessagesViewController = self.storyboard?.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
        navigationController.viewControllers = [viewCon]
        self.dismiss(animated: false, completion: { () -> Void in
            self.delegate.openFromMenu(navigationController)
            
        })
    }
    
    @objc func imageTappedNumCustomers()  {
        let navigationController:UINavigationController = UINavigationController()
        let viewCon:NumCustumersParallelViewController = self.storyboard?.instantiateViewController(withIdentifier: "NumCustumersParallelViewController") as! NumCustumersParallelViewController
        navigationController.viewControllers = [viewCon]
        self.dismiss(animated: false, completion: { () -> Void in
            self.delegate.openFromMenu(navigationController)
            
        })
    }
    
    @objc func imageTappedUpdateTurn()  {
        let mainstoryb = UIStoryboard(name: "SupplierExist", bundle: nil)
        let navigationController:UINavigationController = UINavigationController()
        let viewCon:SupplierNewEvent = mainstoryb.instantiateViewController(withIdentifier: "SupplierNewEvent") as! SupplierNewEvent
        navigationController.viewControllers = [viewCon]
        self.dismiss(animated: false, completion: { () -> Void in
            self.delegate.openFromMenu(navigationController)
            
        })
    }
    
    @objc func imageTappedcancelBlock()  {
        let mainstoryb = UIStoryboard(name: "Testing", bundle: nil)
        let viewRegulation: BlockingHoursTableViewController = mainstoryb.instantiateViewController(withIdentifier: "BlockingHoursTableViewController")as! BlockingHoursTableViewController
        viewRegulation.view.frame = CGRect(x: 0, y: -30, width:self.view.frame.size.width, height: self.view.frame.size.height)
        viewRegulation.modalPresentationStyle = .custom
       self.present(viewRegulation, animated: true, completion: nil)
    }
    @objc func imageTappedBlockHours()  {
        let navigationController:UINavigationController = UINavigationController()
        let viewCon:BlockHoursViewController = self.storyboard?.instantiateViewController(withIdentifier: "BlockHoursViewController") as! BlockHoursViewController
        navigationController.viewControllers = [viewCon]
        self.dismiss(animated: false, completion: { () -> Void in
            self.delegate.openFromMenu(navigationController)
            
        })
    }
    
    @objc func imageTappedListWait()  {
        //   let navigationController:UINavigationController = UINavigationController()
        let mainstoryb = UIStoryboard(name: "SupplierExist", bundle: nil)
        let viewRegulation: CustomerApproval = mainstoryb.instantiateViewController(withIdentifier: "CustomerApprovalID")as! CustomerApproval
        viewRegulation.view.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        viewRegulation.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(viewRegulation, animated: true, completion: nil)
        //
        //        let viewCon:WaitingListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WaitingListViewController") as! WaitingListViewController
        //        navigationController.viewControllers = [viewCon]
        //        self.dismissViewControllerAnimated(false, completion: { () -> Void in
        //            self.delegate.openFromMenu(navigationController)
        //
        //        })
    }
    
    
    
}
