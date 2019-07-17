
//
//  AppointmentTableViewCell.swift
//  Bthere
//
//  Created by User on 25.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {

    var arrImg:Array<String> = ["detailsAppointment.png","cancelAppointment.png"]
    var DICTUSER:NSDictionary = NSDictionary()
    var arrText:Array<String> = ["DETAILS_TURN".localized(LanguageMain.sharedInstance.USERLANGUAGE),"CANCEL_TURN".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    let calendar = Foundation.Calendar.current
    var dayToday:Int = 0
    var monthToday:Int = 0
    var yearToday:Int = 0
    
    var indexPathRow:Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

     
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let lineView: UIView = UIView(frame: CGRect(x: 0, y: self.contentView.frame.height - 1, width: self.contentView.frame.size.width + 60, height: 1))
        lineView.backgroundColor = Colors.sharedInstance.color6
        self.contentView.addSubview(lineView)
        // Configure the view for the selected state
    }
    
    
    func setDisplayData(_ index:Int, MYDICT:NSDictionary)
    {
        self.DICTUSER = MYDICT
           //\\print ("userdict \(self.DICTUSER)")
        indexPathRow = index
           if Global.sharedInstance.myCustomerOrdersARRAY.count > 0 {
          print("indexPathRow \(indexPathRow)")
//         if let _:NSDictionary = Global.sharedInstance.myCustomerOrdersARRAY[indexPathRow] as? NSDictionary {
//            let   d:NSDictionary = Global.sharedInstance.myCustomerOrdersARRAY[indexPathRow] as! NSDictionary
//               print ("MYDICT \(d.description)")
//            }
        }
    }
    
}
//MARK: - CollectionView

extension AppointmentTableViewCell : UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 1

    }
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var STRStartDate:Date = Date()
        var STREndDate:Date = Date()
        var descriere:String = ""
        var descrierealong:String = ""
        var SimpleArrayOfServicesName:[String] = []
        var d:NSDictionary = NSDictionary()
        var caterows:Int = 0
      //  let event =  Global.sharedInstance.arrEvents[indexPathRow]
           if Global.sharedInstance.myCustomerOrdersARRAY.count > 0 {
          if let _:NSDictionary = Global.sharedInstance.myCustomerOrdersARRAY[indexPathRow] as? NSDictionary {
           d = Global.sharedInstance.myCustomerOrdersARRAY[indexPathRow] as!NSDictionary
            if let objProviderServiceDetails:NSArray =  d.object(forKey: "objProviderServiceDetails") as? NSArray
            {
                caterows = objProviderServiceDetails.count
                for i in 0 ..< caterows {
                if let x:NSDictionary = objProviderServiceDetails[i] as? NSDictionary {
                      print("x.description \(x.description)")
                    if let _:String = x.object(forKey: "nvServiceName") as? String {
                        descriere = x.object(forKey: "nvServiceName") as! String
                          print("descriere 2\(descriere)")
                        if !SimpleArrayOfServicesName.contains(descriere) {
                        SimpleArrayOfServicesName.append(descriere)
                        }
                    }
                }
                }
                
            }
         descrierealong = SimpleArrayOfServicesName.joined(separator: ", ")
     ////     print("testeee \(d)")
        //JMODE      let event =  Global.sharedInstance.arrEvents[indexPath.section]
      
     
        if let nvFromHour =  d.object(forKey: "nvFromHour") as? String
        {
            STRStartDate = Global.sharedInstance.getStringFromDateString(nvFromHour)
              print("STRStartDate\(STRStartDate)")
        }
        if let nvToHour =  d.object(forKey: "nvToHour") as? String
        {
            STREndDate = Global.sharedInstance.getStringFromDateString(nvToHour)
              print("STREndDate\(STREndDate)")
        }
            }
        }
  
        
        if indexPath.row  == 0
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowInAppointmentCollectionViewCell", for: indexPath) as! RowInAppointmentCollectionViewCell
               if Global.sharedInstance.myCustomerOrdersARRAY.count > 0 {
//            let componentsStart = calendar.components([.Hour, .Minute], fromDate: event.startDate)
//            
//            let componentsEnd = calendar.components([.Hour, .Minute], fromDate: event.endDate)
            let componentsStart = (calendar as NSCalendar).components([.hour, .minute], from: STRStartDate)
            
            let componentsEnd = (calendar as NSCalendar).components([.hour, .minute], from: STREndDate)

            
            let hourS = componentsStart.hour
            let minuteS = componentsStart.minute
            
            let hourE = componentsEnd.hour
            let minuteE = componentsEnd.minute
            
            var hourS_Show:String = hourS!.description
            var hourE_Show:String = hourE!.description
            var minuteS_Show:String = minuteS!.description
            var minuteE_Show:String = minuteE!.description
                if hourS! < 10
                {
                    hourS_Show = "0" + hourS_Show
                }
                if hourE! < 10
                {
                    hourE_Show = "0" + hourE_Show
                }
                if minuteS! < 10
                {
                    minuteS_Show = "0" +   minuteS_Show
                }
                if minuteE! < 10
                {
                    minuteE_Show = "0" + minuteE_Show
                }
                let st =  "\(hourS_Show):\(minuteS_Show) - \(hourE_Show):\(minuteE_Show)"
          //  cell.setDisplayData(st, desc:event.title)
                        cell.setDisplayData(st, desc:descrierealong, MYUSERDICT: self.DICTUSER)
            }
            return cell
           
        }
        else
        {
                   print("caterows \(caterows) si indexrow \(indexPath.row)")
           let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionAppointmentCollectionViewCell", for: indexPath) as! OptionAppointmentCollectionViewCell
            if Global.sharedInstance.myCustomerOrdersARRAY.count > 0 {
                cell1.setDisplayData(arrImg[indexPath.row -  1],desc:arrText[indexPath.row  - 1],index: indexPath.row, sectiune:indexPathRow ,MYUSERDICT: self.DICTUSER )
            }

                       return cell1
        }
    }
}

