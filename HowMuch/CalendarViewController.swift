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
    
    let realm = try! Realm()
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var statisticStackView: UIStackView!
    @IBOutlet weak var dayTotalButton: UIButton!
    @IBOutlet weak var monthTotalButton: UIButton!
    @IBOutlet weak var monthTotalLabel: UILabel!
    @IBOutlet weak var dayTotalLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        statisticStackView.subviews.forEach({DesignHelper.shared.setBackgroundColorAndShadow(view: $0, r: 0.999, g: 0.999, b: 0.999, alpha: 0.8)})
        setDayTotal(date: calendar.today!)
        setMonthTotal(date: calendar.today!)
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.calendar.reloadData()
        setDayTotal(date: calendar.selectedDate!)
        setMonthTotal(date: calendar.currentPage)
    }
    
    func setupCalendar() {
        calendar.scrollDirection = .vertical
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerTitleColor = UIColor.link
        calendar.appearance.weekdayTextColor = UIColor.link
        calendar.appearance.selectionColor = UIColor.link
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.subtitleFont = UIFont.systemFont(ofSize: 17)
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.borderRadius = 0.3
        calendar.select(calendar.today!, scrollToDate: false)
        DesignHelper.shared.setBackgroundColorAndShadow(view: calendar, r: 0.999, g: 0.999, b: 0.999, alpha: 0.8)
        
    }
    
    @IBAction func unwindToCalendarVC(segue: UIStoryboardSegue) {
        
    }
    
    
    func setDayTotal(date: Date) {
        DesignHelper.shared.setShadowToLabel(view: self.dayTotalLabel)
        let filteredEx = realm.objects(Expense.self).filter({$0.id/100 == DM.shared.ymdFormat(d: date)})
        if filteredEx.count == 0 {
            self.dayTotalButton.setTitle("내역 추가", for: .normal)
        } else {
            let dayTotal = filteredEx.reduce(0) { (result: Int32, ex: Expense) -> Int32 in
                return result + ex.price
            }
            if dayTotal > 0 {
                self.dayTotalButton.setTitle("+\(dayTotal)원", for: .normal)
            } else {
                self.dayTotalButton.setTitle("\(dayTotal)원", for: .normal)
            }
        }
    }
    
    func setMonthTotal(date: Date) {
        DesignHelper.shared.setShadowToLabel(view: self.monthTotalLabel)
        let filteredEx = realm.objects(Expense.self).filter({$0.id/10000 == DM.shared.ymFormat(d: date)})
        if filteredEx.count == 0 {
            self.monthTotalButton.setTitle("내역 없음", for: .normal)
        } else {
            let monthTotal = filteredEx.reduce(0) { (result: Int32, ex: Expense) -> Int32 in
                return result + ex.price
            }
            if monthTotal > 0 {
                self.monthTotalButton.setTitle("+\(monthTotal)원", for: .normal)
            } else {
                self.monthTotalButton.setTitle("\(monthTotal)원", for: .normal)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dayTotal" {
            if let nc = segue.destination as? UINavigationController, let vc = nc.topViewController as? DayTotalViewController {
                let selectedDate = DM.shared.ymdFormat(d: calendar.selectedDate!)
                vc.selectedDate = selectedDate
                vc.dayTotalEx = realm.objects(Expense.self).filter({$0.id/100 == selectedDate}).sorted(by: {$0.id < $1.id})
            }
        } else if segue.identifier == "monthTotal" {
            if let nc = segue.destination as? UINavigationController, let vc = nc.topViewController as? MonthTotalViewController {
                let currentYearMonth = DM.shared.ymFormat(d: calendar.currentPage)
                vc.currentPageDate = calendar.currentPage
                vc.monthTotalEx = realm.objects(Expense.self).filter({$0.id/10000 == currentYearMonth}).sorted(by: {$0.id < $1.id})
            }
        }
    }
    
    @IBAction func dayTotalButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "dayTotal", sender: nil)
    }
    @IBAction func monthTotalButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "monthTotal", sender: nil)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        setDayTotal(date: date)
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
 
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        setMonthTotal(date: calendar.currentPage)
    }
    
}
