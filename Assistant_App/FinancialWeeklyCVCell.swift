//
//  FinancialWeeklyCVCell.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/23.
//

import UIKit
import Foundation

//let isoFormatter = ISO8601DateFormatter()
//let dateString = isoFormatter.string(from: Date())
// Output: "2025-12-27T18:15:20Z"

protocol FinancialSeugeToEditViewDelegate: AnyObject{
    func UpdateSelectedCell(_ transaction: MoneyStruct)
}

class FinancialWeeklyCVCell: UICollectionViewCell {
    weak var delegate : FinancialSeugeToEditViewDelegate?
    @IBOutlet weak var tableStack : UITableView!
    private var sortedTransactions: [MoneyStruct] = []
    var selectedTransaction = MoneyStruct(amount: 0, date: Date(), type: "", category: "")
    
    var transactionsPerCell : [MoneyStruct] = [] {
        didSet{
            self.sortedTransactions = transactionsPerCell.sorted{ $0.amount > $1.amount}
            tableStack.reloadData()
        }
    }

    override func awakeFromNib() {
            
        super.awakeFromNib()
        tableStack.dataSource = self
        tableStack.delegate = self
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    func configure(with transactions: [MoneyStruct]){
        tableStack.reloadData()
    }
}

//MARK: - TableView DataSource, Delegate
extension FinancialWeeklyCVCell: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTransactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            self.sortedTransactions = []
            delegate = nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableStack.dequeueReusableCell(withIdentifier: "FinancialWeeklyTableCell", for: indexPath) as! FinancialWeeklyTableViewCell
        
        cell.selectionStyle = .none
        cell.transactionLabel.text = "¥" + String(sortedTransactions[indexPath.row].amount)
        let type = sortedTransactions[indexPath.row].type
        
        if type == "earn" {
            cell.transactionLabel.backgroundColor = UIColor(red: 60/255, green: 255/255, blue: 60/255, alpha: 1.0)
            cell.transactionLabel.textColor = .black
        }else{
            cell.transactionLabel.backgroundColor = UIColor(red: 255/255, green: 90/255, blue: 95/255, alpha: 1.0)
            cell.transactionLabel.textColor = .white
        }
        
        cell.transactionLabel.layer.cornerRadius = 5.0
        cell.transactionLabel.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTransaction = sortedTransactions[indexPath.row]
        print("\(selectedTransaction)")
        delegate?.UpdateSelectedCell(selectedTransaction)
    }
}

