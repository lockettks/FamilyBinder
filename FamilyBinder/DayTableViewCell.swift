//
//  DayTableViewCell.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 11/28/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMealType: UILabel!    
    @IBOutlet weak var lblScheduledRecipeCat: UILabel!
    @IBOutlet weak var lblScheduledRecipeUncat: UILabel!
    
    func initWithModel(model: Recipe){
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
