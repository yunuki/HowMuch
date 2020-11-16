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

extension Notification.Name {
    static let addExpense = Notification.Name("addExpense")
    static let addRevenue = Notification.Name("addRevenue")
}

class CalendarViewController: UIViewController {
    
    let realm = try! Realm()
    var isWeek = true
    var expenses: [Expense] = []
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        setTableUI()
        setGesture()
        setNotification()
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(addExpense(_:)), name: .addExpense, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addRevenue(_:)), name: .addRevenue, object: nil)
    }
    
    @objc func addExpense(_ notification: Notification) {
        let addExpenseVC = self.storyboard!.instantiateViewController(withIdentifier: "expense") as! AddExpenseViewController
        addExpenseVC.modalPresentationStyle = .automatic
        addExpenseVC.selectedDate = self.calendar.selectedDate
        self.present(addExpenseVC, animated: true, completion: nil)
    }
    
    @objc func addRevenue(_ notification: Notification) {
        
    }

    func setGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        swipeUp.direction = .up
        swipeUp.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        swipeDown.direction = .down
        swipeDown.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func swipeHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.direction {
        case .up:
            if !self.isWeek {
                calendar.setScope(.week, animated: true)
                self.isWeek = true
            }
            break
        case .down:
            if self.isWeek {
                calendar.setScope(.month, animated: true)
                self.isWeek = false
            }
            break
        default:
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.calendar.reloadData()
    }
    
    //달력 설정
    func setupCalendar() {
        calendar.scrollDirection = .horizontal
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
        calendar.scope = .week
        calendar.calendarHeaderView.scrollEnabled = false
        calendar.select(Date())
        calendar(self.calendar, didSelect: Date(), at: .current)
    }
    
    
    @IBAction func unwindToCalendarVC(segue: UIStoryboardSegue) {
        self.expenses = realm.objects(Expense.self).filter({$0.id/100 == DM.shared.ymdFormat(d: self.calendar.selectedDate!)})
        self.tableView.reloadData()
        self.calendar.reloadData()
    }

}

//FSCalendarDelegate, FSCalendarDataSource 메소드 구현
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    //날짜 선택시 호출되는 Delegate 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        self.expenses = realm.objects(Expense.self).filter({$0.id/100 == DM.shared.ymdFormat(d: date)})
        self.tableView.reloadData()
    }

    
    //subtitle을 설정하는 DataSource 메소드
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
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.heightContraint.constant = bounds.height //calender의 height constraint를 현재 calendar의 bound의 height(scope 바뀔 때마다 변하는 높이)로 변경
        self.view.layoutIfNeeded() // constraint 변화있을 때 애니메이션
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableUI() {
        self.tableView.rowHeight = 100
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleTableViewSwipe(_:)))
        swipeLeft.direction = .left
        self.tableView.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleTableViewSwipe(_:)))
        swipeRight.direction = .right
        self.tableView.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleTableViewSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.direction {
        case .left:
            self.calendar.select(self.calendar.selectedDate?.addingTimeInterval(86400))
            self.calendar(self.calendar, didSelect: self.calendar.selectedDate!, at: .current)
            break
        case .right:
            self.calendar.select(self.calendar.selectedDate?.addingTimeInterval(-86400))
            self.calendar(self.calendar, didSelect: self.calendar.selectedDate!, at: .current)
            break
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expense", for: indexPath) as! ExpenseTableViewCell
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        cell.descLabel.text = self.expenses[indexPath.row].desc
        cell.timeLabel.text = DM.shared.hmFormat(d: self.expenses[indexPath.row].time)
        cell.priceLabel.text = nf.string(from: NSNumber(value: self.expenses[indexPath.row].price))! + "원"
        return cell
    }
    //cell을 삭제하는 DataSource 메소드 -> 내역 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedExpenseId = self.expenses[indexPath.row].id
            self.expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let deletedExpense = realm.objects(Expense.self).filter({$0.id == deletedExpenseId})
            try! realm.write {
                realm.delete(deletedExpense)
            }
        }
        self.calendar.reloadData()
    }
    
    /*
    //cell이 선택되었을 때 호출되는 Delegate 메소드 -> 내역 수정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let editAlert = UIAlertController(title: "수정", message: "\n\n", preferredStyle: .alert)
        editAlert.addTextField { (descTextField) in
            descTextField.text = self.expenses[indexPath.row].desc
        }
        editAlert.addTextField { (priceTextField) in
            priceTextField.keyboardType = .numberPad
            priceTextField.text = "\(self.expenses[indexPath.row].price > 0 ? self.expenses[indexPath.row].price : self.expenses[indexPath.row].price * -1)"
        }
        let plusMinusSegment = UISegmentedControl(items: ["수입", "지출"])
        plusMinusSegment.frame = CGRect(x: 85, y: 50, width: 100, height: 40)
        plusMinusSegment.selectedSegmentIndex = 1
        editAlert.view.addSubview(plusMinusSegment)
        let ok = UIAlertAction(title: "확인", style: .default) { (ok) in
            if let strPrice = editAlert.textFields![1].text {
                if let price = Int(strPrice) {
                    try! self.realm.write {
                        self.expenses[indexPath.row].desc = editAlert.textFields![0].text ?? ""
                        self.expenses[indexPath.row].price = plusMinusSegment.selectedSegmentIndex == 0 ? Int32(price) : Int32(price) * -1
                        self.realm.add(self.expenses[indexPath.row], update: .modified)
                    }
                    self.tableView.reloadData()
                } else { //문자입력 에러처리
                    let errorAlert = UIAlertController(title: "에러", message: "숫자를 입력하세요", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
            self.calendar.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        editAlert.addAction(cancel)
        editAlert.addAction(ok)
        self.present(editAlert, animated: true, completion: nil)
        
    }
 */
}
