//
//  ExpenseViewController.swift
//  HowMuch
//
//  Created by woogie on 2020/08/07.
//  Copyright © 2020 woogie. All rights reserved.
//

import UIKit
import RealmSwift

class ExpenseViewController: UIViewController {
    
    var selectedDate: Int = 0
    var expenses: [Expense] = []
    let realm = try! Realm()
    @IBOutlet weak var expenseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
        self.expenses = realm.objects(Expense.self).filter { (ex) -> Bool in
            return (ex.id / 100) == self.selectedDate
        }
        expenses = self.expenses.sorted(by: {$0.id < $1.id})
        self.expenseTableView.reloadData()
    }
    
    func updateUI() {
        expenseTableView.rowHeight = 70
        print(self.selectedDate)
        self.title = "\(self.selectedDate/100%100)월\(self.selectedDate%100)일"
    }

    
    @IBAction func addButtonTapped(_ sender: Any) {
        let addAlert = UIAlertController(title: "추가", message: "\n\n", preferredStyle: .alert)
        let plusMinusSegment = UISegmentedControl(items: ["수입", "지출"])
        plusMinusSegment.frame = CGRect(x: 85, y: 50, width: 100, height: 40)
        
        addAlert.view.addSubview(plusMinusSegment)
        let ok = UIAlertAction(title: "확인", style: .default) { (ok) in
            if let strPrice = addAlert.textFields![1].text {
                if let price = Int(strPrice) {
                    let newExpense = Expense()
                    if let lastOrder = self.expenses.max(by: {$0.id < $1.id}) {
                        newExpense.id = lastOrder.id+1
                    } else {
                        newExpense.id = Int32(self.selectedDate * 100)
                    }
                    newExpense.price = plusMinusSegment.selectedSegmentIndex == 0 ? Int32(price) : Int32(price) * -1
                    newExpense.desc = addAlert.textFields![0].text ?? ""
                    newExpense.time = DM.shared.hmFormat(d: Date())
                    try! self.realm.write {
                        self.realm.add(newExpense)
                    }
                    self.expenses.append(newExpense)
                    self.expenseTableView.reloadData()
                } else { //문자입력 에러처리
                    print("숫자를 입력하세요!")
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        addAlert.addAction(cancel)
        addAlert.addAction(ok)
        addAlert.addTextField { (descTextField) in
            descTextField.placeholder = "항목을 입력하세요"
        }
        addAlert.addTextField { (priceTextField) in
            priceTextField.keyboardType = .numberPad
            priceTextField.placeholder = "금액을 입력하세요"
        }
        self.present(addAlert, animated: true, completion: nil)
        
    }
    @IBAction func cameraButtonTapped(_ sender: Any) {
        
    }
    
}

extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expense", for: indexPath) as! ExpenseTableViewCell
        cell.descLabel.text = self.expenses[indexPath.row].desc
        cell.timeLabel.text = self.expenses[indexPath.row].time
        cell.priceLabel.text = "\(self.expenses[indexPath.row].price)원"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(self.expenses[indexPath.row])
    }
    
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
    }
    
    
}
