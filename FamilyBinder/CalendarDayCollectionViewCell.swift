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
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                UIView.animate(withDuration: 0.25, animations: {
                    self.lblWeekday.textColor = UIColor.white
                    self.lblDate.textColor = UIColor.white
                    self.lblWeekday.font = self.lblWeekday.font.withSize(19)
                    self.lblDate.font = self.lblWeekday.font.withSize(22)
                    self.backgroundColor = UIColor(hex: "C1212E")
                })
            }
            else
            {
                UIView.animate(withDuration: 0.25, animations: {
                    self.lblWeekday.textColor = UIColor.black
                    self.lblDate.textColor = UIColor.black
                    self.lblWeekday.font = self.lblWeekday.font.withSize(16)
                    self.lblDate.font = self.lblWeekday.font.withSize(17)
                    self.backgroundColor = UIColor.clear
                })
            }
        }
    }
    
    func selectCell(){
        self.isSelected = true
    }
    
    func deselectCell(){
        self.isSelected = false
    }

    
    func initWithModel(day: Date){
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.timeZone = TimeZone.current
        weekdayFormatter.dateFormat = "EEE"
        let weekday = weekdayFormatter.string(from: day)
        let test = Date()
        print(weekdayFormatter.string(from: test))
        lblWeekday.text = weekday
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d"
        let date = dateFormatter.string(from: day)
        print(dateFormatter.string(from: test))
        lblDate.text = date
        
    }
}
