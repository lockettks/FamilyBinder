//
//  Instruction.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/26/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Instruction : Object {
    dynamic var stepNumber: Int = 0
    dynamic var step: String = ""
    
    convenience init?(json: JSON) {
        self.init()
        guard let stepNumber = json["number"].int,
        let step = json["step"].string
            else {
                return nil
        }
        self.stepNumber = stepNumber
        self.step = step
    }

}
