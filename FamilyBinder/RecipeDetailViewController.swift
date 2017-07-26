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
    @IBOutlet weak var directionsLabel: UILabel!
    
    var scrollViewPropertiesInitialized = false
    
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
            if let label = self.directionsLabel {
                label.text = detail.instructions
            }
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        if let detail = self.detailItem {
            let attributesDictionary = [NSFontAttributeName : self.ingredientsLabel.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
            for ingredient in (detail.ingredients) {
                if let oString = ingredient.originalString {
                    let bulletPoint: String = "\u{2022}"
                    let formattedString: String = "\(bulletPoint) \(oString)\n"
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
                    
                    let paragraphStyle = createParagraphAttribute()
                    attributedString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, attributedString.length))
                    fullAttributedString.append(attributedString)
                }
            }
            ingredientsLabel.attributedText = fullAttributedString
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !scrollViewPropertiesInitialized {
            self.automaticallyAdjustsScrollViewInsets = true
            scrollView.contentInset = .zero
            scrollView.scrollIndicatorInsets = .zero
            scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
            scrollViewPropertiesInitialized = true
        }
        updateScrollSize()
    }
    
    func updateScrollSize() {
        let directionsBottomYPos = directionsLabel.frame.origin.y + directionsLabel.frame.size.height
        scrollView.contentSize.height = directionsBottomYPos + 40.0
    }
    
    
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

