//
//  AddToMealPlanTableViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/20/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import UIKit


class AddToMealPlanTableViewController: UITableViewController {
    
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet weak var imgRecipe: UIImageView!
    @IBOutlet weak var lblRecipe: UILabel!
    @IBOutlet weak var lblScheduledDate: UILabel!
    @IBOutlet weak var pickerScheduledDate: UIDatePicker!
    @IBOutlet weak var cellRecipe: UITableViewCell!
    @IBOutlet weak var cellDateLabel: UITableViewCell!
    @IBOutlet weak var cellDatePicker: UITableViewCell!
    @IBOutlet weak var cellBreakfast: UITableViewCell!
    @IBOutlet weak var cellLunch: UITableViewCell!
    @IBOutlet weak var cellSnack: UITableViewCell!
    @IBOutlet weak var cellDinner: UITableViewCell!
    
    var selectedRecipe = Recipe()
    var mealTypeCells = [UITableViewCell]()
    
    var selectedDate = Date()
    var datePickerVisible = false
    var selectedMealTypes = [MealType]()
    
    let RECIPE_POSITION = (SECTION: 0, ROW: 0)
    let DATE_LABEL_POSITION = (SECTION: 1, ROW: 0)
    let DATE_PICKER_POSITION = (SECTION: 1, ROW: 1)
    let MEAL_TYPE_POSITION = (SECTION: 2, ROW: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgRecipe.image = selectedRecipe.image
        lblRecipe.text = selectedRecipe.title
        
        mealTypeCells = [cellBreakfast, cellLunch, cellSnack, cellDinner]
        for mealTypeCell in mealTypeCells {
            mealTypeCell.accessoryType = .none
        }
        
        datePickerVisible = false
        lblScheduledDate.text = Date().withoutTime()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        btnAdd.isEnabled = selectedMealTypes.count > 0
        self.pickerScheduledDate.isHidden = true
        self.pickerScheduledDate.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 44 // Default
        if indexPath.section == RECIPE_POSITION.SECTION {
            height = 80
        } else if indexPath.section == DATE_PICKER_POSITION.SECTION && indexPath.row == DATE_PICKER_POSITION.ROW {
            height = datePickerVisible ? 216 : 0
        }
        return height
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case RECIPE_POSITION.SECTION:
            return cellRecipe
        case DATE_LABEL_POSITION.SECTION:
            switch indexPath.row {
            case DATE_LABEL_POSITION.ROW:
                return cellDateLabel
            default:
                return cellDatePicker
            }
        default:
            mealTypeCells[indexPath.row].textLabel?.text = MealType.allTypes[indexPath.row].displayName()
            return mealTypeCells[indexPath.row]
        }
    }
    
    
    // MARK: - Action Handling
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == MEAL_TYPE_POSITION.SECTION {
            if let cell = tableView.cellForRow(at: indexPath) {
                
                if (cell.accessoryType == .checkmark){
                    cell.accessoryType = .none;
                    if let removedIndex = selectedMealTypes.index(of: MealType.allTypes[indexPath.row]) {
                        selectedMealTypes.remove(at: removedIndex)
                    }
                } else{
                    cell.accessoryType = .checkmark
                    selectedMealTypes.append(MealType.allTypes[indexPath.row])
                }
            }
            btnAdd.isEnabled = selectedMealTypes.count > 0
        }
        if indexPath.section == DATE_LABEL_POSITION.SECTION && indexPath.row == DATE_LABEL_POSITION.ROW {
            showScheduledDatePickerCell(containingDatePicker: pickerScheduledDate)
            selectedDate = pickerScheduledDate.date
            lblScheduledDate.text = selectedDate.withoutTime()
        }
        else if datePickerVisible {
            hideScheduledDatePickerCell(containingDatePicker: pickerScheduledDate)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        selectedDate = pickerScheduledDate.date
        lblScheduledDate.text = selectedDate.withoutTime()
    }
    
    func showScheduledDatePickerCell(containingDatePicker picker:UIDatePicker){
        
        if picker == pickerScheduledDate {
            datePickerVisible = true
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        picker.isHidden = false
        picker.alpha = 0.0
        
        UIView.animate(withDuration: 0.25){
            picker.alpha = 1.0
        }
    }
    
    func hideScheduledDatePickerCell(containingDatePicker picker:UIDatePicker){
        
        if picker == pickerScheduledDate {
            datePickerVisible = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        
        UIView.animate(withDuration: 0.25, animations: {
            picker.alpha = 0.0
        }) { (finished) in
            picker.isHidden = true
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        print("\(selectedRecipe.title) is added to meal plan for date \(selectedDate.withoutTime())")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
