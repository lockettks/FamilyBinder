//
//  Ingredient.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/26/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Ingredient : Object {
    @objc dynamic var originalString: String = ""
    let recipes = LinkingObjects(fromType: Recipe.self, property: "ingredients")
    
    convenience init?(json: JSON){
        self.init()
        guard let originalString = json["originalString"].string else {
            return nil
        }
        self.originalString = originalString
    }
}
