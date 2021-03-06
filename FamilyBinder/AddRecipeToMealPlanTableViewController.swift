//
//  AddRecipeToMealPlanTableViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 11/26/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit
import RealmSwift

class AddRecipeToMealPlanTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SelectDayDelegate, MealPlanDelegate, ScheduleOptionDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addBtn: UIBarButtonItem!
    
    
    var calTVC: CalendarTableViewCell = CalendarTableViewCell()
    let realm = try! Realm()
    let mealPlanService = MealPlanService()
    var selectedRecipe = Recipe()
    var selectedMealPlan = MealPlan()
    var selectedScheduleOption = ScheduleOption.now
    var existingScheduledMeals = [ScheduledMeal]()
    let POSITION_MEALPLAN = (SECTION: 0, ROW: 0)
    let POSITION_SCHEDULE_OPTION = (SECTION: 1, ROW: 0)
    let POSITION_RECIPE = (SECTION: 2, ROW: 0)
    let POSITION_CALENDAR = (SECTION: 3, ROW: 0)
    let POSITION_DAYS = (SECTION: 4, ROW: 0)
    
    let startDate = Date()
    var days = [Date]()
    var selections = [Selection]()
    
    var mealTypeCircleButtons = [CircleButton]()
    var mealCircleMenuView : CircleMenuView?
    var initialPoint = CGPoint(x: 0, y: 0)
    var scrollVerticalOffset = CGFloat(0.0)
    var selectedInnerIndexPath : IndexPath? = IndexPath()
    
    
    convenience init(){
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.tableView.addGestureRecognizer(longPressGesture)
        
        // Meal Time Circle Menu
        let testColors = [UIColor.lightGray.cgColor, UIColor.lightGray.cgColor,UIColor.lightGray.cgColor, UIColor.lightGray.cgColor]
        var mealCircleIds = [String]()
        var mealCircleImages = [UIImage]()
        for mealType in MealType.allTypes {
            mealCircleIds.append(mealType.rawValue)
            let mealCircleImage = mealPlanService.getImageForMealTypeOn(mealType: mealType)
            mealCircleImages.append(mealCircleImage)
        }
        mealCircleMenuView = CircleMenuView(ids: mealCircleIds, fillColors: testColors, containerView: self.view, circleImages: mealCircleImages)
    }
    
    @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer){
        var selectedCellRect : CGRect?
        let currentPoint = longPressGesture.location(in: self.tableView)
        let currentPointInMainView = self.tableView.convert(currentPoint, to: self.view)
        
        if (longPressGesture.state == UIGestureRecognizerState.began) {
            self.initialPoint = currentPoint
            selectedInnerIndexPath = getInnerIndexPath(selectedPoint: initialPoint)
            if let selectedInnerIndexPath = selectedInnerIndexPath {
                selectedCellRect = getCellRect(forInnerIndexPath: selectedInnerIndexPath, selectedPoint: initialPoint)
                if let selectedCellRect = selectedCellRect {
                    longPressBegan(startingLocation: currentPoint, backgroundRect: selectedCellRect)
                }
            }
            
        } else if (longPressGesture.state == .changed) {
            longPressChanged(updatedLocation: currentPointInMainView)
        }
            
        else if (longPressGesture.state == UIGestureRecognizerState.ended) {
            longPressEnded(endingLocation: currentPointInMainView)
            dismissCircleMenu()
        }
    }
    
    func longPressBegan(startingLocation: CGPoint, backgroundRect: CGRect) {
        if let menu = mealCircleMenuView {
            menu.setCircleMenuLocation(touchPoint: startingLocation, sourceRect: backgroundRect)
            self.view.addSubview(menu)
        }
    }
    
    func longPressChanged(updatedLocation: CGPoint){
        if let menu = mealCircleMenuView {
            let pointInCircleMenuView = view.convert(updatedLocation, to: menu)
            menu.touchMoved(newPosition: pointInCircleMenuView)
        }
    }
    
    func longPressEnded(endingLocation: CGPoint){
        if let selectedInnerIndexPath = selectedInnerIndexPath {
            if let menu = mealCircleMenuView {
                let pointInCircleMenuView = view.convert(endingLocation, to: menu)
                if let selectedMealButton = menu.touchEnded(finalPosition: pointInCircleMenuView)
                {
                    didSelectWithLongPress(selectedMealButton: selectedMealButton, selectedInnerIndexPath: selectedInnerIndexPath)
                } else {
                    didSelectWithLongPress( selectedMealButton: nil, selectedInnerIndexPath: selectedInnerIndexPath)
                }
            }
        }
    }
    
    func didSelectWithLongPress(selectedMealButton: CircleButton?, selectedInnerIndexPath: IndexPath){
        if let selectedMealButton = selectedMealButton {
            print("selected \(days[selectedInnerIndexPath.row]) \(String(describing: MealType(rawValue: selectedMealButton.id) ))")
            addMealToSelections(selectedDate: days[selectedInnerIndexPath.row], mealType: MealType(rawValue: selectedMealButton.id))
        } else {
            print("selected \(days[selectedInnerIndexPath.row]))")
            addMealToSelections(selectedDate: days[selectedInnerIndexPath.row], mealType: nil)
        }
        
        updateTableForSelection(selectedDay: days[selectedInnerIndexPath.row])
        if let collectionRowToSelect = mealPlanService.getIndex(forDate: days[selectedInnerIndexPath.row], fromDates: days) {
            let collectionCellIndexToSelect = IndexPath(row: collectionRowToSelect, section: 0)
            calTVC.collectionView.selectItem(at: collectionCellIndexToSelect, animated: true, scrollPosition: [])
        }
    }
    
    func getCellRect(forInnerIndexPath: IndexPath, selectedPoint: CGPoint) -> CGRect {
        var cellRect = CGRect()
        if let indexPathInOuterTable = self.tableView.indexPathForRow(at: selectedPoint) {
            if indexPathInOuterTable.section == POSITION_CALENDAR.SECTION {
                let originalCellRect = self.calTVC.collectionView.layoutAttributesForItem(at: forInnerIndexPath)?.frame
                cellRect = self.calTVC.collectionView.convert(originalCellRect!, to: self.view)
            } else if indexPathInOuterTable.section == POSITION_DAYS.SECTION {
                let originalCellRect = self.tableView.rectForRow(at: forInnerIndexPath)
                cellRect = self.tableView.convert(originalCellRect, to: self.view)
            }
        }
        return cellRect
    }
    
    
    func getInnerIndexPath(selectedPoint: CGPoint) -> IndexPath? {
        var selectedIndexPathInInnerTable = IndexPath()
        if let indexPathInOuterTable = self.tableView.indexPathForRow(at: selectedPoint) {
            switch indexPathInOuterTable.section {
                
            case POSITION_CALENDAR.SECTION:
                let adjustedSelectedPoint = self.tableView.convert(selectedPoint, to: self.view)
                let pointInCollectionView = view.convert(adjustedSelectedPoint, to: calTVC.collectionView)
                selectedIndexPathInInnerTable = calTVC.collectionView.indexPathForItem(at: pointInCollectionView)!
                if let collectionRowToSelect = mealPlanService.getIndex(forDate: days[selectedIndexPathInInnerTable.row], fromDates: days) {
                    let collectionCellIndexToSelect = IndexPath(row: collectionRowToSelect, section: 0)
                    calTVC.collectionView.selectItem(at: collectionCellIndexToSelect, animated: true, scrollPosition: [])
                }
                
            case POSITION_DAYS.SECTION:
                selectedIndexPathInInnerTable = self.tableView.indexPathForRow(at: selectedPoint)!
                
            default:
                print("Long press outside of selectable area")
                return nil
            }
        }
        return selectedIndexPathInInnerTable
    }
    
    
    // Handle selection/deselections on table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case POSITION_MEALPLAN.SECTION:
            self.performSegue(withIdentifier: "mealPlansSegue", sender: self)
            return
            
        case POSITION_SCHEDULE_OPTION.SECTION:
            self.performSegue(withIdentifier: "scheduleOptionSegue", sender: self)
            return
            
        case POSITION_DAYS.SECTION:
            addMealToSelections(selectedDate: days[indexPath.row], mealType: nil)
            if let collectionRowToSelect = mealPlanService.getIndex(forDate: days[indexPath.row], fromDates: days) {
                let collectionCellIndexToSelect = IndexPath(row: collectionRowToSelect, section: 0)
                calTVC.collectionView.selectItem(at: collectionCellIndexToSelect, animated: true, scrollPosition: [])
            }
            return
            
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        removeFromSelection(deselectedDate: days[indexPath.row])
        if let collectionRowToDeselect = mealPlanService.getIndex(forDate: days[indexPath.row], fromDates: days) {
            let collectionCellIndexToDeselect = IndexPath(row: collectionRowToDeselect, section: 0)
            calTVC.collectionView.deselectItem(at: collectionCellIndexToDeselect, animated: true)
            self.tableView.reloadData()
        }
    }
    
    // Update table when collection has updates
    func updateTableForSelection(selectedDay: Date) {
        addMealToSelections(selectedDate: selectedDay, mealType: nil)
        if let tableRowToSelect = mealPlanService.getIndex(forDate: selectedDay, fromDates: days) {
            let tableIndexToSelect = IndexPath(row: tableRowToSelect, section: POSITION_DAYS.SECTION)
            self.tableView.selectRow(at: tableIndexToSelect, animated: true, scrollPosition: .none)
        }
    }
    
    func updateTableForDeselection(deselectedDay: Date) {
        removeFromSelection(deselectedDate: deselectedDay)
        if let tableRowToDeselect = mealPlanService.getIndex(forDate: deselectedDay, fromDates: days) {
            let tableIndexToDeselect = IndexPath(row: tableRowToDeselect, section: POSITION_DAYS.SECTION)
            self.tableView.deselectRow(at: tableIndexToDeselect, animated: true)
            self.tableView.reloadData()
        }
    }
    
    
    // Manage shared selections
    func addMealToSelections(selectedDate: Date, mealType: MealType?) {
        // Prevent a selection from being added twice- one from long press and other from normal table selection
        if let sameDaySelection = selections.first(where: { $0.date == selectedDate}) {
            // Recipe already added for this day, so only update the selection to add mealtype if it is provided
            if let mealType = mealType {
                sameDaySelection.mealType = mealType
            }
        } else {
            // Recipe not added yet for this day, so append it like normal
            let newSelection = Selection()
            newSelection.date = selectedDate
            if let mealType = mealType {
                newSelection.mealType = mealType
            }
            selections.append(newSelection)
        }
        self.tableView.reloadSections(IndexSet(integersIn: POSITION_DAYS.SECTION...POSITION_DAYS.SECTION), with: .automatic)
    }
    
    func removeFromSelection(deselectedDate: Date) {
        if let indexToRemove = selections.index(where: { (selection) -> Bool in
            selection.date == deselectedDate
        }) {
            selections.remove(at: indexToRemove)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissCircleMenu()
        self.scrollVerticalOffset = scrollView.contentOffset.y
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
    
    
    // MARK: - Delegate Functions
    func mealPlanSelected(selectedMealPlan: MealPlan) {
        self.selectedMealPlan = selectedMealPlan
        self.tableView.reloadData()
    }
    
    func scheduleOptionSelected(selectedScheduleOption: ScheduleOption) {
        self.selectedScheduleOption = selectedScheduleOption
        self.tableView.reloadData()
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mealPlansSegue") {
            let mealPlansTableViewController: MealPlansTableViewController = segue.destination as! MealPlansTableViewController
            mealPlansTableViewController.selectedMealPlan = self.selectedMealPlan
        }
        
        if (segue.identifier == "scheduleOptionSegue") {
            let scheduleOptionTableViewController: ScheduleOptionTableViewController = segue.destination as! ScheduleOptionTableViewController
            scheduleOptionTableViewController.selectedScheduleOption = self.selectedScheduleOption
            scheduleOptionTableViewController.scheduleOptionDelegate = self
        }
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        for selection in selections {
            print("Selected \(selection.date)")
            mealPlanService.addRecipeToMealPlan(recipe: selectedRecipe, mealType: selection.mealType, scheduledDate: selection.date, mealPlan: selectedMealPlan)
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
            
        case POSITION_SCHEDULE_OPTION.SECTION:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! ScheduleOptionSelectedTableViewCell
            cell.initWithModel(selectedScheduleOption: selectedScheduleOption)
            return cell
            
        case POSITION_CALENDAR.SECTION:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! CalendarTableViewCell
            cell.initWithModel(days: days)
            cell.selectDayDelegate = self
            calTVC = cell
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DayTableViewCell
            
            var existingMealsForDay: [ScheduledMeal]
            existingMealsForDay = Array(selectedMealPlan.meals.filter { $0.scheduledDate.withoutTime() == self.days[indexPath.row].withoutTime() })
            
            // get other existing meals in the selections that have not yet been added to the meal plan
            if let existingMealInSelections = selections.first(where: { $0.date.withoutTime() == self.days[indexPath.row].withoutTime()}) {
                
                if let mealNotYetOnMealPlan = ScheduledMeal(recipe: selectedRecipe, scheduledDate: existingMealInSelections.date, mealType: existingMealInSelections.mealType) {
                    existingMealsForDay.append(mealNotYetOnMealPlan)
                }
            }
            
            existingMealsForDay.sort(by: {($0.mealType?.sortOrder() ?? 100) < ($1.mealType?.sortOrder() ?? 100)})
            cell.initWithModel(dayHeadline: days[indexPath.row], existingMeals: existingMealsForDay)
            
            if days[indexPath.row].withoutTime() >= Date().withoutTime() {
                let isSelected = selections.contains(where: { (selection) -> Bool in
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
            if days[indexPath.row].withoutTime() >= Date().withoutTime() {
                height = UITableViewAutomaticDimension
            } else {
                // hide days in the past
                height = 0
            }
        default:
            height = 44
        }
        return height
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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

