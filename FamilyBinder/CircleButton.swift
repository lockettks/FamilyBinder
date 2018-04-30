//
//  CircleButton.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 4/15/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import UIKit

class CircleButton: UIView {
    var id: String
    var radius: CGFloat
    var circleCenter: CGPoint
    var fillColor: CGColor
    var circleImage: UIImage?
    var circleLayer:CAShapeLayer
    
    let circleViewService = CircleMenuService()
    
    init(id: String, frame: CGRect, fillColor: CGColor, circleImage: UIImage?) {
        self.id = id
        self.radius = frame.width/2
        self.circleCenter = CGPoint(x: radius, y: radius)
        self.fillColor = fillColor
//        self.mealType = mealType
        self.circleLayer = CAShapeLayer()
        
        super.init(frame: frame)
        
//        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(arcCenter: self.circleCenter, radius: self.radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath
        circleLayer.fillColor = self.fillColor
        self.layer.addSublayer(circleLayer)

        
        if let circleImage = circleImage {
            self.circleImage = circleImage
            
            var imageView: UIImageView
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 0.6, height: self.frame.height * 0.6))
            imageView.center = circleCenter
            imageView.contentMode = .scaleAspectFit
            imageView.image = self.circleImage
            self.addSubview(imageView)
        }
//        let circleImage = circleViewService.getImageForMealTypeOn(mealType: self.mealType)
//        imageView.image = circleImage
//        self.addSubview(imageView)
    }
    
    func setActive(){
        self.circleLayer.fillColor =  UIColor.red.cgColor
    }
    
    func setInactive(){
        self.circleLayer.fillColor =  self.fillColor
    }

    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return UIBezierPath(ovalIn: self.frame).contains(point)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
