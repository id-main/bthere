//
//  CostumerFromListCollectionViewCell.swift
//  bthree-ios
//
//  Created by User on 21.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class CostumerFromListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var defaultImg: UIImageView!
    @IBOutlet weak var viewDefaultimg: UIView!
    @IBOutlet weak var imgCostumer: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnStar: UIButton!
    @IBOutlet weak var viewSideLine: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds;
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    func setDisplayData(_ imgName:String,costumerName:String,isStar:Bool)
    {
        imgCostumer.isUserInteractionEnabled = false
        defaultImg.isUserInteractionEnabled = false
        imgCostumer.contentMode = .scaleAspectFit
        defaultImg.contentMode = .scaleAspectFit
   
        if imgName == "" || imgName == "<null>"
        {
            viewDefaultimg.isHidden = false
            defaultImg.isHidden = false
            imgCostumer.isHidden = true
            defaultImg.image = UIImage(named: "supplier-iphone-icons@x1-33.png")
        } else {
            viewDefaultimg.isHidden = true
            defaultImg.isHidden = true
            imgCostumer.isHidden = false
            let dataDecoded:Data = Data(base64Encoded: (imgName), options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
            var decodedimage:UIImage = UIImage()
            if (UIImage(data: dataDecoded) != nil) {
                decodedimage = UIImage(data: dataDecoded)!
                imgCostumer.image = decodedimage
            } else {
             //   imgCostumer.image = UIImage(named: "IMG_05072016_131013.png") cover_pic.jpg
                 imgCostumer.image = UIImage(named: "cover_pic.jpg")
            }
        }
        lblName.text = costumerName
        btnStar.isHidden = !isStar
    }
}
