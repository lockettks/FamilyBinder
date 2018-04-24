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
        var imageView: UIImageView
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 0.6, height: self.frame.height * 0.6))
        imageView.center = circleCenter
        imageView.contentMode = .scaleAspectFit
        let circleImage = circleViewService.getImageForMealTypeOn(mealType: self.mealType)
        imageView.image = circleImage
        self.addSubview(imageView)

    }

    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return UIBezierPath(ovalIn: self.frame).contains(point)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
