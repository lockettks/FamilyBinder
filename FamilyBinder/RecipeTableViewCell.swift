//
//  RecipeTableViewCell.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/26/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeLbl: UILabel!
    
    func initWithModel(model: Recipe){
        recipeLbl.text = model.title
        let placeholderImage = #imageLiteral(resourceName: "dinnerPlate")
        let url = URL(string: model.imageURL)
        recipeImg.af_setImage(withURL: url!, placeholderImage: placeholderImage)
        model.image = recipeImg.image
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
