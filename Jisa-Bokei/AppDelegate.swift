//
//  AppDelegate.swift
//  Jisa-Bokei
//
//  Created by 小沢克治 on 2017/12/02.
//  Copyright © 2017年 Private. All rights reserved.
//

import UIKit
//import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataController: DataController!
 
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 起動直後に行う処理
        
        // Initialize the Google Mobile Ads SDK.
//        MobileAds.shared.start()
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //
        let storyboard:UIStoryboard = UIStoryboard(name: ID.STORYBOARD.MAIN, bundle: nil)
        
        //
        dataController = DataController() {
        }

        //
        if userDefaults.object(forKey: .DISPLAY_SPLASH) == nil {
            userDefaults.set(true, forKey: .DISPLAY_SPLASH)
        }

        // 表示するビューコントローラーを指定
        let id = userDefaults.bool(forKey: .DISPLAY_SPLASH) ? ID.STORYBOARD.SPLASH : ID.STORYBOARD.MAIN
        window?.rootViewController = storyboard.instantiateViewController(withIdentifier: id) as UIViewController

        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .all
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // アプリ終了時の機能モードを保存
        if let tabBar: TabBarController = self.window?.rootViewController as? TabBarController {
            userDefaults.set(tabBar.selectedIndex, forKey: .START_LAST)
        } else {
            print("AppDelegate:applicationWillTerminate: tabBar = nil")
        }
        
        //
        dataController.saveContext()
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

}
