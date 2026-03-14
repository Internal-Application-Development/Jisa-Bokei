//
//  TabBarController.swift
//  Jisa-Bokei
//
//  Created by 小沢克治 on 2018/03/11.
//  Copyright © 2018年 Private. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if userDefaults.object(forKey: .START_MODE) == nil {
            self.selectedIndex = MODE.START.CALC
        } else if userDefaults.integer(forKey: .START_MODE) == MODE.START.LAST {
            self.selectedIndex = userDefaults.integer(forKey: .START_LAST)
        } else {
            self.selectedIndex = userDefaults.integer(forKey: .START_MODE)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
