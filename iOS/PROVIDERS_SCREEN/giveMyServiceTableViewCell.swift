//
//  giveMyServiceTableViewCell.swift
//  Bthere
//
//  Created by User on 10.8.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class giveMyServiceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var openBusinessProfileBtn: UIButton!
    var index:Int = 0//שומרת את הסקשין של השורה
    var generic:Generic = Generic()
    var PARENTDELEGATE:GiveServicesParentpresentViewControllerDelegate!=nil
    @IBOutlet weak var colViewResult: UICollectionView!
    
    
    
    
    func addBottomBorder(_ any:UIView,color:UIColor)
    {
        
        let borderBottom = CALayer()
        borderBottom.frame = CGRect(x: 0, y: any.layer.frame.height, width: any.layer.frame.width + (any.layer.frame.width / 3) , height: 2)
        
        borderBottom.backgroundColor = color.cgColor;
        
        any.layer.addSublayer(borderBottom)
    }
    
    var timer: Timer? = nil
    var arrText:Array<String> =
        ["DELETE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"NAVIGATE".localized(LanguageMain.sharedInstance.USERLANGUAGE),"ORDER".localized(LanguageMain.sharedInstance.USERLANGUAGE)]
    var arrImages:Array<String> =        ["recicle-bin.png","icon-waze.png","27.png"] //was garb.png
    //   var arrImages:Array<String> = ["27.png", "26.png", "icon-waze.png"]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //בפעם הראשונה שפותחים את הדף - תוצאת החיפוש הראשונה נגללת מעט שמאלה כדי להראות למשתמש את האפשרות לגלול
//        if index == 0 && Global.sharedInstance.firstGiveService == true
//        {
//            Global.sharedInstance.firstGiveService = false
//
//            UIView.animate(withDuration: 0.1, delay: 0.1, options:UIViewAnimationOptions(), animations: { () -> Void in
//
//                self.colViewResult.layoutIfNeeded()
//                let rightOffset = CGPoint(x: self.colViewResult.contentSize.width - self.colViewResult.bounds.size.width, y: 0)
//                self.colViewResult.setContentOffset(rightOffset, animated: true)
//
//                self.timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.doDelayed), userInfo: nil, repeats: false)
//
//            }) { (completed:Bool) -> Void in
//
//            }
//        }
//        else//fix 2.3
//        {
            if  #available(iOS 10.0, *){
                self.colViewResult.layoutIfNeeded()
                self.colViewResult.setContentOffset(CGPoint(x: 0 , y: 0), animated: false)
                
            }
//        }
    }
    
    func doDelayed(_ t: Timer) {
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options:UIView.AnimationOptions(), animations: { () -> Void in
            
            self.colViewResult.layoutIfNeeded()
            self.colViewResult.setContentOffset(CGPoint(x: 0 , y: 0), animated: true)
            
        }) { (completed:Bool) -> Void in
            
        }
        
        
    }
    
    
    
}

extension giveMyServiceTableViewCell : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
        //        return Global.sharedInstance.dicResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
//        if indexPath.row == 0
//        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "big", for: indexPath) as! bigCollectionViewCell
            cell.setDisplayData(Global.sharedInstance.dicResults[index])
            
            cell.indexRow = index
            return cell
//        }
//        else
//        {
//            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "smallGiveMyServicesCollectionViewCell", for: indexPath) as! smallGiveMyServicesCollectionViewCell
//            cell1.delegateDeleteItem = Global.sharedInstance.giveServices
//            cell1.delegateCloseCollection = Global.sharedInstance.giveServices
//            cell1.setDisplayData(arrImages[indexPath.row - 1], text: arrText[indexPath.row - 1],index: indexPath.row, _indexrow: index)
//           // cell1.indexRow = index
//            cell1.coll = colViewResult
//
//            return cell1
//        }
    }
}

extension giveMyServiceTableViewCell : UICollectionViewDelegateFlowLayout {
    
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
            let itemWidth = collectionView.bounds.width / itemsPerRow//) - hardCodedPadding
            let widthscr = bounds.size.width
            var heightscr:CGFloat = 0
            heightscr  = 60 +  (widthscr * 0.7 )
            let itemHeight = 70 +  heightscr //collectionView.bounds.height
            return CGSize(width: itemWidth + 10, height: itemHeight)
        }
        
        //        if indexPath.row == 0
        //        {
        //            let itemWidth = collectionView.bounds.width
        //            let itemHeight = collectionView.bounds.height
        //            return CGSize(width: itemWidth, height: itemHeight)
        //        }
        //        else
        //        {
        //            let itemsPerRow:CGFloat = 4.5
        //            // let hardCodedPadding:CGFloat = 0
        //            let itemWidth = collectionView.bounds.width / itemsPerRow//) - hardCodedPadding
        //            let itemHeight = collectionView.bounds.height
        //            return CGSize(width: itemWidth + 10, height: itemHeight)
        //        }
    }
    func setDisplayData(_ indexPath:Int) {
        index = indexPath
    }
    
}
