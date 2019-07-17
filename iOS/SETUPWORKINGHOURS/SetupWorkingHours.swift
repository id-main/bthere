//
//  SetupWorkingHours.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 12/14/18.
//  Copyright © 2018 Bthere. All rights reserved.
//
//
import Foundation
import UIKit
protocol isOpenRowDelegate {
    func openRow(_WHICHCELL:Int, _WHICHSTATE:Bool)
    func seteditbuttonpressed(_WHICHCELL:Int)
    func seteditsecondbuttonpressed(_WHICHCELL:Int)
    func setaddbuttonpressed(_WHICHCELL:Int)
    func savedDataOn(_WHICHCELL:Int, _WHICHSTATE:Bool, _WHICHSTATE2:Bool, _firstSel: objWorkingHours, _secondsel: objWorkingHours)
    func savedDataFirstInterval(_WHICHCELL:Int, _WHICHSTATE:Bool, _firstSel: objWorkingHours)
    func closeandclearWorkingHours(_WHICHCELL:Int)
}
class SetupWorkingHours:UIViewController, UITableViewDelegate, UITableViewDataSource,isOpenRowDelegate {
    var myDayNames:Array<String> = Array<String>()
    var openRows:Array<Bool> = [false, false, false, false, false, false, false]
    var hasHoursSelected:Array<Bool> = [false, false, false, false, false, false, false]
    var hasHoursSecondSelected:Array<Bool> = [false, false, false, false, false, false, false]
    var lastopencell:Int = -1
    var currentopencell:Int = -1
    var haspreesededitsecondbutton:Array<Bool> = [false, false, false, false, false, false, false]
    var haspreesededitbutton:Array<Bool> = [false, false, false, false, false, false, false]
    var haspreesedaddbutton:Array<Bool> = [false, false, false, false, false, false, false]
    var FIRSTINTERVALArray = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
    var SECONDINTERVALArray = [objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours(),objWorkingHours()]
    //    var iDayInWeekType:Int = 0
    //    var nvFromHour:String = ""
    //    var nvToHour:String = ""
    @IBOutlet weak var Container:UITableView!
    @IBOutlet weak var closeButton:UIButton!
    @IBOutlet weak var validateScreen:UIButton!
    @IBAction func closeButton(_ sender:UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func validateScreen(_ sender:UIButton) {
        //check hasHoursSelected
        var isValidToSave:Bool = false
        for i in hasHoursSelected {
            if i == true {
                isValidToSave = true
                AppDelegate.JHASVALIDHOURS = true
                break
            }
        }
        if isValidToSave == false {
            AppDelegate.JHASVALIDHOURS = false
      //in main      Alert.sharedInstance.showAlertDelegate("SELECT_HOURS_FOR_DAY".localized(LanguageMain.sharedInstance.USERLANGUAGE))
        } else {
            Global.sharedInstance.generalDetails.arrObjWorkingHours = Array<objWorkingHours>() //empty before mix the working and rest
            var mymixedarray:Array<objWorkingHours> = Array<objWorkingHours>()
            Global.sharedInstance.generalDetails.arrObjWorkingHours  = mymixedarray
            if AppDelegate.JHASVALIDHOURS == true {
                //compose final array from intervals
                for i in 0..<hasHoursSelected.count {
                    if hasHoursSelected[i] == true {
                        let goodworkingintervalfirst = FIRSTINTERVALArray[i]
                        if !mymixedarray.contains(goodworkingintervalfirst) {
                            mymixedarray.append(goodworkingintervalfirst)
                        }
                    }
                }
                for i in 0..<hasHoursSecondSelected.count {
                    if hasHoursSecondSelected[i] == true {
                        let goodworkingintervalfirst = SECONDINTERVALArray[i]
                        if !mymixedarray.contains(goodworkingintervalfirst) {
                            mymixedarray.append(goodworkingintervalfirst)
                        }
                    }
                }
            }
            for h in mymixedarray {
            print("mixedArray print2: \(h.getDic())")
            }
            Global.sharedInstance.generalDetails.arrObjWorkingHours  = mymixedarray

        }
    }
    override func viewDidLoad() {
        //   self.view.addBackground()
        Container.delegate = self
        Container.dataSource = self
        myDayNames = ["SUNDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                      "MONDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                      "TUESDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                      "WEDNSDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                      "THIRTHDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                      "FRIDAY".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                      "SHABAT".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        ]
        //precomplete array with default values
        for i in 0..<FIRSTINTERVALArray.count {
            var workingHoursTEST:objWorkingHours = objWorkingHours()
            workingHoursTEST = objWorkingHours(
                _iDayInWeekType: i + 1,
                _nvFromHour: "00:00:00",
                _nvToHour: "00:00:00")
            FIRSTINTERVALArray[i] = workingHoursTEST
        }
        for i in 0..<SECONDINTERVALArray.count {
            var workingHoursTEST:objWorkingHours = objWorkingHours()
            workingHoursTEST = objWorkingHours(
                _iDayInWeekType: i + 1,
                _nvFromHour: "00:00:00",
                _nvToHour: "00:00:00")
            SECONDINTERVALArray[i] = workingHoursTEST
        }
        //by default has empty hours
        AppDelegate.JHASVALIDHOURS = false
        Global.sharedInstance.generalDetails.arrObjWorkingHours = Array<objWorkingHours>()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EditWorkingHoursCell = tableView.dequeueReusableCell(withIdentifier: "EditWorkingHoursCell") as! EditWorkingHoursCell
        let ax = indexPath.section
        cell.delegate = self
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.indexSection = indexPath.section
        let _isopen  = openRows[ax]
        let _firstinterval = FIRSTINTERVALArray[ax]
        let _hasHoursSelected = hasHoursSelected[ax]
        let _hasHoursSecondSelected = hasHoursSecondSelected[ax]
        cell.setDisplayData(openRows[ax], daydesc: myDayNames[indexPath.section], _indexsection:indexPath.section, _firstinterval: FIRSTINTERVALArray[ax], _secondinterval: SECONDINTERVALArray[ax], _hasHoursSelected: hasHoursSelected[ax], _hasHoursSecondSelected:hasHoursSecondSelected[ax], _isinEDIT:haspreesededitbutton[ax], _isinEDITSECOND:haspreesededitsecondbutton[ax],_isinADD:haspreesedaddbutton[ax] )
        print("_isnewopen \(currentopencell)")


        cell.mySwitch.onTintColor = Colors.sharedInstance.color4
        if _hasHoursSelected == false && _isopen == true {
            cell.mySwitch.isOn = true
            cell.mySwitch.onTintColor = Colors.sharedInstance.color3
        }
        if _hasHoursSelected == false && _isopen == false {
            cell.mySwitch.isOn = false
        }
        if _hasHoursSelected == true && _isopen == false {
            cell.mySwitch.isOn = true
        }
        switch (_isopen) {
        case false:
            if _hasHoursSelected == false  {
                cell.AddHoursButton.isHidden = true
                break
            } else
                if _hasHoursSelected == true &&  _hasHoursSecondSelected == true {
                    cell.AddHoursButton.isHidden = true
                    break
                } else
                    if _hasHoursSelected == true && _hasHoursSecondSelected == false {
                        if _firstinterval.nvToHour == "23:59:00" {
                            cell.AddHoursButton.isHidden = true
                            break
                        }
                        else {
                            cell.AddHoursButton.isHidden = false
                            break
                        }
            }
        case true:
            cell.AddHoursButton.isHidden = true
            break
        }
        let tapAction = UITapGestureRecognizer(target: cell, action: #selector(cell.EditHoursButton))
        tapAction.delegate = cell
        cell.RowSelectedHours1.isUserInteractionEnabled = true
        cell.RowSelectedHours1.addGestureRecognizer(tapAction)
        let tapAction2 = UITapGestureRecognizer(target: cell, action: #selector(cell.EditHoursSecondButton))
        tapAction2.delegate = cell
        cell.RowSelectedHours2.isUserInteractionEnabled = true
        cell.RowSelectedHours2.addGestureRecognizer(tapAction2)


        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let ax = indexPath.section
        var x:CGFloat  = 0.0
        if openRows[ax] == false {
            if hasHoursSelected [ax] == true &&   hasHoursSecondSelected[ax] == true {
                x = 90
            } else if hasHoursSelected [ax] == true &&   hasHoursSecondSelected[ax] == false {
                x = 70
            } else if hasHoursSelected [ax] == false &&   hasHoursSecondSelected[ax] == false {
                x = 50
            }
        } else {
            currentopencell = ax
            let screenSize: CGRect = UIScreen.main.bounds
            let screenHeight = screenSize.height
            x = CGFloat(screenHeight * 0.7)
        }


        return x
    }

    func closeandclearWorkingHours(_WHICHCELL:Int) {
        var workingHoursTEST:objWorkingHours = objWorkingHours()
        workingHoursTEST = objWorkingHours(
            _iDayInWeekType: _WHICHCELL + 1,
            _nvFromHour: "00:00:00",
            _nvToHour: "00:00:00")
        FIRSTINTERVALArray[_WHICHCELL] = workingHoursTEST
        SECONDINTERVALArray[_WHICHCELL] = workingHoursTEST
        hasHoursSelected[_WHICHCELL] = false
        hasHoursSecondSelected[_WHICHCELL] = false
        haspreesedaddbutton[_WHICHCELL] = false
        haspreesededitbutton[_WHICHCELL] = false
        haspreesededitsecondbutton[_WHICHCELL] = false
        validateScreen(self.validateScreen)
        openRow(_WHICHCELL:_WHICHCELL, _WHICHSTATE: false)
    }

    func openRow(_WHICHCELL:Int, _WHICHSTATE:Bool) {

        if _WHICHSTATE == true {

            //close others
            for i in 0..<openRows.count {
                //   if i != _WHICHCELL {
                openRows[i] = false



                //   }
            }

            openRows[_WHICHCELL] = true

            let indexPath = IndexPath(row: 0, section: _WHICHCELL)


            let indexes = Container.indexPathsForVisibleRows!
            if indexes.contains(indexPath)
            {
                //               self.Container.reloadRows(at: [indexPath], with: .none)
                self.Container.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            self.Container.reloadData()
        } else {
            for i in 0..<openRows.count {
                openRows[i] = false
            }
            openRows[_WHICHCELL] = false
            self.Container.reloadData()
            haspreesededitbutton[_WHICHCELL] = false
            haspreesededitsecondbutton[_WHICHCELL] = false
            haspreesedaddbutton[_WHICHCELL] = false
            for i in 0..<haspreesedaddbutton.count {
                haspreesedaddbutton[i] = false
                haspreesededitbutton[i] = false
                haspreesededitsecondbutton[i] = false
            }

            let indexPath = IndexPath(row: 0, section: 0)
            let indexes = Container.indexPathsForVisibleRows!
            if indexes.contains(indexPath)
            {
                self.Container.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            self.Container.reloadData()
        }

    }


    func savedDataFirstInterval(_WHICHCELL:Int, _WHICHSTATE:Bool, _firstSel: objWorkingHours) {
        if _WHICHSTATE == true {
            hasHoursSelected[_WHICHCELL] = true
            FIRSTINTERVALArray[_WHICHCELL] = _firstSel
            hasHoursSecondSelected[_WHICHCELL] = false
            var workingHoursTEST:objWorkingHours = objWorkingHours()
            workingHoursTEST = objWorkingHours(
                _iDayInWeekType: _WHICHCELL + 1,
                _nvFromHour: "00:00:00",
                _nvToHour: "00:00:00")
            SECONDINTERVALArray[_WHICHCELL] = workingHoursTEST
            validateScreen(self.validateScreen)
            self.lastopencell = _WHICHCELL
            self.Container.reloadData()
        }

    }

    func savedDataOn(_WHICHCELL:Int, _WHICHSTATE:Bool, _WHICHSTATE2:Bool, _firstSel: objWorkingHours, _secondsel: objWorkingHours ) {
        //    Container.beginUpdates()
        if _WHICHSTATE == true {
            hasHoursSelected[_WHICHCELL] = true
            FIRSTINTERVALArray[_WHICHCELL] = _firstSel
            if _WHICHSTATE2 == true {
                hasHoursSecondSelected[_WHICHCELL] = true
                SECONDINTERVALArray[_WHICHCELL] = _secondsel
            } else {
                hasHoursSecondSelected[_WHICHCELL] = false
                var workingHoursTEST:objWorkingHours = objWorkingHours()
                workingHoursTEST = objWorkingHours(
                    _iDayInWeekType: _WHICHCELL + 1,
                    _nvFromHour: "00:00:00",
                    _nvToHour: "00:00:00")
                SECONDINTERVALArray[_WHICHCELL] = workingHoursTEST
            }
        } else {
            hasHoursSelected[_WHICHCELL] = false
            hasHoursSecondSelected[_WHICHCELL] = false
            var workingHoursTEST:objWorkingHours = objWorkingHours()
            workingHoursTEST = objWorkingHours(
                _iDayInWeekType: _WHICHCELL + 1,
                _nvFromHour: "00:00:00",
                _nvToHour: "00:00:00")
            FIRSTINTERVALArray[_WHICHCELL] = workingHoursTEST
            SECONDINTERVALArray[_WHICHCELL] = workingHoursTEST
        }
        for i in FIRSTINTERVALArray {
            print("one \(i.getDic())")
        }
        for i in SECONDINTERVALArray {
            print("two \(i.getDic())")
        }
        openRows[_WHICHCELL] = false
        haspreesededitbutton[_WHICHCELL] = false
        haspreesededitsecondbutton[_WHICHCELL] = false
        haspreesedaddbutton[_WHICHCELL] = false
        let indexPath = IndexPath(row: 0, section: _WHICHCELL)
        validateScreen(self.validateScreen)

        let indexes = Container.indexPathsForVisibleRows!
        if indexes.contains(indexPath)
        {
            self.Container.reloadRows(at: [indexPath], with: .none)
            self.Container.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        self.Container.reloadData()


    }
    //EDIT HOURS LABEL PRESSED
    func seteditbuttonpressed(_WHICHCELL:Int) {
        for i in 0..<haspreesededitbutton.count {

            if i != _WHICHCELL {
                haspreesededitbutton[i] = false
            }
            haspreesedaddbutton[i] = false
            haspreesededitsecondbutton[i] = false
        }
        haspreesededitbutton[_WHICHCELL] = true
    }
    //EDIT SECOND HOURS LABEL PRESSED
    func seteditsecondbuttonpressed(_WHICHCELL:Int) {
        for i in 0..<haspreesededitsecondbutton.count {

            if i != _WHICHCELL {
                haspreesededitsecondbutton[i] = false
            }
            haspreesededitbutton[i] = false
            haspreesededitsecondbutton[i] = false
        }
        haspreesededitsecondbutton[_WHICHCELL] = true
    }
    //ADD HOURS BUTTON PRESSED
    func setaddbuttonpressed(_WHICHCELL:Int) {
        for i in 0..<haspreesedaddbutton.count {

            if i != _WHICHCELL {
                haspreesedaddbutton[i] = false
            }
            haspreesededitbutton[i] = false
            haspreesededitsecondbutton[i] = false
        }
        haspreesedaddbutton[_WHICHCELL] = true
}
}
