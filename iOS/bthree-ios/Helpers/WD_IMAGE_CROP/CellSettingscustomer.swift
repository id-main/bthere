//
//  CellSettingscustomer.swift
//  BThere
//
//  Created by Ioan Ungureanu on 30/08/2017.
//  Copyright © 2017 Bthere. All rights reserved.
//

import Foundation
import UIKit


class CellSettingscustomer: UICollectionViewCell  {
    @IBOutlet weak var titluitem:UILabel!
    var rowDIfferent:Int = 0 //for payment whitch is grey
    @IBOutlet weak var rectangleVIEW:UIView!
override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

func setDisplayDatax(_ text: String)
{
//    if rowDIfferent == 6 {
//    self.rectangleVIEW.backgroundColor = UIColor.lightGrayColor()
//    }
    titluitem.text = text
}
}
