//
//  DateFormatter.swift
//  HowMuch
//
//  Created by woogie on 2020/08/06.
//  Copyright © 2020 woogie. All rights reserved.
//

import Foundation

class DF {
    static let shared = DateFormatter()
    
    static func format(d: Date) -> Int {
        self.shared.dateFormat = "yyMMdd"
        return Int(self.shared.string(from: d))!
    }
    
}
