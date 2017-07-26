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

    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!
    


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

