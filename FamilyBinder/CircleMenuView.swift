//
//  CircleMenuView.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 4/21/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import UIKit

class CircleMenuView: UIView {
    
    var circleDiameter: CGFloat
    let menuRadius = Float(75.0)
    var fillColors: [CGColor]
    var images: [UIImage]?
    var circleButtons = [CircleButton]()
    let circleMenuService = CircleMenuService()
    let menuWidth = CGFloat(200)
    let menuHeight = CGFloat(200)
    
    
    
    init(touchPoint: CGPoint, fillColors: [CGColor], circleImages: [UIImage]?, circleDiameter: CGFloat = 50.0) {
        let menuFrame = CGRect(x: touchPoint.x-self.menuWidth/2, y: touchPoint.y-self.menuHeight/2, width: self.menuWidth, height: self.menuHeight)
//        let origin = CGPoint(x: 0, y: 0)
        let menuCenter = CGPoint(x: CGFloat(menuRadius), y: CGFloat(menuRadius))
        self.circleDiameter = circleDiameter
//        if let circleDiameter = circleDiameter {
//            self.circleDiameter = circleDiameter
//        } else {
//            self.circleDiameter = 50.0
//        }
        
        //let menuFrame = CGRect(x: origin.x, y: origin.y, width: 200, height: 200)
        
        
        self.fillColors = fillColors
        if let images = circleImages {
            if images.count == fillColors.count {
                self.images = images
            } else {
                print("Missing images for circle menu")
            }
        }
        
        //super.init(frame: menuFrame)
        super.init(frame: menuFrame)
        
        for (index, fillColor) in self.fillColors.enumerated() {
            var circleButton : CircleButton
            let circleFrame = CGRect(x: 0, y: 0, width: self.circleDiameter, height: self.circleDiameter)
            if let circleImages = self.images {
                circleButton = CircleButton(frame: circleFrame, fillColor: fillColor, circleImage: circleImages[index])
            } else {
                circleButton = CircleButton(frame: circleFrame, fillColor: fillColor, circleImage: nil)
            }
            self.circleButtons.append(circleButton)
            
            circleButton.center = circleMenuService.getCircleLocation(menuRadius: self.menuRadius, anchorPoint: menuCenter, totalCircleCount: Float(self.fillColors.count), circleInstanceNumber: Float(index))
            
            print("circle center \(circleButton.center)")
            
            self.addSubview(circleButton)
            self.backgroundColor = UIColor.brown
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
