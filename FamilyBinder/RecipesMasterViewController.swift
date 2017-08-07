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
    
    var NUMBER_OF_RECIPES = 1
    var detailViewController: RecipeDetailViewController? = nil
    var recipes = [Recipe]()
    //    var recipes = List<Recipe>()
    
    // Get the default Realm
    let realm = try! Realm()
    // You only need to do this once (per thread)
    // To find Realm File, enter the following when debugger is paused:
    // po Realm.Configuration.defaultConfiguration.fileURL
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? RecipeDetailViewController
        }
        
//        switch(recipesTypeSegCntrl.selectedSegmentIndex){
//        case 0:
//            let test = realm.objects(Recipe.self)
//            self.recipes = Array(test)
//            
//            break
//        case 1:
            loadRecipes()
//            break
//        default:
//            break
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadRecipes() {
                switch(recipesTypeSegCntrl.selectedSegmentIndex){
                case 0:
                    let test = realm.objects(Recipe.self)
                    self.recipes = Array(test)
        
                    break
                case 1:
        SpoonacularAPIManager.sharedInstance.fetchRandomRecipes(numberOfRecipes: NUMBER_OF_RECIPES).then { result -> Void in
            self.recipes = result
            self.detailViewController?.detailItem = self.recipes[0] // Default selected recipe
            self.tableView.reloadData()
            }.catch { error in
                print(error)
        }
                    break
                default:
                    break
                }
    
        
    }
    
    
    func handleLoadRecipesError(_ error: Error) {
        // TODO: show error
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(_ sender: Any) {
        let alert = UIAlertController(title: "Not Implemented",
                                      message: "Can't create new recipes yet, will implement later",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        //        recipes.insert(NSDate(), at: 0)
        //        let indexPath = IndexPath(row: 0, section: 0)
        //        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func recipesTypeSegCntrlChanged(_ sender: UISegmentedControl) {
        loadRecipes()
        tableView.reloadData()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let recipe = recipes[indexPath.row]
                if let controller = (segue.destination as! UINavigationController).topViewController as? RecipeDetailViewController {
                    controller.detailItem = recipe
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = recipes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecipeTableViewCell
        cell.initWithModel(model: recipe)
        return cell
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
    
    
}

