//
//  StringHelper.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 9/19/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import Foundation
import UIKit

class StringHelper {
    
    func convertToBulletedItem(textToConvert: String) -> NSMutableAttributedString {
        let bulletPoint: String = "\u{2022}"
        let formattedString: String = "\(bulletPoint) \(textToConvert)\n"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
        
        let paragraphStyle = createParagraphAttribute()
        attributedString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    func convertToNumberedItem(textToConvert: String, textNumber: String) -> NSMutableAttributedString {
        let formattedString: String = "\(textNumber). \(textToConvert)\n"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
        
        let paragraphStyle = createParagraphAttribute()
        attributedString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, attributedString.length))
        return attributedString
    }

    func createParagraphAttribute() ->NSParagraphStyle {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [String : AnyObject])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        
        return paragraphStyle
    }
}

extension String  {
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
}

