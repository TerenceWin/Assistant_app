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

class FinancialWeeklyCVCell: UICollectionViewCell {
    
    @IBOutlet weak var tableStack : UITableView!
    
    private var sortedTransactions: [MoneyStruct] = []
    
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
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableStack.dequeueReusableCell(withIdentifier: "FinancialWeeklyTableCell", for: indexPath) as! FinancialWeeklyTableViewCell
                        
        cell.transactionLabel.text = "¥" + String(sortedTransactions[indexPath.row].amount)
        let money = sortedTransactions[indexPath.row].amount
        
        if money > 0 {
            cell.transactionLabel.backgroundColor = UIColor(red: 60/255, green: 255/255, blue: 60/255, alpha: 1.0)
            cell.transactionLabel.textColor = .black
        }else if money < 0{
            cell.transactionLabel.backgroundColor = UIColor(red: 255/255, green: 90/255, blue: 95/255, alpha: 1.0)
            cell.transactionLabel.textColor = .white
        }else{
            cell.transactionLabel.backgroundColor = .systemGray4
            cell.transactionLabel.textColor = .black
        }
        
        cell.transactionLabel.layer.cornerRadius = 5.0
        cell.transactionLabel.clipsToBounds = true
        return cell
        
    }
    

    
    
}

