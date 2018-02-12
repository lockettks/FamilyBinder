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
    @IBOutlet weak var lblDayHeading: UILabel!
    @IBOutlet weak var lblDayHeadingBackground: UILabel!
    
    func initWithModel(dayHeadline: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        lblDayHeading.text = dateFormatter.string(from: dayHeadline)
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
