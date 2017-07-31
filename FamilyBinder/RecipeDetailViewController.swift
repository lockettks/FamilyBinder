//
//  RecipeDetailViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/14/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit
import RealmSwift

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    var scrollViewPropertiesInitialized = false
    
    // MARK: - View Manipulation
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        if let detail = self.detailItem {
            
            // Format ingredients
            var attributesDictionary = [NSFontAttributeName : self.ingredientsLabel.font]
            var fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
            for ingredient in (detail.ingredients) {
                if let oString = ingredient.originalString {
                    fullAttributedString.append(convertToBulletedItem(textToConvert: oString))
                }
            }
            ingredientsLabel.attributedText = fullAttributedString
            
            // Format instructions
            attributesDictionary = [NSFontAttributeName : self.instructionsLabel.font]
            fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
            detail.analyzedInstructions.sort { $0.stepNumber! < $1.stepNumber!}
            for instruction in detail.analyzedInstructions {
                fullAttributedString.append(convertToNumberedItem(instruction: instruction))
            }
            instructionsLabel.attributedText = fullAttributedString
        }
        
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            self.navigationItem.title = detail.title
            
            if let label = self.recipeTitleLabel {
                label.text = detail.title
            }
            if let img = self.recipeImg {
                img.image = detail.image
            }
            if let label = self.servingsLabel {
                label.text = detail.servings?.description
            }
            if let label = self.instructionsLabel {
                label.text = detail.instructions
            }
        }
    }

    override func viewDidLayoutSubviews() {
        if !scrollViewPropertiesInitialized {
            self.automaticallyAdjustsScrollViewInsets = true
            scrollView.contentInset = .zero
            scrollView.contentInset.bottom = 100
            scrollView.scrollIndicatorInsets = .zero
            scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
            scrollViewPropertiesInitialized = true
        }
        recipeTitleLabel.sizeToFit()
        recipeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeTitleLabel.setNeedsLayout()
        recipeTitleLabel.layoutIfNeeded()
    
        ingredientsLabel.sizeToFit()
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.setNeedsLayout()
        ingredientsLabel.layoutIfNeeded()
        
        instructionsLabel.sizeToFit()
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.setNeedsLayout()
        instructionsLabel.layoutIfNeeded()
        updateScrollSize()
    }
    
    
    
    func updateScrollSize() {
        
        let directionsBottomYPos = instructionsLabel.frame.origin.y + instructionsLabel.frame.size.height
        scrollView.contentSize.height = directionsBottomYPos + 140.0
    }
    
    
    
    // MARK: - Text Formatting
    func convertToNumberedItem(instruction: Instruction) -> NSMutableAttributedString {
        let formattedString: String = "\n\(instruction.stepNumber ?? 0). \(instruction.step ?? "")\n"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
        
        let paragraphStyle = createParagraphAttribute()
        attributedString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    func convertToBulletedItem(textToConvert: String) -> NSMutableAttributedString {
        let bulletPoint: String = "\u{2022}"
        let formattedString: String = "\(bulletPoint) \(textToConvert)\n"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
        
        let paragraphStyle = createParagraphAttribute()
        attributedString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    
    func createParagraphAttribute() ->NSParagraphStyle {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [String : AnyObject])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        
        return paragraphStyle
    }
    

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRecipeToMealPlanSegue" {
            if let controller = (segue.destination as! UINavigationController).topViewController as? AddToMealPlanTableViewController {
                if let detail = self.detailItem {
                    controller.selectedRecipe = detail
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: Recipe? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}

