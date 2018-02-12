//
//  RecipeTitleTableViewCell.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 11/29/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit

class RecipeTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var imgRecipe: UIImageView!
    @IBOutlet weak var lblRecipeTitle: UILabel!
    
    func initWithModel(model: Recipe){
        lblRecipeTitle.text = model.title
        let placeholderImage = #imageLiteral(resourceName: "dinnerPlate")
        model.image = placeholderImage
        if let url = URL(string: model.imageURL) {
            imgRecipe.af_setImage(withURL: url, placeholderImage: placeholderImage)
            model.image = imgRecipe.image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
