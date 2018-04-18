//
//  CircleButton.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 4/15/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import UIKit

class CircleButton: UIButton {
    var circleFrame: CGRect
    var fillColor: UIColor
    var mealType: MealType
    
    let circleViewService = CircleMenuService()
    
    init(frame: CGRect, fillColor: UIColor, mealType: MealType) {
        self.circleFrame = frame
        self.fillColor = fillColor
        self.mealType = mealType
        
        super.init(frame: self.circleFrame)
        
        self.frame = self.circleFrame
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true
        self.setBackgroundColor(color: self.fillColor, forState: .normal)
        let circleImage = circleViewService.getImageForMealTypeOn(mealType: self.mealType)
        self.setImage(circleImage, for: .normal)
        self.addTarget(self, action: #selector(onPress), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onPress(){
        print("\(self.mealType.displayName()) Button Pressed")
    }

}
