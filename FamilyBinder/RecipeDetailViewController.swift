//
//  RecipeDetailViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/14/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit
import RealmSwift

enum DetailTabs: Int {
    case ingredients = 0
    case directions
}

class RecipeDetailViewController: UIViewController, TabToggledDelegate {
    // MARK: - Outlets
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var addRecipeBtn: UIBarButtonItem!
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeTabsContainerView: UIView!
    @IBOutlet weak var recipeTitleContainerView: UIView!
    
    var favoritedRecipe = Recipe()
    var recipeTitleViewController:RecipeTitleViewController?
    var titleHeight = CGFloat()
    var tabsHeight = CGFloat()
    var recipeTabsViewController:RecipeTabsViewController?

    
    //    // Get the default Realm
    let realm = try! Realm()

    
    // MARK: - View Manipulation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.detailItem == nil {
            if let firstRecipe = realm.objects(Recipe.self).first {
                self.detailItem = firstRecipe
            }
        }
        
        configureView()
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
            
            if let img = self.recipeImg {
                let placeholderImage = #imageLiteral(resourceName: "dinnerPlate")
                if let url = URL(string: detail.imageURL) {
                    img.af_setImage(withURL: url, placeholderImage: placeholderImage)
                    detail.image = img.image
                }
            }

            
            self.navigationItem.title = detail.title
            
            
            addRecipeBtn.isEnabled = true
            
//            if realm.objects(Recipe.self).filter("id == %@", detail.id).first != nil {
//                try! self.realm.write {
//                    detail.isFavorite = true
//                }
//                setFavoriteIconImg()
//            }
            
            if let vc = recipeTabsViewController {
                vc.setCurrentRecipe(newRecipe: detail)
                vc.configureView()
            }
        }
    }
    
    // MARK: Constraints
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        updateHeights()
    }
    
    
    func updateHeights(){
//        recipeTitleContainerView.subviews[0].translatesAutoresizingMaskIntoConstraints = false
//        recipeTabsContainerView.subviews[0].translatesAutoresizingMaskIntoConstraints = false
        
        contentView.frame.size.height = recipeImg.frame.size.height + recipeTitleContainerView.frame.size.height + recipeTabsContainerView.frame.size.height
        recipeTitleContainerView.frame.origin.y = recipeImg.frame.size.height
        recipeTabsContainerView.frame.origin.y = recipeTitleContainerView.frame.maxY
//       contentViewConstraint.constant = recipeImg.frame.size.height + recipeTitleContainerView.frame.size.height + recipeTabsContainerView.frame.size.height
        view.layoutSubviews()
        view.layoutIfNeeded()
    
        
    }
    
    // MARK: Protocol Functions
    func updateTabHeights(detailHeight: CGFloat){
        recipeTabsContainerView.frame.size.height = detailHeight
        updateHeights()
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
    
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRecipeToMealPlanSegue" {
            if let controller = (segue.destination as! UINavigationController).topViewController as? AddToMealPlanTableViewController {
                if let detail = self.detailItem {
                    controller.selectedRecipe = detail
                }
            }
        } else if segue.identifier == "titleSegue" {
            recipeTitleViewController = segue.destination as? RecipeTitleViewController
            if let detail = self.detailItem {
                recipeTitleViewController?.setCurrentRecipe(newRecipe: detail)
                recipeTitleViewController?.view.translatesAutoresizingMaskIntoConstraints = false
                
            }
        } else if segue.identifier == "tabsSegue" {
            recipeTabsViewController = segue.destination as? RecipeTabsViewController
            recipeTabsViewController?.tabToggledDelegate = self
            if let detail = self.detailItem {
                recipeTabsViewController?.setCurrentRecipe(newRecipe: detail)
                recipeTabsViewController?.view.translatesAutoresizingMaskIntoConstraints = false
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
            //configureView()
        }
    }
}

