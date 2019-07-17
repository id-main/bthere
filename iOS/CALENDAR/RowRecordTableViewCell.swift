//
//  RowRecordTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/14/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class RowRecordTableViewCell: UITableViewCell {

    //MARK: - OUTLET
    
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblHour: UILabel!
    
    //MARK: - PROPERTIES
    var cancelOrderID:Int = 0
    var event:allKindEventsForListDesign = allKindEventsForListDesign()
    var calendar:Foundation.Calendar = Foundation.Calendar.current
    var delegate:openDetailsOrderDelegate!=nil
    var currDate:Date = Date()
    
    //MARK: - INITIAL
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOrderTurn))
        self.contentView.addGestureRecognizer(tap)
        if (Global.sharedInstance.defaults.integer(forKey: "CHOOSEN_LANGUAGE") == 0) {
            lblDesc.textAlignment = .right
            lblHour.textAlignment = .right
        } else {
            lblDesc.textAlignment = .left
            lblHour.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: self.contentView.frame.height - 1, width: self.contentView.frame.size.width + 60, height: 1))
        lineView.backgroundColor = Colors.sharedInstance.color6
        self.contentView.addSubview(lineView)
    }
    
    //EventFrom - מציין האם הארוע מהמכשיר =2 או מביזר =1
    func setDisplayData(_ hourDesc:String,desc:String,EventFrom:Int, _isFormSyncedCalendar:Bool){
        
        if EventFrom == 1 || _isFormSyncedCalendar == false //ביזר
        {
            lblDesc.font = UIFont (name: "OpenSansHebrew-Bold", size: 15)
            lblHour.font = UIFont (name: "OpenSansHebrew-Bold", size: 15)
            let currentDateTime = Date()
            if currentDateTime > event.dateEvent
            {
                 lblHour.textColor = .orange
                 lblDesc.textColor = .orange
            }
            else
            {
                lblHour.textColor = .black
                lblDesc.textColor = .black
                
            }

        }
        else
        {
            lblDesc.textColor = Colors.sharedInstance.greenforsyncedincalendar
            lblHour.textColor = Colors.sharedInstance.greenforsyncedincalendar
            lblDesc.font = UIFont (name: "OpenSansHebrew-Bold", size: 15)
            lblHour.font = UIFont (name: "OpenSansHebrew-Bold", size: 15)
        }
        
        lblDesc.text = desc
        lblHour.text = hourDesc
        self.cancelOrderID = self.event.iCoordinatedServiceId
    }
    
    @objc func tapOrderTurn(_ sender:UITapGestureRecognizer)
    {
        Global.sharedInstance.whichDesignOpenDetailsAppointment = 3
        
        //בודק האם ה-cell שעליו לחצו הוא תור של ביזר ואז בלחיצה יש להציג את פרטי התור
        if event.tag == 1
        {
            Global.sharedInstance.hourBthereEvent = event.fromHour
            Global.sharedInstance.hourBthereEventEnd = event.toHour
            let orderDetailsFoBthereEvent:OrderDetailsObj = OrderDetailsObj(
                _iCoordinatedServiceId: self.cancelOrderID,
                _iProviderUserId: 0,
                _nvFirstName: "",
                _nvSupplierName: event.nvSupplierName,
                _objProviderServiceDetails: [],
                _iDayInWeek: 0,
                _dtDateOrder: event.dateEvent,
                _nvFromHour: event.fromHour,
                _nvToHour: event.toHour,
                _nvAddress: event.nvAddress,
                _nvComment: event.nvComment,
                _nvLogo: "",
                _iUserId: 0,
                _title:self.event.title,
                _chServiceColor: "",
                _iSupplierId: event.iSupplierId,
                _iCoordinatedServiceStatusType:  0,
                _nvLastName: "",
                _nvPhone: event.nvPhone
            )

            Global.sharedInstance.orderDetailsFoBthereEvent = orderDetailsFoBthereEvent
            Global.sharedInstance.dateEventBthereClick = event.dateEvent
            Global.sharedInstance.serviceName = event.nvServiceName
            Global.sharedInstance.dayFreeEvent = DateFormatter().weekdaySymbols[event.iDayInWeek - 1]
            
            
            delegate.openDetailsOrder(3)//רשימה של יומן לקוח
            
        }
    }

}
