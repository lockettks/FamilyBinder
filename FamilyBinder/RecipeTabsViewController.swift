//
//  RecipeTabsViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 10/11/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import UIKit

// MARK: Protocols
protocol TabToggledDelegate: class {
    func updateTabHeights()
}

class RecipeTabsViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var ingredientsBtn: UIButton!
    @IBOutlet weak var directionsBtn: UIButton!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var ingredientsContainer: UIView!
    @IBOutlet weak var directionsContainer: UIView!
    
    // MARK: Public Properties
    weak var tabToggledDelegate: TabToggledDelegate?

    // MARK: Private Properties
    private var currentRecipe = Recipe()
    
    // MARK: View Controller Variables
    var ingredientsViewController:IngredientsViewController?
    var directionsViewController:DirectionsViewController?
    
    // MARK: View Loaders
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    func setCurrentRecipe(newRecipe: Recipe){
        self.currentRecipe = newRecipe
    }
    
    func configureView(){
        ingredientsBtn.setBackgroundColor(color: UIColor(hex: "DAE0E1"), forState: .normal)
        ingredientsBtn.setBackgroundColor(color: UIColor(hex: "C1212E"), forState: .selected)
        ingredientsBtn.isSelected = true
        
        directionsBtn.setBackgroundColor(color: UIColor(hex: "DAE0E1"), forState: .normal)
        directionsBtn.setBackgroundColor(color: UIColor(hex: "C1212E"), forState: .selected)
        directionsBtn.isSelected = false
        
        if let vc = directionsViewController {
            vc.configureView(currentRecipe: currentRecipe)
        }
        if let vc = ingredientsViewController {
            vc.configureView(currentRecipe: currentRecipe)
        }
    }
    
    // MARK: Actions
    @IBAction func detailTabPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case DetailTabs.ingredients.rawValue:
            ingredientsBtn.isSelected = true
            directionsBtn.isSelected = false
        case DetailTabs.directions.rawValue:
            ingredientsBtn.isSelected = false
            directionsBtn.isSelected = true
        default:
            break
        }
        
        ingredientsContainer.isHidden = !ingredientsBtn.isSelected
        directionsContainer.isHidden = !directionsBtn.isSelected
        
        tabToggledDelegate?.updateTabHeights()
    }
    
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ingredientsSegue" {
            ingredientsViewController = segue.destination as? IngredientsViewController
            ingredientsViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        } else if segue.identifier == "directionsSegue" {
            directionsViewController = segue.destination as? DirectionsViewController
            directionsViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
