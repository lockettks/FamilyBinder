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
    
    private var currentDirections = [Direction()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureView() {
        let stringHelper = StringHelper()
        if let label = directionsLbl {
            let attributesDictionary = [NSAttributedStringKey.font : label.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [NSAttributedStringKey : Any]))
            for direction in currentDirections {
                fullAttributedString.append(stringHelper.convertToNumberedItem(textToConvert: direction.step, textNumber: direction.stepNumber.description))
            }
            label.attributedText = fullAttributedString
        }
    }

    func setDirections(directions: [Direction]){
        self.currentDirections = directions
    }
    func removeDirections(){
        self.currentDirections = [Direction]()
    }
}
