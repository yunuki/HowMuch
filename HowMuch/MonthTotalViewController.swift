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
    var filteredMonthTotalEx: [Expense] = []
    var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "내역 검색"
        return sc
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
        setUpSearch()
        tableView.reloadData()
    }
    
    func updateUI() {
        let ym = DM.shared.ymFormat(d: currentPageDate)
        self.tableView.rowHeight = 70
        self.title = "\(ym/100)년 \(ym%100)월"
    }

}

//UITableViewDelegate, UITableViewDataSource 메소드 구현
extension MonthTotalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchController.isActive ? self.filteredMonthTotalEx.count : self.monthTotalEx.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthTotalExCell", for: indexPath) as! ExpenseTableViewCell
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        if self.searchController.isActive {
            let ymd = DM.shared.ymdFormat(d: filteredMonthTotalEx[indexPath.row].time)
            let time = DM.shared.hmFormat(d: filteredMonthTotalEx[indexPath.row].time)
            cell.descLabel.text = self.filteredMonthTotalEx[indexPath.row].desc
            cell.timeLabel.text = "\(ymd/10000)년 \((ymd/100)%100)월 \(ymd%100)일 \(time)"
            cell.priceLabel.text = nf.string(from: NSNumber(value: self.filteredMonthTotalEx[indexPath.row].price))! + "원"
        } else {
            let ymd = DM.shared.ymdFormat(d: monthTotalEx[indexPath.row].time)
            let time = DM.shared.hmFormat(d: monthTotalEx[indexPath.row].time)
            cell.descLabel.text = self.monthTotalEx[indexPath.row].desc
            cell.timeLabel.text = "\(ymd/10000)년 \((ymd/100)%100)월 \(ymd%100)일 \(time)"
            cell.priceLabel.text = nf.string(from: NSNumber(value: self.monthTotalEx[indexPath.row].price))! + "원"
        }

        return cell
    }
    
    
}
//검색 기능 관련 Delegate 메소드 구현
extension MonthTotalViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    //SearchBar에 입력된 텍스트를 포함하는 결과를 TableView에 보이도록
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            filteredMonthTotalEx = monthTotalEx.filter { (ex) -> Bool in
                return ex.desc.contains(text)
            }
            self.tableView.reloadData()
        }
    }
    //검색 기능 설정
    func setUpSearch() {
        tableView.tableHeaderView = searchController.searchBar
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        self.searchController.obscuresBackgroundDuringPresentation = false
    }
}
