//
//  MyWaitingListTableViewCell.swift
//  bthree-ios
//
//  Created by User on 29.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class MyWaitingListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colWaitingList: UICollectionView!
    
    var delegate:deleteFromWaitingListDelegate!=nil
    var indexRow:Int = 0
    let calendar = Foundation.Calendar.current
    var today:Date = Date()
    var imagesArray:Array <String> = ["22.png","26.png","28.png"]
    var datesArray:Array <Date> = [Date(),Date(timeIntervalSinceReferenceDate: -12345.0),Date(timeIntervalSinceReferenceDate: +123000089.0)]
    
    var textArray:Array <String> =
        ["תספורת אישה בחצי מחיר",
         "1 + 1 על מסיכות השיער",
         "גוונים ב₪200 עד השעה 2:00"]
    
    var generic:Generic = Generic()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setDisplayData(_ index:Int)
    {
        indexRow = index
    }
    
    
    func getHour(_ date:Date)-> String
    {
        let components = (calendar as NSCalendar).components([.hour,.minute], from: date)
        let hour =  components.hour
        let minute =  components.minute
        return "\(hour):\(minute)"
    }
    
    func shortDate(_ date:Date) -> String {
        
        let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)
        
        let components1 = (calendar as NSCalendar).components([.day, .month, .year], from: Date())
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        let yearToday =  components1.year
        let monthToday = components1.month
        let dayToday = components1.day
        
        if year == yearToday && month == monthToday && day == dayToday
        {
            return "TODAY".localized(LanguageMain.sharedInstance.USERLANGUAGE)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
    
}


extension MyWaitingListTableViewCell : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigWaitingListCollectionViewCell", for: indexPath) as! BigWaitingListCollectionViewCell
            
//            cell.setDisplayData(imagesArray[indexRow], date: shortDate(datesArray[indexRow]),hour:  getHour(datesArray[indexRow]), text: textArray[indexRow])
            
            cell.setDisplayData(Global.sharedInstance.arrWaitingList[indexRow].nvLogo, date:shortDate(Global.sharedInstance.arrWaitingList[indexRow].dtDateOrder), hour: getHour(Global.sharedInstance.arrWaitingList[indexRow].dtDateOrder), text: Global.sharedInstance.arrWaitingList[indexRow].nvComment)
            
            
            cell.index = indexRow
            return cell
        }
        else
        {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "SmallWaitingListCollectionViewCell", for: indexPath) as! SmallWaitingListCollectionViewCell
            
            cell1.index = indexRow
            
            return cell1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 1
        {
            var dicDelete:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
            
            dicDelete["iWaitingForServiceId"] = Global.sharedInstance.arrWaitingList[indexRow].iWaitingForServiceId as AnyObject
            
            
            api.sharedInstance.DeleteFromWaitingList(dicDelete, success:{ (operation: AFHTTPRequestOperation!,responseObject: Any?) -> Void in
                if let _ = responseObject as? Dictionary<String,AnyObject> {
                    let RESPONSEOBJECT = responseObject as! Dictionary<String,AnyObject>  // fix Swift 3
                    if let _ = RESPONSEOBJECT["Error"]!["ErrorCode"] as? Int {
                        if RESPONSEOBJECT["Error"]!["ErrorCode"] as! Int != 1
                    {
                        Alert.sharedInstance.showAlertDelegate("ERROR_SERVER".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                    }
                    else
                    {
                        Global.sharedInstance.arrWaitingList.remove(at: self.indexRow)
                        self.delegate.deleteFromWaitingList()
                    }
                    }
                }
                    },failure: {(AFHTTPRequestOperation, Error) -> Void in
//                        Alert.sharedInstance.showAlertDelegate("NO_INTERNET".localized(LanguageMain.sharedInstance.USERLANGUAGE))
                })
        }
    }
    
    
}

extension MyWaitingListTableViewCell : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0
        {
            let itemWidth = collectionView.bounds.width
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
        else
        {
            let itemsPerRow:CGFloat = 4.5
            let itemWidth = collectionView.bounds.width / itemsPerRow
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth + 10, height: itemHeight)
        }
}
}


