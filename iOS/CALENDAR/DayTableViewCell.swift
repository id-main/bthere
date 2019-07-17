//
//  DayTableViewCell.swift
//  bthree-ios
//
//  Created by Lior Ronen on 3/1/16.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    @IBOutlet var lblDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        addBorderBottom(size: 1, color: Colors.sharedInstance.color1)

    }
    //MARK: _  cell design
    func setDisplayData(_ str:String){
        lblDesc.text = str
    }
    //MARK: - Borders
    func addBorderBottom(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }
    
    fileprivate func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }


}
