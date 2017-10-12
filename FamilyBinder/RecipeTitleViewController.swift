//
//  RecipeTitleViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 10/11/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import UIKit

class RecipeTitleViewController: UIViewController {
    @IBOutlet weak var ingredientsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureView(currentRecipe: Recipe){
        let stringHelper = StringHelper()
        if let label = self.ingredientsLbl {
            let attributesDictionary = [NSFontAttributeName : label.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
            for ingredient in (currentRecipe.ingredients) where ingredient.originalString != "" {
                fullAttributedString.append(stringHelper.convertToBulletedItem(textToConvert: ingredient.originalString))
            }
            label.attributedText = fullAttributedString
            
            let newIngredientsLblSize = ingredientsLbl.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            
            view.frame.size.height = newIngredientsLblSize.height + 56
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
