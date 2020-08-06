//
//  CalendarViewController.swift
//  HowMuch
//
//  Created by woogie on 2020/08/07.
//  Copyright © 2020 woogie. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    
    var selectedDate: Int = 0
    
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.scrollDirection = .vertical
    }
    
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = DM.shared.format(d: date)
        performSegue(withIdentifier: "expense", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "expense" {
            if let vc = segue.destination as? ExpenseViewController {
                vc.selectedDate = self.selectedDate
            }
        }
    }
}
