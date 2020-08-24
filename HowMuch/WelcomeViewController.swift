//
//  WelcomeViewController.swift
//  HowMuch
//
//  Created by woogie on 2020/08/24.
//  Copyright © 2020 woogie. All rights reserved.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView()
        imageView.image = UIImage(imageLiteralResourceName: "HowMuch")
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self.view)
            make.width.height.equalTo(100)
        }
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        usleep(1000000)
        let calendarVC = self.storyboard?.instantiateViewController(identifier: "CalendarViewController") as! CalendarViewController
        calendarVC.modalPresentationStyle = .fullScreen
        self.present(calendarVC, animated: false, completion: nil)
    }

}
