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
               // self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    self.lblWeekday.textColor = UIColor.white
                    self.lblWeekday.font = self.lblWeekday.font.withSize(19)
                    self.lblDate.textColor = UIColor.white
                    self.backgroundColor = UIColor(hex: "C1212E")
                })
            }
            else
            {
                UIView.animate(withDuration: 0.25, animations: {
                    self.transform = CGAffineTransform.identity
                    self.lblWeekday.textColor = UIColor.black
                    self.lblWeekday.font = self.lblWeekday.font.withSize(17)
                    self.lblDate.textColor = UIColor.black
                    self.backgroundColor = UIColor.clear
                })
            }
        }
    }

    
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
