//
//  DateHelper.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/21/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation

extension Date {
    var startOfWeek: Date? {
        return Calendar.gregorian.date(from: Calendar.gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }
    
    func withoutTime() -> String {
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .short
        return myFormatter.string(from:self)
    }
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}
