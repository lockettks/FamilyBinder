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
        
//        if let vc = ingredientsViewController {
//            vc.setCurrentRecipe(newRecipe: currentRecipe)
//            vc.configureView()
//        }
//        
//        if let vc = directionsViewController {
//            vc.setCurrentRecipe(newRecipe: currentRecipe)
//            vc.configureView()
//        }
        
        updateHeights()
    }
    
    
    
    //    override func updateViewConstraints() {
    //        super.updateViewConstraints()
    //        updateHeights()
    //    }
    
    func updateHeights(){
        //var newDetailHeight = self.ingredientsBtn.frame.size.height
        
        let ingredientsHeightNeeded = ingredientsContainer.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        print("ingredientsHeightNeeded \(ingredientsHeightNeeded)")
        ingredientsContainer.frame.size.height = ingredientsHeightNeeded
        
        
        let directionsHeightNeeded = directionsContainer.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        print("directionsHeightNeeded \(directionsHeightNeeded)")
        directionsContainer.frame.size.height = directionsHeightNeeded
        
//        if let iVC = ingredientsViewController, let dVC = directionsViewController {
        
            if ingredientsBtn.isSelected {
                detailsView.frame.size.height = ingredientsHeightNeeded
                
//                remove(asChildViewController: dVC)
//                add(asChildViewController: iVC)
                
            } else if directionsBtn.isSelected {
                detailsView.frame.size.height = directionsHeightNeeded
                
//                remove(asChildViewController: iVC)
//                add(asChildViewController: dVC)
            }
//        }
        
        //newDetailHeight += detailsView.frame.size.height
        //
        //                tabToggledDelegate?.updateTabHeights(detailHeight: newDetailHeight)
        
        //        contentViewConstraint.constant = recipeImg.frame.size.height + recipeTitleView.frame.size.height + detailsView.frame.size.height
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
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
        updateHeights()
        
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
