//
//  SettingsViewController.swift
//  Jisa-Bokei
//
//  Created by 小沢克治 on 2018/03/11.
//  Copyright © 2018年 Private. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard

    // 画面項目との関連づけ
    @IBOutlet weak var SplashSW      : UISwitch!
    @IBOutlet weak var StartUpModeSW : UISegmentedControl!
    @IBOutlet weak var TimeDiffSW    : UISegmentedControl!
    @IBOutlet weak var TimeDispStyle : UISegmentedControl!
    
    // キャンセルボタン
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 設定ボタン
    @IBAction func doneButton(_ sender: Any) {
        clickDoneButton(sender)
        self.dismiss(animated: true, completion: nil)
    }

    // 設定処理
    func clickDoneButton(_ sender: Any) {
        
        // スプラッシュ画面
        if SplashSW.isOn != userDefaults.bool(forKey: .DISPLAY_SPLASH) {
            userDefaults.set(SplashSW.isOn, forKey:.DISPLAY_SPLASH)
        }
        
        // 起動時モード
        if StartUpModeSW.selectedSegmentIndex != getStartupMode() {
            userDefaults.set(StartUpModeSW.selectedSegmentIndex, forKey: .START_MODE)
        }
        
        // 時差表示
        if TimeDiffSW.selectedSegmentIndex != getTimeDiffSW() {
            userDefaults.set(TimeDiffSW.selectedSegmentIndex, forKey:.DISPLAY_TIMEDIFF)
        }
        
        // 時刻表示
        if TimeDispStyle.selectedSegmentIndex != getTimeDispStyle() {
            userDefaults.set(TimeDispStyle.selectedSegmentIndex, forKey:.TIME_STYLE)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        // スプラッシュ画面
        let startSplash = userDefaults.bool(forKey: .DISPLAY_SPLASH)
        SplashSW.setOn(startSplash, animated: true)

        // 起動時モード
        StartUpModeSW.selectedSegmentIndex = getStartupMode()

        // 時差表示
        TimeDiffSW.selectedSegmentIndex = getTimeDiffSW()

        // 時刻表示形式
        TimeDispStyle.selectedSegmentIndex = getTimeDispStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(false, animated: animated)
            super.viewWillAppear(animated)
        }
    }
 
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            super.viewDidAppear(animated)
            presentingViewController?.endAppearanceTransition()
        }
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            super.viewWillDisappear(animated)
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }
    }

    // 起動時モードの取得
    func getStartupMode() -> Int {
        userDefaults.register(defaults:[UDEFS.ITEM.STARTUP_MODE:MODE.START.CALC])
        var startUpMode = userDefaults.integer(forKey: .START_MODE)
        if startUpMode == MODE.START.LAST {
            startUpMode = userDefaults.integer(forKey: .START_LAST)
        }
        return startUpMode
    }

    // 時差表示モードの取得
    func getTimeDiffSW() -> Int {
        userDefaults.register(defaults:[UDEFS.ITEM.TIMEDIFF_MODE:MODE.TIMEDIFF.NONE])
        let timeDiff = userDefaults.integer(forKey: .DISPLAY_TIMEDIFF)
        return timeDiff
    }

    // 時刻表示形式の取得
    func getTimeDispStyle() -> Int {
        userDefaults.register(defaults:[UDEFS.ITEM.TIME_STYLE:MODE.TIMESTYLE.STANDARD])
        let timeStyle = userDefaults.integer(forKey: .TIME_STYLE)
        return timeStyle
    }
}
