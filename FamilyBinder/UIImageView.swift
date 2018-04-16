//
//  UIImageView.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 4/14/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
}
