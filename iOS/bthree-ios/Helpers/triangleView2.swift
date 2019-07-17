//
//  triangleView2.swift
//  bthree-ios
//
//  Created by User on 20.4.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit

class triangleView2: UIView {

    override func draw(_ rect: CGRect) {
        
        // Get Height and Width
        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        
        // Create Path
        let bezierPath = UIBezierPath()
        
        // Draw Points

        bezierPath.close()
        
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerHeight + 12,y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth / 2 ,y: layerHeight))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        bezierPath.close()
        
        // Apply Color
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).setFill()
        bezierPath.fill()
        
        // Mask to Path
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }


}
