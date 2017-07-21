//
//  ScheduledMeal.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/20/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation

class ScheduledMeal {
    var recipe:Recipe
    var scheduledDate = Date()
    var mealType : MealType
    
    init?(recipe:Recipe?, scheduledDate:Date?, mealType:MealType?){
        if let newRecipe = recipe {
            self.recipe = newRecipe
        } else {
            print("Unable to add recipe to meal plan.  Missing recipe.")
            return nil
        }
        if let newScheduledDate = scheduledDate {
            self.scheduledDate = newScheduledDate
        } else {
            print("Unable to add recipe to meal plan.  Missing scheduled date.")
            return nil
        }
        if let newMealType = mealType {
            self.mealType = newMealType
        } else {
            print("Unable to add recipe to meal plan.  Missing meal type.")
            return nil
        }
    }
}
