//
//  SetupServices.swift
//  Bthere
//
//  Created by Ioan Ungureanu on 13/02/19.
//  Copyright © 2019 Bthere. All rights reserved.
//
//
import Foundation
import UIKit
protocol isOpenRowDelegate2 {
    func reloadTableFull()
    func openRow(_WHICHCELL:Int, _WHICHSTATE:Bool)
    func editRow(_WHICHCELL:Int,_WHICHSTATE:Bool)
    func savedDataOn(_WHICHCELL:Int, _WHICHSTATE:Bool, _WHICHSTATE2:Bool, _firstSel: objWorkingHours, _secondsel: objWorkingHours)
    func closeandclearcell(_WHICHCELL:Int)
}

class SetupServices:UIViewController, UITableViewDelegate, UITableViewDataSource,isOpenRowDelegate2 {
    var allclosed:Bool = true
    var AddisClosed:Bool = true //by default add service is not touch on load
    var EditCell:Int = -1 // default value
    var EditisClosed:Bool = true //by default edit service is closed
    var openRows:Array<Bool> = []
    @IBOutlet weak var TitleScreen:UILabel!
    @IBOutlet weak var Container:UITableView!
    @IBOutlet weak var closeButton:UIButton!
    @IBOutlet weak var validateScreen:UIButton!
    @IBAction func closeButton(_ sender:UIButton) {
            self.dismiss(animated: false, completion: nil)

    }

