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
    @IBOutlet weak var lblIngredientsConstraint: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func loadView() {
        super.loadView()
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLayoutSubviews() {
//        print("ingredients view height before \(view.frame.size.height)")
//        print("ingredientsLbl height before \(ingredientsLbl.frame.size.height)")
        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//        let test = ingredientsLbl.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//        ingredientsLbl.setNeedsLayout()
//        ingredientsLbl.layoutIfNeeded()
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
//        print("ingredients view after \(view.frame.size.height)")
//        print("ingredientsLbl height after \(ingredientsLbl.frame.size.height)")
    }
    
    func updateView(currentRecipe: Recipe){
        let stringHelper = StringHelper()
        if let label = self.ingredientsLbl {
            let attributesDictionary = [NSFontAttributeName : label.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
            for ingredient in (currentRecipe.ingredients) where ingredient.originalString != "" {
                fullAttributedString.append(stringHelper.convertToBulletedItem(textToConvert: ingredient.originalString))
            }
            label.attributedText = fullAttributedString
            
            print("ingredients view height before layout \(view.frame.size.height)")
            print("ingredientsLbl height before layout \(ingredientsLbl.frame.size.height)")
            
//            preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            let newSize = ingredientsLbl.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            lblIngredientsConstraint.constant = newSize.height
            view.frame.size.height = newSize.height + 40
            ingredientsLbl.frame.size.height = newSize.height
            
            print("ingredients view height after layout \(view.frame.size.height)")
            print("ingredientsLbl height after layout \(ingredientsLbl.frame.size.height)")
            
//            ingredientsLbl.setNeedsDisplay()
//            ingredientsLbl.layoutIfNeeded()
//            view.setNeedsDisplay()
//            view.layoutIfNeeded()
//            view.layoutSubviews()
            
//            ingredientsLbl.sizeToFit()
//            view.sizeToFit()
        }


        
    }
    
//    override func updateViewConstraints() {
//        let newSize = ingredientsLbl.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//        lblIngredientsConstraint.constant = newSize.height
//        view.frame.size.height = newSize.height + 40
//        ingredientsLbl.frame.size.height = newSize.height
//
//        super.updateViewConstraints()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
