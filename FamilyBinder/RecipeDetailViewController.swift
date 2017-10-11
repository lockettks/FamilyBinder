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
    // MARK: - Outlets
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var timeToCookLabel: UILabel!
    @IBOutlet weak var spoonacularLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!

    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var addRecipeBtn: UIBarButtonItem!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var shoppingCartBtn: UIButton!
    @IBOutlet weak var mealPlanBtn: UIButton!
    
    @IBOutlet weak var recipeTitleView: UIView!
    @IBOutlet weak var recipeDetailsView: UIView!
    
    @IBOutlet weak var ingredientsTab: UIButton!
    @IBOutlet weak var ingredientsViewContainer: UIView!
    @IBOutlet weak var directionsTab: UIButton!
    @IBOutlet weak var directionsViewContainer: UIView!
    @IBOutlet weak var recipeImgBackground: UIImageView!


    // MARK: View Controller Variables
    var scrollViewPropertiesInitialized = false
    var favoritedRecipe = Recipe()
    var ingredientsViewController:IngredientsViewController?
    var directionsViewController:DirectionsViewController?
    var didSetConstraints = false
    
    //    // Get the default Realm
    let realm = try! Realm()
    //    // You only need to do this once (per thread)
    //    // To find Realm File, enter the following when debugger is paused:
    //    // po Realm.Configuration.defaultConfiguration.fileURL
    
    enum DetailTabs: Int {
        case ingredients = 0
        case directions
    }
    
    // MARK: - View Manipulation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.detailItem == nil {
            if let firstRecipe = realm.objects(Recipe.self).first {
                self.detailItem = firstRecipe
            }
        }

        ingredientsTab.setBackgroundColor(color: UIColor(hex: "DAE0E1"), forState: .normal)
        ingredientsTab.setBackgroundColor(color: UIColor(hex: "C1212E"), forState: .selected)
        directionsTab.setBackgroundColor(color: UIColor(hex: "DAE0E1"), forState: .normal)
        directionsTab.setBackgroundColor(color: UIColor(hex: "C1212E"), forState: .selected)
        
        configureView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            self.navigationItem.title = detail.title
            
            if let recipeTitleLabel = self.recipeTitleLabel {
                recipeTitleLabel.text = detail.title
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

            ingredientsTab.isSelected = true
            directionsTab.isSelected = false
            toggleDetailsPanels()
            
            if let cookTimeLabel = self.timeToCookLabel {
                cookTimeLabel.text = "\(detail.readyInMinutes) min"
            }
            
            if let spoonacularLabel = self.spoonacularLabel {
                spoonacularLabel.text = detail.spoonacularScore.description
            }
            
            if let likesLabel = self.likesLabel {
                likesLabel.text = detail.likes.description
            }
            
            if let favoriteBtn = self.favoriteBtn {
                favoriteBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFill
            }
            
            creditLabel?.text = detail.creditText
            
            addRecipeBtn.isEnabled = true
            
            if realm.objects(Recipe.self).filter("id == %@", detail.id).first != nil {
                try! self.realm.write {
                    detail.isFavorite = true
                }
                setFavoriteIconImg()
            }
            
                    if let vc = directionsViewController {
                            vc.configureView(currentRecipe: detail)
                    }
            if let vc = ingredientsViewController {
                    vc.configureView(currentRecipe: detail)
            }
        }
    }
    
    // MARK: Constraints
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        updateHeights()
    }

    
    func updateHeights(){
        ingredientsViewContainer.subviews[0].translatesAutoresizingMaskIntoConstraints = false
        directionsViewContainer.subviews[0].translatesAutoresizingMaskIntoConstraints = false
        
        let ingredientsContainerHeight = ingredientsViewContainer.subviews[0].frame.size.height
        ingredientsViewContainer.frame.size.height = ingredientsContainerHeight
        let directionsContainerHeight = directionsViewContainer.subviews[0].frame.size.height
        directionsViewContainer.frame.size.height = directionsContainerHeight
        
        if ingredientsTab.isSelected {
            recipeDetailsView.frame.size.height = ingredientsContainerHeight - 10 //TODO:  Debug why i need to remove - 10
            recipeDetailsView.subviews[1].frame.size.height = 0
            
        } else if directionsTab.isSelected {
            recipeDetailsView.frame.size.height = directionsContainerHeight
            recipeDetailsView.subviews[0].frame.size.height = 0
        }
        
        contentViewConstraint.constant = recipeImg.frame.size.height + recipeTitleView.frame.size.height + recipeDetailsView.frame.size.height
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
    @IBAction func shoppingCartBtnPressed(_ sender: Any) {
    }
    
    @IBAction func mealPlanBtnPressed(_ sender: Any) {
    }

    
    @IBAction func detailTabPressed(_ sender: UIButton) {
        switch sender.tag {
        case DetailTabs.ingredients.rawValue:
            ingredientsTab.isSelected = true
            directionsTab.isSelected = false
        case DetailTabs.directions.rawValue:
            ingredientsTab.isSelected = false
            directionsTab.isSelected = true
        default:
            break
        }
        
        toggleDetailsPanels()
        updateHeights()
    }
    
    
    func toggleDetailsPanels(){
        ingredientsViewContainer.isHidden = !ingredientsTab.isSelected
        directionsViewContainer.isHidden = !directionsTab.isSelected
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
        } else if segue.identifier == "ingredientsSegue" {
            ingredientsViewController = segue.destination as? IngredientsViewController
            ingredientsViewController?.view.translatesAutoresizingMaskIntoConstraints = false
            
            
        } else if segue.identifier == "directionsSegue" {
            directionsViewController = segue.destination as? DirectionsViewController
            directionsViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: Recipe? {
        didSet {
            // Update the view.
            //configureView()
        }
    }
}

