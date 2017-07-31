//
//  ScheduledMeal.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/20/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import RealmSwift

class ScheduledMeal : Object {
    dynamic var recipe = Recipe()
    dynamic var scheduledDate = Date()
    dynamic var mealTypeRaw = ""
    var mealType : MealType {
        return MealType(rawValue: mealTypeRaw) ?? .dinner
    }
    
    convenience init?(recipe:Recipe?, scheduledDate:Date?, mealType:MealType?){
        self.init()
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
            self.mealTypeRaw = newMealType.rawValue
        } else {
            print("Unable to add recipe to meal plan.  Missing meal type.")
            return nil
        }
    }
}
