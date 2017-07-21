//
//  DateHelper.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/21/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation

extension Date {
    func withoutTime() -> String {
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .short
        return myFormatter.string(from:self)
    }
}
