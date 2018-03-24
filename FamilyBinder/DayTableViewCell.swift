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
    @IBOutlet weak var lblScheduledRecipe: UILabel!
    @IBOutlet weak var lblDayHeading: UILabel!
    @IBOutlet weak var lblDayHeadingBackground: UILabel!
    var scheduledMeal: ScheduledMeal?
    
    func displayExistingMeal(location: CGRect, textToDisplay: String) -> UILabel {
        let existingMealLabel = UILabel(frame: location)
        existingMealLabel.center = CGPoint(x: 160, y: 285)
        existingMealLabel.textAlignment = .left
        existingMealLabel.text = textToDisplay
        return existingMealLabel
    }
    
    func initWithModel(dayHeadline: Date, existingMeals: [ScheduledMeal]){
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        lblDayHeading.text = dateFormatter.string(from: dayHeadline)
        existingMeals.forEach{existingMeal in
            if let existingMealType = existingMeal.mealType {
                let mealTypeLabel = displayExistingMeal(location: CGRect(x: 0, y: 0, width: 200, height: 21), textToDisplay: existingMealType.displayName())
                self.addSubview(mealTypeLabel)
                if let existingMealName = existingMeal.recipe?.title {
                    let mealNameLabel = displayExistingMeal(location: CGRect(x: 0, y: 0, width: 200, height: 21), textToDisplay: existingMealName)
                    self.addSubview(mealNameLabel)
                }
            } else {
                if let existingMealName = existingMeal.recipe?.title {
                    let mealNameLabel = displayExistingMeal(location: CGRect(x: 0, y: 0, width: 200, height: 21), textToDisplay: existingMealName)
                    self.addSubview(mealNameLabel)
                }
            }
        }
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
