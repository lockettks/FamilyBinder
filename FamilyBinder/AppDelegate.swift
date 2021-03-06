//
//  AppDelegate.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 7/14/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var userContextCache:UserContextCache?
    let realm = try! Realm()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let tabController = window!.rootViewController as! UITabBarController
        let splitViewController = tabController.viewControllers?.first as! UISplitViewController
        
        //splitViewController.extendedLayoutIncludesOpaqueBars = true
        
        //let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        let navigationController = splitViewController.viewControllers[0] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        
        let navController2 = splitViewController.viewControllers[1] as! UINavigationController
        navController2.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController2.navigationBar.shadowImage = UIImage()
        navController2.navigationBar.isTranslucent = true
        navController2.view.backgroundColor = .clear
        
        if realm.objects(User.self).first == nil {
            try! self.realm.write{
                let newUser = User()
                realm.create(User.self, value: newUser, update: true)
            }
        }
        
        
//        let usersMealPlans: Results<MealPlan> = {
//            let realm = try! Realm()
//            return realm.objects(MealPlan.self)
//        }()
//        if usersMealPlans.count == 0 {
//            try! self.realm.write {
//                let defaultMealPlan = MealPlan()
//                self.realm.add(defaultMealPlan)
//            }
//        }
        
        print("po Realm.Configuration.defaultConfiguration.fileURL")
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? RecipeDetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}

