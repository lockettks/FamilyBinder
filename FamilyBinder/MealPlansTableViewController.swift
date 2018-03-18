//
//  MealPlansTableViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 3/15/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import UIKit
import RealmSwift

protocol MealPlanSelectedDelegate : class {
    func mealPlanSelected(selectedMealPlan: MealPlan)
}

class MealPlansTableViewController: UITableViewController {
    
    var selectedMealPlan: MealPlan?
    weak var mealPlanDelegate: MealPlanSelectedDelegate?
    
    
    let myMealPlans: Results<MealPlan> = {
        let realm = try! Realm()
        return realm.objects(MealPlan.self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myMealPlans.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = myMealPlans[indexPath.row].name
        
        if let selectedMealPlan = selectedMealPlan {
            cell.isSelected = myMealPlans[indexPath.row].name == selectedMealPlan.name
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMealPlan = myMealPlans[indexPath.row]
        if let selectedMealPlan = selectedMealPlan {
            mealPlanDelegate?.mealPlanSelected(selectedMealPlan: selectedMealPlan)
        }
        _ = navigationController?.popViewController(animated: true)

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
