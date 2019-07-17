//
//  CalendarSettingsEditWorkingHoursCell.swift
//  bthree-ios
//
//  Created by Ioan Ungureanu on 29/03/2019
//  Copyright © 2018 BThere. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class CalendarSettingsEditWorkingHoursCell: UITableViewCell {
    let calendar = Foundation.Calendar.current
    var dateFormatter = DateFormatter()
    var outputFormatter: DateFormatter = DateFormatter()
    var delegate:isOpenRowDelegate8!=nil
    var indexSection:Int = 0
    var hourstart = ""
    var hourend = ""
    var hourstartSecond = ""
    var hourendSecond = ""
    var isValidFirst:Bool = false
    var isValidSecond:Bool = false
    var addHoursPressed:Bool = false
    var addSecondHoursPressed:Bool = false
    var _isinEDIT:Bool = false
    var _isinEDITSECOND:Bool = false
    var _isinADD:Bool = false
    @IBOutlet var lblDescDay: UILabel!
    @IBOutlet var RowSelectedHours1: UILabel!
    @IBOutlet var RowSelectedHours2: UILabel!
    @IBOutlet weak var FROM_LABEL:UILabel!
    @IBOutlet weak var UNTIL_LABEL:UILabel!
    @IBOutlet weak var AddHoursButton:UIButton!
    //\\    @IBOutlet weak var EditHoursButton:UIButton!
    @IBOutlet weak var SAVEAddHoursButton:UIButton!
    @IBOutlet weak var dtFromHour:UIDatePicker!
    @IBOutlet weak var dtToHour:UIDatePicker!
    @IBOutlet weak var mySwitch:UISwitch!
    @IBAction func SAVEAddHoursButton(_ sender:UIButton) {
        // 1. check interval one
        // 2. check interval two
        // 3. put in array
        // 4. inactivate
        var workingHoursTEST = objWorkingHours()
        var workingHoursTEST2 = objWorkingHours()

        if self.isValidFirst == true {
            if hourstart != "" &&  hourend != "" {
            let finalhour = hourstart + ":00"
            let finalendhour = hourend + ":00"
            workingHoursTEST = objWorkingHours(
                _iDayInWeekType: self.indexSection + 1,
                _nvFromHour: finalhour,
                _nvToHour: finalendhour)

          //  if self.isValidSecond == true {
                if hourstartSecond != "" &&  hourendSecond != "" {
                let finalhoursecond = hourstartSecond  + ":00"
                let finalendhoursecond  = hourendSecond  + ":00"


                workingHoursTEST2 = objWorkingHours(
                    _iDayInWeekType: self.indexSection + 1,
                    _nvFromHour: finalhoursecond,
                    _nvToHour: finalendhoursecond)
                } else {
                        self.isValidSecond = false
                }
              delegate.savedDataOn(_WHICHCELL: self.indexSection, _WHICHSTATE: self.isValidFirst, _WHICHSTATE2: self.isValidSecond, _firstSel: workingHoursTEST, _secondsel: workingHoursTEST2)
            }
        } else {
            Alert.sharedInstance.showAlertDelegate("ILLEGAL_HOURS".localized(LanguageMain.sharedInstance.USERLANGUAGE))
            return
        }



     //   addHoursPressed = false
     //   addSecondHoursPressed = false

        //  delegate.openRow(_WHICHCELL: self.indexSection, _WHICHSTATE: false)
    }
    @IBAction func AddHoursButton(_ sender:UIButton) {
        // 1. open picker to last hour selected first until 23:59 only if lath selected first is less then 23:59
        // 2. check interval two
        // 3. put in second array
        //        delegate.savedDataOn(_WHICHCELL: self.indexSection, _WHICHSTATE: true)
        //        delegate.openRow(_WHICHCELL: self.indexSection, _WHICHSTATE: false)
        //save partial selected hours anyway
        if hourstart != "" &&  hourend != "" {
        var workingHoursTEST:objWorkingHours = objWorkingHours()
        let finalhour = hourstart + ":00"
        let finalendhour = hourend + ":00"
        workingHoursTEST = objWorkingHours(
            _iDayInWeekType: self.indexSection + 1,
            _nvFromHour: finalhour,
            _nvToHour: finalendhour)
        addHoursPressed = true
        addSecondHoursPressed = false
        AddHoursButton.isHidden = true

        if isValidFirst == true {
            delegate.savedDataFirstInterval(_WHICHCELL:self.indexSection, _WHICHSTATE:true, _firstSel: workingHoursTEST)
            delegate.setaddbuttonpressed(_WHICHCELL:self.indexSection)
            delegate.openRow(_WHICHCELL: self.indexSection, _WHICHSTATE: true)
        }
        }


        //set min start hour in  picker
        //  delegate.setaddbuttonpressed(_WHICHCELL: self.indexSection)

    }
    @objc func EditHoursButton() {
        addHoursPressed = false
        addSecondHoursPressed = false
        delegate.seteditbuttonpressed(_WHICHCELL:self.indexSection)
        delegate.openRow(_WHICHCELL: self.indexSection, _WHICHSTATE: true)
    }
    @objc func EditHoursSecondButton() {
        addHoursPressed = false
        addSecondHoursPressed = true
        delegate.seteditsecondbuttonpressed(_WHICHCELL:self.indexSection)
        delegate.openRow(_WHICHCELL: self.indexSection, _WHICHSTATE: true)
    }
 
    override func awakeFromNib() {
        super.awakeFromNib()
//        AddHoursButton.layer.cornerRadius = 0
//        AddHoursButton.setTitle("AddHoursButton_TEXT".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControlState())
//        AddHoursButton.titleLabel?.textColor = Colors.sharedInstance.color3
//        AddHoursButton.layer.borderColor = Colors.sharedInstance.color3.cgColor
//        AddHoursButton.layer.borderWidth =  1
//        AddHoursButton.layer.cornerRadius = 0
//        SAVEAddHoursButton.setTitle("SAVEAddHoursButton".localized(LanguageMain.sharedInstance.USERLANGUAGE), for: UIControlState())
//        SAVEAddHoursButton.backgroundColor =  Colors.sharedInstance.color4
//        FROM_LABEL.text = "FROM_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
//        UNTIL_LABEL.text = "UNTIL_LABEL".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        mySwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
        dtFromHour.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        dtToHour.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setDisplayData(_ isopen:Bool,daydesc:String, _indexsection:Int, _firstinterval: objWorkingHours, _secondinterval: objWorkingHours, _hasHoursSelected:Bool, _hasHoursSecondSelected:Bool,
                         _isinEDIT:Bool,
                         _isinEDITSECOND:Bool,
                         _isinADD:Bool) {

        if _isinEDIT == true {
            addHoursPressed = false
            addSecondHoursPressed = false
        } else
        if _isinEDITSECOND == true {
            addHoursPressed = false
            addSecondHoursPressed = true
        } else

        if _isinADD == true {
            addHoursPressed = true
            addSecondHoursPressed = false
        }
        if _isinEDIT == false && _isinEDITSECOND == false && _isinADD == false {
            addHoursPressed = false
            addSecondHoursPressed = false
        }

        //        print("first interval \(_firstinterval.getDic())")
        //        print("second interval \(_secondinterval.getDic())")
        self.indexSection = _indexsection
        if _indexsection == 5 {

            print("addpres \(addHoursPressed) \(addSecondHoursPressed) second press")
       }
        hourstart = ""
        hourend = ""
        hourstartSecond = ""
        hourendSecond = ""
        RowSelectedHours1.text = ""
        RowSelectedHours2.text = ""
        let USERDEF = UserDefaults.standard



        if mySwitch.isOn == false {
            AddHoursButton.isHidden = true
        }



        //complete labels of selected hours
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "HH:mm"
        RowSelectedHours1.text = ""
        RowSelectedHours2.text = ""
        lblDescDay.text = daydesc
        dateFormatter.dateFormat = "HH:mm:00"
        outputFormatter.dateFormat  = "HH:mm:00"
    //    print("ce am salvat \(_firstinterval.getDic())")
        //init defaults or saved

        if addHoursPressed == false && addSecondHoursPressed == false  {
            //COMPLETE FIRST INTERVAL
            if (_firstinterval.nvFromHour != "00:00:00" &&  _firstinterval.nvToHour !=  "00:00:00") || (_firstinterval.nvFromHour == "00:00:00" &&  _firstinterval.nvToHour !=  "00:00:00") {
                print( _firstinterval.nvFromHour)
                isValidFirst = true
                let USERDEF = UserDefaults.standard
                if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                    let mydatef = DateFormatter()
                    mydatef.dateStyle = .none
                    mydatef.dateFormat = "HH:mm:00"
                    let min = mydatef.date(from: "00:00:00")!      // min time
                    let max = mydatef.date(from: "23:59:00") // max time
                    dtFromHour.minimumDate = min  //setting min time to picker
                    dtFromHour.maximumDate = max
                    dtToHour.minimumDate = min
                    dtToHour.maximumDate = max
                    dtToHour.setDate ( mydatef.date(from: _firstinterval.nvFromHour)!, animated:  true )
                    dtFromHour.setDate ( mydatef.date(from: _firstinterval.nvToHour )!, animated:  true )
                    dtToHour.date =  mydatef.date(from: _firstinterval.nvFromHour)!
                    dtFromHour.date =  mydatef.date(from: _firstinterval.nvToHour)!
                    dtFromHour.reloadInputViews()
                    dtToHour.reloadInputViews()


                } else {
                    let mydatef = DateFormatter()
                    mydatef.dateStyle = .none
                    mydatef.dateFormat = "HH:mm:00"
                    let min = mydatef.date(from: "00:00:00")!      // min time
                    let max = mydatef.date(from: "23:59:00") // max time
                    dtFromHour.minimumDate = min  //setting min time to picker
                    dtFromHour.maximumDate = max
                    dtToHour.minimumDate = min
                    dtToHour.maximumDate = max
                    dtToHour.setDate ( mydatef.date(from: _firstinterval.nvToHour)!, animated:  true )
                    dtFromHour.setDate ( mydatef.date(from: _firstinterval.nvFromHour)!, animated:  true )
                    dtToHour.date =  mydatef.date(from: _firstinterval.nvToHour)!
                    dtFromHour.date =  mydatef.date(from: _firstinterval.nvFromHour)!
                    dtFromHour.reloadInputViews()
                    dtToHour.reloadInputViews()
                }
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "HH:mm"
                if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                    hourstart = dateFormatter.string(from: dtToHour.date)
                    hourend = dateFormatter.string(from: dtFromHour.date)
                } else {
                    hourstart = dateFormatter.string(from: dtFromHour.date)
                    hourend = dateFormatter.string(from: dtToHour.date)
                }
                RowSelectedHours1.text = "\(hourstart) - \(hourend)"
                  //COMPLETE SECOND INTERVAL
                ////////////////////////    precompletehoursfromsecond      ////////////////////

                if (_secondinterval.nvFromHour != "00:00:00" &&  _secondinterval.nvToHour !=  "00:00:00") || (_secondinterval.nvFromHour == "00:00:00" &&  _secondinterval.nvToHour !=  "00:00:00"){
                    print( _secondinterval.nvFromHour)
                    isValidFirst = true
                    let dateFormatterWithSeconds = DateFormatter()
                    dateFormatterWithSeconds.dateStyle = .none
                    dateFormatterWithSeconds.dateFormat = "HH:mm:00"
                    let fromHour =  dateFormatterWithSeconds.date(from: _secondinterval.nvFromHour)!
                    let toHour =  dateFormatterWithSeconds.date(from: _secondinterval.nvToHour)!
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "HH:mm"
                    hourstartSecond = dateFormatter.string(from: fromHour)
                    hourendSecond = dateFormatter.string(from: toHour)
                    RowSelectedHours2.text = "\(hourstartSecond) - \(hourendSecond)"
                    isValidSecond = true
                }
                //END OF PRECOMPLETE SECOND

            }
            else {
                if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                    let dateFormatterWithSeconds = DateFormatter()
                    dateFormatterWithSeconds.dateStyle = .none
                    dateFormatterWithSeconds.dateFormat = "HH:mm:00"
                    let min = dateFormatterWithSeconds.date(from: "00:00:00")!      // min time
                    let max = dateFormatterWithSeconds.date(from: "23:59:00") // max time
                    dtFromHour.minimumDate = min  //setting min time to picker
                    dtFromHour.maximumDate = max
                    dtToHour.minimumDate = min
                    dtToHour.maximumDate = max
                    dtToHour.setDate ( dateFormatterWithSeconds.date(from: "08:00:00")!, animated:  true )
                    dtFromHour.setDate ( dateFormatterWithSeconds.date(from: "20:00:00" )!, animated:  true )
                    dtToHour.date =  dateFormatterWithSeconds.date(from: "08:00:00")!
                    dtFromHour.date =  dateFormatterWithSeconds.date(from: "20:00:00")!
                    dtFromHour.reloadInputViews()
                    dtToHour.reloadInputViews()
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "HH:mm"
                    hourstart = dateFormatter.string(from: dtToHour.date)
                    hourend = dateFormatter.string(from: dtFromHour.date)
                    RowSelectedHours1.text = "\(hourstart) - \(hourend)"
                    isValidFirst = true
                } else {
                    let dateFormatterWithSeconds = DateFormatter()
                    dateFormatterWithSeconds.dateStyle = .none
                    dateFormatterWithSeconds.dateFormat = "HH:mm:00"
                    let min = dateFormatterWithSeconds.date(from: "00:00:00")!      //createing min time
                    let max = dateFormatterWithSeconds.date(from: "23:59:00") //creating max time
                    dtFromHour.minimumDate = min  //setting min time to picker
                    dtFromHour.maximumDate = max
                    dtToHour.minimumDate = min
                    dtToHour.maximumDate = max
                    dtToHour.setDate ( dateFormatterWithSeconds.date(from: "20:00:00")!, animated:  true )
                    dtFromHour.setDate ( dateFormatterWithSeconds.date(from: "08:00:00")!, animated:  true )
                    dtToHour.date =  dateFormatterWithSeconds.date(from: "20:00:00")!
                    dtFromHour.date =  dateFormatterWithSeconds.date(from: "08:00:00")!
                    dtFromHour.reloadInputViews()
                    dtToHour.reloadInputViews()
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "HH:mm"
                    hourstart = dateFormatter.string(from: dtFromHour.date)
                    hourend = dateFormatter.string(from: dtToHour.date)
                    RowSelectedHours1.text = "\(hourstart) - \(hourend)"
                    isValidFirst = true
                }
            }
        } else  if addHoursPressed == true &&  addSecondHoursPressed == false {
            /////////////////////////////////////////////////// ADD HOURS SECOND INTERVAL ////////////////////////////
            //setup min date
            let dateFormatterx = DateFormatter()
            dateFormatterx.dateFormat = "HH:mm"
            let USERDEF = UserDefaults.standard
            //calculate min and max based on already selected
            if (_firstinterval.nvFromHour != "00:00:00" &&  _firstinterval.nvToHour !=  "00:00:00") || (_firstinterval.nvFromHour == "00:00:00" &&  _firstinterval.nvToHour !=  "00:00:00") {
                print( _firstinterval.nvFromHour)
                isValidFirst = true
                let dateFormatterWithSeconds = DateFormatter()
                dateFormatterWithSeconds.dateStyle = .none
                dateFormatterWithSeconds.dateFormat = "HH:mm:00"
                let min = dateFormatterWithSeconds.date(from: "00:00:00")!      // min time
                let max = dateFormatterWithSeconds.date(from: "23:59:00") // max time
                if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                    dtFromHour.minimumDate = min  //setting min time to picker
                    dtFromHour.maximumDate = max
                    dtToHour.minimumDate = min
                    dtToHour.maximumDate = max
                    dtToHour.setDate ( dateFormatterWithSeconds.date(from: _firstinterval.nvFromHour)!, animated:  true )
                    dtFromHour.setDate ( dateFormatterWithSeconds.date(from: _firstinterval.nvToHour )!, animated:  true )
                    dtToHour.date =  dateFormatterWithSeconds.date(from: _firstinterval.nvFromHour)!
                    dtFromHour.date =  dateFormatterWithSeconds.date(from: _firstinterval.nvToHour)!
                    dtFromHour.reloadInputViews()
                    dtToHour.reloadInputViews()
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "HH:mm"
                    hourstart = dateFormatter.string(from: dtToHour.date)
                    hourend = dateFormatter.string(from: dtFromHour.date)
                    RowSelectedHours1.text = "\(hourstart) - \(hourend)"
                } else {
                    let dateFormatterWithSeconds = DateFormatter()
                    dateFormatterWithSeconds.dateStyle = .none
                    dateFormatterWithSeconds.dateFormat = "HH:mm:00"
                    let min = dateFormatterWithSeconds.date(from: "00:00:00")!      // min time
                    let max = dateFormatterWithSeconds.date(from: "23:59:00") // max time
                    dtFromHour.minimumDate = min  //setting min time to picker
                    dtFromHour.maximumDate = max
                    dtToHour.minimumDate = min
                    dtToHour.maximumDate = max
                    dtToHour.setDate ( dateFormatterWithSeconds.date(from: _firstinterval.nvToHour)!, animated:  true )
                    dtFromHour.setDate ( dateFormatterWithSeconds.date(from: _firstinterval.nvFromHour)!, animated:  true )
                    dtToHour.date =  dateFormatterWithSeconds.date(from: _firstinterval.nvToHour)!
                    dtFromHour.date =  dateFormatterWithSeconds.date(from: _firstinterval.nvFromHour)!
                    dtFromHour.reloadInputViews()
                    dtToHour.reloadInputViews()
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "HH:mm"
                    hourstart = dateFormatter.string(from: dtFromHour.date)
                    hourend = dateFormatter.string(from: dtToHour.date)
                    RowSelectedHours1.text = "\(hourstart) - \(hourend)"
                }
            }
            print("hourend \(hourend)")
            let dateFormatterz = DateFormatter()
            dateFormatterz.timeStyle = .none
            dateFormatterz.dateFormat = "HH:mm"

            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                if hourend != "" {
                    dtToHour.setDate ( dateFormatterz.date(from: hourend)!, animated:  true )
                }
                dtFromHour.setDate ( dateFormatterz.date(from: "23:59")!, animated:  true )
                let min = dateFormatterz.date(from: hourend)      // min time
                let max = dateFormatterz.date(from: "23:59") // max time
                dtToHour.minimumDate = min  //setting min time to picker
                dtFromHour.minimumDate = min
                dtFromHour.maximumDate = max
            } else {
                if hourend != "" {
                    dtFromHour.setDate ( dateFormatterz.date(from: hourend)!, animated:  true )
                }

                dtToHour.setDate ( dateFormatterz.date(from: "23:59")!, animated:  true )
                let min = dateFormatterz.date(from: hourend)      // min time
                let max = dateFormatterz.date(from: "23:59") // max time
                dtFromHour.minimumDate = min  //setting min time to picker
                dtToHour.minimumDate = min
                dtToHour.maximumDate = max
            }
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "HH:mm"
            if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                hourstartSecond = dateFormatter.string(from: dtToHour.date)
                hourendSecond = dateFormatter.string(from: dtFromHour.date)
            } else {
                hourstartSecond = dateFormatter.string(from: dtFromHour.date)
                hourendSecond = dateFormatter.string(from: dtToHour.date)
            }
            RowSelectedHours2.text = "\(hourstartSecond) - \(hourendSecond)"
            isValidSecond = true

    } else if  addSecondHoursPressed == true {
 ////////////////////////    addSecondHoursPressed  true     ////////////////////
 ////////////////////////    precompletehoursfromsecond      ////////////////////
            //COMPLETE FIRST INTERVAL
            if (_firstinterval.nvFromHour != "00:00:00" &&  _firstinterval.nvToHour !=  "00:00:00") || (_firstinterval.nvFromHour == "00:00:00" &&  _firstinterval.nvToHour !=  "00:00:00") {
                print( _firstinterval.nvFromHour)
                isValidFirst = true
                let dateFormatterWithSeconds = DateFormatter()
                dateFormatterWithSeconds.dateStyle = .none
                dateFormatterWithSeconds.dateFormat = "HH:mm:00"
                let fromHour =  dateFormatterWithSeconds.date(from: _firstinterval.nvFromHour)!
                let toHour =  dateFormatterWithSeconds.date(from: _firstinterval.nvToHour)!
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "HH:mm"
                hourstart = dateFormatter.string(from:fromHour)
                hourend = dateFormatter.string(from: toHour)
                RowSelectedHours1.text = "\(hourstart) - \(hourend)"
            }
            if (_secondinterval.nvFromHour != "00:00:00" &&  _secondinterval.nvToHour !=  "00:00:00") || (_secondinterval.nvFromHour == "00:00:00" &&  _secondinterval.nvToHour !=  "00:00:00"){
                print( _secondinterval.nvFromHour)
                isValidFirst = true
                let USERDEF = UserDefaults.standard
                if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                    let dateFormatterWithSeconds = DateFormatter()
                    dateFormatterWithSeconds.dateStyle = .none
                    dateFormatterWithSeconds.dateFormat = "HH:mm:00"
                    let min = dateFormatterWithSeconds.date(from: _firstinterval.nvToHour)!      // min time
                    let max = dateFormatterWithSeconds.date(from: "23:59:00")! // max time
                    dtFromHour.minimumDate = min  //setting min time to picker
                    dtFromHour.maximumDate = max
                    dtToHour.minimumDate = min
                    dtToHour.maximumDate = max
                    dtToHour.setDate ( dateFormatterWithSeconds.date(from: _secondinterval.nvFromHour)!, animated:  true )
                    dtFromHour.setDate ( dateFormatterWithSeconds.date(from: _secondinterval.nvToHour )!, animated:  true )
                    dtToHour.date =  dateFormatterWithSeconds.date(from: _secondinterval.nvFromHour)!
                    dtFromHour.date =  dateFormatterWithSeconds.date(from: _secondinterval.nvToHour)!
                    dtFromHour.reloadInputViews()
                    dtToHour.reloadInputViews()


                } else {
                    let dateFormatterWithSeconds = DateFormatter()
                    dateFormatterWithSeconds.dateStyle = .none
                    dateFormatterWithSeconds.dateFormat = "HH:mm:00"
                    let min = dateFormatterWithSeconds.date(from: _firstinterval.nvToHour)!      // min time
                    let max = dateFormatterWithSeconds.date(from: "23:59:00")! // max time
                    dtFromHour.minimumDate = min  //setting min time to picker
                    dtFromHour.maximumDate = max
                    dtToHour.minimumDate = min
                    dtToHour.maximumDate = max
                    dtToHour.setDate ( dateFormatterWithSeconds.date(from: _secondinterval.nvToHour)!, animated:  true )
                    dtFromHour.setDate ( dateFormatterWithSeconds.date(from: _secondinterval.nvFromHour)!, animated:  true )
                    dtToHour.date =  dateFormatterWithSeconds.date(from: _secondinterval.nvToHour)!
                    dtFromHour.date =  dateFormatterWithSeconds.date(from: _secondinterval.nvFromHour)!
                    dtFromHour.reloadInputViews()
                    dtToHour.reloadInputViews()
                }
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "HH:mm"
                if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                    hourstartSecond = dateFormatter.string(from: dtToHour.date)
                    hourendSecond = dateFormatter.string(from: dtFromHour.date)
                } else {
                    hourstartSecond = dateFormatter.string(from: dtFromHour.date)
                    hourendSecond = dateFormatter.string(from: dtToHour.date)
                }
                RowSelectedHours2.text = "\(hourstartSecond) - \(hourendSecond)"
                isValidSecond = true
            }


    }
        if _hasHoursSelected == false {
            RowSelectedHours1.text = ""
            RowSelectedHours2.text = ""

        }
         if _hasHoursSecondSelected == false {
            RowSelectedHours2.text = ""
        }
        mySwitch.onTintColor = Colors.sharedInstance.color4
        //        if isopen == true {
        //        mySwitch.isOn  = true
        //        } else {
        //            mySwitch.isOn  = false
        //        }



    }

    override func layoutSubviews(){
        let USERDEF = UserDefaults.standard
        //this must fix uipicker being flipped
        dtToHour.setValue(UIColor.white, forKeyPath: "textColor")
        dtFromHour.setValue(UIColor.white, forKeyPath: "textColor")
        dtToHour.backgroundColor = UIColor.black
        dtFromHour.backgroundColor = UIColor.black

        if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
            dtFromHour.locale = Locale(identifier: "he_IL") //  set datePicker to 24 format without am/pm
            dtToHour.locale = Locale(identifier: "he_IL")
        } else {
            dtFromHour.locale = Locale(identifier: "en_GB") //  set datePicker to 24 format without am/pm
            dtToHour.locale = Locale(identifier: "en_GB")
        }
        //this must fix uipicker being flipped
        for view in dtFromHour.subviews {
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {
                view.semanticContentAttribute = .forceRightToLeft

            } else {
                //this must fix uipicker being flipped
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
        for view in mySwitch.subviews {
            let USERDEF = UserDefaults.standard
            if  USERDEF.integer(forKey: "CHOOSEN_LANGUAGE") == 0 {

                view.semanticContentAttribute = .forceRightToLeft
            } else {

                view.semanticContentAttribute = .forceLeftToRight
            }
        }








    }
    @objc func switchValueDidChange() {
        if mySwitch.isOn {
            addHoursPressed = false
            addSecondHoursPressed = false
            delegate.openRow(_WHICHCELL: self.indexSection, _WHICHSTATE: true)

        } else {
            RowSelectedHours1.text = ""
            RowSelectedHours2.text = ""
            addHoursPressed = false
            addSecondHoursPressed = false
            //
            clearhours()
            clearhoursSecond()
            delegate.closeandclearWorkingHours(_WHICHCELL: self.indexSection)

        }
    }
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        // Date

        //    if isValidFirst == false {
        if addHoursPressed == false && addSecondHoursPressed == false {
            AddHoursButton.isHidden = true
            if (sender == dtFromHour) {
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "HH:mm"

                if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                    hourend =  dateFormatter.string(from: sender.date)
                    if hourstart == "" {
                        //Alert.sharedInstance.showAlertDelegate("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return
                    }
                    if hourend == "" {
                        //Alert.sharedInstance.showAlertDelegate("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return
                    }
                    let fromHourDate = dtFromHour.date
                    let toHourDate = dtToHour.date
                    switch fromHourDate.compare(toHourDate) {
                    case .orderedSame   :
                        print("The two hours are the same")
                        clearhours()
                        clearhoursSecond()
                        //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return
                    default:
                        print("diff")
                    }

                    if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                        // Hebrew
                        if (toHourDate > fromHourDate) {
                            clearhours()
                            clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                    } else {
                        // Other
                        if fromHourDate > toHourDate {
                            clearhours()
                            clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                    }
                    RowSelectedHours1.text = "\(hourstart) - \(hourend)"
                    isValidFirst = true
                    if hourend == "23:59" {
                        AddHoursButton.isHidden = true
                    } else {
                        AddHoursButton.isHidden = false
                    }
                    //clear previous rest hours
                    clearhoursSecond()
                } else {
                    hourstart =  dateFormatter.string(from: sender.date)
                    if hourstart == "" {
                        //Alert.sharedInstance.showAlertDelegate("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return
                    }
                    if hourend == "" {
                        //Alert.sharedInstance.showAlertDelegate("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return
                    }
                    let fromHourDate = dtFromHour.date
                    let toHourDate = dtToHour.date
                    switch fromHourDate.compare(toHourDate) {
                    case .orderedSame   :
                        print("The two hours are the same")
                        clearhours()
                        clearhoursSecond()
                        //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return
                    default:
                        print("diff")
                    }

                    if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                        // Hebrew
                        if (toHourDate > fromHourDate) {
                            clearhours()
                             clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                    } else {
                        // Other
                        if fromHourDate > toHourDate {
                            clearhours()
                             clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                    }
                    RowSelectedHours1.text = "\(hourstart) - \(hourend)"
                    isValidFirst = true

                    if hourend == "23:59" {
                        AddHoursButton.isHidden = true
                    } else {
                        AddHoursButton.isHidden = false
                    }
                    //clear previous rest hours
                    clearhoursSecond()

                }
            }

            // Hour end choose
            if (sender == dtToHour) {
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "HH:mm"
                if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                    hourstart = dateFormatter.string(from: sender.date)
                    if hourstart == "" {
                        //Alert.sharedInstance.showAlertDelegate("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return
                    }
                    if hourend == "" {
                        //Alert.sharedInstance.showAlertDelegate("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return
                    }
                    let fromHourDate = dtFromHour.date
                    let toHourDate = dtToHour.date
                    switch fromHourDate.compare(toHourDate) {
                    case .orderedSame   :
                        print("The two hours are the same")
                        clearhours()
                         clearhoursSecond()
                        //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return
                    default:
                        print("diff")
                    }

                    if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                        // Hebrew
                        if (toHourDate > fromHourDate) {
                            clearhours()
                             clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                    } else {
                        // Other
                        if fromHourDate > toHourDate {
                            clearhours()
                             clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                    }
                    RowSelectedHours1.text = "\(hourstart) - \(hourend)"
                    isValidFirst = true
                    if hourend == "23:59" {
                        AddHoursButton.isHidden = true
                    } else {
                        AddHoursButton.isHidden = false
                    }
                } else {
                    hourend = dateFormatter.string(from: sender.date)
                    if hourstart == "" {
                        //Alert.sharedInstance.showAlertDelegate("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return
                    }
                    if hourend == "" {
                        //Alert.sharedInstance.showAlertDelegate("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return
                    }
                    let fromHourDate = dtFromHour.date
                    let toHourDate = dtToHour.date
                    switch fromHourDate.compare(toHourDate) {
                    case .orderedSame   :
                        print("The two hours are the same")
                        clearhours()
                        clearhoursSecond()
                        //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                        return
                    default:
                        print("diff")
                    }

                    if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                        // Hebrew
                        if (toHourDate > fromHourDate) {
                            clearhours()
                             clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                    } else {
                        // Other
                        if fromHourDate > toHourDate {
                            clearhours()
                             clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                    }
                    RowSelectedHours1.text = "\(hourstart) - \(hourend)"
                    isValidFirst = true

                    if hourend == "23:59" {
                        AddHoursButton.isHidden = true
                    } else {
                        AddHoursButton.isHidden = false
                    }
                    //clear previous rest hours
                    clearhoursSecond()
                }
            }
        } else  // check if addhours was pressed and edit second row
            if addHoursPressed == true && addSecondHoursPressed == false {
                AddHoursButton.isHidden = true
                if (sender == dtFromHour) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "HH:mm"

                    if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                        hourendSecond =  dateFormatter.string(from: sender.date)
                        if hourstartSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        if hourendSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        let fromHourDate = dtFromHour.date
                        let toHourDate = dtToHour.date
                        switch fromHourDate.compare(toHourDate) {
                        case .orderedSame   :
                            print("The two hours are the same")
                            clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        default:
                            print("diff")
                        }

                        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                            // Hebrew
                            if (toHourDate > fromHourDate) {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        } else {
                            // Other
                            if fromHourDate > toHourDate {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        }
                        RowSelectedHours2.text = "\(hourstartSecond) - \(hourendSecond)"
                        isValidSecond = true
                        AddHoursButton.isHidden = true
                    } else {
                        hourstartSecond =  dateFormatter.string(from: sender.date)
                        if hourstartSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        if hourendSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        let fromHourDate = dtFromHour.date
                        let toHourDate = dtToHour.date
                        switch fromHourDate.compare(toHourDate) {
                        case .orderedSame   :
                            print("The two hours are the same")
                            clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        default:
                            print("diff")
                        }

                        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                            // Hebrew
                            if (toHourDate > fromHourDate) {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        } else {
                            // Other
                            if fromHourDate > toHourDate {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        }
                        RowSelectedHours2.text = "\(hourstartSecond) - \(hourendSecond)"
                        isValidSecond = true
                        AddHoursButton.isHidden = true

                    }
                }

                // Hour end choose
                if (sender == dtToHour) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "HH:mm"
                    if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                        hourstartSecond = dateFormatter.string(from: sender.date)
                        if hourstartSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        if hourendSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        let fromHourDate = dtFromHour.date
                        let toHourDate = dtToHour.date
                        switch fromHourDate.compare(toHourDate) {
                        case .orderedSame   :
                            print("The two hours are the same")
                            clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        default:
                            print("diff")
                        }

                        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                            // Hebrew
                            if (toHourDate > fromHourDate) {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        } else {
                            // Other
                            if fromHourDate > toHourDate {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        }
                        RowSelectedHours2.text = "\(hourstartSecond) - \(hourendSecond)"
                        isValidSecond = true
                        AddHoursButton.isHidden = true
                    } else {
                        hourendSecond = dateFormatter.string(from: sender.date)
                        if hourstartSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        if hourendSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        let fromHourDate = dtFromHour.date
                        let toHourDate = dtToHour.date
                        switch fromHourDate.compare(toHourDate) {
                        case .orderedSame   :
                            print("The two hours are the same")
                            clearhoursSecond() ///
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        default:
                            print("diff")
                        }

                        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                            // Hebrew
                            if (toHourDate > fromHourDate) {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        } else {
                            // Other
                            if fromHourDate > toHourDate {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        }
                        RowSelectedHours2.text = "\(hourstartSecond) - \(hourendSecond)"
                        isValidSecond = true
                        AddHoursButton.isHidden = true
                    }
                }
            }
            else if addSecondHoursPressed == true {
                AddHoursButton.isHidden = true
                if (sender == dtFromHour) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "HH:mm"

                    if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                        hourendSecond =  dateFormatter.string(from: sender.date)
                        if hourstartSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        if hourendSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        let fromHourDate = dtFromHour.date
                        let toHourDate = dtToHour.date
                        switch fromHourDate.compare(toHourDate) {
                        case .orderedSame   :
                            print("The two hours are the same")
                            clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        default:
                            print("diff")
                        }

                        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                            // Hebrew
                            if (toHourDate > fromHourDate) {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        } else {
                            // Other
                            if fromHourDate > toHourDate {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        }
                        RowSelectedHours2.text = "\(hourstartSecond) - \(hourendSecond)"
                        isValidSecond = true
                        AddHoursButton.isHidden = true
                    } else {
                        hourstartSecond =  dateFormatter.string(from: sender.date)
                        if hourstartSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        if hourendSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        let fromHourDate = dtFromHour.date
                        let toHourDate = dtToHour.date
                        switch fromHourDate.compare(toHourDate) {
                        case .orderedSame   :
                            print("The two hours are the same")
                            clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        default:
                            print("diff")
                        }

                        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                            // Hebrew
                            if (toHourDate > fromHourDate) {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        } else {
                            // Other
                            if fromHourDate > toHourDate {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        }
                        RowSelectedHours2.text = "\(hourstartSecond) - \(hourendSecond)"
                        isValidSecond = true
                        AddHoursButton.isHidden = true

                    }
                }

                // Hour end choose
                if (sender == dtToHour) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "HH:mm"
                    if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                        hourstartSecond = dateFormatter.string(from: sender.date)
                        if hourstartSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        if hourendSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        let fromHourDate = dtFromHour.date
                        let toHourDate = dtToHour.date
                        switch fromHourDate.compare(toHourDate) {
                        case .orderedSame   :
                            print("The two hours are the same")
                            clearhoursSecond()
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        default:
                            print("diff")
                        }

                        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                            // Hebrew
                            if (toHourDate > fromHourDate) {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        } else {
                            // Other
                            if fromHourDate > toHourDate {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        }
                        RowSelectedHours2.text = "\(hourstartSecond) - \(hourendSecond)"
                        isValidSecond = true
                        AddHoursButton.isHidden = true
                    } else {
                        hourendSecond = dateFormatter.string(from: sender.date)
                        if hourstartSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_Start".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        if hourendSecond == "" {
                            //Alert.sharedInstance.showAlertDelegate("ERROR_hour_End".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        }
                        let fromHourDate = dtFromHour.date
                        let toHourDate = dtToHour.date
                        switch fromHourDate.compare(toHourDate) {
                        case .orderedSame   :
                            print("The two hours are the same")
                            clearhoursSecond() ///
                            //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_ISEQUAL".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                            return
                        default:
                            print("diff")
                        }

                        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
                            // Hebrew
                            if (toHourDate > fromHourDate) {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        } else {
                            // Other
                            if fromHourDate > toHourDate {
                                clearhoursSecond()
                                //Alert.sharedInstance.showAlertDelegate("ERROR_HOUR_START_END".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                                return
                            }
                        }
                        RowSelectedHours2.text = "\(hourstartSecond) - \(hourendSecond)"
                        isValidSecond = true
                        AddHoursButton.isHidden = true
                    }
                }


        }

    }
    func clearhoursSecond()
    {
//        hourstartSecond = ""
//        hourendSecond = ""
        isValidSecond = false
        RowSelectedHours2.text = ""
    }
    func clearhours()
    {
//        hourstart = ""
//        hourend = ""
        isValidFirst = false
        RowSelectedHours1.text = ""
    }


}
