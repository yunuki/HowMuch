//
//  TabBarController.swift
//  HowMuch
//
//  Created by woogie on 2020/11/16.
//  Copyright © 2020 woogie. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: PlusViewController.self) {
            let actionSheet = UIAlertController(title: "", message: "내역 추가", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "수입", style: .default, handler: { (revenue) in
                NotificationCenter.default.post(name: .addRevenue, object: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "지출", style: .default, handler: { (expense) in
                NotificationCenter.default.post(name: .addExpense, object: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
            return false
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
