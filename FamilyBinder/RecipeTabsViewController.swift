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
    func updateTabHeights(detailHeight: CGFloat)
}

class RecipeTabsViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var ingredientsBtn: UIButton!
    @IBOutlet weak var directionsBtn: UIButton!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var ingredientsContainer: UIView!
    @IBOutlet weak var directionsContainer: UIView!
    
    // MARK: Properties
    weak var tabToggledDelegate: TabToggledDelegate?
    private var currentRecipe = Recipe()
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
    
    // MARK: Functions
    
    func setCurrentRecipe(newRecipe: Recipe){
        self.currentRecipe = newRecipe
    }
    
    func configureView(){
        var detailHeight = self.ingredientsBtn.frame.size.height
        ingredientsBtn.setBackgroundColor(color: UIColor(hex: "DAE0E1"), forState: .normal)
        ingredientsBtn.setBackgroundColor(color: UIColor(hex: "C1212E"), forState: .selected)
        ingredientsBtn.isSelected = true
        detailHeight += ingredientsContainer.frame.size.height
        tabToggledDelegate?.updateTabHeights(detailHeight: detailHeight)
        
        directionsBtn.setBackgroundColor(color: UIColor(hex: "DAE0E1"), forState: .normal)
        directionsBtn.setBackgroundColor(color: UIColor(hex: "C1212E"), forState: .selected)
        directionsBtn.isSelected = false
        directionsContainer.isHidden = true
        
        if let vc = directionsViewController {
            vc.setCurrentRecipe(newRecipe: currentRecipe)
            vc.configureView()
        }
        if let vc = ingredientsViewController {
            vc.setCurrentRecipe(newRecipe: currentRecipe)
            vc.configureView()
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        updateHeights()
    }
    
    func updateHeights(){
        var newDetailHeight = self.ingredientsBtn.frame.size.height
//        ingredientsContainer.translatesAutoresizingMaskIntoConstraints = false
//        directionsContainer.translatesAutoresizingMaskIntoConstraints = false
//        ingredientsContainer.subviews[0].translatesAutoresizingMaskIntoConstraints = false
//        directionsContainer.subviews[0].translatesAutoresizingMaskIntoConstraints = false
        
        let ingredientsContainerHeight = ingredientsContainer.subviews[0].frame.size.height
        ingredientsContainer.frame.size.height = ingredientsContainerHeight
        
        let directionsContainerHeight = directionsContainer.subviews[0].frame.size.height
        directionsContainer.frame.size.height = directionsContainerHeight
        
        if ingredientsBtn.isSelected {
            detailsView.frame.size.height = ingredientsContainerHeight
            detailsView.subviews[1].frame.size.height = 0
            
        } else if directionsBtn.isSelected {
            detailsView.frame.size.height = directionsContainerHeight
            detailsView.subviews[0].frame.size.height = 0
        }

        newDetailHeight += detailsView.frame.size.height

        tabToggledDelegate?.updateTabHeights(detailHeight: newDetailHeight)
        
//        contentViewConstraint.constant = recipeImg.frame.size.height + recipeTitleView.frame.size.height + detailsView.frame.size.height
    }
    
    // MARK: Actions
    @IBAction func detailTabPressed(_ sender: UIButton) {
//        var newDetailHeight = self.ingredientsBtn.frame.size.height
        
        switch sender.tag {
        case DetailTabs.ingredients.rawValue:
            ingredientsBtn.isSelected = true
            directionsBtn.isSelected = false
//            newDetailHeight += ingredientsContainer.frame.size.height
        case DetailTabs.directions.rawValue:
            ingredientsBtn.isSelected = false
            directionsBtn.isSelected = true
//            newDetailHeight += directionsContainer.frame.size.height
        default:
            break
        }
        
        ingredientsContainer.isHidden = !ingredientsBtn.isSelected
        directionsContainer.isHidden = !directionsBtn.isSelected
        
        updateHeights()
//        tabToggledDelegate?.updateTabHeights(detailHeight: newDetailHeight)
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
