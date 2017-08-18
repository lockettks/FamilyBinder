//
//  MealDatePickerTableViewCell.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/24/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit

class MealDatePickerTableViewCell: UITableViewCell {
    @IBOutlet weak var pickerMealDate: UIDatePicker!
    
    var selectedValue = Date()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func pickerValChanged(_ sender: Any) {
        selectedValue = pickerMealDate.date
    }
    
    public func showPicker(){
        pickerMealDate.isHidden = false
        pickerMealDate.alpha = 0.0
        UIView.animate(withDuration: 0.25){
            self.pickerMealDate.alpha = 1.0
        }
    }
    
    public func hidePicker(){
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerMealDate.alpha = 0.0
        }) { (_) in
            self.pickerMealDate.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
