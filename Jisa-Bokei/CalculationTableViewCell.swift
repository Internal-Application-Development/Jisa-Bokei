//
//  CalculationTableViewCell.swift
//  Jisa-Bokei
//
//  Created by 小沢克治 on 2020/10/18.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit

class CalculationTableViewCell: UITableViewCell {

    @IBOutlet weak var flagImage           : UIImageView!
    @IBOutlet weak var cityName            : UILabel!
    @IBOutlet weak var datetime            : UILabel!
    @IBOutlet weak var checkMark           : UIImageView!
    @IBOutlet weak var summerTimeImage     : UIImageView!
    @IBOutlet weak var stackView           : UIStackView!
    @IBOutlet weak var summerTimeImageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // セルのConfigration
    func configureCell(_ data: BaseGridData,_ check: Bool) {
        _ = configureCellCommon(data)
        // アクセサリタイプ
        checkMark.image = check ? UIImage(named:IMAGE.CHECKMARK)?.tint(color: .systemBlue) : nil
    }

    // セルのConfigration（基準日時差表示用）
    func configureCell(_ base: BaseGridData,_ data: BaseGridData) {
        let date2s = configureCellCommon(data)!
        
        // 時差計算と文字列作成
        var date1s:String!
        if base.getKind() == MODE.SELECT.ABBREVIATION {
            date1s = base.getDateStr2()
        } else {
            date1s = base.getDateStr()
        }
        let format = DateFormatter()        //
        let userDefaults = UserDefaults.standard
        if userDefaults.integer(forKey: .DISPLAY_TIMEDIFF) != MODE.TIMEDIFF.UTC {
            if userDefaults.integer(forKey: .TIME_STYLE) == MODE.TIMESTYLE.STANDARD {
                format.setTemplate(.full)
            } else {
                format.setTemplate(.fullJP)
            }
        } else {
            if userDefaults.integer(forKey: .TIME_STYLE) == MODE.TIMESTYLE.STANDARD {
                format.setTemplate(.fullTZ)
            } else {
                format.setTemplate(.fullJPTZ)
            }
        }
        let date1 = format.date(from: date1s)
        let date2 = format.date(from: date2s)
        let span  = date2!.timeIntervalSince(date1!)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .pad
        // 時差文字列追加
        datetime.text! += " ("
        if span >= 0 {
            datetime.text! += "+"
        } else if span > -3600 {
            datetime.text! += "-"
        }
        datetime.text! += formatter.string(from: span)! + ")"

        // アクセサリタイプ
        checkMark.image = nil
    }

    func configureCellCommon(_ data: BaseGridData) -> String? {
        //
        let country_Name   = data.getCountry()     ?? "Unknown"     // 国名/略称
        let city_Name      = data.getCity()        ?? "Unknown"     // 都市名/名称（日本語）
        var isDaylightTime = false                                  // サマータイムか否か
        if data.getKind() == MODE.SELECT.ABBREVIATION {
            // 国旗イメージ
            flagImage.image = UIImage(named: IMAGE.NO_IMAGE)
            // タイトル（Value Text）
            cityName.text = city_Name + " (" + country_Name + ")"
            //
            if city_Name.localizedStandardContains("夏時間") {
                isDaylightTime = true
            }
            // サブタイトル(Detail Text)
            datetime.text = data.getDateStr2()
        } else {
            let country_Code = data.getCountryCode() ?? "Unknown"
            // 国旗イメージ
            flagImage.image = UIImage(named: country_Code) ?? UIImage(named: IMAGE.NO_IMAGE)
            // タイトル（Value Text）
            cityName.text = city_Name + " (" + country_Name + ")"
            // サマータイムアイコン
            if data.isDateSet() {
                let datetime = data.getDate()!
                let timeZone = data.getTimezone()!
                if timeZone.isDaylightSavingTime(for: datetime) {
                    isDaylightTime = true
                }
            }
            // サブタイトル(Detail Text)
            datetime.text = data.getDateStr()
        }
        if isDaylightTime {
            // サマータイム中（アイコン表示）
            summerTimeImage.image = UIImage(named: IMAGE.SUMMER)?.tint(color: .systemYellow)
            summerTimeImageWidth.constant = 24
            stackView.spacing = 4
        } else {
            // サマータイム外（アイコン非表示）
            summerTimeImageWidth.constant = 0
            stackView.spacing = 0
        }
        return datetime.text
    }

}
