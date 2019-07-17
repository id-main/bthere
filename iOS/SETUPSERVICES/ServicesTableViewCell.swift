//
//  ServicesTableViewCell.swift
//  bthree-ios
//
//  Created by User on 14.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

protocol reloadCollectionDelegate {
    func reloadCollection(_ providerServiceSort:Array<objProviderServices>)
}

class ServicesTableViewCell: UITableViewCell,reloadCollectionDelegate {

    @IBOutlet weak var collServices: UICollectionView!
    var index:Int = 0//מיקום השרות בטבלה הכללית
    var timer: Timer? = nil
    var canbechecked:Bool  = false
    //    var arrayServiceDesc:Array<String> = ["תספורת אישה","פן","תספורת גבר","גוונים"]
    //    var arrayServiceHours:Array<String> = ["20 second","40 second","1.30-2.30","20-40"]
    //    var arrayServicePrices:Array<String> = ["150-250","150-70","150-450","120-50"]

    var ProviderServicesArray:Array<objProviderServices> = Array<objProviderServices>()
    var delegateMoreInfo:showMoreInfoDelegate!=nil
    var indexPathRow:Int = 0
    var parent_ListServicesViewController:ListServicesViewController = ListServicesViewController()
    var multipleSelected = false
    var ismultipleactive = 0
    var ismoresessions:Bool = false
    func addBottomBorder(_ any:UIView,color:UIColor)
    {
        let borderBottom = CALayer()
        borderBottom.frame = CGRect(x: 0, y: any.layer.frame.height, width: any.layer.frame.width + (any.layer.frame.width / 3) , height: 2)

        borderBottom.backgroundColor = color.cgColor;

        any.layer.addSublayer(borderBottom)
    }

    var arrText:Array<String> = ["MORE_INFORMATION".localized(LanguageMain.sharedInstance.USERLANGUAGE),"MULTIPLE_SELECT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"ORDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var arrTextForCellSelected:Array<String> = ["MORE_INFORMATION".localized(LanguageMain.sharedInstance.USERLANGUAGE),"MULTIPLE_SELECT".localized(LanguageMain.sharedInstance.USERLANGUAGE),"ORDER_MARKED".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var arrTextAfterCellSelected:Array<String> = ["MORE_INFORMATION".localized(LanguageMain.sharedInstance.USERLANGUAGE),"MULTIPLE_SELECT".localized(LanguageMain.sharedInstance.USERLANGUAGE),""]
    // var arrImages:Array<String> = ["v-small.png","circle.png","more-info.png"]
    var arrImages:Array<String> = ["28.png","empty_circle.png","27.png"]
    var arrImagesForCellSelected:Array<String> = ["28.png","29.png","27.png"]
    var arrImagesCellSelected:Array<String> = ["28.png","29.png",""]
    var arrImagesAfterCellSelected:Array<String> = ["28.png","empty_circle.png",""]

    // circleEmpty1.png - old
    //    empty_circle - new
    //MARK: - initial

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        Global.sharedInstance.indexCellSelected = -1
        Global.sharedInstance.isFirstCellSelected = false
        Global.sharedInstance.multipleServiceName = []

        //בפעם הראשונה שפותחים את הדף - תוצאת החיפוש הראשונה נגללת מעט שמאלה כדי להראות למשתמש את האפשרות לגלול
        if index == 0 && Global.sharedInstance.firstService == true
        {
            Global.sharedInstance.firstService = false
            self.collServices.layoutIfNeeded()
            //
            //            UIView.animate(withDuration: 0.1, delay: 0.1, options:UIViewAnimationOptions(), animations: { () -> Void in
            //self.collServices.layoutIfNeeded()
            //
            //
            //                let rightOffset = CGPoint(x: self.collServices.contentSize.width - self.collServices.bounds.size.width, y: 0)
            //                self.collServices.setContentOffset(rightOffset, animated: true)
            //
            //                self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.doDelayed), userInfo: nil, repeats: false)
            //
            //            }) { (completed:Bool) -> Void in
            //
            //            }
        }
        else//fix 2.3
        {
            if  #available(iOS 10.0, *){
                self.collServices.layoutIfNeeded()
                self.collServices.setContentOffset(CGPoint(x: 0 , y: 0), animated: false)
            }
        }
        //        for elem:objProviderServices in self.ProviderServicesArray
        //        {
        //            print("/////////")
        //            print("table cell element services: \(elem.getDic())")
        //            print("/////////")
        //        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //   super.setSelected(selected, animated: animated)

        Global.sharedInstance.arrayServicesNames = []
        for item in ProviderServicesArray {
            Global.sharedInstance.arrayServicesNames.append(item.nvServiceName)
        }
    }


