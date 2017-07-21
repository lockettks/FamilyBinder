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
    
    var selectedValue: Date?
    var datePickerVisible = false
    let myFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myFormatter.dateStyle = .short
        if let val = selectedValue {
            datePickerVisible = true
            pickerScheduledDate.date = val
        } else {
            datePickerVisible = false
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pickerScheduledDate.isHidden = true
        self.pickerScheduledDate.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedValue = nil
        if indexPath.section == 0 && indexPath.row == 0 {
            showScheduledDatePickerCell(containingDatePicker: pickerScheduledDate)
            selectedValue = pickerScheduledDate.date
            if let labelDate = selectedValue {
                lblScheduledDate.text = myFormatter.string(from: labelDate)
            }
        }
        else if datePickerVisible {
            hideScheduledDatePickerCell(containingDatePicker: pickerScheduledDate)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        selectedValue = pickerScheduledDate.date
        lblScheduledDate.text = myFormatter.string(from: pickerScheduledDate.date)
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 44 // Default
        if indexPath.row == 1 {
            height = datePickerVisible ? 216 : 0
        }
        return height
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
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
