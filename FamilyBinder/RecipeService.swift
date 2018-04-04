//
//  RecipeService.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 4/3/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import Foundation
import RealmSwift

class RecipeService {
    
    let realm = try! Realm()
    
    func isFavoriteInRealm(recipe: Recipe) -> Bool {
        return (realm.object(ofType: Recipe.self, forPrimaryKey: recipe.id) != nil)
    }
    
    func isOnMealPlanInFutureInRealm(recipe: Recipe)-> Bool {
        let instancesOnMealPlan = realm
            .objects(ScheduledMeal.self)
            .filter("recipe.id == %@", recipe.id)
        let currentInstancesOnMealPlan = instancesOnMealPlan.filter("scheduledDate >= %@", Date())
        return currentInstancesOnMealPlan.count > 0
    }
    
//    func getMealPlansForRecipe(recipe: Recipe) -> [MealPlan] {
//        
//    }
    
    
}
