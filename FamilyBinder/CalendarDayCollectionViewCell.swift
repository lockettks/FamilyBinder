//
//  CalendarDayCollectionViewCell.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 11/25/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit


class CalendarDayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblDate: UILabel!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                UIView.animate(withDuration: 0.25, animations: {
                    self.lblDate.textColor = UIColor.white
                    self.lblDate.font = self.lblDate.font.withSize(22)
                    self.backgroundColor = UIColor(hex: "C1212E")
                })
            }
            else
            {
                UIView.animate(withDuration: 0.25, animations: {
                    self.lblDate.textColor = UIColor.black
                    self.lblDate.font = self.lblDate.font.withSize(17)
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d"
        let date = dateFormatter.string(from: day)
        lblDate.text = date
        let today = NSCalendar.current.startOfDay(for: Date())
        if (NSCalendar.current.startOfDay(for: day) < today) {
            lblDate.textColor = UIColor(hex: "C0C0C0")
        } else if (NSCalendar.current.startOfDay(for: day) == today) {
            lblDate.font = lblDate.font.bold()
            lblDate.textColor = UIColor.black
        } else {
            lblDate.font = lblDate.font.noBold()
            lblDate.textColor = UIColor.black
        }
    }
}
