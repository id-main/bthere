//
//  imageforstart.swift
//  Bthere
//
//  Created by BThere on 10/18/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import Foundation
import UIKit

class MyImageStart: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
    
    if UIDevice.current.userInterfaceIdiom == .pad {
    self.image = UIImage(named: "main_image_for_ipad.jpg")
    } else {
    self.image = UIImage(named: "main_image_for_iphone.jpg")
    }
    }
}
