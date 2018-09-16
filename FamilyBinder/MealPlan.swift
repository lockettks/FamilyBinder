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
    static let sharedInstance = MealPlan()
    
    var meals = List<ScheduledMeal>()
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = "Magical Meal Plan"
    @objc dynamic var startDate: Date?
    @objc dynamic var endDate: Date?
    
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
    
    override static func primaryKey() -> String? {
        return "id"
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
