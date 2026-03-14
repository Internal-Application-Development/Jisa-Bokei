//
//  ClockViewController.swift
//  Jisa-Bokei
//
//  Created by 小沢克治 on 2017/12/03.
//  Copyright © 2017年 Private. All rights reserved.
//

import UIKit

class ClockViewController: DataViewController {

    // セルデータ
    private var clockGrid = [BaseGridData]()

    // タイマー
    private var timer       : Timer?
    private var timerControl: Bool = true

    @IBOutlet weak var clockTableView: UITableView!
        
    // セクションの個数を指定
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // 各セクションごとのセル数を返却
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let n = clockGrid.count
        return n
    }

    // 各セルの設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = clockTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ClockTableViewCell
        // Set up the cell
        cell.configureCell(clockGrid[indexPath.row])
        return cell
    }

    // メインメソッド
    override func viewDidLoad() {
        
        self.reuseIdentifier = ID.CELL.CLOCK
        self.tableView       = clockTableView
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // 未設定時の初期値
        let key = KEY.init(type: UDEFS.ITEM.CLOCK)
        userDefaults.register(defaults: [key.NumberOfSection():3,
                                         key.ItemsInSection(UDEFS.ITEM.SELECT_KIND    , 0):0,
                                         key.ItemsInSection(UDEFS.ITEM.COUNTRY_NAME   , 0):"日本",
                                         key.ItemsInSection(UDEFS.ITEM.COUNTRY_CODE   , 0):"JP",
                                         key.ItemsInSection(UDEFS.ITEM.CITY_NAME      , 0):"東京",
                                         key.ItemsInSection(UDEFS.ITEM.LATITUDE       , 0):35.6895,
                                         key.ItemsInSection(UDEFS.ITEM.LONGTITUDE     , 0):139.69171,
                                         key.ItemsInSection(UDEFS.ITEM.LATITUDE_SPAN  , 0):1.0,
                                         key.ItemsInSection(UDEFS.ITEM.LONGTITUDE_SPAN, 0):1.0,
                                         key.ItemsInSection(UDEFS.ITEM.TIMEZONE_ID    , 0):"Asia/Tokyo",
                                         key.ItemsInSection(UDEFS.ITEM.RECORD_ID      , 0):234,
                                         key.ItemsInSection(UDEFS.ITEM.SECONDFROMGMT  , 0):0,
                                         key.ItemsInSection(UDEFS.ITEM.SELECT_KIND    , 1):0,
                                         key.ItemsInSection(UDEFS.ITEM.COUNTRY_NAME   , 1):"アメリカ",
                                         key.ItemsInSection(UDEFS.ITEM.COUNTRY_CODE   , 1):"US",
                                         key.ItemsInSection(UDEFS.ITEM.CITY_NAME      , 1):"ニューヨーク",
                                         key.ItemsInSection(UDEFS.ITEM.LATITUDE       , 1):40.71427,
                                         key.ItemsInSection(UDEFS.ITEM.LONGTITUDE     , 1):-74.00597,
                                         key.ItemsInSection(UDEFS.ITEM.LATITUDE_SPAN  , 1):1.0,
                                         key.ItemsInSection(UDEFS.ITEM.LONGTITUDE_SPAN, 1):1.0,
                                         key.ItemsInSection(UDEFS.ITEM.TIMEZONE_ID    , 1):"America/New_York",
                                         key.ItemsInSection(UDEFS.ITEM.RECORD_ID      , 1):136,
                                         key.ItemsInSection(UDEFS.ITEM.SECONDFROMGMT  , 1):0,
                                         key.ItemsInSection(UDEFS.ITEM.SELECT_KIND    , 2):0,
                                         key.ItemsInSection(UDEFS.ITEM.COUNTRY_NAME   , 2):"オーストラリア",
                                         key.ItemsInSection(UDEFS.ITEM.COUNTRY_CODE   , 2):"AU",
                                         key.ItemsInSection(UDEFS.ITEM.CITY_NAME      , 2):"アデレード",
                                         key.ItemsInSection(UDEFS.ITEM.LATITUDE       , 2):-34.92866,
                                         key.ItemsInSection(UDEFS.ITEM.LONGTITUDE     , 2):138.59863,
                                         key.ItemsInSection(UDEFS.ITEM.LATITUDE_SPAN  , 2):1.0,
                                         key.ItemsInSection(UDEFS.ITEM.LONGTITUDE_SPAN, 2):1.0,
                                         key.ItemsInSection(UDEFS.ITEM.TIMEZONE_ID    , 2):"Australia/Adelaide",
                                         key.ItemsInSection(UDEFS.ITEM.RECORD_ID      , 2):252,
                                         key.ItemsInSection(UDEFS.ITEM.SECONDFROMGMT  , 2):0
                                        ])
        let n = userDefaults.integer(forKey: key.NumberOfSection())
        for i in 0..<n {
            let base = BaseGridData()
            base.setKind          (userDefaults.integer(forKey: key.ItemsInSection(UDEFS.ITEM.SELECT_KIND    , i)))
            base.setCountry       (userDefaults.string (forKey: key.ItemsInSection(UDEFS.ITEM.COUNTRY_NAME   , i)))
            base.setCountryCode   (userDefaults.string (forKey: key.ItemsInSection(UDEFS.ITEM.COUNTRY_CODE   , i)))
            base.setCity          (userDefaults.string (forKey: key.ItemsInSection(UDEFS.ITEM.CITY_NAME      , i)))
            base.setLatitude      (userDefaults.double (forKey: key.ItemsInSection(UDEFS.ITEM.LATITUDE       , i)))
            base.setLongtitude    (userDefaults.double (forKey: key.ItemsInSection(UDEFS.ITEM.LONGTITUDE     , i)))
            base.setLatitudeSpan  (userDefaults.double (forKey: key.ItemsInSection(UDEFS.ITEM.LATITUDE_SPAN  , i)))
            base.setLongtitudeSpan(userDefaults.double (forKey: key.ItemsInSection(UDEFS.ITEM.LONGTITUDE_SPAN, i)))
            base.setTimezone      (userDefaults.string (forKey: key.ItemsInSection(UDEFS.ITEM.TIMEZONE_ID    , i)))
            base.setRecordID      (userDefaults.integer(forKey: key.ItemsInSection(UDEFS.ITEM.RECORD_ID      , i)))
            base.setSecondFromGMT (userDefaults.integer(forKey: key.ItemsInSection(UDEFS.ITEM.SECONDFROMGMT  , i)))
            clockGrid.append(base)
        }
        // タイトル表示
        self.navigationItem.title = CONST.CLOCK
        
        // 広告表示
        createBannerViewProgrammatically()
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      loadInlineAdaptiveBanner()
    }

    override func viewWillAppear(_ animated: Bool) {
        timerStart()
        // ビュー更新
        self.tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        timerStop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func timerUpdate() {
        self.tableView.reloadData()
    }

    // 編集ボタンが押された
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        if editing == true {
            // 編集モードにした時にはタイマーを止める
            timerStop()
        } else {
            // 編集モードの終了時にタイマーを再設定する
            timerStart()
        }
    }

    // タイマースタート
    func timerStart() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
        timerControl = true
    }

    // タイマーストップ
    func timerStop() {
        timer?.invalidate()
    }
 
    func timerControlOff() {
        timerControl = false
    }

    // セル並べ替えの処理
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let fRow = fromIndexPath.row
        let tRow = to.row
        // 現在のUserDefaultsを削除
        deleteUserDefaults()
        // 並べ替えの処理
        let temp = clockGrid[fRow]
        clockGrid.remove(at: fRow)
        clockGrid.insert(temp, at: tRow)
        // UserDefaults更新
        updateUserDefaults()
        // ビュー更新
        self.tableView.reloadData()
    }

    // セル削除の処理
    override func deleteData(_ tableView: UITableView,_ indexPath: IndexPath) {
        // Delete the data (Before delete data source)
        deleteUserDefaults()
        clockGrid.remove(at: indexPath.row)
        updateUserDefaults()
        // Delete the row from the data source
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    // UserDefaults削除
    func deleteUserDefaults() {
        let key = KEY.init(type:UDEFS.ITEM.CLOCK)
        let n = userDefaults.integer(forKey: key.NumberOfSection())
        for i in 0..<n {
            userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.SELECT_KIND    , i))
            userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.COUNTRY_NAME   , i))
            userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.CITY_NAME      , i))
            userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.LATITUDE       , i))
            userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.LONGTITUDE     , i))
            userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.LATITUDE_SPAN  , i))
            userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.LONGTITUDE_SPAN, i))
            userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.TIMEZONE_ID    , i))
            userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.RECORD_ID      , i))
            userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.COUNTRY_CODE   , i))
            userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.SECONDFROMGMT  , i))
        }
    }
    
    // UserDefaults更新
    func updateUserDefaults() {
        let key = KEY.init(type:UDEFS.ITEM.CLOCK)
        let cnt = clockGrid.count
        userDefaults.set(cnt, forKey: key.NumberOfSection())
        for i in 0..<cnt {
            userDefaults.set(clockGrid[i].getKind()          ,forKey: key.ItemsInSection(UDEFS.ITEM.SELECT_KIND    , i))
            userDefaults.set(clockGrid[i].getCountry()       ,forKey: key.ItemsInSection(UDEFS.ITEM.COUNTRY_NAME   , i))
            userDefaults.set(clockGrid[i].getCity()          ,forKey: key.ItemsInSection(UDEFS.ITEM.CITY_NAME      , i))
            userDefaults.set(clockGrid[i].getLatitude()      ,forKey: key.ItemsInSection(UDEFS.ITEM.LATITUDE       , i))
            userDefaults.set(clockGrid[i].getLongtitude()    ,forKey: key.ItemsInSection(UDEFS.ITEM.LONGTITUDE     , i))
            userDefaults.set(clockGrid[i].getLatitudeSpan()  ,forKey: key.ItemsInSection(UDEFS.ITEM.LATITUDE_SPAN  , i))
            userDefaults.set(clockGrid[i].getLongtitudeSpan(),forKey: key.ItemsInSection(UDEFS.ITEM.LONGTITUDE_SPAN, i))
            userDefaults.set(clockGrid[i].getDate()          ,forKey: key.ItemsInSection(UDEFS.ITEM.DATETIME       , i))
            userDefaults.set(clockGrid[i].getTimezoneID()    ,forKey: key.ItemsInSection(UDEFS.ITEM.TIMEZONE_ID    , i))
            userDefaults.set(clockGrid[i].getRecordID()      ,forKey: key.ItemsInSection(UDEFS.ITEM.RECORD_ID      , i))
            userDefaults.set(clockGrid[i].getCountryCode()   ,forKey: key.ItemsInSection(UDEFS.ITEM.COUNTRY_CODE   , i))
            userDefaults.set(clockGrid[i].getSecondFromGMT() ,forKey: key.ItemsInSection(UDEFS.ITEM.SECONDFROMGMT  , i))
        }
    }
    
    // セル追加の処理
    override func insertData(_ indexPath: IndexPath) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        self.insertMode = true
        insertData = BaseGridData.init()
        // 画面遷移
        transition(insertData!)
    }
    
    // セル更新の処理
    override func updateData(_ indexPath: IndexPath) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        self.insertMode = false
        // 画面遷移
        transition(clockGrid[indexPath.row])
    }
    
    // 選択画面への画面遷移時の処理
    func transition(_ base:BaseGridData) {
        //
        let storyboard: UIStoryboard = self.storyboard!
        let vc = storyboard.instantiateViewController(withIdentifier: ID.STORYBOARD.CITY_SELECT) as! CitySelectViewController
        vc.prmBaseData = base
        vc.prmTitle    = TITLE.AREA_SELECT
        vc.prmVC       = self
        self.present(vc, animated: true, completion: nil)
    }

    // 前画面から戻った時の再描画
    override func updateView() {
        // 挿入モード判定
        if self.insertMode {
            // データ挿入判定
            guard let insData = insertData else {
                abort()
            }
            let idx = actionCellIndexPath!
            let row = idx.row
            if insData.isCitySet() {
                // Insert the data
                deleteUserDefaults()
                clockGrid.insert(insData, at:row+1)
                updateUserDefaults()
                // Insert the row to the data source
                tableView.insertRows(at: [idx], with: .automatic)
                // インスタンス解放
                insertData = nil
            }
            self.insertMode = false
        }
        // 再描画
        super.updateView()
    }

    // 各indexPathのcellが横にスワイプされスワイプメニューが表示される際に呼ばれます．
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        super.tableView(tableView, willBeginEditingRowAt: indexPath)
        timerStop()
    }

    // 各indexPathのcellのスワイプメニューが非表示になった際に呼ばれます．
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        super.tableView(tableView, didEndEditingRowAt: indexPath)
        // 都市画面選択による非表示時はタイマーを開始しない
        if timerControl == true {
            timerStart()
        }
    }
}
