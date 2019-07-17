//
//  LastMinuteTableViewCell.swift
//  BThere
//
//  Created by Eduard Stefanescu on 1/15/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import UIKit
//protocol scrollCollectionDelegate {
//    func scrollCollection()
//}

class LastMinuteTableViewCell: UITableViewCell{
    var row:Int = 0
    var indexPathRow:Int = 0
    var viewDelegate:LastMinuteViewController!
    var offerName:String = ""
    var offerDetail:String = ""
    var dateoffer:String = ""
    var isexpanded:Bool = false
    @IBOutlet weak var collItems: UICollectionView!
    let imgOptionsArray:Array<String> = ["creion-negru.png","44.png"]
    var ceva:CGFloat = 0
    
    
    func setDisplayDataString(_ _offername:String, _offerDetail:String, _dateoffer: String, _isexpanded:Bool, _indexPathRow:Int) {
        offerName = _offername
        offerDetail = _offerDetail
        dateoffer = _dateoffer
        isexpanded = _isexpanded
        indexPathRow = _indexPathRow
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func scrollCollection() {
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  self.isexpanded == true {
            return 1
        }
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastMinuteListCollectionViewCell", for: indexPath) as! LastMinuteListCollectionViewCell
            if indexPathRow == 0 {
                cell.setDisplayData(offerName, offerDate: dateoffer, flag: false)
            } else {
                cell.setDisplayData(offerName, offerDate: "", flag: true)
            }
            cell.borderView.isHidden = false
            cell.layoutMargins = UIEdgeInsets.zero
            cell.borderView.isHidden = false
            if indexPathRow == 0 && self.isexpanded == true {
                cell.borderView.isHidden = true
            }
            
           print("\(cell.offerDetailsLabel.frame.size.height)")
            
            return cell
        } else {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "LastMinuteForCollectionCell", for: indexPath) as! LastMinuteForCollectionCell
            cell1.row = row
            cell1.viewDelegate = viewDelegate
            cell1.coll = collItems
            if self.isexpanded == false {
                cell1.setDisplayData(imgOptionsArray[indexPath.row - 1], index:indexPath.row, offerRow: row, offerColl:collectionView)
            }
            cell1.backgroundColor? = UIColor(red: 246/255.0, green: 240/255.0, blue: 232/255.0, alpha: 1.0)
            
            return cell1
        }
    }
}


extension LastMinuteTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath.row == 0) {
            if (isexpanded == true) {
               let newHeight:CGFloat = 300.00
                let itemWidth = collectionView.bounds.width
                let itemHeight = newHeight  // collectionView.bounds.height
                
                return CGSize(width: itemWidth, height: itemHeight)
            } else {
                let itemWidth = collectionView.bounds.width
                let itemHeight = collectionView.bounds.height
                
                return CGSize(width: itemWidth, height: itemHeight)
            }
        }  else {
            
            let itemsPerRow:CGFloat = 6.5
            let itemWidth = collectionView.bounds.width / itemsPerRow
            let itemHeight = collectionView.bounds.height
            
            return CGSize(width: itemWidth + 10, height: itemHeight)
        }
    }
}
