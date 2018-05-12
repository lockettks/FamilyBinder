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
    let frameWidth = CGFloat(200)
    let frameHeight = CGFloat(200)
    var menuRadius = Float(90.0) // 75 //TODO:  Calculate this based on circle count- may need to be updated when placing circles
    var fillColors: [CGColor]
    var images: [UIImage]?
    var circleButtons = [CircleButton]()
    let circleMenuService = CircleMenuService()
    var selectedButton: CircleButton?

    init(ids: [String], fillColors: [CGColor], circleImages: [UIImage]?, circleRadius: CGFloat = 30.0) {
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
            self.addSubview(circleButton)
        }
    }
    
    func setTouchPoint(touchPoint: CGPoint, containerView: UIView) {
        self.frame = CGRect(x: touchPoint.x-self.frameWidth/2, y: touchPoint.y-self.frameHeight/2, width: self.frameWidth, height: self.frameHeight)
        var menuRadiusDuplicate = self.menuRadius
        let menuCenter = CGPoint(x: frameWidth/2, y: frameHeight/2)
        var circleSpacingFactor = 1.5 // higher = closer // pretty = 1.5
        var numberOfCirclesToFit = (Float(self.circleButtons.count) ) * Float(circleSpacingFactor)
        var firstCirclePosition = numberOfCirclesToFit / Float(self.circleButtons.count) * -1 //pretty = -1.5
        var maxPosition = numberOfCirclesToFit - 1 + Float(abs(firstCirclePosition))
        // TODO:  CALCULATE number of Positions depending on number of buttons and where press is.  If it is in the corner, numberOfPositions will need to be increased until it fits
        
        var stop = false
            repeat {
                var position = firstCirclePosition
                for circleButton in self.circleButtons {
                    circleButton.center = circleMenuService.getCircleLocation(menuRadius: menuRadiusDuplicate, anchorPoint: menuCenter, totalCircleCount: numberOfCirclesToFit-1, circleInstanceNumber: Float(position))
                    //                    circleButton.center = circleMenuService.getCircleLocation(menuRadius: self.menuRadius, anchorPoint: menuCenter, totalCircleCount: Float(self.circleButtons.count * 2), circleInstanceNumber: Float(circleIntanceNumber)) //original.  works: count * 3
                    position += 1
                }
                
                firstCirclePosition += 0.5
//                print("firstCirclePosition: \(firstCirclePosition) frame: \(circleButtons[0].frame.origin.x) \(circleButtons[0].frame.origin.y)")
                if isRunOutOfPositions(firstCirclePosition: firstCirclePosition, maxPosition: maxPosition) {
                    print("CIRCLES CAN'T DISPLAY HERE.  breaks at position \(firstCirclePosition)")
                    circleSpacingFactor += 0.5
                    numberOfCirclesToFit = (Float(self.circleButtons.count) ) * Float(circleSpacingFactor) //duplicate/reset
                    firstCirclePosition = numberOfCirclesToFit / Float(self.circleButtons.count) * -1 //duplicate/reset
                }
                
                if isOverlappingCircles() {
                    menuRadiusDuplicate += 10
                }

            } while (isOutsideContainer(containerView: containerView) && stop == false)
//        print("\nfinal position: \(firstCirclePosition)")
        
//            let circleConverted = self.convert(circleButton.frame, to: containerView)
//            if !(containerView.frame.contains(circleConverted)) {
//                print("\ncircleButton \(index) is partially outside")
//            } else {
//                print("\ncircleButton \(index) is 100% contained in parent")
//            }
        
        

        
        if !(containerView.frame.contains(self.frame)) {
//            print("\nmenu is partially outside")
        } else {
//            print("\nmenu is 100% contained in parent")
        }
    }
    
    func isRunOutOfPositions(firstCirclePosition: Float, maxPosition: Float) -> Bool {
        return (firstCirclePosition) ==  maxPosition + 1
    }
    
    func isOverlappingCircles() -> Bool {
        var isOverlapping = false
        for (index, circle) in circleButtons.enumerated() {
            let nextCircle = index == circleButtons.count - 1 ? 0 : index + 1
            if circle.frame.intersects(circleButtons[nextCircle].frame) {
                isOverlapping = true
                break
            }
        }
        return isOverlapping
    }
    
    func isOutsideContainer(containerView: UIView) -> Bool {
        var isOutside = false
        for circleButton in self.circleButtons {
            let circleConverted = self.convert(circleButton.frame, to: containerView)
            if !(containerView.frame.contains(circleConverted)) {
                isOutside = true
                print("outside")
                return isOutside
            }
        }
        return isOutside
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
