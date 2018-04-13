//
//  CircleView.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 4/12/18.
//  Copyright © 2018 kimMathieu. All rights reserved.
//

import UIKit

class CircleView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder): has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor.green.setFill()
        path.fill()
    }
 

}
