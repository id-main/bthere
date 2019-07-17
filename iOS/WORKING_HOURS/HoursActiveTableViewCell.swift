//
//  HoursActiveTableViewCell.swift
//  Bthere
//
//  Created by User on 5.7.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

protocol datePickerDelegate
{
    func setDatePickerNull()
}

protocol hoursActiveDelegate {
    func checkValidityHours(_ index:Int)
}

protocol enabledBtnDaysDelegate {
    func enabledBtnDays()
    func enabledTrueBtnDays()
}
protocol ZeroDPMaxMinDelegte {
    func ZeroDPMaxMin()
}
//שעות פעילות בהרשמה
class HoursActiveTableViewCell: UITableViewCell,hoursActiveDelegate,enabledBtnDaysDelegate,datePickerDelegate,ZeroDPMaxMinDelegte {
    //   let timePicker = LFTimePickerController()
    //MARK: - Properties
    @IBOutlet weak var timePicker:LFTimePickerController!
    
    var generic = Generic()
    @IBOutlet weak var Blueview:UIView!
    @IBOutlet weak var MAINVIEW:UIView!
    @IBOutlet weak var BlueviewBorder:UIView!
    var DayFlagArr:Array<Int> = [0,0,0,0,0,0,0]
    var delagetReloadHeight:reloadTblDelegate!=nil
    
    var dateFormatter = DateFormatter()
    var outputFormatter: DateFormatter = DateFormatter()
    //MARK: - Outlet
    var frame1 = CGRect()
    var frame2 = CGRect()
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewBlack: UIView!
    @IBOutlet weak var viewSelectAll: UIView!
    @IBOutlet weak var lblHoursShow: UILabel!
    @IBOutlet weak var lblRestShow: UILabel!
    
    @IBOutlet weak var btnDay1: workingHoursBtn!
    @IBOutlet weak var btnDay2: workingHoursBtn!
    @IBOutlet weak var btnDay3: workingHoursBtn!
    @IBOutlet weak var btnDay4: workingHoursBtn!
    @IBOutlet weak var btnDay5: workingHoursBtn!
    
    //    @IBOutlet weak var btnDay7: dayCheckBox!
    @IBOutlet weak var btnDay6: workingHoursBtn!
    @IBOutlet weak var btnDay7: workingHoursBtn!
    var workingHoursButtonsArray:Array<workingHoursBtn> = Array()
    
    @IBOutlet weak var viewSelectAllDays: UIView!
    @IBOutlet weak var btnSelectAllDays: UIButton!
    @IBOutlet weak var dtFromHour: UIDatePicker!
    @IBOutlet weak var dtToHour: UIDatePicker!
    @IBOutlet weak var lblChooseAll: UILabel!
    @IBOutlet weak var FROM_LABEL:UILabel!
    @IBOutlet weak var UNTIL_LABEL:UILabel!
    @IBAction func btnSelectAllDays(_ sender: AnyObject)
    {
        //     isValidSelectAllDays()
        //        selectAll()
        toSelectAllOrNotToSelectThisIsTheQuestion()
    }
    
    
    @IBAction func btnDay7Action(_ sender: workingHoursBtn)
    {
        pressedButton(sender: sender)
        
    }
    @IBAction func btnDay6Action(_ sender: workingHoursBtn)
    {
        
        pressedButton(sender: sender)
        
    }
    @IBAction func btnDay5Action(_ sender: workingHoursBtn)
    {
        pressedButton(sender: sender)
    }
    @IBAction func btnDay4Action(_ sender: workingHoursBtn)
    {
        pressedButton(sender: sender)
    }
    @IBAction func btnDay3Action(_ sender: workingHoursBtn)
    {
        pressedButton(sender: sender)
    }
    @IBAction func btnDay2Action(_ sender: workingHoursBtn)
    {
        pressedButton(sender: sender)
    }
    @IBAction func btnDay1Action(_ sender: workingHoursBtn)
    {
        pressedButton(sender: sender)
    }
    
    
    
    
    
    
    func initButtonWorkingHours()
    {
        for x in Global.sharedInstance.arrWorkHours
        {
            print("arr work hours log: \(x.getDic())")
        }
        
        for x in Global.sharedInstance.arrWorkHoursChild
        {
            print("arr work hours child log: \(x.getDic())")
        }
        
        for x in Global.sharedInstance.arrWorkHoursRest
        {
            print("arr rest hours log: \(x.getDic())")
        }
        
        for x in Global.sharedInstance.arrWorkHoursRestChild
        {
            print("arr rest hours child log:  \(x.getDic())")
        }
        
        
        
        for  (index, buttonWeekDay) in workingHoursButtonsArray.enumerated()
        {
            buttonWeekDay.tag = index
            print("btn tag \(buttonWeekDay.tag)")
        }
        
        if  Global.sharedInstance.addRecess == false
        {
            //                    if Global.sharedInstance.arrWorkHours[1].iDayInWeekType == 0
            //                    {
            //                        for buttonWeekDay:workingHoursBtn in workingHoursButtonsArray
            //                        {
            //                            buttonWeekDay.backgroundColor = Colors.sharedInstance.color5
            //                            buttonWeekDay.stateBtn = 2
            //                            buttonWeekDay.layer.borderWidth = 0
            //                            buttonWeekDay.setTitleColor(.white, for: .normal)
            //                            buttonWeekDay.onBtn = false
            //                        }
            //
            //                    }buttonWeekDay:workingHoursBtn in workingHoursButtonsArray
            for buttonWeekDay:workingHoursBtn in workingHoursButtonsArray {
                var buttonFound:Bool = false
                for x in Global.sharedInstance.arrWorkHours
                {
                    
                    
                    if x.iDayInWeekType - 1 == buttonWeekDay.tag {
                        buttonWeekDay.hoursDictionary = x.getDic()
                        
                        
                        if x.nvFromHour == "" || x.nvToHour == ""
                        {
                            
                            buttonWeekDay.backgroundColor = Colors.sharedInstance.color5
                            buttonWeekDay.stateBtn = 2
                            buttonWeekDay.layer.borderWidth = 0
                            buttonWeekDay.setTitleColor(.white, for: .normal)
                            buttonWeekDay.onBtn = false
                        }
                        else if x.nvFromHour != "" && x.nvToHour != "00:00:00" && x.nvToHour != "" && x.nvFromHour != x.nvToHour
                        {
                            
                            buttonWeekDay.backgroundColor = Colors.sharedInstance.color4
                            buttonWeekDay.stateBtn = 0
                            buttonWeekDay.layer.borderWidth = 0
                            buttonWeekDay.setTitleColor(.white, for: .normal)
                            buttonWeekDay.onBtn = true
                        }
                        else
                        {
                            buttonWeekDay.backgroundColor = Colors.sharedInstance.color5
                            buttonWeekDay.stateBtn = 2
                            buttonWeekDay.layer.borderWidth = 0
                            buttonWeekDay.setTitleColor(.white, for: .normal)
                            buttonWeekDay.onBtn = false
                        }
                        
                        print("found selected one \(x.getDic())")
                        print("found selected one btn \(buttonWeekDay.hoursDictionary)")
                        buttonFound = true
                    }
                    
                }
                if buttonFound == false
                {
                    buttonWeekDay.backgroundColor = Colors.sharedInstance.color5
                    buttonWeekDay.stateBtn = 2
                    buttonWeekDay.layer.borderWidth = 0
                    buttonWeekDay.setTitleColor(.white, for: .normal)
                    buttonWeekDay.onBtn = false
                }
            }
        }
            
        else
        {
            
            for buttonWeekDay:workingHoursBtn in workingHoursButtonsArray {
                var buttonFound:Bool = false
                for x in Global.sharedInstance.arrWorkHoursRest
                {
                    
                    
                    if x.iDayInWeekType - 1 == buttonWeekDay.tag {
                        buttonWeekDay.hoursDictionary = x.getDic()
                        
                        
                        if x.nvFromHour == "" || x.nvToHour == ""
                        {
                            buttonWeekDay.backgroundColor = Colors.sharedInstance.color5
                            buttonWeekDay.stateBtn = 2
                            buttonWeekDay.layer.borderWidth = 0
                            buttonWeekDay.setTitleColor(.white, for: .normal)
                            buttonWeekDay.onBtn = false
                        }
                        else if x.nvFromHour != "" && x.nvToHour != "00:00:00" && x.nvToHour != "" && x.nvFromHour != x.nvToHour
                        {
                            buttonWeekDay.backgroundColor = Colors.sharedInstance.color3
                            buttonWeekDay.stateBtn = 0
                            buttonWeekDay.layer.borderWidth = 0
                            buttonWeekDay.setTitleColor(.white, for: .normal)
                            buttonWeekDay.onBtn = true
                        }
                        else
                        {
                            buttonWeekDay.backgroundColor = Colors.sharedInstance.color5
                            buttonWeekDay.stateBtn = 2
                            buttonWeekDay.layer.borderWidth = 0
                            buttonWeekDay.setTitleColor(.white, for: .normal)
                            buttonWeekDay.onBtn = false
                        }
                        
                        print("found selected one \(x.getDic())")
                        print("found selected one btn \(buttonWeekDay.hoursDictionary)")
                        print("found btn tag: \(buttonWeekDay.tag)")
                        buttonFound = true
                    }
                    
                }
                if buttonFound == false
                {
                    buttonWeekDay.backgroundColor = Colors.sharedInstance.color5
                    buttonWeekDay.stateBtn = 2
                    buttonWeekDay.layer.borderWidth = 0
                    buttonWeekDay.setTitleColor(.white, for: .normal)
                    buttonWeekDay.onBtn = false
                }
            }
            
            
        }
        
    }
    
    
    
    
    
    //////////////////////////////////////////
    //        var blueOrOrange:UIColor
    //        if  Global.sharedInstance.addRecess == false
    //        {
    //            blueOrOrange = Colors.sharedInstance.color4
    //        }
    //        else
    //        {
    //            blueOrOrange = Colors.sharedInstance.color3
    //        }
    
    //
    //        if Global.sharedInstance.arrWorkHours[1].iDayInWeekType == 0
    //        {
    //            for buttonWeekDay:workingHoursBtn in workingHoursButtonsArray
    //            {
    //                buttonWeekDay.backgroundColor = Colors.sharedInstance.color5
    //                buttonWeekDay.stateBtn = 2
    //                buttonWeekDay.layer.borderWidth = 0
    //                buttonWeekDay.setTitleColor(.white, for: .normal)
    //                buttonWeekDay.onBtn = false
    //            }
    //
    //        }
    //        else
    //        {
    //            for x in Global.sharedInstance.arrWorkHours {
    //                print("get dic motherfucker \(x.getDic())")
    //                for buttonWeekDay:workingHoursBtn in workingHoursButtonsArray
    //                {
    //
    //
    //                    if x.iDayInWeekType - 1 == buttonWeekDay.tag {
    //                        buttonWeekDay.hoursDictionary = x.getDic()
    //
    //
    //                        if x.nvFromHour == "" || x.nvToHour == ""
    //                        {
    //                            buttonWeekDay.backgroundColor = Colors.sharedInstance.color5
    //                            buttonWeekDay.stateBtn = 2
    //                            buttonWeekDay.layer.borderWidth = 0
    //                            buttonWeekDay.setTitleColor(.white, for: .normal)
    //                            buttonWeekDay.onBtn = false
    //                        }
    //                        else if x.nvFromHour != "" && x.nvToHour != "00:00:00" && x.nvToHour != "" && x.nvFromHour != x.nvToHour
    //                        {
    //                            buttonWeekDay.backgroundColor = blueOrOrange
    //                            buttonWeekDay.stateBtn = 0
    //                            buttonWeekDay.layer.borderWidth = 0
    //                            buttonWeekDay.setTitleColor(.white, for: .normal)
    //                            buttonWeekDay.onBtn = true
    //                        }
    //                        else
    //                        {
    //                            buttonWeekDay.backgroundColor = Colors.sharedInstance.color5
    //                            buttonWeekDay.stateBtn = 2
    //                            buttonWeekDay.layer.borderWidth = 0
    //                            buttonWeekDay.setTitleColor(.white, for: .normal)
    //                            buttonWeekDay.onBtn = false
    //                        }
    //                        print("found selected one \(x.getDic())")
    //                        print("found selected one btn \(buttonWeekDay.hoursDictionary)")
    //                    }
    //                }
    //            }
    //        }
    
    
    
    //    func initButtonsBreakingHours()
    //    {
    //        for  (index, buttonWeekDay) in workingHoursButtonsArray.enumerated()
    //        {
    //            buttonWeekDay.tag = index
    //            print("btn tag \(buttonWeekDay.tag)")
    //        }
    //
    //
    //    }
    
    
    
    func changeColorAndStateToButton(_ myBtn:workingHoursBtn)
    {
        let components = Foundation.Calendar.current.dateComponents([.hour, .minute], from: dtToHour.date)
        let hour = components.hour!
        print("dtToHour date: \(String(describing: dtToHour.date))")
        print("dtToHour time: \(String(describing: hour))")
        
        //blue or orange?
        var blueOrOrange:UIColor
        
        if  Global.sharedInstance.addRecess == false
        {
            blueOrOrange = Colors.sharedInstance.color4
        }
        else
        {
            blueOrOrange = Colors.sharedInstance.color3
        }
        
        //light blue  orange => dark grey
        
        if myBtn.backgroundColor == blueOrOrange
        {
            myBtn.backgroundColor = Colors.sharedInstance.color5
            myBtn.stateBtn = 2
            myBtn.layer.borderWidth = 0
            myBtn.setTitleColor(.white, for: .normal)
            myBtn.onBtn = false
            for btn:workingHoursBtn in workingHoursButtonsArray
            {
                if btn != myBtn && btn.backgroundColor == .clear
                {
                    
                    btn.backgroundColor = blueOrOrange
                    btn.stateBtn = 0
                    btn.layer.borderWidth = 0
                    btn.setTitleColor(.white, for: .normal)
                    btn.onBtn = true
                    
                }
            }
            if  Global.sharedInstance.addRecess == false
            {
                let neededtag = myBtn.tag
                let workingHoursTEST:objWorkingHours = objWorkingHours()
                Global.sharedInstance.arrWorkHours[neededtag] = workingHoursTEST
                Global.sharedInstance.isHoursSelected[neededtag] = false
                Global.sharedInstance.isHoursSelectedRest[neededtag] = false
                Global.sharedInstance.arrWorkHoursRest[neededtag] = workingHoursTEST
                
            }
            else if Global.sharedInstance.addRecess == true
            {
                let neededtag = myBtn.tag
                let workingHoursTEST:objWorkingHours = objWorkingHours()
                Global.sharedInstance.isHoursSelectedRest[neededtag] = false
                Global.sharedInstance.arrWorkHoursRest[neededtag] = workingHoursTEST
            }
            showSelectedRecessAndDays()
        }
            //dark gray color => clear
        else if myBtn.backgroundColor == Colors.sharedInstance.color5
        {
            myBtn.backgroundColor = .clear
            myBtn.stateBtn = 1
            myBtn.layer.borderWidth = 1
            myBtn.layer.borderColor = UIColor.black.cgColor
            myBtn.setTitleColor(.black, for: .normal)
            myBtn.onBtn = true
            for btn:workingHoursBtn in workingHoursButtonsArray
            {
                if btn != myBtn && btn.backgroundColor == .clear
                {
                    btn.backgroundColor = blueOrOrange
                    btn.stateBtn = 0
                    btn.layer.borderWidth = 0
                    btn.setTitleColor(.white, for: .normal)
                    btn.onBtn = true
                }
                
            }

            
        }
            //clear => light blue color / orange
        else if myBtn.backgroundColor == .clear
        {
            myBtn.backgroundColor = blueOrOrange
            myBtn.stateBtn = 0
            myBtn.layer.borderWidth = 0
            myBtn.setTitleColor(.white, for: .normal)
            myBtn.onBtn = true
            for btn:workingHoursBtn in workingHoursButtonsArray
            {
                if btn != myBtn && btn.backgroundColor == .clear
                {
                    btn.backgroundColor = blueOrOrange
                    btn.stateBtn = 0
                    btn.layer.borderWidth = 0
                    btn.setTitleColor(.white, for: .normal)
                    btn.onBtn = true
                }
                
            }
        }
    }
    
    
    func pressedButton(sender:workingHoursBtn) 
    {
        
        dtFromHour.isUserInteractionEnabled = true
        dtToHour.isUserInteractionEnabled = true
        
        if Global.sharedInstance.currentEditCellOpen == 1//משעות פעילות    Activity time
        {
            if Global.sharedInstance.addRecess == false//בוחר שעות ולא הפסקות    // Selects hours and not breaks
            {
                //////// see what is inside array at object tag
                
                print("what is in this day business working hours \(Global.sharedInstance.arrWorkHours)")
                
                // Validation of the previous day//בדיקת תקינות ליום הקודם
                if sender.stateBtn == 2//רוצה להדליק We want to light
                {
                    changeColorAndStateToButton(sender)
                    
                    if Global.sharedInstance.currentBtnDayTag != -1
                    {
                        Global.sharedInstance.lastBtnDayTag = Global.sharedInstance.currentBtnDayTag
                    }
                    else
                    {
                        Global.sharedInstance.lastBtnDayTag = sender.tag
                    }
                    
                    Global.sharedInstance.currentBtnDayTag = sender.tag
                    
                    //  Validation of the previous day    //בדיקת תקינות ליום הקודם
                    checkValidityHours(Global.sharedInstance.lastBtnDayTag)
                    
                    if Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] == false && Global.sharedInstance.isHoursSelected[Global.sharedInstance.lastBtnDayTag] == true && Global.sharedInstance.lastBtnDayTag != Global.sharedInstance.currentBtnDayTag
                    {
                        Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] = true
                    }
                    //מופעל רק על היום הקודם...// Only on previous day ...
                    //אם גלל שעת התחלה וסיום זהות// If you have a start time and end identity,
                    //(אם גולל שעות לא תקינות מופעל ב handeleDatePicker)// (If invalid hours are rolled in
                    if Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] == true && Global.sharedInstance.lastBtnDayTag != Global.sharedInstance.currentBtnDayTag
                    {
                        checkHoursEquals(Global.sharedInstance.lastBtnDayTag)
                    }
                    //אתחול הדייט פיקר// Start Date Picker
                    
                    if Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] == true
                    {
                        setDatePickerHoursBySelected(sender.tag + 1)
                    }
                    else
                    {
                        setDatePickerToZero()
                    }
                    
                    
                    Global.sharedInstance.isHoursSelected[sender.tag] = true
                    
                    
                    
