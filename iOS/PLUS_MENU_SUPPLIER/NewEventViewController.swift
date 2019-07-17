//
//  NewEventViewController.swift
//  Bthere
//
//  Created by User on 12.9.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
import EventKit

protocol editTextInCellDelegate {
    func editTextInCell(_ section:Int,text:AnyObject)
}
//קבע אירוע - דרך תפריט פלוס
class NewEventViewController: UIViewController,editTextInCellDelegate,UIGestureRecognizerDelegate {
    
    let dateFormatt:DateFormatter = DateFormatter()
    
    var dicEvent:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    
    @IBOutlet weak var viewPage: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    //קבע אירוע
    @IBAction func btnAddEvent(_ sender: AnyObject) {
        if dicEvent["date"]?.description != nil && dicEvent["hours"]?.description != "" && dicEvent["name"]?.description != ""
        {
            saveEventInDeviceCalander()
        }
        else
        {
            Alert.sharedInstance.showAlert("FILL_ALL_DATA".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnAddEvent: UIButton!
    
    var selectedSection = -1
    var textArr:Array<String> = ["EVENT_NAME".localized(LanguageMain.sharedInstance.USERLANGUAGE),"DATE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"HOUR".localized(LanguageMain.sharedInstance.USERLANGUAGE),"NOTES".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    
    //MARK: ---------initial ---------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = "NEW_EVENT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        btnAddEvent.setTitle("SET_EVENT".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        btnAddEvent.titleLabel?.font = UIFont (name: "OpenSansHebrew-Light", size: 18)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.alwaysBounceVertical = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: -------table view -------
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSection != -1 && section == selectedSection//אם לחצו על אחד הסלים לפתיחה
        {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        //הסל הדיפולטיבי - טקסט
        let  cell = tableView.dequeueReusableCell(withIdentifier: "NewEventTableViewCell")as! NewEventTableViewCell
        cell.delegate = self
        
        if indexPath.row == 0
        {
            cell.setDisplatData(textArr[indexPath.section])
            
            if indexPath.section != 0
            {
                cell.txtFText.isEnabled = false
                switch indexPath.section {
                case 1:
                    dateFormatt.dateFormat = "dd/MM/YYYY"
                    if dicEvent["date"]?.description != nil
                    {
                        cell.txtFText.text = dateFormatt.string(from: dicEvent["date"] as! Date)
                    }
                case 2:
                    cell.txtFText.text = dicEvent["hours"]?.description
                case 3:
                    cell.txtFText.text = dicEvent["remark"]?.description
                default:
                    cell.txtFText.text = dicEvent["name"]?.description
                }
            }
            else
            {
                cell.txtFText.text = dicEvent["name"]?.description
            }
            
            return cell
        }
            //הסל השני - תאריך
        else if indexPath.section == 1 && indexPath.row == 1
        {
            let  cellDate = tableView.dequeueReusableCell(withIdentifier: "NewEventDateTableViewCell")as! NewEventDateTableViewCell
            cellDate.delegate = self
            return cellDate
        }
            //הסל השלישי - שעות האירוע
        else if indexPath.section == 2 && indexPath.row == 1
        {
            let  cellHour = tableView.dequeueReusableCell(withIdentifier: "NewEventHoursTableViewCell")as! NewEventHoursTableViewCell
            cellHour.delegate = self
            return cellHour
        }
            //הסל הרביעי - הערות
        else if indexPath.section == 3 && indexPath.row == 1
        {
            let  cellRemark = tableView.dequeueReusableCell(withIdentifier: "NewEventRemarkTableViewCell")as! NewEventRemarkTableViewCell
            cellRemark.delegate = self
            return cellRemark
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        
        //לחיצה על אותו סל שפתוח כעת, סוגר אותו
        if selectedSection == indexPath.section && indexPath.row == 0// || indexPath.section == 0
        {
            selectedSection = -1
        }
        else
        {
            selectedSection = indexPath.section
        }
        
        tableView.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return self.view.frame.size.height / 15
        }
        else if indexPath.section == 3
        {
            return self.view.frame.size.height / 5
        }
        else if indexPath.section == 2
        {
            return self.view.frame.size.height / 4
        }
        else if indexPath.section == 1
        {
            return self.view.frame.size.height / 3
        }
        return 50
        
    }
    
    //שמירת הנתונים מהסלים בתוך הטקסט פילד ע״י דליגייט
    func editTextInCell(_ section:Int,text:AnyObject)
    {
        let indexPathToEdit:IndexPath = IndexPath(row: 0, section: section)
        (tableView.cellForRow(at: indexPathToEdit) as! NewEventTableViewCell).txtFText.text = text.description
        dateFormatt.dateFormat = "dd/MM/YYYY"
        switch section {
        case 0:
            dicEvent["name"] = text.description as AnyObject
        case 1:
            if text.description != ""
            {
                dicEvent["date"] = text as! Date as AnyObject
                (tableView.cellForRow(at: indexPathToEdit) as! NewEventTableViewCell).txtFText.text = dateFormatt.string(from: text as! Date)
            }
            else
            {
                dicEvent["date"] = text.description as AnyObject
            }
        case 2:
            dicEvent["hours"] = text.description as AnyObject
        case 3:
            dicEvent["remark"] = text.description as AnyObject
        default:
            dicEvent["name"] = text.description as AnyObject
        }
    }
    
    @objc func dismissKeyBoard()
    {
        view.endEditing(true)
    }
    
    //שמירת האירוע החדש במכשיר האישי
    func saveEventInDeviceCalander()
    {
        let calendar = Foundation.Calendar.current
        var startDate:Date?
        var endDate:Date?
        
        dateFormatt.dateFormat = "dd/MM/YYYY"
        var eventDate:Date = dicEvent["date"] as! Date
        
        //cut "12:40-15:50"
        if self.dicEvent["hours"] != nil
        {
            let hours : String = (self.dicEvent["hours"]?.description)!
            let hoursArr : [String] = hours.components(separatedBy: "-")
            
            let startHour : String = hoursArr[0]//12:40
            let endHour : String = hoursArr[1]//15:50
            
            dateFormatt.dateFormat = "HH:mm"
            
            var componentsmStart1 = (calendar as NSCalendar).components([.year,.month,.day,.hour, .minute], from: eventDate)
            componentsmStart1.hour = Int(startHour.components(separatedBy: ":")[0])!
            componentsmStart1.minute = Int(startHour.components(separatedBy: ":")[1])!
            
            let gregorian = Foundation.Calendar(identifier: .gregorian)
            eventDate = gregorian.date(from: componentsmStart1)!
              //\\print(eventDate)
            
            startDate = eventDate
            endDate = dateFormatt.date(from: endHour)!
            
            let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: startDate!)
            
            let componentsEnd = (calendar as NSCalendar).components([.hour, .minute], from: endDate!)
            
            //יצירת תאריכי התחלה וסיום לאירוע - ע״פ התאריך והשעות.
            startDate = Calendar.sharedInstance.getPartsOfDate( eventDate, to: componentsStart)
            endDate = Calendar.sharedInstance.getPartsOfDate(eventDate, to: componentsEnd)
            
            //בדיקה את התאריך סיום גדול מתאריך התחלה
            if small(endDate!, rhs: startDate!) == true
            {
                Alert.sharedInstance.showAlert("ILLEGAL_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
            }
            else
            {
                //יצירת האירוע
                let eventStore : EKEventStore = EKEventStore()
                
                eventStore.requestAccess(to: .event, completion: { (granted, error) in
                    if (granted) && (error == nil) {
                        let event = EKEvent(eventStore: eventStore)
                        if let _:String = self.dicEvent["name"] as? String {
                            event.title = (self.dicEvent["name"] as! String)
                        }
                        if let _:String = self.dicEvent["remark"] as? String {
                            event.notes = (self.dicEvent["remark"] as! String)
                            
                        }
                        //הוספתי את :by_BThere להערות לזיהוי שזהו אירוע שנקבע באפליקצית ביזר
                        event.isAllDay = false
                        event.startDate = startDate!
                        event.endDate = endDate!
                       //\\ event.notes = notes! + " :by_BThere"
                        
                        event.calendar = eventStore.defaultCalendarForNewEvents
                        do
                        {
                            try eventStore.save(event, span: .thisEvent)
                            Alert.sharedInstance.showAlert("SUCCESS_NEW_EVENT".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
                            
                        }
                        catch let e as NSError {
                              print(e)
                            return
                        }
                    } else {
                        let alert = UIAlertController(title: nil, message: "REQUEST_CALENDAR_PERMISION".localized(LanguageMain.sharedInstance.USERLANGUAGE), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OPEN_SETTINGS".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .default) { action in
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        })
                        alert.addAction(UIAlertAction(title: "CANCEL".localized(LanguageMain.sharedInstance.USERLANGUAGE), style: .cancel) { action in
                        })
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            Alert.sharedInstance.showAlert("NO_HOUR".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: self)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if touch.view!.isDescendant(of: tableView)
        {
            return false
        }
        return true
    }
    
    //compare between date
    func small(_ lhs: Date, rhs: Date) -> Bool {
        
        return lhs.compare(rhs) == .orderedAscending
    }
    
}
