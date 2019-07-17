//
// BthereEventListViewcontroller.swift
//  Bthere
//
//  Created by User on 24.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class BthereEventListViewcontroller: UIViewController,UITableViewDataSource,UITableViewDelegate ,openFromMenuDelegate,UIGestureRecognizerDelegate{
    var myArray : Array<allKindEventsForListDesign> = []
    var ICUSTOMERID:Int = 0
    var iFilterByMonth:Int = 0
    var iFilterByYear:Int = 0
    var iFilterByMonthEnd:Int = 0
    var iFilterByYearEnd:Int = 0
    var DCUSTOMER:NSDictionary = NSDictionary()
    var myCustomersArray : NSMutableArray = []
    @IBOutlet weak var titleofScreen: UILabel!
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
    let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //myArray = []
    }

    let calendar = Foundation.Calendar.current
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    var row:Int = 0
    
    
    @IBOutlet weak var tblData: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblData.delegate = self
        self.tblData.reloadData()
        Global.sharedInstance.BthereEventList = self
          print("xMYordersOfClientsArray \(myArray)")
        tblData.separatorStyle = .none
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  myArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       let totalnumberrows:Int = 1
     //  totalnumberrows =  myArray.count
       return totalnumberrows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
    
        var d:allKindEventsForListDesign  = allKindEventsForListDesign ()
        
             d =  self.myArray[indexPath.section]
              print("mydict \(d.getDic())")
              print("STRdtDateOrder\(d.dateEvent)")
        let cell:HeaderBtheventRecordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HeaderBtheventRecordTableViewCell")as!HeaderBtheventRecordTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
       
         //   cell.setDisplayData(d)
        if d.iCoordinatedServiceId > 0 {
            cell.EYEORBTHERE.image =  UIImage(named: "bthere-small-weekd.png")!
        } else {
            cell.EYEORBTHERE.image = UIImage(named: "small-eye.png")!
        }
          let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd/MM/yyyy"
        cell.DATEEVENT.text = dateFormatter.string(from: d.dateEvent as Date)
        // lblHour.text = st
        cell.HOURSEVENT.text =   "\(d.fromHour) - \(d.toHour)"
        let dayWeek = Calendar.sharedInstance.getDayOfWeek(d.dateEvent)
        
        let dayInWeek = DateFormatter().weekdaySymbols[dayWeek! - 1]
        cell.DAYOFEVENT.text = dayInWeek
        cell.TITLEEVENT.text = d.title
    //    cell.USERNAME.text = String( d.iCoordinatedServiceId)
     if d.iCoordinatedServiceId != 0 {
            cell.tag = indexPath.section
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showContent(_:)))
            tap.delegate = self
            cell.addGestureRecognizer(tap)
        }
        //    cell.setDisplayData(indexPath.section, MYDICT: self.DCUSTOMER)
  //      let anyhow:Int = d.iUserId
//        var emi:NSDictionary = NSDictionary()
//        if self.findCustomer(anyhow) != NSDictionary() {
//            emi = self.findCustomer(anyhow)
//            if let _:String = emi.object(forKey: "nvFullName") as? String{
//                let  ClientnvFullName:String = emi.object(forKey: "nvFullName") as! String
//                cell.USERNAME.text = ClientnvFullName
//            
//            }
//        }
        if d.ClientnvFullName != "" {
            cell.USERNAME.text = d.ClientnvFullName
        }
            return cell
 
        
    }
    func findCustomer(_ iuseridcautat:Int) -> NSDictionary {
        var gasit:NSDictionary = NSDictionary()
        for item in self.myCustomersArray {
            if let _:NSDictionary = item as? NSDictionary {
                let d:NSDictionary = item as! NSDictionary
                if let x:Int = d.object(forKey: "iCustomerUserId") as? Int{
                    if x == iuseridcautat {
                        gasit = d
                    }
                }
            }
        }
        //    print("gasit \(gasit.description)")
        return gasit
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
     //   return self.view.frame.height * 0.12
        return 100
    }
    
    //openFromMenuDelegate
    func openFromMenu(_ con:UIViewController){
        self.present(con, animated: true, completion: nil)
    }
    
       @objc func showContent(_ sender: UITapGestureRecognizer) {
        let tag = sender.view!.tag
          print("sender tag \(tag)")
        var d:allKindEventsForListDesign = allKindEventsForListDesign()
        
       
        if myArray.count > 0 {
            if let _:allKindEventsForListDesign = myArray[tag]   {
                d = myArray[tag]
                  print("ddddd \(d)")
               let supplierStoryBoard = UIStoryboard(name: "SupplierExist", bundle: nil)
                let frontviewcontroller:UINavigationController? = UINavigationController()
                let viewCon:detailsAppointmetsupplierViewController = supplierStoryBoard.instantiateViewController(withIdentifier: "detailsAppointmetsupplierViewController") as! detailsAppointmetsupplierViewController
                viewCon.APPOINMENT_DICT = d.getDic() as NSDictionary
                let mydic = d.getDic() as NSDictionary
                if let _:String = mydic["nvComment"] as? String {
                    let nvcom = mydic["nvComment"] as! String
                    if nvcom == "BlockedBySupplier" {
                        viewCon.isBLOCKED = true
                    } else {
                        viewCon.isBLOCKED = false
                    }
                }
               
                  print("d.getDic() \(d.getDic())")
                viewCon.isfromLIST = false
               // viewCon.userAPPOINMENT_DICT = self.DCUSTOMER
               // let anyhow:Int = d.iUserId
            
                let emi:NSMutableDictionary = NSMutableDictionary()
                if let _:String = mydic["nvPhone"] as? String   {
                    let nvPhone = mydic["nvPhone"] as! String
                    emi["nvPhone"] = nvPhone
                }
                
                if let _:Int = mydic["iUserId"]  as? Int {
                    let a:Int =  mydic["iUserId"]  as! Int
                    if a == 134 {
                    if let _:String = mydic["nvComment"] as? String {
                        let b:String =  mydic["nvComment"]  as! String
                         emi["nvPhone"] = b
                    }
                }
                }

                viewCon.userAPPOINMENT_DICT = emi
                viewCon.isfromWEEK = true
                frontviewcontroller!.pushViewController(viewCon, animated: false)
                //initialize REAR View Controller- it is the LEFT hand menu.
                let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                let rearViewController = storyboard1.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
                let mainRevealController = SWRevealViewController()
                mainRevealController.frontViewController = frontviewcontroller
                mainRevealController.rearViewController = rearViewController
                let window :UIWindow = UIApplication.shared.keyWindow!
                window.rootViewController = mainRevealController
            }
        }
        
    }
    func hidetoast(){
        view.hideToastActivity()
    }
    
    
   }
