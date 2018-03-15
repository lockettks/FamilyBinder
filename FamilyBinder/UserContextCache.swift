//
//  UserContextCache.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/31/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class UserContextCache: Object {
    var myRecipes = List<Recipe>() //TODO:  do i need this?

 
    static func current() -> UserContextCache {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.userContextCache == nil {
            appDelegate.userContextCache = UserContextCache()
        }
        return appDelegate.userContextCache!
    }
}
