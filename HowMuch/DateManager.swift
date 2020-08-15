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
    
    private let df = DateFormatter()
    
    func ymdFormat(d: Date) -> Int {
        self.df.dateFormat = "yyMMdd"
        return Int(self.df.string(from: d))!
    }
    
    func hmFormat(d: Date) -> String{
        self.df.dateFormat = "HH:mm"
        return self.df.string(from: d)
    }
    
    func ymFormat(d: Date) -> Int {
        self.df.dateFormat = "yyMM"
        return Int(self.df.string(from: d))!
    }
    
}
