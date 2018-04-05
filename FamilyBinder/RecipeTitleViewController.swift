//
//  RecipeTitleViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 10/11/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol TitleDelegate : class {
    func mealPlanBtnClicked()
}

class RecipeTitleViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var recipeTitleView: DesignableView!
    @IBOutlet weak var timeToCookLabel: UILabel!
    @IBOutlet weak var spoonacularLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    @IBOutlet weak var creditLabel: UILabel!
    
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var shoppingCartBtn: UIButton!
    @IBOutlet weak var mealPlanBtn: UIButton!
    
    // MARK: Properties
    let realm = try! Realm()
    private var currentRecipe = Recipe()
    weak var delegate: TitleDelegate?
    let recipeService = RecipeService()
    var isCurrentlyFavorite = false
    
    // MARK: View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureView()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (!(isCurrentlyFavorite)) {
            // Remove from favorites if it exists
            try! self.realm.write {
                if let recipeToDelete = realm.object(ofType: Recipe.self, forPrimaryKey: self.currentRecipe.id) {
                    self.realm.delete(recipeToDelete.analyzedDirections)
                    self.realm.delete(recipeToDelete.ingredients)
                    self.realm.delete(recipeToDelete)
                }
            }
        } else {
            // Add to favorites if it doesn't already exist
            if realm.object(ofType: Recipe.self, forPrimaryKey: self.currentRecipe.id) == nil {
                try! self.realm.write {
                    // self.realm.create(Recipe.self, value: thisRecipe, update:true)
                    self.realm.add(self.currentRecipe, update:true)
                    print("Added \(self.currentRecipe.title) to my recipes")
                }
            }
        }
    }
    
    // MARK: Functions
    func setCurrentRecipe(newRecipe: Recipe){
        self.currentRecipe = newRecipe
    }
    
    func configureView(){
        recipeTitleLabel.text = currentRecipe.title
        recipeTitleLabel.sizeToFit()
        
        creditLabel.text = currentRecipe.creditText
        creditLabel.sizeToFit()
        
        servingsLabel.text = currentRecipe.servings.description
        servingsLabel.sizeToFit()
        
        timeToCookLabel.text = "\(currentRecipe.readyInMinutes) min"
        timeToCookLabel.sizeToFit()
        
        spoonacularLabel.text = currentRecipe.spoonacularScore.description
        spoonacularLabel.sizeToFit()
        
        likesLabel.text = currentRecipe.likes.description
        likesLabel.sizeToFit()
        
        isCurrentlyFavorite = recipeService.isFavoriteInRealm(recipe: currentRecipe)
        setFavoriteIconImg()
        
        mealPlanBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        setMealPlanIconImg()
        
        self.view.layoutIfNeeded()
        
        
//        if realm.objects(Recipe.self).filter("id == %@", currentRecipe.id).first != nil {
//            try! self.realm.write {
//                currentRecipe.isFavorite = true //why do this?  shouldn't be done here.
//            }
//            setFavoriteIconImg()
//        }
        
    }
    
    // MARK: Actions
    @IBAction func favoriteBtnClicked(_ sender: Any) {
        isCurrentlyFavorite = !isCurrentlyFavorite
        setFavoriteIconImg()
//        try! realm.write {
//            currentRecipe.isFavorite = !currentRecipe.isFavorite
////            setFavoriteIconImg()
//        }
    }
    

    
    func setFavoriteIconImg(){
        favoriteBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        if (isCurrentlyFavorite) {
            favoriteBtn.setImage(#imageLiteral(resourceName: "pin_Checkmark_On"), for: .normal)
        } else {
            favoriteBtn.setImage(#imageLiteral(resourceName: "pin"), for: .normal)
        }
//        if (currentRecipe.isFavorite) {
//            if let btn = self.favoriteBtn {
//                btn.setImage(#imageLiteral(resourceName: "pin_Checkmark_On"), for: .normal)
//            }
//        } else {
//            if let btn = self.favoriteBtn {
//                btn.setImage(#imageLiteral(resourceName: "pin"), for: .normal)
//            }
//        }
    }
    
    @IBAction func mealPlanBtnClicked(_ sender: Any) {
        delegate?.mealPlanBtnClicked()
        setMealPlanIconImg()
    }
    
    func setMealPlanIconImg(){
        if (currentRecipe.isOnMealPlan) {
            if let btn = self.mealPlanBtn {
                btn.setBackgroundImage(#imageLiteral(resourceName: "mealPlan_Checkmark_On"), for: .normal)
            }
        } else {
            if let btn = self.mealPlanBtn {
                btn.setBackgroundImage(#imageLiteral(resourceName: "mealPlan_Add"), for: .normal)
            }
        }
    }
}
