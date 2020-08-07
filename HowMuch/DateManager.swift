//
//  DateManager.swift
//  HowMuch
//
//  Created by woogie on 2020/08/06.
//  Copyright © 2020 woogie. All rights reserved.
//

import Foundation

class DM {
    static let shared = DM()
    
    private var ymdDF: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyMMdd"
        df.locale = Locale(identifier: "ko")
        return df
    }
    
    private var hmDF: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        df.locale = Locale(identifier: "ko")
        return df
    }
    
    func ymdFormat(d: Date) -> Int {
        return Int(self.ymdDF.string(from: d))!
    }
    
    func hmFormat(d: Date) -> String{
        return self.hmDF.string(from: d)
    }
    
}
