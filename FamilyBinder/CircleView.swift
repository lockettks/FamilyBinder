//
//  Circle.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 4/10/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import UIKit

class CircleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder: has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor.green.setFill()
        path.fill()
        
//        // Get the Graphics Context
//        let context = UIGraphicsGetCurrentContext()
//
//        // Set the circle outerline-width
//        context?.setLineWidth(4.0)
//
//        // Set the circle outerline-colour
//        context?.setStrokeColor(UIColor.blue.cgColor)
//
//
//        let rectangle = CGRect(x: 60,y: 170,width: 200,height: 80)
//        context?.addEllipse(in: rectangle)
//        context?.strokePath()
    }
 

}