                    showSelectedHoursAndDays()
                    checkIfSelectAll()
                    //                    showSelectedHoursAndDaysChild()
                }
                else if sender.stateBtn == 0 //מכבה // Shutdown or remove hours from global
                {
                    if Global.sharedInstance.isSelectAllHours == true
                    {
                        Global.sharedInstance.isSelectAllHours = false
                        Global.sharedInstance.isSelectAllRest = false
                        
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    }
                    changeColorAndStateToButton(sender)
                    //JMODE this is one fix
                    var workingHoursTEST:objWorkingHours = objWorkingHours()
                    workingHoursTEST = objWorkingHours(
                        _iDayInWeekType: sender.tag,
                        _nvFromHour: "00:00:00",
                        _nvToHour: "00:00:00")
                    Global.sharedInstance.arrWorkHours[sender.tag] = workingHoursTEST
                    Global.sharedInstance.arrWorkHoursRest[sender.tag] = workingHoursTEST
                    //END ONE fix
                    Global.sharedInstance.isHoursSelected[sender.tag] = false
                    Global.sharedInstance.isHoursSelectedRest[sender.tag] = false

                    
                    showSelectedHoursAndDaysChild()
                    showSelectedHoursAndDays()
                    checkIfSelectAll()
                    
                }
                else if sender.stateBtn == 1
                {
                    changeColorAndStateToButton(sender)
                    if Global.sharedInstance.currentBtnDayTag != -1
                    {
                        Global.sharedInstance.lastBtnDayTag = Global.sharedInstance.currentBtnDayTag
                    }
                    else
                    {
                        Global.sharedInstance.lastBtnDayTag = sender.tag
                    }
                    
                    Global.sharedInstance.currentBtnDayTag = sender.tag
                    
                    //  Validation of the previous day    //בדיקת תקינות ליום הקודם
                    checkValidityHours(Global.sharedInstance.lastBtnDayTag)
                    
                    if Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] == false && Global.sharedInstance.isHoursSelected[Global.sharedInstance.lastBtnDayTag] == true && Global.sharedInstance.lastBtnDayTag != Global.sharedInstance.currentBtnDayTag
                    {
                        Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] = true
                    }
                    //מופעל רק על היום הקודם...// Only on previous day ...
                    //אם גלל שעת התחלה וסיום זהות// If you have a start time and end identity,
                    //(אם גולל שעות לא תקינות מופעל ב handeleDatePicker)// (If invalid hours are rolled in
                    if Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] == true && Global.sharedInstance.lastBtnDayTag != Global.sharedInstance.currentBtnDayTag
                    {
                        checkHoursEquals(Global.sharedInstance.lastBtnDayTag)
                    }
                    //אתחול הדייט פיקר// Start Date Picker
                    //                    setDatePickerHoursBySelected(sender.tag + 1)
                    showSelectedHoursAndDaysChild()
                    showSelectedRecessAndDaysChild()
                    Global.sharedInstance.isHoursSelected[sender.tag] = true
                    
                    if Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] == false
                    {
                        setDatePickerToZero()
                    }
                    
                    
                    showSelectedHoursAndDays()
                    checkIfSelectAll()
                }
            }
            else//Selects breaks בוחר הפסקות
            {
                if sender.stateBtn == 2//מדליק highlight
                {
                    //black turns white
                    changeColorAndStateToButton(sender)
                    if Global.sharedInstance.currentBtnDayTagRest != -1
                    {
                        Global.sharedInstance.lastBtnDayTagRest = Global.sharedInstance.currentBtnDayTagRest
                    }
                    else
                    {
                        Global.sharedInstance.lastBtnDayTagRest = sender.tag
                    }
                    
                    Global.sharedInstance.currentBtnDayTagRest = sender.tag
                    
                    checkValidityHours(Global.sharedInstance.lastBtnDayTagRest)
                    
                    if Global.sharedInstance.fIsValidRest[Global.sharedInstance.lastBtnDayTagRest] == false && Global.sharedInstance.isHoursSelectedRest[Global.sharedInstance.lastBtnDayTagRest] == true && Global.sharedInstance.lastBtnDayTagRest != Global.sharedInstance.currentBtnDayTagRest
                    {
                        Global.sharedInstance.fIsValidRest[Global.sharedInstance.lastBtnDayTagRest] = true
                    }
                    //מופעל רק על היום הקודם...
                    //אם גלל שעת התחלה וסיום זהות,
                    //(אם גולל שעות לא תקינות מופעל ב handeleDatePicker)
                    if Global.sharedInstance.fIsValidRest[Global.sharedInstance.lastBtnDayTagRest] == true && Global.sharedInstance.lastBtnDayTagRest != Global.sharedInstance.currentBtnDayTagRest
                    {
                        checkHoursEquals(Global.sharedInstance.lastBtnDayTagRest)
                    }
                    //
                    if Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].iDayInWeekType != 0
                    {
                        //           Check whether the previously selected recesses are not within the range of hours, in case he changed the hours
                        //בדיקה אם ההפסקות שבחר בעבר אינן נמצאות בטווח של השעות, למקרה ששינה את השעות
                        if checkIfRestInHours(Global.sharedInstance.currentBtnDayTagRest) == false
                        {
                            Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest] = objWorkingHours()
                            Global.sharedInstance.isHoursSelectedRest[Global.sharedInstance.currentBtnDayTagRest]  = false
                        }
                    }
                    
                    setDatePickerRest(sender.tag)
                    
                    setDatePickerRestBySelected(sender.tag + 1)
                    checkValidityHours(Global.sharedInstance.lastBtnDayTag)
                    Global.sharedInstance.isHoursSelectedRest[sender.tag] = true
                    showSelectedRecessAndDays()
                    showSelectedRecessAndDaysChild()
                    checkIfSelectAll()
                }
                else if sender.stateBtn == 0
                {
                    //orange turns black
                    if Global.sharedInstance.isSelectAllRest == true
                        //if btnSelectAllDays.tag == 2//בחור
                    {
                        Global.sharedInstance.isSelectAllRest = false
                        //btnSelectAllDays.tag = 1
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    }

                    //JMODE this is second fix
                    var workingHoursTEST:objWorkingHours = objWorkingHours()
                    workingHoursTEST = objWorkingHours(
                        _iDayInWeekType: sender.tag,
                        _nvFromHour: "00:00:00",
                        _nvToHour: "00:00:00")
                    Global.sharedInstance.arrWorkHoursRest[sender.tag] = workingHoursTEST
                    //END SECOND fix
                    Global.sharedInstance.isHoursSelectedRest[sender.tag] = false
                    changeColorAndStateToButton(sender)
                    showSelectedRecessAndDaysChild()
                    showSelectedRecessAndDays()
                    checkIfSelectAll()
                    //                    showSelectedRecessAndDays()
                    //            Global.sharedInstance.lastBtnDayTag = sender.tag//נוכחי
                    //            setDatePickerToDefult()
                }
                    
                else if sender.stateBtn == 1
                {
                    //white turns orange
                    changeColorAndStateToButton(sender)
                    if Global.sharedInstance.currentBtnDayTag != -1
                    {
                        Global.sharedInstance.lastBtnDayTag = Global.sharedInstance.currentBtnDayTag
                    }
                    else
                    {
                        Global.sharedInstance.lastBtnDayTag = sender.tag
                    }
                    
                    Global.sharedInstance.currentBtnDayTag = sender.tag
                    
                    //  Validation of the previous day    //בדיקת תקינות ליום הקודם
                    checkValidityHours(Global.sharedInstance.lastBtnDayTag)
                    
                    if Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] == false && Global.sharedInstance.isHoursSelected[Global.sharedInstance.lastBtnDayTag] == true && Global.sharedInstance.lastBtnDayTag != Global.sharedInstance.currentBtnDayTag
                    {
                        Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] = true
                    }
                    //מופעל רק על היום הקודם...// Only on previous day ...
                    //אם גלל שעת התחלה וסיום זהות// If you have a start time and end identity,
                    //(אם גולל שעות לא תקינות מופעל ב handeleDatePicker)// (If invalid hours are rolled in
                    if Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] == true && Global.sharedInstance.lastBtnDayTag != Global.sharedInstance.currentBtnDayTag
                    {
                        checkHoursEquals(Global.sharedInstance.lastBtnDayTag)
                    }
                    //אתחול הדייט פיקר// Start Date Picker
                    //                    setDatePickerHoursBySelected(sender.tag + 1)
                    showSelectedHoursAndDaysChild()
                    showSelectedRecessAndDaysChild()
                    Global.sharedInstance.isHoursSelected[sender.tag] = true
                    showSelectedHoursAndDays()
                    checkIfSelectAll()
                }
            }
            
        }
            
        else//הוספת עובדים
        {
            ///HERE ARE EMPLOYEES WORKING HOURS
            if Global.sharedInstance.addRecess == false//בחירת שעות ולא הפסקות
            {
                if sender.stateBtn == 2//מדליק
                {
                    changeColorAndStateToButton(sender)
                    if Global.sharedInstance.currentBtnDayTagChild != -1//כבר בחרו שעות ליום מסויים
                    {
                        Global.sharedInstance.lastBtnDayTagChild = Global.sharedInstance.currentBtnDayTagChild
                    }
                    else//בחירת שעות פעם ראשונה
                    {
                        Global.sharedInstance.lastBtnDayTagChild = sender.tag
                    }
                    
                    Global.sharedInstance.currentBtnDayTagChild = sender.tag
                    
                    
                    checkValidityHours(Global.sharedInstance.lastBtnDayTagChild)
                    
                    
                    if Global.sharedInstance.fIsValidHoursChild[Global.sharedInstance.lastBtnDayTagChild] == false && Global.sharedInstance.isHoursSelectedChild[Global.sharedInstance.lastBtnDayTagChild] == true && Global.sharedInstance.lastBtnDayTagChild != Global.sharedInstance.currentBtnDayTagChild
                    {
                        Global.sharedInstance.fIsValidHoursChild[Global.sharedInstance.lastBtnDayTagChild] = true
                    }
                    //מופעל רק על היום הקודם...
                    //אם גלל שעת התחלה וסיום זהות,
                    //(אם גולל שעות לא תקינות מופעל ב handeleDatePicker)
                    if Global.sharedInstance.fIsValidHoursChild[Global.sharedInstance.lastBtnDayTagChild] == true && Global.sharedInstance.lastBtnDayTagChild != Global.sharedInstance.currentBtnDayTagChild
                    {
                        checkHoursEquals(Global.sharedInstance.lastBtnDayTagChild)
                    }
                    
                    setDatePickerHoursBySelected_Workers(sender.tag + 1)
                    Global.sharedInstance.isHoursSelectedChild[sender.tag] = true
                    checkIfSelectAll()
                    showSelectedHoursAndDaysChild()
                    
                    
                }
                else if sender.stateBtn == 0//מכבה
                {
                    if Global.sharedInstance.isSelectAllHoursChild == true
                    {
                        Global.sharedInstance.isSelectAllHoursChild = false
                        Global.sharedInstance.isSelectAllRestChild = false
                        
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    }
                    changeColorAndStateToButton(sender)
                    
                    
                    //JMODE this is 3RD fix
                    var workingHoursTEST:objWorkingHours = objWorkingHours()
                    workingHoursTEST = objWorkingHours(
                        _iDayInWeekType: sender.tag,
                        _nvFromHour: "00:00:00",
                        _nvToHour: "00:00:00")
                    Global.sharedInstance.arrWorkHoursChild[sender.tag] = workingHoursTEST
                    Global.sharedInstance.arrWorkHoursRestChild[sender.tag] = workingHoursTEST
                    //END 3RD fix
                    Global.sharedInstance.isHoursSelectedChild[sender.tag] = false
                    Global.sharedInstance.isHoursSelectedRestChild[sender.tag] = false
                    
                    showSelectedHoursAndDaysChild()
                    showSelectedRecessAndDaysChild()
                    //להציג גם את ההפסקות, כי גם בהן נעשה שינוי
                }
                    
                else if sender.stateBtn == 1
                {
                    
                }
            }
            else//בוחר הפסקות
            {
                if sender.stateBtn == 2//מדליק
                {
                    changeColorAndStateToButton(sender)
                    if Global.sharedInstance.currentBtnDayTagRestChild != -1
                    {
                        Global.sharedInstance.lastBtnDayTagRestChild = Global.sharedInstance.currentBtnDayTagRestChild
                    }
                    else
                    {
                        Global.sharedInstance.lastBtnDayTagRestChild = sender.tag
                    }
                    
                    Global.sharedInstance.currentBtnDayTagRestChild = sender.tag
                    
                    checkValidityHours(Global.sharedInstance.lastBtnDayTagRest)
                    
                    
                    if Global.sharedInstance.fIsValidRestChild[Global.sharedInstance.lastBtnDayTagRestChild] == false && Global.sharedInstance.isHoursSelectedRestChild[Global.sharedInstance.lastBtnDayTagRestChild] == true && Global.sharedInstance.lastBtnDayTagRestChild != Global.sharedInstance.currentBtnDayTagRestChild
                    {
                        Global.sharedInstance.fIsValidRestChild[Global.sharedInstance.lastBtnDayTagRestChild] = true
                    }
                    //מופעל רק על היום הקודם...
                    //אם גלל שעת התחלה וסיום זהות,
                    //(אם גולל שעות לא תקינות מופעל ב handeleDatePicker)
                    if Global.sharedInstance.fIsValidRestChild[Global.sharedInstance.lastBtnDayTagRestChild] == true && Global.sharedInstance.lastBtnDayTagRestChild != Global.sharedInstance.currentBtnDayTagRestChild
                    {
                        checkHoursEquals(Global.sharedInstance.lastBtnDayTagRestChild)
                    }
                    if Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].iDayInWeekType != 0
                    {
                        //בדיקה אם ההפסקות שבחר בעבר אינן נמצאות בטווח של השעות, למקרה ששינה את השעות
                        if checkIfRestInHours(Global.sharedInstance.currentBtnDayTagRestChild) == false
                        {
                            Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild] = objWorkingHours()
                            Global.sharedInstance.isHoursSelectedRestChild[Global.sharedInstance.currentBtnDayTagRestChild]  = false
                        }
                    }
                    
                    setDatePickerRest(sender.tag)
                    
                    setDatePickerRestBySelected_Workers(sender.tag + 1)
                    
                    //setDatePickerRestBySelected(sender.tag + 1)
                    checkValidityHours(Global.sharedInstance.lastBtnDayTag)
                    Global.sharedInstance.isHoursSelectedRestChild[sender.tag] = true
                    checkIfSelectAll()
                    showSelectedHoursAndDaysChild()
                    showSelectedRecessAndDaysChild()
                }
                else if sender.stateBtn == 0
                    //מכבה
                {
                    if Global.sharedInstance.isSelectAllRestChild == true
                        //if btnSelectAllDays.tag == 2//בחור
                    {
                        Global.sharedInstance.isSelectAllRestChild = false
                        //btnSelectAllDays.tag = 1
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    }
                    changeColorAndStateToButton(sender)
                    //JMODE this is 4th fix
                    var workingHoursTEST:objWorkingHours = objWorkingHours()
                    workingHoursTEST = objWorkingHours(
                        _iDayInWeekType: sender.tag,
                        _nvFromHour: "00:00:00",
                        _nvToHour: "00:00:00")
                    Global.sharedInstance.arrWorkHoursRestChild[sender.tag] = workingHoursTEST
                    //END 4th fix
                    Global.sharedInstance.isHoursSelectedRestChild[sender.tag] = false
                    showSelectedHoursAndDaysChild()
                    showSelectedRecessAndDaysChild()
                    //showSelectedRecessAndDays()
                }
                    
                else if sender.stateBtn == 1
                {
                    
                }
            }
        }
        changeRectangleColorandBorder()
    }
    
    
    func toSelectAllOrNotToSelectThisIsTheQuestion()
    {
        let components = Foundation.Calendar.current.dateComponents([.hour, .minute], from: dtToHour.date)
        let hour = components.hour!
        if Global.sharedInstance.currentEditCellOpen == 1
        {
            if Global.sharedInstance.addRecess == false//בוחרים שעות פעילות ולא הפסקות
            {
                if Global.sharedInstance.isSelectAllHours == false
                    //if btnSelectAllDays.tag == 1// היה לא בחור
                {
                    if Global.sharedInstance.isHoursSelected.contains(true)//אם יש לפחות מישהו אחד שבחרו לו שעות
                    {
                        if Global.sharedInstance.currentBtnDayTag != -1 && hour != 0
                        {
                            
                            //btnSelectAllDays.tag = 2//- נהפך לבחור
                            btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                            //modifica aici
                            
                            for i in 0 ..< Global.sharedInstance.arrWorkHours.count
                            {
                                var workingHoursTEST:objWorkingHours = objWorkingHours()
                                workingHoursTEST = objWorkingHours(
                                    _iDayInWeekType: i+1,
                                    _nvFromHour: "00:00:00",
                                    _nvToHour: "00:00:00")
                                
                                //                            print("")
                                Global.sharedInstance.arrWorkHours[i].iDayInWeekType = i+1
                                
                                Global.sharedInstance.arrWorkHours[i].nvFromHour = Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvFromHour
                                
                                Global.sharedInstance.arrWorkHours[i].nvToHour = Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvToHour
                                
                                Global.sharedInstance.isHoursSelected[i] = true
                                
                                Global.sharedInstance.arrWorkHoursRest[i] = workingHoursTEST
                                //END SECOND fix
                                Global.sharedInstance.isHoursSelectedRest[i] = false
                                
                                showSelectedRecessAndDaysChild()
                                showSelectedRecessAndDays()
                                
                                
                                workingHoursButtonsArray[i].backgroundColor = Colors.sharedInstance.color4
                                workingHoursButtonsArray[i].stateBtn = 0
                                workingHoursButtonsArray[i].layer.borderWidth = 0
                                workingHoursButtonsArray[i].setTitleColor(.white, for: .normal)
                                workingHoursButtonsArray[i].onBtn = true
                            }
                            
                            dtFromHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvFromHour)!
                            dtToHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvToHour)!
                            
                            Global.sharedInstance.isSelectAllHours = true
                            showSelectedHoursAndDays()
                        }
                        else
                        {
                            // no btn selected
                            print("no btn selected")
                        }
                    }
                    else//אם עדין לא בחרו שעות לאף יום
                    {
                        Alert.sharedInstance.showAlert(
                            "CANT_SELECT_ALL_DAYS_BEFORE_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: Global.sharedInstance.GlobalDataVC!)
                    }
                }
                else//(tag=2) אם בחור נהפך ללא בחור
                {
                    Global.sharedInstance.isSelectAllHours = false
                    Global.sharedInstance.isSelectAllRest = false
                    
                    
                    //btnSelectAllDays.tag = 1//לא בחור
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    
                    for i in 0 ..< Global.sharedInstance.arrWorkHours.count
                    {
                        var workingHoursTEST:objWorkingHours = objWorkingHours()
                        workingHoursTEST = objWorkingHours(
                            _iDayInWeekType: i+1,
                            _nvFromHour: "00:00:00",
                            _nvToHour: "00:00:00")
                        
                        
                        Global.sharedInstance.isHoursSelected[i] = false
                        Global.sharedInstance.arrWorkHours[i] = workingHoursTEST
                        Global.sharedInstance.arrWorkHoursRest[i] = workingHoursTEST
                        
                        Global.sharedInstance.isHoursSelected[i] = false
                        Global.sharedInstance.isHoursSelectedRest[i] = false
                        
                        workingHoursButtonsArray[i].backgroundColor = Colors.sharedInstance.color5
                        workingHoursButtonsArray[i].stateBtn = 2
                        workingHoursButtonsArray[i].layer.borderWidth = 0
                        workingHoursButtonsArray[i].setTitleColor(.white, for: .normal)
                        workingHoursButtonsArray[i].onBtn = false
                    }
                    showSelectedHoursAndDays()
                    showSelectedRecessAndDays()
                    
                }
            }
            else//בוחרים הפסקות
            {
                if Global.sharedInstance.isSelectAllRest == false && Global.sharedInstance.isSelectAllHours == true
                {
                    if Global.sharedInstance.isHoursSelectedRest.contains(true)
                        //אם יש לפחות מישהו אחד שבחרו לו הפסקות
                    {

                        //עובר על ההפסקות ומוסיף לכולם את אותן השעות
                        if Global.sharedInstance.currentBtnDayTagRest != -1 {
//                        if let _:String =  Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvFromHour as String? {
//                            if let _:String =  Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvToHour as String? {


                        for i in 0 ..< Global.sharedInstance.arrWorkHoursRest.count
                            //bug one   for i in 0 ..< Global.sharedInstance.arrWorkHours.count
                        {
                            Global.sharedInstance.arrWorkHoursRest[i].iDayInWeekType = i+1
                            
                            Global.sharedInstance.arrWorkHoursRest[i].nvFromHour = Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvFromHour
                            
                            Global.sharedInstance.arrWorkHoursRest[i].nvToHour = Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvToHour
                            
                            Global.sharedInstance.isHoursSelectedRest[i] = true
                            
                            workingHoursButtonsArray[i].backgroundColor = Colors.sharedInstance.color3
                            workingHoursButtonsArray[i].stateBtn = 0
                            workingHoursButtonsArray[i].layer.borderWidth = 0
                            workingHoursButtonsArray[i].setTitleColor(.white, for: .normal)
                            workingHoursButtonsArray[i].onBtn = true
                        }
                            if let _:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvFromHour) as? Date {
                                if let _:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvToHour) as? Date {

                        dtFromHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvFromHour)!
                        dtToHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvToHour)!
                        
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                        
                        Global.sharedInstance.isSelectAllRest = true
                        showSelectedRecessAndDays()
                                }
                            }
                    }
                    else//אם לא בחרו הפסקות לאף יום
                    {
                        Alert.sharedInstance.showAlert("CANT_SELECT_ALL_DAYS_BEFORE_RECESS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: Global.sharedInstance.GlobalDataVC!)
                    }

                }
                else//(tag=2) אם בחור נהפך ללא בחור
                {
                    //asdasdasdasdada
                    Global.sharedInstance.isSelectAllRest = false
                    
                    //btnSelectAllDays.tag = 1//לא בחור
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    for i in 0 ..< Global.sharedInstance.arrWorkHoursRest.count
                    {
                        var workingHoursTEST:objWorkingHours = objWorkingHours()
                        workingHoursTEST = objWorkingHours(
                            _iDayInWeekType: i+1,
                            _nvFromHour: "00:00:00",
                            _nvToHour: "00:00:00")
                        
                        Global.sharedInstance.isHoursSelectedRest[i] = false
                        Global.sharedInstance.arrWorkHoursRest[i] = workingHoursTEST
                        
                        workingHoursButtonsArray[i].backgroundColor = Colors.sharedInstance.color5
                        workingHoursButtonsArray[i].stateBtn = 2
                        workingHoursButtonsArray[i].layer.borderWidth = 0
                        workingHoursButtonsArray[i].setTitleColor(.white, for: .normal)
                        workingHoursButtonsArray[i].onBtn = false
                    }
                    showSelectedRecessAndDays()
                    showSelectedHoursAndDays()
                    
                    
                    
                    
                    
                    btnDay1.onBtn = false
                    btnDay2.onBtn = false
                    btnDay3.onBtn = false
                    btnDay4.onBtn = false
                    btnDay5.onBtn = false
                    btnDay6.onBtn = false
                    btnDay7.onBtn = false
                }
                
            }
            }
        }
        else if Global.sharedInstance.currentEditCellOpen == 2//עובדים
        {
            if Global.sharedInstance.addRecess == false//בוחרים שעות פעילות ולא הפסקות
            {
                if Global.sharedInstance.isSelectAllHoursChild == false
                {
                    if Global.sharedInstance.isHoursSelectedChild.contains(true)//אם יש לפחות מישהו אחד שבחרו לו שעות
                    {
                        Global.sharedInstance.isSelectAllHoursChild = true
                        //- נהפך לבחור
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                        
                        for i in 0 ..< Global.sharedInstance.arrWorkHoursChild.count
                        {
                            Global.sharedInstance.arrWorkHoursChild[i].iDayInWeekType = i+1
                            
                            Global.sharedInstance.arrWorkHoursChild[i].nvFromHour = Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvFromHour
                            
                            Global.sharedInstance.arrWorkHoursChild[i].nvToHour = Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvToHour
                            
                            Global.sharedInstance.isHoursSelectedChild[i] = true
                        }
                        
                        dtFromHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvFromHour)!
                        dtToHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvToHour)!
                        
                        btnDay1.onBtn = true
                        btnDay2.onBtn = true
                        btnDay3.onBtn = true
                        btnDay4.onBtn = true
                        btnDay5.onBtn = true
                        btnDay6.onBtn = true
                        btnDay7.onBtn = true
                    }
                    else//אם עדין לא בחרו שעות לאף יום
                    {
                        Alert.sharedInstance.showAlert(
                            "CANT_SELECT_ALL_DAYS_BEFORE_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: Global.sharedInstance.GlobalDataVC!)
                    }
                }
                else//(tag=2) אם בחור נהפך ללא בחור
                {
                    Global.sharedInstance.isSelectAllHoursChild = false
                    
                    //לא בחור
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    
                    for i in 0 ..< Global.sharedInstance.arrWorkHoursChild.count
                    {
                        Global.sharedInstance.isHoursSelectedChild[i] = false
                    }
                    
                    btnDay1.onBtn = false
                    btnDay2.onBtn = false
                    btnDay3.onBtn = false
                    btnDay4.onBtn = false
                    btnDay5.onBtn = false
                    btnDay6.onBtn = false
                    btnDay7.onBtn = false
                }
            }
            else//בוחרים הפסקות
            {
                if Global.sharedInstance.isSelectAllRestChild == false
                    //if btnSelectAllDays.tag == 1// היה לא בחור
                {
                    if Global.sharedInstance.isHoursSelectedRestChild.contains(true)
                        //אם יש לפחות מישהו אחד שבחרו לו הפסקות
                    {
                        //עובר על ההפסקות ומוסיף לכולם את אותן השעות
                        for i in 0 ..< Global.sharedInstance.arrWorkHoursChild.count
                        {
                            Global.sharedInstance.arrWorkHoursRestChild[i].iDayInWeekType = i+1
                            
                            Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour = Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvFromHour
                            
                            Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour = Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvToHour
                            
                            Global.sharedInstance.isHoursSelectedRestChild[i] = true
                        }
                        
                        dtFromHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvFromHour)!
                        dtToHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvToHour)!
                        
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                        
                        Global.sharedInstance.isSelectAllRestChild = true
                        
                        btnDay1.onBtn = true
                        btnDay2.onBtn = true
                        btnDay3.onBtn = true
                        btnDay4.onBtn = true
                        btnDay5.onBtn = true
                        btnDay6.onBtn = true
                        btnDay7.onBtn = true
                    }
                    else//אם לא בחרו הפסקות לאף יום
                    {
                        Alert.sharedInstance.showAlert("CANT_SELECT_ALL_DAYS_BEFORE_RECESS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: Global.sharedInstance.GlobalDataVC!)
                    }
                }
                else//(tag=2) אם בחור נהפך ללא בחור
                {
                    Global.sharedInstance.isSelectAllRestChild = false
                    
                    //לא בחור
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    
                    for i in 0 ..< Global.sharedInstance.arrWorkHoursRestChild.count
                    {
                        Global.sharedInstance.isHoursSelectedRestChild[i] = false
                    }
                    
                    btnDay1.onBtn = false
                    btnDay2.onBtn = false
                    btnDay3.onBtn = false
                    btnDay4.onBtn = false
                    btnDay5.onBtn = false
                    btnDay6.onBtn = false
                    btnDay7.onBtn = false
                }
            }
        }
    }
    
    //Click on a day      //בלחיצה על יום
    @IBAction func btnDay(_ sender: AnyObject)
    {
        dtFromHour.isUserInteractionEnabled = true
        dtToHour.isUserInteractionEnabled = true
        //          print("btn day tag \(sender.tag)")
        //        for x in Global.sharedInstance.arrWorkHours {
        //            if x.iDayInWeekType == sender.tag + 1 {
        //                  print("found selected one \(x.getDic())")
        //            }
        //        }
        //modifica aici
        if Global.sharedInstance.currentEditCellOpen == 1//משעות פעילות    Activity time
        {
            if Global.sharedInstance.addRecess == false//בוחר שעות ולא הפסקות    // Selects hours and not breaks
            {
                //////// see what is inside array at object tag
                
                print("what is in this day business working hours \(Global.sharedInstance.arrWorkHours)")
                
                // Validation of the previous day//בדיקת תקינות ליום הקודם
                if (sender as! dayCheckBox).isCecked == false//רוצה להדליק We want to light
                {
                    (sender as! dayCheckBox).isCecked = true
                    
                    if Global.sharedInstance.currentBtnDayTag != -1
                    {
                        Global.sharedInstance.lastBtnDayTag = Global.sharedInstance.currentBtnDayTag
                    }
                    else
                    {
                        Global.sharedInstance.lastBtnDayTag = sender.tag
                    }
                    
                    Global.sharedInstance.currentBtnDayTag = sender.tag
                    
                    //  Validation of the previous day    //בדיקת תקינות ליום הקודם
                    checkValidityHours(Global.sharedInstance.lastBtnDayTag)
                    
                    if Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] == false && Global.sharedInstance.isHoursSelected[Global.sharedInstance.lastBtnDayTag] == true && Global.sharedInstance.lastBtnDayTag != Global.sharedInstance.currentBtnDayTag
                    {
                        Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] = true
                    }
                    //מופעל רק על היום הקודם...// Only on previous day ...
                    //אם גלל שעת התחלה וסיום זהות// If you have a start time and end identity,
                    //(אם גולל שעות לא תקינות מופעל ב handeleDatePicker)// (If invalid hours are rolled in
                    if Global.sharedInstance.fIsValidHours[Global.sharedInstance.lastBtnDayTag] == true && Global.sharedInstance.lastBtnDayTag != Global.sharedInstance.currentBtnDayTag
                    {
                        checkHoursEquals(Global.sharedInstance.lastBtnDayTag)
                    }
                    //אתחול הדייט פיקר// Start Date Picker
                    setDatePickerHoursBySelected(sender.tag + 1)
                    
                    Global.sharedInstance.isHoursSelected[sender.tag] = true
                    
                    checkIfSelectAll()
                    
                    showSelectedHoursAndDays()
                }
                else//מכבה // Shutdown or remove hours from global
                {
                    if Global.sharedInstance.isSelectAllHours == true
                    {
                        Global.sharedInstance.isSelectAllHours = false
                        Global.sharedInstance.isSelectAllRest = false
                        
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    }
                    (sender as! dayCheckBox).isCecked = false
                    //JMODE this is one fix
                    var workingHoursTEST:objWorkingHours = objWorkingHours()
                    workingHoursTEST = objWorkingHours(
                        _iDayInWeekType: sender.tag,
                        _nvFromHour: "00:00:00",
                        _nvToHour: "00:00:00")
                    Global.sharedInstance.arrWorkHours[sender.tag] = workingHoursTEST
                    Global.sharedInstance.arrWorkHoursRest[sender.tag] = workingHoursTEST
                    //END ONE fix
                    Global.sharedInstance.isHoursSelected[sender.tag] = false
                    Global.sharedInstance.isHoursSelectedRest[sender.tag] = false
                    
                    showSelectedHoursAndDays()
                    showSelectedRecessAndDays()
                    
                }
                //                }
            }
            else//Selects breaks בוחר הפסקות
            {
                if (sender as! dayCheckBox).isCecked == false//מדליק highlight
                {
                    (sender as! dayCheckBox).isCecked = true
                    if Global.sharedInstance.currentBtnDayTagRest != -1
                    {
                        Global.sharedInstance.lastBtnDayTagRest = Global.sharedInstance.currentBtnDayTagRest
                    }
                    else
                    {
                        Global.sharedInstance.lastBtnDayTagRest = sender.tag
                    }
                    
                    Global.sharedInstance.currentBtnDayTagRest = sender.tag
                    
                    checkValidityHours(Global.sharedInstance.lastBtnDayTagRest)
                    
                    if Global.sharedInstance.fIsValidRest[Global.sharedInstance.lastBtnDayTagRest] == false && Global.sharedInstance.isHoursSelectedRest[Global.sharedInstance.lastBtnDayTagRest] == true && Global.sharedInstance.lastBtnDayTagRest != Global.sharedInstance.currentBtnDayTagRest
                    {
                        Global.sharedInstance.fIsValidRest[Global.sharedInstance.lastBtnDayTagRest] = true
                    }
                    //מופעל רק על היום הקודם...
                    //אם גלל שעת התחלה וסיום זהות,
                    //(אם גולל שעות לא תקינות מופעל ב handeleDatePicker)
                    if Global.sharedInstance.fIsValidRest[Global.sharedInstance.lastBtnDayTagRest] == true && Global.sharedInstance.lastBtnDayTagRest != Global.sharedInstance.currentBtnDayTagRest
                    {
                        checkHoursEquals(Global.sharedInstance.lastBtnDayTagRest)
                    }
                    //
                    if Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].iDayInWeekType != 0
                    {
                        //           Check whether the previously selected recesses are not within the range of hours, in case he changed the hours
                        //בדיקה אם ההפסקות שבחר בעבר אינן נמצאות בטווח של השעות, למקרה ששינה את השעות
                        if checkIfRestInHours(Global.sharedInstance.currentBtnDayTagRest) == false
                        {
                            Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest] = objWorkingHours()
                            Global.sharedInstance.isHoursSelectedRest[Global.sharedInstance.currentBtnDayTagRest]  = false
                        }
                    }
                    
                    setDatePickerRest(sender.tag)
                    
                    setDatePickerRestBySelected(sender.tag + 1)
                    checkValidityHours(Global.sharedInstance.lastBtnDayTag)
                    Global.sharedInstance.isHoursSelectedRest[sender.tag] = true
                    checkIfSelectAll()
                    showSelectedRecessAndDays()
                }
                else//מכבה
                {
                    if Global.sharedInstance.isSelectAllRest == true
                        //if btnSelectAllDays.tag == 2//בחור
                    {
                        Global.sharedInstance.isSelectAllRest = false
                        //btnSelectAllDays.tag = 1
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    }
                    (sender as! dayCheckBox).isCecked = false
                    //JMODE this is second fix
                    var workingHoursTEST:objWorkingHours = objWorkingHours()
                    workingHoursTEST = objWorkingHours(
                        _iDayInWeekType: sender.tag,
                        _nvFromHour: "00:00:00",
                        _nvToHour: "00:00:00")
                    Global.sharedInstance.arrWorkHoursRest[sender.tag] = workingHoursTEST
                    //END SECOND fix
                    Global.sharedInstance.isHoursSelectedRest[sender.tag] = false
                    showSelectedRecessAndDays()
                    //            Global.sharedInstance.lastBtnDayTag = sender.tag//נוכחי
                    //            setDatePickerToDefult()
                }
            }
            // pana aici
            /////////////////////////////////////////
        }
        else//הוספת עובדים
        {
            ///HERE ARE EMPLOYEES WORKING HOURS
            if Global.sharedInstance.addRecess == false//בחירת שעות ולא הפסקות
            {
                if (sender as! dayCheckBox).isCecked == false//מדליק
                {
                    (sender as! dayCheckBox).isCecked = true
                    if Global.sharedInstance.currentBtnDayTagChild != -1//כבר בחרו שעות ליום מסויים
                    {
                        Global.sharedInstance.lastBtnDayTagChild = Global.sharedInstance.currentBtnDayTagChild
                    }
                    else//בחירת שעות פעם ראשונה
                    {
                        Global.sharedInstance.lastBtnDayTagChild = sender.tag
                    }
                    
                    Global.sharedInstance.currentBtnDayTagChild = sender.tag
                    
                    
                    checkValidityHours(Global.sharedInstance.lastBtnDayTagChild)
                    
                    
                    if Global.sharedInstance.fIsValidHoursChild[Global.sharedInstance.lastBtnDayTagChild] == false && Global.sharedInstance.isHoursSelectedChild[Global.sharedInstance.lastBtnDayTagChild] == true && Global.sharedInstance.lastBtnDayTagChild != Global.sharedInstance.currentBtnDayTagChild
                    {
                        Global.sharedInstance.fIsValidHoursChild[Global.sharedInstance.lastBtnDayTagChild] = true
                    }
                    //מופעל רק על היום הקודם...
                    //אם גלל שעת התחלה וסיום זהות,
                    //(אם גולל שעות לא תקינות מופעל ב handeleDatePicker)
                    if Global.sharedInstance.fIsValidHoursChild[Global.sharedInstance.lastBtnDayTagChild] == true && Global.sharedInstance.lastBtnDayTagChild != Global.sharedInstance.currentBtnDayTagChild
                    {
                        checkHoursEquals(Global.sharedInstance.lastBtnDayTagChild)
                    }
                    
                    setDatePickerHoursBySelected_Workers(sender.tag + 1)
                    Global.sharedInstance.isHoursSelectedChild[sender.tag] = true
                    checkIfSelectAll()
                    showSelectedHoursAndDaysChild()
                    
                    
                }
                else//מכבה
                {
                    if Global.sharedInstance.isSelectAllHoursChild == true
                    {
                        Global.sharedInstance.isSelectAllHoursChild = false
                        Global.sharedInstance.isSelectAllRestChild = false
                        
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    }
                    (sender as! dayCheckBox).isCecked = false
                    
                    
                    //JMODE this is 3RD fix
                    var workingHoursTEST:objWorkingHours = objWorkingHours()
                    workingHoursTEST = objWorkingHours(
                        _iDayInWeekType: sender.tag,
                        _nvFromHour: "00:00:00",
                        _nvToHour: "00:00:00")
                    Global.sharedInstance.arrWorkHoursChild[sender.tag] = workingHoursTEST
                    Global.sharedInstance.arrWorkHoursRestChild[sender.tag] = workingHoursTEST
                    //END 3RD fix
                    Global.sharedInstance.isHoursSelectedChild[sender.tag] = false
                    Global.sharedInstance.isHoursSelectedRestChild[sender.tag] = false
                    
                    showSelectedHoursAndDaysChild()
                    showSelectedRecessAndDaysChild()
                    //להציג גם את ההפסקות, כי גם בהן נעשה שינוי
                }
            }
            else//בוחר הפסקות
            {
                if (sender as! dayCheckBox).isCecked == false//מדליק
                {
                    (sender as! dayCheckBox).isCecked = true
                    if Global.sharedInstance.currentBtnDayTagRestChild != -1
                    {
                        Global.sharedInstance.lastBtnDayTagRestChild = Global.sharedInstance.currentBtnDayTagRestChild
                    }
                    else
                    {
                        Global.sharedInstance.lastBtnDayTagRestChild = sender.tag
                    }
                    
                    Global.sharedInstance.currentBtnDayTagRestChild = sender.tag
                    
                    checkValidityHours(Global.sharedInstance.lastBtnDayTagRest)
                    
                    
                    if Global.sharedInstance.fIsValidRestChild[Global.sharedInstance.lastBtnDayTagRestChild] == false && Global.sharedInstance.isHoursSelectedRestChild[Global.sharedInstance.lastBtnDayTagRestChild] == true && Global.sharedInstance.lastBtnDayTagRestChild != Global.sharedInstance.currentBtnDayTagRestChild
                    {
                        Global.sharedInstance.fIsValidRestChild[Global.sharedInstance.lastBtnDayTagRestChild] = true
                    }
                    //מופעל רק על היום הקודם...
                    //אם גלל שעת התחלה וסיום זהות,
                    //(אם גולל שעות לא תקינות מופעל ב handeleDatePicker)
                    if Global.sharedInstance.fIsValidRestChild[Global.sharedInstance.lastBtnDayTagRestChild] == true && Global.sharedInstance.lastBtnDayTagRestChild != Global.sharedInstance.currentBtnDayTagRestChild
                    {
                        checkHoursEquals(Global.sharedInstance.lastBtnDayTagRestChild)
                    }
                    if Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].iDayInWeekType != 0
                    {
                        //בדיקה אם ההפסקות שבחר בעבר אינן נמצאות בטווח של השעות, למקרה ששינה את השעות
                        if checkIfRestInHours(Global.sharedInstance.currentBtnDayTagRestChild) == false
                        {
                            Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild] = objWorkingHours()
                            Global.sharedInstance.isHoursSelectedRestChild[Global.sharedInstance.currentBtnDayTagRestChild]  = false
                        }
                    }
                    
                    setDatePickerRest(sender.tag)
                    
                    setDatePickerRestBySelected_Workers(sender.tag + 1)
                    
                    //setDatePickerRestBySelected(sender.tag + 1)
                    checkValidityHours(Global.sharedInstance.lastBtnDayTag)
                    Global.sharedInstance.isHoursSelectedRestChild[sender.tag] = true
                    checkIfSelectAll()
                    showSelectedHoursAndDaysChild()
                    showSelectedRecessAndDaysChild()
                }
                else//מכבה
                {
                    if Global.sharedInstance.isSelectAllRestChild == true
                        //if btnSelectAllDays.tag == 2//בחור
                    {
                        Global.sharedInstance.isSelectAllRestChild = false
                        //btnSelectAllDays.tag = 1
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    }
                    (sender as! dayCheckBox).isCecked = false
                    //JMODE this is 4th fix
                    var workingHoursTEST:objWorkingHours = objWorkingHours()
                    workingHoursTEST = objWorkingHours(
                        _iDayInWeekType: sender.tag,
                        _nvFromHour: "00:00:00",
                        _nvToHour: "00:00:00")
                    Global.sharedInstance.arrWorkHoursRestChild[sender.tag] = workingHoursTEST
                    //END 4th fix
                    Global.sharedInstance.isHoursSelectedRestChild[sender.tag] = false
                    showSelectedHoursAndDaysChild()
                    showSelectedRecessAndDaysChild()
                    //showSelectedRecessAndDays()
                }
            }
        }
        changeRectangleColorandBorder()
    }
    
    
    //MARK: - Initial
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        let USERDEF = UserDefaults.standard
        //JMODE ADDED ON 21.08.2018
        if USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            var scalingTransform : CGAffineTransform!
            scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
            self.Blueview.transform = scalingTransform
            dtFromHour.transform = scalingTransform
            dtToHour.transform = scalingTransform
        }
        FROM_LABEL.text = "FROM_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        UNTIL_LABEL.text = "UNTIL_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ///////////////////////////////////
        workingHoursButtonsArray = [btnDay1,btnDay2,btnDay3,btnDay4,btnDay5,btnDay6,btnDay7]
        initButtonWorkingHours()
        // aici init butoane
        
        
        for view in dtFromHour.subviews {
            
            let USERDEF = UserDefaults.standard
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                // 21.08.2018    view.semanticContentAttribute = .forceRightToLeft
                
            } else {
                //this must fix uipicker being flipped
                view.semanticContentAttribute = .forceLeftToRight
                
                
            }
        }
        for view in dtToHour.subviews {
            
            let USERDEF = UserDefaults.standard
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                //  21.08.2018     view.semanticContentAttribute = .forceRightToLeft
                
            } else {
                //this must fix uipicker being flipped
                view.semanticContentAttribute = .forceLeftToRight
                
                
            }
        }
        
        
        //1. Create a LFTimePickerController
        //        timePicker.delegate = self
        //        timePicker.timeType = .hour24
        //
        //
        //        Blueview.addSubview(timePicker)
        //
        //
        //        self.contentView.bringSubviewToFront(Blueview)
        //          Blueview.bringSubviewToFront(timePicker)
        //2. Present the timePicker
        //  self.navigationController?.pushViewController(timePicker, animated: true)
        
        //3. Implement the LFTimePickerControllerDelegate
        
        dateFormatter.dateFormat = "HH:mm:00"
        outputFormatter.dateFormat  = "HH:mm:00"
        dtFromHour.locale = Locale(identifier: "en_GB")//set datePicker to 24 format without am/pm
        dtToHour.locale = Locale(identifier: "en_GB")
        
        //        let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
        //        appDelegate.rtlRELOAD()
        
        
        //  if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
        //             dtFromHour.semanticContentAttribute = .ForceLeftToRight
        //             dtToHour.semanticContentAttribute = .ForceLeftToRight
        //fix flip
        //    }
        //
        //            UIView.appearance().semanticContentAttribute = .ForceLeftToRight
        ////            Blueview.semanticContentAttribute = .ForceRightToLeft
        ////            dtFromHour.semanticContentAttribute = .ForceLeftToRight
        ////            dtToHour.semanticContentAttribute = .ForceLeftToRight
        //
        //        } else {
        //            UIView.appearance().semanticContentAttribute = .ForceLeftToRight
        ////            Blueview.semanticContentAttribute = .ForceLeftToRight
        ////            dtFromHour.semanticContentAttribute = .ForceLeftToRight
        ////            dtToHour.semanticContentAttribute = .ForceLeftToRight
        //        }
        if(UIApplication.shared.userInterfaceLayoutDirection == UIUserInterfaceLayoutDirection.rightToLeft)
        {
            // self.transform = CGAffineTransformMakeScale(-1.0, 1.0)
            //
            //            Blueview.transform = CGAffineTransformMakeScale(-1.0, 1.0)
            //            dtFromHour.transform = CGAffineTransformMakeScale( -1.0, 1.0)
            //            dtToHour.transform = CGAffineTransformMakeScale(-1.0, 1.0)
            //            Global.sharedInstance.isFLIPPINGFORMLANGUAGE = false
            
        }
        
        //        if(UIApplication.sharedApplication().userInterfaceLayoutDirection == UIUserInterfaceLayoutDirection.RightToLeft)
        //        {
        //  if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
        //     self.transform = CGAffineTransformMakeScale(-1.0, 1.0)
        //            dtFromHour.transform = CGAffineTransformMakeScale(-1.0, 1.0)
        //            dtToHour.transform = CGAffineTransformMakeScale(-1.0, 1.0)
        //             print("RTL")
        //        }
        //            else{
        //            print("LTR")
        //        }
        //   print("buuu \(self.dtToHour.semanticContentAttribute.dire) \n \(self.dtFromHour.semanticContentAttribute) ")
        
        //        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
        //            //          //hebwr
        //            BlueviewBorder.hidden = true
        //            Blueview.hidden = true
        //        }
        
        lblHoursShow.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        lblHoursShow.numberOfLines = 0
        lblHoursShow.sizeToFit()
        lblRestShow.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        lblRestShow.numberOfLines = 0
        lblRestShow.sizeToFit()
        changeRectangleColorandBorder()
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 0 {  //register business
            //is first time
            dtToHour.isUserInteractionEnabled = false
            dtFromHour.isUserInteractionEnabled = false
            
            //  Blueview.backgroundColor = Colors.sharedInstance.color4
            //            Blueview.frame  = CGRectMake( dtFromHour.frame.origin.x - 10, viewBlack.frame.origin.y - 20 ,  dtToHour.frame.size.width * 2 + viewBlack.frame.size.width +  20, dtToHour.frame.size.height  + 20 )
            
        } else  {
            //update screen
            dtToHour.isUserInteractionEnabled = true
            dtFromHour.isUserInteractionEnabled = true
            onetime()
            //            showSelectedHoursAndDaysChild()
            //            showSelectedRecessAndDaysChild()
        }
        //        lblHoursShow.numberOfLines = 0
        //        lblRestShow.numberOfLines = 0
        
        
        
        
        btnDay1.setTitle("SUNDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay2.setTitle("MONDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay3.setTitle("TUESDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay4.setTitle("WEDNSDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay5.setTitle("THIRTHDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay6.setTitle("FRIDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay7.setTitle("SHABAT2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        
        lblChooseAll.text = "CHOOSE_ALL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        
        
        
        self.contentView.bringSubviewToFront(viewSelectAllDays)
        Global.sharedInstance.isFirstHoursOpen = true
        Global.sharedInstance.GlobalDataVC?.delegateActiveHours = self
        viewSelectAllDays.isHidden = true
        
        
        
        dtFromHour.date = dateFormatter.date(from: "00:00:00")!
        dtToHour.date = dateFormatter.date(from: "00:00:00")!
        
        dtToHour.addTarget(self, action: #selector(ItemInSection2TableViewCell.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        dtFromHour.addTarget(self, action: #selector(ItemInSection2TableViewCell.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectAllTap))
        viewSelectAllDays.addGestureRecognizer(tap)
        
        btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
        if  Global.sharedInstance.defaults.integer(forKey: "ISFROMSETTINGS") == 0 {
            Global.sharedInstance.isSelectAllHours = false
            Global.sharedInstance.isSelectAllRest = false
            Global.sharedInstance.lastBtnDayTag = -1
            Global.sharedInstance.lastBtnDayTagRest = -1
            setDatePickerNull()
        }
        //modifica aici
        if Global.sharedInstance.addRecess == true
        {
            
            enabledBtnDays()
            
        }
        lblHoursShow.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        lblHoursShow.numberOfLines = 0
        lblRestShow.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        lblRestShow.numberOfLines = 0
        
    }
    //modifica aici
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        print("n//////////////////////")
        for a in Global.sharedInstance.isHoursSelectedRest {
            print("22hselectedrest \(a)")
        }
        changeRectangleColorandBorder()

        print("n/////////////////////")
        if Global.sharedInstance.addRecess == true//לחצו על הפסקות
        {

            if Global.sharedInstance.currentEditCellOpen == 1//שעות פעילות
            {

                //אתחול הכפתור של ה"סמן את כל הימים"


                if Global.sharedInstance.isSelectAllRest == true//בחור
                {
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                }
                else//לא בחור
                {
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                }

                if Global.sharedInstance.isFirstRecessHoursOpen == false // אם זה פעם ראשונה מאתחל את הדייט פיקר של ההפסקות ב-0
                {
                    Global.sharedInstance.isFirstRecessHoursOpen = true

                    if ( Global.sharedInstance.isSelectAllHours == true && Global.sharedInstance.isSelectAllRest == true)
                    {
                        for i in 0 ..< 7
                        {

                            Global.sharedInstance.isHoursSelectedRest[i] = true//איפוס המערך של הפלאגים

                            switch i
                            {
                            case 0:
                                btnDay1.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 1:
                                btnDay2.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 2:
                                btnDay3.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 3:
                                btnDay4.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 4:
                                btnDay5.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 5:
                                //                            btnDay6.isCecked = Global.sharedInstance.isHoursSelectedRest[i]
                                btnDay6.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 6:
                                btnDay7.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break

                            default:
                                break
                            }
                        }
                        if Global.sharedInstance.currentBtnDayTagRest != -1
                        {
                            setDatePickerRestBySelected(Global.sharedInstance.currentBtnDayTagRest + 1)
                        }
                    }
                    else
                    {
                        for i in 0 ..< 7
                        {
                            Global.sharedInstance.isHoursSelectedRest[i] = false//איפוס המערך של הפלאגים

                            switch i
                            {
                            case 0:
                                btnDay1.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 1:
                                btnDay2.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 2:
                                btnDay3.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 3:
                                btnDay4.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 4:
                                btnDay5.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 5:
                                //                            btnDay6.isCecked = Global.sharedInstance.isHoursSelectedRest[i]
                                btnDay6.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 6:
                                btnDay7.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break

                            default:
                                break
                            }
                        }
                        if Global.sharedInstance.currentBtnDayTagRest != -1
                        {
                            setDatePickerRestBySelected(Global.sharedInstance.currentBtnDayTagRest + 1)
                        }
                    }



                }
                    //אם זה לא פעם ראשונה וזה אחרי שפתחו שוב את השעות פעילות
                    //אתחול ההפסקות בהתאם למי שנבחר כבר(אם נבחר)
                else if Global.sharedInstance.onOpenRecessHours == true
                {
                    //modifica aici
                    initButtonWorkingHours()
                    showSelectedRecessAndDays()
                    Global.sharedInstance.onOpenRecessHours = false

                    for i in 0 ..< 7
                    {
                        switch i
                        {
                        case 0:
                            btnDay1.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 1:
                            btnDay2.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 2:
                            btnDay3.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 3:
                            btnDay4.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 4:
                            btnDay5.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 5:
                            //                            btnDay6.isCecked = Global.sharedInstance.isHoursSelectedRest[i]
                            btnDay6.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 6:
                            btnDay7.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        default:
                            break
                        }
                    }
                    if Global.sharedInstance.currentBtnDayTagRest != -1
                    {
                        setDatePickerRestBySelected(Global.sharedInstance.currentBtnDayTagRest + 1)
                    }
                }
            }
            else//עובדים
            {
                //אתחול הכפתור של ה"סמן את כל הימים"
                if Global.sharedInstance.isSelectAllRestChild == true//בחור
                {
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                }
                else//לא בחור
                {
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                }

                //מאתחל את הדייט פיקר של ההפסקות ב-0
                //אם זה פעם ראשונה או בהוספת עובד חדש או אם זה מעריכה וגם אין לו הפסקות
                if !Global.sharedInstance.isHoursSelectedRestChild.contains(true) && (Global.sharedInstance.isOpenNewWorker == true || Global.sharedInstance.isFromSave == false)
                    || (Global.sharedInstance.isFromEdit == true && !Global.sharedInstance.isHoursSelectedChild.contains(true))
                {
                    for i in 0 ..< 7
                    {
                        Global.sharedInstance.isHoursSelectedRestChild[i] = false//איפוס המערך של הפלאגים
                        switch i
                        {
                        case 0:
                            btnDay1.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 1:
                            btnDay2.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 2:
                            btnDay3.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 3:
                            btnDay4.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 4:
                            btnDay5.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 5:
                            //                            btnDay6.isCecked = Global.sharedInstance.isHoursSelectedRest[i]
                            btnDay6.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 6:
                            btnDay7.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break

                        default:
                            break
                        }
                    }
                    if Global.sharedInstance.currentBtnDayTagRestChild != -1
                    {
                        setDatePickerRestBySelected_Workers(Global.sharedInstance.currentBtnDayTagRestChild + 1)
                    }
                    else
                    {
                        setDatePickerToZero()
                    }
                }

                    //אחרי שפתחו שוב את ההפסקות
                    //אתחול ההפסקות בהתאם למי שנבחר כבר(אם נבחר)
                else
                {
                    //אם זה מהוספת עובד חדש או בפעם הראשונה
                    if Global.sharedInstance.isOpenNewWorker == true || Global.sharedInstance.isFromSave == false
                    {
                        for i in 0 ..< 7
                        {
                            switch i
                            {
                            case 0:
                                btnDay1.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 1:
                                btnDay2.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 2:
                                btnDay3.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 3:
                                btnDay4.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 4:
                                btnDay5.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 5:
                                //                            btnDay6.isCecked = Global.sharedInstance.isHoursSelectedRest[i]
                                btnDay6.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 6:
                                btnDay7.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            default:
                                break
                            }
                        }

                        if Global.sharedInstance.currentBtnDayTagRestChild != -1
                        {
                            setDatePickerRestBySelected_Workers(Global.sharedInstance.currentBtnDayTagRestChild + 1)
                        }

                    }
                    else if Global.sharedInstance.isServiceProviderEditOpen == true//מעריכה
                    {
                        for i in 0 ..< 7
                        {
                            switch i
                            {
                            case 0:
                                btnDay1.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 1:
                                btnDay2.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 2:
                                btnDay3.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 3:
                                btnDay4.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 4:
                                btnDay5.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 5:
                                //                            btnDay6.isCecked = Global.sharedInstance.isHoursSelectedRest[i]
                                btnDay6.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 6:
                                btnDay7.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            default:
                                break
                            }
                            setDatePickerRestBySelected_Workers(i+1)
                        }
                    }
                }
            }
        }
            //בפתיחה של השעות פעילות
        else if Global.sharedInstance.onOpenTimeOpenHours == true
        {
            initButtonWorkingHours()
            if Global.sharedInstance.currentEditCellOpen == 1//שעות פעילות
            {
                //אתחול הכפתור של ה"סמן את כל הימים"
                if Global.sharedInstance.isSelectAllHours == true//בחור
                {
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                }
                else//לא בחור
                {
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                }

                if !Global.sharedInstance.isHoursSelected.contains(true)
                    // אם זה פעם ראשונה מאתחל את הדייט פיקר של השעות ב-0
                {
                    Global.sharedInstance.isFirstHoursOpen = false

                    for i in 0 ..< 7
                    {
                        Global.sharedInstance.isHoursSelected[i] = false//איפוס המערך של הפלאגים
                        switch i
                        {
                        case 0:
                            btnDay1.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 1:
                            btnDay2.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 2:
                            btnDay3.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 3:
                            btnDay4.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 4:
                            btnDay5.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 5:
                            //                            btnDay6.isCecked = Global.sharedInstance.isHoursSelectedRest[i]
                            btnDay6.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 6:
                            btnDay7.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        default:
                            break
                        }
                        setDatePickerHoursBySelected(i+1)
                    }
                }
                    //אם זה לא פעם ראשונה וזה אחרי שפתחו שוב את השעות פעילות
                    //אתחול השעות בהתאם למי שנבחר כבר(אם נבחר)
                else if Global.sharedInstance.onOpenTimeOpenHours == true
                {
                    Global.sharedInstance.onOpenTimeOpenHours = false

                    for i in 0 ..< 7
                    {
                        //אתחול הכפתורים בהתאם למה שנבחר להם(שלא יציג לפי מה שנבחר בהפסקות)
                        switch i
                        {
                        case 0:
                            btnDay1.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 1:
                            btnDay2.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 2:
                            btnDay3.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 3:
                            btnDay4.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 4:
                            btnDay5.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 5:
                            //                            btnDay6.isCecked = Global.sharedInstance.isHoursSelectedRest[i]
                            btnDay6.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 6:
                            btnDay7.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        default:
                            break
                        }
                        //הצגת השעות שנחרו בפועל
                        setDatePickerHoursBySelected(i+1)
                    }
                }
            }
            else//עובדים
            {
                //אתחול הכפתור של ה"סמן את כל הימים"
                if Global.sharedInstance.isSelectAllHoursChild == true//בחור
                {
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                }
                else//לא בחור
                {
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                }

                //מאתחל את הדייט פיקר של השעות ב-0
                //אם  לא בחר שעות וגם - זה פעם ראשונה או בהוספת עובד חדש
                //או אם מעריכה ואין לו שעות
                if !Global.sharedInstance.isHoursSelectedChild.contains(true) && (Global.sharedInstance.isOpenNewWorker == true || Global.sharedInstance.isFromSave == false)
                    || (Global.sharedInstance.isFromEdit == true && !Global.sharedInstance.isHoursSelectedChild.contains(true))
                {
                    for i in 0 ..< 7
                    {
                        Global.sharedInstance.isHoursSelectedChild[i] = false//איפוס המערך של הפלאגים
                        switch i
                        {
                        case 0:
                            btnDay1.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 1:
                            btnDay2.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 2:
                            btnDay3.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 3:
                            btnDay4.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 4:
                            btnDay5.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 5:
                            //                            btnDay6.isCecked = Global.sharedInstance.isHoursSelectedRest[i]
                            btnDay6.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        case 6:
                            btnDay7.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                            break
                        default:
                            break
                        }
                        setDatePickerHoursBySelected_Workers(i+1)
                    }
                }

                    //אחרי שפתחו שוב את השעות
                    //אתחול השעות בהתאם למי שנבחר כבר(אם נבחר)
                else
                {
                    //אם זה מהוספת עובד חדש או בפעם הראשונה
                    if Global.sharedInstance.isOpenNewWorker == true || Global.sharedInstance.isFromSave == false
                    {
                        for i in 0 ..< 7
                        {
                            switch i
                            {
                            case 0:
                                btnDay1.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 1:
                                btnDay2.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 2:
                                btnDay3.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 3:
                                btnDay4.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 4:
                                btnDay5.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 5:
                                //                            btnDay6.isCecked = Global.sharedInstance.isHoursSelectedRest[i]
                                btnDay6.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 6:
                                btnDay7.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            default:
                                break
                            }
                            setDatePickerHoursBySelected_Workers(i+1)
                        }

                    }
                    else if Global.sharedInstance.isServiceProviderEditOpen == true//מעריכה
                    {
                        for i in 0 ..< 7
                        {
                            switch i
                            {
                            case 0:
                                btnDay1.onBtn = Global.sharedInstance.isHoursSelectedRest[i]

                                break
                            case 1:
                                btnDay2.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 2:
                                btnDay3.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 3:
                                btnDay4.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 4:
                                btnDay5.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 5:
                                //                            btnDay6.isCecked = Global.sharedInstance.isHoursSelectedRest[i]
                                btnDay6.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            case 6:
                                btnDay7.onBtn = Global.sharedInstance.isHoursSelectedRest[i]
                                break
                            default:
                                break
                            }
                            setDatePickerHoursBySelected_Workers(i+1)
                        }
                    }
                }
            }
        }
        onetime()
    }


    


    override func layoutSubviews(){
        //        dtToHour.semanticContentAttribute = .ForceLeftToRight
        //        dtFromHour.semanticContentAttribute = .ForceLeftToRight
        dtToHour.setValue(UIColor.white, forKeyPath: "textColor")
        dtFromHour.setValue(UIColor.white, forKeyPath: "textColor")
        dtToHour.backgroundColor = UIColor.black
        dtFromHour.backgroundColor = UIColor.black
        
    }
    
    //MARK: - DatePicker
    
    ///בלחיצה על ה-datePicker של השעות פעילות
  @objc func handleDatePicker(_ sender: UIDatePicker)
    {
        viewSelectAllDays.isHidden = false
        //        btnSelectAllDays.enabled = true
        
        //        let language = NSBundle.mainBundle().preferredLocalizations.first! as NSString
        
        
        //   outputFormatter.dateFormat = "HH:mm:00"
        
        if Global.sharedInstance.currentEditCellOpen == 1//שעות פעילות
        {
            if Global.sharedInstance.addRecess == false//בוחרים שעות פעילות ולא הפסקות
            {
                Blueview.backgroundColor = Colors.sharedInstance.color4
                Global.sharedInstance.workingHours = objWorkingHours()
                
                /*if language == "he"
                 {*/
                Global.sharedInstance.workingHours.nvFromHour = outputFormatter.string(from: dtFromHour.date)
                
                Global.sharedInstance.workingHours.nvToHour = outputFormatter.string(from: dtToHour.date)
                //}
                /*else
                 {
                 Global.sharedInstance.workingHours.nvFromHour = outputFormatter.stringFromDate(self.dtToHour.date)
                 
                 Global.sharedInstance.workingHours.nvToHour = outputFormatter.stringFromDate(dtFromHour.date)
                 }*/
                
                Global.sharedInstance.workingHours.iDayInWeekType = Global.sharedInstance.currentBtnDayTag + 1
                print("current btn day tag: \(Global.sharedInstance.currentBtnDayTag)")
                if Global.sharedInstance.currentBtnDayTag != -1 && self.workingHoursButtonsArray[Global.sharedInstance.currentBtnDayTag].stateBtn != 2 //אם לא בחר יום מסויים(וזה הפעם הראשונה) הנתונים לא נשמרים
                {
                    //שמירת שעה ליום מסויים ,השמירה דווקא כך ולא ע״י append כדי שיוכל לשנות את השעה וזה יתעדכן
                    Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag] = Global.sharedInstance.workingHours
                    
                    checkValidityHours(Global.sharedInstance.currentBtnDayTag)
                    
                    checkIfSelectAll()
                    // este valid?
                    if Global.sharedInstance.fIsValidHours[Global.sharedInstance.currentBtnDayTag] == false//לא תקין(שעת ההתחלה גדולה משעת הסיום)
                    {
                        if sender == dtFromHour
                        {
                            dtToHour.date = dtFromHour.date
                            Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvToHour = Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvFromHour
                            print("nvToHour 1: \(Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvToHour) ")
                            print("nvFromHour 1: \(Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvFromHour)")
                        }
                        else
                        {
                            dtFromHour.date = dtToHour.date
                            Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvFromHour = Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvToHour
                            print("nvToHour 2: \(Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvToHour) ")
                            print("nvFromHour 2: \(Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvFromHour)")
                        }
                        //ביטול בחירת היום הזה
                        checkHoursEquals(Global.sharedInstance.currentBtnDayTag)
                    }
                    showSelectedHoursAndDays()
                }
            }
                //breaking hours
            else//בוחרים הפסקות
            {
                Global.sharedInstance.workingHoursRest = objWorkingHours()
                
                //if language == "he"
                //{
                Global.sharedInstance.workingHoursRest.nvFromHour = outputFormatter.string(from: dtFromHour.date)
                
                Global.sharedInstance.workingHoursRest.nvToHour = outputFormatter.string(from: dtToHour.date)
                //}
                /*else
                 {
                 Global.sharedInstance.workingHoursRest.nvFromHour = outputFormatter.stringFromDate(dtToHour.date)
                 
                 Global.sharedInstance.workingHoursRest.nvToHour = outputFormatter.stringFromDate(dtFromHour.date)
                 }*/
                
                Global.sharedInstance.workingHoursRest.iDayInWeekType = Global.sharedInstance.currentBtnDayTagRest + 1
                
                
                if Global.sharedInstance.currentBtnDayTagRest != -1 && self.workingHoursButtonsArray[Global.sharedInstance.currentBtnDayTagRest].stateBtn != 0//אם לא בחר יום מסויים(וזה הפעם הראשונה) הנתונים לא נשמרים
                {
                    ///שמירת שעה ליום מסויים ,השמירה דווקא כך ולא ע״י append כדי שיוכל לשנות את השעה וזה יתעדכן
                    Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest] = Global.sharedInstance.workingHoursRest
                    
                    showSelectedRecessAndDays()//הצגת הפסקות שנבחרו על הלייבל
                    
                    checkValidityHours(Global.sharedInstance.currentBtnDayTagRest)
                    checkIfSelectAll()
                    
                    if Global.sharedInstance.fIsValidRest[Global.sharedInstance.currentBtnDayTagRest] == false//לא תקין(שעת ההתחלה גדולה משעת הסיום)
                    {
                        if sender == dtFromHour
                        {
                            dtToHour.date = dtFromHour.date
                            Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvToHour = Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvFromHour
                        }
                        else
                        {
                            dtFromHour.date = dtToHour.date
                            Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvFromHour = Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvToHour
                        }
                        //ביטול בחירת היום הזה
                        checkHoursEquals(Global.sharedInstance.currentBtnDayTagRest)
                    }
                    
                    showSelectedRecessAndDays()//הצגת הפסקות שנבחרו על הלייבל
                }
            }
        }
            
        else//בוחר לעובד
        {
            //בחירת שעות ולא הפסקות
            if Global.sharedInstance.addRecess == false
            {
                Global.sharedInstance.workingHoursChild = objWorkingHours()
                
                //if language == "he"
                // {
                Global.sharedInstance.workingHoursChild.nvFromHour = outputFormatter.string(from: dtFromHour.date)
                
                Global.sharedInstance.workingHoursChild.nvToHour = outputFormatter.string(from: dtToHour.date)
                // }
                /*else
                 {
                 Global.sharedInstance.workingHoursChild.nvFromHour = outputFormatter.stringFromDate(dtToHour.date)
                 
                 Global.sharedInstance.workingHoursChild.nvToHour = outputFormatter.stringFromDate(dtFromHour.date)
                 }*/
                
                Global.sharedInstance.workingHoursChild.iDayInWeekType = Global.sharedInstance.currentBtnDayTagChild + 1
                
                if Global.sharedInstance.currentBtnDayTagChild != -1//אם לא בחר יום מסויים(וזה הפעם הראשונה) הנתונים לא נשמרים
                {
                    ///שמירת שעה ליום מסויים,השמירה דווקא כך ולא ע״י append כדי שיוכל לשנות את השעה וזה יתעדכן
                    Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild] = Global.sharedInstance.workingHoursChild
                    
                    checkValidityHours(Global.sharedInstance.currentBtnDayTagChild)
                    
                    checkIfSelectAll()
                    
                    if Global.sharedInstance.fIsValidHoursChild[Global.sharedInstance.currentBtnDayTagChild] == false//לא תקין(שעת ההתחלה גדולה משעת הסיום)
                    {
                        //שעת התחלה אם היא מתאחרת לאחר שעת סיום צריך לעדכן את שעת סיום ולהשוותה לשעת התחלה עד שהמשתמש יעדכנה
                        if sender == dtFromHour
                        {
                            dtToHour.date = dtFromHour.date
                            Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvToHour = Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvFromHour
                        }
                        else
                        {
                            dtFromHour.date = dtToHour.date
                            Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvFromHour = Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvToHour
                        }
                        //ביטול בחירת היום הזה
                        checkHoursEquals(Global.sharedInstance.currentBtnDayTagChild)
                    }
                }
                showSelectedHoursAndDaysChild()
            }
                //בוחרים הפסקות
            else //if Global.sharedInstance.recessForWorker == true || Global.sharedInstance.recessForWorkerFromPlus
            {
                Global.sharedInstance.workingHoursRestChild = objWorkingHours()
                
                //if language == "he"
                // {
                Global.sharedInstance.workingHoursRestChild.nvFromHour = outputFormatter.string(from: dtFromHour.date)
                
                Global.sharedInstance.workingHoursRestChild.nvToHour = outputFormatter.string(from: dtToHour.date)
                //}
                /*else
                 {
                 Global.sharedInstance.workingHoursRestChild.nvFromHour = outputFormatter.stringFromDate(dtToHour.date)
                 
                 Global.sharedInstance.workingHoursRestChild.nvToHour = outputFormatter.stringFromDate(dtFromHour.date)
                 }*/
                
                Global.sharedInstance.workingHoursRestChild.iDayInWeekType = Global.sharedInstance.currentBtnDayTagRestChild + 1
                
                if Global.sharedInstance.currentBtnDayTagRestChild != -1//אם לא בחר יום מסויים(וזה הפעם הראשונה) הנתונים לא נשמרים
                {
                    ///שמירת שעה ליום מסויים ,השמירה דווקא כך ולא ע״י append כדי שיוכל לשנות את השעה וזה יתעדכן
                    Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild] = Global.sharedInstance.workingHoursRestChild
                    
                    //הצגת הפסקות שנבחרו על הלייבל
                    
                    checkValidityHours(Global.sharedInstance.currentBtnDayTagRestChild)
                    
                    checkIfSelectAll()
                    
                    if Global.sharedInstance.fIsValidRestChild[Global.sharedInstance.currentBtnDayTagRestChild] == false//לא תקין(שעת ההתחלה גדולה משעת הסיום)
                    {
                        //שעת תחילת הפסקה אם היא מתאחרת לאחר שעת סוף הפסקה צריך לעדכן את שעת סוף ההפסקה ולהשוותה לתחילת ההפסקה עד שהמשתמש יעדכנה
                        if sender == dtFromHour
                        {
                            dtToHour.date = dtFromHour.date
                            Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvToHour = Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvFromHour
                        }
                        else
                        {
                            dtFromHour.date = dtToHour.date
                            Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvFromHour = Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvToHour
                        }
                        //ביטול בחירת היום הזה
                        checkHoursEquals(Global.sharedInstance.currentBtnDayTagRestChild)
                    }
                    showSelectedRecessAndDaysChild()
                }
            }
        }
    }
    
    //מאתחל את הדייט פיקר של שעות פעילות ליום מסויים
    func setDatePickerHoursBySelected(_ index:Int)
    {
        dtFromHour.maximumDate = .none
        dtFromHour.minimumDate = .none
        dtToHour.maximumDate = .none
        dtToHour.minimumDate = .none
        
        var flag = false
        
        var toHourD:Date?
        var fromHourD:Date?
        
        //אם זה פעם ראשונה שפותח את השעות פעילות(גם אם פותח אחרי שבחר לעובדים לפני שבחר לעסק)
        if Global.sharedInstance.currentBtnDayTag == -1
        {
            setDatePickerToZero()
        }
        
        if Global.sharedInstance.arrWorkHours[index-1].iDayInWeekType == index//בחרתי כבר שעות ליום זה(היה דלוק ,נכבה ונדלק שוב)
        {
            if Global.sharedInstance.arrWorkHours[index-1].nvToHour != "" && Global.sharedInstance.arrWorkHours[index-1].nvFromHour != ""
            {
                //מאתחל את השעות לפי מה שכבר בחר
                fromHourD = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index-1].nvFromHour)
                toHourD = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index-1].nvToHour)
                
                dtFromHour.date = fromHourD!
                dtToHour.date = toHourD!
                
                flag = true
            }
        }
        
        var btnDay = false
        print("index value \(index)")
        switch index
        {
        case 1:
            btnDay = btnDay1.onBtn
            break
        case 2:
            btnDay = btnDay2.onBtn
            break
        case 3:
            btnDay = btnDay3.onBtn
            break
        case 4:
            btnDay = btnDay4.onBtn
            break
        case 5:
            btnDay = btnDay5.onBtn
            break
        case 6:
            btnDay = btnDay6.onBtn
            break
        case 7:
            btnDay = btnDay7.onBtn
            break
        default:
            break
        }
        print("btnDay value \(btnDay)")
        
        if flag == false//לא בחר שעות ליום הזה
        {
            if btnDay == true//אם לחץ על היום הזה כדי לבחור לו שעות
            {
                if Global.sharedInstance.lastBtnDayTag != -1//אם יש יום קודם -צריך לאתחל לפיו
                {
                    if Global.sharedInstance.arrWorkHours[Global.sharedInstance.lastBtnDayTag].nvFromHour != "" && Global.sharedInstance.arrWorkHours[Global.sharedInstance.lastBtnDayTag].nvToHour != ""
                    {
                        //הצגת התאריך בדייט פיקר לפי מה שבחר ביום הקודם
                        dtFromHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[Global.sharedInstance.lastBtnDayTag].nvFromHour)!
                        dtToHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[Global.sharedInstance.lastBtnDayTag].nvToHour)!
                        //שמירה במערך בגלובל
                        Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvFromHour = Global.sharedInstance.arrWorkHours[Global.sharedInstance.lastBtnDayTag].nvFromHour
                        Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvToHour = Global.sharedInstance.arrWorkHours[Global.sharedInstance.lastBtnDayTag].nvToHour
                        Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].iDayInWeekType = index
                    }
                        //אתחול לפי מה שמוצג עכשיו בפיקר,כדי לאפשר גלילה לפני שבוחרים יום
                    else if dateFormatter.string(from: dtToHour.date) != "" && dateFormatter.string(from: dtFromHour.date) != ""
                    {
                        //שמירה במערך בגלובל
                        Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvFromHour = dateFormatter.string(from: dtFromHour.date)
                        
                        Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvToHour = dateFormatter.string(from: dtToHour.date)
                        Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].iDayInWeekType = index
                    }
                        
                    else //אתחול דיפולטיבי
                    {
                        dtFromHour.date = dateFormatter.date(from: "00:00:00")!
                        dtToHour.date = dateFormatter.date(from: "00:00:00")!
                        Global.sharedInstance.lastBtnDayTag = index-1
                    }
                }
                else
                {
                    //אתחול דיפולטיבי
                    dtFromHour.date = dateFormatter.date(from: "00:00:00")!
                    dtToHour.date = dateFormatter.date(from: "00:00:00")!
                }
            }
        }
    }
    
    //מאתחל את השעות של העובדים ליום מסויים לפי מה שהמשתמש בחר
    func setDatePickerHoursBySelected_Workers(_ index:Int)
    {
        var flag = false
        
        var toHourD:Date?
        var fromHourD:Date?
        
        //אם זה לא מעריכה
        if Global.sharedInstance.hoursForWorkerFromEdit == false
        {
            if Global.sharedInstance.currentBtnDayTagChild == -1
            {
                setDatePickerToZero()
            }
                
            else if index-1 == Global.sharedInstance.currentBtnDayTagChild//בגלל שמגיעים לפה כמה פעמים כי זה מלולאה-אין צורך לאתחל לכל הימים אלא רק לפי הנוכחי(אם לא שאלה זו זה יאתחל לפי האחרון)
            {
                if Global.sharedInstance.arrWorkHoursChild[index-1].iDayInWeekType == index//אם כבר בחר ליום זה שעות,כיבה ועכשיו מדליק שוב
                {
                    if Global.sharedInstance.arrWorkHoursChild[index-1].nvToHour != "" && Global.sharedInstance.arrWorkHoursChild[index-1].nvFromHour != ""
                    {
                        fromHourD = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index-1].nvFromHour)
                        toHourD = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index-1].nvToHour)
                        
                        dtFromHour.maximumDate = .none
                        dtFromHour.minimumDate = .none
                        dtToHour.maximumDate = .none
                        dtToHour.minimumDate = .none
                        
                        dtFromHour.date = fromHourD!
                        dtToHour.date = toHourD!
                        
                        flag = true
                    }
                }
                
                var btnDay = false
                
                switch index {
                case 1:
                    btnDay = btnDay1.onBtn
                    break
                case 2:
                    btnDay = btnDay2.onBtn
                    break
                case 3:
                    btnDay = btnDay3.onBtn
                    break
                case 4:
                    btnDay = btnDay4.onBtn
                    break
                case 5:
                    btnDay = btnDay5.onBtn
                    break
                case 6:
                    btnDay = btnDay6.onBtn
                    break
                case 7:
                    btnDay = btnDay7.onBtn
                    break
                default:
                    break
                }
                
                if flag == false//לא בחר שעות ליום הזה
                {
                    if btnDay == true//מדליק את היום לבחירת שעות
                    {
                        //אם יש יום קודם שנבחרו לו שעות -יש לאתחל לפיו
                        if Global.sharedInstance.lastBtnDayTagChild != -1
                        {
                            if Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.lastBtnDayTagChild].nvFromHour != "" && Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.lastBtnDayTagChild].nvToHour != ""
                            {
                                //הצגת התאריך בדייט פיקר לפי מה שבחר ביום הקודם
                                dtFromHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.lastBtnDayTagChild].nvFromHour)!
                                dtToHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.lastBtnDayTagChild].nvToHour)!
                                //שמירה במערך בגלובל
                                Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvFromHour = Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.lastBtnDayTagChild].nvFromHour
                                Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvToHour = Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.lastBtnDayTagChild].nvToHour
                                Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].iDayInWeekType = index
                            }
                                //אתחול לפי מה שמוצג עכשיו בפיקר,כדי לאפשר גלילה לפני שבוחרים יום
                            else if dateFormatter.string(from: dtToHour.date) != "" && dateFormatter.string(from: dtFromHour.date) != ""
                            {
                                //שמירה במערך בגלובל
                                Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvFromHour = dateFormatter.string(from: dtFromHour.date)
                                Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvToHour = dateFormatter.string(from: dtToHour.date)
                                Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].iDayInWeekType = index
                            }
                            else
                            {
                                //אתחול דיפולטיבי
                                dtFromHour.date = dateFormatter.date(from: "00:00:00")!
                                dtToHour.date = dateFormatter.date(from: "00:00:00")!
                                Global.sharedInstance.lastBtnDayTagChild = index-1
                            }
                        }
                        else
                        {
                            //אתחול דיפולטיבי
                            dtFromHour.date = dateFormatter.date(from: "00:00:00")!
                            dtToHour.date = dateFormatter.date(from: "00:00:00")!
                        }
                    }
                }
            }
        }
        else//מעריכה
        {
            ///    print("Global.sharedInstance.arrWorkHoursChild \(Global.sharedInstance.arrWorkHoursChild)")
            //                if Global.sharedInstance.arrWorkHoursChild.count == 0 {
            //                    Global.sharedInstance.arrWorkHoursChild = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
            //                }
            if Global.sharedInstance.arrWorkHoursChild[index-1].iDayInWeekType == index//אם כבר בחר שעות ליום הזה
            {
                if Global.sharedInstance.arrWorkHoursChild[index-1].nvToHour != "" && Global.sharedInstance.arrWorkHoursChild[index-1].nvFromHour != ""
                {
                    //אתחול הפיקר בהתאם למה שכבר בחר(מה ששמור)
                    fromHourD = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index-1].nvFromHour)
                    toHourD = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index-1].nvToHour)
                    //איפוס המקסימום והמינימום למקרה שמגיע מהפסקות ואז זה מציג בפיקר לפי המקסימום והמינימום של היום האחרון שבחר לו הפסקות ולא את השעות
                    dtFromHour.maximumDate = .none
                    dtFromHour.minimumDate = .none
                    dtToHour.maximumDate = .none
                    dtToHour.minimumDate = .none
                    
                    dtFromHour.date = fromHourD!
                    dtToHour.date = toHourD!
                    
                    flag = true
                }
            }
            
            var btnDay = false
            
            switch index {
            case 1:
                btnDay = btnDay1.onBtn
                break
            case 2:
                btnDay = btnDay2.onBtn
                break
            case 3:
                btnDay = btnDay3.onBtn
                break
            case 4:
                btnDay = btnDay4.onBtn
                break
            case 5:
                btnDay = btnDay5.onBtn
                break
            case 6:
                btnDay = btnDay6.onBtn
            case 7:
                btnDay = btnDay7.onBtn
                break
            default:
                break
            }
            
            if flag == false//לא בחר שעות ליום הזה
            {
                if btnDay == true//אם לחץ על היום הזה כדי לבחור לו שעות
                {
                    if Global.sharedInstance.isVclicedForWorkerForEdit == true
                    {
                        if Global.sharedInstance.lastBtnDayTagChild != -1
                        {
                            if Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.lastBtnDayTagChild].nvFromHour != ""
                            {
                                //הצגת התאריך בדייט פיקר לפי מה שבחר ביום הקודם
                                dtFromHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.lastBtnDayTagChild].nvFromHour)!
                                dtToHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.lastBtnDayTagChild].nvToHour)!
                                //שמירה במערך בגלובל
                                Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvFromHour = Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.lastBtnDayTagChild].nvFromHour
                                Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvToHour = Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.lastBtnDayTagChild].nvToHour
                                Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].iDayInWeekType = index
                            }
                            else
                            {
                                //אתחול דיפולטיבי
                                dtFromHour.date = dateFormatter.date(from: "00:00:00")!
                                dtToHour.date = dateFormatter.date(from: "00:00:00")!
                                Global.sharedInstance.lastBtnDayTagChild = index-1
                            }
                        }
                    }
                    else
                    {
                        //אתחול דיפולטיבי
                        dtFromHour.date = dateFormatter.date(from: "00:00:00")!
                        dtToHour.date = dateFormatter.date(from: "00:00:00")!
                    }
                }
            }
        }
        showSelectedHoursAndDaysChild()
        showSelectedRecessAndDaysChild()
    }
    
    //מאתחל את ההפסקות ליום מסויים לפי מה שהמשתמש בחר
    func setDatePickerRestBySelected(_ index:Int)
    {
        var flag = false
        
        var toHourD:Date?
        var fromHourD:Date?
        
        if Global.sharedInstance.currentEditCellOpen == 1//שעות פעילות
        {
            if Global.sharedInstance.arrWorkHoursRest[index-1].iDayInWeekType == index//אם בחר הפסקות ליום הזה
            {
                if Global.sharedInstance.arrWorkHoursRest[index-1].nvToHour != "" && Global.sharedInstance.arrWorkHoursRest[index-1].nvFromHour != ""
                {
                    //אם ההפסקות שבחר בעבר נמצאות בטווח של השעות, למקרה ששינה את השעות
                    
                    fromHourD = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index-1].nvFromHour)
                    toHourD = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index-1].nvToHour)
                    
                    dtFromHour.date = fromHourD!
                    dtToHour.date = toHourD!
                    
                    flag = true
                }
            }
        }
        else//מעובדים
        {
            setDatePickerRestBySelected_Workers(index)
        }
    }
    
    //מאתחל את השעות של העובדים ליום מסויים לפי מה שהמשתמש בחר
    func setDatePickerRestBySelected_Workers(_ index:Int)
    {
        var toHourD:Date?
        var fromHourD:Date?
        
        if index-1 == Global.sharedInstance.currentBtnDayTagRestChild || Global.sharedInstance.currentBtnDayTagRestChild == -1
        {
            if Global.sharedInstance.isServiceProviderEditOpen == true//מעריכה
            {
                if Global.sharedInstance.arrWorkHoursRestChild[index-1].iDayInWeekType == index//אם כבר בחר שעות ליום הזה
                {
                    if Global.sharedInstance.arrWorkHoursRestChild[index-1].nvToHour != "" && Global.sharedInstance.arrWorkHoursRestChild[index-1].nvFromHour != ""
                    {
                        fromHourD = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[index-1].nvFromHour)
                        toHourD = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[index-1].nvToHour)
                        
                        dtFromHour.date = fromHourD!
                        dtToHour.date = toHourD!
                    }
                }
            }
            else
            {
                if Global.sharedInstance.isHoursSelectedRestChild[index-1] == false &&
                    Global.sharedInstance.arrWorkHoursRestChild[index-1].iDayInWeekType != 0//אם מדליק וגם נבחרו שעות
                {
                    dtFromHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[index-1].nvFromHour)!
                    dtToHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[index-1].nvToHour)!
                }
            }
        }
        showSelectedHoursAndDaysChild()
        showSelectedRecessAndDaysChild()
    }
    
    //אתחול הדייט פיקר לעובד חדש ומבטל את המקסימום והמינימום (אם יש)
    func setDatePickerToZero()
    {
        dtFromHour.maximumDate = .none
        dtFromHour.minimumDate = .none
        dtToHour.maximumDate = .none
        dtToHour.minimumDate = .none
        
        
        dtFromHour.date = dateFormatter.date(from: "00:00:00")!
        dtToHour.date = dateFormatter.date(from: "00:00:00")!
        dtFromHour.setDate(dtFromHour.date, animated: false)
        dtToHour.setDate(dtToHour.date, animated: false)
    }
    
    //איפוס הדייט פיקר בלחיצה על הפסקות שלא יציג לפי השעות פעילות
    func setDatePickerNull()
    {
        dtFromHour.date = dateFormatter.date(from: "00:00:00")!
        dtToHour.date = dateFormatter.date(from: "00:00:00")!
    }
    
    //אתחול ההפסקות
    //מקבלת אינדקס של יום
    func setDatePickerRest(_ index:Int)
    {
        var flag = false
        
        var toHourD:Date?
        var fromHourD:Date?
        
        if Global.sharedInstance.currentEditCellOpen == 1//שעות פעילות
        {
            for item in Global.sharedInstance.arrWorkHours
            {
                if item.iDayInWeekType == index + 1
                {
                    fromHourD = dateFormatter.date(from: item.nvFromHour)
                    toHourD = dateFormatter.date(from: item.nvToHour)
                    
                    dtFromHour.minimumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .minute, value: 30, to: fromHourD!, options: [])!
                    
                    dtFromHour.maximumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: -1, to: toHourD!, options: [])!
                    
                    dtToHour.minimumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 1, to: fromHourD!, options: [])!
                    
                    dtToHour.maximumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .minute, value: -30, to: toHourD!
                        , options: [])!
                    
                    if Global.sharedInstance.isHoursSelectedRest[index] == false && Global.sharedInstance.arrWorkHoursRest[index].iDayInWeekType == 0//אם מדליק וגם לא נבחרו שעות
                    {
                        dtFromHour.date = dtFromHour.minimumDate!
                        dtToHour.date = dtToHour.maximumDate!
                        //שמירה במערך בגלובל
                        Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvFromHour = dateFormatter.string(from: dtFromHour.date)
                        Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvToHour = dateFormatter.string(from: dtToHour.date)
                        Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].iDayInWeekType = Global.sharedInstance.currentBtnDayTagRest + 1
                    }
                    flag = true
                    break
                }
            }
            if !flag
            {
                
                //פקודות אלו מאפשרות לו לגלול את השעות ללא הגבלה של מקסימום ומינימום שנבחרו ליום אחר
                
                dtFromHour.maximumDate = .none
                dtFromHour.minimumDate = .none
                dtToHour.maximumDate = .none
                dtToHour.minimumDate = .none
                
                
                dtFromHour.date = dateFormatter.date(from: "00:00:00")!
                dtToHour.date = dateFormatter.date(from: "00:00:00")!
                dtFromHour.setDate(dtFromHour.date, animated: false)
                dtToHour.setDate(dtToHour.date, animated: false)
                
            }
        }
        else//מעובדים
        {
            for item in Global.sharedInstance.arrWorkHoursChild
            {
                if item.iDayInWeekType == index + 1
                {
                    fromHourD = dateFormatter.date(from: item.nvFromHour)
                    toHourD = dateFormatter.date(from: item.nvToHour)
                    
                    dtFromHour.minimumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .minute, value: 30, to: fromHourD!, options: [])!
                    
                    dtFromHour.maximumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: -1, to: toHourD!, options: [])!
                    
                    dtToHour.minimumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .hour, value: 1, to: fromHourD!, options: [])!
                    
                    dtToHour.maximumDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: .minute, value: -30, to: toHourD!
                        , options: [])!
                    
                    if Global.sharedInstance.isHoursSelectedRestChild[index] == false &&
                        Global.sharedInstance.arrWorkHoursRestChild[index].iDayInWeekType == 0 && Global.sharedInstance.currentBtnDayTagRestChild != -1//אם מדליק וגם לא נבחרו שעות
                    {
                        dtFromHour.date = dtFromHour.minimumDate!
                        dtToHour.date = dtToHour.maximumDate!
                        //שמירה במערך בגלובל
                        Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvFromHour = dateFormatter.string(from: dtFromHour.date)
                        Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvToHour = dateFormatter.string(from: dtToHour.date)
                        Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].iDayInWeekType = Global.sharedInstance.currentBtnDayTagRestChild + 1
                    }
                    flag = true
                }
            }
            if !flag
            {
                //פקודות אלו מאפשרות לו לגלול את השעות ללא הגבלה של מקסימום ומינימום שנבחרו ליום אחר
                
                dtFromHour.maximumDate = .none
                dtFromHour.minimumDate = .none
                dtToHour.maximumDate = .none
                dtToHour.minimumDate = .none
                
                
                dtFromHour.date = dateFormatter.date(from: "00:00:00")!
                dtToHour.date = dateFormatter.date(from: "00:00:00")!
                dtFromHour.setDate(dtFromHour.date, animated: false)
                dtToHour.setDate(dtToHour.date, animated: false)
                
            }
        }
        showSelectedHoursAndDaysChild()
        showSelectedRecessAndDaysChild()
    }
    
    //בדיקת תקינות לשעות-במעבר ליום הבא בדק את היום הקודם
    func checkValidityHours(_ index:Int)
    {
        print("ce index crash \(index)")
        if Global.sharedInstance.currentEditCellOpen == 1//שעות פעילות
        {
            if Global.sharedInstance.addRecess == false//שעות פעילות
            {
                if index != -1
                {
                    print("indexul este \(index)")
                    if Global.sharedInstance.arrWorkHours[index].iDayInWeekType != 0//כדי שלא יקרוס כשעדיין לא בחר ליום זה שעות
                    {
                        if let _:Date =  dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvFromHour) as? Date {
                            if let _:Date =  dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvToHour) as? Date {

                        let hhFromHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvFromHour)!
                        
                        let hhToHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvToHour)!
                        
                        //hours and minutes from hour - working
                        var hhFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourDate))
                        let mmFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourDate))
                        
                        //hours and minutes to hour - working
                        var hhToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourDate))
                        let mmToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourDate))
                        if Global.sharedInstance.isHoursSelectedRest[index] == true
                            // אם יש הפסקות ביום הזה
                        {
                            let hhFromHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index].nvFromHour)!
                            
                            //hours and minutes from hour - rest
                            var hhFromHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourRestDate))
                            let mmFromHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourRestDate))
                            
                            
                            let hhToHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index].nvToHour)!
                            
                            //hours and minutes to hour - rest
                            var hhToHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourRestDate))
                            let mmToHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourRestDate))
                            
                            if mmFromHour != 0//== 30
                            {
                                hhFromHour = hhFromHour + mmFromHour / 60 //+ 0.5
                            }
                            
                            if mmToHour != 0//== 30
                            {
                                hhToHour = hhToHour + mmToHour / 60//0.5
                            }
                            
                            if mmFromHourRest != 0 //== 30
                            {
                                hhFromHourRest = hhFromHourRest + mmFromHourRest / 60//0.5
                            }
                            
                            if mmToHourRest != 0 //== 30
                            {
                                hhToHourRest = hhToHourRest + mmToHourRest/60//0.5
                            }
                            //אם השעות לא תקינות
                            if hhFromHour > hhToHour
                            {
                                Global.sharedInstance.fIsValidHours[index] = false
                                //                                changeColorAndStateToButton(workingHoursButtonsArray[index - 5])
                                //                                changeColorAndStateToButton(workingHoursButtonsArray[index - 5])
                            }
                                //אם ההפסקות לא תקינות
                            else if hhFromHourRest > hhToHourRest
                            {
                                Global.sharedInstance.fIsValidRest[index] = false
                                //                                changeColorAndStateToButton(workingHoursButtonsArray[index - 5])
                                //                                changeColorAndStateToButton(workingHoursButtonsArray[index - 5])
                            }
                                //אם השעות וההפסקות לא תקינות
                            else if hhFromHour > hhFromHourRest || hhToHour < hhToHourRest
                            {
                                Global.sharedInstance.fIsValidHours[index] = false
                                Global.sharedInstance.fIsValidRest[index] = false
                                //                                changeColorAndStateToButton(workingHoursButtonsArray[index - 5])
                                //                                changeColorAndStateToButton(workingHoursButtonsArray[index - 5])
                                
                            }
                            else if hhFromHour == hhToHour
                            {
                                
                                //                                Global.sharedInstance.isHoursSelected[index] = false
                                Global.sharedInstance.fIsValidHours[index] = false
                                //                                changeColorAndStateToButton(workingHoursButtonsArray[index - 5])
                                //                                changeColorAndStateToButton(workingHoursButtonsArray[index - 5])
                            }
                                //אם תקין
                            else
                            {
                                Global.sharedInstance.fIsValidHours[index] = true
                                Global.sharedInstance.fIsValidRest[index] = true
                            }
                            
                        }
                            
                        else//אין הפסקות
                        {
                            if mmFromHour != 0//== 30
                            {
                                hhFromHour = hhFromHour + mmFromHour / 60 //+ 0.5
                            }
                            if mmToHour != 0//== 30
                            {
                                hhToHour = hhToHour + mmToHour / 60//0.5
                            }
                            
                            if hhFromHour > hhToHour
                            {
                                Global.sharedInstance.fIsValidHours[index] = false
                                Global.sharedInstance.isHoursSelected[index] = false
                                //                                changeColorAndStateToButton(workingHoursButtonsArray[index - 5])
                                //                                changeColorAndStateToButton(workingHoursButtonsArray[index - 5])
                            }
                            else if hhFromHour == hhToHour
                            {
                                
                                Global.sharedInstance.isHoursSelected[index] = false
                                Global.sharedInstance.fIsValidHours[index] = false
                                //                                Global.sharedInstance.fIsValidHours[index] = false
                                //                                changeColorAndStateToButton(workingHoursButtonsArray[index - 5])
                                //                                changeColorAndStateToButton(workingHoursButtonsArray[index - 5])
                            }
                            else
                            {
                                Global.sharedInstance.fIsValidHours[index] = true
                                Global.sharedInstance.isHoursSelected[index] = true
                            }
                            
                            
                        }
                    }
                }
                    }
                }
            }
            else//בוחר הפסקות
            {
                if index != -1
                {
                    if Global.sharedInstance.arrWorkHoursRest[index].iDayInWeekType != 0  && Global.sharedInstance.arrWorkHours[index].iDayInWeekType != 0 //כדי שלא יקרוס כשעדיין לא בחר ליום זה הפסקות
                    {
                        ///BUG BUG BUG
                        print("index value: \(index)")
                        print("array work hours la validare: ")
                        for x in Global.sharedInstance.arrWorkHours
                        {
                            print(x.getDic())
                        }
                        let hhFromHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvFromHour)!
                        
                        let hhToHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvToHour)!
                        
                        //hours and minutes from hour - working
                        var hhFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourDate))
                        let mmFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourDate))
                        
                        //hours and minutes to hour - working
                        var hhToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourDate))
                        let mmToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourDate))
                        if let _:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index].nvFromHour) as? Date {
                        if let _:Date =  dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index].nvToHour) as? Date {
                        let hhFromHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index].nvFromHour)!
                        
                        //hours and minutes from hour - rest
                        var hhFromHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourRestDate))
                        let mmFromHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourRestDate))


                        
                        let hhToHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index].nvToHour)!
                        
                        //hours and minutes to hour - rest
                        var hhToHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourRestDate))
                        let mmToHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourRestDate))
                        
                        if mmFromHour != 0//== 30
                        {
                            hhFromHour = hhFromHour + mmFromHour / 60
                        }
                        
                        if mmToHour != 0
                        {
                            hhToHour = hhToHour + mmToHour / 60
                        }
                        
                        if mmFromHourRest != 0
                        {
                            hhFromHourRest = hhFromHourRest + mmFromHourRest / 60
                        }
                        
                        if mmToHourRest != 0
                        {
                            hhToHourRest = hhToHourRest + mmToHourRest/60
                        }
                        //אם השעות לא תקינות
                        if hhFromHour > hhToHour
                        {
                            Global.sharedInstance.fIsValidHours[index] = false
                        }
                            //אם ההפסקות לא תקינות
                        else if hhFromHourRest > hhToHourRest
                        {
                            Global.sharedInstance.fIsValidRest[index] = false
                        }
                        else if hhFromHourRest == hhToHourRest
                        {
                            Global.sharedInstance.fIsValidRest[index] = false
                        }
                            //אם השעות וההפסקות לא תקינות
                        else if hhFromHour > hhFromHourRest || hhToHour < hhToHourRest
                        {
                            Global.sharedInstance.fIsValidHours[index] = false
                            Global.sharedInstance.fIsValidRest[index] = false
                            
                        }
                        else if hhFromHourRest == hhToHourRest
                        {
                            Global.sharedInstance.fIsValidRest[index] = false
                        }
                            //אם תקין
                        else
                        {
                            Global.sharedInstance.fIsValidHours[index] = true
                            Global.sharedInstance.fIsValidRest[index] = true
                        }
                    }
                }
                }
            }
            }
        }
        else//עובדים
        {
            if Global.sharedInstance.addRecess == false//שעות פעילות
            {
                if index != -1
                {
                    if Global.sharedInstance.arrWorkHoursChild[index].iDayInWeekType != 0//כדי שלא יקרוס כשעדיין לא בחר ליום זה שעות
                    {

                        let hhFromHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index].nvFromHour)!
                        
                        let hhToHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index].nvToHour)!
                        
                        //hours and minutes from hour - working
                        var hhFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourDate))
                        let mmFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourDate))
                        
                        //hours and minutes to hour - working
                        var hhToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourDate))
                        let mmToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourDate))
                        if Global.sharedInstance.isHoursSelectedRestChild[index] == true// אם יש הפסקות ביום הזה
                        {
                            let hhFromHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[index].nvFromHour)!
                            
                            //hours and minutes from hour - rest
                            var hhFromHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourRestDate))
                            let mmFromHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourRestDate))
                            
                            
                            let hhToHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[index].nvToHour)!
                            
                            //hours and minutes to hour - rest
                            var hhToHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourRestDate))
                            let mmToHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourRestDate))
                            
                            if mmFromHour != 0//== 30
                            {
                                hhFromHour = hhFromHour + mmFromHour / 60 //+ 0.5
                            }
                            
                            if mmToHour != 0//== 30
                            {
                                hhToHour = hhToHour + mmToHour / 60//0.5
                            }
                            
                            if mmFromHourRest != 0 //== 30
                            {
                                hhFromHourRest = hhFromHourRest + mmFromHourRest / 60//0.5
                            }
                            
                            if mmToHourRest != 0 //== 30
                            {
                                hhToHourRest = hhToHourRest + mmToHourRest/60//0.5
                            }
                            //אם השעות לא תקינות
                            if hhFromHour > hhToHour
                            {
                                Global.sharedInstance.fIsValidHoursChild[index] = false
                            }
                                //אם ההפסקות לא תקינות
                            else if hhFromHourRest > hhToHourRest
                            {
                                Global.sharedInstance.fIsValidRestChild[index] = false
                            }
                                //אם השעות וההפסקות לא תקינות
                            else if hhFromHour > hhFromHourRest || hhToHour < hhToHourRest
                            {
                                Global.sharedInstance.fIsValidHoursChild[index] = false
                                Global.sharedInstance.fIsValidRestChild[index] = false
                                
                            }
                                //אם תקין
                            else
                            {
                                Global.sharedInstance.fIsValidHoursChild[index] = true
                                Global.sharedInstance.fIsValidRestChild[index] = true
                            }
                            
                            if hhFromHour == hhToHour
                            {
                                
                                //                                Global.sharedInstance.fIsValidHoursChild[index] = false
                                Global.sharedInstance.isHoursSelectedChild[index] = false
                            }
                        }
                            
                        else//אין הפסקות
                        {
                            if mmFromHour != 0//== 30
                            {
                                hhFromHour = hhFromHour + mmFromHour / 60 //+ 0.5
                            }
                            if mmToHour != 0//== 30
                            {
                                hhToHour = hhToHour + mmToHour / 60//0.5
                            }
                            
                            if hhFromHour == hhToHour
                            {
                                
                                Global.sharedInstance.isHoursSelectedChild[index] = false
                                //                                Global.sharedInstance.fIsValidHoursChild[index] = false
                            }
                            if hhFromHour > hhToHour
                            {
                                Global.sharedInstance.fIsValidHoursChild[index] = false
                            }
                            else
                            {
                                Global.sharedInstance.fIsValidHoursChild[index] = true
                            }
                            
                        }
                    }
                }
            }
            else//בוחר הפסקות
            {
                if index != -1
                {
                    if Global.sharedInstance.arrWorkHoursRestChild[index].iDayInWeekType != 0//כדי שלא יקרוס כשעדיין לא בחר ליום זה הפסקות
                    {
                        let hhFromHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index].nvFromHour)!
                        
                        let hhToHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index].nvToHour)!
                        
                        //hours and minutes from hour - working
                        var hhFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourDate))
                        let mmFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourDate))
                        
                        //hours and minutes to hour - working
                        var hhToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourDate))
                        let mmToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourDate))
                        
                        let hhFromHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[index].nvFromHour)!
                        
                        //hours and minutes from hour - rest
                        var hhFromHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourRestDate))
                        let mmFromHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourRestDate))
                        
                        
                        let hhToHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[index].nvToHour)!
                        
                        //hours and minutes to hour - rest
                        var hhToHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourRestDate))
                        let mmToHourRest:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourRestDate))
                        
                        if mmFromHour != 0//== 30
                        {
                            hhFromHour = hhFromHour + mmFromHour / 60 //+ 0.5
                        }
                        
                        if mmToHour != 0//== 30
                        {
                            hhToHour = hhToHour + mmToHour / 60//0.5
                        }
                        
                        if mmFromHourRest != 0 //== 30
                        {
                            hhFromHourRest = hhFromHourRest + mmFromHourRest / 60//0.5
                        }
                        
                        if mmToHourRest != 0 //== 30
                        {
                            hhToHourRest = hhToHourRest + mmToHourRest/60//0.5
                        }
                        
                        //אם השעות לא תקינות
                        if hhFromHour > hhToHour
                        {
                            Global.sharedInstance.fIsValidHoursChild[index] = false
                        }
                            //אם ההפסקות לא תקינות
                        else if hhFromHourRest > hhToHourRest
                        {
                            Global.sharedInstance.fIsValidRestChild[index] = false
                        }
                            //אם השעות וההפסקות לא תקינות
                        else if hhFromHour > hhFromHourRest || hhToHour < hhToHourRest
                        {
                            Global.sharedInstance.fIsValidHoursChild[index] = false
                            Global.sharedInstance.fIsValidRestChild[index] = false
                            
                        }
                            //אם תקין
                        else
                        {
                            Global.sharedInstance.fIsValidHoursChild[index] = true
                            Global.sharedInstance.fIsValidRestChild[index] = true
                        }
                    }
                }
            }
        }
        for x in Global.sharedInstance.arrWorkHours
        {
            print("finale \(x.getDic())")
        }
       //  Global.sharedInstance.generalDetails.arrObjWorkingHours = Global.sharedInstance.arrWorkHours
        print("zzz \(Global.sharedInstance.hourShowRecess)")
        Global.sharedInstance.generalDetails.arrObjWorkingHours =  Array<objWorkingHours>()
        var mymixedarray:Array<objWorkingHours> = Array<objWorkingHours>()

        ////////Global.sharedInstance.arrWorkHours
        for x in Global.sharedInstance.arrWorkHours {
            print("ce a ramaas wh \(x.getDic())")
            var workingHours:objWorkingHours = objWorkingHours()
            if x.iDayInWeekType != 0 && !(x.nvToHour == "00:00:00"){
                workingHours = objWorkingHours(
                    _iDayInWeekType: x.iDayInWeekType,
                    _nvFromHour: x.nvFromHour,
                    _nvToHour: x.nvToHour)
                if !mymixedarray.contains(workingHours) {
                    mymixedarray.append(workingHours)
                }
            }
        }
        for h in mymixedarray
        {
            print("mixedArray print1: \(h.getDic())")
        }
        //   print("Global.sharedInstance.arrWorkHoursRest \(Global.sharedInstance.arrWorkHoursRest)")
        for x in Global.sharedInstance.arrWorkHoursRest {
            print("rh ce ramane \(x.getDic())")
            var workingHours:objWorkingHours = objWorkingHours()
            if x.iDayInWeekType != 0 &&  !(x.nvToHour == "00:00:00") {
                workingHours = objWorkingHours(
                    _iDayInWeekType: x.iDayInWeekType,
                    _nvFromHour: x.nvFromHour,
                    _nvToHour: x.nvToHour)
                if !mymixedarray.contains(workingHours) {
                    mymixedarray.append(workingHours)
                }
            }
        }
        for h in mymixedarray
        {
            print("mixedArray print2: \(h.getDic())")
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
                    //\\      print("no cathch")
                    let oneelement:objWorkingHours = hoursinday[0]
                    if !Global.sharedInstance.generalDetails.arrObjWorkingHours.contains(oneelement) {
                        Global.sharedInstance.generalDetails.arrObjWorkingHours.append(oneelement)
                    }
                } else    if hoursinday.count == 2 && hoursinday[0].iDayInWeekType == i && hoursinday[1].iDayInWeekType == i {
                    print("onelex \(hoursinday[0].getDic())")
                    print("secondx \(hoursinday[1].getDic())")
                    //                    onelex ["nvFromHour": 10:30:00, "nvToHour": 20:00:00, "iDayInWeekType": 1]
                    //                    secondx ["nvFromHour": 11:00:00, "nvToHour": 12:00:00, "iDayInWeekType": 1]
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


    }
    
    //הצגת השעות שנבחרו בלייבל
    
    
    //cut last characters of string
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
    
    //הצגת השעות שנבחרו בלייבל
    func showSelectedHoursAndDays()
    {
        DayFlagArr = [0,0,0,0,0,0,0]
        Global.sharedInstance.hourShow = ""
        
        for i in 0 ..< 7
        {
            if Global.sharedInstance.isHoursSelected[i] == true
            {
                if DayFlagArr[i] != 1
                {
                    if Global.sharedInstance.arrWorkHours[i].nvFromHour != "" && !(Global.sharedInstance.arrWorkHours[i].nvFromHour == "00:00:00" && Global.sharedInstance.arrWorkHours[i].nvToHour == "00:00:00")
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
        
        delagetReloadHeight.reloadTbl()
    }
    
    //הצגת השעות בלייבל, לאחר לחיצה על סמן את כל הימים
    func showHoursFromSelectAll()
    {
        Global.sharedInstance.hourShow = "\("ALLDAYS".localized(LanguageMain.sharedInstance.USERLANGUAGE)) \(cutHour(Global.sharedInstance.arrWorkHours[0].nvFromHour))-\(cutHour(Global.sharedInstance.arrWorkHours[0].nvToHour))"
        
        delagetReloadHeight.reloadTbl()
    }
    
    //הצגת ההפסקות שנבחרו בלייבל
    func showSelectedRecessAndDays()
    {
        DayFlagArr = [0,0,0,0,0,0,0]
        Global.sharedInstance.hourShowRecess = ""
        
        for i in 0 ..< 7
        {
            if Global.sharedInstance.isHoursSelectedRest[i] == true
            {
                if DayFlagArr[i] != 1
                {
                    if Global.sharedInstance.arrWorkHoursRest[i].nvFromHour != "" && !(Global.sharedInstance.arrWorkHoursRest[i].nvFromHour == "00:00:00" && Global.sharedInstance.arrWorkHoursRest[i].nvToHour == "00:00:00")
                    {
                        for j in 0 ..< 7
                        {
                            if Global.sharedInstance.isHoursSelectedRest[j] == true
                            {
                                if Global.sharedInstance.arrWorkHoursRest[i].nvFromHour == Global.sharedInstance.arrWorkHoursRest[j].nvFromHour && Global.sharedInstance.arrWorkHoursRest[i].nvToHour == Global.sharedInstance.arrWorkHoursRest[j].nvToHour
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
        
        delagetReloadHeight.reloadTbl()
    }
    
    
    //הצגת ההפסקות בלייבל, לאחר לחיצה על סמן את כל הימים
    func showRecessFromSelectAll()
    {
        Global.sharedInstance.hourShowRecess = "\("ALLDAYS".localized(LanguageMain.sharedInstance.USERLANGUAGE)) \(cutHour(Global.sharedInstance.arrWorkHoursRest[0].nvFromHour))-\(cutHour(Global.sharedInstance.arrWorkHoursRest[0].nvToHour))"
        
        delagetReloadHeight.reloadTbl()
    }
    
    @objc func selectAllTap()
    {
        //בלחיצה על סמן את כל הימים
        //        isValidSelectAllDays()
        //        selectAll()
        toSelectAllOrNotToSelectThisIsTheQuestion()
    }
    
    func selectAll()
    {
        
        if Global.sharedInstance.currentEditCellOpen == 1
        {
            if Global.sharedInstance.addRecess == false//בוחרים שעות פעילות ולא הפסקות
            {
                if Global.sharedInstance.isSelectAllHours == false
                    //if btnSelectAllDays.tag == 1// היה לא בחור
                {
                    if Global.sharedInstance.isHoursSelected.contains(true)//אם יש לפחות מישהו אחד שבחרו לו שעות
                    {
                        Global.sharedInstance.isSelectAllHours = true
                        
                        //btnSelectAllDays.tag = 2//- נהפך לבחור
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                        //modifica aici
                        for i in 0 ..< Global.sharedInstance.arrWorkHours.count
                        {
                            Global.sharedInstance.arrWorkHours[i].iDayInWeekType = i+1
                            
                            Global.sharedInstance.arrWorkHours[i].nvFromHour = Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvFromHour
                            
                            Global.sharedInstance.arrWorkHours[i].nvToHour = Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvToHour
                            
                            Global.sharedInstance.isHoursSelected[i] = true
                        }
                        
                        dtFromHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvFromHour)!
                        dtToHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[Global.sharedInstance.currentBtnDayTag].nvToHour)!
                        
                        showSelectedHoursAndDays()
                        
                        btnDay1.onBtn = true
                        btnDay2.onBtn = true
                        btnDay3.onBtn = true
                        btnDay4.onBtn = true
                        btnDay5.onBtn = true
                        btnDay6.onBtn = true
                        btnDay7.onBtn = true
                    }
                    else//אם עדין לא בחרו שעות לאף יום
                    {
                        Alert.sharedInstance.showAlert(
                            "CANT_SELECT_ALL_DAYS_BEFORE_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: Global.sharedInstance.GlobalDataVC!)
                    }
                }
                else//(tag=2) אם בחור נהפך ללא בחור
                {
                    Global.sharedInstance.isSelectAllHours = false
                    
                    //btnSelectAllDays.tag = 1//לא בחור
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    for i in 0 ..< Global.sharedInstance.arrWorkHours.count
                    {
                        Global.sharedInstance.isHoursSelected[i] = false
                    }
                    showSelectedHoursAndDays()
                    
                    btnDay1.onBtn = false
                    btnDay2.onBtn = false
                    btnDay3.onBtn = false
                    btnDay4.onBtn = false
                    btnDay5.onBtn = false
                    btnDay6.onBtn = false
                    btnDay7.onBtn = false
                }
            }
            else//בוחרים הפסקות
            {
                if Global.sharedInstance.isSelectAllRest == false
                {
                    if Global.sharedInstance.isHoursSelectedRest.contains(true)
                        //אם יש לפחות מישהו אחד שבחרו לו הפסקות
                    {
                        //עובר על ההפסקות ומוסיף לכולם את אותן השעות
                        for i in 0 ..< Global.sharedInstance.arrWorkHoursRest.count
                            //bug one   for i in 0 ..< Global.sharedInstance.arrWorkHours.count
                        {
                            Global.sharedInstance.arrWorkHoursRest[i].iDayInWeekType = i+1
                            
                            Global.sharedInstance.arrWorkHoursRest[i].nvFromHour = Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvFromHour
                            
                            Global.sharedInstance.arrWorkHoursRest[i].nvToHour = Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvToHour
                            
                            Global.sharedInstance.isHoursSelectedRest[i] = true
                        }
                        
                        dtFromHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvFromHour)!
                        dtToHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[Global.sharedInstance.currentBtnDayTagRest].nvToHour)!
                        
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                        
                        Global.sharedInstance.isSelectAllRest = true
                        showSelectedRecessAndDays()
                        
                        btnDay1.onBtn = true
                        btnDay2.onBtn = true
                        btnDay3.onBtn = true
                        btnDay4.onBtn = true
                        btnDay5.onBtn = true
                        btnDay6.onBtn = true
                        btnDay7.onBtn = true
                    }
                    else//אם לא בחרו הפסקות לאף יום
                    {
                        Alert.sharedInstance.showAlert("CANT_SELECT_ALL_DAYS_BEFORE_RECESS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: Global.sharedInstance.GlobalDataVC!)
                    }
                }
                else//(tag=2) אם בחור נהפך ללא בחור
                {
                    Global.sharedInstance.isSelectAllRest = false
                    
                    //btnSelectAllDays.tag = 1//לא בחור
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    for i in 0 ..< Global.sharedInstance.arrWorkHoursRest.count
                    {
                        Global.sharedInstance.isHoursSelectedRest[i] = false
                    }
                    showSelectedRecessAndDays()
                    
                    btnDay1.onBtn = false
                    btnDay2.onBtn = false
                    btnDay3.onBtn = false
                    btnDay4.onBtn = false
                    btnDay5.onBtn = false
                    btnDay6.onBtn = false
                    btnDay7.onBtn = false
                }
                
            }
        }
        else if Global.sharedInstance.currentEditCellOpen == 2//עובדים
        {
            if Global.sharedInstance.addRecess == false//בוחרים שעות פעילות ולא הפסקות
            {
                if Global.sharedInstance.isSelectAllHoursChild == false
                {
                    if Global.sharedInstance.isHoursSelectedChild.contains(true)//אם יש לפחות מישהו אחד שבחרו לו שעות
                    {
                        Global.sharedInstance.isSelectAllHoursChild = true
                        //- נהפך לבחור
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                        
                        for i in 0 ..< Global.sharedInstance.arrWorkHoursChild.count
                        {
                            Global.sharedInstance.arrWorkHoursChild[i].iDayInWeekType = i+1
                            
                            Global.sharedInstance.arrWorkHoursChild[i].nvFromHour = Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvFromHour
                            
                            Global.sharedInstance.arrWorkHoursChild[i].nvToHour = Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvToHour
                            
                            Global.sharedInstance.isHoursSelectedChild[i] = true
                        }
                        
                        dtFromHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvFromHour)!
                        dtToHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[Global.sharedInstance.currentBtnDayTagChild].nvToHour)!
                        
                        btnDay1.onBtn = true
                        btnDay2.onBtn = true
                        btnDay3.onBtn = true
                        btnDay4.onBtn = true
                        btnDay5.onBtn = true
                        btnDay6.onBtn = true
                        btnDay7.onBtn = true
                    }
                    else//אם עדין לא בחרו שעות לאף יום
                    {
                        Alert.sharedInstance.showAlert(
                            "CANT_SELECT_ALL_DAYS_BEFORE_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: Global.sharedInstance.GlobalDataVC!)
                    }
                }
                else//(tag=2) אם בחור נהפך ללא בחור
                {
                    Global.sharedInstance.isSelectAllHoursChild = false
                    
                    //לא בחור
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    
                    for i in 0 ..< Global.sharedInstance.arrWorkHoursChild.count
                    {
                        Global.sharedInstance.isHoursSelectedChild[i] = false
                    }
                    
                    btnDay1.onBtn = false
                    btnDay2.onBtn = false
                    btnDay3.onBtn = false
                    btnDay4.onBtn = false
                    btnDay5.onBtn = false
                    btnDay6.onBtn = false
                    btnDay7.onBtn = false
                }
            }
            else//בוחרים הפסקות
            {
                if Global.sharedInstance.isSelectAllRestChild == false
                    //if btnSelectAllDays.tag == 1// היה לא בחור
                {
                    if Global.sharedInstance.isHoursSelectedRestChild.contains(true)
                        //אם יש לפחות מישהו אחד שבחרו לו הפסקות
                    {
                        //עובר על ההפסקות ומוסיף לכולם את אותן השעות
                        for i in 0 ..< Global.sharedInstance.arrWorkHoursChild.count
                        {
                            Global.sharedInstance.arrWorkHoursRestChild[i].iDayInWeekType = i+1
                            
                            Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour = Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvFromHour
                            
                            Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour = Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvToHour
                            
                            Global.sharedInstance.isHoursSelectedRestChild[i] = true
                        }
                        
                        dtFromHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvFromHour)!
                        dtToHour.date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[Global.sharedInstance.currentBtnDayTagRestChild].nvToHour)!
                        
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                        
                        Global.sharedInstance.isSelectAllRestChild = true
                        
                        btnDay1.onBtn = true
                        btnDay2.onBtn = true
                        btnDay3.onBtn = true
                        btnDay4.onBtn = true
                        btnDay5.onBtn = true
                        btnDay6.onBtn = true
                        btnDay7.onBtn = true
                    }
                    else//אם לא בחרו הפסקות לאף יום
                    {
                        Alert.sharedInstance.showAlert("CANT_SELECT_ALL_DAYS_BEFORE_RECESS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: Global.sharedInstance.GlobalDataVC!)
                    }
                }
                else//(tag=2) אם בחור נהפך ללא בחור
                {
                    Global.sharedInstance.isSelectAllRestChild = false
                    
                    //לא בחור
                    btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    
                    for i in 0 ..< Global.sharedInstance.arrWorkHoursRestChild.count
                    {
                        Global.sharedInstance.isHoursSelectedRestChild[i] = false
                    }
                    
                    btnDay1.onBtn = false
                    btnDay2.onBtn = false
                    btnDay3.onBtn = false
                    btnDay4.onBtn = false
                    btnDay5.onBtn = false
                    btnDay6.onBtn = false
                    btnDay7.onBtn = false
                }
            }
        }
    }
    
    
    //מאפשר את הלחיצה על הימים
    //modifica aici
    func enabledBtnDays()
    {
        initButtonWorkingHours()
        if Global.sharedInstance.currentEditCellOpen == 1//משעות פעילות
        {
            if Global.sharedInstance.arrWorkHours[0].iDayInWeekType != 0 && checkIfCanAddRecess(0) == true
            {
                btnDay1.isEnabled = Global.sharedInstance.isHoursSelected[0]
            }
            else
            {
                btnDay1.isEnabled = false
            }
            if Global.sharedInstance.arrWorkHours[1].iDayInWeekType != 0 && checkIfCanAddRecess(1) == true
            {
                btnDay2.isEnabled = Global.sharedInstance.isHoursSelected[1]
            }
            else
            {
                btnDay2.isEnabled = false
            }
            if Global.sharedInstance.arrWorkHours[2].iDayInWeekType != 0 && checkIfCanAddRecess(2) == true
            {
                btnDay3.isEnabled = Global.sharedInstance.isHoursSelected[2]
            }
            else
            {
                btnDay3.isEnabled = false
            }
            
            if Global.sharedInstance.arrWorkHours[3].iDayInWeekType != 0 && checkIfCanAddRecess(3) == true
            {
                btnDay4.isEnabled = Global.sharedInstance.isHoursSelected[3]
            }
            else
            {
                btnDay4.isEnabled = false
            }
            
            if Global.sharedInstance.arrWorkHours[4].iDayInWeekType != 0 && checkIfCanAddRecess(4) == true
            {
                btnDay5.isEnabled = Global.sharedInstance.isHoursSelected[4]
            }
            else
            {
                btnDay5.isEnabled = false
            }
            if Global.sharedInstance.arrWorkHours[5].iDayInWeekType != 0 && checkIfCanAddRecess(5) == true
            {
                btnDay6.isEnabled = Global.sharedInstance.isHoursSelected[5]
            }
            else
            {
                btnDay6.isEnabled = false
            }
            
            if Global.sharedInstance.arrWorkHours[6].iDayInWeekType != 0 && checkIfCanAddRecess(6) == true
            {
                btnDay7.isEnabled = Global.sharedInstance.isHoursSelected[6]
            }
            else
            {
                btnDay7.isEnabled = false
            }
        }
        else//מעובדים
        {
            if Global.sharedInstance.arrWorkHoursChild[0].iDayInWeekType != 0 && checkIfCanAddRecess(0) == true
            {
                btnDay1.isEnabled = Global.sharedInstance.isHoursSelectedChild[0]
            }
            else
            {
                btnDay1.isEnabled = false
            }
            if Global.sharedInstance.arrWorkHoursChild[1].iDayInWeekType != 0 && checkIfCanAddRecess(1) == true
            {
                btnDay2.isEnabled = Global.sharedInstance.isHoursSelectedChild[1]
            }
            else
            {
                btnDay2.isEnabled = false
            }
            if Global.sharedInstance.arrWorkHoursChild[2].iDayInWeekType != 0 && checkIfCanAddRecess(2) == true
            {
                btnDay3.isEnabled = Global.sharedInstance.isHoursSelectedChild[2]
            }
            else
            {
                btnDay3.isEnabled = false
            }
            if Global.sharedInstance.arrWorkHoursChild[3].iDayInWeekType != 0 && checkIfCanAddRecess(3) == true
            {
                btnDay4.isEnabled = Global.sharedInstance.isHoursSelectedChild[3]
            }
            else
            {
                btnDay4.isEnabled = false
            }
            if Global.sharedInstance.arrWorkHoursChild[4].iDayInWeekType != 0 && checkIfCanAddRecess(4) == true
            {
                btnDay5.isEnabled = Global.sharedInstance.isHoursSelectedChild[4]
            }
            else
            {
                btnDay5.isEnabled = false
            }
            if Global.sharedInstance.arrWorkHoursChild[5].iDayInWeekType != 0 && checkIfCanAddRecess(5) == true
            {
                btnDay6.isEnabled = Global.sharedInstance.isHoursSelectedChild[5]
            }
            else
            {
                btnDay6.isEnabled = false
            }
            if Global.sharedInstance.arrWorkHoursChild[6].iDayInWeekType != 0 && checkIfCanAddRecess(6) == true
            {
                btnDay7.isEnabled = Global.sharedInstance.isHoursSelectedChild[6]
            }
            else
            {
                btnDay7.isEnabled = false
            }
        }
        Global.sharedInstance.GlobalDataVC!.delegateEnabledBtnDays = self
    }
    
    //מאפשר את הלחיצה על הכפתורים
    func enabledTrueBtnDays()
    {
        btnDay1.isEnabled = true
        btnDay2.isEnabled = true
        btnDay3.isEnabled = true
        btnDay4.isEnabled = true
        btnDay5.isEnabled = true
        btnDay6.isEnabled = true
        btnDay7.isEnabled = true
    }
    
    //בדיקה האם שעת ההתחלה ושעת הסיום זהות
    //במקרה כזה השעות ההן נמחקות, והיום נראה כאינו בחור.
    func checkHoursEquals(_ index:Int)
    {
        var hhFromHour:Float = 0.0
        var hhToHour:Float = 0.0
        var hhFromHourDate:Date = Date()
        var hhToHourDate:Date = Date()
        
        if index != -1
        {
            if Global.sharedInstance.currentEditCellOpen == 1//שעות פעילות
            {
                if Global.sharedInstance.addRecess == false//שעות פעילות ולא הפסקות
                {
                    if Global.sharedInstance.arrWorkHours[index].iDayInWeekType != 0//כדי שלא יקרוס כשעדיין לא בחר ליום זה שעות
                    {
                        if let _:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvFromHour) as? Date {
                            if let _:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvToHour) as? Date {

                        hhFromHourDate = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvFromHour)!
                        
                        hhToHourDate = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvToHour)!
                        
                        //hours and minutes from hour - working
                        hhFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourDate))
                        let mmFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourDate))
                        
                        //hours and minutes to hour - working
                        hhToHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourDate))
                        let mmToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourDate))
                        
                        if mmFromHour != 0
                        {
                            hhFromHour = hhFromHour + mmFromHour / 60
                        }
                        
                        if mmToHour != 0
                        {
                            hhToHour = hhToHour + mmToHour / 60
                        }
                    }
                    if Global.sharedInstance.isHoursSelectedRest[index] == true// אם יש הפסקות ביום הזה
                    {
                        if hhFromHour == hhToHour
                        {
                            Global.sharedInstance.isHoursSelected[index] = false
                            Global.sharedInstance.isHoursSelectedRest[index] = false
                            
                            Global.sharedInstance.arrWorkHours[index] = objWorkingHours()
                            Global.sharedInstance.arrWorkHoursRest[index] = objWorkingHours()
                            
                            switchBtnDay(index,bool: false)//מכבה את הכפתור של היום הזה
                        }
                    }
                    else //אין הפסקות
                    {
                        if hhFromHour == hhToHour
                        {
                            Global.sharedInstance.isHoursSelected[index] = false
                            Global.sharedInstance.arrWorkHours[index] = objWorkingHours()
                            
                            switchBtnDay(index,bool: false)//מכבה את הכפתור של היום הזה
                        }
                    }
                }
                else//הפסקות
                {
                    if Global.sharedInstance.arrWorkHoursRest[index].iDayInWeekType != 0//כדי שלא יקרוס כשעדיין לא בחר ליום זה שעות
                    {
                        hhFromHourDate = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index].nvFromHour)!
                        
                        hhToHourDate = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index].nvToHour)!
                        
                        //hours and minutes from hour - working
                        hhFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourDate))
                        let mmFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourDate))
                        
                        //hours and minutes to hour - working
                        hhToHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourDate))
                        let mmToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourDate))
                        
                        if mmFromHour != 0
                        {
                            hhFromHour = hhFromHour + mmFromHour / 60
                        }
                        if mmToHour != 0
                        {
                            hhToHour = hhToHour + mmToHour / 60
                        }
                    }
                    if hhFromHour == hhToHour
                    {
                        Global.sharedInstance.isHoursSelectedRest[index] = false
                        Global.sharedInstance.arrWorkHoursRest[index] = objWorkingHours()
                        
                        switchBtnDay(index,bool: false)//מכבה את הכפתור של היום הזה
                    }
                }
                    }
                }
            }
                
            else if Global.sharedInstance.currentEditCellOpen == 2//עובדים
            {
                if Global.sharedInstance.addRecess == false//שעות פעילות ולא הפסקות
                {
                    if Global.sharedInstance.arrWorkHoursChild[index].iDayInWeekType != 0//כדי שלא יקרוס כשעדיין לא בחר ליום זה שעות
                    {
                        
                        hhFromHourDate = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index].nvFromHour)!
                        
                        hhToHourDate = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index].nvToHour)!
                        
                        //hours and minutes from hour - working
                        hhFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourDate))
                        let mmFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourDate))
                        
                        //hours and minutes to hour - working
                        hhToHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourDate))
                        let mmToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourDate))
                        
                        if mmFromHour != 0
                        {
                            hhFromHour = hhFromHour + mmFromHour / 60
                        }
                        if mmToHour != 0
                        {
                            hhToHour = hhToHour + mmToHour / 60
                        }
                    }
                    
                    if Global.sharedInstance.isHoursSelectedRestChild[index] == true// אם יש הפסקות ביום הזה
                    {
                        if hhFromHour == hhToHour
                        {
                            Global.sharedInstance.isHoursSelectedChild[index] = false
                            Global.sharedInstance.isHoursSelectedRestChild[index] = false
                            
                            Global.sharedInstance.arrWorkHoursChild[index] = objWorkingHours()
                            Global.sharedInstance.arrWorkHoursRestChild[index] = objWorkingHours()
                            
                            switchBtnDay(index,bool: false)//מכבה את הכפתור של היום הזה
                        }
                    }
                    else //אין הפסקות
                    {
                        if hhFromHour == hhToHour
                        {
                            Global.sharedInstance.isHoursSelectedChild[index] = false
                            Global.sharedInstance.arrWorkHoursChild[index] = objWorkingHours()
                            
                            switchBtnDay(index,bool: false)//מכבה את הכפתור של היום הזה
                        }
                    }
                }
                else//הפסקות
                {
                    if Global.sharedInstance.arrWorkHoursRestChild[index].iDayInWeekType != 0//כדי שלא יקרוס כשעדיין לא בחר ליום זה שעות
                    {
                        hhFromHourDate = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[index].nvFromHour)!
                        
                        hhToHourDate = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[index].nvToHour)!
                        
                        //hours and minutes from hour - working
                        hhFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourDate))
                        let mmFromHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourDate))
                        
                        //hours and minutes to hour - working
                        hhToHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourDate))
                        let mmToHour:Float = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourDate))
                        
                        if mmFromHour != 0
                        {
                            hhFromHour = hhFromHour + mmFromHour / 60
                        }
                        if mmToHour != 0
                        {
                            hhToHour = hhToHour + mmToHour / 60
                        }
                    }
                    if hhFromHour == hhToHour
                    {
                        Global.sharedInstance.isHoursSelectedRestChild[index] = false
                        Global.sharedInstance.arrWorkHoursRestChild[index] = objWorkingHours()
                        
                        switchBtnDay(index,bool: false)//מכבה את הכפתור של היום הזה
                    }
                }
            }
        }
    }
    
    func isValidSelectAllDays()
    {
        
        var previousFrom = ""
        var currentFrom = ""
        var previousTo = ""
        var currentTo = ""
        var fIsEquals = true
        var currentIndex = 0//שומר את היום האחרון שלפיו נאתחל את כל הימים(למקרה שלוחץ על סמן את כל הימים בלי לבחור יום מסויים,לדוג:כיבה יום או בעריכה כשפותחים ומיד לוחצים על סמן הכל)
        
        if Global.sharedInstance.currentEditCellOpen == 1//שעות פעילות
        {
            if Global.sharedInstance.addRecess == false//שעות פעילות ולא הפסקות
            {
                if Global.sharedInstance.isSelectAllHours == false//אם לחצתי כדי להדליק את הכפתור סמן את כל הימים בשעות
                {
                    //מעבר על שעות הפעילות לוודא שכולן זהות, אחרת לא ניתן לסמן את כל הימים
                    for i in 0...6
                    {
                        if Global.sharedInstance.isHoursSelected[i] == true
                        {
                            currentIndex = i
                            currentFrom = Global.sharedInstance.arrWorkHours[i].nvFromHour
                            currentTo = Global.sharedInstance.arrWorkHours[i].nvToHour
                            //אם משעה ועד שעה שווים או שלא בחרו שעות
                            if currentFrom == currentTo
                            {
                                fIsEquals = false
                                break
                            }
                            else if previousFrom == ""
                            {
                                previousFrom = currentFrom
                                previousTo = currentTo
                            }
                            else
                            {
                                if currentFrom != previousFrom || currentTo != previousTo
                                {
                                    fIsEquals = false
                                    break
                                }
                            }
                        }
                    }
                    if fIsEquals == true
                    {
                        Global.sharedInstance.currentBtnDayTag = currentIndex
                        self.selectAll()
                    }
                }
                else//אם לחצתי כדי לכבות
                {
                    selectAll()
                }
            }
            else//הפסקות
            {
                if Global.sharedInstance.isSelectAllRest == false//אם לחצתי כדי להדליק את הכפתור סמן את כל הימים בהפסקות
                {
                    //אם כל הימים בחורים
                    if !Global.sharedInstance.isHoursSelected.contains(false)
                    {
                        //מעבר על שעות הפעילות לוודא שכולן זהות, אחרת לא ניתן לסמן את כל הימים
                        for i in 0...6
                        {
                            currentFrom = Global.sharedInstance.arrWorkHours[i].nvFromHour
                            currentTo = Global.sharedInstance.arrWorkHours[i].nvToHour
                            
                            if previousFrom == ""
                            {
                                previousFrom = currentFrom
                                previousTo = currentTo
                            }
                            else
                            {
                                if currentFrom != previousFrom || currentTo != previousTo
                                {
                                    fIsEquals = false
                                    break
                                }
                            }
                        }
                        
                        if fIsEquals == true//אם השעות פעילות זהות, יש לבדוק אם ההפסות הבחורות זהות
                        {
                            previousFrom = ""
                            currentFrom = ""
                            previousTo = ""
                            currentTo = ""
                            fIsEquals = true
                            
                            //מעבר על ההפסקות לוודא שכולן זהות, אחרת לא ניתן לסמן את כל הימים
                            for i in 0...6
                            {
                                if Global.sharedInstance.isHoursSelectedRest[i] == true
                                {
                                    currentIndex = i
                                    currentFrom = Global.sharedInstance.arrWorkHoursRest[i].nvFromHour
                                    currentTo = Global.sharedInstance.arrWorkHoursRest[i].nvToHour
                                    
                                    //אם משעה ועד שעה שווים או שלא בחרו שעות
                                    if currentFrom == currentTo
                                    {
                                        fIsEquals = false
                                        break
                                    }
                                    else if previousFrom == ""
                                    {
                                        previousFrom = currentFrom
                                        previousTo = currentTo
                                    }
                                    else
                                    {
                                        if currentFrom != previousFrom || currentTo != previousTo
                                        {
                                            fIsEquals = false
                                            break
                                        }
                                    }
                                }
                            }
                            if fIsEquals == true
                            {
                                Global.sharedInstance.currentBtnDayTagRest = currentIndex
                                self.selectAll()
                                
                            }
                        }
                    }
                }
                else//אם לחצתי כדי לכבות
                {
                    selectAll()
                }
            }
        }
        else if Global.sharedInstance.currentEditCellOpen == 2//עובדים
        {
            if Global.sharedInstance.addRecess == false//שעות פעילות ולא הפסקות
            {
                if Global.sharedInstance.isSelectAllHoursChild == false//אם לחצתי כדי להדליק את הכפתור סמן את כל הימים בשעות
                {
                    //מעבר על שעות הפעילות לוודא שכולן זהות, אחרת לא ניתן לסמן את כל הימים
                    for i in 0...6
                    {
                        if Global.sharedInstance.isHoursSelectedChild[i] == true
                        {
                            currentIndex = i
                            currentFrom = Global.sharedInstance.arrWorkHoursChild[i].nvFromHour
                            currentTo = Global.sharedInstance.arrWorkHoursChild[i].nvToHour
                            //אם משעה ועד שעה שווים או שלא בחרו שעות
                            if currentFrom == currentTo
                            {
                                fIsEquals = false
                                break
                            }
                            else if previousFrom == ""
                            {
                                previousFrom = currentFrom
                                previousTo = currentTo
                            }
                            else
                            {
                                if currentFrom != previousFrom || currentTo != previousTo
                                {
                                    fIsEquals = false
                                    break
                                }
                            }
                        }
                    }
                    if fIsEquals == true
                    {
                        Global.sharedInstance.currentBtnDayTagChild = currentIndex
                        self.selectAll()
                    }
                }
                else//אם לחצתי כדי לכבות
                {
                    selectAll()
                }
            }
            else//הפסקות
            {
                if Global.sharedInstance.isSelectAllRestChild == false//אם לחצתי כדי להדליק את הכפתור סמן את כל הימים בהפסקות
                {
                    //אם כל הימים בחורים
                    if !Global.sharedInstance.isHoursSelectedChild.contains(false)
                    {
                        //מעבר על שעות הפעילות לוודא שכולן זהות, אחרת לא ניתן לסמן את כל הימים
                        for i in 0...6
                        {
                            currentFrom = Global.sharedInstance.arrWorkHoursChild[i].nvFromHour
                            currentTo = Global.sharedInstance.arrWorkHoursChild[i].nvToHour
                            
                            if previousFrom == ""
                            {
                                previousFrom = currentFrom
                                previousTo = currentTo
                            }
                            else
                            {
                                if currentFrom != previousFrom || currentTo != previousTo
                                {
                                    fIsEquals = false
                                    break
                                }
                            }
                        }
                        if fIsEquals == true//אם השעות פעילות זהות, יש לבדוק אם ההפסקות הבחורות זהות
                        {
                            previousFrom = ""
                            currentFrom = ""
                            previousTo = ""
                            currentTo = ""
                            fIsEquals = true
                            
                            //מעבר על ההפסקות לוודא שכולן זהות, אחרת לא ניתן לסמן את כל הימים
                            for i in 0...6
                            {
                                if Global.sharedInstance.isHoursSelectedRestChild[i] == true
                                {
                                    currentIndex = i
                                    currentFrom = Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour
                                    currentTo = Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour
                                    
                                    //אם משעה ועד שעה שווים או שלא בחרו שעות
                                    if currentFrom == currentTo
                                    {
                                        fIsEquals = false
                                        break
                                    }
                                    else if previousFrom == ""
                                    {
                                        previousFrom = currentFrom
                                        previousTo = currentTo
                                    }
                                    else
                                    {
                                        if currentFrom != previousFrom || currentTo != previousTo
                                        {
                                            fIsEquals = false
                                            break
                                        }
                                    }
                                }
                            }
                            if fIsEquals == true
                            {
                                Global.sharedInstance.currentBtnDayTagRestChild = currentIndex
                                self.selectAll()
                            }
                            
                        }
                    }
                }
                else//אם לחצתי כדי לכבות
                {
                    selectAll()
                }
            }
        }
    }
    //פונקציה הבודקת בכל לחיצה על יום או בגלילה, האם כל הימים בחורים וזהים - כדי לדעת האם להדליק את הכפתור ״סמן את כל הימים״
    func checkIfSelectAll()
    {
        var previousFrom = ""
        var currentFrom = ""
        var previousTo = ""
        var currentTo = ""
        var fIsEquals = true
        if Global.sharedInstance.currentEditCellOpen == 1//שעות פעילות
        {
            if Global.sharedInstance.addRecess == false//שעות פעילות ולא הפסקות
            {

                //אם כל הימים בחורים
                if !Global.sharedInstance.isHoursSelected.contains(false)
                {
                    //בדיקה האם כל הימים זהים
                    for i in 0...6
                    {
                        currentFrom = Global.sharedInstance.arrWorkHours[i].nvFromHour
                        currentTo = Global.sharedInstance.arrWorkHours[i].nvToHour

                        if previousFrom == ""
                        {
                            previousFrom = currentFrom
                            previousTo = currentTo
                        }
                        else
                        {
                            if currentFrom != previousFrom || currentTo != previousTo
                            {
                                fIsEquals = false
                                break
                            }
                        }
                    }
                    if fIsEquals == true
                    {

                        Global.sharedInstance.isSelectAllHours = true
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                    }
                    else
                    {
                        Global.sharedInstance.isSelectAllHours = false
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    }

                }
            }
            else//הפסקות
            {

                //אם כל ההפסקות בחורות
                if !Global.sharedInstance.isHoursSelectedRest.contains(false)
                {
                    //בדיקה האם כל ההפסקות זהות
                    var nullHoursCounter:Int = 0
                    for i in 0...6
                    {
                        currentFrom = Global.sharedInstance.arrWorkHoursRest[i].nvFromHour
                        currentTo = Global.sharedInstance.arrWorkHoursRest[i].nvToHour

                        if currentFrom == "00:00:00" && currentTo == "00:00:00"
                        {
                            nullHoursCounter += 1
                        }

                        if previousFrom == ""
                        {
                            previousFrom = currentFrom
                            previousTo = currentTo
                        }
                        else
                        {
                            if currentFrom != previousFrom || currentTo != previousTo
                            {
                                fIsEquals = false
                                break
                            }

                        }
                    }
                    if nullHoursCounter == 7
                    {
                        fIsEquals = false
                    }
                    if fIsEquals == true
                    {

                        Global.sharedInstance.isSelectAllRest = true
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                    }
                    else
                    {
                        Global.sharedInstance.isSelectAllRest = false
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    }

                }
            }



        }
        else if Global.sharedInstance.currentEditCellOpen == 2//עובדים
        {
            if Global.sharedInstance.addRecess == false//שעות פעילות ולא הפסקות
            {

                //אם כל הימים בחורים
                if !Global.sharedInstance.isHoursSelectedChild.contains(false)
                {
                    //בדיקה האם כל הימים זהים
                    for i in 0...6
                    {
                        currentFrom = Global.sharedInstance.arrWorkHoursChild[i].nvFromHour
                        currentTo = Global.sharedInstance.arrWorkHoursChild[i].nvToHour

                        if previousFrom == ""
                        {
                            previousFrom = currentFrom
                            previousTo = currentTo
                        }
                        else
                        {
                            if currentFrom != previousFrom || currentTo != previousTo
                            {
                                fIsEquals = false
                                break
                            }
                        }
                    }
                    if fIsEquals == true
                    {

                        Global.sharedInstance.isSelectAllHoursChild = true
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                    }
                    else
                    {
                        Global.sharedInstance.isSelectAllHoursChild = false
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    }

                }
            }
            else//הפסקות
            {

                //אם כל ההפסקות בחורות
                if !Global.sharedInstance.isHoursSelectedRestChild.contains(false)
                {
                    //בדיקה האם כל ההפסקות זהות
                    for i in 0...6
                    {
                        currentFrom = Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour
                        currentTo = Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour

                        if previousFrom == ""
                        {
                            previousFrom = currentFrom
                            previousTo = currentTo
                        }
                        else
                        {
                            if currentFrom != previousFrom || currentTo != previousTo
                            {
                                fIsEquals = false
                                break
                            }
                        }
                    }
                    if fIsEquals == true
                    {

                        Global.sharedInstance.isSelectAllRestChild = true
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "15a.png"), for: UIControl.State())
                    }
                    else
                    {
                        Global.sharedInstance.isSelectAllRestChild = false
                        btnSelectAllDays.setBackgroundImage(UIImage(named: "9.png"), for: UIControl.State())
                    }

                }
            }



        }
    }
    

    
    //checkHoursEquals פונקצית עזר לפונקציה
    //הפונקציה מכבה / מדליקה את היום שקבלה בהתאם למשתנה הבוליאני שקבלה
    func switchBtnDay(_ index:Int,bool:Bool)
    {
        switch index
        {
        case 0:
            btnDay1.onBtn = false
            break
        case 1:
            btnDay2.onBtn = false
            break
        case 2:
            btnDay3.onBtn = false
            break
        case 3:
            btnDay4.onBtn = false
            break
        case 4:
            btnDay5.onBtn = false
            break
        case 5:
            //                            btnDay6.isCecked = Global.sharedInstance.isHoursSelectedRest[i]
            btnDay6.onBtn = false
            break
        case 6:
            btnDay7.onBtn = false
            break
        default:
            break
        }
    }
    //בדיקה אם ההפסקות שבחר בעבר נמצאות בטווח של השעות, למקרה ששינה את השעות
    func checkIfRestInHours(_ index:Int)->Bool
    {
        var hhFromHour:Float = 0.0
        var hhToHour:Float = 0.0
        var hhFromHourRest:Float = 0.0
        var hhToHourRest:Float = 0.0
        
        //הפעלת הפונקציה שממריה את השעות וההפסקות לfloat כדי לבדוק את התקינות
        var arr = convertHoursRestsToFloat(index)
        
        hhFromHour = arr[0]
        hhToHour = arr[1]
        hhFromHourRest = arr[2]
        hhToHourRest = arr[3]
        
        if hhFromHourRest < hhFromHour || hhToHourRest > hhToHour
        {
            return false
        }
        return true
    }
    
    //פונקציה הבודקת האם טווח השעות קטן או שווה לשעה
    // ולכן אין לאפשר בחירת הפסקה
    func checkIfCanAddRecess(_ index:Int) -> Bool {
        
        var hhFromHour:Float = 0.0
        var hhToHour:Float = 0.0
        
        //המרת השעות ל float
        let arr = convertHoursToFloat(index)
        
        hhFromHour = arr[0]
        hhToHour = arr[1]
        
        if (hhFromHour + 1) >= hhToHour
        {
            return false
        }
        
        return true
    }
    
    //פונקצית עזר הממירה את השעות ןההפסקות ל float
    func convertHoursRestsToFloat(_ index:Int) -> Array<Float> {
        var arrHours:Array<Float> = [0.0,0.0,0.0,0.0]
        
        var hhFromHour:Float = 0.0
        var mmFromHour:Float = 0.0
        var hhToHour:Float = 0.0
        var mmToHour:Float = 0.0
        var hhFromHourRest:Float = 0.0
        var mmFromHourRest:Float = 0.0
        var hhToHourRest:Float = 0.0
        var mmToHourRest:Float = 0.0
        
        if Global.sharedInstance.currentEditCellOpen == 1//שעות פעילות
        {
            let hhFromHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvFromHour)!
            
            let hhToHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvToHour)!
            
            
            //hours and minutes from hour
            hhFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourDate))
            mmFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourDate))
            
            //hours and minutes to hour
            hhToHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourDate))
            mmToHour = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourDate))
            
            let hhFromHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index].nvFromHour)!
            
            //hours and minutes from hour - rest
            hhFromHourRest = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourRestDate))
            mmFromHourRest = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourRestDate))
            
            let hhToHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRest[index].nvToHour)!
            
            //hours and minutes to hour - rest
            hhToHourRest = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourRestDate))
            mmToHourRest = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourRestDate))
            
            if mmFromHour != 0
            {
                hhFromHour = hhFromHour + mmFromHour / 60
            }
            
            if mmToHour != 0
            {
                hhToHour = hhToHour + mmToHour / 60
            }
            
            if mmFromHourRest != 0
            {
                hhFromHourRest = hhFromHourRest + mmFromHourRest / 60
            }
            
            if mmToHourRest != 0
            {
                hhToHourRest = hhToHourRest + mmToHourRest/60
            }
            
        }
        else//עובדים
        {
            let hhFromHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index].nvFromHour)!
            
            let hhToHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index].nvToHour)!
            
            
            //hours and minutes from hour
            hhFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourDate))
            mmFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourDate))
            
            //hours and minutes to hour
            hhToHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourDate))
            mmToHour = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourDate))
            
            let hhFromHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[index].nvFromHour)!
            
            //hours and minutes from hour - rest
            hhFromHourRest = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourRestDate))
            mmFromHourRest = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourRestDate))
            
            let hhToHourRestDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursRestChild[index].nvToHour)!
            
            //hours and minutes to hour - rest
            hhToHourRest = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourRestDate))
            mmToHourRest = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourRestDate))
            
            if mmFromHour != 0
            {
                hhFromHour = hhFromHour + mmFromHour / 60
            }
            
            if mmToHour != 0
            {
                hhToHour = hhToHour + mmToHour / 60
            }
            
            if mmFromHourRest != 0
            {
                hhFromHourRest = hhFromHourRest + mmFromHourRest / 60
            }
            
            if mmToHourRest != 0
            {
                hhToHourRest = hhToHourRest + mmToHourRest/60
            }
        }
        
        arrHours[0] = hhFromHour
        arrHours[1] = hhToHour
        arrHours[2] = hhFromHourRest
        arrHours[3] = hhToHourRest
        
        return arrHours
    }
    
    //פונקצית עזר הממירה את השעות בלבד ל float
    func convertHoursToFloat(_ index:Int) -> Array<Float> {
        var arrHours:Array<Float> = [0.0,0.0]
        
        var hhFromHour:Float = 0.0
        var mmFromHour:Float = 0.0
        var hhToHour:Float = 0.0
        var mmToHour:Float = 0.0
        
        if Global.sharedInstance.currentEditCellOpen == 1//שעות פעילות
        {
            let hhFromHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvFromHour)!
            
            let hhToHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHours[index].nvToHour)!
            
            //hours and minutes from hour
            hhFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourDate))
            mmFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourDate))
            
            //hours and minutes to hour
            hhToHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourDate))
            mmToHour = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourDate))
            
            
            if mmFromHour != 0
            {
                hhFromHour = hhFromHour + mmFromHour / 60
            }
            
            if mmToHour != 0
            {
                hhToHour = hhToHour + mmToHour / 60
            }
            
        }
        else//עובדים
        {
            let hhFromHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index].nvFromHour)!
            
            let hhToHourDate:Date = dateFormatter.date(from: Global.sharedInstance.arrWorkHoursChild[index].nvToHour)!
            
            
            //hours and minutes from hour
            hhFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhFromHourDate))
            mmFromHour = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhFromHourDate))
            
            //hours and minutes to hour
            hhToHour = Float((Foundation.Calendar.current as NSCalendar).component(.hour, from: hhToHourDate))
            mmToHour = Float((Foundation.Calendar.current as NSCalendar).component(.minute, from: hhToHourDate))
            
            
            if mmFromHour != 0
            {
                hhFromHour = hhFromHour + mmFromHour / 60
            }
            
            if mmToHour != 0
            {
                hhToHour = hhToHour + mmToHour / 60
            }
        }
        
        arrHours[0] = hhFromHour
        arrHours[1] = hhToHour
        
        return arrHours
    }
    
    func ZeroDPMaxMin()
    {
        dtFromHour.maximumDate = .none
        dtFromHour.minimumDate = .none
        dtToHour.maximumDate = .none
        dtToHour.minimumDate = .none
        setDatePickerNull()
    }
    func changeRectangleColorandBorder() {
        //        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
        //            //          //hebwr
        //            BlueviewBorder.hidden = true
        //            Blueview.hidden = true
        //        } else {
        if Global.sharedInstance.addRecess == true//לחצו על הפסקות
        {
            Blueview.backgroundColor = Colors.sharedInstance.color3
            BlueviewBorder.backgroundColor = Colors.sharedInstance.color3
        } else {
            Blueview.backgroundColor = Colors.sharedInstance.color4
            BlueviewBorder.backgroundColor = Colors.sharedInstance.color4
        }
        if Global.sharedInstance.currentEditCellOpen == 1//  Activity time
        {
            if Global.sharedInstance.addRecess == false//Selects hours and not breaks
            {
                //check if is selected at last one day
                if  Global.sharedInstance.isHoursSelected.contains(true) {
                    BlueviewBorder.isHidden = true
                }
                else
                {
                    BlueviewBorder.isHidden = false
                }
            } else { //rest business hours
                if  Global.sharedInstance.isHoursSelectedRest.contains(true) {
                    
                    BlueviewBorder.isHidden = true
                }
                else
                {
                    BlueviewBorder.isHidden = false
                }
            }
        }
        else
        {
            if Global.sharedInstance.addRecess == false//Selects hours and not breaks
            {
                //check if is selected at last one day
                if  Global.sharedInstance.isHoursSelectedChild.contains(true) {
                    BlueviewBorder.isHidden = true
                }
                else
                {
                    BlueviewBorder.isHidden = false
                }
            } else { //rest business hours
                if  Global.sharedInstance.isHoursSelectedRestChild.contains(true) {
                    BlueviewBorder.isHidden = true
                }
                else
                {
                    BlueviewBorder.isHidden = false
                }
            }
        }
        // }
        //        if  Global.sharedInstance.defaults.integerForKey("CHOOSEN_LANGUAGE") == 0 {
        //          //hebwr
        //                    var scalingTransform : CGAffineTransform!
        //                    scalingTransform = CGAffineTransformMakeScale(-1, 1)
        //                    Blueview.transform = scalingTransform
        //
        //        }
        
        
        
    }
    //JMODE FIX
    func showSelectedHoursAndDaysChild()
    {
        DayFlagArr = [0,0,0,0,0,0,0]
        Global.sharedInstance.hourShowChild = ""
        
        for i in 0 ..< 7
        {
            if Global.sharedInstance.isHoursSelectedChild[i] == true
            {
                if DayFlagArr[i] != 1
                {
                    if Global.sharedInstance.arrWorkHoursChild[i].nvFromHour != "" && !(Global.sharedInstance.arrWorkHoursChild[i].nvFromHour == "00:00:00" && Global.sharedInstance.arrWorkHoursChild[i].nvToHour == "00:00:00")
                    {
                        for j in 0 ..< 7
                        {
                            if Global.sharedInstance.isHoursSelectedChild[j] == true
                            {
                                if Global.sharedInstance.arrWorkHoursChild[i].nvFromHour == Global.sharedInstance.arrWorkHoursChild[j].nvFromHour &&
                                    Global.sharedInstance.arrWorkHoursChild[i].nvToHour == Global.sharedInstance.arrWorkHoursChild[j].nvToHour
                                {
                                    Global.sharedInstance.hourShowChild = "\(Global.sharedInstance.hourShowChild) \(convertDays(j)),"
                                    DayFlagArr[j] = 1
                                }
                            }
                        }
                        Global.sharedInstance.hourShowChild = String(Global.sharedInstance.hourShowChild.characters.dropLast())
                        Global.sharedInstance.hourShowChild = "\(Global.sharedInstance.hourShowChild) - "
                        
                        if Global.sharedInstance.isHoursSelected[i] == true
                        {
                            Global.sharedInstance.hourShowChild = "\(Global.sharedInstance.hourShowChild) \(cutHour(Global.sharedInstance.arrWorkHoursChild[i].nvFromHour))-\(cutHour(Global.sharedInstance.arrWorkHoursChild[i].nvToHour)),"
                        }
                    }
                }
            }
        }
        Global.sharedInstance.hourShowChild = String(Global.sharedInstance.hourShowChild.characters.dropLast())
        lblHoursShow.text = Global.sharedInstance.hourShowChild
        lblHoursShow.setNeedsLayout()
        //   lblHoursShow.layoutIfNeeded()
        
        
        
        // delagetReloadHeight.beginHeightUpdate()
        delagetReloadHeight.reloadHeight()
        //delagetReloadHeight.reloadTbl()
    }
    
    func showSelectedRecessAndDaysChild()
    {
        
        DayFlagArr = [0,0,0,0,0,0,0]
        Global.sharedInstance.hourShowRecessChild = ""
        
        for i in 0 ..< 7
        {
            if Global.sharedInstance.isHoursSelectedRestChild[i] == true
            {
                if DayFlagArr[i] != 1
                {
                    if Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour != "" && !(Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour == "00:00:00" && Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour == "00:00:00")
                    {
                        for j in 0 ..< 7
                        {
                            if Global.sharedInstance.isHoursSelectedRestChild[j] == true
                            {
                                if Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour == Global.sharedInstance.arrWorkHoursRestChild[j].nvFromHour && Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour == Global.sharedInstance.arrWorkHoursRestChild[j].nvToHour
                                {
                                    Global.sharedInstance.hourShowRecessChild  = "\(Global.sharedInstance.hourShowRecessChild ) \(convertDays(j)),"
                                    DayFlagArr[j] = 1
                                }
                            }
                        }
                        Global.sharedInstance.hourShowRecessChild = String(Global.sharedInstance.hourShowRecessChild.characters.dropLast())
                        Global.sharedInstance.hourShowRecessChild = "\(Global.sharedInstance.hourShowRecessChild) - "
                        
                        if Global.sharedInstance.isHoursSelectedRestChild[i] == true
                        {
                            Global.sharedInstance.hourShowRecessChild  = "\(Global.sharedInstance.hourShowRecessChild ) \(cutHour(Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour))-\(cutHour(Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour)),"
                        }
                    }
                }
            }
        }
        Global.sharedInstance.hourShowRecessChild = String(Global.sharedInstance.hourShowRecessChild.characters.dropLast())
        
        if Global.sharedInstance.hourShowRecessChild != ""
        {
            Global.sharedInstance.hourShowRecessChild = "\("RECESS".localized(LanguageMain.sharedInstance.USERLANGUAGE)):\(Global.sharedInstance.hourShowRecessChild)"
        }
        lblRestShow.text = Global.sharedInstance.hourShowRecessChild
        lblRestShow.setNeedsLayout()
        //    lblRestShow.layoutIfNeeded()
        
        
        
        delagetReloadHeight.reloadHeight()
        //    delagetReloadHeight.reloadTbl()
        
    }
    func onetime() {
        DayFlagArr = [0,0,0,0,0,0,0]
        Global.sharedInstance.hourShowChild = ""
        
        for i in 0 ..< 7
        {
            if Global.sharedInstance.isHoursSelectedChild[i] == true
            {
                if DayFlagArr[i] != 1
                {
                    if Global.sharedInstance.arrWorkHoursChild[i].nvFromHour != "" && !(Global.sharedInstance.arrWorkHoursChild[i].nvFromHour == "00:00:00" && Global.sharedInstance.arrWorkHoursChild[i].nvToHour == "00:00:00")
                    {
                        for j in 0 ..< 7
                        {
                            if Global.sharedInstance.isHoursSelectedChild[j] == true
                            {
                                if Global.sharedInstance.arrWorkHoursChild[i].nvFromHour == Global.sharedInstance.arrWorkHoursChild[j].nvFromHour &&
                                    Global.sharedInstance.arrWorkHoursChild[i].nvToHour == Global.sharedInstance.arrWorkHoursChild[j].nvToHour
                                {
                                    Global.sharedInstance.hourShowChild = "\(Global.sharedInstance.hourShowChild) \(convertDays(j)),"
                                    DayFlagArr[j] = 1
                                }
                            }
                        }
                        Global.sharedInstance.hourShowChild = String(Global.sharedInstance.hourShowChild.characters.dropLast())
                        Global.sharedInstance.hourShowChild = "\(Global.sharedInstance.hourShowChild) - "
                        
                        if Global.sharedInstance.isHoursSelected[i] == true
                        {
                            Global.sharedInstance.hourShowChild = "\(Global.sharedInstance.hourShowChild) \(cutHour(Global.sharedInstance.arrWorkHoursChild[i].nvFromHour))-\(cutHour(Global.sharedInstance.arrWorkHoursChild[i].nvToHour)),"
                        }
                    }
                }
            }
        }
        Global.sharedInstance.hourShowChild = String(Global.sharedInstance.hourShowChild.characters.dropLast())
        lblHoursShow.text = Global.sharedInstance.hourShowChild
        
        
        lblHoursShow.setNeedsLayout()
        //   lblHoursShow.layoutIfNeeded()
        DayFlagArr = [0,0,0,0,0,0,0]
        Global.sharedInstance.hourShowRecessChild = ""
        
        for i in 0 ..< 7
        {
            if Global.sharedInstance.isHoursSelectedRestChild[i] == true
            {
                if DayFlagArr[i] != 1
                {
                    if Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour != "" && !(Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour == "00:00:00" && Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour == "00:00:00")
                    {
                        for j in 0 ..< 7
                        {
                            if Global.sharedInstance.isHoursSelectedRestChild[j] == true
                            {
                                if Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour == Global.sharedInstance.arrWorkHoursRestChild[j].nvFromHour && Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour == Global.sharedInstance.arrWorkHoursRestChild[j].nvToHour
                                {
                                    Global.sharedInstance.hourShowRecessChild  = "\(Global.sharedInstance.hourShowRecessChild ) \(convertDays(j)),"
                                    DayFlagArr[j] = 1
                                }
                            }
                        }
                        Global.sharedInstance.hourShowRecessChild = String(Global.sharedInstance.hourShowRecessChild.characters.dropLast())
                        Global.sharedInstance.hourShowRecessChild = "\(Global.sharedInstance.hourShowRecessChild) - "
                        
                        if Global.sharedInstance.isHoursSelectedRestChild[i] == true
                        {
                            Global.sharedInstance.hourShowRecessChild  = "\(Global.sharedInstance.hourShowRecessChild ) \(cutHour(Global.sharedInstance.arrWorkHoursRestChild[i].nvFromHour))-\(cutHour(Global.sharedInstance.arrWorkHoursRestChild[i].nvToHour)),"
                        }
                    }
                }
            }
        }
        Global.sharedInstance.hourShowRecessChild = String(Global.sharedInstance.hourShowRecessChild.characters.dropLast())
        
        if Global.sharedInstance.hourShowRecessChild != ""
        {
            Global.sharedInstance.hourShowRecessChild = "\("RECESS".localized(LanguageMain.sharedInstance.USERLANGUAGE)):\(Global.sharedInstance.hourShowRecessChild)"
        }
        lblRestShow.text = Global.sharedInstance.hourShowRecessChild
        
        lblRestShow.setNeedsLayout()
        //  lblRestShow.layoutIfNeeded()
        
        
    }
}
extension HoursActiveTableViewCell: LFTimePickerDelegate {
    
    func didPickTime(_ start: String, end: String) {
        //        self.lblStartSelectedTime.text = start
        //
        //        self.lblFinishSelectedTime.text = end
        
        print(start)
        print(end)
    }
}
