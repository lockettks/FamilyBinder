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
            self.navigationItem.title = detail.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !scrollViewPropertiesInitialized {
            self.automaticallyAdjustsScrollViewInsets = false
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
    
    @IBAction func addToMealPlan(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRecipeToMealPlanSegue" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let recipe = recipes[indexPath.row]
                if let controller = (segue.destination as! UINavigationController).topViewController as? AddToMealPlanTableViewController {
                    if let detail = self.detailItem {
                        controller.selectedRecipe = detail
                    }
//                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
//            }
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

