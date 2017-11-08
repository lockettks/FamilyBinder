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
    // Get the default Realm
    let realm = try! Realm()
    //    // To find Realm File, enter the following when debugger is paused:
    //    // po Realm.Configuration.defaultConfiguration.fileURL
    
    private var currentRecipe = Recipe()
    
    // MARK: View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (!(self.currentRecipe.isFavorite)) {
            // Remove from favorites
            try! self.realm.write {
                if let recipeToDelete = realm.object(ofType: Recipe.self, forPrimaryKey: self.currentRecipe.id) {
                    self.realm.delete(recipeToDelete.analyzedDirections)
                    self.realm.delete(recipeToDelete.ingredients)
                    self.realm.delete(recipeToDelete)
                }
            }
        } else {
            // Add to favorites
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
        
        if let recipeTitleLabel = self.recipeTitleLabel {
            recipeTitleLabel.text = currentRecipe.title
            recipeTitleLabel.sizeToFit()
        }
        if let creditLabel = self.creditLabel {
            creditLabel.text = currentRecipe.creditText
            creditLabel.sizeToFit()
        }
        
        if let servingsLabel = self.servingsLabel {
            servingsLabel.text = currentRecipe.servings.description
            servingsLabel.sizeToFit()
        }
        
        if let cookTimeLabel = self.timeToCookLabel {
            cookTimeLabel.text = "\(currentRecipe.readyInMinutes) min"
            cookTimeLabel.sizeToFit()
        }
        
        if let spoonacularLabel = self.spoonacularLabel {
            spoonacularLabel.text = currentRecipe.spoonacularScore.description
            spoonacularLabel.sizeToFit()
        }
        
        if let likesLabel = self.likesLabel {
            likesLabel.text = currentRecipe.likes.description
            likesLabel.sizeToFit()
        }
        
        if let favoriteBtn = self.favoriteBtn {
            favoriteBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFill
            setFavoriteIconImg()
        }
        
        
        if realm.objects(Recipe.self).filter("id == %@", currentRecipe.id).first != nil {
            try! self.realm.write {
                currentRecipe.isFavorite = true
            }
            setFavoriteIconImg()
        }
    }
    
    // MARK: Actions
    @IBAction func favoriteBtnClicked(_ sender: Any) {
        try! realm.write {
            currentRecipe.isFavorite = !currentRecipe.isFavorite
            setFavoriteIconImg()
        }
    }
    
    @IBAction func mealPlanBtnClicked(_ sender: Any) {
    }
    
    func setFavoriteIconImg(){
        if (currentRecipe.isFavorite) {
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
