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
        
//        let imageName = "dinnerPlate.jpeg"
//        let placeholderImage = UIImage(named: imageName)
        let placeholderImage = #imageLiteral(resourceName: "dinnerPlate")
        
        recipeLbl.text = model.title
        
        let url = URL(string: model.imageURL)
        recipeImg.af_setImage(withURL: url!, placeholderImage: placeholderImage)
        model.image = recipeImg.image
        
//        recipeImg?.image = placeHolderImage
//            SpoonacularAPIManager.sharedInstance.imageFrom(urlString: model.imageURL) {
//                (image, error) in
//                guard error == nil else {
//                    print(error!)
//                    return
//                }
//                model.image = image
//                self.recipeImg.image = image // will work fine even if image is nil
//                // need to reload the view, which won't happen otherwise
//                // sincew this is in an async call
//                self.setNeedsLayout()
//            }
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
