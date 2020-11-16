//
//  AddExpenseViewController.swift
//  HowMuch
//
//  Created by woogie on 2020/11/16.
//  Copyright © 2020 woogie. All rights reserved.
//

import UIKit
import RealmSwift

class AddExpenseViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    
    var datePickerIsHidden = true
    var selectedDate: Date?
    let dateFormatter = DateFormatter()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelGesture()
        priceTextField.keyboardType = .numberPad
        priceTextField.delegate = self
        descTextField.delegate = self
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: Date())
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:))))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.descTextField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard(_ gestureRecognizer: UITapGestureRecognizer) {
        self.priceTextField.resignFirstResponder()
        self.descTextField.resignFirstResponder()
    }
    
    func setLabelGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        timeLabel.isUserInteractionEnabled = true
        timeLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {

        if datePickerIsHidden {
            self.datePickerHeight.constant = CGFloat(162)
            UIView.animate(withDuration: 0.5) {
                self.datePicker.isHidden = false
                self.view.layoutIfNeeded()
            }
            datePickerIsHidden = false
        } else {
            self.datePickerHeight.constant = CGFloat(0)
             UIView.animate(withDuration: 0.5) {
                self.datePicker.isHidden = true
                self.view.layoutIfNeeded()
            }
            datePickerIsHidden = true
        }
    }
    @IBAction func pickerValueChanged(_ sender: Any) {
        self.timeLabel.text = dateFormatter.string(from:datePicker.date)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let strPrice = self.priceTextField.text, Int(strPrice) != nil {
            performSegue(withIdentifier: "backToCalendar", sender: nil)
        } else { //문자입력 에러처리
            let errorAlert = UIAlertController(title: "에러", message: "숫자를 입력하세요", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "backToCalendar" {
             let price = Int(self.priceTextField.text!)!
             let newExpense = Expense()
             if let lastOrder = realm.objects(Expense.self).filter({$0.id/100 == DM.shared.ymdFormat(d: self.selectedDate!)}).max(by: {$0.id < $1.id}) {
                 if lastOrder.id % 100 != 99 {
                     newExpense.id = lastOrder.id+1
                     newExpense.price = Int32(price) * -1
                     newExpense.desc = self.descTextField.text ?? ""
                     newExpense.time = dateFormatter.date(from: self.timeLabel.text!)!
                     newExpense.category = Expense.Category(rawValue: self.categorySegmentedControl.selectedSegmentIndex)!
                     try! self.realm.write {
                         self.realm.add(newExpense)
                     }
                 } else { //최대 내역 초과 에러처리
                     let errorAlert = UIAlertController(title: "에러", message: "더 이상 추가할 수 없습니다", preferredStyle: .alert)
                     errorAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                     self.present(errorAlert, animated: true, completion: nil)
                 }
             } else {
                 newExpense.id = Int32(DM.shared.ymdFormat(d: self.selectedDate!) * 100)
                 newExpense.price = Int32(price) * -1
                 newExpense.desc = self.descTextField.text ?? ""
                 newExpense.time = dateFormatter.date(from: self.timeLabel.text!)!
                 newExpense.category = Expense.Category(rawValue: self.categorySegmentedControl.selectedSegmentIndex)!
                 try! self.realm.write {
                     self.realm.add(newExpense)
                 }
             }
         }
     }
}
