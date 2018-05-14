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
    
    func setCircleMenuLocation(touchPoint: CGPoint, containerView: UIView) {
        self.frame = CGRect(x: touchPoint.x-self.frameWidth/2, y: touchPoint.y-self.frameHeight/2, width: self.frameWidth, height: self.frameHeight)
        var menuSpacing = self.menuRadius
        let menuCenter = CGPoint(x: frameWidth/2, y: frameHeight/2)
        var circleSpacingFactor = Float(1.5)
        var numberOfCirclesToFit = getNumberOfCirclesToFit(circleSpacingFactor: circleSpacingFactor)
        var firstCirclePosition = getInitialFirstCirclePosition(numberOfCirclesToFit: numberOfCirclesToFit) //pretty = -1.5
        let maxPosition = numberOfCirclesToFit - 1 + Float(abs(firstCirclePosition))
        repeat {
            var position = firstCirclePosition
            for circleButton in self.circleButtons {
                circleButton.center = self.circleMenuService.getCircleLocation(menuRadius: menuSpacing, anchorPoint: menuCenter, totalCircleCount: numberOfCirclesToFit-1, circleInstanceNumber: Float(position))
                position += 1
            }
            firstCirclePosition += 0.5
            if isRunOutOfPositions(firstCirclePosition: firstCirclePosition, maxPosition: maxPosition) {
                circleSpacingFactor += 0.5
                menuSpacing += 10
                numberOfCirclesToFit = getNumberOfCirclesToFit(circleSpacingFactor: circleSpacingFactor) //duplicate/reset
                firstCirclePosition = getInitialFirstCirclePosition(numberOfCirclesToFit: numberOfCirclesToFit) //duplicate/reset
            }
            if isOverlappingCircles() {
                menuSpacing += 10
            }
        } while isCircleOutsideContainer(containerView: containerView)
        animateMenuOpen()
    }
    
    func animateMenuOpen() {
        let menuCenter = CGPoint(x: frameWidth/2, y: frameHeight/2)
        var delay = Double(0)
        for circleButton in self.circleButtons {
            let newCenter = circleButton.center
            circleButton.center = menuCenter
            UIView.animate(withDuration: 0.15, delay: delay, options: .curveEaseIn, animations: {
                circleButton.center = newCenter
            }, completion: nil)
            delay += 0.03
        }
    }
    
    func getNumberOfCirclesToFit(circleSpacingFactor : Float) -> Float {
        return Float(self.circleButtons.count) * circleSpacingFactor
    }
    
    func getInitialFirstCirclePosition(numberOfCirclesToFit : Float) -> Float {
        return numberOfCirclesToFit / Float(self.circleButtons.count) * -1
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
    
    func isCircleOutsideContainer(containerView: UIView) -> Bool {
        var isOutside = false
        for circleButton in self.circleButtons {
            let circleConverted = self.convert(circleButton.frame, to: containerView)
            if !(containerView.frame.contains(circleConverted)) {
                isOutside = true
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
