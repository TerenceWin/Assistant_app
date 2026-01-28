//
//  FinancialMonthlyViewController.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/01/17.
//

import Foundation
import UIKit
import JTAppleCalendar

class FinancialMonthlyViewController : UIViewController{
    
    @IBOutlet weak var monthLabel : UILabel!
    @IBOutlet weak var totalAmount : UILabel!
    @IBOutlet weak var DaysLabel : UIStackView!
    @IBOutlet weak var monthlyCalendar: JTACMonthView!
    @IBOutlet weak var earnTV : UITableView!
    @IBOutlet weak var spendTV: UITableView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var currentTransaction : MoneyStruct?
    var allTransactions : [MoneyStruct]?
    var earnTypeTransactions : [MoneyStruct] = []
    var spendTypeTransactions : [MoneyStruct] = []
    var currentMonthTransaction: [MoneyStruct] = []
    
    var date = Date()
    var formattedDate = ""
    var selectedDate = ""
    var totalMoney : Int = 0
    let formatter = DateFormatter()
    var year = Date().formatted(.dateTime.year())
    var month = Date().formatted(.dateTime.month(.wide))
    
    @IBAction func previousButtonPressed(_ sender : UIButton){
        guard let previousDate = Calendar.current.date(byAdding: .month, value: -1, to: date) else{ return }
        date = previousDate
        month = date.formatted(.dateTime.month(.wide))
        year = date.formatted(.dateTime.year())
        updateMonthLabel()
        calculateMonthlyTotal()
        monthlyCalendar.scrollToDate(Date().getFirstDateOfMonth(for: date), animateScroll: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton){
        guard let nextDate = Calendar.current.date(byAdding: .month, value: 1, to: date) else { return }
        date = nextDate
        month = date.formatted(.dateTime.month(.wide))
        year = date.formatted(.dateTime.year())
        updateMonthLabel()
        calculateMonthlyTotal()
        monthlyCalendar.scrollToDate(Date().getFirstDateOfMonth(for: date), animateScroll: true)
    }
    
    func fetchTransactions(){
        TransactionManager.shared.loadData{ [weak self] in
            DispatchQueue.main.async{
                guard let self = self else{
                    print("View Controller was deallocated. Skipping UI update.")
                    return }
                self.allTransactions = TransactionManager.shared.allTransactions
                self.seperateTransactionForOneDay()
                self.calculateMonthlyTotal()
            }
        }
    }
    
    func seperateTransactionForOneDay(){
        earnTypeTransactions = []
        spendTypeTransactions = []
        
        guard let all = allTransactions else{ return }
        for transaction in all{
            if transaction.date.getDateInYYYYMMDD() == selectedDate{
                if transaction.type == "earn"{
                    earnTypeTransactions.append(transaction)
                }else{
                    spendTypeTransactions.append(transaction)
                }
            }
        }
        
        earnTV.reloadData()
        spendTV.reloadData()
    }
    
    func calculateMonthlyTotal(){
        guard let all = allTransactions else {return}
        totalMoney = 0
        for transaction in all{
            let transactionMonth = transaction.date.formatted(.dateTime.month(.wide))
            if month == transactionMonth{
                currentMonthTransaction.append(transaction)
                if transaction.type == "earn"{
                    totalMoney += transaction.amount
                }else{
                    totalMoney -= transaction.amount
                }
            }
        }
        updateTotalAmountLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formattedDate = date.getDateInYYYYMMDD()
        selectedDate = date.getDateInYYYYMMDD()
        updateMonthLabel()
        givesBorder()
        monthlyCalendar.calendarDataSource = self
        monthlyCalendar.calendarDelegate = self
        
        fetchTransactions()
        
        earnTV.delegate = self
        earnTV.dataSource = self
        let earnNib = UINib(nibName: "FinancialMonthlyEarnTVCell", bundle: nil)
        earnTV.register(earnNib, forCellReuseIdentifier: "financialMonthlyEarnTVCell")
        
        spendTV.delegate = self
        spendTV.dataSource = self
        let spendNib = UINib(nibName: "FinancialMonthlySpendTVCell", bundle: nil)
        spendTV.register(spendNib, forCellReuseIdentifier: "financialMonthlySpendTVCell")
        
        if #available(iOS 15.0, *) {
            earnTV.sectionHeaderTopPadding = 0
            spendTV.sectionHeaderTopPadding = 0
        }
        
        monthlyCalendar.scrollToDate(Date().getFirstDateOfMonth(for: date), animateScroll: false)
        monthlyCalendar.isScrollEnabled = false
        
    }

    func updateMonthLabel(){
        monthLabel.text = "\(month) \(year)"
    }
    
    func updateTotalAmountLabel(){
        totalAmount.text = "\(totalMoney)"
    }
    
    func givesBorder(){
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor.systemGray
        bottomBorder.frame = CGRect(x: 0, y: DaysLabel.frame.height - 1.5, width: DaysLabel.frame.width, height: 1.5)
        bottomBorder.autoresizingMask = [.flexibleWidth]
        DaysLabel.addSubview(bottomBorder)
        
        earnTV.backgroundColor = UIColor.white
        spendTV.backgroundColor = UIColor.white
    }
}

//MARK: - Reload VC after edit view
extension FinancialMonthlyViewController: reloadFinancialVCDelegate{
    func addedTransaction() {
        fetchTransactions()
        print("Successfully fetched New Transaction")
    }
}

//MARK: -Segue to Edit View

