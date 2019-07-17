//
//  MyCostumerTableViewCell.swift
//  bthree-ios
//
//  Created by User on 21.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
protocol scrollCollectionDelegate {
    func scrollCollection()
}
//ספק קיים
class MyCostumerTableViewCell: UITableViewCell{
    var row:Int = 0
    var indexPathRow:Int = 0
    var viewDelegate:MyCostumersViewController!
    var labelName:UILabel!
    @IBOutlet weak var collItems: UICollectionView!
    let isStarArr:Array<Bool> = [true,false,false,true,false]
    let imgOptionsArray:Array<String> = ["44.png","call.png","46.png","47.png"]
    let nameOptionsArray:Array<String> = [ "NEWDELETE".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                           "NEWCALL".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                           "NEWMYTURN".localized(LanguageMain.sharedInstance.USERLANGUAGE),
                                           "COSTUMER".localized(LanguageMain.sharedInstance.USERLANGUAGE)
    ]
    let searchArray:Array<String> = []
    func setDisplayData(_ index:Int)
    {
        indexPathRow = index
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func scrollCollection()  {
    }
    
}

extension MyCostumerTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CostumerFromListCollectionViewCell", for: indexPath) as! CostumerFromListCollectionViewCell
            let customer:NSDictionary = (Global.sharedInstance.searchCostumersArray[indexPathRow]as! NSDictionary) as NSDictionary
//            print("crash NSDictionary \(d.description)")
            let consumerNameJ:String = customer.object(forKey: "nvFullName") as! String // + d.objectForKey("nvLastName") as! String
            var arestea:Bool = true
            if let somethingelse =  customer.object(forKey: "bIsVip") as? Int {
                if somethingelse == 0 {
                    arestea = false
                }
            } else if let somethingelse:Bool =  customer.object(forKey: "bIsVip") as? Bool {
                if somethingelse == false {
                    arestea = false
                }
            }
            var imageCustomer:String = ""
            
            if let somethingelse =  customer.object(forKey: "nvImage") as? String
            {
                imageCustomer = somethingelse
            }
            else
            {
                imageCustomer = ""
            }
            if cell.tag  == 134 {
                
            }
            cell.setDisplayData(imageCustomer, costumerName:consumerNameJ , isStar: arestea)
            self.labelName = cell.lblName
            return cell
        }
        else
        {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsForCostumerCollectionViewCell", for: indexPath) as! OptionsForCostumerCollectionViewCell
            cell1.row = row
            cell1.coll = collItems
            cell1.delegateCloseCollectionDelegate = viewDelegate
            cell1.delegate = viewDelegate
            cell1.setDisplayData(imgOptionsArray[indexPath.row - 1], desc: nameOptionsArray[indexPath.row - 1],index: indexPath.row)
            cell1.lblDescription.textAlignment = .center
            cell1.backgroundColor? = UIColor(red: 246/255.0, green: 240/255.0, blue: 232/255.0, alpha: 1.0)
            return cell1
        }
    }
    
}

extension MyCostumerTableViewCell : UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0
        {
            let itemWidth = collectionView.bounds.width
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
        else
        {
            let itemsPerRow:CGFloat = 6.5
            let itemWidth = collectionView.bounds.width / itemsPerRow
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth + 10, height: itemHeight)
        }
    }
    
}
