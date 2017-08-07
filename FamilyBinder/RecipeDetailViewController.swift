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
    @IBOutlet weak var addRecipeBtn: UIBarButtonItem!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var scrollViewPropertiesInitialized = false
    var favoritedRecipe = Recipe()
    
//    // Get the default Realm
    let realm = try! Realm()
//    // You only need to do this once (per thread)
//    // To find Realm File, enter the following when debugger is paused:
//    // po Realm.Configuration.defaultConfiguration.fileURL
    
    // MARK: - View Manipulation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            self.navigationItem.title = detail.title
            
            if let label = self.recipeTitleLabel {
                label.text = detail.title
            }
            if let img = self.recipeImg {
                let placeholderImage = #imageLiteral(resourceName: "dinnerPlate")
                let url = URL(string: detail.imageURL)
                img.af_setImage(withURL: url!, placeholderImage: placeholderImage)
                detail.image = img.image
            }
            if let label = self.servingsLabel {
                label.text = detail.servings.description
            }
            
            // Format ingredients
            if let label = self.ingredientsLabel {
                let attributesDictionary = [NSFontAttributeName : label.font]
                let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
                for ingredient in (detail.ingredients) {
                    if ingredient.originalString != "" {
                        fullAttributedString.append(convertToBulletedItem(textToConvert: ingredient.originalString))
                    }
                }
                
                label.attributedText = fullAttributedString
            }
            
            // Format instructions
            if let label = instructionsLabel {
                let attributesDictionary = [NSFontAttributeName : label.font]
                let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
                for instruction in detail.analyzedInstructions {
                    fullAttributedString.append(convertToNumberedItem(instruction: instruction))
                }
                
                label.attributedText = fullAttributedString
            }

            addRecipeBtn.isEnabled = true
            updateFavoriteBtn()
        } else {
            addRecipeBtn.isEnabled = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        if !scrollViewPropertiesInitialized {
            self.automaticallyAdjustsScrollViewInsets = true
            scrollView.contentInset = .zero
            scrollView.contentInset.bottom = 120
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
        let formattedString: String = "\n\(instruction.stepNumber ). \(instruction.step )\n"
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
    
    // MARK: - Action Handlers
    
    @IBAction func addRecipeBtnClicked(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let addToMyRecipes = UIAlertAction(title: "Add To My Recipes", style: .default, handler: {
            _ in
            self.addRemoveRecipeFromFavorites()
        })
        let removeFromMyRecipes = UIAlertAction(title: "Remove From My Recipes", style: .default, handler: {
            _ in
            self.addRemoveRecipeFromFavorites()
        })
        let addToMealPlan = UIAlertAction(title: "Add To Meal Plan", style: .default, handler: {
            action in self.performSegue(withIdentifier: "addRecipeToMealPlanSegue", sender: self)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        if (self.detailItem?.isFavorite)! {
            optionMenu.addAction(removeFromMyRecipes)
        } else {
            optionMenu.addAction(addToMyRecipes)
        }
        
        optionMenu.addAction(addToMealPlan)
        optionMenu.addAction(cancelAction)
        
        optionMenu.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func favoriteBtnClicked(_ sender: Any) {
        addRemoveRecipeFromFavorites()
    }
    
    func addRemoveRecipeFromFavorites() {
        if (self.detailItem?.isFavorite)! {
            // Remove from favorites
            try! self.realm.write {
                self.realm.delete(realm.objects(Recipe.self).filter("id == %@", favoritedRecipe.id))
                print("Removed \(favoritedRecipe.title) from my recipes")
                self.detailItem?.isFavorite = false
                if let btn = self.favoriteBtn {
                    btn.setImage(#imageLiteral(resourceName: "heart_black_empty"), for: .normal)
                }
            }
        } else {
            // Add to favorites
            try! self.realm.write {
                self.detailItem?.isFavorite = true
                favoritedRecipe = self.detailItem?.copy() as! Recipe
                self.realm.create(Recipe.self, value: favoritedRecipe)
                print("Added \(favoritedRecipe.title) to my recipes")
                if let btn = self.favoriteBtn {
                    btn.setImage(#imageLiteral(resourceName: "heart_red_filled"), for: .normal)
                }
                
            }
        }
    }
    
    
    // MARK: - Business Logic
    func addRecipeToFavorites() {
        try! self.realm.write {
            self.realm.add(self.detailItem!, update: true)
            print("Added to my recipes")
            self.detailItem?.isFavorite = true
            updateFavoriteBtn()
        }
    }
    
    func removeRecipeFromFavorites() {
        try! self.realm.write {
            self.realm.delete(self.detailItem!)
            print("Removed from my recipes")
            self.detailItem?.isFavorite = false
            updateFavoriteBtn()
        }
    }
    
    func updateFavoriteBtn(){
        if (self.detailItem?.isFavorite)! {
            if let btn = self.favoriteBtn {
                btn.setImage(#imageLiteral(resourceName: "heart_red_filled"), for: .normal)
            }
        } else {
            if let btn = self.favoriteBtn {
                btn.setImage(#imageLiteral(resourceName: "heart_black_empty"), for: .normal)
            }
        }
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

