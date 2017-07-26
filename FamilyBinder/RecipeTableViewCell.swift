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
        
        recipeImg?.image = nil
        if let urlString = model.imageURL {
            SpoonacularAPIManager.sharedInstance.imageFrom(urlString: urlString) {
                (image, error) in
                guard error == nil else {
                    print(error!)
                    return
                }
                self.recipeImg.image = image // will work fine even if image is nil
                // need to reload the view, which won't happen otherwise
                // sincew this is in an async call
                self.setNeedsLayout()
            }
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
