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
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var recipeImgBackground: UIImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var addRecipeBtn: UIBarButtonItem!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var recipeTitleView: UIView!
    @IBOutlet weak var shadowBackgroundView: UIView!
    @IBOutlet weak var recipeDetailsView: UIView!
    
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
    
    override func viewDidAppear(_ animated: Bool) {


    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let split = splitViewController {
            if split.isCollapsed {
                // Hide the navigation bar on iphones
                self.navigationController?.setNavigationBarHidden(true, animated: animated)
                backBtn.isHidden = false
            } else {
                // Show the nav bar and hide the back button on ipads
                backBtn.isHidden = true
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        //performSegue(withIdentifier: "unwindSegueToMasterRecipes", sender: self)
        
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.navigationController?.popToRootViewController(animated: true)
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
                if let url = URL(string: detail.imageURL) {
                    img.af_setImage(withURL: url, placeholderImage: placeholderImage)
                    detail.image = img.image
                }
                
            }
            if let img = self.recipeImgBackground {
                let placeholderImage = #imageLiteral(resourceName: "dinnerPlate")
                if let url = URL(string: detail.imageURL) {
                    img.af_setImage(withURL: url, placeholderImage: placeholderImage)
                    detail.image = img.image
                }
            }
            
            
            if let label = self.servingsLabel {
                label.text = detail.servings.description
            }
            
            // Format ingredients
            if let label = self.ingredientsLabel {
                let attributesDictionary = [NSFontAttributeName : label.font]
                let fullAttributedString = NSMutableAttributedString(string: "", attributes: (attributesDictionary as Any as! [String : Any]))
                for ingredient in (detail.ingredients) where ingredient.originalString != "" {
                    fullAttributedString.append(convertToBulletedItem(textToConvert: ingredient.originalString))
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
            
            if realm.objects(Recipe.self).filter("id == %@", detail.id).first != nil {
                detail.isFavorite = true
                setFavoriteIconImg()
            }
            
            
        } else {
            addRecipeBtn.isEnabled = false
        }
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
        
        let addToMyRecipes = UIAlertAction(title: "Add To My Recipes", style: .default, handler: {_ in
            self.updateFavoriteStatus()
        })
        let removeFromMyRecipes = UIAlertAction(title: "Remove From My Recipes", style: .default, handler: {_ in
            self.updateFavoriteStatus()
        })
        let addToMealPlan = UIAlertAction(title: "Add To Meal Plan", style: .default, handler: {_ in self.performSegue(withIdentifier: "addRecipeToMealPlanSegue", sender: self)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_: UIAlertAction!) -> Void in
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
        updateFavoriteStatus()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        if let thisRecipe = self.detailItem {
            if (!(thisRecipe.isFavorite)) {
                // Remove from favorites
                try! self.realm.write {
                    if let recipeToDelete = realm.object(ofType: Recipe.self, forPrimaryKey: thisRecipe.id) {
                        self.realm.delete(recipeToDelete.analyzedInstructions)
                        self.realm.delete(recipeToDelete.ingredients)
                        self.realm.delete(recipeToDelete)
                    }
                }
            } else {
                // Add to favorites
                if realm.object(ofType: Recipe.self, forPrimaryKey: thisRecipe.id) == nil {
                    try! self.realm.write {
                        // self.realm.create(Recipe.self, value: thisRecipe, update:true)
                        self.realm.add(thisRecipe, update:true)
                        print("Added \(thisRecipe.title) to my recipes")
                    }
                }
            }
        }
    }
    
    
    
    func updateFavoriteStatus(){
        if let detailItem = self.detailItem {
            try! self.realm.write {
                detailItem.isFavorite = !detailItem.isFavorite
                setFavoriteIconImg()
            }
        }
    }
    
    func setFavoriteIconImg(){
        if let detailItem = self.detailItem {
            if (detailItem.isFavorite) {
                if let btn = self.favoriteBtn {
                    btn.setImage(#imageLiteral(resourceName: "pin_Checkmark_On"), for: .normal)
                }
            } else {
                if let btn = self.favoriteBtn {
                    btn.setImage(#imageLiteral(resourceName: "pin"), for: .normal)
                }
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
        }
    }
}

