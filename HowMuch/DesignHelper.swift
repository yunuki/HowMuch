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
    
    func setBackgroundColorAndShadow(view: UIView, r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: alpha)
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 4
    }
}