extension FinancialMonthlyViewController: FinancialSeugeToEditViewDelegate{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MonthlyToEditView"{
            if let destination = segue.destination as? FinancialWeeklyEditView{
                destination.delegate = self
                if let transaction = sender as? MoneyStruct{
                    destination.currentTransaction = transaction
                    destination.isNew = false
                    print("with transaction")
                }else{
                    destination.isNew = true
                }
            }
        }
    }
    
    func UpdateSelectedCell(_ transaction: MoneyStruct) {
        performSegue(withIdentifier: "MonthlyToEditView", sender: transaction)
    }
}

//MARK: - Calendar View (JTAppleCalendar's CV)
extension FinancialMonthlyViewController: JTACMonthViewDataSource, JTACMonthViewDelegate{
    
    func calendar(_ calendar: JTAppleCalendar.JTACMonthView, willDisplay cell: JTAppleCalendar.JTACDayCell, forItemAt date: Date, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) {
        _ = cell as! FinancialMonthlyCalendarViewCell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendar.JTACMonthView) -> JTAppleCalendar.ConfigurationParameters {
        let tempCalendar = Calendar.current
        let tempDate = Date()
        
        guard let tempStartDate = tempCalendar.date(byAdding: .year, value: -10, to: tempDate),
           let tempEndDate = tempCalendar.date(byAdding: .year, value: 10, to: tempDate) else {
            return ConfigurationParameters(startDate: Date(), endDate: Date())
        }

        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = tempCalendar.startOfDay(for: tempStartDate)
        let endDate = tempCalendar.startOfDay(for: tempEndDate)
        
        return  ConfigurationParameters(startDate: startDate,
                                        endDate: endDate,
                                        numberOfRows: 6,
                                        calendar: Calendar.current,
                                        generateInDates: .forAllMonths,
                                        generateOutDates: .tillEndOfGrid,
                                        hasStrictBoundaries: false)
    }
    
    func calendar(_ calendar: JTAppleCalendar.JTACMonthView, cellForItemAt date: Date, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) -> JTAppleCalendar.JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "FinancialMonthlyCVCell", for: indexPath) as! FinancialMonthlyCalendarViewCell
        cell.dateLabel.text = cellState.text

        if cellState.dateBelongsTo == .thisMonth{
            cell.dateLabel.textColor = .black
            cell.isHidden = false
        }else{
            cell.dateLabel.textColor = .clear
            cell.isHidden = true
        }
        
        let cellStateString = cellState.date.getDateInYYYYMMDD()
        if cellStateString == self.selectedDate{
            cell.backgroundColor = UIColor.workNavy
            cell.dateLabel.textColor = .white
        }else if cellStateString == self.formattedDate{
            cell.backgroundColor = UIColor.clear
            cell.dateLabel.textColor = .blue
        }else{
            cell.backgroundColor = UIColor.clear
            cell.dateLabel.textColor = .black
        }
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        let tempDate = cellState.date.getDateInYYYYMMDD()
        selectedDate = tempDate
        calendar.reloadData()
        seperateTransactionForOneDay()
    }
}


//MARK: - Earn, Spend Table View
extension FinancialMonthlyViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = (tableView == earnTV) ? UIColor(named: "EarnGreen") : UIColor(named: "SpendRed")
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = (tableView == earnTV) ? "Earning" : "Spending"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .left
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: (headerView.leadingAnchor), constant: 20.0),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == earnTV {
            if earnTypeTransactions.isEmpty{
                return 1
            }else{
                return earnTypeTransactions.count
            }
        }else{
            if spendTypeTransactions.isEmpty{
                return 1
            }else{
                return spendTypeTransactions.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == earnTV {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "financialMonthlyEarnTVCell", for: indexPath) as! FinancialMonthlyEarnTVCell
            if earnTypeTransactions.isEmpty {
                
                cell.categoryIcon.image = UIImage(systemName: "plus.app")
                cell.categoryIcon.tintColor = .systemGray2
                cell.categoryName.text = ""
                cell.amount.text = ""
            }else{
                let transaction = earnTypeTransactions[indexPath.item]
                cell.categoryIcon.image = UIImage(named: transaction.category)
                cell.categoryIcon.tintColor = .systemGray2
                cell.categoryName.text =  transaction.category
                cell.amount.text = "¥\(transaction.amount)"
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "financialMonthlySpendTVCell", for: indexPath) as! FinancialMonthlySpendTVCell
            if spendTypeTransactions.isEmpty{
                cell.categoryIcon.image = UIImage(systemName: "plus.app")
                cell.categoryIcon.tintColor = .systemGray2
                cell.categoryName.text = ""
                cell.amount.text = ""
            }else{
                let transaction = spendTypeTransactions[indexPath.item]
                
                cell.categoryIcon.image = UIImage(named: transaction.category)
                cell.categoryIcon.tintColor = .systemGray2
                cell.categoryName.text =  transaction.category
                cell.amount.text = "¥\(transaction.amount)"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == earnTV{
            if earnTypeTransactions.isEmpty{
                formatter.dateFormat = "yyyy-MM-dd"
                guard let tempDate = formatter.date(from: selectedDate) else {return}
                let transaction = MoneyStruct(amount: 0, date: tempDate, type: "earn", category: "")
                performSegue(withIdentifier: "MonthlyToEditView", sender: transaction)
            }else{
                let transaction = earnTypeTransactions[indexPath.row]
                UpdateSelectedCell(transaction)
            }
        }else{
            if spendTypeTransactions.isEmpty{
                formatter.dateFormat = "yyyy-MM-dd"
                guard let tempDate = formatter.date(from: selectedDate) else {return}
                let transaction = MoneyStruct(amount: 0, date: tempDate, type: "earn", category: "")
                performSegue(withIdentifier: "MonthlyToEditView", sender: transaction)
            }else{
                let transaction = spendTypeTransactions[indexPath.row]
                UpdateSelectedCell(transaction)
            }
        }
    }
}

