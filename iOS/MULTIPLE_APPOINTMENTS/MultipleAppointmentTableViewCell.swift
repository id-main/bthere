//
//  MultipleAppointmentTableViewCell.swift
//  BThere
//
//  Created by Ioan Ungureanu on 28/02//2018
//  Copyright © 2018 Bthere. All rights reserved.
//

import UIKit

class MultipleAppointmentTableViewCell: UITableViewCell {
    var txtOrder:String = ""
    var date:String = ""
    var hourS:String = ""
    var hourE:String = ""
    var whatindex:Int = 0

    //MARK: - Outlet
    @IBOutlet weak var appointmentnumber: UILabel!
    @IBOutlet weak var lblSupllierName: UILabel!
    @IBOutlet weak var lblSupplierService: UILabel!
    @IBOutlet weak var lblSupplierAddress: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    var myorderdetails:OrderDetailsObj = OrderDetailsObj()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    func setDisplayData(_ primaryObject:OrderDetailsObj, _whatindex:Int) {
        myorderdetails = primaryObject
        whatindex = _whatindex + 1
        appointmentnumber.text = "APPOINTMENT_LBL_SHORTNUM".localized(LanguageMain.sharedInstance.USERLANGUAGE) + whatindex.description
        let objunique = myorderdetails.objProviderServiceDetails.uniquevals
        print("unice \(objunique.count)")
        txtOrder = ""
        for e in objunique {
            print("e \(e.nvServiceName)")
            if txtOrder == ""
            {
                txtOrder = e.nvServiceName
            }
            else
            {
                txtOrder += ",\(e.nvServiceName)"
            }
        }
        if txtOrder == "" {
            txtOrder = myorderdetails.title
        }
        if txtOrder == "" {
            txtOrder = Global.sharedInstance.serviceName
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: myorderdetails.dtDateOrder as Date)
        lblDate.text = date
        lblSupplierAddress.text = myorderdetails.nvAddress
//        let dateFormatterHours = NSDateFormatter()
//        dateFormatterHours.dateFormat = "HH:mm"
        let hourS:String = myorderdetails.nvFromHour
      //  let hourE:String = dateFormatterHours.stringFromDate(Global.sharedInstance.getStringFromDateString(myorderdeails.nvToHour))
        lblHour.text = hourS // + "-" + hourE
        lblDay.text  = DateFormatter().weekdaySymbols[myorderdetails.iDayInWeek - 1]
        lblSupllierName.text = myorderdetails.nvSupplierName
        lblSupplierService.textAlignment = .center
        lblSupplierService.numberOfLines = 0
//        lblSupplierService.lineBreakMode = NSLineBreakMode.byWordWrapping
//        lblSupplierService.sizeToFit()
        lblSupplierService.text = txtOrder
        
    }
   }
