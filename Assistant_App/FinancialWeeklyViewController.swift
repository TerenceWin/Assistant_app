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
    @IBOutlet weak var weekLabel: UILabel!
        
    var todayComponents: DateComponents{
        Calendar.current.dateComponents([.year, .month, .day], from: Date())
    }
    
    var year : Int? {todayComponents.year}
    var month : Int? {todayComponents.month}
    var fromDate: Int? = Calendar.current.component(.day, from: Date())
    var toDate: Int? {
        guard let fromDate, let end = endDateOfMonth else { return nil }
        return min(fromDate + 6, end)
    }
    
    var monthString : String? {
        guard let month else{ return nil }
        return numToMonth(num: month)
    }
    
    var date = Date()
    var endDateOfMonth: Int? {
        Calendar.current.range(of: .day, in: .month, for: date)!.count
    }

    var currentWeekOfMonth: Int {
        Int(ceil(Double(toDate!) / 7.0))
    }

    var lastWeekOfMonth: Int {
        Int(ceil(Double(endDateOfMonth!) / 7.0))
    }
    
    @IBAction func previousWeekPressed(_ sender: UIButton) {
        guard fromDate! > 1 else { return }

        fromDate = max(fromDate! - 7, 1)
        UpdateWeekLabel()
    }
    
    @IBAction func nextWeekPressed(_ sender: UIButton) {
        guard toDate! < endDateOfMonth! else { return }

        fromDate = toDate! + 1
        UpdateWeekLabel()
    }
    
    func UpdateWeekLabel(){
        monthLabel.text = "\(monthString!)"
        weekLabel.text = "Week \(currentWeekOfMonth) Out of \(lastWeekOfMonth)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = endDateOfMonth
        UpdateWeekLabel()
    }
}
    
    func numToMonth(num: Int) -> String{
        switch num {
        case 1:
            return "January"
        case 2:
            return "Fabruary"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return "Wtf? "
        }
    }
//MARK: - Date Extension to get last date of Month
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
}

