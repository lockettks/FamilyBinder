//
//  MealPlan.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/20/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import RealmSwift

class MealPlan : Object {
    //TODO:  This is not a singleton, but a user can have multiple meal plans with start/end dates.
    // need to update the model so that a user can have multiple meal plans with unique id's of start/end dates
    // they can name the meal plan, rate it, see if they've made it before, share it, see if it trends
    static let sharedInstance = MealPlan()
    
    var meals = List<ScheduledMeal>()
    dynamic var name = "Magical Meal Plan"
    dynamic var startDate: Date?
    dynamic var endDate: Date?
    
    convenience init(newName: String?, startDate: Date?, endDate: Date?) {
        self.init()
        if let usersSuppliedName = newName {
            self.name = usersSuppliedName
        }
        
        if let newStartDate = startDate {
            self.startDate = newStartDate
        }
        
        if let newEndDate = endDate {
            self.endDate = newEndDate
        }
    }
    
    func addToMealPlan(mealToAdd : ScheduledMeal?) {
        if let newMeal = mealToAdd {
            meals.append(newMeal)
        }
    }
    
    func updateName(newName: String) {
        self.name = newName
    }
    
    func updateStartDate(newStartDate: Date) {
        self.startDate = newStartDate
    }
    
    func updateEndDate(newEndDate: Date) {
        self.endDate = newEndDate
    }
}
