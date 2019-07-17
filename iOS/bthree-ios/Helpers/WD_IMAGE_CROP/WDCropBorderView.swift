//
//  WDCropBorderView.swift
//  WDImagePicker
//
//  Created by Wu Di on 27/8/15.
//  Copyright (c) 2015 Wu Di. All rights reserved.
//

import UIKit

internal class WDCropBorderView: UIView {
    fileprivate let kNumberOfBorderHandles: CGFloat = 8
    fileprivate let kHandleDiameter: CGFloat = 24
    fileprivate var lockAspectRatio: Bool
 
    convenience init(frame: CGRect, lockAspectRatio locked: Bool) {
        self.init(frame: frame)
        self.lockAspectRatio = locked
        //\\print ("one of kind \( self.lockAspectRatio)")
    }
   
    override init(frame: CGRect) {
        //main init
        self.lockAspectRatio = false
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        //\\print ("two of kind \( self.lockAspectRatio)")
          }

    required init?(coder aDecoder: NSCoder) {
        self.lockAspectRatio = false
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        //\\print ("three of kind \( self.lockAspectRatio)")
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        context!.setStrokeColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor)
        context!.setLineWidth(0.5)
        context!.addRect(CGRect(x: kHandleDiameter / 2, y: kHandleDiameter / 2,
            width: rect.size.width - kHandleDiameter, height: rect.size.height - kHandleDiameter))
      context!.strokePath()//2.6

      context!.setFillColor(red: 1, green: 1, blue: 1, alpha: 0.95)
        for handleRect in calculateAllNeededHandleRects() {
              context!.fill(handleRect)
//            CGContextFillEllipseInRect(context, handleRect)
        }
    }

    fileprivate func calculateAllNeededHandleRects() -> [CGRect] {

        let width = self.frame.width
        let height = self.frame.height

        let leftColX: CGFloat = 0
        let rightColX = width - kHandleDiameter
        let centerColX = rightColX / 2

        let topRowY: CGFloat = 0
        let bottomRowY = height - kHandleDiameter
        let middleRowY = bottomRowY / 2

        //starting with the upper left corner and then following clockwise
//        let topLeft = CGRectMake(leftColX, topRowY, kHandleDiameter, kHandleDiameter)
//        let topCenter = CGRectMake(centerColX, topRowY, kHandleDiameter, kHandleDiameter)
//        let topRight = CGRectMake(rightColX, topRowY, kHandleDiameter, kHandleDiameter)
//        let middleRight = CGRectMake(rightColX, middleRowY, kHandleDiameter, kHandleDiameter)
//        let bottomRight = CGRectMake(rightColX, bottomRowY, kHandleDiameter, kHandleDiameter)
//        let bottomCenter = CGRectMake(centerColX, bottomRowY, kHandleDiameter, kHandleDiameter)
//        let bottomLeft = CGRectMake(leftColX, bottomRowY, kHandleDiameter, kHandleDiameter)
//        let middleLeft = CGRectMake(leftColX, middleRowY, kHandleDiameter, kHandleDiameter)
//        
//        return [topLeft/*, topCenter*/, topRight,/* middleRight,*/ bottomRight,/* bottomCenter*/ bottomLeft/*,
//            middleLeft*/]
 //   }
        //JMODE based on Git modify
        var handleArray = [CGRect]()
        handleArray.append(CGRect(x: leftColX, y: topRowY, width: kHandleDiameter, height: kHandleDiameter)) //top left
        handleArray.append(CGRect(x: rightColX, y: topRowY, width: kHandleDiameter, height: kHandleDiameter)) //top right
        handleArray.append(CGRect(x: rightColX, y: bottomRowY, width: kHandleDiameter, height: kHandleDiameter)) //bottom right
        handleArray.append(CGRect(x: leftColX, y: bottomRowY, width: kHandleDiameter, height: kHandleDiameter)) //bottom left
        if !lockAspectRatio {
            handleArray.append(CGRect(x: centerColX, y: topRowY, width: kHandleDiameter, height: kHandleDiameter)) //top center
            handleArray.append(CGRect(x: rightColX, y: middleRowY, width: kHandleDiameter, height: kHandleDiameter)) //middle right
            handleArray.append(CGRect(x: centerColX, y: bottomRowY, width: kHandleDiameter, height: kHandleDiameter)) //bottom center
            handleArray.append(CGRect(x: leftColX, y: middleRowY, width: kHandleDiameter, height: kHandleDiameter)) //middle left
       }
        
        return handleArray
    }
}
