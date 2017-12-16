//
//  AddRecipeToMealPlanTableViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 11/26/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit
import RealmSwift

class AddRecipeToMealPlanTableViewController: UITableViewController {
    //let calTBC: CalendarTableViewCell?
    let realm = try! Realm()
    var selectedRecipe = Recipe()
    let POSITION_RECIPE = (SECTION: 0, ROW: 0)
    let POSITION_CALENDAR = (SECTION: 1, ROW: 0)
    let POSITION_DAYS = (SECTION: 2, ROW: 0)
    
    let startDate = Date()
    var days = [Date]()
    
    @IBAction func btnWeekBackClicked(_ sender: Any) {
        days = generateDates(startDate: days[0], addbyUnit: .day, numberOfDays: -7)
        let children = self.childViewControllers
        print("test")
//        if let vc = calTBC {
//            vc.days = days
//        }
        
    }
    
    @IBAction func btnWeekFrwdClicked(_ sender: Any) {
        days = generateDates(startDate: days[0], addbyUnit: .day, numberOfDays: 7)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        days = generateDates(startDate: startDate, addbyUnit: .day, numberOfDays: 7)
    }
    
    func generateDates( startDate: Date?, addbyUnit: Calendar.Component, numberOfDays: Int) -> [Date] {
        var dates = [Date]()
        var date = startDate!
        let endDate = Calendar.current.date(byAdding: addbyUnit, value: numberOfDays, to: date)!
        while date < endDate {
            date = Calendar.current.date(byAdding: addbyUnit, value: 1, to: date)!
            dates.append(date)
        }
        return dates
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
//        var mealTypesStr = ""
//        for mealType in selectedMealTypes {
//            mealTypesStr.append("\(mealType.displayName()), ")
//
//            let newScheduledMeal = ScheduledMeal()
//            let realmRecipe = realm.objects(Recipe.self).filter("id == %@", selectedRecipe.id)
//            if realmRecipe.count > 0 {
//                newScheduledMeal.recipe = realmRecipe[0] as Recipe
//            } else {
//                newScheduledMeal.recipe = selectedRecipe
//            }
//            newScheduledMeal.mealTypeRaw = mealType.rawValue
//            newScheduledMeal.scheduledDate = selectedDate
//
//            // Add newScheduledMeal to meal plan
//            try! self.realm.write {
//                self.realm.create(ScheduledMeal.self, value: newScheduledMeal)
//                print("\(selectedRecipe.title) is added to meal plan for date \(selectedDate.withoutTime()) for \(mealTypesStr)")
//                dismiss(animated: true, completion: nil)
//
//                if let recipeOnMealPlan = realm.object(ofType: Recipe.self, forPrimaryKey: selectedRecipe.id) {
//                    recipeOnMealPlan.isOnMealPlan = true
//                }//TODO:  check this
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case POSITION_RECIPE.SECTION:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! RecipeTitleTableViewCell
            cell.initWithModel(model: selectedRecipe)
            return cell
//            return cellRecipe
            
        case POSITION_CALENDAR.SECTION:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! CalendarTableViewCell
            cell.initWithModel(days: days)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DayTableViewCell
            cell.initWithModel(dayHeadline: days[indexPath.row])
            return cell
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 44 // Default
        if indexPath.section == POSITION_RECIPE.SECTION {
            height = 85
        }
        else if indexPath.section == POSITION_CALENDAR.SECTION {
            height = 90
        }
        return height
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case POSITION_DAYS.SECTION:
            return days.count
        default:
            return 1
        }
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "addRecipeToMealPlanSegue" {
//            if let controller = (segue.destination as! UINavigationController).topViewController as? AddRecipeToMealPlanTableViewController {
//                if let detail = self.detailItem {
//
//                    controller.selectedRecipe = detail
//                }
//            }
//        } else if segue.identifier == "titleSegue" {
//            recipeTitleViewController = segue.destination as? RecipeTitleViewController
//            if let detail = self.detailItem {
//                recipeTitleViewController?.setCurrentRecipe(newRecipe: detail)
//                recipeTitleViewController?.view.translatesAutoresizingMaskIntoConstraints = false
//                recipeTitleViewController?.delegate = self
//            }
//        } else if segue.identifier == "tabsSegue" {
//            recipeTabsViewController = segue.destination as? RecipeTabsViewController
//            if let detail = self.detailItem {
//                recipeTabsViewController?.setCurrentRecipe(newRecipe: detail)
//                recipeTabsViewController?.view.translatesAutoresizingMaskIntoConstraints = false
//            }
//        }
//    }


}
