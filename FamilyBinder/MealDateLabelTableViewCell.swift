//
//  ScheduledDateLabelTableViewCell.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/24/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit

class MealDateLabelTableViewCell: UITableViewCell {
    @IBOutlet weak var lblMealDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    public func configure(newText: String) {
        lblMealDate.text = newText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
