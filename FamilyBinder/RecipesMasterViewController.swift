//
//  RecipeMasterViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/14/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit
import PromiseKit
import RealmSwift

class RecipesMasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipesTypeSegCntrl: UISegmentedControl!
    
    
    // MARK: - Defaults
    let NUMBER_OF_RECIPES = 1
    let DEFAULT_SELECTED_ROW = 0
    let DEFAULT_SELECTED_TOGGLE = 0
    
    let realm = try! Realm()
    // To find Realm File, enter the following when debugger is paused:
    // po Realm.Configuration.defaultConfiguration.fileURL
    
    
    // MARK: - Variables
    var detailViewController: RecipeDetailViewController?
    var recipes = [Recipe]()
    
    
    // MARK: - Table Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? RecipeDetailViewController
        }
        recipesTypeSegCntrl.selectedSegmentIndex = DEFAULT_SELECTED_TOGGLE
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Refresh data if viewing My Recipes to ensure the favorited recipes are updated
        if (recipesTypeSegCntrl.selectedSegmentIndex == 0) {
            self.recipes = Array(realm.objects(Recipe.self))
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = recipes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecipeTableViewCell
        cell.initWithModel(model: recipe)
        return cell
    }
    
    
    // MARK: - Data
    
    func loadRecipes() -> Promise<[Recipe]> {
        return Promise{fulfill, _ in
            switch(recipesTypeSegCntrl.selectedSegmentIndex){
            case 0:
                let myRecipes = Array(realm.objects(Recipe.self))
                fulfill(myRecipes)
                
                break
            case 1:
                getRandomRecipes().then { recipesReceived -> Void in
                    fulfill(recipesReceived)
                    //                    self.tableView.reloadData()
                    }.catch { error in
                        print(error)
                }
                break
            default:
                break
            }
        }
    }
    
    func getRandomRecipes() -> Promise<[Recipe]> {
        return Promise {fulfill, _ in
            SpoonacularAPIManager.sharedInstance.fetchRandomRecipes(numberOfRecipes: NUMBER_OF_RECIPES).then { result -> Void in
                fulfill(result)
                }.catch { error in
                    print(error)
            }
        }
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func recipesTypeSegCntrlChanged(_ sender: UISegmentedControl) {
        loadRecipes().then{ recipesReceived -> Void in
            self.recipes = recipesReceived
            self.tableView.reloadData()
            }.catch { error in
                print(error)
        }
    }

    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let recipe = recipes[indexPath.row]
                if let controller = (segue.destination as! UINavigationController).topViewController as? RecipeDetailViewController {
                    controller.detailItem = recipe.copy() as? Recipe
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }
    
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    
    // MARK: - Table Updating
    
    func insertNewObject(_ sender: Any) {
        let alert = UIAlertController(title: "Not Implemented",
                                      message: "Can't create new recipes yet, will implement later",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    
    // MARK: - Error handling
    
    func handleLoadRecipesError(_ error: Error) {
        // TODO: show error
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

