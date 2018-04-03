//
//  MealPlanService.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 3/31/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import Foundation
import RealmSwift

class MealPlanService {
    
    let realm = try! Realm()
    
    func generateDates( anchorDate: Date, addbyUnit: Calendar.Component, numberOfDays: Int) -> [Date] {
        var dates = [Date]()
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.timeZone = TimeZone.current
        weekdayFormatter.dateFormat = "EEE"
        if let firstSundayFromAnchor = anchorDate.startOfWeek {
            if let anchorDate2 = Calendar.current.date(byAdding: addbyUnit, value: numberOfDays, to: firstSundayFromAnchor) {
                let startDate = min(firstSundayFromAnchor, anchorDate2)
                let endDate = max(firstSundayFromAnchor, anchorDate2)
                var date = startDate
                
                while date < endDate {
                    dates.append(date)
                    date = Calendar.current.date(byAdding: addbyUnit, value: 1, to: date)!
                }
            }
        }
        return dates
    }
    
    func addRecipeToMealPlan( recipe: Recipe, scheduledDate: Date, mealPlan: MealPlan ){
        let newScheduledMeal = ScheduledMeal()
        let realmRecipe = realm.objects(Recipe.self).filter("id == %@", recipe.id)
        if realmRecipe.count > 0 {
            newScheduledMeal.recipe = realmRecipe[0] as Recipe
        } else {
            // User added a non-favorited recipe to meal plan
            newScheduledMeal.recipe = recipe
        }
        newScheduledMeal.scheduledDate = scheduledDate
        
        // Add newScheduledMeal to meal plan
        try! realm.write {
            mealPlan.meals.append(newScheduledMeal)
            recipe.isOnMealPlan = true
            
            print("\(newScheduledMeal.recipe!.title) is added to meal plan for date \(newScheduledMeal.scheduledDate.withoutTime())")
            
            if let recipeOnMealPlan = realm.object(ofType: Recipe.self, forPrimaryKey: recipe.id) {
                recipeOnMealPlan.isOnMealPlan = true
            }
        }
    }
}

