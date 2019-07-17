//
//  JGeneralDetails.swift
//  BThere
//
//  Created by BThere on 12/4/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import Foundation
import UIKit
protocol reloadTblDelegateParent {
    func reloadTbl()
    func showerroemessageforselectall()
    func showerroemessageforaddbreaks()
    func OPENBREAKS()
    func OPENHOURS()
    func showerroemessagenodays()
    func showerroemessageincorrectbreaks()
    func presentVC(_ MYALERT:UIAlertController)
    func openAddNewWorker()
    func reloadWorkingandBreaksLabels()
    
}
class JGeneralDetails: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource,reloadTblDelegateParent {
    @IBOutlet weak var titlescreen: UILabel!
    @IBOutlet weak var MAINTABLE:UITableView!
    @IBOutlet weak var closebutton: UIButton!
    // Variables
    var originalMAINTABLEorigin: CGFloat = 0.0
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    let heightiphone:CGFloat = 45.0
    let heightipad:CGFloat = 60.0
    var isscrolled:Bool = false //screen was scrolled to previous choosen domain
    var hashoursselected:Bool = true // were bussiness hours selected ?
    var hasfreehoursselected:Bool = true // were bussiness free hours selected ?
    var expandedcells: Array<Bool> = [false, false, false, false, false] //represents main header cells for section state
    var headersCell:Array<String> =
        ["DOMAIN".localized(LanguageMain.sharedInstance.USERLANGUAGE),"HOURS_ACTIVITY".localized(LanguageMain.sharedInstance.USERLANGUAGE),"ADD_WORKERS".localized(LanguageMain.sharedInstance.USERLANGUAGE),"SERVICE_PRODUCT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"TURN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var isOPENBUSINESSHOUR:Bool = true //WORKING HOURS by default
    var isOPENBUSINESSBREAKS:Bool = false //
    var isValidMaxServiceForCustomer:Bool = false
    var isValidPeriodInWeeksForMaxServices:Bool = false
    var iFirstCalendarViewType:Int = 0
    @IBAction func closebutton(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.MAINTABLE.delegate = self
        self.MAINTABLE.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
       
        
    }
    override func viewWillLayoutSubviews() {
        let USERDEF = UserDefaults.standard
        if USERDEF.integer(forKey: "RELOADAFTERSERVICEADD") == 1{
            USERDEF.set(0, forKey: "RELOADAFTERSERVICEADD")
            USERDEF.synchronize()
            self.reloadTbl()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        originalMAINTABLEorigin = self.MAINTABLE.frame.origin.y
        NotificationCenter.default.addObserver(self, selector: #selector(JGeneralDetails.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JGeneralDetails.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        rereadalldetails()
        reloadTbl()
        
    }
    func reloadWorkingandBreaksLabels() {
        LISTALLWORKINGHOURSFORSERVER()
        let indexPath = IndexPath(item: 1, section: 1)
        MAINTABLE.reloadRows(at: [indexPath], with: .none)
        let indexPath2 = IndexPath(item: 2, section: 1)
        MAINTABLE.reloadRows(at: [indexPath2], with: .none)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if MAINTABLE.frame.origin.y == originalMAINTABLEorigin{
                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                if deviceIdiom != .pad {
                    self.MAINTABLE.frame.origin.y -= keyboardSize.height
              
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if MAINTABLE.frame.origin.y != originalMAINTABLEorigin {
                self.MAINTABLE.frame.origin.y = originalMAINTABLEorigin
            }
        }
    }
   
//    func adjustingHeight(show:Bool, notification:NSNotification) {
//        switch (show) {
//        case true:
//                var frame = self.MAINTABLE.frame
//                UIView.beginAnimations(nil, context: nil)
//                UIView.setAnimationBeginsFromCurrentState(true)
//                UIView.setAnimationDuration(0.3)
//                 if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//                let keyboardFrame:CGRect = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
//                frame.size.height -= keyboardFrame.height
//                self.MAINTABLE.frame = frame
//                let bottomview = self.MAINTABLE
//                let rect = self.MAINTABLE.convertRect(bottomview.bounds, fromView: bottomview)
//                self.MAINTABLE.scrollRectToVisible(rect, animated: false)
//                UIView.commitAnimations()
//            }
//            
//        
//        case false :
//            var frame = self.MAINTABLE.frame
//            UIView.beginAnimations(nil, context: nil)
//            UIView.setAnimationBeginsFromCurrentState(true)
//            UIView.setAnimationDuration(0.3)
//             if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//            let keyboardFrame:CGRect = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
//            let keyBoardSize = keyboardFrame
//            if keyBoardSize.height != 0
//            {
//                frame.size.height += keyBoardSize.height 
//            }
//            else{
//                frame.size.height += 216 - 110
//            }
//            self.MAINTABLE.frame = frame
//            UIView.commitAnimations()
//            }
//        
//        
//        default:
//            print("no")
//        }
//    }
    func openAddNewWorker() {
        //open popup for new worker edit details
    }
    func presentVC(_ MYALERT:UIAlertController) {
        self.present(MYALERT, animated: true, completion: nil)
    }
    @objc func OPENBREAKS() {
        isOPENBUSINESSHOUR = false
        isOPENBUSINESSBREAKS = true
        reloadTbl()
    }
    func OPENHOURS() {
        isOPENBUSINESSHOUR = true
        isOPENBUSINESSBREAKS = false
        reloadTbl()
    }
    func showerroemessageforselectall() {
        showAlertDelegateX("CANT_SELECT_ALL_DAYS_BEFORE_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
    }
    func showerroemessageforaddbreaks() {
        showAlertDelegateX("SELECT_HOURS_FOR_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE))
    }
    func showerroemessagenodays() {
        showAlertDelegateX("NO_DAY_SELECTED".localized(LanguageMain.sharedInstance.USERLANGUAGE))
    }
    func showerroemessageincorrectbreaks() {
        self.view.makeToast(message:  "INCORRECT_BREAKS".localized(LanguageMain.sharedInstance.USERLANGUAGE), duration: 3.0, position: HRToastPositionCenter as AnyObject)
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.hidetoast()
        })
    }
        func hidetoast(){
        view.hideToastActivity()
    }
    func reloadTbl() {
        LISTALLWORKINGHOURSFORSERVER()
        if Global.sharedInstance.generalDetails.arrObjServiceProviders.count == 0 {
            expandedcells[2] = false
            isscrolled = false
        }
        if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0 {
            expandedcells[3] = false
            isscrolled = false
        }
        
        self.MAINTABLE.reloadData()
    }
        @objc func refreshtable(){
        self.MAINTABLE.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        var y = 0
        switch(x) {
        ////////////    DOMAIN BUSINESS SECTION      ////////////
        case 0:
            if expandedcells[x] == true {
                //return 1 + all categ
                y = 1 + AppDelegate.arrDomains.count
            } else {
                y = 1
            }
            ////////////  END OF DOMAIN BUSINESS SECTION      ////////////
        ////////////    BUSINESS HOURS SECTION            ////////////
        case 1:
            return 4
            ////////////   END OF BUSINESS HOURS SECTION       ////////////
        ////////////    WORKERS SECTION      ///////////
        case 2:
            y = 1
            if expandedcells[x] == true {
                y = 1
                if Global.sharedInstance.generalDetails.arrObjServiceProviders.count > 0 {
                    y = Global.sharedInstance.generalDetails.arrObjServiceProviders.count + 2 //first is row 0 last is add employee row
                }
            } else {
                y = 1
            }
            ////////////  END OF WORKERS  SECTION      ////////////
            ////////////    SERVICES SECTION      ///////////
        case 3:
            y = 1
            if expandedcells[x] == true {
                y = 1
                if Global.sharedInstance.generalDetails.arrObjProviderServices.count > 0 {
                    y = Global.sharedInstance.generalDetails.arrObjProviderServices.count + 2 //first is row 0 last is add service row
                }
            } else {
                y = 1
            }
            ////////////  END OF SERVICES  SECTION      ////////////
            ////////////    CALENDAR SECTION      ///////////
        case 4:
            y = 1
            if expandedcells[x] == true {
                y = 2
            } else {
                y = 1
            }
             ////////////  END OF CALENDAR  SECTION      ////////////
        default:
            y = 0
        }
        return y
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var y:CGFloat = 0
        let x = indexPath.section
        let z = indexPath.row
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch(x) {
        ////////////    DOMAIN BUSINESS SECTION      ///////////
        case 0:
            if deviceIdiom != .pad {
                y = heightiphone
            } else {
                y = heightipad
            }
            ////////////  END OF DOMAIN BUSINESS SECTION      ////////////
        ////////////    BUSINESS HOURS SECTION            ////////////
        case 1:
            //  row 0 header cell
            if z == 0 {
             
                    y = heightiphone
           
            }
            //  bussiness hours label row
            if z == 1 {
                if Global.sharedInstance.hourShow.characters.count > 0 {
                    var font = UIFont()
                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                    let Mystr = showSelectedHoursAndDays()
                    if deviceIdiom != .pad {
                        font = UIFont(name: "OpenSansHebrew-Bold", size: 15)!
                        let calculateheight = heightForView(Mystr, font: font, width: tableView.frame.size.width - 30)
                        y =  calculateheight + 25  //25
                        
                    } else {
                        font = UIFont(name: "OpenSansHebrew-Bold", size: 17)!
                        let calculateheight = heightForView(Mystr, font: font, width: tableView.frame.size.width - 70)
                        y =  calculateheight + 15  //25
                    }
                    
                } else {
                    y = 0
                }
            }
            
            // free hours label row
            if z == 2 {
                if Global.sharedInstance.hourShowRecess.characters.count > 0 {
                    var font = UIFont()
                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                    let Mystr = showSelectedHoursAndDays()
                    if deviceIdiom != .pad {
                        font = UIFont(name: "OpenSansHebrew-Bold", size: 15)!
                        let calculateheight = heightForView(Mystr, font: font, width: tableView.frame.size.width - 30)
                        y =  calculateheight + 25  //25
                        
                    } else {
                        font = UIFont(name: "OpenSansHebrew-Bold", size: 17)!
                        let calculateheight = heightForView(Mystr, font: font, width: tableView.frame.size.width - 70)
                        y =  calculateheight + 15  //25
                    }
                } else {
                    
                    y = 0
                }
            }
            
            //  select hours row
            //business hours has extra add breaks button
            if  z == 3 {
                if isOPENBUSINESSHOUR == true {
                    if expandedcells[x] == true  {
                        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                        if deviceIdiom == .pad {
                            y = self.view.frame.size.height * 0.6
                        } else {
                            y = 435
                        }
                    } else {
                        y = 0
                    }
                }else {
                    //breaks has less height because of hidden add breaks
                    if expandedcells[x] == true  {
                        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                        if deviceIdiom == .pad {
                            y = self.view.frame.size.height * 0.56
                        } else {
                            y = 410
                        }
                    } else {
                        y = 0
                    }
                    
                }
            }
            
            ////////////   END OF BUSINESS HOURS SECTION       ////////////
        ////////////    WORKERS SERVICES  SECTION      ///////////
        case 2,  3 :
            //row 0 header cell
            if deviceIdiom != .pad {
                y = heightiphone
            } else {
                y = heightipad
            }
            
        ////////////  END OF WORKERS SERVICES  SECTION      ////////////
            ////////////    CALENDAR SECTION      ///////////
        case 4 :
            if z == 0 {
            if deviceIdiom != .pad {
                y = heightiphone
            } else {
                y = heightipad
            }
            } else {
                y = 215
            }
         ////////////  END OF CALENDAR  SECTION      ////////////
        default:
            y = 0
        }
        
        return y
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //  let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)
        let x = indexPath.section
        let y = indexPath.row
        ////////////    DOMAIN BUSINESS SECTION      ////////////
        if x == 0 {
            let cell:DomainTableViewCell =  domaincell(x, row:y)
            return cell
        }
        ////////////  END OF DOMAIN BUSINESS SECTION      ////////////
        ////////////    BUSINESS HOURS SECTION            ////////////
        if x == 1 {
            let cell:DomainTableViewCell = domaincell(x, row:y)
            let cell1:HoursBusinessTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HoursBusinessTableViewCell")as!HoursBusinessTableViewCell
            let cell2:BreaksBusinessTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BreaksBusinessTableViewCell")as!BreaksBusinessTableViewCell
            
            cell1.DELEGATERELOAD = self
            cell2.DELEGATERELOAD = self
            if y < 3 {
                return cell
            }
            if y == 3 && expandedcells[x] == true {
                if isOPENBUSINESSHOUR == true {
                    return cell1
                } else {
                    
                    return cell2
                }
            }
        }
        ////////////   END OF BUSINESS HOURS SECTION       ////////////
        ////////////    WORKERS SECTION      ///////////
        if x == 2 {
            let cell:DomainTableViewCell = domaincell(x, row:y)
            let cell1:JoWorkerInListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "JoWorkerInListTableViewCell")as! JoWorkerInListTableViewCell
            let cell2:AddNewWorkerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddNewWorkerTableViewCell")as! AddNewWorkerTableViewCell
            if y == 0 {
                return cell
            }
            var howmany:Int = 0
            if Global.sharedInstance.generalDetails.arrObjServiceProviders.count > 0 {
                howmany = Global.sharedInstance.generalDetails.arrObjServiceProviders.count + 2 //first is row 0 last is add employee row
            }
            if (y > 0 && y < howmany - 1) {
                cell1.selectionStyle = UITableViewCell.SelectionStyle.none
                cell1.tag = y
                cell1.DELEGATERELOAD = self
                let Fname = Global.sharedInstance.generalDetails.arrObjServiceProviders[y - 1].objsers.nvFirstName
                let Lname =  Global.sharedInstance.generalDetails.arrObjServiceProviders[y - 1].objsers.nvLastName
                let name = "\(Fname) \(Lname)"
                cell1.setDisplayData(name)
                return cell1
            }
            else if
                y == howmany - 1  { //last row
                cell2.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell2
            }
        }
        
        ////////////  END OF WORKERS  SECTION      ////////////
        ////////////    SERVICES SECTION      ///////////
          if x == 3 {
            let cell:DomainTableViewCell = domaincell(x, row:y)
            let cell1:JoServiceInListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "JoServiceInListTableViewCell")as! JoServiceInListTableViewCell
            let cell2:JoAddNewServiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "JoAddNewServiceTableViewCell")as! JoAddNewServiceTableViewCell
            if y == 0 {
                return cell
            }
            var howmany:Int = 0
            if Global.sharedInstance.generalDetails.arrObjProviderServices.count > 0 {
                howmany = Global.sharedInstance.generalDetails.arrObjProviderServices.count + 2 //first is row 0 last is add service row
            }
            if (y > 0 && y < howmany - 1) {
                cell1.selectionStyle = UITableViewCell.SelectionStyle.none
                cell1.tag = y
                cell1.DELEGATERELOAD = self
                cell1.setDispalyData(Global.sharedInstance.generalDetails.arrObjProviderServices[y - 1].nvServiceName, indexRow: y - 1)
                return cell1
            }
            else if
                y == howmany - 1  { //last row
                cell2.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell2
            }
           

        }
          ////////////  END OF SERVICES  SECTION      ////////////
        ////////////    CALENDAR SECTION      ///////////
        if x == 4 {
            let cell:DomainTableViewCell = domaincell(x, row:y)
            let cell1:JoCalendarSettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "JoCalendarSettingsTableViewCell")as! JoCalendarSettingsTableViewCell
       
            if y == 0 {
                return cell
            }
            else {
            cell1.selectionStyle = UITableViewCell.SelectionStyle.none
            cell1.PARENTDELEGATE = self
            return cell1
            }
        }
        ////////////  END OF CALENDAR  SECTION      ////////////
       
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        
        let x = indexPath.section
        
        let y = indexPath.row
        ////////////    DOMAIN BUSINESS SECTION      ////////////
        if x == 0 {
            if expandedcells[x] == true {
                expandedcells = [false, false, false, false, false]
                isscrolled = false
            } else {
                expandedcells = [false, false, false, false, false]
                expandedcells[x] = true
                isscrolled = false
            }
            refreshtable()
            if y > 0 {
                if  AppDelegate.arrDomains.count > 0 {
                    //safe
                    if let _:Domain =  AppDelegate.arrDomains[y - 1] {
                        let mybusinessdomain =  AppDelegate.arrDomains[y - 1]
                        Global.sharedInstance.domainBuisness =  mybusinessdomain.nvCategoryName
                    }
                }
            } else {
                if  expandedcells[x] == true {
                    if  AppDelegate.arrDomains.count > 0 {
                        //safe get the previous selected one
                        if Global.sharedInstance.domainBuisness != "" {
                            for searchdomain in AppDelegate.arrDomains {
                                if searchdomain.nvCategoryName == Global.sharedInstance.domainBuisness {
                                    let myfoundindex = AppDelegate.arrDomains.index(of: searchdomain)
                                    print("myfoundindex \(myfoundindex)")
                                    if isscrolled == false {
                                        let index = IndexPath(row: myfoundindex!, section: 0)
                                        MAINTABLE.scrollToRow(at: index, at: UITableView.ScrollPosition.top, animated: true)
                                        isscrolled = true
                                    }
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
        ////////////  END OF DOMAIN BUSINESS SECTION      ////////////
        ////////////    BUSINESS HOURS SECTION            ////////////
        if x == 1  {
            if  y == 0 {
                if expandedcells[x] == true {
                    OPENHOURS()
                    expandedcells = [false, false, false, false, false]
                    isscrolled = false
                } else {
                    expandedcells = [false, false, false, false, false]
                    expandedcells[x] = true
                    isscrolled = false
                }
                refreshtable()
            }
            else {
                
            }
        }
        
        ////////////   END OF BUSINESS HOURS SECTION       ////////////
        ////////////    WORKERS SECTION      ///////////
        if x == 2 {
            if  y == 0 {
                if Global.sharedInstance.generalDetails.arrObjServiceProviders.count == 0 {
                    //open new screen
                    expandedcells = [false, false, false, false, false]
                    isscrolled = false
                    let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                    let viewpop:JoNewWorkerViewController = storyboardtest.instantiateViewController(withIdentifier: "JoNewWorkerViewController") as! JoNewWorkerViewController
                    viewpop.DELEGATERELOAD = self
                    viewpop.modalPresentationStyle = UIModalPresentationStyle.custom
                    self.present(viewpop, animated: true, completion: nil)
                } else {
                        if expandedcells[x] == true {
                        expandedcells = [false, false, false, false, false]
                        isscrolled = false
                    } else {
                        expandedcells = [false, false, false, false, false]
                        expandedcells[x] = true
                        isscrolled = false
                    }
                    refreshtable()
                }
            }
            else {
                //last row AddNewWorkerTableViewCell
                var howmany:Int = 0
                if Global.sharedInstance.generalDetails.arrObjServiceProviders.count > 0 {
                    howmany = Global.sharedInstance.generalDetails.arrObjServiceProviders.count + 2 //first is row 0 last is add employee row
                }
                if y == howmany - 1 {
                    let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                    let viewpop:JoNewWorkerViewController = storyboardtest.instantiateViewController(withIdentifier: "JoNewWorkerViewController") as! JoNewWorkerViewController
                    viewpop.DELEGATERELOAD = self
                    viewpop.modalPresentationStyle = UIModalPresentationStyle.custom
                    self.present(viewpop, animated: true, completion: nil)
                }
                
            }
        }
         ////////////  END OF WORKERS  SECTION      ////////////
        ////////////    SERVICES SECTION      ///////////
        if x == 3 {
            if  y == 0 {
                if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0 {
                    //open new screen
                    expandedcells = [false, false, false, false, false]
                    isscrolled = false
                    let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                    let viewpop:JoNewServiceViewController = storyboardtest.instantiateViewController(withIdentifier: "JoNewServiceViewController") as! JoNewServiceViewController
                    viewpop.DELEGATERELOAD = self
                    viewpop.modalPresentationStyle = UIModalPresentationStyle.custom
                    self.present(viewpop, animated: true, completion: nil)
                } else {
                        if expandedcells[x] == true {
                        expandedcells = [false, false, false, false, false]
                        isscrolled = false
                    } else {
                        expandedcells = [false, false, false, false, false]
                        expandedcells[x] = true
                        isscrolled = false
                    }
                   
                }
                 refreshtable()
            }
            else {
                //last row AddNewServiceTableViewCell
                var howmany:Int = 0
                if Global.sharedInstance.generalDetails.arrObjProviderServices.count > 0 {
                    howmany = Global.sharedInstance.generalDetails.arrObjProviderServices.count + 2 //first is row 0 last is add employee row
                }
                if y == howmany - 1 {
                    expandedcells = [false, false, false, false, false]
                    expandedcells[x] = true
                    refreshtable()
                    let storyboardtest = UIStoryboard(name: "Testing", bundle: nil)
                    let viewpop:JoNewServiceViewController = storyboardtest.instantiateViewController(withIdentifier: "JoNewServiceViewController") as! JoNewServiceViewController
//                    if self.iOS8 {
//                        viewpop.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
//                    } else {
//                        viewpop.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
//                    }
                     viewpop.DELEGATERELOAD = self
                   viewpop.modalPresentationStyle = UIModalPresentationStyle.custom
                    self.present(viewpop, animated: true, completion: nil)
                }
                
            }
        }

        ////////////  END OF SERVICES  SECTION      ////////////
        ////////////    CALENDAR SECTION      ///////////
            if x == 4 {
            if expandedcells[x] == true {
                 let indexPathtocheck = IndexPath(row: 1, section: x)
                guard let cell = self.MAINTABLE.cellForRow(at: indexPathtocheck) as? JoCalendarSettingsTableViewCell
                                            else {
                                            expandedcells = [false, false, false, false, false]
                                            refreshtable()
                                            return
                }
                
                if cell.txtMaxServiceForCustomer.text == "" && cell.btnYesSelect.isCecked == true || cell.txtMaxServiceForCustomer.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                {
                    cell.txtMaxServiceForCustomer.text = "3"
                }
                if cell.txtPeriodInWeeksForMaxServices.text == "" && cell.btnYesSelect.isCecked == true || cell.txtPeriodInWeeksForMaxServices.text == "REQUIREFIELD".localized(LanguageMain.sharedInstance.USERLANGUAGE)
                {
                    
                    cell.txtPeriodInWeeksForMaxServices.text = "6"
                }
                if cell.btnYesSelect.isCecked == false {
                    cell.txtMaxServiceForCustomer.text = "0"
                    cell.txtPeriodInWeeksForMaxServices.text = "0"
                }
                var inttosetforCALENDARWEEKSFORSUPPLIER = 0
                let USERDEF = UserDefaults.standard
                if  USERDEF.object(forKey: "CALENDARWEEKSFORSUPPLIER") == nil {
                    inttosetforCALENDARWEEKSFORSUPPLIER = 52
                } else {
                    inttosetforCALENDARWEEKSFORSUPPLIER = USERDEF.integer(forKey: "CALENDARWEEKSFORSUPPLIER")
                    if inttosetforCALENDARWEEKSFORSUPPLIER == 0 {
                        inttosetforCALENDARWEEKSFORSUPPLIER = 52
                    }
                }

                    let iFirstCalendarViewType:Int = 0
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    Global.sharedInstance.generalDetails.calendarProperties = objCalendarProperties(
                        _iFirstCalendarViewType: iFirstCalendarViewType,
                        _dtCalendarOpenDate:String(),
                        _bLimitSeries: cell.btnYesSelect.isCecked,
                        _iMaxServiceForCustomer: Global.sharedInstance.parseJsonToInt(cell.txtMaxServiceForCustomer.text! as AnyObject),
                        _iPeriodInWeeksForMaxServices: Global.sharedInstance.parseJsonToInt(cell.txtPeriodInWeeksForMaxServices.text! as AnyObject),
                        _bSyncGoogleCalendar: false,
                        _iCustomerViewLimit: 52,
                        _iHoursForPreCancelServiceByCustomer:0,
                        _bIsAvailableForNewCustomer:true

                    )
                
                expandedcells = [false, false, false, false, false]
                isscrolled = false
            } else {
                expandedcells = [false, false, false, false, false]
                expandedcells[x] = true
               
                isscrolled = false
            }
            refreshtable()
        }
         ////////////  END OF CALENDAR  SECTION      ////////////
    }
    func showSelectedHoursAndDays() -> String
    {
        var  DayFlagArr = [0,0,0,0,0,0,0]
        Global.sharedInstance.hourShow = ""
        
        for i in 0 ..< 7
        {
            if Global.sharedInstance.isHoursSelected[i] == true
            {
                if DayFlagArr[i] != 1
                {
                    if Global.sharedInstance.arrWorkHours[i].nvFromHour != ""  && Global.sharedInstance.arrWorkHours[i].nvToHour != "" && (Global.sharedInstance.arrWorkHours[i].nvFromHour != Global.sharedInstance.arrWorkHours[i].nvToHour )
                    {
                        for j in 0 ..< 7
                        {
                            if Global.sharedInstance.isHoursSelected[j] == true
                            {
                                if Global.sharedInstance.arrWorkHours[i].nvFromHour == Global.sharedInstance.arrWorkHours[j].nvFromHour &&
                                    Global.sharedInstance.arrWorkHours[i].nvToHour == Global.sharedInstance.arrWorkHours[j].nvToHour
                                {
                                    Global.sharedInstance.hourShow = "\(Global.sharedInstance.hourShow) \(convertDays(j)),"
                                    DayFlagArr[j] = 1
                                }
                            }
                        }
                        Global.sharedInstance.hourShow = String(Global.sharedInstance.hourShow.characters.dropLast())
                        Global.sharedInstance.hourShow = "\(Global.sharedInstance.hourShow) - "
                        
                        if Global.sharedInstance.isHoursSelected[i] == true
                        {
                            Global.sharedInstance.hourShow = "\(Global.sharedInstance.hourShow) \(cutHour(Global.sharedInstance.arrWorkHours[i].nvFromHour))-\(cutHour(Global.sharedInstance.arrWorkHours[i].nvToHour)),"
                        }
                    }
                }
            }
        }
        Global.sharedInstance.hourShow = String(Global.sharedInstance.hourShow.characters.dropLast())
        
        return Global.sharedInstance.hourShow
    }
    func showSelectedRecessAndDays() -> String
    {
        var  DayFlagArr = [0,0,0,0,0,0,0]
        Global.sharedInstance.hourShowRecess = ""
        
        for i in 0 ..< 7
        {
            if Global.sharedInstance.isHoursSelectedRest[i] == true
            {
                if DayFlagArr[i] != 1
                {
                    if Global.sharedInstance.arrWorkHoursRest[i].nvFromHour != ""  && Global.sharedInstance.arrWorkHoursRest[i].nvToHour != "" && (Global.sharedInstance.arrWorkHoursRest[i].nvFromHour != Global.sharedInstance.arrWorkHoursRest[i].nvToHour )
                    {
                        for j in 0 ..< 7
                        {
                            if Global.sharedInstance.isHoursSelectedRest[j] == true
                            {
                                if Global.sharedInstance.arrWorkHoursRest[i].nvFromHour == Global.sharedInstance.arrWorkHoursRest[j].nvFromHour &&
                                    Global.sharedInstance.arrWorkHoursRest[i].nvToHour == Global.sharedInstance.arrWorkHoursRest[j].nvToHour
                                {
                                    Global.sharedInstance.hourShowRecess = "\(Global.sharedInstance.hourShowRecess) \(convertDays(j)),"
                                    DayFlagArr[j] = 1
                                }
                            }
                        }
                        Global.sharedInstance.hourShowRecess = String(Global.sharedInstance.hourShowRecess.characters.dropLast())
                        Global.sharedInstance.hourShowRecess = "\(Global.sharedInstance.hourShowRecess) - "
                        
                        if Global.sharedInstance.isHoursSelectedRest[i] == true
                        {
                            Global.sharedInstance.hourShowRecess = "\(Global.sharedInstance.hourShowRecess) \(cutHour(Global.sharedInstance.arrWorkHoursRest[i].nvFromHour))-\(cutHour(Global.sharedInstance.arrWorkHoursRest[i].nvToHour)),"
                        }
                    }
                }
            }
        }
        Global.sharedInstance.hourShowRecess = String(Global.sharedInstance.hourShowRecess.characters.dropLast())
        
        if Global.sharedInstance.hourShowRecess != ""
        {
            Global.sharedInstance.hourShowRecess = "\("RECESS".localized(LanguageMain.sharedInstance.USERLANGUAGE)):\(Global.sharedInstance.hourShowRecess)"
        }
        return Global.sharedInstance.hourShowRecess
    }
    
    //cut last 3 characters of string to avoid hh:mm -> :00
    func cutHour(_ hour:String) -> String {
        var fixedHour = String(hour.characters.dropLast())
        fixedHour = String(fixedHour.characters.dropLast())
        fixedHour = String(fixedHour.characters.dropLast())
        return fixedHour
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
    
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    ////AND PURE CLEAN CODE FOR cells
    func domaincell(_ section:Int,row:Int) -> DomainTableViewCell {
        var font = UIFont()
        var font2 = UIFont()
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            font = UIFont(name: "OpenSansHebrew-Bold", size: 15)!
            font2 = UIFont(name: "OpenSansHebrew-Light", size: 17)!
        } else {
            font = UIFont(name: "OpenSansHebrew-Bold", size: 17)!
            font2 = UIFont(name: "OpenSansHebrew-Light", size: 19)!
        }
        let cell:DomainTableViewCell = MAINTABLE.dequeueReusableCell(withIdentifier: "DomainTableViewCell")as!DomainTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.lblText?.font = font2
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        let x = section
        let y = row
        ////////////    DOMAIN BUSINESS SECTION      ///////////
        
        if x == 0 {
            if y == 0 {
                if expandedcells[x] == false {
                    cell.arrow.image = UIImage(named: "generaldataleft.png")
                } else {
                    cell.arrow.image = UIImage(named: "generaldatadown.png")
                }
                cell.contentView.backgroundColor = UIColor.clear
                cell.lblText?.textColor = UIColor.black
                if Global.sharedInstance.domainBuisness != "" {
                    cell.lblText?.text = Global.sharedInstance.domainBuisness
                } else {
                    cell.lblText?.text = headersCell[x]
                }
            } else {
                cell.contentView.backgroundColor = UIColor.black
                cell.lblText?.textColor = UIColor.white
                cell.arrow.image = nil
                if  AppDelegate.arrDomains.count > 0 {
                    //safe get the previous selected one
                    if Global.sharedInstance.domainBuisness != "" {
                        for searchdomain in AppDelegate.arrDomains {
                            if searchdomain.nvCategoryName == Global.sharedInstance.domainBuisness {
                                let myfoundindex = AppDelegate.arrDomains.index(of: searchdomain)
                                print("myfoundindex \(myfoundindex)")
                                if y == myfoundindex! + 1 {
                                    cell.contentView.backgroundColor = UIColor(red:145/255.0, green: 201/255.0, blue: 214/255.0, alpha: 1.0)
                                    cell.lblText?.textColor = UIColor.black
                                }
                                break
                            }
                        }
                    }
                    if let _:Domain =  AppDelegate.arrDomains[y - 1]  {
                        let mybusinessdomain =  AppDelegate.arrDomains[y - 1]
                        cell.lblText?.text = mybusinessdomain.nvCategoryName
                    }
                }
            }
        }
        ////////////  END OF DOMAIN BUSINESS SECTION      ////////////
        ////////////    BUSINESS HOURS SECTION            ////////////
        
        if x == 1 {
            
            if y == 0 {             //  main cell title
                cell.lblText?.font = font2
                if expandedcells[x] == false {
                    cell.arrow.image = UIImage(named: "generaldataleft.png")
                } else {
                    cell.arrow.image = UIImage(named: "generaldatadown.png")
                }
                cell.contentView.backgroundColor = UIColor.clear
                cell.lblText?.textColor = UIColor.black
                cell.lblText?.text = headersCell[x]
                cell.separatorInset = UIEdgeInsets.init(top: 0, left: 1000, bottom: 0, right: 0)
                return cell
            }
            else if y == 1 {      //hashoursselected == true
                cell.lblText?.font = font
                cell.contentView.backgroundColor = UIColor.clear
                cell.lblText?.textColor = Colors.sharedInstance.color4
                cell.arrow.image = nil
                cell.lblText?.lineBreakMode = .byWordWrapping
                cell.lblText?.numberOfLines = 0
                let Mystr = showSelectedHoursAndDays()
                if Mystr.characters.count > 0 {
                    cell.lblText?.text = Mystr
                } else {
                    cell.lblText?.text = ""
                }
                cell.separatorInset = UIEdgeInsets.init(top: 0, left: 1000, bottom: 0, right: 0)
                return cell
            } else if y == 2 {      //hasfreehoursselected == true
                cell.lblText?.font = font
                cell.contentView.backgroundColor = UIColor.clear
                cell.lblText?.textColor = Colors.sharedInstance.color3
                cell.arrow.image = nil
                cell.lblText?.lineBreakMode = .byWordWrapping
                cell.lblText?.numberOfLines = 0
                let Mystr = showSelectedRecessAndDays()
                if Mystr.characters.count > 0 {
                    cell.lblText?.text = Mystr
                } else {
                    cell.lblText?.text = ""
                }
                cell.separatorInset = UIEdgeInsets.init(top: 0, left: 1000, bottom: 0, right: 0)
                return cell
            }
        }
        ////////////   END OF BUSINESS HOURS SECTION       ////////////
        if x == 2 || x == 3 || x == 4 {
            if y == 0 {
                if expandedcells[x] == false {
                    cell.arrow.image = UIImage(named: "generaldataleft.png")
                } else {
                    cell.arrow.image = UIImage(named: "generaldatadown.png")
                }
                cell.contentView.backgroundColor = UIColor.clear
                cell.lblText?.textColor = UIColor.black
                cell.lblText?.text = headersCell[x]
                cell.separatorInset = UIEdgeInsets.init(top: 0, left: 1000, bottom: 0, right: 0)
                return cell
            } else {
                cell.contentView.backgroundColor = UIColor.clear
                cell.lblText?.textColor = UIColor.black
                // cell.lblText?.text = headersCell[x]
                cell.separatorInset = UIEdgeInsets.init(top: 0, left: 1000, bottom: 0, right: 0)
                return cell
            }
        }
        
        return cell
    }
    func LISTALLWORKINGHOURSFORSERVER() {
        Global.sharedInstance.generalDetails.arrObjWorkingHours = Array<objWorkingHours>() //empty before mix the working and rest
        //IN CASE YOU WANT TO TEST OR CLEAR PREVIOUS BAD SAVED DATA USE FROM HERE ====>
        //    var workingHours:objWorkingHours = objWorkingHours()
        //      var workingHoursTEST:objWorkingHours = objWorkingHours()
        //            workingHours = objWorkingHours(
        //                _iDayInWeekType: 1,
        //                _nvFromHour: "10:30:00",
        //                _nvToHour: "11:00:00")
        //        workingHoursTEST = objWorkingHours(
        //            _iDayInWeekType: 1,
        //            _nvFromHour: "12:30:00",
        //            _nvToHour: "19:00:00")
        //        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHours)
        //        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workingHoursTEST)
        //   <==== <====<====<====<====<====<====<====<====<==== to here AND COMMENT BELLOW
        var mymixedarray:Array<objWorkingHours> = Array<objWorkingHours>()
        
        ////////Global.sharedInstance.arrWorkHours
        for x in Global.sharedInstance.arrWorkHours {
            print("ce a ramaas wh \(x.getDic())")
            var workingHours:objWorkingHours = objWorkingHours()
            if x.iDayInWeekType != 0 && (x.nvFromHour != x.nvToHour) {
                workingHours = objWorkingHours(
                    _iDayInWeekType: x.iDayInWeekType,
                    _nvFromHour: x.nvFromHour,
                    _nvToHour: x.nvToHour)
                if !mymixedarray.contains(workingHours) {
                    mymixedarray.append(workingHours)
                }
            }
        }
        //   print("Global.sharedInstance.arrWorkHoursRest \(Global.sharedInstance.arrWorkHoursRest)")
        for x in Global.sharedInstance.arrWorkHoursRest {
            print("rh ce ramane \(x.getDic())")
            var workingHours:objWorkingHours = objWorkingHours()
            if x.iDayInWeekType != 0 && (x.nvFromHour != x.nvToHour) {
                workingHours = objWorkingHours(
                    _iDayInWeekType: x.iDayInWeekType,
                    _nvFromHour: x.nvFromHour,
                    _nvToHour: x.nvToHour)
                if !mymixedarray.contains(workingHours) {
                    mymixedarray.append(workingHours)
                }
            }
        }
        print("mym \(mymixedarray.count)")
        if mymixedarray.count > 0 {
            for i in 1...7 {
                var hoursinday:Array<objWorkingHours> = []
                for z in 0..<mymixedarray.count {
                    let arie:objWorkingHours = mymixedarray[z]
                    let ay = arie.iDayInWeekType
                    if ay == i {
                        hoursinday.append(arie)
                    }
                }
                print("////////// \(i)")
                if hoursinday.count == 0 {
                    print("no working hours ")
                } else  if hoursinday.count == 1 && hoursinday[0].iDayInWeekType == i {
                    print("onele \(hoursinday[0].getDic())")
                    let oneelement:objWorkingHours = hoursinday[0]
                    if !Global.sharedInstance.generalDetails.arrObjWorkingHours.contains(oneelement) {
                        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(oneelement)
                    }
                } else    if hoursinday.count == 2 && hoursinday[0].iDayInWeekType == i && hoursinday[1].iDayInWeekType == i {
                    print("onelex \(hoursinday[0].getDic())")
                    print("secondx \(hoursinday[1].getDic())")
                    let firstelement:objWorkingHours = hoursinday[0]
                    let secondelement:objWorkingHours = hoursinday[1]
                    let workelement:objWorkingHours = objWorkingHours()
                    let restlement:objWorkingHours = objWorkingHours()
                    workelement.iDayInWeekType = i
                    restlement.iDayInWeekType = i
                    workelement.nvFromHour = firstelement.nvFromHour
                    workelement.nvToHour = secondelement.nvFromHour
                    restlement.nvFromHour = secondelement.nvToHour
                    restlement.nvToHour = firstelement.nvToHour
                    if !Global.sharedInstance.generalDetails.arrObjWorkingHours.contains(workelement) {
                        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(workelement)
                    }
                    if !Global.sharedInstance.generalDetails.arrObjWorkingHours.contains(restlement) {
                        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(restlement)
                    }
                }
            }
        }
        
        /////////till HERE
        for nextw in Global.sharedInstance.generalDetails.arrObjWorkingHours {
            print("nextw \(nextw.getDic())")
        }
    }
    func rereadalldetails() {
        //populate workers
        Global.sharedInstance.generalDetails.arrObjServiceProviders = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjServiceProviders
        print("Global.sharedInstance.generalDetails.arrObjServiceProviders.count \(Global.sharedInstance.generalDetails.arrObjServiceProviders.count)")
        Global.sharedInstance.generalDetails.arrObjProviderServices = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjProviderServices
        print("Global.sharedInstance.generalDetails.arrObjProviderServices \(Global.sharedInstance.generalDetails.arrObjProviderServices)")
        Global.sharedInstance.generalDetails.calendarProperties = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.calendarProperties
        Global.sharedInstance.arrObjServiceProvidersForEdit = []
        ////////////////////////////////////////////////////////////////////////////////////////////////////
        Global.sharedInstance.isHoursSelected = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedRest = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedChild = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedRestChild = [false,false,false,false,false,false,false]
        Global.sharedInstance.arrWorkHours  = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        Global.sharedInstance.isHoursSelected = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedRest = [false,false,false,false,false,false,false]
        Global.sharedInstance.hourShow = ""
        Global.sharedInstance.hourShowRecess = ""
        Global.sharedInstance.generalDetails.arrObjWorkingHours = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        Global.sharedInstance.arrWorkHoursRest = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        print("si orele \( Global.sharedInstance.generalDetails.arrObjWorkingHours)")
        print("testing \(Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours.count)")
        //fast parse of iDayInWeekType
        if Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours.count == 0 {
            for i in 1...7 {
                //\\  print("no reg ")
                let emptyelement:objWorkingHours = objWorkingHours()
                emptyelement.iDayInWeekType = i
                emptyelement.nvFromHour = "00:00:00"
                emptyelement.nvToHour = "00:00:00"
                Global.sharedInstance.arrWorkHoursRest[i-1] = emptyelement
                Global.sharedInstance.generalDetails.arrObjWorkingHours[i-1] = emptyelement
            }
        } else {
            for i in 1...7 {
                var hoursinday:Array<objWorkingHours> = []
                for z in 0..<Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours.count {
                    //\\    print("aria gasita \(Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours[z].getDic())")
                    let arie:objWorkingHours = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjWorkingHours[z]
                    let ay = arie.iDayInWeekType
                    if ay == i {
                        hoursinday.append(arie)
                    }
                    if hoursinday.count == 0 {
                        //\\     print("no reg ")
                        let emptyelement:objWorkingHours = objWorkingHours()
                        emptyelement.iDayInWeekType = i
                        emptyelement.nvFromHour = "00:00:00"
                        emptyelement.nvToHour = "00:00:00"
                        Global.sharedInstance.arrWorkHoursRest[i-1] = emptyelement
                        Global.sharedInstance.generalDetails.arrObjWorkingHours[i-1] = emptyelement
                    } else  if hoursinday.count == 1 {
                        //\\      print("no cathch")
                        let oneelement:objWorkingHours = hoursinday[0]
                        Global.sharedInstance.generalDetails.arrObjWorkingHours[i-1] = oneelement
                        let emptyelement:objWorkingHours = objWorkingHours()
                        emptyelement.iDayInWeekType = i
                        emptyelement.nvFromHour = "00:00:00"
                        emptyelement.nvToHour = "00:00:00"
                        Global.sharedInstance.arrWorkHoursRest[i-1] = emptyelement
                    } else    if hoursinday.count == 2 {
                        
                        let firstelement:objWorkingHours = hoursinday[0]
                        let secondelement:objWorkingHours = hoursinday[1]
                        let workelement:objWorkingHours = objWorkingHours()
                        let restlement:objWorkingHours = objWorkingHours()
                        workelement.iDayInWeekType = i
                        restlement.iDayInWeekType = i
                        workelement.nvFromHour = firstelement.nvFromHour
                        workelement.nvToHour = secondelement.nvToHour
                        restlement.nvFromHour = firstelement.nvToHour
                        restlement.nvToHour = secondelement.nvFromHour
                        Global.sharedInstance.generalDetails.arrObjWorkingHours[i - 1] = workelement
                        Global.sharedInstance.arrWorkHoursRest[i - 1] = restlement
                    }
                }
            }
        }
        
        Global.sharedInstance.isSelectAllHours = false
        Global.sharedInstance.isSelectAllRest = false
        var simplearr:Array<Int> = []
        for y in 1...7 {
            for i in 0..<Global.sharedInstance.generalDetails.arrObjWorkingHours.count {
                let arie:objWorkingHours = Global.sharedInstance.generalDetails.arrObjWorkingHours[i]
                let ay = arie.iDayInWeekType
                let fromh:String =  arie.nvFromHour
                let toh:String = arie.nvToHour
                if ay == y  {
                    if fromh == "00:00:00" && toh == "00:00:00" {
                        //nothing fill empty
                        Global.sharedInstance.arrWorkHours[y - 1] = arie
                        simplearr.append(y)
                    }else {
                        Global.sharedInstance.arrWorkHours[y - 1] = arie
                        Global.sharedInstance.isHoursSelected[y - 1] = true
                    }
                }
            }
        }
        if simplearr.count > 0 {
            Global.sharedInstance.isSelectAllHours = false
        } else {
            Global.sharedInstance.isSelectAllHours = true
        }
        simplearr = []
        Global.sharedInstance.isRest = false
        for y in 1...7 {
            for i in 0..<Global.sharedInstance.arrWorkHoursRest.count {
                let arie:objWorkingHours = Global.sharedInstance.arrWorkHoursRest[i]
                let ay = arie.iDayInWeekType
                let fromh:String =  arie.nvFromHour
                let toh:String = arie.nvToHour
                if ay == y  {
                    if fromh == "00:00:00" && toh == "00:00:00" {
                        //nothing
                        simplearr.append(y)
                    }else {
                        Global.sharedInstance.isHoursSelectedRest[y - 1] = true
                        Global.sharedInstance.isRest = true
                    }
                }
            }
        }
        if simplearr.count > 0 {
            Global.sharedInstance.isSelectAllRest = false
        } else {
            Global.sharedInstance.isSelectAllRest = true
        }

        Global.sharedInstance.isHoursSelectedChild = [false,false,false,false,false,false,false]
        Global.sharedInstance.isHoursSelectedRestChild = [false,false,false,false,false,false,false]

        
        Global.sharedInstance.workingHours = objWorkingHours()
        Global.sharedInstance.isSelectAllHoursChild = false
        Global.sharedInstance.isSelectAllRestChild = false
        Global.sharedInstance.workingHoursChild = objWorkingHours()
        Global.sharedInstance.arrWorkHoursChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        Global.sharedInstance.workingHoursRestChild = objWorkingHours()
        Global.sharedInstance.arrWorkHoursRestChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
        Global.sharedInstance.currentBtnDayTagChild = -1
        Global.sharedInstance.lastBtnDayTagChild = -1
        Global.sharedInstance.currentBtnDayTagRestChild = -1
        Global.sharedInstance.lastBtnDayTagRestChild = -1
        
        if  Global.sharedInstance.generalDetails.arrObjServiceProviders.count > 0 {
            for i in 0..<Global.sharedInstance.generalDetails.arrObjServiceProviders.count {
                let ax = Global.sharedInstance.generalDetails.arrObjServiceProviders[i]
                var arrObjWorkingHoursChild:Array<objWorkingHours> = Array<objWorkingHours>()
                var arrObjRestHoursChild:Array<objWorkingHours> = Array<objWorkingHours>()
                arrObjWorkingHoursChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
                arrObjRestHoursChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
                var ish = [false, false, false, false, false, false, false]
                var ishrest = [false, false, false, false, false, false, false]
                if ax.arrObjWorkingHours.count == 0 {
                    for i in 1...7 {
                        //\\   print("no reg ")
                        let emptyelement:objWorkingHours = objWorkingHours()
                        emptyelement.iDayInWeekType = i
                        emptyelement.nvFromHour = "00:00:00"
                        emptyelement.nvToHour = "00:00:00"
                        arrObjWorkingHoursChild[i-1] = emptyelement
                        arrObjRestHoursChild[i-1] = emptyelement
                    }
                } else {
                    for i in 1...7 {
                        var hoursinday:Array<objWorkingHours> = []
                        for z in 0..<ax.arrObjWorkingHours.count {
                            //\\     print("aria gasita 111 \(ax.arrObjWorkingHours[z].getDic())")
                            let arie:objWorkingHours = ax.arrObjWorkingHours[z]
                            let ay = arie.iDayInWeekType
                            if ay == i {
                                hoursinday.append(arie)
                            }
                            if hoursinday.count == 0 {
                                //\\      print("no reg 111")
                                let emptyelement:objWorkingHours = objWorkingHours()
                                emptyelement.iDayInWeekType = i
                                emptyelement.nvFromHour = "00:00:00"
                                emptyelement.nvToHour = "00:00:00"
                                arrObjWorkingHoursChild[i-1] = emptyelement
                                arrObjRestHoursChild[i-1] = emptyelement
                            } else  if hoursinday.count == 1 {
                                //\\      print("no cathch 1111")
                                let oneelement:objWorkingHours = hoursinday[0]
                                arrObjWorkingHoursChild[i-1] = oneelement
                                let emptyelement:objWorkingHours = objWorkingHours()
                                emptyelement.iDayInWeekType = i
                                emptyelement.nvFromHour = "00:00:00"
                                emptyelement.nvToHour = "00:00:00"
                                arrObjRestHoursChild[i-1] = emptyelement
                            } else    if hoursinday.count == 2 {
                                //\\    print("this cathch 1111")
                                let firstelement:objWorkingHours = hoursinday[0]
                                let secondelement:objWorkingHours = hoursinday[1]
                                let workelement:objWorkingHours = objWorkingHours()
                                let restlement:objWorkingHours = objWorkingHours()
                                workelement.iDayInWeekType = i
                                restlement.iDayInWeekType = i
                                workelement.nvFromHour = firstelement.nvFromHour
                                workelement.nvToHour = secondelement.nvToHour
                                restlement.nvFromHour = firstelement.nvToHour
                                restlement.nvToHour = secondelement.nvFromHour
                                arrObjWorkingHoursChild[i - 1] = workelement
                                arrObjRestHoursChild[i - 1] = restlement
                            }
                        }
                    }
                }
                for z in 0..<arrObjWorkingHoursChild.count {
                    print("aria gasita worker \(arrObjWorkingHoursChild[z].getDic())")
                }
                for z in 0..<arrObjRestHoursChild.count {
                    print("aria gasita rest worker \(arrObjRestHoursChild[z].getDic())")
                }
                var isSelectAllHours:Bool = false
                var isSelectAllRecess:Bool = false
                var simplearr:Array<Int> = []
                for y in 1...7 {
                    for i in 0..<arrObjWorkingHoursChild.count {
                        let arie:objWorkingHours = arrObjWorkingHoursChild[i]
                        let ay = arie.iDayInWeekType
                        let fromh:String =  arie.nvFromHour
                        let toh:String = arie.nvToHour
                        if ay == y  {
                            if fromh == "00:00:00" && toh == "00:00:00" {
                                //nothing fill empty
                                ish[y - 1] = false
                                simplearr.append(y)
                            }else {
                                ish[y - 1] = true
                            }
                        }
                    }
                }
                if simplearr.count > 0 {
                    isSelectAllHours = false
                } else {
                    isSelectAllHours = true
                }
                simplearr = []
                for y in 1...7 {
                    for i in 0..<arrObjRestHoursChild.count {
                        let arie:objWorkingHours = arrObjRestHoursChild[i]
                        let ay = arie.iDayInWeekType
                        let fromh:String =  arie.nvFromHour
                        let toh:String = arie.nvToHour
                        if ay == y  {
                            if fromh == "00:00:00" && toh == "00:00:00" {
                                //nothing
                                simplearr.append(y)
                            }else {
                                ishrest[y - 1] = true
                                //\\
                            }
                        }
                    }
                }
                if simplearr.count > 0 {
                    isSelectAllRecess = false
                } else {
                    isSelectAllRecess = true
                }
                //\\    print("x.bSameWH \(ax.bSameWH)")
                let serviceProvidersForEdit = objServiceProvidersForEdit(
                    _objsers: ax.objsers,
                    _arrObjWorkingHours: arrObjWorkingHoursChild,
                    _arrObjWorkingRest: arrObjRestHoursChild,
                    _isHoursSelected: ish,
                    _isHoursSelectedRest:ishrest,
                    _isSelectAllHours: isSelectAllHours,
                    _isSelectAllRecess: isSelectAllRecess,
                    _bSameWH: ax.bSameWH)
                Global.sharedInstance.arrObjServiceProvidersForEdit.append(serviceProvidersForEdit)
            }
        }
        
          }
    

    
}

