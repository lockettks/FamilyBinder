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
    
    //    func displayExistingMeal(location: CGRect, textToDisplay: String) -> UILabel {
    //        let existingMealLabel = UILabel(frame: location)
    //        existingMealLabel.center = CGPoint(x: 160, y: 285)
    //        existingMealLabel.textAlignment = .left
    //        existingMealLabel.text = textToDisplay
    //        return existingMealLabel
    //    }
    
    //    func initWithModel(dayHeadline: Date){
    func initWithModel(dayHeadline: Date, existingMeals: [ScheduledMeal]?){
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        lblDayHeading.text = dateFormatter.string(from: dayHeadline)
        
        if let stack = stackView {
        let index = stack.arrangedSubviews.count > 0 ? (stack.arrangedSubviews.count) - 1 : 0
//        let addView = stack.arrangedSubviews[index]
        
        if let meals = existingMeals {
            if meals.count > 0 {
                meals.forEach{existingMeal in
                    let existingMealLabel = createExistingMealLabel(existingMeal: existingMeal)
                    stack.insertArrangedSubview(existingMealLabel, at: index)
                }
            }
        }
        }
        
    }
    
    func createExistingMealLabel(existingMeal: ScheduledMeal) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.distribution = .fill
        stack.spacing = 8
        
        if let existingMealType = existingMeal.mealType {
            let mealTypeLabel = UILabel()
            mealTypeLabel.text = existingMealType.displayName()
            stack.addArrangedSubview(mealTypeLabel)
        }
        if let existingMealName = existingMeal.recipe?.title {
            let mealNameLabel = UILabel()
            mealNameLabel.text = existingMealName
            stack.addArrangedSubview(mealNameLabel)
        }
        
        return stack
    }
    
    //    func addExistingMealLabel(){
    //        let stack = stackView
    //        let index = (stack?.arrangedSubviews.count)! - 1
    //        let addView = stack?.arrangedSubviews[index]
    //
    //        let newView = createExistingMealLabel()
    //        newView.isHidden = true
    //        stack?.insertArrangedSubview(newView, at: index)
    //    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