    func setDisplayData(_ index:Int, _ismultipleactive:Int, _ismoresessions:Bool, _canbechecked:Bool)
    {

        indexPathRow = index
        ismultipleactive = _ismultipleactive
        ismoresessions = _ismoresessions


        self.canbechecked = _canbechecked
        //        if Global.sharedInstance.indexCellSelected != -1
        //        {

        collServices.reloadData()
        for elem:objProviderServices in self.ProviderServicesArray
        {
            print("/////////")
            print("services table element services: \(elem.getDic())")
            print("/////////")
        }

        //        }
    }
    

    func doDelayed(_ t: Timer) {

        UIView.animate(withDuration: 0.1, delay: 0.1, options:UIView.AnimationOptions(), animations: { () -> Void in

            self.collServices.layoutIfNeeded()
            self.collServices.setContentOffset(CGPoint(x: 0 , y: 0), animated: true)

        }) { (completed:Bool) -> Void in

        }
        timer = nil
    }

    //MARK: - Delegate Function

    func reloadCollection(_ providerServiceSort:Array<objProviderServices>)
    {
        ProviderServicesArray = providerServiceSort
        if ProviderServicesArray.count > 0
        {
            collServices.reloadData()
        }
        else
        {
            Alert.sharedInstance.showAlert("NO_RESOLTS".localized(LanguageMain.sharedInstance.USERLANGUAGE), vc: Global.sharedInstance.viewCon!)
        }
    }
}

// MARK: - collectionView
extension ServicesTableViewCell : UICollectionViewDataSource {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 //4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        //        if indexPath.row == 0
        //        {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigService", for: indexPath) as! BigServiceCollectionViewCell

