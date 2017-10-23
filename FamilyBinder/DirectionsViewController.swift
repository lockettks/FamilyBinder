//
//  DirectionsViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 9/19/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit

class DirectionsViewController: UIViewController {

    @IBOutlet weak var directionsLbl: UILabel!
    @IBOutlet weak var recipeImgBackground: UIImageView!
    
    private var currentRecipe = Recipe()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureView() {
        let stringHelper = StringHelper()
        if let label = directionsLbl {
            let attributesDictionary = [NSFontAttributeName : label.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
            for instruction in currentRecipe.analyzedInstructions {
                fullAttributedString.append(stringHelper.convertToNumberedItem(textToConvert: instruction.step, textNumber: instruction.stepNumber.description))
            }
//            label.attributedText = fullAttributedString
            label.text = "Test"
            
            let newDirectionsLblSize = directionsLbl.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            print("newDirectionsLblSize \(newDirectionsLblSize.height)")
            print("directions view.frame.size.height \(view.frame.size.height)\n")
            
            //directionsLbl.frame.size.height = newDirectionsLblSize.height
        }
    }
    
    override func viewDidLayoutSubviews() {
//        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//        view.frame.size.height = preferredContentSize.height
    }
    

    // MARK: Functions
    
    func setCurrentRecipe(newRecipe: Recipe){
        self.currentRecipe = newRecipe
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
