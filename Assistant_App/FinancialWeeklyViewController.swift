//
//  WeeklyViewController.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/21.
//

import Foundation
import UIKit

class FinancialWeeklyViewController: UIViewController{
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    var currentStartDate: Date = Date(){
        didSet {
            UIView.transition(with: self.monthLabel,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: {},
                              completion: nil)
            UIView.transition(with: self.moneyLabel,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: {},
                              completion: nil
            )
        }
    }
    
    var weekStartDate = Date()
    var weekEndDate = Date()
    private var calendar = Calendar.current
    var totalMoney : Int = 0
    
    @IBOutlet weak var financialWeeklyCV : FinancialWeeklyCV!
    
    private var allTransactions : [MoneyStruct] = [
        MoneyStruct(amount: -70, date: Date().dateBy(days: -7, hours: 0), type: "earn", category: "salary", note: "Grocery"),
        MoneyStruct(amount: -60, date: Date().dateBy(days: -6, hours: 0), type: "earn", category: "salary", note: "Grocery"),
        MoneyStruct(amount: -50, date: Date().dateBy(days: -5, hours: 0), type: "earn", category: "salary", note: "Grocery"),
        MoneyStruct(amount: -40, date: Date().dateBy(days: -4, hours: 0), type: "earn", category: "salary", note: "Grocery"),
        MoneyStruct(amount: -30, date: Date().dateBy(days: -3, hours: 0), type: "earn", category: "salary", note: "Grocery"),
        MoneyStruct(amount: -20, date: Date().dateBy(days: -2, hours: 0), type: "earn", category: "salary", note: "Grocery"),
        MoneyStruct(amount: -10, date: Date().dateBy(days: -1, hours: 0), type: "spend", category: "food", note: "Coffee"),
        MoneyStruct(amount: 10, date: Date().dateBy(days: 0, hours: 0), type: "spend", category: "food", note: "Grocery"),
        MoneyStruct(amount: 1000, date: Date().dateBy(days: 0, hours: 0), type: "spend", category: "food", note: "Grocery"),
        MoneyStruct(amount: 100000, date: Date().dateBy(days: 0, hours: 0), type: "spend", category: "food", note: "Grocery"),
        MoneyStruct(amount: 0, date: Date().dateBy(days: 0, hours: 6), type: "spend", category: "food", note: "Grocery"),
        MoneyStruct(amount: 0, date: Date().dateBy(days: 0, hours: 12), type: "spend", category: "food", note: "Grocery"),
        MoneyStruct(amount: 0, date: Date().dateBy(days: 0, hours: 18), type: "spend", category: "food", note: "Grocery"),
        MoneyStruct(amount: 0, date: Date().dateBy(days: 0, hours: 24), type: "spend", category: "food", note:   "Grocery"),
        MoneyStruct(amount: 10, date: Date().dateBy(days: 1, hours: 0), type: "earn", category: "Mercari", note: ""),
        MoneyStruct(amount: 20, date: Date().dateBy(days: 2, hours: 0), type: "spend", category: "Goods", note: "LV Bag"),
        MoneyStruct(amount: 30, date: Date().dateBy(days: 3, hours: 0), type: "earn", category: "Mercari", note: ""),
        MoneyStruct(amount: 40, date: Date().dateBy(days: 4, hours: 0), type: "earn", category: "Mercari", note: ""),
        MoneyStruct(amount: 50, date: Date().dateBy(days: 5, hours: 0), type: "earn", category: "salary", note: "Grocery"),
        MoneyStruct(amount: 60, date: Date().dateBy(days: 6, hours: 0), type: "earn", category: "salary", note: "Grocery"),
        MoneyStruct(amount: 70, date: Date().dateBy(days: 7, hours: 0), type: "earn", category: "salary", note: "Grocery"),

        ]
    
    var groupedTransactions : [WeeklyKey: [MoneyStruct]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        financialWeeklyCV.financialDelegate = self
        
        groupAllTransactions(transactions: allTransactions)
        UpdateWeekLabel()
    }
    
    var monthString: String{
        currentStartDate.formatted(.dateTime.month(.wide))
    }
    
    var year: Int{
        return calendar.component(.year, from: currentStartDate)
    }
    
