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
    
    // MARK: Functions
    func setCurrentRecipe(newRecipe: Recipe){
        self.currentRecipe = newRecipe
    }
    
    func configureView(){
        
        if let recipeTitleLabel = self.recipeTitleLabel {
            recipeTitleLabel.text = currentRecipe.title
        }
        if let creditLabel = self.creditLabel {
            creditLabel.text = currentRecipe.creditText
        }
        
        if let servingsLabel = self.servingsLabel {
            servingsLabel.text = currentRecipe.servings.description
        }
        
        if let cookTimeLabel = self.timeToCookLabel {
            cookTimeLabel.text = "\(currentRecipe.readyInMinutes) min"
        }
        
        if let spoonacularLabel = self.spoonacularLabel {
            spoonacularLabel.text = currentRecipe.spoonacularScore.description
        }
        
        if let likesLabel = self.likesLabel {
            likesLabel.text = currentRecipe.likes.description
        }
        
        if let favoriteBtn = self.favoriteBtn {
            favoriteBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFill
            setFavoriteIconImg()
        }
        
        
        
        
//        if realm.objects(Recipe.self).filter("id == %@", detail.id).first != nil {
//            try! self.realm.write {
//                detail.isFavorite = true
//            }
//            setFavoriteIconImg()
//        }
    }
    
    // MARK: Actions
    @IBAction func mealPlanBtnClicked(_ sender: Any) {
    }
    
    func updateFavoriteStatus(){
        try! realm.write {
            currentRecipe.isFavorite = !currentRecipe.isFavorite
            setFavoriteIconImg()
        }
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
