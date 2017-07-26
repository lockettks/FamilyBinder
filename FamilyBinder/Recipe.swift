//
//  Recipe.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/14/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import SwiftyJSON

class Recipe {
    var id: Int?
    var title: String?
    var analyzedInstructions = [Instruction]()
    var ingredients = [Ingredient]()
    var instructions: String?
    var servings: Int?
    var imageURL: String?
    var image: UIImage?
    
    required init() {
    }
    
//    required init?(json: [String: Any]) {
//        guard let instructions = json["instructions"] as? String,
//            let idValue = json["id"] as? Int,
//            let title = json["title"] as? String,
//            let servings = json["servings"] as? Int,
//            let imageURL = json["image"] as? String
//            else {
//                return nil
//        }
//        self.instructions = instructions
//        self.id = idValue
//        self.title = title
//        self.servings = servings
//        self.imageURL = imageURL
//    }
    
    required init?(json: JSON) {
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
    }
}