        cell.delegate = delegateMoreInfo
        cell.index = indexPathRow
        print(Global.sharedInstance.canselectmultiple)
        cell.setDisplayData(ProviderServicesArray[indexPathRow], _ismultiplepossible: Global.sharedInstance.canselectmultiple, _canbechecked: self.canbechecked, _iServiceTime: ProviderServicesArray[indexPathRow].iTimeOfService)
        cell.delegateReloadTbl = parent_ListServicesViewController
        return cell
        //   }
        //        else
        //        {
        //            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "SmallInService", for: indexPath) as! SmallInServiceCollectionViewCell
        //
        //            cell1.index = index
        //            cell1.delegate = delegateMoreInfo
        //            cell1.index = indexPathRow
        //            cell1.delegateReloadTbl = parent_ListServicesViewController
        //
        //
        //
        //
        //            if indexPath.row != 1
        //            {
        //                if Global.sharedInstance.arrCellsMultiple.contains(true)//בחרו מישהו אחד לפחות
        //                {
        //                    if Global.sharedInstance.arrCellsMultiple[index] == true//בחור
        //                    {
        //                        if indexPath.row == 2//סל של בחירה מרובה
        //                        {
        //                            multipleSelected = true
        //                            if Global.sharedInstance.arrCellsMultiple.index(of: true) == index
        //                                //if Global.sharedInstance.isFirstCellSelected == false//הראשון
        //                            {
        //                                cell1.setDisplayData(arrImagesForCellSelected[indexPath.row - 1], text: arrTextForCellSelected[indexPath.row - 1],index: indexPath.row, serviceName: ProviderServicesArray[indexPathRow].nvServiceName, _canbechecked: self.canbechecked, _iServiceTime: ProviderServicesArray[indexPathRow].iTimeOfService )
        //
        //                            }
        //                            else
        //                            {
        //                                cell1.setDisplayData(arrImagesCellSelected[indexPath.row - 1], text: arrTextAfterCellSelected[indexPath.row - 1],index: indexPath.row, serviceName: ProviderServicesArray[indexPathRow].nvServiceName, _canbechecked: self.canbechecked, _iServiceTime: ProviderServicesArray[indexPathRow].iTimeOfService)
        //                            }
        //                        }
        //                        else if multipleSelected == true && indexPath.row == 3
        //                        {
        //                            multipleSelected = false
        //                            if Global.sharedInstance.arrCellsMultiple.index(of: true) == index
        //                                //if Global.sharedInstance.isFirstCellSelected == false//הראשון
        //                            {
        //                                cell1.setDisplayData(arrImagesForCellSelected[indexPath.row - 1], text: arrTextForCellSelected[indexPath.row - 1],index: indexPath.row, serviceName: ProviderServicesArray[indexPathRow].nvServiceName, _canbechecked: self.canbechecked, _iServiceTime: ProviderServicesArray[indexPathRow].iTimeOfService)
        //                                Global.sharedInstance.isFirstCellSelected = true
        //                            }
        //                            else
        //                            {
        //                                cell1.setDisplayData(arrImagesCellSelected[indexPath.row - 1], text: arrTextAfterCellSelected[indexPath.row - 1],index: indexPath.row, serviceName: ProviderServicesArray[indexPathRow].nvServiceName, _canbechecked: self.canbechecked, _iServiceTime: ProviderServicesArray[indexPathRow].iTimeOfService)
        //                            }
        //                        }
        //                    }
        //                    else
        //                    {
        //                        if indexPath.row == 2//סל של בחירה מרובה ולא בחור
        //                        {
        //                            cell1.setDisplayData(arrImages[indexPath.row - 1], text: arrTextAfterCellSelected[indexPath.row - 1],index: indexPath.row, serviceName: ProviderServicesArray[indexPathRow].nvServiceName, _canbechecked: self.canbechecked, _iServiceTime: ProviderServicesArray[indexPathRow].iTimeOfService)
        //                        }
        //                        else//לא בחור
        //                        {
        //                            cell1.setDisplayData(arrImagesAfterCellSelected[indexPath.row - 1], text: arrTextAfterCellSelected[indexPath.row - 1],index: indexPath.row, serviceName: ProviderServicesArray[indexPathRow].nvServiceName, _canbechecked: self.canbechecked, _iServiceTime: ProviderServicesArray[indexPathRow].iTimeOfService)
        //                        }
        //                    }
        //                }
        //                else//לא בחרו עדיין אף אחד
        //                {
        //                    cell1.setDisplayData(arrImages[indexPath.row - 1], text: arrText[indexPath.row - 1],index: indexPath.row, serviceName: ProviderServicesArray[indexPathRow].nvServiceName, _canbechecked: self.canbechecked, _iServiceTime: ProviderServicesArray[indexPathRow].iTimeOfService)
        //                }
        //
        //            }
        //            else
        //            {
        //                cell1.setDisplayData(arrImages[indexPath.row - 1], text: "",index: indexPath.row, serviceName: ProviderServicesArray[indexPathRow].nvServiceName, _canbechecked: self.canbechecked, _iServiceTime: ProviderServicesArray[indexPathRow].iTimeOfService)
        //            }
        //
        //
        //
        //            return cell1
        //        }
    }

}


extension ServicesTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath.row == 0) {
            let itemWidth = collectionView.bounds.width
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth, height: itemHeight)
        } else {
            let itemsPerRow:CGFloat = 4.5
            let itemWidth = collectionView.bounds.width / itemsPerRow
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth - 30, height: itemHeight)
        }
    }
}


