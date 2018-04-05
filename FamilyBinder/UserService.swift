//
//  UserService.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 4/5/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import Foundation
import RealmSwift

class UserService {
    let realm = try! Realm()
    
    func getFavoriteRecipes() -> [Recipe] {
        let favoriteRecipes = realm
            .objects(Recipe.self)
            .filter("isFavorite == true")
        return Array(favoriteRecipes)
    }
    
}
