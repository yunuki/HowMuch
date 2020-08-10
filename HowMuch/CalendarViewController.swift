//
//  CalendarViewController.swift
//  HowMuch
//
//  Created by woogie on 2020/08/07.
//  Copyright © 2020 woogie. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController {
    
    var selectedDate: Int = 0
    let realm = try! Realm()
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var statisticStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        statisticStackView.subviews.forEach({DesignHelper.shared.setBackgroundColorAndShadow(view: $0)})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.calendar.reloadData()
    }
    
    func setupCalendar() {
        calendar.scrollDirection = .vertical
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.subtitleFont = UIFont.systemFont(ofSize: 12)
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .black
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "cell")
        DesignHelper.shared.setBackgroundColorAndShadow(view: calendar)
    }
    
    @IBAction func unwindToCalendarVC(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "expense" {
            if let nc = segue.destination as? UINavigationController, let vc = nc.topViewController as? ExpenseViewController {
                vc.selectedDate = self.selectedDate
            }
        }
    }
    
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.deselect(date)
        self.selectedDate = DM.shared.ymdFormat(d: date)
        performSegue(withIdentifier: "expense", sender: nil)
    }
    
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let filteredEx = realm.objects(Expense.self).filter({($0.id/100) == DM.shared.ymdFormat(d: date)})
        let sumOfPrice = filteredEx.reduce(0) { (result: Int32, element: Expense) -> Int32 in
            return result + element.price
        }
        
        if sumOfPrice > 0 {
            return "💰"
        } else if sumOfPrice < 0{
            return "💸"
        } else {
            return ""
        }

    }
 
    
    
}
