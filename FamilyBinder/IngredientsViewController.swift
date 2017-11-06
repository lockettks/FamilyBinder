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
    @IBOutlet weak var recipeImgBackground: UIImageView!
    @IBOutlet weak var ingredientsLblConstraint: NSLayoutConstraint!
    
    private var ingredients = [Ingredient()]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureView(){
        let stringHelper = StringHelper()
        if let label = self.ingredientsLbl {
            let attributesDictionary = [NSFontAttributeName : label.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
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

