//
//  User.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 3/4/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import Foundation
import RealmSwift

class User : Object {
    dynamic var userName: String = "Kimpossible"
    var mealPlans = List<MealPlan>()
    
//    convenience init() {
//        self.init()
//        self.userName = "Kimpossible"
//    }
}
