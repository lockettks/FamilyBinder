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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        }
    }

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
