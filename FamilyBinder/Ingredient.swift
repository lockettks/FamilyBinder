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
    dynamic var originalString: String = ""
    
    convenience init?(json: JSON){
        self.init()
        guard let originalString = json["originalString"].string else {
            return nil
        }
        self.originalString = originalString
    }
}
