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
//    @IBOutlet weak var lblIngredientsConstraint: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
//    override func loadView() {
//        super.loadView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//    }
    
//    override func viewDidLayoutSubviews() {
//        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//    }
    
    func updateView(currentRecipe: Recipe){
        let stringHelper = StringHelper()
        if let label = self.ingredientsLbl {
            let attributesDictionary = [NSFontAttributeName : label.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
            for ingredient in (currentRecipe.ingredients) where ingredient.originalString != "" {
                fullAttributedString.append(stringHelper.convertToBulletedItem(textToConvert: ingredient.originalString))
            }
            label.attributedText = fullAttributedString
            
//            print("ingredients view height before layout \(view.frame.size.height)")
//            print("ingredientsLbl height before layout \(ingredientsLbl.frame.size.height)")
            
            let newIngredientsLblSize = ingredientsLbl.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//            lblIngredientsConstraint.constant = newIngredientsLblSize
            
            view.frame.size.height = newIngredientsLblSize.height + 50
            print("label size: \(newIngredientsLblSize.height)")
            print("ingredients view height \(view.frame.size.height)")
//            ingredientsLbl.frame.size.height = newIngredientsLblSize
            
            
//            print("ingredientsLbl height after layout \(ingredientsLbl.frame.size.height)")
        }
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
