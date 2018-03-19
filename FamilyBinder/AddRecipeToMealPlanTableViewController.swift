//
//  AddRecipeToMealPlanTableViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 11/26/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit
import RealmSwift

class AddRecipeToMealPlanTableViewController: UITableViewController, SelectDayDelegate, MealPlanSelectedDelegate {
    var calTVC: CalendarTableViewCell = CalendarTableViewCell()
    let realm = try! Realm()
    var selectedRecipe = Recipe()
    var selectedMealPlan = MealPlan()
    let POSITION_MEALPLAN = (SECTION: 0, ROW: 0)
    let POSITION_RECIPE = (SECTION: 1, ROW: 0)
    let POSITION_CALENDAR = (SECTION: 2, ROW: 0)
    let POSITION_DAYS = (SECTION: 3, ROW: 0)
    
    let startDate = Date()
    var days = [Date]()
    var selections = [Selection]()
    
    @IBAction func btnWeekBackClicked(_ sender: Any) {
        let lastWeekEndDate = Calendar.current.date(byAdding: .day, value: -1, to: days[0])!
        days = generateDates(anchorDate: lastWeekEndDate, addbyUnit: .day, numberOfDays: 15)
        _ = days.popLast()
        calTVC.days = days
        
        let calendarIndexPath = IndexPath(item: POSITION_CALENDAR.ROW, section: POSITION_CALENDAR.SECTION)
        self.tableView.reloadRows(at: [calendarIndexPath], with: .right)
        
        self.tableView.reloadSections(IndexSet(integersIn: POSITION_DAYS.SECTION...POSITION_DAYS.SECTION), with: .bottom)
        
    }
    
    @IBAction func btnWeekFrwdClicked(_ sender: Any) {
        let nextWeekStartDate = Calendar.current.date(byAdding: .day, value: 1, to: days[6])!
        days = generateDates(anchorDate: nextWeekStartDate, addbyUnit: .day, numberOfDays: 14)
        calTVC.days = days
        
        let calendarIndexPath = IndexPath(item: POSITION_CALENDAR.ROW, section: POSITION_CALENDAR.SECTION)
        self.tableView.reloadRows(at: [calendarIndexPath], with: .left)
        
        self.tableView.reloadSections(IndexSet(integersIn: POSITION_DAYS.SECTION...POSITION_DAYS.SECTION), with: .bottom)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case POSITION_MEALPLAN.SECTION:
            self.performSegue(withIdentifier: "mealPlansSegue", sender: self)
            return
            
        case POSITION_CALENDAR.SECTION, POSITION_DAYS.SECTION:
            if days[indexPath.row].withoutTime() >= Date().withoutTime() {
                let newSelection = Selection()
                newSelection.date = days[indexPath.row]
                addToSelection(selectedDay: newSelection)
                
                calTVC.tableRowSelected(indexOfSelected: indexPath.row)
            }
            return
            
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (indexPath.section == POSITION_DAYS.SECTION) {
            let deselectedRow = Selection()
            deselectedRow.date = days[indexPath.row]
            removeFromSelection(deselectedDay: deselectedRow)
            calTVC.tableRowDeselected(indexOfDeselected: indexPath.row)
        }
    }
    
    func mealPlanSelected(selectedMealPlan: MealPlan) {
        self.selectedMealPlan = selectedMealPlan
    }
    
    
    func dayCollectionCellSelected(selectedDay: Selection) {
        if selectedDay.date.withoutTime() >= Date().withoutTime() {
            addToSelection(selectedDay: selectedDay)
            
            let index = days.index(where: { (day) -> Bool in
                day == selectedDay.date
            })
            if let selectedCell = index {
                let rowToSelect = IndexPath(row: selectedCell, section: POSITION_DAYS.SECTION)
                self.tableView.selectRow(at: rowToSelect, animated: true, scrollPosition: .none)
            }
        }
    }
    
