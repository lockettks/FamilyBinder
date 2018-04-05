//
//  IngredientsViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 9/19/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController {
    @IBOutlet weak var ingredientsLbl: UILabel!
    
    private var ingredients = [Ingredient()]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureView(){
        let stringHelper = StringHelper()
        if let label = self.ingredientsLbl {
            let attributesDictionary = [NSAttributedStringKey.font : label.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [NSAttributedStringKey : Any]))
            for ingredient in (ingredients) where ingredient.originalString != "" {
                fullAttributedString.append(stringHelper.convertToBulletedItem(textToConvert: ingredient.originalString))
            }
            label.attributedText = fullAttributedString
        }
   
    }
    func setIngredients(ingredients: [Ingredient]){
        self.ingredients = ingredients
    }
    
    func removeIngredients(){
        self.ingredients = [Ingredient]()
    }

}

