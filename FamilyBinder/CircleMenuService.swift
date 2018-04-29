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
    
    
    func getCircleLocation(menuRadius: Float, anchorPoint: CGPoint, totalCircleCount: Float, circleInstanceNumber: Float) -> CGPoint {
        let x = CGFloat(Float(anchorPoint.x) + menuRadius * cosf(2 * circleInstanceNumber * Float.pi / totalCircleCount - Float.pi / 2))
        let y = CGFloat(Float(anchorPoint.y) + menuRadius * sinf(2 * circleInstanceNumber * Float.pi / totalCircleCount - Float.pi / 2))
        return CGPoint(x: x, y: y)
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
