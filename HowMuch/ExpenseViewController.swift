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
        self.expenses = realm.objects(Expense.self).filter { (ex) -> Bool in
            return (ex.id / 100) == self.selectedDate
        }
        self.expenseTableView.reloadData()
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
    
}

extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expense", for: indexPath)
        cell.textLabel?.text = expenses[indexPath.row].desc
        cell.detailTextLabel?.text = "\(expenses[indexPath.row].price)"
        return cell
    }
    
    
}
