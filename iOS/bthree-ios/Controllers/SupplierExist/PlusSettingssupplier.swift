//
//  PlusSettingssupplier.swift
//  BThere
//
//  Created by BThere on 2/9/17.
//  Copyright © 2017 Webit. All rights reserved.
//

import Foundation
import UIKit


class PlusSettingssupplier: UICollectionViewCell  {
    @IBOutlet weak var titluitem:UILabel!
    var rowDIfferent:Int = 0
    @IBOutlet weak var rectangleVIEW:UIView!
override func awakeFromNib() {
    super.awakeFromNib()
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

func setDisplayDatax(_ text: String)
{
    if UIDevice.current.userInterfaceIdiom != .pad {
        titluitem.font = UIFont(name: (titluitem.font?.familyName)!, size: 13)!
    }
    titluitem.text = text
}
}
