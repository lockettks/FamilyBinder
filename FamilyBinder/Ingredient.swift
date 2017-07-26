//
//  Ingredient.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/26/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import SwiftyJSON

class Ingredient {
    var originalString: String?
    
    required init?(json: JSON){
        guard let originalString = json["originalString"].string else {
            return nil
        }
        self.originalString = originalString
    }
}
