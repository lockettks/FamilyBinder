//
//  ScheduleOptionSelectedTableViewCell.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 5/24/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import UIKit

class ScheduleOptionSelectedTableViewCell: UITableViewCell {
    @IBOutlet var lblScheduleOption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithModel(selectedScheduleOption: ScheduleOption){
        lblScheduleOption.text = selectedScheduleOption.rawValue
    }

}