    @IBAction func validateScreen(_ sender:UIButton) {

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
       // self.view.addBackground()
        TitleScreen.text = "SETUP_SERVICES".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        Container.delegate = self
        Container.dataSource = self
        Container.separatorStyle = .none
        Global.sharedInstance.generalDetails.arrObjProviderServices = []
        Global.sharedInstance.generalDetails.arrObjProviderServices = Global.sharedInstance.currentProviderDetailsObj.providerGeneralDetailsObj.arrObjProviderServices
        print(" arrObjProviderServices servicii  \( Global.sharedInstance.generalDetails.arrObjProviderServices.count )")
        for _ in Global.sharedInstance.generalDetails.arrObjProviderServices {
             openRows.append(false)
        }
        self.Container.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var x:Int = 1
        //case 1 -> no service -> edit service cell -> number of rows 1
        if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0 {
            x = 1
        } else {
            //case 2-> services> 0 -> list services table   + add service row -> number of services + 1 (all closed)
            if allclosed == true {
                x = Global.sharedInstance.generalDetails.arrObjProviderServices.count + 1
            } else {
                //case 3 -> services> 0 -> list services table   + add service row -> number of services + edit service cell  + 1 (one open for edit)
                x = Global.sharedInstance.generalDetails.arrObjProviderServices.count + 2
            }
        }
        return x
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mycel = UITableViewCell()
        let myindex = indexPath.row
        //case 1 -> no service -> edit service cell -> number of rows 1
        if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0 {
            //nothing now
            let cell:NewBussinesServicesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewBussinesServicesTableViewCell") as! NewBussinesServicesTableViewCell
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.setDisplayDataNull()
            cell.delegate = self
            cell.tag = indexPath.section
            return cell
        } else {
            //case 2-> services> 0 -> list services table   + add service row -> number of services + 1 (all closed)
            if allclosed == true {
                if myindex == Global.sharedInstance.generalDetails.arrObjProviderServices.count   {
                    print("last row")
                    let cell:JoAddNewServiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "JoAddNewServiceTableViewCell") as! JoAddNewServiceTableViewCell
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.setState(_isClosed: self.AddisClosed)
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    return cell
                } else {
                    //last row  x = Global.sharedInstance.generalDetails.arrObjProviderServices.count + 1
                    //other rows
                    let cell:ServiceInListCell = tableView.dequeueReusableCell(withIdentifier: "ServiceInListCell") as! ServiceInListCell
                    cell.tag = indexPath.row
                    cell.delegate = self
                    cell.setEditState(_isEditOpen: false)
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row].nvServiceName)
                    return cell
                }

            } else {
                //case 3 -> services> 0 -> list services table   + add service row -> number of services + edit service cell  + 1 (one open for edit)
                //last row


            if EditisClosed == true  {
                if myindex == Global.sharedInstance.generalDetails.arrObjProviderServices.count     {
                    print("add row")
                    let cell:JoAddNewServiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "JoAddNewServiceTableViewCell") as! JoAddNewServiceTableViewCell
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.setState(_isClosed: self.AddisClosed)
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                                        return cell
                } else if myindex == Global.sharedInstance.generalDetails.arrObjProviderServices.count + 1  {
                    print("edit row")
                    let cell:NewBussinesServicesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewBussinesServicesTableViewCell") as! NewBussinesServicesTableViewCell
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.delegate = self
                    cell.txtPrice.tag = -11
                    cell.setDisplayDataNull()
                    cell.tag = indexPath.section
                    return cell
                } else {
                    let cell:ServiceInListCell = tableView.dequeueReusableCell(withIdentifier: "ServiceInListCell") as! ServiceInListCell
                    cell.setEditState(_isEditOpen: false)
                    cell.tag = indexPath.row
                    cell.delegate = self
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                   // cell.setEditState(_isEditOpen: self.EditisClosed)
                    cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row].nvServiceName)
                    return cell
                }
              }
            else  if EditisClosed == false  {   //case 3 -> services> 0 -> list services table    -> number of services + edit service cell  + 1 (one open for edit) + add service row
                if myindex == self.EditCell + 1 { //because origin is existing one
                    let cell:NewBussinesServicesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewBussinesServicesTableViewCell") as! NewBussinesServicesTableViewCell
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.delegate = self
                    cell.txtPrice.tag = myindex - 1
                    cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row - 1])
                    cell.tag = indexPath.section
                    return cell
                }
                if myindex == self.EditCell + 2 {
                    let cell:JoAddNewServiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "JoAddNewServiceTableViewCell") as! JoAddNewServiceTableViewCell
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.setState(_isClosed: self.AddisClosed)
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    return cell
                }
                if myindex == self.EditCell {
                    let cell:ServiceInListCell = tableView.dequeueReusableCell(withIdentifier: "ServiceInListCell") as! ServiceInListCell
                    cell.tag = indexPath.row
                    cell.setEditState(_isEditOpen: true)
                    cell.delegate = self
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row].nvServiceName)
                    return cell
                }
                if myindex < self.EditCell {
                    let cell:ServiceInListCell = tableView.dequeueReusableCell(withIdentifier: "ServiceInListCell") as! ServiceInListCell
                    cell.tag = indexPath.row
                    cell.setEditState(_isEditOpen: false)
                    cell.delegate = self
                    cell.selectionStyle = .none
                    cell.separatorInset = UIEdgeInsets.zero
                    cell.layoutMargins = UIEdgeInsets.zero

                   cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row].nvServiceName) //allways have add
                    return cell
                    }
                if myindex > self.EditCell + 2 {
                        let cell:ServiceInListCell = tableView.dequeueReusableCell(withIdentifier: "ServiceInListCell") as! ServiceInListCell
                        cell.tag = indexPath.row - 2
                        cell.setEditState(_isEditOpen: false)
                        cell.delegate = self
                        cell.selectionStyle = .none
                        cell.separatorInset = UIEdgeInsets.zero
                        cell.layoutMargins = UIEdgeInsets.zero
                    print(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row - 2].nvServiceName)
                        cell.setDisplayData(Global.sharedInstance.generalDetails.arrObjProviderServices[indexPath.row - 2].nvServiceName) //allways have add
                    return cell
                    }


            }
        }
        }

        return mycel
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 print(indexPath.row)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let ax = indexPath.row
        var x:CGFloat  = 0.0
        let y = view.frame.size.height * 0.07
        let y2 = view.frame.size.height
        if Global.sharedInstance.generalDetails.arrObjProviderServices.count == 0 {
            x = y2
        } else {
            if EditisClosed == true  {
            //case 2-> services> 0 -> list services table   + add service row -> number of services + 1 (all closed)
            if allclosed == true {
                x =  y
            } else {
                //case 3 -> services> 0 -> list services table   + add service row -> number of services + edit service cell  + 1 (one open for edit)
                if ax == Global.sharedInstance.generalDetails.arrObjProviderServices.count + 1 {
                    x = y2
                } else {

                        x = y
                }
            }
        }
            if EditisClosed == false && self.EditCell != -1 {
                //case 2-> services> 0 -> list services table   + add service row -> number of services + 1 (all closed)
                if allclosed == true {
                    x =  y
                } else {
                    //case 3 -> services> 0 -> list services table   + add service row -> number of services + edit service cell  + 1 (one open for edit)
                    if ax == self.EditCell + 1 {
                        x = y2
                    } else {

                        x = y
                    }
                }
            }
            }
        return x
    }
    func closeandclearcell(_WHICHCELL:Int) {
        allclosed = true
        AddisClosed = true
        self.EditisClosed = true
        self.EditCell = -1
        self.Container.reloadData()
    }

    func openRow(_WHICHCELL:Int, _WHICHSTATE:Bool) {
        allclosed = false
        AddisClosed = false
        EditisClosed = true
        self.EditCell = -1
        self.EditCell = _WHICHCELL
        self.Container.reloadData()
      //  let indexPath = IndexPath(row: _WHICHCELL, section: 0)
        let numberOfRows = Container.numberOfRows(inSection: 0)
        if numberOfRows > 0 {
        let indexPath = IndexPath(
            row: numberOfRows - 1,
            section: 0)
        self.Container.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    func editRow(_WHICHCELL:Int, _WHICHSTATE:Bool) {
        self.EditCell = _WHICHCELL
        EditisClosed = false
        AddisClosed = true
        allclosed = false
        self.Container.reloadData()
    }
    func savedDataOn(_WHICHCELL:Int, _WHICHSTATE:Bool, _WHICHSTATE2:Bool, _firstSel: objWorkingHours, _secondsel: objWorkingHours ) {

        self.Container.reloadData()


    }

    func reloadTableFull() {
        self.Container.reloadData()
    }


}
