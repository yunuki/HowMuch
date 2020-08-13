//
//  DayTotalViewController.swift
//  HowMuch
//
//  Created by woogie on 2020/08/07.
//  Copyright © 2020 woogie. All rights reserved.
//

import UIKit
import RealmSwift

class DayTotalViewController: UIViewController {
    
    var selectedDate: Int = 0
    var dayTotalEx: [Expense] = []
    let realm = try! Realm()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
        self.tableView.reloadData()
    }
    
    func updateUI() {
        tableView.rowHeight = 70
        self.title = "\(self.selectedDate/100%100)월\(self.selectedDate%100)일"
    }

    
    @IBAction func addButtonTapped(_ sender: Any) {
        let addAlert = UIAlertController(title: "추가", message: "\n\n", preferredStyle: .alert)
        addAlert.addTextField { (descTextField) in
            descTextField.placeholder = "항목을 입력하세요"
        }
        addAlert.addTextField { (priceTextField) in
            priceTextField.keyboardType = .numberPad
            priceTextField.placeholder = "금액을 입력하세요"
        }
        let plusMinusSegment = UISegmentedControl(items: ["수입", "지출"])
        plusMinusSegment.frame = CGRect(x: 85, y: 50, width: 100, height: 40)
        plusMinusSegment.selectedSegmentIndex = 1
        addAlert.view.addSubview(plusMinusSegment)
        let ok = UIAlertAction(title: "확인", style: .default) { (ok) in
            if let strPrice = addAlert.textFields![1].text {
                if let price = Int(strPrice) {
                    let newExpense = Expense()
                    if let lastOrder = self.dayTotalEx.max(by: {$0.id < $1.id}) {
                        if lastOrder.id % 100 != 99 {
                            newExpense.id = lastOrder.id+1
                            newExpense.price = plusMinusSegment.selectedSegmentIndex == 0 ? Int32(price) : Int32(price) * -1
                            newExpense.desc = addAlert.textFields![0].text ?? ""
                            try! self.realm.write {
                                self.realm.add(newExpense)
                            }
                            self.dayTotalEx.append(newExpense)
                            self.tableView.reloadData()
                        } else { //최대 내역 초과 에러처리
                            let errorAlert = UIAlertController(title: "에러", message: "더 이상 추가할 수 없습니다", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                    } else {
                        newExpense.id = Int32(self.selectedDate * 100)
                        newExpense.price = plusMinusSegment.selectedSegmentIndex == 0 ? Int32(price) : Int32(price) * -1
                        newExpense.desc = addAlert.textFields![0].text ?? ""
                        try! self.realm.write {
                            self.realm.add(newExpense)
                        }
                        self.dayTotalEx.append(newExpense)
                        self.tableView.reloadData()
                    }
                } else { //문자입력 에러처리
                    let errorAlert = UIAlertController(title: "에러", message: "숫자를 입력하세요", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        addAlert.addAction(cancel)
        addAlert.addAction(ok)
        self.present(addAlert, animated: true, completion: nil)
        
    }
    @IBAction func cameraButtonTapped(_ sender: Any) {
        
    }
    
}

extension DayTotalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dayTotalEx.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayTotalExCell", for: indexPath) as! ExpenseTableViewCell
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        cell.descLabel.text = self.dayTotalEx[indexPath.row].desc
        cell.timeLabel.text = DM.shared.hmFormat(d: self.dayTotalEx[indexPath.row].time)
        cell.priceLabel.text = nf.string(from: NSNumber(value: self.dayTotalEx[indexPath.row].price))! + "원"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let editAlert = UIAlertController(title: "수정", message: "\n\n", preferredStyle: .alert)
        editAlert.addTextField { (descTextField) in
            descTextField.text = self.dayTotalEx[indexPath.row].desc
        }
        editAlert.addTextField { (priceTextField) in
            priceTextField.keyboardType = .numberPad
            priceTextField.text = "\(self.dayTotalEx[indexPath.row].price > 0 ? self.dayTotalEx[indexPath.row].price : self.dayTotalEx[indexPath.row].price * -1)"
        }
        let plusMinusSegment = UISegmentedControl(items: ["수입", "지출"])
        plusMinusSegment.frame = CGRect(x: 85, y: 50, width: 100, height: 40)
        plusMinusSegment.selectedSegmentIndex = 1
        editAlert.view.addSubview(plusMinusSegment)
        let ok = UIAlertAction(title: "확인", style: .default) { (ok) in
            if let strPrice = editAlert.textFields![1].text {
                if let price = Int(strPrice) {
                    try! self.realm.write {
                        self.dayTotalEx[indexPath.row].desc = editAlert.textFields![0].text ?? ""
                        self.dayTotalEx[indexPath.row].price = plusMinusSegment.selectedSegmentIndex == 0 ? Int32(price) : Int32(price) * -1
                        self.realm.add(self.dayTotalEx[indexPath.row], update: .modified)
                    }
                    self.tableView.reloadData()
                } else { //문자입력 에러처리
                    let errorAlert = UIAlertController(title: "에러", message: "숫자를 입력하세요", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        editAlert.addAction(cancel)
        editAlert.addAction(ok)
        self.present(editAlert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedExpenseId = self.dayTotalEx[indexPath.row].id
            self.dayTotalEx.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let deletedExpense = realm.objects(Expense.self).filter({$0.id == deletedExpenseId})
            try! realm.write {
                realm.delete(deletedExpense)
            }
        }
    }
    
    
}
