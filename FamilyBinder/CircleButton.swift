//
//  CircleButton.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 4/15/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import UIKit

class CircleButton: UIView {
    var circleFrame: CGRect
    var circleCenter: CGPoint
    var fillColor: CGColor
    var mealType: MealType
    var radius: CGFloat
    var circlePath: UIBezierPath
    
    let circleViewService = CircleMenuService()
    
    init(frame: CGRect, fillColor: CGColor, mealType: MealType, radius: CGFloat) {
        self.circleFrame = frame
        circleCenter = CGPoint(x: radius, y: radius)
        self.fillColor = fillColor
        self.mealType = mealType
        self.radius = radius
        
        self.circlePath = UIBezierPath(arcCenter: self.circleCenter, radius: self.radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        super.init(frame: self.circleFrame)
        
        self.frame = self.circleFrame
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = self.circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = self.fillColor

        /*
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true
        self.setBackgroundColor(color: self.fillColor, forState: .normal)
        */
        
        self.layer.addSublayer(shapeLayer)

        let circleImage = circleViewService.getImageForMealTypeOn(mealType: self.mealType)
//        self.setImage(circleImage, for: .normal)
//        self.addTarget(self, action: #selector(onPress), for: .touchUpInside)
    }
    /*
     override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
     return UIBezierPath(ovalIn: bounds).contains(point)
     }
 */
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        print("\n circlePath \(self.circlePath) contains point: \(point)")
//        return UIBezierPath(ovalIn: self.bounds).contains(point)
//        return self.circlePath.contains(point)
        return UIBezierPath(ovalIn: self.frame).contains(point)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    @objc func onPress(){
//        print("\(self.mealType.displayName()) Button Pressed")
//    }

}
