//
//  DesignHelper.swift
//  HowMuch
//
//  Created by woogie on 2020/08/11.
//  Copyright © 2020 woogie. All rights reserved.
//

import UIKit

class DesignHelper {
    static let shared = DesignHelper()
    
    func setBackgroundColorAndShadow(view: UIView) {
        view.backgroundColor = UIColor(red: 237/255, green: 245/255, blue: 255/255, alpha: 0.8)
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 4
    }
}
