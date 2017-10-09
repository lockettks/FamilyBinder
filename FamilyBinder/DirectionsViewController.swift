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
    
    func updateView(currentRecipe: Recipe) {
        let stringHelper = StringHelper()
        if let label = directionsLbl {
            let attributesDictionary = [NSFontAttributeName : label.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
            for instruction in currentRecipe.analyzedInstructions {
                fullAttributedString.append(stringHelper.convertToNumberedItem(textToConvert: instruction.step, textNumber: instruction.stepNumber.description))
            }
            
            label.text = fullAttributedString.string
            
            let newDirectionsLblSize = directionsLbl.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            print("label size: \(newDirectionsLblSize.height)")
            view.frame.size.height = newDirectionsLblSize.height + 50
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
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
