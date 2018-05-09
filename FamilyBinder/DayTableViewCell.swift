//
//  DayTableViewCell.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 11/28/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit
import RealmSwift

class DayTableViewCell: UITableViewCell {
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet weak var lblMealType: UILabel!    
    @IBOutlet weak var lblScheduledRecipe: UILabel!
    @IBOutlet weak var lblDayHeading: UILabel!
    @IBOutlet weak var lblDayHeadingBackground: UILabel!
    var scheduledMeal: ScheduledMeal?
    
    
    override func prepareForReuse() {
        for sub in stackView.subviews {
            sub.removeFromSuperview()
        }
    }
    
    func initWithModel(dayHeadline: Date, existingMeals: [ScheduledMeal]?){
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        lblDayHeading.text = dateFormatter.string(from: dayHeadline)
        
        if let stack = stackView {
            if let meals = existingMeals {
                if meals.count > 0 {
                    meals.forEach{existingMeal in
                        let existingMealStackView = createExistingMealStackView(existingMeal: existingMeal)
                        stack.addArrangedSubview(existingMealStackView)
                    }
                }
            }
        }
        
    }
    
    func createExistingMealStackView(existingMeal: ScheduledMeal) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.distribution = .fill
        stack.spacing = 8
        
        if let existingMealName = existingMeal.recipe?.title {
            let mealNameLabel = UILabel()
            mealNameLabel.text = existingMealName
            mealNameLabel.numberOfLines = 0
            mealNameLabel.lineBreakMode = .byWordWrapping
            stack.addArrangedSubview(mealNameLabel)
        }
        
        if let existingMealType = existingMeal.mealType {
            let mealTypeLabel = UILabel()
            mealTypeLabel.textAlignment = NSTextAlignment.right
            mealTypeLabel.text = existingMealType.displayName()
            mealTypeLabel.addConstraint(NSLayoutConstraint(item: mealTypeLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80))
            stack.addArrangedSubview(mealTypeLabel)
        }

        
        return stack
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
