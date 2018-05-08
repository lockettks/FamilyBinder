//
//  MealTypes.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/20/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation

enum MealType: String {
    case breakfast
    case lunch
    case snack
    case dinner
    static let allTypes = [breakfast, lunch, snack, dinner]
    
    func displayName() -> String {
        switch self {
        case .breakfast:
            return "Breakfast"
        case .lunch:
            return "Lunch"
        case .snack:
            return "Snack"
        case .dinner:
            return "Dinner"
        }
    }
    
    func sortOrder() -> Int {
        switch self {
        case .breakfast:
            return 0
        case .lunch:
            return 1
        case .snack:
            return 2
        case .dinner:
            return 3
        }
    }
}
