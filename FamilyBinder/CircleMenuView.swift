//
//  CircleMenuView.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 4/21/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import UIKit

class CircleMenuView: UIView {
    
    var circleRadius: CGFloat
    let frameWidth = CGFloat(300)
    let frameHeight = CGFloat(300)
    let menuRadius = Float(75.0)
    var fillColors: [CGColor]
    var images: [UIImage]?
    var circleButtons = [CircleButton]()
    let circleMenuService = CircleMenuService()
    var selectedButton: CircleButton?

    init(ids: [String], fillColors: [CGColor], circleImages: [UIImage]?, circleRadius: CGFloat = 25.0) {
//    init(touchPoint: CGPoint, ids: [String], fillColors: [CGColor], circleImages: [UIImage]?, circleRadius: CGFloat = 25.0) {
    
//        let menuFrame = CGRect(x: 0, y: 0, width: self.frameWidth, height: self.frameHeight)
//        let menuFrame = CGRect(x: touchPoint.x-self.frameWidth/2, y: touchPoint.y-self.frameHeight/2, width: self.frameWidth, height: self.frameHeight)
//        let menuCenter = CGPoint(x: frameWidth/2, y: frameHeight/2)
        self.circleRadius = circleRadius
        self.fillColors = fillColors
        if let images = circleImages {
            if images.count == fillColors.count {
                self.images = images
            } else {
                print("Missing images for circle menu")
            }
        }
        super.init(frame: CGRect(x: 0, y: 0, width: self.frameWidth, height: self.frameHeight))
//        super.init(frame: self.frame)
//        super.init(frame: menuFrame)
        self.backgroundColor = UIColor.yellow
        for (index, fillColor) in self.fillColors.enumerated() {
            var circleButton : CircleButton
            let circleFrame = CGRect(x: 0, y: 0, width: self.circleRadius * 2, height: self.circleRadius * 2)
            if let circleImages = self.images {
                circleButton = CircleButton(id: ids[index], frame: circleFrame, fillColor: fillColor, circleImage: circleImages[index])
            } else {
                circleButton = CircleButton(id: ids[index], frame: circleFrame, fillColor: fillColor, circleImage: nil)
            }
            self.circleButtons.append(circleButton)
//            circleButton.center = circleMenuService.getCircleLocation(menuRadius: self.menuRadius, anchorPoint: menuCenter, totalCircleCount: Float(self.fillColors.count), circleInstanceNumber: Float(index))
            self.addSubview(circleButton)
        }
    }
    
    func setTouchPoint(touchPoint: CGPoint) {
        self.frame = CGRect(x: touchPoint.x-self.frameWidth/2, y: touchPoint.y-self.frameHeight/2, width: self.frameWidth, height: self.frameHeight)
        let menuCenter = CGPoint(x: frameWidth/2, y: frameHeight/2)
        for (index, circleButton) in self.circleButtons.enumerated() {
            circleButton.center = circleMenuService.getCircleLocation(menuRadius: self.menuRadius, anchorPoint: menuCenter, totalCircleCount: Float(self.fillColors.count), circleInstanceNumber: Float(index))
        }
    }
    
    func touchMoved(newPosition: CGPoint) {
        _ = getSelectedCircle(position: newPosition)
    }
    
    func touchEnded(finalPosition: CGPoint) -> CircleButton? {
        if let selectedButton = getSelectedCircle(position: finalPosition) {
            print("\nSelected \(selectedButton.id)")
            return selectedButton
        }
        return nil
    }
    
    func getSelectedCircle(position: CGPoint) -> CircleButton? {
        for circle in self.circleButtons {
            circle.setInactive()
            if circle.point(inside: position, with: nil) {
                circle.setActive()
                return circle
            }
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
