//
//  CalendarDayCollectionViewCell.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 11/25/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit

class CalendarDayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblWeekday: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    func initWithModel(day: Date){
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEE"
        let weekday = weekdayFormatter.string(from: day)
        lblWeekday.text = weekday
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let date = dateFormatter.string(from: day)
        lblDate.text = date
    }
    

    
}
