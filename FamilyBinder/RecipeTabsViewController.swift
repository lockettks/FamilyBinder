//
//  RecipeTabsViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 10/11/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import UIKit


protocol TabToggledDelegate: class {
    func didSelectTab()
}

class RecipeTabsViewController: UIViewController {

    @IBOutlet weak var ingredientsBtn: UIButton!
    @IBOutlet weak var directionsBtn: UIButton!
    weak var tabToggledDelegate: TabToggledDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureView(currentRecipe: Recipe){
//        let stringHelper = StringHelper()
//        if let label = self.ingredientsLbl {
//            let attributesDictionary = [NSFontAttributeName : label.font]
//            let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
//            for ingredient in (currentRecipe.ingredients) where ingredient.originalString != "" {
//                fullAttributedString.append(stringHelper.convertToBulletedItem(textToConvert: ingredient.originalString))
//            }
//            label.attributedText = fullAttributedString
//
//            let newIngredientsLblSize = ingredientsLbl.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//
//            view.frame.size.height = newIngredientsLblSize.height + 56
//        }
        
        ingredientsBtn.setBackgroundColor(color: UIColor(hex: "DAE0E1"), forState: .normal)
        ingredientsBtn.setBackgroundColor(color: UIColor(hex: "C1212E"), forState: .selected)
        ingredientsBtn.isSelected = true
        
        directionsBtn.setBackgroundColor(color: UIColor(hex: "DAE0E1"), forState: .normal)
        directionsBtn.setBackgroundColor(color: UIColor(hex: "C1212E"), forState: .selected)
        directionsBtn.isSelected = false
        
    }
    
    
    @IBAction func detailTabPressed(_ sender: UIButton) {
        tabToggledDelegate?.didSelectTab()
//        switch sender.tag {
//        case DetailTabs.ingredients.rawValue:
//            ingredientsTab.isSelected = true
//            directionsTab.isSelected = false
//        case DetailTabs.directions.rawValue:
//            ingredientsTab.isSelected = false
//            directionsTab.isSelected = true
//        default:
//            break
//        }
//
//        toggleDetailsPanels()
//        updateHeights()
    }
    
}
