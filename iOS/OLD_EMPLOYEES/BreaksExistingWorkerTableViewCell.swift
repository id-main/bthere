//  BreaksExistingWorkerTableViewCell.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu 22/02/2018 this is clean and closed
//  Copyright © 2017 Bthere. All rights reserved.
//

import UIKit


class BreaksExistingWorkerTableViewCell: UITableViewCell {
    var generic = Generic()
    var DayFlagArr:Array<Int> = [0,0,0,0,0,0,0]
    var dateFormatter = DateFormatter()
    var outputFormatter: DateFormatter = DateFormatter()
    var daybtnarray:Array<UIButton> = Array<UIButton>() //days buttons
    var rectangleCheckdaybtnarray:Array<RoundRectangleCheckBox> = Array<RoundRectangleCheckBox>() //rectangle check boxes above days buttons
    var arrWorkHoursRest:Array<objWorkingHours> = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
    var arrWorkHours:Array<objWorkingHours> = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
    var DELEGATERELOAD:reloadTblDelegateParentWorkers!=nil
    @IBOutlet weak var btnDay1: dayCheckBox!
    @IBOutlet weak var btnDay2: dayCheckBox!
    @IBOutlet weak var btnDay3: dayCheckBox!
    @IBOutlet weak var btnDay4: dayCheckBox!
    @IBOutlet weak var btnDay5: dayCheckBox!
    @IBOutlet weak var btnDay6: dayCheckBox!
    @IBOutlet weak var btnDay7: dayCheckBox!
    @IBOutlet weak var rectangleCheckBtnDay1: RoundRectangleCheckBox!
    @IBOutlet weak var rectangleCheckBtnDay2: RoundRectangleCheckBox!
    @IBOutlet weak var rectangleCheckBtnDay3: RoundRectangleCheckBox!
    @IBOutlet weak var rectangleCheckBtnDay4: RoundRectangleCheckBox!
    @IBOutlet weak var rectangleCheckBtnDay5: RoundRectangleCheckBox!
    @IBOutlet weak var rectangleCheckBtnDay6: RoundRectangleCheckBox!
    @IBOutlet weak var rectangleCheckBtnDay7: RoundRectangleCheckBox!
    @IBOutlet weak var btnSelectAllDays: UIButton!
    @IBOutlet weak var dtFromHour: UIDatePicker!
    @IBOutlet weak var dtToHour: UIDatePicker!
    @IBOutlet weak var lblChooseAll: UILabel!
    @IBOutlet weak var viewSelectAllDays: UIView!
    @IBOutlet weak var MAINVIEW:UIView!
    //FUNCTIONS
    func hidetoast(){
        self.hideToastActivity()
    }
    @objc func allfromlabeltap() {
          btnSelectAllDays(btnSelectAllDays)
    }
    func showerroemessageforselectall() {
        DELEGATERELOAD.showerroemessageforselectall()
    }
   
   
    @IBAction func btnSelectAllDays(_ sender: AnyObject)
    {
        btnSelectAllDays.isSelected =  !btnSelectAllDays.isSelected
        print ("checkifcanselectalldays  \(checkifcanselectalldays())")
        if btnSelectAllDays.currentImage == (UIImage(named: "15a.png")) {
            //deselect all
            for i in 0...6 {
                daybtnarray[i].backgroundColor = UIColor.darkGray
                DayFlagArr[i] = 0
                arrWorkHoursRest[i] = objWorkingHours()
                Global.sharedInstance.isHoursSelectedRest[i] = false
//                rectangleCheckdaybtnarray[i].isChecked = false
//                rectangleCheckdaybtnarray[i].userInteractionEnabled = false
            }
            Global.sharedInstance.arrWorkHoursRest = arrWorkHoursRest
            btnSelectAllDays.setImage(UIImage(named: "9.png"), for: UIControl.State())
            DELEGATERELOAD.reloadTbl()
            
        } else {
            if checkifcanselectalldays() == true {
                selectAllTap()
                btnSelectAllDays.setImage(UIImage(named: "15a.png"), for: UIControl.State())
            }
            else {
                var isnonesecled:Bool = true
                for i in 0...6 {
                    if Global.sharedInstance.isHoursSelectedRest[i] == true
                    {
                        isnonesecled = false
                        break
                    }
                }
                if isnonesecled == true {
                    showerroemessageforselectall()
                }
                btnSelectAllDays.setImage(UIImage(named: "9.png"), for: UIControl.State())
            }
        }
        
    }
    @IBAction func rectangleCheckBtnDay(_ sender:AnyObject) {
        let neededtag = sender.tag
  //      rectangleCheckdaybtnarray[neededtag].isChecked = !rectangleCheckdaybtnarray[neededtag].isChecked
        if rectangleCheckdaybtnarray[neededtag!].currentImage! == (UIImage(named: "patrat.png"))! {
//            if   daybtnarray[neededtag].backgroundColor == Colors.sharedInstance.darkred {
//                if   Global.sharedInstance.isHoursSelectedRest[neededtag] == false {
//                    daybtnarray[neededtag].backgroundColor = UIColor.darkGrayColor()
//                    DayFlagArr[neededtag] = 0
//                    arrWorkHoursRest[neededtag] = objWorkingHours()
//                    Global.sharedInstance.isHoursSelectedRest[neededtag] = false
//                    Global.sharedInstance.arrWorkHoursRest = arrWorkHoursRest
//                    DELEGATERELOAD.reloadTbl()
//                } 
//            }
            for daybtn in daybtnarray {
                if daybtn.backgroundColor == Colors.sharedInstance.darkred { //we know was in edit mode and now we need to close
                    let neededtag = daybtn.tag
                    let completedHOURS = arrWorkHoursRest[neededtag]
                    
                    if (completedHOURS.nvFromHour != completedHOURS.nvToHour  && completedHOURS.nvFromHour != "" &&  completedHOURS.nvToHour != "" ) {
                        let WorkingBusines:objWorkingHours =  Global.sharedInstance.arrWorkHours[neededtag]
                        if WorkingBusines.nvFromHour >= completedHOURS.nvFromHour ||  WorkingBusines.nvToHour <= completedHOURS.nvToHour {
                           DELEGATERELOAD.showerroemessageincorrectbreaks()
                            daybtnarray[neededtag].backgroundColor = UIColor.darkGray
                            DayFlagArr[neededtag] = 0
                            arrWorkHoursRest[neededtag] = objWorkingHours()
                            Global.sharedInstance.isHoursSelectedRest[neededtag] = false
                            rectangleCheckdaybtnarray[neededtag].isChecked = false
                            Global.sharedInstance.arrWorkHoursRest = arrWorkHoursRest
                        } else {
                            daybtnarray[neededtag].backgroundColor = Colors.sharedInstance.color3
                            DayFlagArr[neededtag] = 0
                            arrWorkHoursRest[neededtag] = completedHOURS
                            Global.sharedInstance.isHoursSelectedRest[neededtag] = true
                            rectangleCheckdaybtnarray[neededtag].isChecked = true
                            Global.sharedInstance.arrWorkHoursRest = arrWorkHoursRest
                            //                        rectangleCheckdaybtnarray[neededtag].userInteractionEnabled = true
                        }
                    } else {
                        //no hours selected
                        daybtnarray[neededtag].backgroundColor = UIColor.darkGray
                        DayFlagArr[neededtag] = 0
                        arrWorkHoursRest[neededtag] = objWorkingHours()
                        Global.sharedInstance.isHoursSelectedRest[neededtag] = false
                        rectangleCheckdaybtnarray[neededtag].isChecked = false
                        Global.sharedInstance.arrWorkHoursRest = arrWorkHoursRest
                        //                        rectangleCheckdaybtnarray[neededtag].userInteractionEnabled = false
                    }
                }
            }
             DELEGATERELOAD.reloadTbl()
        } else {
            //remove selected hours from array and make day button black again
            daybtnarray[neededtag!].backgroundColor = UIColor.darkGray
            DayFlagArr[neededtag!] = 0
            arrWorkHoursRest[neededtag!] = objWorkingHours()
            Global.sharedInstance.isHoursSelectedRest[neededtag!] = false
            Global.sharedInstance.arrWorkHoursRest = arrWorkHoursRest
            DELEGATERELOAD.reloadTbl()
        }
        
    }
    @IBAction func btnSelectDay(_ sender:AnyObject) {
        let neededtag = sender.tag
        daybtnarray[neededtag!].isSelected = !daybtnarray[neededtag!].isSelected
        
        let completedHOURS = arrWorkHoursRest[neededtag!]
        if daybtnarray[neededtag!].isSelected == true {
            dtFromHour.isUserInteractionEnabled = true
            dtToHour.isUserInteractionEnabled = true
            if (completedHOURS.nvFromHour != completedHOURS.nvToHour  && completedHOURS.nvFromHour != "" &&  completedHOURS.nvToHour != "" ) {
                //the hours were already selected
                daybtnarray[neededtag!].backgroundColor = Colors.sharedInstance.darkred //Colors.sharedInstance.color3
                DayFlagArr[neededtag!] = 1
                arrWorkHoursRest[neededtag!] = completedHOURS
            }
            else {
                //hours must be edited
                daybtnarray[neededtag!].backgroundColor = Colors.sharedInstance.darkred
                DayFlagArr[neededtag!] = 1
                var workingHoursTEST:objWorkingHours = objWorkingHours()
                workingHoursTEST = objWorkingHours(
                    _iDayInWeekType: sender.tag,
                    _nvFromHour: "00:00:00",
                    _nvToHour: "00:00:00")
                arrWorkHoursRest[neededtag!] = workingHoursTEST
            }
            Global.sharedInstance.arrWorkHoursRest = arrWorkHoursRest
        }
            //closed
            //hours were selected
            
        else {
            //here is made for all buttons selected because you can have multiple red but one tap reloads table
            for daybtn in daybtnarray {
                if daybtn.backgroundColor == Colors.sharedInstance.darkred { //we know was in edit mode and now we need to close
                    let neededtag = daybtn.tag
                    let completedHOURS = arrWorkHoursRest[neededtag]
                   
                    if (completedHOURS.nvFromHour != completedHOURS.nvToHour  && completedHOURS.nvFromHour != "" &&  completedHOURS.nvToHour != "" ) {
                        let WorkingBusines:objWorkingHours =  Global.sharedInstance.arrWorkHours[neededtag]
                        if WorkingBusines.nvFromHour >= completedHOURS.nvFromHour ||  WorkingBusines.nvToHour <= completedHOURS.nvToHour {
                           DELEGATERELOAD.showerroemessageincorrectbreaks()
                            daybtnarray[neededtag].backgroundColor = UIColor.darkGray
                            DayFlagArr[neededtag] = 0
                            arrWorkHoursRest[neededtag] = objWorkingHours()
                            Global.sharedInstance.isHoursSelectedRest[neededtag] = false
                            rectangleCheckdaybtnarray[neededtag].isChecked = false
                            Global.sharedInstance.arrWorkHoursRest = arrWorkHoursRest
                        } else {
                        daybtnarray[neededtag].backgroundColor = Colors.sharedInstance.color3
                        DayFlagArr[neededtag] = 0
                        arrWorkHoursRest[neededtag] = completedHOURS
                        Global.sharedInstance.isHoursSelectedRest[neededtag] = true
                        rectangleCheckdaybtnarray[neededtag].isChecked = true
                            Global.sharedInstance.arrWorkHoursRest = arrWorkHoursRest
//                        rectangleCheckdaybtnarray[neededtag].userInteractionEnabled = true
                        }
                    } else {
                        //no hours selected
                        daybtnarray[neededtag].backgroundColor = UIColor.darkGray
                        DayFlagArr[neededtag] = 0
                        arrWorkHoursRest[neededtag] = objWorkingHours()
                        Global.sharedInstance.isHoursSelectedRest[neededtag] = false
                        rectangleCheckdaybtnarray[neededtag].isChecked = false
                        Global.sharedInstance.arrWorkHoursRest = arrWorkHoursRest
//                        rectangleCheckdaybtnarray[neededtag].userInteractionEnabled = false
                    }
                }
            }
            var btnselect = false
            for item in daybtnarray {
                if item.backgroundColor == Colors.sharedInstance.color3 ||  item.backgroundColor == Colors.sharedInstance.darkred  {
                    btnselect = true
                    break
                }
            }
            if btnselect == true {
                dtFromHour.isUserInteractionEnabled = true
                dtToHour.isUserInteractionEnabled = true
            } else {
                DELEGATERELOAD.showerroemessagenodays()
                dtFromHour.isUserInteractionEnabled = false
                dtToHour.isUserInteractionEnabled = false
            }
            Global.sharedInstance.arrWorkHoursRest = arrWorkHoursRest
            DELEGATERELOAD.reloadTbl()
        }
        
        print("all days /////////////////////////////////////////////")
        for item in arrWorkHoursRest {
            print("all days \(item.getDic())")
        }
        print("all days /////////////////////////////////////////////\n\n")
    }
    func checkifcanselectalldays() ->Bool {
        
        var previousFrom = ""
        var currentFrom = ""
        var previousTo = ""
        var currentTo = ""
        var fIsEquals = true
        var isatleastoneselected = false
        for i in 0...6 {
            if Global.sharedInstance.isHoursSelectedRest[i] == true {
                isatleastoneselected = true
                break
            }
        }
        if isatleastoneselected == true {
            for i in 0...6
            {
                if Global.sharedInstance.isHoursSelectedRest[i] == true
                {
                    
                    currentFrom = Global.sharedInstance.arrWorkHoursRest[i].nvFromHour
                    currentTo = Global.sharedInstance.arrWorkHoursRest[i].nvToHour
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
        } else {
            
            fIsEquals = false
            
        }
        
        return fIsEquals
    }
    
    
    @objc func selectAllTap()
    {
        var currentFrom = ""
        var currentTo = ""
        var perfectFrom = ""
        var prefectTo = ""
        var workingHoursTEST:objWorkingHours = objWorkingHours()
        for i in 0...6
        {
            if Global.sharedInstance.isHoursSelectedRest[i] == true
            {
                currentFrom = Global.sharedInstance.arrWorkHoursRest[i].nvFromHour
                currentTo = Global.sharedInstance.arrWorkHoursRest[i].nvToHour
                if currentFrom != currentTo {
                    perfectFrom = currentFrom
                    prefectTo = currentTo
                    break
                }
            }
        }
        for item in daybtnarray {
            if item.isUserInteractionEnabled != false {
              item.backgroundColor = Colors.sharedInstance.color3
            }
            
            
        }
        for i in 0...6 {
            if daybtnarray[i].isUserInteractionEnabled != false {
            workingHoursTEST = objWorkingHours(
                _iDayInWeekType: i,
                _nvFromHour: perfectFrom,
                _nvToHour: prefectTo)
            arrWorkHoursRest[i] = workingHoursTEST
            Global.sharedInstance.isHoursSelectedRest[i] = true
            } else {
                Global.sharedInstance.isHoursSelectedRest[i] = false
                var workingHoursTEST:objWorkingHours = objWorkingHours()
                workingHoursTEST = objWorkingHours(
                    _iDayInWeekType: i,
                    _nvFromHour: "00:00:00",
                    _nvToHour: "00:00:00")
               arrWorkHoursRest[i] = workingHoursTEST
            }
        }
        Global.sharedInstance.arrWorkHoursRest = arrWorkHoursRest
        print("all days /////////////////////////////////////////////")
        for item in arrWorkHoursRest {
            print("all days \(item.getDic())")
        }
        print("all days /////////////////////////////////////////////\n\n")
        DELEGATERELOAD.reloadTbl()
    }
    @objc func handleDatePicker(_ sender: UIDatePicker)
    {
        Global.sharedInstance.fIsEmptyOwnerHours = false
        Global.sharedInstance.flagIfValidSection1 = true
        let outputFormatter: DateFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm:00"
        let nvFromHour = outputFormatter.string(from: dtFromHour.date)
        let nvToHour = outputFormatter.string(from: dtToHour.date)
        switch (sender) {
            
        case dtFromHour:
            //first check if start hour selected is greater than working hours preselected and end hour is less than end working preselected
            if (dtToHour.date > dtFromHour.date   ) {
                for item in  daybtnarray {
                    let myindex = daybtnarray.index(of: item)
                    //all  items opened to edit
                    if item.backgroundColor == Colors.sharedInstance.darkred  {
                     
                        var workingHoursTEST:objWorkingHours = objWorkingHours()
                        workingHoursTEST = objWorkingHours(
                            _iDayInWeekType: myindex!,
                            _nvFromHour: nvFromHour,
                            _nvToHour: nvToHour)
                        arrWorkHoursRest[myindex!] = workingHoursTEST
                        
                    }
                }
                
            } else {
                for item in  daybtnarray {
                    let myindex = daybtnarray.index(of: item)
                    if item.backgroundColor == Colors.sharedInstance.darkred {
                        
                        arrWorkHoursRest[myindex!] = objWorkingHours()
                    }
                }
            }
            
            break
            
        case dtToHour:
            if (dtToHour.date > dtFromHour.date ) {
                for item in  daybtnarray {
                    let myindex = daybtnarray.index(of: item)
                    //all  items opened to edit
                    if item.backgroundColor == Colors.sharedInstance.darkred  {

                            var workingHoursTEST:objWorkingHours = objWorkingHours()
                            workingHoursTEST = objWorkingHours(
                                _iDayInWeekType: myindex!,
                                _nvFromHour: nvFromHour,
                                _nvToHour: nvToHour)
                            arrWorkHoursRest[myindex!] = workingHoursTEST
                        
                    }
                }
                
            } else {
                for item in  daybtnarray {
                    let myindex = daybtnarray.index(of: item)
                    if item.backgroundColor == Colors.sharedInstance.darkred {
                        
                        arrWorkHoursRest[myindex!] = objWorkingHours()
                    }
                }
            }
            break
            
        default:
            print("nocase")
            break
        }
        print("all days /////////////////////////////////////////////")
        for item in arrWorkHoursRest {
            print("all days \(item.getDic())")
        }
        print("all days /////////////////////////////////////////////\n\n")
    }
    
    
    ///INTERFACE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.MAINVIEW.layer.borderWidth = 10
        self.MAINVIEW.layer.borderColor = Colors.sharedInstance.color3.cgColor
        btnDay1.setTitle("SUNDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay2.setTitle("MONDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay3.setTitle("TUESDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay4.setTitle("WEDNSDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay5.setTitle("THIRTHDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay6.setTitle("FRIDAY2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        btnDay7.setTitle("SHABAT2".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControl.State())
        lblChooseAll.text = "CHOOSE_ALL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        daybtnarray = [btnDay1,btnDay2,btnDay3,btnDay4,btnDay5,btnDay6,btnDay7]
        rectangleCheckdaybtnarray = [rectangleCheckBtnDay1, rectangleCheckBtnDay2, rectangleCheckBtnDay3, rectangleCheckBtnDay4, rectangleCheckBtnDay5, rectangleCheckBtnDay6, rectangleCheckBtnDay7]
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(allfromlabeltap))
        tap.delegate = self
        viewSelectAllDays.addGestureRecognizer(tap)
        self.contentView.bringSubviewToFront(viewSelectAllDays)
        //        this  fixes uipicker being flipped
        for view in dtFromHour.subviews {
            let USERDEF = UserDefaults.standard
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                view.semanticContentAttribute = .forceRightToLeft
            } else {
                view.semanticContentAttribute = .forceLeftToRight
            }
        }
        for view in dtToHour.subviews {
            let USERDEF = UserDefaults.standard
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                view.semanticContentAttribute = .forceRightToLeft
            } else {
                view.semanticContentAttribute = .forceLeftToRight
            }
        }
      
      
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        //  super.setSelected(selected, animated: animated)
        //  Configure the view for the selected state
    }
    override func layoutSubviews(){
        dtToHour.setValue(UIColor.white, forKeyPath: "textColor")
        dtFromHour.setValue(UIColor.white, forKeyPath: "textColor")
        dtToHour.backgroundColor = UIColor.black
        dtFromHour.backgroundColor = UIColor.black
        if Global.sharedInstance.isSelectAllRest == true
        {
            btnSelectAllDays.setImage(UIImage(named: "15a.png"), for: UIControl.State())
        }
        else
        {
            btnSelectAllDays.setImage(UIImage(named: "9.png"), for: UIControl.State())
        }
        dateFormatter.dateFormat = "HH:mm:00"
        outputFormatter.dateFormat  = "HH:mm:00"
        dtFromHour.locale = Locale(identifier: "en_GB") //  set datePicker to 24 format without am/pm
        dtToHour.locale = Locale(identifier: "en_GB")
      
        dtFromHour.setDate ( dateFormatter.date(from: "00:00:00")!, animated:  true )
        dtToHour.setDate ( dateFormatter.date(from: "00:00:00")!, animated:  true )
        dtFromHour.isUserInteractionEnabled = false
        dtToHour.isUserInteractionEnabled = false
        dtToHour.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        dtFromHour.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        arrWorkHoursRest = Global.sharedInstance.arrWorkHoursRest
        arrWorkHours = Global.sharedInstance.arrWorkHours
        for i in 0...6 {
            if Global.sharedInstance.isHoursSelected[i] == true {
                daybtnarray[i].isUserInteractionEnabled = true
            } else {
                daybtnarray[i].isUserInteractionEnabled = false
                daybtnarray[i].setTitleColor(UIColor.darkGray, for: UIControl.State())
                daybtnarray[i].setBackgroundImage(UIImage(named: "hash anca.png"), for: UIControl.State())
                daybtnarray[i].alpha = 0.7
                rectangleCheckdaybtnarray[i].setBackgroundImage(UIImage(named: "hash anca.png"), for: UIControl.State())
                rectangleCheckdaybtnarray[i].isUserInteractionEnabled = false
                rectangleCheckdaybtnarray[i].alpha = 0.7
            }
        }
        var ycount:Int = 0
        for i in 0 ..< 7
        {
            if Global.sharedInstance.isHoursSelectedRest[i] == true
            {
                ycount += 1
                daybtnarray[i].backgroundColor = Colors.sharedInstance.color3
                rectangleCheckdaybtnarray[i].isChecked = true
               // rectangleCheckdaybtnarray[i].userInteractionEnabled = true
            }
            else {
                rectangleCheckdaybtnarray[i].isChecked = false
             //   rectangleCheckdaybtnarray[i].userInteractionEnabled = false
            }
        }
        if ycount == 7 && checkifcanselectalldays() == true {
            btnSelectAllDays.setImage(UIImage(named: "15a.png"), for: UIControl.State())
        }
        else {
            btnSelectAllDays.setImage(UIImage(named: "9.png"), for: UIControl.State())
        }
        changeRectangleColorandBorder()
        
    }
    func changeRectangleColorandBorder() {
        MAINVIEW.layer.borderColor = Colors.sharedInstance.color3.cgColor
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .pad {
        if  Global.sharedInstance.isHoursSelectedRest.contains(true) {
            MAINVIEW.layer.borderWidth = 10
        } else {
            MAINVIEW.layer.borderWidth = 18
        }
        } else {
            if  Global.sharedInstance.isHoursSelectedRest.contains(true) {
                MAINVIEW.layer.borderWidth = 8
            } else {
                MAINVIEW.layer.borderWidth = 14
            }

        }
        
    }
}
