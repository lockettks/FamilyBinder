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
    var frameWidth: CGFloat
    var frameHeight: CGFloat
    var menuRadius = Float(90.0)
    var fillColors: [CGColor]
    var images: [UIImage]?
    var circleButtons = [CircleButton]()
    let circleMenuService = CircleMenuService()
    let containerView: UIView
    var blur = UIVisualEffectView()
    var vibrancyView = UIVisualEffectView()
    
    init(ids: [String], fillColors: [CGColor], containerView: UIView, circleImages: [UIImage]?, circleRadius: CGFloat = 30.0) {
        self.containerView = containerView
        self.frameWidth = self.containerView.frame.size.width
        self.frameHeight = self.containerView.frame.size.height
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
        
        self.backgroundColor = .clear
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            let blurEffect = UIBlurEffect(style: .prominent)
            blur = UIVisualEffectView(effect: blurEffect)
            
            blur.frame = self.frame
            blur.isUserInteractionEnabled = false
            self.addSubview(blur)
            
            blur.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                blur.heightAnchor.constraint(equalTo: self.heightAnchor),
                blur.widthAnchor.constraint(equalTo: self.widthAnchor)
                ])
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            vibrancyView.translatesAutoresizingMaskIntoConstraints = false
            blur.contentView.addSubview(vibrancyView)
            
            NSLayoutConstraint.activate([
                vibrancyView.heightAnchor.constraint(equalTo: blur.contentView.heightAnchor),
                vibrancyView.widthAnchor.constraint(equalTo: blur.contentView.widthAnchor),
                vibrancyView.centerXAnchor.constraint(equalTo: blur.contentView.centerXAnchor),
                vibrancyView.centerYAnchor.constraint(equalTo: blur.contentView.centerYAnchor)
                ])
        }
        
        for (index, fillColor) in self.fillColors.enumerated() {
            var circleButton : CircleButton
            let circleFrame = CGRect(x: 0, y: 0, width: self.circleRadius * 2, height: self.circleRadius * 2)
            if let circleImages = self.images {
                circleButton = CircleButton(id: ids[index], frame: circleFrame, fillColor: fillColor, circleImage: circleImages[index])
            } else {
                circleButton = CircleButton(id: ids[index], frame: circleFrame, fillColor: fillColor, circleImage: nil)
            }
            self.circleButtons.append(circleButton)
            
            if UIAccessibilityIsReduceTransparencyEnabled() {
                self.addSubview(circleButton)
            } else {
                vibrancyView.contentView.addSubview(circleButton)
            }
        }
    }
    
    func setCircleMenuLocation(touchPoint: CGPoint, sourceRect: CGRect?) {
        
        self.frame = CGRect(x: 0, y: 0, width: self.frameWidth, height: self.frameHeight)
        var menuSpacing = self.menuRadius
        let menuCenter = touchPoint
        var circleSpacingFactor = Float(1.5)
        var numberOfCirclesToFit = getNumberOfCirclesToFit(circleSpacingFactor: circleSpacingFactor)
        var firstCirclePosition = getInitialFirstCirclePosition(numberOfCirclesToFit: numberOfCirclesToFit)
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
                numberOfCirclesToFit = getNumberOfCirclesToFit(circleSpacingFactor: circleSpacingFactor)
                firstCirclePosition = getInitialFirstCirclePosition(numberOfCirclesToFit: numberOfCirclesToFit)
            }
            if isOverlappingCircles() {
                menuSpacing += 10
            }
        } while isCircleOutsideContainer(containerView: self.containerView)
        
        let path = UIBezierPath (
            roundedRect: blur.frame,
            cornerRadius: 0)
        if let sourceRect = sourceRect {
            let rectangle = createRectangle(windowRect: sourceRect)
            path.append(rectangle)
            path.usesEvenOddFillRule = true
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            maskLayer.fillRule = kCAFillRuleEvenOdd
            blur.layer.mask = maskLayer
            print("test")
        }
        
        animateMenuOpen(origin: touchPoint)
    }
    
    func createRectangle(windowRect: CGRect) -> UIBezierPath{
        // create window to view below
        let path = UIBezierPath()
        
        path.move(to: windowRect.origin)
        path.addLine(to: CGPoint(x: windowRect.origin.x + windowRect.size.width, y: windowRect.origin.y ))
        path.addLine(to: CGPoint(x: windowRect.origin.x + windowRect.size.width, y: windowRect.origin.y + windowRect.size.height))
        path.addLine(to: CGPoint(x: windowRect.origin.x, y: windowRect.origin.y + windowRect.size.height))
        
        // TODO:  Not sure if I need this
        //        let inset = CGFloat(10)  // Window needs to be smaller than the full width otherwise the blur view gets chopped off
        //        path.move(to: CGPoint(x: windowRect.origin.x + inset, y: windowRect.origin.y))
        //        path.addLine(to: CGPoint(x: windowRect.origin.x + windowRect.size.width - inset * 2, y: windowRect.origin.y ))
        //        path.addLine(to: CGPoint(x: windowRect.origin.x + windowRect.size.width - inset * 2, y: windowRect.origin.y + windowRect.size.height))
        //        path.addLine(to: CGPoint(x: windowRect.origin.x + inset, y: windowRect.origin.y + windowRect.size.height))
        //
        
        path.close()
        
        return path
    }
    
    func animateMenuOpen(origin : CGPoint) {
        let menuCenter = origin
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
