//
//  Model.swift
//  HowMuch
//
//  Created by woogie on 2020/08/06.
//  Copyright © 2020 woogie. All rights reserved.
//

import Foundation
import RealmSwift

class Expense: Object {
    @objc dynamic var id: Int32 = 0
    @objc dynamic var price: Int32 = 0
    @objc dynamic var desc: String = ""
    @objc dynamic var time: Date = Date()
}
