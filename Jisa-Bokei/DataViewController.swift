//
//  DataViewController.swift
//  Jisa-Bokei
//
//  Created by Katsuji Ozawa on 2019/08/17.
//  Copyright © 2019 Private. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DataViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    //
    let userDefaults = UserDefaults.standard        // UserDefaults のインスタンス

    //
    var reuseIdentifier    : String        = ""     // テーブルビューのID
    var insertMode         : Bool          = false  // 挿入モードか否か（true:挿入モード、false:更新モード）
    var insertData         : BaseGridData? = nil    // 挿入時用データ
    var actionCellIndexPath: IndexPath?    = nil    // アクション対象セルのインデックス
    var tableView          : UITableView!           // テーブルビュー
    var bannerView         : AdManagerBannerView!   // 広告ビュー

    // テーブルビューのロード
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        // テーブルビューの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false                   // trueで複数選択、falseで単一選択

        // ナビゲーションメニューの設定
        navigationController?.delegate = self
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        //　スワイプバックジェスチャー禁止
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // 編集モード切り替え（メニューボタン）
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }

    // 各セルの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        // Set up the cell
        return cell
    }

    // 各indexPathのcellがタップされた際に呼び出されます．
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップ後すぐ非選択状態にするには下記メソッドを呼び出します．
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

    // セル並べ替えの設定（有効化）
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        let n = tableView.numberOfRows(inSection: indexPath.section)
        // Return false if you do not want the specified item to be editable.
        return !isEditing ? false : (!(n == 1))
    }

    // 右から左へスワイプ
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
   
        // 作成済みのセル数によってボタンの付加内容を変える
        let nRows = tableView.numberOfRows(inSection: indexPath.section)
        // セクション内セル数が１個の場合は削除メニューはなし
        if nRows == 1 { return nil }

        let deleteAction = UIContextualAction(style: .destructive,
                                              title: CONST.DELETE,
                                              handler: { (action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
            self.actionCellIndexPath = indexPath
            self.deleteData(tableView, indexPath)
            tableView.reloadData()
            // 処理を実行できなかった場合はfalse、できればTrue
            completion(true)
        })
        deleteAction.image = UIImage(systemName: IMAGE.TRASH )
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        // 全画面スワイプで実行されないようにしたい場合:
        config.performsFirstActionWithFullSwipe = false

        return config
    }
    
    // 左から右へスワイプ
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var config:UISwipeActionsConfiguration

        let updateAction = UIContextualAction(style: .normal,
                                              title: CONST.UPDATE,
                                              handler: {(action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
            self.actionCellIndexPath = indexPath
            self.updateData(indexPath)
            tableView.reloadData()
            // 処理を実行できなかった場合はfalse、できればTrue
            completion(true)
        })
        updateAction.image = UIImage(systemName: IMAGE.UPDATE)
        updateAction.backgroundColor = UIColor(red: 101/255.0, green: 198/255.0, blue: 187/255.0, alpha: 1)
        
        let insertAction = UIContextualAction(style: .normal,
                                              title: CONST.INSERT,
                                              handler: { (action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
            self.actionCellIndexPath = indexPath
            self.insertData(indexPath)
            tableView.reloadData()
            // 処理を実行できなかった場合はfalse、できればTrue
            completion(true)
        })
        insertAction.backgroundColor = UIColor(red: 210/255.0, green: 82/255.0, blue: 127/255.0, alpha: 1)
        insertAction.image = UIImage(systemName: IMAGE.INSERT)

        // 作成済みのセル数によってボタンの付加内容を変える
        let nRows = tableView.numberOfRows(inSection: indexPath.section)
        // セクション内セル数がMAX値の場合は追加メニューはなし
        if  reuseIdentifier == ID.CELL.CLOCK && nRows == CONST.CLOCK_MAX  ||
            reuseIdentifier == ID.CELL.CALC  && indexPath.section == 0 && nRows == CONST.SECTION0_MAX ||
            reuseIdentifier == ID.CELL.CALC  && indexPath.section == 1 && nRows == CONST.SECTION1_MAX
        {
            config = UISwipeActionsConfiguration(actions: [updateAction])
        }
        else
        {
            config = UISwipeActionsConfiguration(actions: [updateAction, insertAction])
        }

        // 全画面スワイプで実行されないようにしたい場合:
        config.performsFirstActionWithFullSwipe = false

        return config
    }
    // 各indexPathのcellが横にスワイプされスワイプメニューが表示される際に呼ばれます．
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        // スワイプ中は編集ボタンを押せなくする
        self.editButtonItem.isEnabled = false
    }

    // 各indexPathのcellのスワイプメニューが非表示になった際に呼ばれます．
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        // 編集ボタンを元に戻す
        self.editButtonItem.isEnabled = true
    }

    //
    // サブクラス
    //

    // 前画面終了時のビュー再描画
    func updateView() {
        print("DataViewController:updateView:insertMode=\(self.insertMode)")
        // 編集モード終了
        self.setEditing(false, animated: true)
        // テーブル再読み込み
        self.tableView.reloadData()
        //
    }

    //
    // サブクラス override用ダミー関数
    //

    // セクションの個数を指定
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    // 各セクションごとのセル数を返却
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // セクションタイトルの設定
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    // グリッドデータ設定
    func setCellData(_ base: BaseGridData) {
        print("DataViewController: setCellData dummy!")
    }

    // セル並べ替えの処理
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        print("DataViewController: tableView(moveRowAt) dummy!")
    }
        
    // セル削除の処理
    func deleteData(_ tableView: UITableView,_ indexPath: IndexPath) {
        print("DataViewController: deleteData dummy!")
    }

    // セル追加の処理
    func insertData(_ indexPath: IndexPath) {
        print("DataViewController: insertData dummy!")
    }
    
    // セル更新の処理
    func updateData(_ indexPath: IndexPath) {
        print("DataViewController: updateDate dummy!")
    }

    //
    // 広告表示関係
    //
    func createBannerViewProgrammatically() {
      // [START create_admanager_banner_view]
      // Initialize the banner view.
      bannerView = AdManagerBannerView()
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)

      // This example doesn't give width or height constraints, as the ad size gives the banner an
      // intrinsic content size to size the view.
      // Align the banner's bottom edge with the safe area's bottom edge
      let bannerViewTopConstraint = bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
      // Center the banner horizontally in the view
      let bannerViewCenterXConstraint = bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      // Align the banner's bottom edge with the safe area's bottom edge
      let tableViewTopConstraint = self.tableView.topAnchor.constraint(equalTo: bannerView.bottomAnchor)
      // 制約設定
      NSLayoutConstraint.activate([bannerViewTopConstraint, bannerViewCenterXConstraint, tableViewTopConstraint])
      // [END create_admanager_banner_view]
    }

    func loadInlineAdaptiveBanner() {
      // [START get_width]
      let totalWidth = view.bounds.width
      // Make sure the ad fits inside the readable area.
      let insets = view.safeAreaInsets
      let adWidth = totalWidth - insets.left - insets.right
      // [END get_width]

      // View is not laid out yet, return early.
      guard adWidth > 0 else { return }

      // [START set_adaptive_ad_size]
      bannerView.adSize = portraitAnchoredAdaptiveBanner(width: adWidth)

      // For Ad Manager, the `adSize` property is used for the adaptive banner ad
      // size. The `validAdSizes` property is used as normal for the supported
      // reservation sizes for the ad placement.
      let validAdSize = currentOrientationAnchoredAdaptiveBanner(width: adWidth)
      bannerView.validAdSizes = [nsValue(for: validAdSize)]
      // [END set_adaptive_ad_size]

      // Test ad unit ID for inline adaptive banners.
      bannerView.adUnitID = CONST.AD_UNIT_ID_PROD
      bannerView.load(AdManagerRequest())
    }
}

extension UIImage {
    func tint(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return tintedImage
    }
    func withBackground(color: UIColor, opaque: Bool = true) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
            
        guard let ctx = UIGraphicsGetCurrentContext(), let image = cgImage else { return self }
        defer { UIGraphicsEndImageContext() }
            
        let rect = CGRect(origin: .zero, size: size)
        ctx.setFillColor(color.cgColor)
        ctx.fill(rect)
        ctx.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
        ctx.draw(image, in: rect)
            
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
