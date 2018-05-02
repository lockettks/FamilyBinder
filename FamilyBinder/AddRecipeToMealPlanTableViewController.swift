//
//  AddRecipeToMealPlanTableViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 11/26/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit
import RealmSwift

class AddRecipeToMealPlanTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SelectDayDelegate, MealPlanSelectedDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addBtn: UIBarButtonItem!
    
    
    var calTVC: CalendarTableViewCell = CalendarTableViewCell()
    let realm = try! Realm()
    let mealPlanService = MealPlanService()
    var selectedRecipe = Recipe()
    var selectedMealPlan = MealPlan()
    var existingScheduledMeals = [ScheduledMeal]()
    let POSITION_MEALPLAN = (SECTION: 0, ROW: 0)
    let POSITION_RECIPE = (SECTION: 1, ROW: 0)
    let POSITION_CALENDAR = (SECTION: 2, ROW: 0)
    let POSITION_DAYS = (SECTION: 3, ROW: 0)
    
    let startDate = Date()
    var days = [Date]()
    var selectedDays = [Selection]()
    
    let circleMenuService = CircleMenuService()
    var mealTypeCircleButtons = [CircleButton]()
    var mealCircleMenuView : CircleMenuView?
    var selectedRow : IndexPath?
    
    
    convenience init(){
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Long Press
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.tableView.addGestureRecognizer(longPressGesture)
        
        self.view.backgroundColor = UIColor.green
    }
    
    @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer){
        let p = longPressGesture.location(in: self.tableView)

        if self.tableView.indexPathForRow(at: p) == nil { //TODO:  Allow long press on collection cells too
            print("Long press on table view, not row")
        } else if (longPressGesture.state == UIGestureRecognizerState.began) {
            selectedRow = self.tableView.indexPathForRow(at: p)
            if let selectedRow = selectedRow {
                
                let adjustedPosition = CGPoint(x: p.x, y: p.y + 64)
                
                print("long press began at row \(selectedRow.row) on date \(days[selectedRow.row]), location \(p)")
                
                let tapOutsideCircleMenu = UITapGestureRecognizer(target: self, action: #selector(dismissCircleMenu))
                self.view.addGestureRecognizer(tapOutsideCircleMenu)
                
                // Meal Time Circle Menu
                let testColors = [UIColor.lightGray.cgColor, UIColor.lightGray.cgColor,UIColor.lightGray.cgColor, UIColor.lightGray.cgColor]
                var mealCircleIds = [String]()
                
                var mealCircleImages = [UIImage]()
                for mealType in MealType.allTypes {
                    mealCircleIds.append(mealType.rawValue)
                    let mealCircleImage = circleMenuService.getImageForMealTypeOn(mealType: mealType)
                    mealCircleImages.append(mealCircleImage)
                }
                
                mealCircleMenuView = CircleMenuView(touchPoint: adjustedPosition, ids: mealCircleIds, fillColors: testColors, circleImages: mealCircleImages)
                if let menu = mealCircleMenuView {
                    self.view.addSubview(menu)
                }
            }
            
        } else if (longPressGesture.state == .changed) {
            // TODO:  Remove need for adjusting position
            let adjustedPosition = CGPoint(x: p.x, y: p.y + 64)
            
            if let menu = mealCircleMenuView {
                let convertedPosition = view.convert(adjustedPosition, to: menu)
                menu.touchMoved(newPosition: convertedPosition)
            }
        }
        else if (longPressGesture.state == UIGestureRecognizerState.ended) {
            if let selectedRow = selectedRow {
                print("final press ended at row \(selectedRow.row) on date \(days[(selectedRow.row)]), location \(p)")
                let adjustedPosition = CGPoint(x: p.x, y: p.y + 64)
                
                if let menu = mealCircleMenuView {
                    let convertedPosition = view.convert(adjustedPosition, to: menu)
                    if let selectedMealButton = menu.touchEnded(finalPosition: convertedPosition)
                    {
                        print("\n--->selected meal type \(selectedMealButton.id)")
                        
                        let newSelection = Selection()
                        newSelection.date = days[selectedRow.row]
                        newSelection.mealType = MealType(rawValue: selectedMealButton.id)
                        addToSelection(selectedDay: newSelection)
//                        calTVC.tableRowSelected(selectedDay: newSelection)
//                        calTVC.tableRowSelected(indexOfSelected: selectedRow.row)
                        dayCollectionCellSelected(selectedDay: days[selectedRow.row])
                    }
                }
                dismissCircleMenu()
            }
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mealTypeCircleButtons.count > 0 {
            dismissCircleMenu()
        }
    }
    
    @objc func dismissCircleMenu(){
        if let menu = mealCircleMenuView {
            menu.removeFromSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        days = mealPlanService.generateDates(anchorDate: startDate, addbyUnit: .day, numberOfDays: 14)
        if let defaultMealPlan = realm.objects(User.self).first?.defaultMealPlan {
            self.selectedMealPlan = defaultMealPlan
        }
    }
    
    @IBAction func btnWeekBackClicked(_ sender: Any) {
        let lastWeekEndDate = Calendar.current.date(byAdding: .day, value: -1, to: days[0])!
        days = mealPlanService.generateDates(anchorDate: lastWeekEndDate, addbyUnit: .day, numberOfDays: 15)
        _ = days.popLast()
        calTVC.days = days
        
        let calendarIndexPath = IndexPath(item: POSITION_CALENDAR.ROW, section: POSITION_CALENDAR.SECTION)
        self.tableView.reloadRows(at: [calendarIndexPath], with: .right)
        
        self.tableView.reloadSections(IndexSet(integersIn: POSITION_DAYS.SECTION...POSITION_DAYS.SECTION), with: .bottom)
    }
    
    @IBAction func btnWeekFrwdClicked(_ sender: Any) {
        let nextWeekStartDate = Calendar.current.date(byAdding: .day, value: 1, to: days[6])!
        days = mealPlanService.generateDates(anchorDate: nextWeekStartDate, addbyUnit: .day, numberOfDays: 14)
        calTVC.days = days
        
        let calendarIndexPath = IndexPath(item: POSITION_CALENDAR.ROW, section: POSITION_CALENDAR.SECTION)
        self.tableView.reloadRows(at: [calendarIndexPath], with: .left)
        
        self.tableView.reloadSections(IndexSet(integersIn: POSITION_DAYS.SECTION...POSITION_DAYS.SECTION), with: .bottom)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case POSITION_MEALPLAN.SECTION:
            self.performSegue(withIdentifier: "mealPlansSegue", sender: self)
            return
            
        case POSITION_DAYS.SECTION:
            if let collectionRowToSelect = mealPlanService.getIndex(forDate: days[indexPath.row], fromDates: days) {
                let collectionCellIndexToSelect = IndexPath(row: collectionRowToSelect, section: 0)
                calTVC.collectionView.selectItem(at: collectionCellIndexToSelect, animated: true, scrollPosition: [])
            }
//            if days[indexPath.row].withoutTime() >= Date().withoutTime() {
//                let newSelection = Selection()
//                newSelection.date = days[indexPath.row]
//                addToSelection(selectedDay: newSelection)
////                calTVC.tableRowSelected(indexOfSelected: indexPath.row)  //TODO:  Send selectedDay instead of index
//                calTVC.tableRowSelected(selectedDay: newSelection)
//            }
            return
            
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let collectionRowToDeselect = mealPlanService.getIndex(forDate: days[indexPath.row], fromDates: days) {
            let collectionCellIndexToDeselect = IndexPath(row: collectionRowToDeselect, section: 0)
            calTVC.collectionView.deselectItem(at: collectionCellIndexToDeselect, animated: true)
        }
        
//        if (indexPath.section == POSITION_DAYS.SECTION) {
//            let deselectedRow = Selection()
//            deselectedRow.date = days[indexPath.row]
//            removeFromSelection(deselectedDay: deselectedRow)
//            calTVC.tableRowDeselected(indexOfDeselected: indexPath.row)
//        }
    }
    
    func mealPlanSelected(selectedMealPlan: MealPlan) {
        self.selectedMealPlan = selectedMealPlan
    }
    
    
    func dayCollectionCellSelected(selectedDay: Date) {
        if let tableRowToSelect = mealPlanService.getIndex(forDate: selectedDay, fromDates: days) {
            let tableIndexToSelect = IndexPath(row: tableRowToSelect, section: POSITION_DAYS.SECTION)
            self.tableView.selectRow(at: tableIndexToSelect, animated: true, scrollPosition: .none)
        }
        
        /*
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
        */
    }
    
    func dayCollectionCellDeselected(deselectedDay: Date) {
        if let tableRowToDeselect = mealPlanService.getIndex(forDate: deselectedDay, fromDates: days) {
            let tableIndexToDeselect = IndexPath(row: tableRowToDeselect, section: POSITION_DAYS.SECTION)
            self.tableView.deselectRow(at: tableIndexToDeselect, animated: true)
        }
        
        
//        if deselectedDay.date.withoutTime() >= Date().withoutTime(){
//            removeFromSelection(deselectedDay: deselectedDay)
//
//            let daysIndexToDeselect = days.index(where: { (day) -> Bool in
//                day == deselectedDay.date
//            })
//            if let deselectedIndex = daysIndexToDeselect {
//                let rowToDeselect = IndexPath(row: deselectedIndex, section: POSITION_DAYS.SECTION)
//                self.tableView.deselectRow(at: rowToDeselect, animated: true)
//            }
//        }
    }
    
    
    func addToSelection(selectedDay: Selection) {
        selectedDays.append(selectedDay)
    }
    
    func removeFromSelection(deselectedDay: Selection) {
        if let indexToRemove = selectedDays.index(where: { (selection) -> Bool in
            selection.date == deselectedDay.date
        }) {
            selectedDays.remove(at: indexToRemove)
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mealPlansSegue") {
            let mealPlansTableViewController: MealPlansTableViewController = segue.destination as! MealPlansTableViewController
            mealPlansTableViewController.selectedMealPlan = selectedMealPlan
        }
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        for selectedDay in selectedDays {
            print("Selected \(selectedDay.date)")
            mealPlanService.addRecipeToMealPlan(recipe: selectedRecipe, scheduledDate: selectedDay.date, mealPlan: selectedMealPlan)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            
            let existingMealsForDay: [ScheduledMeal]
            existingMealsForDay = Array(selectedMealPlan.meals.filter { $0.scheduledDate.withoutTime() == self.days[indexPath.row].withoutTime() })
            
            cell.initWithModel(dayHeadline: days[indexPath.row], existingMeals: existingMealsForDay)
            
            if days[indexPath.row] >= Date() {
                let isSelected = selectedDays.contains(where: { (selection) -> Bool in
                    selection.date == days[indexPath.row]
                })
                // check if any days are already selected
                if isSelected {
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    calTVC.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                }
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == POSITION_DAYS.SECTION) {
            return 120
        } else {
            return 44
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat
        switch indexPath.section {
        case POSITION_RECIPE.SECTION:
            height = 85
        case POSITION_CALENDAR.SECTION:
            height = 200
        case POSITION_DAYS.SECTION:
            if days[indexPath.row] < Date() {
                // hide days in the past
                height = 0
            } else {
                height = UITableViewAutomaticDimension
            }
        default:
            height = 44
        }
        return height
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

