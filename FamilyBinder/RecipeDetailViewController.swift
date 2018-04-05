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

class RecipeDetailViewController: UIViewController, TitleDelegate {

    
    // MARK: - Outlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeTabsContainerView: UIView!
    @IBOutlet weak var recipeTitleContainerView: UIView!
    
    var recipeTitleViewController:RecipeTitleViewController?
    var recipeTabsViewController:RecipeTabsViewController?

    let realm = try! Realm()

    
    // MARK: - View Manipulation
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.detailItem == nil {
            if let firstRecipe = realm.objects(Recipe.self).first {
                self.detailItem = firstRecipe.copy as? Recipe
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
            
            if let vc = recipeTabsViewController {
                vc.setCurrentRecipe(newRecipe: detail)
                vc.configureView()
            }
        }
    }
    
    
    
    // MARK: - Actions
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MARK: - Protocols
    func mealPlanBtnClicked() {
        performSegue(withIdentifier: "addRecipeToMealPlanSegue", sender: nil)
    }
    
    // MARK: - Segues
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "addRecipeToMealPlanSegue" {
                if let controller = (segue.destination as! UINavigationController).topViewController as? AddRecipeToMealPlanTableViewController {
                    if let detail = self.detailItem {
    
                        controller.selectedRecipe = detail
                    }
                }
            } else if segue.identifier == "titleSegue" {
                recipeTitleViewController = segue.destination as? RecipeTitleViewController
                if let detail = self.detailItem {
                    recipeTitleViewController?.setCurrentRecipe(newRecipe: detail)
                    recipeTitleViewController?.view.translatesAutoresizingMaskIntoConstraints = false
                    recipeTitleViewController?.delegate = self
                }
            } else if segue.identifier == "tabsSegue" {
                recipeTabsViewController = segue.destination as? RecipeTabsViewController
                if let detail = self.detailItem {
                    recipeTabsViewController?.setCurrentRecipe(newRecipe: detail)
                    recipeTabsViewController?.view.translatesAutoresizingMaskIntoConstraints = false
                }
            }
        }
    
    
    var detailItem: Recipe? {
        didSet {
            // Update the view.
            //configureView()
        }
    }
}

