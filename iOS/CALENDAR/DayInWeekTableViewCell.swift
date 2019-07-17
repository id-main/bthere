//
//  DayInWeekTableViewCell.swift
//  bthree-ios
//
//  Created by User on 23.2.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class DayInWeekTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDesc: UILabel!
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
    //MARK: - Cell design
    
    func setDisplayData(_ str:String){
        lblDesc.text = str
    }
    //MARK:- borders
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
