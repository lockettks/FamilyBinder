//
//  RealmString.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 9/18/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class RealmString : Object {
    dynamic var theString: String = ""
    
    convenience init?(theString: String) {
        self.init()
        self.theString = theString
    }
}
