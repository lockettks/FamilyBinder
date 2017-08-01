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

class Recipe : Object {
    dynamic var id: Int = 0
    dynamic var title: String = ""
    var analyzedInstructions = List<Instruction>()
    var ingredients = List<Ingredient>()
    dynamic var instructions: String = ""
    dynamic var servings: Int = 0
    dynamic var imageURL: String = ""
    var image: UIImage?
    dynamic var isFavorite: Bool = false
    
    
    convenience init?(json: JSON) {
        self.init()
        guard let instructions = json["instructions"].string,
            let idValue = json["id"].int,
            let title = json["title"].string,
            let servings = json["servings"].int,
            let imageURL = json["image"].string,
        let instructionsJSONArray = json["analyzedInstructions"][0]["steps"].array,
        let ingredientsJSONArray = json["extendedIngredients"].array
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
        
        self.isFavorite = UserContextCache.current().myRecipes.first(where: { $0.id == idValue}) != nil

    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image"]
    }
}
