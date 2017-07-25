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
    
    @IBOutlet weak var lblScheduledDate: UILabel!
    @IBOutlet weak var pickerScheduledDate: UIDatePicker!
    @IBOutlet weak var cellDateLabel: UITableViewCell!
    @IBOutlet weak var cellDatePicker: UITableViewCell!
    @IBOutlet weak var cellBreakfast: UITableViewCell!
    @IBOutlet weak var cellLunch: UITableViewCell!
    @IBOutlet weak var cellSnack: UITableViewCell!
    @IBOutlet weak var cellDinner: UITableViewCell!
    
    var mealTypeCells = [UITableViewCell]()
    
    
    var selectedValue: Date?
    var datePickerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealTypeCells = [cellBreakfast, cellLunch, cellSnack, cellDinner]
        for mealTypeCell in mealTypeCells {
            mealTypeCell.accessoryType = .none
        }
        
        if let val = selectedValue {
            datePickerVisible = true
            pickerScheduledDate.date = val
        } else {
            datePickerVisible = false
        }
        lblScheduledDate.text = Date().withoutTime()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.pickerScheduledDate.isHidden = true
        self.pickerScheduledDate.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 44 // Default
        if indexPath.section == 0 && indexPath.row == 1 {
            height = datePickerVisible ? 216 : 0
        }
        return height
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
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
        if indexPath.section == 1 {
            if let cell = tableView.cellForRow(at: indexPath) {
                
                if (cell.accessoryType == .checkmark){
                    cell.accessoryType = .none;
                } else{
                    cell.accessoryType = .checkmark
                }
            }
        }
        selectedValue = nil
        if indexPath.section == 0 && indexPath.row == 0 {
            showScheduledDatePickerCell(containingDatePicker: pickerScheduledDate)
            selectedValue = pickerScheduledDate.date
            if let labelDate = selectedValue {
                lblScheduledDate.text = labelDate.withoutTime()
            }
        }
        else if datePickerVisible {
            hideScheduledDatePickerCell(containingDatePicker: pickerScheduledDate)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        selectedValue = pickerScheduledDate.date
        lblScheduledDate.text = selectedValue?.withoutTime()
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
}