    func dayCollectionCellDeselected(deselectedDay: Selection) {
        if deselectedDay.date.withoutTime() >= Date().withoutTime(){
            removeFromSelection(deselectedDay: deselectedDay)
            
            let daysIndexToDeselect = days.index(where: { (day) -> Bool in
                day == deselectedDay.date
            })
            if let deselectedIndex = daysIndexToDeselect {
                let rowToDeselect = IndexPath(row: deselectedIndex, section: POSITION_DAYS.SECTION)
                self.tableView.deselectRow(at: rowToDeselect, animated: true)
            }
        }
    }
    
    
    func addToSelection(selectedDay: Selection) {
        selections.append(selectedDay)
    }
    
    func removeFromSelection(deselectedDay: Selection) {
        if let indexToRemove = selections.index(where: { (selection) -> Bool in
            selection.date == deselectedDay.date
        }) {
            selections.remove(at: indexToRemove)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        days = generateDates(anchorDate: startDate, addbyUnit: .day, numberOfDays: 14)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "mealPlansSegue") {
            let mealPlansTableViewController: MealPlansTableViewController = segue.destination as! MealPlansTableViewController
            mealPlansTableViewController.selectedMealPlan = selectedMealPlan
            
        }
    }
    
    
    func generateDates( anchorDate: Date, addbyUnit: Calendar.Component, numberOfDays: Int) -> [Date] {
        var dates = [Date]()
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.timeZone = TimeZone.current
        weekdayFormatter.dateFormat = "EEE"
        let weekday = weekdayFormatter.string(from: anchorDate)
        
        if let firstSundayFromAnchor = anchorDate.startOfWeek {
            if let anchorDate2 = Calendar.current.date(byAdding: addbyUnit, value: numberOfDays, to: firstSundayFromAnchor) {
                let startDate = min(firstSundayFromAnchor, anchorDate2)
                let endDate = max(firstSundayFromAnchor, anchorDate2)
                var date = startDate
                
                while date < endDate {
                    dates.append(date)
                    date = Calendar.current.date(byAdding: addbyUnit, value: 1, to: date)!
                }
            }
        }
        return dates
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        for selection in selections {
            print("Selected \(selection.date)")
            let newScheduledMeal = ScheduledMeal()
            let realmRecipe = realm.objects(Recipe.self).filter("id == %@", selectedRecipe.id)
            if realmRecipe.count > 0 {
                newScheduledMeal.recipe = realmRecipe[0] as Recipe
            } else {
                newScheduledMeal.recipe = selectedRecipe
            }
            newScheduledMeal.scheduledDate = selection.date
            
            // Add newScheduledMeal to meal plan
            
            try! self.realm.write {
                self.realm.create(ScheduledMeal.self, value: newScheduledMeal)
                print("\(newScheduledMeal.recipe?.title) is added to meal plan for date \(newScheduledMeal.scheduledDate.withoutTime())")
                dismiss(animated: true, completion: nil)
                
                if let recipeOnMealPlan = realm.object(ofType: Recipe.self, forPrimaryKey: selectedRecipe.id) {
                    recipeOnMealPlan.isOnMealPlan = true
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case POSITION_MEALPLAN.SECTION:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! MealPlanSelectedTableViewCell
            cell.initWithModel(selectedMealPlan: selectedMealPlan)
            return cell
            
        case POSITION_RECIPE.SECTION:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! RecipeTitleTableViewCell
            cell.initWithModel(model: selectedRecipe)
            return cell
            
        case POSITION_CALENDAR.SECTION:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! CalendarTableViewCell
            cell.initWithModel(days: days)
            cell.selectDayDelegate = self
            calTVC = cell
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DayTableViewCell
            cell.initWithModel(dayHeadline: days[indexPath.row])
            if days[indexPath.row].withoutTime() < Date().withoutTime() {
                cell.selectionStyle = .none
            } else {
                let isSelected = selections.contains(where: { (selection) -> Bool in
                    selection.date == days[indexPath.row]
                })
                if isSelected {
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    calTVC.tableRowSelected(indexOfSelected: indexPath.row)
                }
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 44
        if indexPath.section == POSITION_RECIPE.SECTION {
            height = 85
        }
        else if indexPath.section == POSITION_CALENDAR.SECTION {
            height = 200
        }
        return height
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
}
