
//
//  Section2TableViewCell.swift
//  bthree-ios
//
//  Created by User on 23.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
protocol ReloadCollectionDelegate{
    func ReloadCollection(_ collImages:UICollectionView)
}
class Section2TableViewCell: UITableViewCell {
    
 var delegat:ReloadCollectionDelegate! = nil
    
    @IBOutlet weak var collSubject: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var scalingTransform : CGAffineTransform!
        scalingTransform = CGAffineTransform(scaleX: -1, y: 1)
        collSubject.transform = scalingTransform
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisplayData(){
        
        delegat.ReloadCollection(collSubject)
    }


}
