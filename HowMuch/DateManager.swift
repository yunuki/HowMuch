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
    
    private var df: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyMMdd"
        return df
    }
    private let cal = Calendar(identifier: .gregorian)
    
    func format(d: Date) -> Int {
        return Int(self.df.string(from: d))!
    }
    
    func firstDayOfMonth() -> Int {
        let currentYear = cal.component(.year, from: Date())
        let currentMonth = cal.component(.month, from: Date())
        var firstDateStr = ""
        if currentMonth < 10 {
            firstDateStr = "\(currentYear%100)0\(currentMonth)01"
        } else {
            firstDateStr = "\(currentYear%100)\(currentMonth)01"
        }
        return cal.component(.weekday, from: df.date(from: firstDateStr)!)
    }
    
    func daysOfMonth() -> Int{
        let currentYear = cal.component(.year, from: Date())
        let currentMonth = cal.component(.month, from: Date())
        if [1,3,5,7,8,10,12].contains(currentMonth) {
            return 31
        } else if [4,6,9,11].contains(currentMonth) {
            return 30
        } else {
            if currentYear % 4 == 0 {
                return 29
            } else {
                return 28
            }
        }
        
    }
}
