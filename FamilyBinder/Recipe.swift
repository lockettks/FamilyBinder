//
//  Recipe.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/14/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation

class Recipe {
    var id: Int?
    var title: String?
    var instructions: String?
    var servings: Int?
    
    required init() {
    }
    
    required init?(json: [String: Any]) {
        guard let instructions = json["instructions"] as? String,
            let idValue = json["id"] as? Int,
            let title = json["title"] as? String,
        let servings = json["servings"] as? Int else {
                return nil
        }
        self.instructions = instructions
        self.id = idValue
        self.title = title
        self.servings = servings
    }
}
