//
//  CalculationViewController.swift
//  Jisa-Bokei
//
//  Created by 小沢克治 on 2017/12/03.
//  Copyright © 2017年 Private. All rights reserved.
//

import UIKit

class CalculationViewController: DataViewController {
    
    // セルデータ
    private var calcGrid = [[BaseGridData]]()

    // 時差計算
    @IBOutlet weak var calculationTableView: UITableView!
    
    // セクションの個数を指定
    override func numberOfSections(in tableView: UITableView) -> Int {
        let n = calcGrid.count
        return n
    }

    // 各セクションごとのセル数を返却
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let n = calcGrid[section].count
        return n
    }

    // セクションタイトルの設定
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitles = [TITLE.SECTION0,TITLE.SECTION1]
        return sectionTitles[section]
    }

    // セクションヘッダのビュー設定
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor.white             // 好きな色を指定
            // グラデーションさせる範囲をUIViewControllerのviewのサイズに指定
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame.size = header.frame.size
            gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.white.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            header.layer.insertSublayer(gradientLayer, at: 0)
        }
    }

    // セクションヘッダの高さ設定
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    // 各セルの設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = calculationTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CalculationTableViewCell
        // Set up the cell
        let selectedPartnerCityIndex = userDefaults.integer(forKey: KEY.IX_SELECT_PARTNER_CITY)
        if (userDefaults.integer(forKey: .DISPLAY_TIMEDIFF) == MODE.TIMEDIFF.BASE) && (indexPath.section == 1) {
            cell.configureCell(calcGrid[0][selectedPartnerCityIndex],calcGrid[1][indexPath.row])
        } else {
            let checked = (indexPath.section == 0 && indexPath.row == selectedPartnerCityIndex)
            cell.configureCell(calcGrid[indexPath.section][indexPath.row],checked)
        }
        reCalcDate()
        return cell
    }

    // 各indexPathのcellがタップされた際に呼び出されます．
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        if indexPath.section == 0 {
            userDefaults.set(indexPath.row, forKey: KEY.IX_SELECT_PARTNER_CITY)
            reCalcDate()
        }
        super.tableView(tableView, didSelectRowAt: indexPath)
    }

    // メインメソッド
    override func viewDidLoad() {
        self.reuseIdentifier = ID.CELL.CALC
        self.tableView       = calculationTableView
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let key = KEY.init(type:UDEFS.ITEM.CALC)
        userDefaults.register(defaults: [KEY.IX_SELECT_PARTNER_CITY:0,
                                         key.NumberOfSection(0):1,
                                         key.ItemsInSection(UDEFS.ITEM.SELECT_KIND    , 0, 0):0,
                                         key.ItemsInSection(UDEFS.ITEM.COUNTRY_NAME   , 0, 0):"アメリカ合衆国",
                                         key.ItemsInSection(UDEFS.ITEM.COUNTRY_CODE   , 0, 0):"US",
                                         key.ItemsInSection(UDEFS.ITEM.CITY_NAME      , 0, 0):"ニューヨーク",
                                         key.ItemsInSection(UDEFS.ITEM.LATITUDE       , 0, 0):40.71427,
                                         key.ItemsInSection(UDEFS.ITEM.LONGTITUDE     , 0, 0):-74.00597,
                                         key.ItemsInSection(UDEFS.ITEM.LATITUDE_SPAN  , 0, 0):1.0,
                                         key.ItemsInSection(UDEFS.ITEM.LONGTITUDE_SPAN, 0, 0):1.0,
                                         key.ItemsInSection(UDEFS.ITEM.DATETIME       , 0, 0):Date(),
                                         key.ItemsInSection(UDEFS.ITEM.TIMEZONE_ID    , 0, 0):"America/New_York",
                                         key.ItemsInSection(UDEFS.ITEM.RECORD_ID      , 0, 0):136,
                                         key.ItemsInSection(UDEFS.ITEM.SECONDFROMGMT  , 0, 0):0,
                                         key.NumberOfSection(1):2,
                                         key.ItemsInSection(UDEFS.ITEM.SELECT_KIND    , 0, 1):0,
                                         key.ItemsInSection(UDEFS.ITEM.COUNTRY_NAME   , 0, 1):"日本",
                                         key.ItemsInSection(UDEFS.ITEM.COUNTRY_CODE   , 0, 1):"JP",
                                         key.ItemsInSection(UDEFS.ITEM.CITY_NAME      , 0, 1):"東京",
                                         key.ItemsInSection(UDEFS.ITEM.LATITUDE       , 0, 1):35.6895,
                                         key.ItemsInSection(UDEFS.ITEM.LONGTITUDE     , 0, 1):139.69171,
                                         key.ItemsInSection(UDEFS.ITEM.LATITUDE_SPAN  , 0, 1):1.0,
                                         key.ItemsInSection(UDEFS.ITEM.LONGTITUDE_SPAN, 0, 1):1.0,
                                         key.ItemsInSection(UDEFS.ITEM.DATETIME       , 0, 1):Date(),
                                         key.ItemsInSection(UDEFS.ITEM.TIMEZONE_ID    , 0, 1):"Asia/Tokyo",
                                         key.ItemsInSection(UDEFS.ITEM.RECORD_ID      , 0, 1):234,
                                         key.ItemsInSection(UDEFS.ITEM.SECONDFROMGMT  , 0, 1):0,
                                         key.ItemsInSection(UDEFS.ITEM.SELECT_KIND    , 1, 1):0,
                                         key.ItemsInSection(UDEFS.ITEM.COUNTRY_NAME   , 1, 1):"オーストラリア",
                                         key.ItemsInSection(UDEFS.ITEM.COUNTRY_CODE   , 1, 1):"AU",
                                         key.ItemsInSection(UDEFS.ITEM.CITY_NAME      , 1, 1):"アデレード",
                                         key.ItemsInSection(UDEFS.ITEM.LATITUDE       , 1, 1):-34.92866,
                                         key.ItemsInSection(UDEFS.ITEM.LONGTITUDE     , 1, 1):138.59863,
                                         key.ItemsInSection(UDEFS.ITEM.LATITUDE_SPAN  , 1, 1):1.0,
                                         key.ItemsInSection(UDEFS.ITEM.LONGTITUDE_SPAN, 1, 1):1.0,
                                         key.ItemsInSection(UDEFS.ITEM.DATETIME       , 1, 1):Date(),
                                         key.ItemsInSection(UDEFS.ITEM.TIMEZONE_ID    , 1, 1):"Australia/Adelaide",
                                         key.ItemsInSection(UDEFS.ITEM.RECORD_ID      , 1, 1):252,
                                         key.ItemsInSection(UDEFS.ITEM.SECONDFROMGMT  , 1, 1):0
                                        ])
        for s in 0...1 {
            calcGrid.append([BaseGridData]())     // 初期化
            let n = userDefaults.integer(forKey: key.NumberOfSection(s))
            for i in 0..<n {
                let base:BaseGridData = BaseGridData.init()
                base.setKind          (userDefaults.integer(forKey: key.ItemsInSection(UDEFS.ITEM.SELECT_KIND    , i, s)))
                base.setCountry       (userDefaults.string (forKey: key.ItemsInSection(UDEFS.ITEM.COUNTRY_NAME   , i, s)))
                base.setCity          (userDefaults.string (forKey: key.ItemsInSection(UDEFS.ITEM.CITY_NAME      , i, s)))
                base.setLatitude      (userDefaults.double (forKey: key.ItemsInSection(UDEFS.ITEM.LATITUDE       , i, s)))
                base.setLongtitude    (userDefaults.double (forKey: key.ItemsInSection(UDEFS.ITEM.LONGTITUDE     , i, s)))
                base.setLatitudeSpan  (userDefaults.double (forKey: key.ItemsInSection(UDEFS.ITEM.LATITUDE_SPAN  , i, s)))
                base.setLongtitudeSpan(userDefaults.double (forKey: key.ItemsInSection(UDEFS.ITEM.LONGTITUDE_SPAN, i, s)))
                base.setRecordID      (userDefaults.integer(forKey: key.ItemsInSection(UDEFS.ITEM.RECORD_ID      , i, s)))
                base.setCountryCode   (userDefaults.string (forKey: key.ItemsInSection(UDEFS.ITEM.COUNTRY_CODE   , i, s)))
                base.setSecondFromGMT (userDefaults.integer(forKey: key.ItemsInSection(UDEFS.ITEM.SECONDFROMGMT  , i, s)))
                let timezoneID =       userDefaults.string (forKey: key.ItemsInSection(UDEFS.ITEM.TIMEZONE_ID    , i, s))
                let datetime   =       userDefaults.object (forKey: key.ItemsInSection(UDEFS.ITEM.DATETIME       , i, s)) as? Date
                if datetime != nil && timezoneID != nil {
                    base.setDate(datetime!, timezoneID)
                    base.setTimezone(timezoneID)
                }
                calcGrid[s].append(base)
            }
        }
        // タイトル表示
        self.navigationItem.title = CONST.CALC
        
        // 広告表示
        createBannerViewProgrammatically()
    }

    override func viewWillAppear(_ animated: Bool) {
        // ビュー更新
        self.tableView.reloadData()
    }

    // 再計算
    func reCalcDate() {
        // フォーマット設定
        let dateFormatter = DateFormatter()
        let userDefaults = UserDefaults.standard
        if userDefaults.integer(forKey: .TIME_STYLE) == MODE.TIMESTYLE.STANDARD {
            dateFormatter.setTemplate(.full)
        } else {
            dateFormatter.setTemplate(.fullJP)
        }

        // 選択した地域の現地時間(タイムゾーン)
        let selectedPartnerCityIndex = userDefaults.integer(forKey: KEY.IX_SELECT_PARTNER_CITY)
        if let timezone = calcGrid[0][selectedPartnerCityIndex].getTimezone() {
            dateFormatter.timeZone = timezone
        } else {
            print("CalculationViewController: reCalcDate: Invalid timezone(nil)!")
            return
        }

        // 初期値があればその値を利用する
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let partnerDatetime = calcGrid[0][selectedPartnerCityIndex].getDate() {
            for i in 0..<calcGrid[1].count {
                calcGrid[1][i].setDate(partnerDatetime)
            }
        } else {
            print("CalculationViewController: reCalcDate: Invalid datetime(nil)!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // セクションを跨いだ場合の移動
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {

        // 同セクション内ならそのまま移動
        if sourceIndexPath.section == proposedDestinationIndexPath.section {
            return proposedDestinationIndexPath
        }

        // 移動の結果、移動先セクションの行数がMAX値を超えるようなら元に戻す
        let tSec  = proposedDestinationIndexPath.section
        let tRows = tableView.numberOfRows(inSection: tSec)
        if tSec == 0 && tRows == CONST.SECTION0_MAX || tSec == 1 && tRows == CONST.SECTION1_MAX {
            return sourceIndexPath
        }

        // 移動可
        return proposedDestinationIndexPath
    }
    
    // セル並べ替えの処理
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let fSec = fromIndexPath.section
        let fRow = fromIndexPath.row
        let Num0 = tableView.numberOfRows(inSection: 0) - 1    // 並べ替え後の数
        let tSec = to.section
        let tRow = to.row

        // 現在のUserDefaultsを削除
        deleteUserDefaults()
        // 並べ替えの処理
        let temp = calcGrid[fSec][fRow]
        calcGrid[fSec].remove(at: fRow)
        calcGrid[tSec].insert(temp, at: tRow)
        // 選択都市の更新
        var selectedPartnerCityIndex = userDefaults.integer(forKey: KEY.IX_SELECT_PARTNER_CITY)
        if fSec == 0 {
            if tSec == 0 {
                // 相手の場所→相手の場所
                if fRow == selectedPartnerCityIndex {
                    selectedPartnerCityIndex = tRow
                } else if fRow > selectedPartnerCityIndex && tRow <= selectedPartnerCityIndex {
                    selectedPartnerCityIndex += 1
                }
                userDefaults.set(selectedPartnerCityIndex, forKey: KEY.IX_SELECT_PARTNER_CITY)
                reCalcDate()
            } else {
                // 相手の場所→自分の場所
                if fRow == selectedPartnerCityIndex {
                    // 移動元にチェックがついていた場合
                    if selectedPartnerCityIndex > Num0 {
                        // チェック場所が最後の要素だった場合
                        selectedPartnerCityIndex -= 1
                        userDefaults.set(selectedPartnerCityIndex, forKey: KEY.IX_SELECT_PARTNER_CITY)
                        reCalcDate()
                    }
                }
            }
        } else {
            if tSec == 0 {
                // 自分の場所→相手の場所
                if tRow <= selectedPartnerCityIndex {
                    selectedPartnerCityIndex += 1
                    userDefaults.set(selectedPartnerCityIndex, forKey: KEY.IX_SELECT_PARTNER_CITY)
                    reCalcDate()
                }
            } else {
                // 自分の場所→自分の場所：対応不要
            }
        }
        // UserDefaults更新
        updateUserDefaults()
        // ビュー更新
        self.tableView.reloadData()
    }

    // UserDefaults削除
    func deleteUserDefaults() {
        let key = KEY.init(type:UDEFS.ITEM.CALC)
        for s in 0...1 {
            let n = userDefaults.integer(forKey: key.NumberOfSection(s))
            for i in 0..<n {
                userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.SELECT_KIND    , i, s))
                userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.COUNTRY_NAME   , i, s))
                userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.CITY_NAME      , i, s))
                userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.LATITUDE       , i, s))
                userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.LONGTITUDE     , i, s))
                userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.LATITUDE_SPAN  , i, s))
                userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.LONGTITUDE_SPAN, i, s))
                userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.DATETIME       , i, s))
                userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.TIMEZONE_ID    , i, s))
                userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.RECORD_ID      , i, s))
                userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.COUNTRY_CODE   , i, s))
                userDefaults.removeObject(forKey: key.ItemsInSection(UDEFS.ITEM.SECONDFROMGMT  , i, s))
            }
        }
    }

    // UserDefaults更新
    func updateUserDefaults() {
        let key = KEY.init(type:UDEFS.ITEM.CALC)
        for s in 0...1 {
            let cnt = calcGrid[s].count
            userDefaults.set(cnt, forKey: key.NumberOfSection(s))
            for i in 0..<cnt {
                userDefaults.set(calcGrid[s][i].getKind()          ,forKey: key.ItemsInSection(UDEFS.ITEM.SELECT_KIND   , i, s))
                userDefaults.set(calcGrid[s][i].getCountry()       ,forKey: key.ItemsInSection(UDEFS.ITEM.COUNTRY_NAME   , i, s))
                userDefaults.set(calcGrid[s][i].getCity()          ,forKey: key.ItemsInSection(UDEFS.ITEM.CITY_NAME      , i, s))
                userDefaults.set(calcGrid[s][i].getLatitude()      ,forKey: key.ItemsInSection(UDEFS.ITEM.LATITUDE       , i, s))
                userDefaults.set(calcGrid[s][i].getLongtitude()    ,forKey: key.ItemsInSection(UDEFS.ITEM.LONGTITUDE     , i, s))
                userDefaults.set(calcGrid[s][i].getLatitudeSpan()  ,forKey: key.ItemsInSection(UDEFS.ITEM.LATITUDE_SPAN  , i, s))
                userDefaults.set(calcGrid[s][i].getLongtitudeSpan(),forKey: key.ItemsInSection(UDEFS.ITEM.LONGTITUDE_SPAN, i, s))
                userDefaults.set(calcGrid[s][i].getDate()          ,forKey: key.ItemsInSection(UDEFS.ITEM.DATETIME       , i, s))
                userDefaults.set(calcGrid[s][i].getTimezoneID()    ,forKey: key.ItemsInSection(UDEFS.ITEM.TIMEZONE_ID    , i, s))
                userDefaults.set(calcGrid[s][i].getRecordID()      ,forKey: key.ItemsInSection(UDEFS.ITEM.RECORD_ID      , i, s))
                userDefaults.set(calcGrid[s][i].getCountryCode()   ,forKey: key.ItemsInSection(UDEFS.ITEM.COUNTRY_CODE   , i, s))
                userDefaults.set(calcGrid[s][i].getSecondFromGMT() ,forKey: key.ItemsInSection(UDEFS.ITEM.SECONDFROMGMT  , i, s))
            }
        }
    }

    // セル削除の処理
    override func deleteData(_ tableView: UITableView,_ indexPath: IndexPath) {
        let sec = indexPath.section
        let row = indexPath.row
        let num = tableView.numberOfRows(inSection: 0) - 1
        // Delete the data (Before delete data source)
        deleteUserDefaults()
        calcGrid[sec].remove(at: row)
        updateUserDefaults()
        // Delete the row from the data source
        tableView.deleteRows(at: [indexPath], with: .fade)
        // ビュー更新
        if sec == 0 {
            updateCell(num, row)
        }
    }

    private func updateCell(_ num:Int, _ row:Int) {
        var selectedPartnerCityIndex = userDefaults.integer(forKey: KEY.IX_SELECT_PARTNER_CITY)
        let reCalcIfNeeded = (row == selectedPartnerCityIndex)
        if row < selectedPartnerCityIndex || (row == selectedPartnerCityIndex && num == row) {
            selectedPartnerCityIndex -= 1
            userDefaults.set(selectedPartnerCityIndex, forKey: KEY.IX_SELECT_PARTNER_CITY)
        }
        if reCalcIfNeeded {
            reCalcDate()
        }
    }

    // セル追加の処理
    override func insertData(_ indexPath: IndexPath) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        self.insertMode = true
        insertData = BaseGridData.init()
        // 画面遷移
        transition(indexPath,insertData!)
    }

    // セル更新の処理
    override func updateData(_ indexPath: IndexPath) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        self.insertMode = false
        // 画面遷移
        transition(indexPath,calcGrid[indexPath.section][indexPath.row])
    }

    // 選択画面への画面遷移時の処理
    func transition(_ indexPath:IndexPath,_ base:BaseGridData) {

        //
        let storyboard: UIStoryboard = self.storyboard!
        if indexPath.section == 0 {
            // 相手の場所
            let vc = storyboard.instantiateViewController(withIdentifier: ID.STORYBOARD.SELECT_BASE) as! SelectBaseViewController
            vc.prmBaseData = base
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // 自分の場所
            let vc = storyboard.instantiateViewController(withIdentifier: ID.STORYBOARD.CITY_SELECT) as! CitySelectViewController
            vc.prmBaseData = base
            vc.prmTitle    = TITLE.SECTION1
            vc.prmVC       = self
            self.present(vc, animated: true, completion: nil)
        }

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
            let sec = idx.section
            let row = idx.row
            if sec == 0 && insData.isDataSet() || sec == 1 && insData.isCitySet() {
                // Insert the data
                deleteUserDefaults()
                calcGrid[sec].insert(insData, at:row+1)
                updateUserDefaults()
                // Insert the row to the data source
                tableView.insertRows(at: [idx], with: .automatic)
                // チェックマーク更新
                var selectedPartnerCityIndex = userDefaults.integer(forKey: KEY.IX_SELECT_PARTNER_CITY)
                if sec == 0 && row < selectedPartnerCityIndex {
                    selectedPartnerCityIndex += 1
                    userDefaults.set(selectedPartnerCityIndex, forKey: KEY.IX_SELECT_PARTNER_CITY)
                }
                // インスタンス解放
                insertData = nil
            }
            self.insertMode = false
        }
        // 更新後データで再計算
        self.reCalcDate()
        // 再描画
        super.updateView()
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      loadInlineAdaptiveBanner()
    }
}
