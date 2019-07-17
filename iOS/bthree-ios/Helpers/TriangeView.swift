//
//  TriangeView.swift
//  bthree-ios
//
//  Created by User on 2.3.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

//import Foundation
import UIKit

class TriangeView: UIView {

    override func draw(_ rect: CGRect) {
        
        // Get Height and Width
        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        
        // Create Path
        let bezierPath = UIBezierPath()
        
        // Draw Points
        
 


        bezierPath.close()
        
        bezierPath.move(to: CGPoint(x: 0, y: layerHeight))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: layerHeight))
        bezierPath.addLine(to: CGPoint(x: layerHeight-8, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: layerHeight+7))
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
