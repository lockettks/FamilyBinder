//
//  Instruction.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/26/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import SwiftyJSON

class Instruction {
    var stepNumber: Int?
    var step: String?
    
    required init?(json: JSON) {
        guard let stepNumber = json["number"].int,
        let step = json["step"].string
            else {
                return nil
        }
        self.stepNumber = stepNumber
        self.step = step
    }
}
