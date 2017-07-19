//
//  SpoonacularAPIManager.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/14/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

enum SpoonacularAPIManagerError: Error {
    case network(error: Error)
    case apiProvidedError(reason: String)
    case authCouldNot(reason: String)
    case authLost(reason: String)
    case objectSerialization(reason: String)
}

class SpoonacularAPIManager {
    static let sharedInstance = SpoonacularAPIManager()
    
    
    // MARK: Get Random Recipes
    func printRandomRecipes(numberOfRecipes: Int) -> Void {
        let request = Alamofire.request(RecipeRouter.getRandomRecipes(numberOfRecipes))
            .responseString { response in
                guard response.result.error == nil else {
                    print("error")
                    print(response.result.error!)
                    return
                }
                if let receivedString = response.result.value {
                    print(receivedString)
                }
        }
        debugPrint("Print Random Recipes: \(request)")
    }
    
    func fetchRandomRecipes(numberOfRecipes: Int) -> Promise<[Recipe]> {
        return Promise { fulfill, reject in
            let request = Alamofire.request(RecipeRouter.getRandomRecipes(numberOfRecipes)).validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("JSON: \(json)")
                        if let recipesJSONArray = json["recipes"].array {
                            var recipes = [Recipe]()
                            for recipeJSON in recipesJSONArray {
                                if let recipe = Recipe(json: recipeJSON) {
                                    recipes.append(recipe)
                                }
                            }
                            fulfill(recipes)
                        } else {
                            reject((response.error!))
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
            }
            debugPrint("Fetch Random Recipes: \(request)")
        }
    }
    
//    private func randomRecipeArrayFromResponse(response: DataResponse<Any>) -> Result<[Recipe]> {
//        guard response.result.error == nil else {
//            print(response.result.error!)
//            return .failure(SpoonacularAPIManagerError.network(error: response.result.error!))
//        }
//        
//        // make sure we got JSON
//        guard let jsonDictionary = response.result.value as? [String: Any] else {
//            return .failure(SpoonacularAPIManagerError.objectSerialization(reason: "Did not get JSON object in response"))
//        }
//        
//        // check for "message" errors in the JSON because this API does that
//        if let errorMessage = jsonDictionary["message"] as? String {
//            return .failure(SpoonacularAPIManagerError.apiProvidedError(reason: errorMessage))
//        }
//        
//        // make sure the recipe object was in the response
//        guard let recipesArray = jsonDictionary["recipes"] as? [[String: Any]] else {
//            return .failure(SpoonacularAPIManagerError.objectSerialization(reason: "Did not get recipe object in response"))
//        }
//        
//        
//        // turn JSON into recipes
//        var recipes = [Recipe]()
//        for item in recipesArray {
//            if let recipe = Recipe(json: item) {
//                recipes.append(recipe)
//            }
//        }
//        return .success(recipes)
//    }
}
