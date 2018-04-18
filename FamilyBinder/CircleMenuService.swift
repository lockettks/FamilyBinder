//
//  CircleMenuController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 4/12/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import Foundation
import UIKit

class CircleMenuService {
    
    
    func getCircleLocation(menuRadius: CGFloat, anchorPoint: CGPoint, totalCircleCount: Float, circleInstanceNumber: Float) -> CGPoint {
        //TODO:  Variable-ize hard-coded values
        let x = CGFloat(Float(anchorPoint.x) + Float(menuRadius) * cosf(2 * circleInstanceNumber * Float(M_PI) / totalCircleCount - Float(M_PI) / 2))
        let y = CGFloat(Float(anchorPoint.y + menuRadius) + Float(menuRadius) * sinf(2 * circleInstanceNumber * Float(M_PI) / totalCircleCount - Float(M_PI) / 2))
        
        let circleCenter = CGPoint(x: x, y: y)
        
        return circleCenter
        
        /* top answer!!
         let radius = circle.frame.size.width * 0.5
         var rotationInDegrees: CGFloat = 0
         
         for i in 0 ..< count {
         let tick = createTick()
         
         let x = CGFloat(Float(circle.center.x) + Float(radius) * cosf(2 * Float(i) * Float(M_PI) / Float(count) - Float(M_PI) / 2))
         let y = CGFloat(Float(circle.center.y) + Float(radius) * sinf(2 * Float(i) * Float(M_PI) / Float(count) - Float(M_PI) / 2))
         
         tick.center = CGPoint(x: x, y: y)
         // degress -> radians
         tick.transform = CGAffineTransform.identity.rotated(by: rotationInDegrees * .pi / 180.0)
         view.addSubview(tick)
         
         rotationInDegrees = rotationInDegrees + (360.0 / CGFloat(totalCircleCount))
         //rotationInDegrees = rotationInDegrees + (360.0 / CGFloat(totalCircleCount))
         
         0 -> 0 + 90 = 90
         1 -> 90 + 90 = 180
         2 -> 180 + 90 = 270
         3 -> 270 + 90 = 360
         
         }
         
         }
         
         func createTick() -> UIView {
         let tick = UIView(frame: CGRect(x: 0, y: 0, width: 2.0, height: 10.0))
         tick.backgroundColor = UIColor.blue
         
         return tick
         }
 */
        
        /*  OP's code
         myOuterRadius = width / 2
         myInnerRadius = (width / 2) - 10
         myNumberOfTicks = numTicks
         
         
         for i in 0..<myNumberOfTicks {
         let angle = CGFloat(i) * CGFloat(2 * M_PI) / CGFloat(myNumberOfTicks)
         let inner = CGPoint(x: myInnerRadius * cos(angle), y: myInnerRadius * sin(angle))
         let outer = CGPoint(x: myOuterRadius * cos(angle), y: myOuterRadius * sin(angle))
         print(angle, inner, outer)
         tickPath.move(to: inner)
         tickPath.addLine(to: outer)
         }
 */
    }
    
    func getImageForMealTypeOn(mealType: MealType) -> UIImage {
        var mealTypeImage: UIImage
        switch mealType {
        case .breakfast :
            mealTypeImage = #imageLiteral(resourceName: "breakfast_on")
            
        case .lunch :
            mealTypeImage = #imageLiteral(resourceName: "lunch_on")
            
        case .dinner :
            mealTypeImage = #imageLiteral(resourceName: "dinner_on")
            
        case .snack :
            mealTypeImage = #imageLiteral(resourceName: "snack_on")
        }
        return mealTypeImage
    }
}
