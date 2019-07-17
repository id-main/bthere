//
//  SearchResultsTableViewCell.swift
//  bthree-ios
//
//  Created by User on 21.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var colViewResult: UICollectionView!
    
    
    // Variables
    var timer: Timer? = nil
    var index:Int = 0
   
    
    func addBottomBorder(_ any:UIView,color:UIColor) {
        let borderBottom = CALayer()
        borderBottom.frame = CGRect(x: 0, y: any.layer.frame.height, width: any.layer.frame.width + (any.layer.frame.width / 3) , height: 2)
        
        borderBottom.backgroundColor = color.cgColor;
        
        any.layer.addSublayer(borderBottom)
     
    }
    
    var arrText:Array<String> = ["NAVIGATE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"TO_BUSINESS_PAGE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"ORDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var arrImages:Array<String> = ["27.png", "26.png", "icon-waze.png"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

            if  #available(iOS 10.0, *){
                self.colViewResult.layoutIfNeeded()
                self.colViewResult.setContentOffset(CGPoint(x: 0 , y: 0), animated: false)
            }
    }
}

extension SearchResultsTableViewCell : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        print("global shared instance result \(Global.sharedInstance.dicResults) end of ")
//        if indexPath.row == 0
//        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "big", for: indexPath) as! bigCollectionViewCell
            cell.setDisplayData(Global.sharedInstance.dicResults[index])
            
            cell.indexRow = index
            return cell
//        }
//        else
//        {
//            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! searchCollectionViewCell
//            cell1.setDisplayData(arrImages[indexPath.row - 1], text: arrText[indexPath.row - 1],index: indexPath.row, _indexrow: index)
//
//            //cell1.indexRow = index
//
//            return cell1
//        }
    }
    
}

extension SearchResultsTableViewCell : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0
        {
            let itemWidth = collectionView.bounds.width
            let bounds = UIScreen.main.bounds
            let widthscr = bounds.size.width
            var heightscr:CGFloat = 0
            heightscr  = 60 +  (widthscr * 0.7 )
            let itemHeight = 70 +  heightscr //collectionView.bounds.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
        else
        {
            let itemsPerRow:CGFloat = 4.5
            // let hardCodedPadding:CGFloat = 0
            let itemWidth = collectionView.bounds.width / itemsPerRow//) - hardCodedPadding
            let widthscr = bounds.size.width
            var heightscr:CGFloat = 0
            heightscr  = 60 +  (widthscr * 0.7 )
            let itemHeight = 70 +  heightscr //collectionView.bounds.height
            return CGSize(width: itemWidth + 10, height: itemHeight)
        }
    }
    func setDisplayData(_ indexPath:Int) {
        index = indexPath
        print("ceee index \(index)")
    }
    
    func doDelayed(_ t: Timer) {
        
        UIView.animate(withDuration: 2.5, delay: 1.5, options:UIView.AnimationOptions(), animations: { () -> Void in
            
            self.colViewResult.layoutIfNeeded()
            self.colViewResult.setContentOffset(CGPoint(x: 0 , y: 0), animated: true)
            
        }) { (completed:Bool) -> Void in
            
        }
        timer = nil
    }
    
}
