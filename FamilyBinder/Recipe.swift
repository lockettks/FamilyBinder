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
    var analyzedInstructions = List<Instruction>()
    var ingredients = List<Ingredient>()
    dynamic var instructions: String = ""
    dynamic var servings: Int = 0
    dynamic var imageURL: String = ""
    var image: UIImage?
    dynamic var isFavorite: Bool = false
    var dishTypes = List<RealmString>()
    
    
    convenience init?(json: JSON) {
        self.init()
        guard let instructions = json["instructions"].string,
            let idValue = json["id"].int,
            let title = json["title"].string,
            let servings = json["servings"].int,
            let imageURL = json["image"].string,
            let instructionsJSONArray = json["analyzedInstructions"][0]["steps"].array,
            let ingredientsJSONArray = json["extendedIngredients"].array,
            let dishTypesJSONArray = json["dishTypes"].array
            else {
                return nil
        }
        self.instructions = instructions
        self.id = idValue
        self.title = title
        self.servings = servings
        self.imageURL = imageURL
        for instructionJSON in instructionsJSONArray {
            if let instruction = Instruction(json: instructionJSON) {
                analyzedInstructions.append(instruction)
            }
        }
        for ingredientJSON in ingredientsJSONArray {
            if let ingredient = Ingredient(json: ingredientJSON) {
                ingredients.append(ingredient)
            }
        }
        for dishTypesJSON in dishTypesJSONArray {
            if let dishTypeString = dishTypesJSON.string {
                if let dishType = RealmString(theString: dishTypeString) {
                    dishTypes.append(dishType)
                }
            }
        }
    }
    
    convenience init(id: Int, title: String, analyzedInstructions: List<Instruction>, ingredients: List<Ingredient>, instructions: String, servings: Int, imageURL: String, image: UIImage?, isFavorite: Bool, dishTypes: List<RealmString>) {
        self.init()
        self.id = id
        self.title = title
        self.analyzedInstructions = analyzedInstructions
        self.ingredients = ingredients
        self.instructions = instructions
        self.servings = servings
        self.imageURL = imageURL
        self.image = image
        self.isFavorite = isFavorite
        self.dishTypes = dishTypes
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image"]
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Recipe(id: id, title: title, analyzedInstructions: analyzedInstructions, ingredients: ingredients, instructions: instructions, servings: servings, imageURL: imageURL, image: image, isFavorite: isFavorite, dishTypes: dishTypes)
    }
}
