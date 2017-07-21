//
//  MealPlan.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/20/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation

class MealPlan {
    static let sharedInstance = MealPlan()
    var mealPlan = [ScheduledMeal]()
    
    func addToMealPlan(mealToAdd : ScheduledMeal?) {
        if let newMeal = mealToAdd {
            mealPlan.append(newMeal)
        }
    }
    
}
