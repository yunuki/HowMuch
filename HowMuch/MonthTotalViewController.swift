//
//  MonthTotalViewController.swift
//  HowMuch
//
//  Created by woogie on 2020/08/11.
//  Copyright © 2020 woogie. All rights reserved.
//

import UIKit

class MonthTotalViewController: UIViewController {

    var currentPageDate: Date!
    var monthTotalEx: [Expense] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
        tableView.reloadData()
        print(monthTotalEx)
    }
    
    func updateUI() {
        let ym = DM.shared.ymFormat(d: currentPageDate)
        self.tableView.rowHeight = 70
        self.title = "\(ym/100)년 \(ym%100)월"
    }

}

extension MonthTotalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.monthTotalEx.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthTotalExCell", for: indexPath) as! ExpenseTableViewCell
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        let ymd = DM.shared.ymdFormat(d: monthTotalEx[indexPath.row].time)
        let time = DM.shared.hmFormat(d: monthTotalEx[indexPath.row].time)
        cell.descLabel.text = self.monthTotalEx[indexPath.row].desc
        cell.timeLabel.text = "\(ymd/10000)년 \((ymd/100)%100)월 \(ymd%100)일 \(time)"
        cell.priceLabel.text = nf.string(from: NSNumber(value: self.monthTotalEx[indexPath.row].price))! + "원"

        return cell
    }
    
    
}
