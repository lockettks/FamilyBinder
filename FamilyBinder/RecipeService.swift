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
    
    func isFavorite(recipe: Recipe) -> Bool {
        var isFavorite = false
        if let savedRecipe = realm.object(ofType: Recipe.self, forPrimaryKey: recipe.id) {
            isFavorite = savedRecipe.isFavorite
        }
        return (isFavorite)
    }
    
    func addToFavorites(recipe: Recipe) {
        // Create or update recipe as favorite
        let newRecipe = recipe.copy() as! Recipe
        newRecipe.isFavorite = true
        try! realm.write {
            realm.add(newRecipe, update: true)
        }
        print("Recipe \(newRecipe.title) is a favorite")
    }
    
    func removeFromFavorites(recipe: Recipe) {
        // If recipe is on a meal plan in the future set isFavorite to false
        if isOnMealPlanInFuture(recipe: recipe) {
            if let notFavoriteRecipe = realm.object(ofType: Recipe.self, forPrimaryKey: recipe.id) {
                try! self.realm.write {
                    notFavoriteRecipe.isFavorite = false
                }
            }
        }
            // Otherwise remove it if it was saved
        else {
            deleteRecipe(recipe: recipe)
        }
    }
    
    private func deleteRecipe(recipe: Recipe) {
        if let recipeToDelete = realm.object(ofType: Recipe.self, forPrimaryKey: recipe.id) {
            try! self.realm.write {
                self.realm.delete(recipeToDelete.analyzedDirections)
                self.realm.delete(recipeToDelete.ingredients)
                self.realm.delete(recipeToDelete)
            }
            print("Recipe \(recipeToDelete.title) has been deleted")
        } else {
            print("Recipe \(recipe.title) was not stored as a favorite")
        }
    }
    
    
    func isOnMealPlanInFuture(recipe: Recipe)-> Bool {
        let instancesOnMealPlan = realm
            .objects(ScheduledMeal.self)
            .filter("recipe.id == %@", recipe.id)
        let currentInstancesOnMealPlan = instancesOnMealPlan.filter("scheduledDate >= %@", Date())
        return currentInstancesOnMealPlan.count > 0
    }
    
}
