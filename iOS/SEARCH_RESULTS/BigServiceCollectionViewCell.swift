//
//  BigServiceCollectionViewCell.swift
//  bthree-ios
//
//  Created by User on 14.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class BigServiceCollectionViewCell: UICollectionViewCell {
    // Outlets
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet weak var checkListImage: UIImageView!
    @IBOutlet weak var btnOrderService: UIButton!
    @IBOutlet weak var checkListButton: UIButton!
    var canbechecked:Bool  = false
    var iServiceTime:Int = 0
    // Variables
    var delegate:showMoreInfoDelegate!=nil
    var index = 0
    var checkSelected: Bool = false
    var delegateReloadTbl:reloadTblServiceDelegte!=nil
    var ismultiplepossible:Bool = false

    override func awakeFromNib()
    {
//        Global.sharedInstance.arrayServicesKodsToServer = []
    }


    // Order service button
    @IBAction func btnOrderService(_ sender: AnyObject) {

        if canbechecked == false {
            delegate.shownoavalaibleworkers()
            return

        }



        if (Global.sharedInstance.arrayServicesKodsToServer.count == 0) {
            Global.sharedInstance.arrayServicesKodsToServer = []
            Global.sharedInstance.serviceName = lblDesc.text!
            Global.sharedInstance.indexRowForIdService = index

            print("initial array of services matricea initiala de servicii \(Global.sharedInstance.arrayServicesKods.description) index found \(index) si id \(Global.sharedInstance.arrayServicesKods[index])")

            if (!Global.sharedInstance.arrayServicesKodsToServer.contains(Global.sharedInstance.arrayServicesKods [index])) {
                Global.sharedInstance.arrayServicesKodsToServer.insert(Global.sharedInstance.arrayServicesKods[index], at: 0)
            }
//            if !Global.sharedInstance.multipleServiceName.contains(Global.sharedInstance.arrayServicesNames[index])
//            {
                Global.sharedInstance.multipleServiceName.append(Global.sharedInstance.arrayServicesNames[index])
           // }

            print("what codes \(Global.sharedInstance.arrayServicesKodsToServer)")
        } else {
            if (!Global.sharedInstance.arrayServicesKodsToServer.contains(Global.sharedInstance.arrayServicesKods[index])) {
                Global.sharedInstance.arrayServicesKodsToServer.insert(Global.sharedInstance.arrayServicesKods[index], at: 0)
                Global.sharedInstance.multipleServiceName.append(Global.sharedInstance.arrayServicesNames[index])
                print("what codes 2\(Global.sharedInstance.arrayServicesKodsToServer)")
            }
//            if !Global.sharedInstance.multipleServiceName.contains(Global.sharedInstance.arrayServicesNames[index])
//            {
            
          //  }
        }


        delegate.showOdrerTurn()
    }


    // Check list button
    @IBAction func checkListButton(_ sender: AnyObject) {
        print("bbbb \(canbechecked)")
        if canbechecked == false {
            delegate.shownoavalaibleworkers()
            return

        }
        if (checkSelected == false) {
            // Select
            checkSelected = true

            if (!Global.sharedInstance.arrayServicesKodsToServer.contains(Global.sharedInstance.arrayServicesKods[index])) {
                Global.sharedInstance.arrayServicesKodsToServer.append(Global.sharedInstance.arrayServicesKods[index])
                Global.sharedInstance.iServiceTimeSUM =  Global.sharedInstance.iServiceTimeSUM  + self.iServiceTime
            }

        //    if (!Global.sharedInstance.multipleServiceName.contains(Global.sharedInstance.arrayServicesNames[index])) {
                Global.sharedInstance.multipleServiceName.append(Global.sharedInstance.arrayServicesNames[index])

        //    }

            Global.sharedInstance.numCellsCellected += 1
            Global.sharedInstance.indexCellSelected = index

            Global.sharedInstance.isFirstCellSelected = false
            Global.sharedInstance.arrCellsMultiple[index] = true

            checkListImage.image = UIImage(named: "29.png")

            delegateReloadTbl.reloadTblService()
        } else {
            // Deselect
            checkSelected = false

            if (Global.sharedInstance.arrayServicesKodsToServer.contains(Global.sharedInstance.arrayServicesKods[index])) {
                let indexs = Global.sharedInstance.arrayServicesKodsToServer.index(of: Global.sharedInstance.arrayServicesKods[index])
                Global.sharedInstance.arrayServicesKodsToServer.remove(at: indexs!)
                Global.sharedInstance.iServiceTimeSUM =  Global.sharedInstance.iServiceTimeSUM - self.iServiceTime
            }

            if (Global.sharedInstance.multipleServiceName.contains(Global.sharedInstance.arrayServicesNames[index])) {
                let indexs = Global.sharedInstance.multipleServiceName.index(of: Global.sharedInstance.arrayServicesNames[index])
                Global.sharedInstance.multipleServiceName.remove(at: indexs!)
            }

            if (Global.sharedInstance.numCellsCellected != 0) {
                Global.sharedInstance.numCellsCellected -= 1
            }

            Global.sharedInstance.isFirstCellSelected = false
            Global.sharedInstance.arrCellsMultiple[index] = false

            if (Global.sharedInstance.numCellsCellected == 0) {
                Global.sharedInstance.indexCellSelected = -1
            }

            checkListImage.image = UIImage(named: "empty_circle.png")

            delegateReloadTbl.reloadTblService()
        }

        print("what codes in 2 \(Global.sharedInstance.arrayServicesKodsToServer)")
    }


    // Set display data
    func setDisplayData(_ descService:String,time:String,price:String, iServiceTime:Int) {
        lblDesc.text = descService
        lblPrice.text = "₪\(price)"
        lblTime.text = "\("MINUTES".localized(LanguageMain.sharedInstance.USERLANGUAGE))\(time)"

    }


    // Set display data
    func setDisplayData(_ pr:objProviderServices, _ismultiplepossible:Bool,_canbechecked:Bool, _iServiceTime:Int) {
        self.iServiceTime = _iServiceTime
        ismultiplepossible = _ismultiplepossible

           canbechecked = _canbechecked
        
        self.isUserInteractionEnabled = true

        self.checkListButton.isHidden = false
        self.checkListImage.isHidden = false


        //  checkListButton.hidden = false
        //  checkListImage.hidden = false
        if Global.sharedInstance.ISFROMMULTIPLEAPPOINTMENTS == true {
            if  ismultiplepossible == true   {
                if  Global.sharedInstance.arrCellsMultiple[index] == true {
                    self.checkListImage.image = UIImage(named: "29.png")
                    self.checkListButton.isSelected = true
                    self.checkSelected = true
                } else {
                    self.checkListButton.isSelected = false
                    self.checkListImage.image =  UIImage(named: "empty_circle.png")
                    self.checkSelected = false
                }
            } else {
                self.checkListButton.isHidden = true
                self.checkListImage.isHidden = true
            }
        } else {
            if  Global.sharedInstance.arrCellsMultiple[index] == true {
                self.checkListImage.image = UIImage(named: "29.png")
                self.checkListButton.isSelected = true
                self.checkSelected = true
            } else {
                self.checkListButton.isSelected = false
                self.checkListImage.image =  UIImage(named: "empty_circle.png")
                self.checkSelected = false
            }

        }
        if (!Global.sharedInstance.arrayServicesKods.contains(pr.iProviderServiceId)) {
            Global.sharedInstance.arrayServicesKods.append(pr.iProviderServiceId)
        }

        lblDesc.text = pr.nvServiceName

        if (pr.nUntilPrice != 0.0) {
            lblPrice.text = "₪\(pr.iPrice) - \(pr.nUntilPrice)"
        } else {
            if (pr.iPrice != 0.0) {
                lblPrice.text = "₪\(String(pr.iPrice))"
            } else {
                lblPrice.text = ""
            }
        }

        if (pr.iUntilSeviceTime != 0) {
            lblTime.text = "\(pr.iTimeOfService) - \(pr.iUntilSeviceTime) \("MINUTES".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
        } else {
            lblTime.text = "\(pr.iTimeOfService) \("MINUTES".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
        }
        print("total time is: \(String(describing: lblTime.text))")
        //        if pr.iTimeInterval != 0
        //        {
        //            lblTime.text = "\(pr.iTimeOfService) - \(pr.iUntilSeviceTime) \("MINUTES".localized(LanguageMain.sharedInstance.USERLANGUAGE))"
        //        }
        if canbechecked == false {
            //      self.isUserInteractionEnabled = false
            self.checkListButton.isSelected = false
            self.checkListImage.image =  UIImage(named: "empty_circle.png")
            self.checkSelected = false
            self.checkListImage.isHidden = true
            //     return
        }
    }
}