    var month: Int{
        return calendar.component(.month, from: currentStartDate)
    }
    
    @IBAction func previousWeekPressed(_ sender: UIButton) {
        if let lastWeek = calendar.date(byAdding: .day, value: -7, to: currentStartDate){
            currentStartDate = lastWeek
            UpdateWeekLabel()
        }
    }
    
    @IBAction func nextWeekPressed(_ sender: UIButton) {
        if let nextWeek = calendar.date(byAdding: .day, value: 7, to: currentStartDate){
            currentStartDate = nextWeek
            UpdateWeekLabel()
        }
    }
    
    
    
    //MARK: - GroupAllTransactions, GetWeekRange and UpdateLabels func
    func groupAllTransactions(transactions: [MoneyStruct]){
        for transaction in transactions {
            let date = calendar.dateComponents([.year, .month, .day, .hour], from: transaction.date)
            let yearIndex = date.year!
            let monthIndex = date.month!
            let dateIndex = date.day!
            let hourIndex = date.hour! / 6
            
            let key = WeeklyKey(year: yearIndex, month: monthIndex, day: dateIndex, hour: hourIndex)
            if groupedTransactions[key] == nil{
                groupedTransactions[key] = [transaction]
            }else{
                groupedTransactions[key]?.append(transaction)
            }
        }
        
        financialWeeklyCV.groupedAllTransactions = groupedTransactions
//        for (key, value) in groupedTransactions{
//            print("Key: \(key), Value: \(value.count)")
//        }
    }
    
    func getWeekRange(for date: Date) ->(start: Date, end: Date)?{
        let localDate = calendar.startOfDay(for: date)
        guard let range = calendar.dateInterval(of: .weekOfYear, for: localDate) else{
            return nil
        }
        
        let start = range.start
        guard let end = calendar.date(byAdding: .day, value: 6, to: start) else {
            return nil
        }
        
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: end)!
        
        self.weekStartDate = start
        self.weekEndDate = endOfDay
                
        financialWeeklyCV.weekEndDate = endOfDay
        financialWeeklyCV.weekStartDate = start
        
        return (start, endOfDay)
    }
    
    func UpdateWeekLabel(){
        guard let range = getWeekRange(for: currentStartDate) else{
            return
        }
        
        let startDate = Calendar.current.component(.day, from: range.start)
        let endDate = Calendar.current.component(.day, from: range.end)
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        let startString = formatter.string(from: NSNumber(value: startDate)) ?? "\(startDate)"
        let endString = formatter.string(from: NSNumber(value: endDate)) ?? "\(endDate)"

        monthLabel.text = "\(monthString), \(startString) - \(endString)"
        moneyLabel.text = "¥\(totalMoney)"
    }
}

//MARK: - UpdateMoneyLabel Extension
extension FinancialWeeklyViewController: FinancialWeeklyCVDelegate{
    func updateMoneyLabel(to text: String) {
        DispatchQueue.main.async {
                self.moneyLabel.text = "¥\(text)"
            }
    }
}
    
//MARK: - Date Extension
extension Date{
    var endOfMonth: Int{
        Calendar.current.range(of: .day, in: .month, for: self)?.count ?? 0
    }
    
    func getHourIndex() -> Int{
        let hour = Calendar.current.component(.hour, from: self)
        return hour / 6
    }
    
    
    func dateBy(days: Int, hours: Int) -> Date {
        let now = Date()
        let dayDate = Calendar.current.date(byAdding: .day, value: days, to: now)!
        return Calendar.current.date(byAdding: .hour, value: hours, to: dayDate)!
    }
    
    func getCurrentDate() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    
    func getCurrentDays() -> Int{
        let calendar = Calendar.current
        var dayNumber = calendar.component(.weekday, from: self)
        if(dayNumber == 1 ){
            dayNumber = 7
        }else{
            dayNumber -= 1
        }
        return dayNumber
    }
    
    func getDateAsInt() -> Int{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: self)
        
        let yyyy = components.year ?? 0
        let mm = components.month ?? 0
        let dd = components.day ?? 0
        let hh = components.hour ?? 0
            
        return (yyyy * 1000000) + (mm * 10000) + (dd * 100) + hh
    }
}

