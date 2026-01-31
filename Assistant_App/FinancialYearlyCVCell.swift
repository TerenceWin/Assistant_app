//
//  FinancialYearlyCVCell.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/01/29.
//

import UIKit
import Foundation
import JTAppleCalendar

class FinancialYearlyCVCell: UICollectionViewCell{
    @IBOutlet weak var CVMonthLabel : UILabel!
    @IBOutlet weak var CVMonthAmountLabel : UILabel!
    @IBOutlet weak var calendar : JTACMonthView!
        
    let date = Date()
    let formatter = DateFormatter()
    
    var currentYear : Int = 0 {
        didSet{
            DispatchQueue.main.async {
                self.calendar.reloadData()
            }
        }
    }
    var currentMonth : Int = 1{
        didSet{
            DispatchQueue.main.async {
                self.calendar.reloadData()
            }
        }
    }
    
    var monthlyTransactionsArr : [MoneyStruct] = []
    var monthlyTotalAmountArr : Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()

        calendar.calendarDelegate = self
        calendar.calendarDataSource = self
        
        calendar.scrollToDate(Date().getFirstDateOfMonth(for: date), animateScroll: false)
        calendar.isScrollEnabled = false
    }
    
    
}

extension FinancialYearlyCVCell: JTACMonthViewDelegate, JTACMonthViewDataSource{
    func calendar(_ calendar: JTAppleCalendar.JTACMonthView, willDisplay cell: JTAppleCalendar.JTACDayCell, forItemAt date: Date, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) {
        _ = cell as! FinancialYearlyCVCell2

    }
    
    func configureCalendar(_ calendar: JTAppleCalendar.JTACMonthView) -> JTAppleCalendar.ConfigurationParameters {
        let tempCalendar = Calendar.current

        var startComponents = DateComponents()
        startComponents.year = currentYear
        startComponents.month = currentMonth
        startComponents.day = 1
        
        guard let startDate = tempCalendar.date(from: startComponents)
        else{
            return ConfigurationParameters(startDate: Date(), endDate: Date())
        }
        
        let range = tempCalendar.range(of: .day, in: .month, for: startDate)
        let lastDay = range?.count ?? 30
        
        var endComponents = DateComponents()
        endComponents.year = currentYear
        endComponents.month = currentMonth
        endComponents.day = lastDay
        
        guard let endDate = tempCalendar.date(from: endComponents) else {
            return ConfigurationParameters(startDate: Date(), endDate: Date())
        }
        
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       numberOfRows: 6,
                                       calendar: tempCalendar,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfGrid,
                                       hasStrictBoundaries: true)
    }
    
    func calendar(_ calendar: JTAppleCalendar.JTACMonthView, cellForItemAt date: Date, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) -> JTAppleCalendar.JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "yearlyCVCell2", for: indexPath) as! FinancialYearlyCVCell2
        cell.date.text = cellState.text
        
        if cellState.dateBelongsTo == .thisMonth{
            cell.date.textColor = .black
            cell.isHidden = false
        }else{
            cell.date.textColor = .clear
            cell.isHidden = true
        }
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        print(cellState.date)
    }
    

    
    
}
