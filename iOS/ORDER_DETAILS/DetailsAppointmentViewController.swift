//
//  DetailsAppointmentViewController.swift
//  bthree-ios
//
//  Created by User on 21.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
// פרטי תור ספק
class DetailsAppointmentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {
    @IBOutlet weak var tblHoursServices: UITableView!

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblKind: UILabel!
    @IBOutlet weak var viewKindService: UIView!
    @IBOutlet weak var viewGiveService: UIView!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var tblListWorkers: UITableView!
    
    @IBOutlet weak var viewCancelTurn: UIView!
    @IBOutlet weak var viewHourSer: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var tblDates: UITableView!
    @IBOutlet weak var tblKinds: UITableView!
    @IBOutlet weak var viewIn: UIView!
    @IBOutlet weak var lblGiveServiceName: UILabel!
    @IBOutlet weak var viewCall: UIView!
    var x = 0
    var x1 = 0
    var x2  = 0
    var x3 = 0
    var arr:Array<String> = ["asfaf","afas","dfsd","sfdf"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewIn.bringSubviewToFront(tblListWorkers)
        tblListWorkers.separatorStyle = .none
        viewIn.bringSubviewToFront(tblKinds)
        
        tblKinds.separatorStyle = .none
        viewIn.bringSubviewToFront(tblHoursServices)
        tblHoursServices.separatorStyle = .none
        viewIn.bringSubviewToFront(tblDates)
        tblDates.separatorStyle = .none
       self.view.bringSubviewToFront(tblListWorkers)
       tblListWorkers.isHidden = true
        tblDates.isHidden = true

        tblHoursServices.isHidden = true
        tblKinds.isHidden = true

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(DetailsAppointmentViewController.imageTapped))
        viewGiveService.isUserInteractionEnabled = true
        viewGiveService.addGestureRecognizer(tapGestureRecognizer)
        let tapGestureRecognizer1 = UITapGestureRecognizer(target:self, action:#selector(DetailsAppointmentViewController.imageTapped1))
        viewKindService.isUserInteractionEnabled = true
        viewKindService.addGestureRecognizer(tapGestureRecognizer1)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target:self, action:#selector(DetailsAppointmentViewController.imageTapped3))
        viewDate.isUserInteractionEnabled = true
        viewDate.addGestureRecognizer(tapGestureRecognizer2)
        let tapGestureRecognizer3 = UITapGestureRecognizer(target:self, action:#selector(DetailsAppointmentViewController.imageTapped2))
        viewHourSer.isUserInteractionEnabled = true
        viewHourSer.addGestureRecognizer(tapGestureRecognizer3)
        let tapGestureRecognizer4 = UITapGestureRecognizer(target:self, action:#selector(DetailsAppointmentViewController.CancelTurnTapped))
        viewCancelTurn.isUserInteractionEnabled = true
        viewCancelTurn.addGestureRecognizer(tapGestureRecognizer4)
        let tapGestureRecognizer5 = UITapGestureRecognizer(target:self, action:#selector(DetailsAppointmentViewController.CallTapped))
        viewCall.isUserInteractionEnabled = true
        viewCall.addGestureRecognizer(tapGestureRecognizer5)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer()
        tap.delegate = self
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
           }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(tableView){
        case tblListWorkers:
        let cell:GiveServiceNameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GiveServiceNameTableViewCell")as!GiveServiceNameTableViewCell
        cell.setDisplayData(arr[indexPath.row])
        cell.selectionStyle = .none
        return cell
        case tblKinds:
            let cell:KindServiceNameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "KindServiceNameTableViewCell")as!KindServiceNameTableViewCell
            cell.setDisplayData(arr[indexPath.row])
            cell.selectionStyle = .none
            return cell
        
        case tblHoursServices:
        let cell:HoursTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HoursTableViewCell")as!HoursTableViewCell
        cell.setDisplayData(arr[indexPath.row])
        cell.selectionStyle = .none
        return cell
        case tblDates:
            let cell:DatesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DatesTableViewCell")as!DatesTableViewCell
            cell.setDisplayData(arr[indexPath.row])
            cell.selectionStyle = .none
            return cell
        default:
            let cell:DatesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DatesTableViewCell")as!DatesTableViewCell
            cell.setDisplayData(arr[indexPath.row])
            cell.selectionStyle = .none
            return cell
    }
   }


   @objc func imageTapped(){
    if x == 0{
    tblListWorkers.isHidden = false
        x = 1
   }
    else{
        x = 0
        tblListWorkers.isHidden = true
    }
    
   }
    
    @objc func imageTapped1(){
        if x1 == 0{
            tblKinds.isHidden = false
            x1 = 1
        }
        else{
            x1 = 0
            tblKinds.isHidden = true
        }
    }
    
    @objc func imageTapped2(){
        if x2 == 0{
            tblHoursServices.isHidden = false
            x2 = 1
        }
        else{
            x2 = 0
            tblHoursServices.isHidden = true
        }
    }
    
    
    @objc func imageTapped3(){
        
        if x3 == 0{
            tblDates.isHidden = false
            x3 = 1
        }
        else{
            x3 = 0
            tblDates.isHidden = true
        }
    }
    
    @objc func CancelTurnTapped(){
        
    }
    
    @objc func CallTapped(){
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblListWorkers{
            lblGiveServiceName.text = arr[indexPath.row]
            tblListWorkers.isHidden = true

        }
        if tableView == tblKinds{
            lblKind.text = arr[indexPath.row]
            tblKinds.isHidden = true
            
        }
        if tableView == tblHoursServices{
            lblHour.text = arr[indexPath.row]
            tblHoursServices.isHidden = true
            
        }
        if tableView == tblDates{
            lblDate.text = arr[indexPath.row]
            tblDates.isHidden = true
            
        }
    }

    
   @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        self.dismissKeyboard()
        return false
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
