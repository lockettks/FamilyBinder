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
    
    private var currentRecipe = Recipe()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureView(){
        let stringHelper = StringHelper()
        if let label = self.ingredientsLbl {
            let attributesDictionary = [NSFontAttributeName : label.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
            for ingredient in (currentRecipe.ingredients) where ingredient.originalString != "" {
                fullAttributedString.append(stringHelper.convertToBulletedItem(textToConvert: ingredient.originalString))
            }
            label.attributedText = fullAttributedString
            
//            let newIngredientsLblSize = ingredientsLbl.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//            ingredientsLbl.frame.size.height = newIngredientsLblSize.height
//            ingredientsLblConstraint.constant = newIngredientsLblSize.height
//            view.frame.size.height = newIngredientsLblSize.height + 56
        }
        
        if let img = self.recipeImgBackground {
            let placeholderImage = #imageLiteral(resourceName: "dinnerPlate")
            if let url = URL(string: currentRecipe.imageURL) {
                img.af_setImage(withURL: url, placeholderImage: placeholderImage)
                //detail.image = img.image
            }
        }
   
    }
    
    // MARK: Functions
    
    func setCurrentRecipe(newRecipe: Recipe){
        self.currentRecipe = newRecipe
    }
}
