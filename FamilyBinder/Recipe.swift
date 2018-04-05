//
//  Recipe.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/14/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Recipe : Object, NSCopying {
    dynamic var id: Int = 0
    dynamic var title: String = ""
    var analyzedDirections = List<Direction>()
    var ingredients = List<Ingredient>()
    dynamic var directions: String = ""
    dynamic var servings: Int = 0
    dynamic var imageURL: String = ""
    var image: UIImage?
    dynamic var isFavorite: Bool = false
    var dishTypes = List<RealmString>()
    dynamic var readyInMinutes: Int = 0
    dynamic var likes: Int = 0
    dynamic var spoonacularScore: Int = 0
    dynamic var creditText: String = ""
    
    convenience init?(json: JSON) {
        self.init()
        guard let instructions = json["instructions"].string,
            let idValue = json["id"].int,
            let title = json["title"].string,
            let servings = json["servings"].int,
            let imageURL = json["image"].string,
            let instructionsJSONArray = json["analyzedInstructions"][0]["steps"].array,
            let ingredientsJSONArray = json["extendedIngredients"].array,
            let dishTypesJSONArray = json["dishTypes"].array,
            let readyInMinutes = json["readyInMinutes"].int,
            let likes = json["aggregateLikes"].int,
            let spoonacularScore = json["spoonacularScore"].int,
            let creditText = json["creditText"].string
            else {
                return nil
        }
        self.directions = instructions
        self.id = idValue
        self.title = title
        self.servings = servings
        self.imageURL = imageURL
        for instructionJSON in instructionsJSONArray {
            if let direction = Direction(json: instructionJSON) {
                if (!direction.step.isNumber) && (direction.step != "Watch how to make this recipe." ) {
                    analyzedDirections.append(direction)
                }
            }
        }
        for ingredientJSON in ingredientsJSONArray {
            if let ingredient = Ingredient(json: ingredientJSON) {
                if (!ingredient.originalString.hasPrefix("-") ) {
                    ingredients.append(ingredient)
                }
            }
        }
        for dishTypesJSON in dishTypesJSONArray {
            if let dishTypeString = dishTypesJSON.string {
                if let dishType = RealmString(theString: dishTypeString) {
                    dishTypes.append(dishType)
                }
            }
        }
        self.readyInMinutes = readyInMinutes
        self.likes = likes
        self.spoonacularScore = spoonacularScore
        self.creditText = creditText
    }
    
    convenience init(id: Int, title: String, analyzedDirections: List<Direction>, ingredients: List<Ingredient>, directions: String, servings: Int, imageURL: String, image: UIImage?, isFavorite: Bool, dishTypes: List<RealmString>, readyInMinutes: Int, likes: Int, spoonacularScore: Int, creditText: String) {
        self.init()
        self.id = id
        self.title = title
        self.analyzedDirections = analyzedDirections
        self.ingredients = ingredients
        self.directions = directions
        self.servings = servings
        self.imageURL = imageURL
        self.image = image
        self.isFavorite = isFavorite
        self.dishTypes = dishTypes
        self.readyInMinutes = readyInMinutes
        self.likes = likes
        self.spoonacularScore = spoonacularScore
        self.creditText = creditText
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image"]
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Recipe(id: id, title: title, analyzedDirections: analyzedDirections, ingredients: ingredients, directions: directions, servings: servings, imageURL: imageURL, image: image, isFavorite: isFavorite, dishTypes: dishTypes, readyInMinutes: readyInMinutes, likes: likes, spoonacularScore: spoonacularScore, creditText: creditText)
    }
}
