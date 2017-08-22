//
//  TempMealPlanViewController.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 8/21/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit

class TempMealPlanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
                tabBarItem = UITabBarItem(title: "My Recipes", image: tab, tag: 0)
        //tabBarItem = UITabBarItem(title: "Cover", image: UIImage(named: "icon-cover"), tag: 0)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