extension AppointmentTableViewCell : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0
        {
            //        let itemsPerRow:CGFloat = 1
            //        let hardCodedPadding:CGFloat = 0
            let itemWidth = collectionView.bounds.width
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
        else
        {
            let itemsPerRow:CGFloat = 5.5
            // let hardCodedPadding:CGFloat = 0
            let itemWidth = collectionView.bounds.width / itemsPerRow//) - hardCodedPadding
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth + 10, height: itemHeight)
        }
    }
    
}

///JMODE OLD BACKUP FROM SERVER

//
//  AppointmentTableViewCell.swift
//  Bthere
//
//  Created by User on 25.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//
//
//import UIKit
//
//class AppointmentTableViewCell: UITableViewCell {
//    
//    var arrImg:Array<String> = ["detailsAppointment.png","cancelAppointment.png"]
//    
//    var arrText:Array<String> = ["DETAILS_TURN".localized(LanguageMain.sharedInstance.USERLANGUAGE),"CANCEL_TURN".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
//    let calendar = NSCalendar.currentCalendar()
//    var dayToday:Int = 0
//    var monthToday:Int = 0
//    var yearToday:Int = 0
//    
//    var indexPathRow:Int = 0
//    
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//    
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        let lineView: UIView = UIView(frame: CGRectMake(0, self.contentView.frame.height - 1, self.contentView.frame.size.width + 60, 1))
//        lineView.backgroundColor = Colors.sharedInstance.color6
//        self.contentView.addSubview(lineView)
//        // Configure the view for the selected state
//    }
//    
//    
//    func setDisplayData(index:Int)
//    {
//        indexPathRow = index
//    }
//    
//}
////MARK: - CollectionView
//
//extension AppointmentTableViewCell : UICollectionViewDataSource {
//    
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//        let event =  Global.sharedInstance.arrEvents[indexPathRow]
//        
//        if indexPath.row == 0
//        {
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RowInAppointmentCollectionViewCell", forIndexPath: indexPath) as! RowInAppointmentCollectionViewCell
//            let componentsStart = calendar.components([.Hour, .Minute], fromDate: event.startDate)
//            
//            let componentsEnd = calendar.components([.Hour, .Minute], fromDate: event.endDate)
//            
//            let hourS = componentsStart.hour
//            let minuteS = componentsStart.minute
//            
//            let hourE = componentsEnd.hour
//            let minuteE = componentsEnd.minute
//            
//            var hourS_Show:String = hourS.description
//            var hourE_Show:String = hourE.description
//            var minuteS_Show:String = minuteS.description
//            var minuteE_Show:String = minuteE.description
//            
//            if hourS < 10
//            {
//                hourS_Show = "0\(hourS)"
//            }
//            if hourE < 10
//            {
//                hourE_Show = "0\(hourE)"
//            }
//            if minuteS < 10
//            {
//                minuteS_Show = "0\(minuteS)"
//            }
//            if minuteE < 10
//            {
//                minuteE_Show = "0\(minuteE)"
//            }
//            let st =  "\(hourS_Show):\(minuteS_Show) - \(hourE_Show):\(minuteE_Show)"
//            cell.setDisplayData(st, desc:event.title)
//            
//            return cell
//        }
//        else
//        {
//            let cell1 = collectionView.dequeueReusableCellWithReuseIdentifier("OptionAppointmentCollectionViewCell", forIndexPath: indexPath) as! OptionAppointmentCollectionViewCell
//            
//            cell1.setDisplayData(arrImg[indexPath.row - 1],desc:arrText[indexPath.row - 1],index: indexPath.row)
//            return cell1
//        }
//    }
//}
//
//extension AppointmentTableViewCell : UICollectionViewDelegateFlowLayout {
//    
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        if indexPath.row == 0
//        {
//            //        let itemsPerRow:CGFloat = 1
//            //        let hardCodedPadding:CGFloat = 0
//            let itemWidth = collectionView.bounds.width
//            let itemHeight = collectionView.bounds.height
//            return CGSize(width: itemWidth, height: itemHeight)
//        }
//        else
//        {
//            let itemsPerRow:CGFloat = 5.5
//            // let hardCodedPadding:CGFloat = 0
//            let itemWidth = collectionView.bounds.width / itemsPerRow//) - hardCodedPadding
//            let itemHeight = collectionView.bounds.height
//            return CGSize(width: itemWidth + 10, height: itemHeight)
//        }
//    }
//    
//}
//
