//
//  Constants.swift
//  Jisa-Bokei
//
//  Created by 小沢克治 on 2018/03/14.
//  Copyright © 2018年 Private. All rights reserved.
//

import Foundation

struct MODE {
    struct START {
        public static let CALC  = 0
        public static let CLOCK = 1
        public static let LAST  = 2
    }
    struct SELECT {
        public static let AREA         = 0
        public static let MAP          = 1
        public static let ABBREVIATION = 2
    }
    struct TIMEDIFF {
        public static let NONE = 0
        public static let UTC  = 1
        public static let BASE = 2
    }
    struct TIMESTYLE {
        public static let STANDARD = 0
        public static let KM       = 1
    }
}

struct ID {
    struct CELL {
        public static let CALC       = "CalculationTableViewCell"
        public static let CLOCK      = "ClockTableViewCell"
        public static let LIST       = "ListCell"
        public static let DATA       = "DataCell"
        public static let BASE       = "ProtoCell"
        public static let AREA       = "AreaCell"
        public static let DATETIME   = "DatetimeCell"
        public static let DATEPICKER = "DatePickerCell"
        public static let TIMEZONE   = "TimezoneCell"
    }
    struct STORYBOARD {
        public static let SPLASH      = "Splash"
        public static let MAIN        = "Main"
        public static let SELECT_BASE = "SelectBaseNavi"
        public static let CITY_SELECT = "CitySelectNavi"
        public static let SELF        = "self"
    }
}

struct CONST {
    public static let DATAVIEW_ROWHEIGHT = 62
    public static let DATEPICKER_ROWHEIGHT = 216
    public static let BASECELL_ROWHEIGHT = 44
    public static let SECTION0_MAX = 3
    public static let SECTION1_MAX = 5
    public static let CLOCK_MAX = (SECTION0_MAX + SECTION1_MAX)
    public static let NOT_SET  = "未設定"
    public static let CALC     = "時差計算"
    public static let CLOCK    = "世界時計"
    public static let DELETE   = "削除"
    public static let INSERT   = "挿入"
    public static let UPDATE   = "変更"
    public static let AD_UNIT_ID_TEST = "ca-app-pub-3940256099942544/2435281174"
    public static let AD_UNIT_ID_PROD = "ca-app-pub-9743348087007542/7399184966"
}

struct ENTITY {
    public static let TIMEZONEID   = "TimeZoneIDModel"
    public static let ABBREVIATION = "AbbreviationModel"
    struct ITEM {
        public static let AREA        = "area"
        public static let COUNTRYNAME = "country_name"
        public static let COUNTRYCODE = "countryCode"
        public static let CITYNAME    = "city_name"
        public static let CHECKED     = "checked"
        public static let ID          = "id"
        public static let TIMEZONEID  = "timezoneID"
        public static let LATITUDE    = "latitude"
        public static let LONGTITUDE  = "longtitude"
        public static let GEONAMEID   = "geoname_id"
    }
}

struct UDEFS {
    struct ITEM {
        public static let CALC            = "Cal"
        public static let CLOCK           = "Clk"
        public static let STARTUP_MODE    = "STARTUP"
        public static let TIMEDIFF_MODE   = "TIMEDIFF"
        public static let TIME_STYLE      = "TimeStyle"
        public static let COUNTRY_NAME    = "CountryNm"
        public static let COUNTRY_CODE    = "CountryCd"
        public static let CITY_NAME       = "City"
        public static let LATITUDE        = "Latitude"
        public static let LONGTITUDE      = "Longtitude"
        public static let LATITUDE_SPAN   = "LatiSpan"
        public static let LONGTITUDE_SPAN = "LongSpan"
        public static let DATETIME        = "Datetime"
        public static let TIMEZONE_ID     = "TZID"
        public static let RECORD_ID       = "RecID"
        public static let SELECT_KIND     = "SelKind"
        public static let SECONDFROMGMT   = "SecFrmGMT"
    }
}

struct KEY {
    var type:String
    public static let IX_SELECT_PARTNER_CITY = "PartnerCity"
    func NumberOfSection() -> String {
//        let name = "NumberOf" + type + "ItemsInSection"
        let name = type + "_Sections"
        return name
    }
    func ItemsInSection(_ kind:String,_ row:Int) -> String {
//        let name = kind + String(row) + "Of" + type + "ItemsInSection"
        let name = type + "_" + kind + String(row)
        return name
    }
    func NumberOfSection(_ sec:Int) -> String {
//        let name = "NumberOf" + type + "ItemsInSection" + String(sec)
        let name = type + String(sec) + "_Items"
        return name
    }
    func ItemsInSection(_ kind:String,_ row:Int,_ sec:Int) -> String {
//        let name = kind + String(row) + "Of" + type + "ItemsInSection" + String(sec)
        let name = type + "_" + kind + String(sec) + "-" + String(row)
        return name
    }
}

struct PLIST {
    public static let TIMEZONEID_MASTER = "TimeZoneIDMaster.plist"
    public static let ABBREVIATION      = "Abbreviations.plist"
    struct ITEM {
        public static let ID          = "id"
        public static let GEONAMEID   = "geonameid"
        public static let LATITUDE    = "latitude"
        public static let LONGTITUDE  = "longtitude"
        public static let COUNTRYCODE = "countrycode"
        public static let TIMEZONEID  = "timezone"
        public static let AREA        = "area"
        public static let COUNTRYNAME = "country_name"
        public static let CITYNAME    = "city_name"
        public static let ABBR        = "abbr"
        public static let DESCJP      = "descJp"
        public static let DESCEN      = "descEn"
        public static let SIGN        = "sign"
        public static let HOUR        = "hour"
        public static let MINUTE      = "minute"
    }
    func Record(_ id:Int, _ kind:String) -> String {
        let name = "record" + String(id) + "." + kind
        return name
    }
    func Record2(_ id:Int, _ kind:String) -> String {
        let name = "record" + ("000"+String(id)).suffix(3) + "." + kind
        return name
    }
}

struct TITLE {
    public static let SECTION0    = "自分の国（基準国）"
    public static let SECTION1    = "調べたい国（複数選択可能）"
    public static let AREA_SELECT = "地域選択"
}

struct IMAGE {
    public static let CHECKMARK = "Checkmark"
    public static let TRASH     = "trash"
    public static let INSERT    = "plus"
    public static let UPDATE    = "square.and.pencil"
    public static let NO_IMAGE  = "NoImage"
    public static let SUMMER    = "Sun"
}

enum FETCHTYPE: Int8 {
    case COUNTRY_SELECT
    case CITY_SELECT
    case TYPE_CLOCK
    case TYPE_CALC
}
