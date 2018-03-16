//
//  MealPlanSelectedTableViewCell.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 3/14/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import UIKit

class MealPlanSelectedTableViewCell: UITableViewCell {
    @IBOutlet var lblSelectedMealPlan: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initWithModel(selectedMealPlan: MealPlan){
        lblSelectedMealPlan.text = selectedMealPlan.name
    }
    
    

}
