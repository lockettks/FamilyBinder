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
    
    var mealTypeCircleButtons = [CircleButton]()
    let mealTypeCircleDiameter = CGFloat(50.0)
    let circleMenuRadius = CGFloat(75.0)
    let circleMenuService = CircleMenuService()
    var firstPosition = CGPoint()
    
    
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
        
        let indexPath = self.tableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row")
        } else if (longPressGesture.state == UIGestureRecognizerState.began) {
            firstPosition = p
            
            
            print("long press on row, at \(indexPath!.row), location \(p)")
            
            
            
            let tapOutsideCircleMenu = UITapGestureRecognizer(target: self, action: #selector(dismissCircleMenu))
            self.view.addGestureRecognizer(tapOutsideCircleMenu)
            
            // Meal Time Circle Menu
            //TODO:  restructure all this
            let mealTypeCircleFrame = CGRect(x: p.x, y: p.y, width: mealTypeCircleDiameter, height: mealTypeCircleDiameter)
            
            let testColors = [UIColor.lightGray.cgColor, UIColor.blue.cgColor,UIColor.cyan.cgColor, UIColor.brown.cgColor]
            
            for (index, mealType) in MealType.allTypes.enumerated() {
                let mealTypeCircleButton = CircleButton(frame: mealTypeCircleFrame, fillColor: testColors[index], mealType: mealType, radius: mealTypeCircleDiameter/2)
                mealTypeCircleButtons.append(mealTypeCircleButton)
                
                mealTypeCircleButton.center = circleMenuService.getCircleLocation(menuRadius: Float(circleMenuRadius), anchorPoint: p, totalCircleCount: Float(MealType.allTypes.count), circleInstanceNumber: Float(index))
                
                view.addSubview(mealTypeCircleButton)
            }

        } else if (longPressGesture.state == .changed) {
            let currentPositionX = p.x
            let currentPositionY = p.y
            
            print("\n\ncurrent position: \(p)")
            
//            let convertedPosition = mealTypeCircleButtons[0].convert(p, to: view)
//            let convertedPosition = view.convert(p, to: mealTypeCircleButtons[0]) //SUCCESS within the button's radus of start point
            let convertedPosition = CGPoint(x: p.x, y: p.y + 64)
            print("converted current position: \(convertedPosition)")

            print("button frame: \(mealTypeCircleButtons[0].frame)")
            
            
//            let isPointOnButton = mealTypeCircleButtons[0].frame.contains(convertedPosition) // SUCCESS-- but for rect, not circle
//            let isPointOnButton = mealTypeCircleButtons[0].bounds.contains(p)
//            let isPointOnButton = mealTypeCircleButtons[0].bounds.contains(convertedPosition) //success
            
            //Using over-ridden method
            let isPointOnButton = mealTypeCircleButtons[0].point(inside: convertedPosition, with: nil)
//            let isPointOnButton = mealTypeCircleButtons[0].point(inside: p, with: nil)

            
            print("Is on button? \(isPointOnButton)")
            
            if isPointOnButton {
                print("-------- SUCCESSSSSSSSSSSSS! --------")
            }
            

        }
        else if (longPressGesture.state == UIGestureRecognizerState.ended) {
            
            print("final position: \(p)")
            let convertedPosition = view.convert(p, to: mealTypeCircleButtons[0])
            print("converted final position: \(convertedPosition)")

            let isPointOnButton = mealTypeCircleButtons[0].point(inside: convertedPosition, with: nil)

            print("button frame \(mealTypeCircleButtons[0].frame)")
            print("Is on button? \(isPointOnButton)")
            if isPointOnButton {
                print("-------- SUCCESSSSSSSSSSSSS! --------")
            }
            
            /*
             for (UIView *row in self.rows) {
             for (UITouch *touch in touches) {
             if ([row pointInside:[touch locationInView:self] withEvent:event]) {
             // Do something here!
             }
             }
             }
 */
            dismissCircleMenu()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mealTypeCircleButtons.count > 0 {
            dismissCircleMenu()
        }
    }
    
    @objc func dismissCircleMenu(){
        print("menu closed")
        for mealTypeCircleButton in mealTypeCircleButtons {
            mealTypeCircleButton.removeFromSuperview()
        }
        mealTypeCircleButtons.removeAll()
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
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
                    calTVC.tableRowSelected(indexOfSelected: indexPath.row)
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

