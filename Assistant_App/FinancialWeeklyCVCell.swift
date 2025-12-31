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
    
    var transcationsPerCell : [MoneyStruct] = [] {
        didSet{
            tableStack.reloadData()
        }
    }
    
    //Start creating the Grid for the tableStack like CollectionView and
    override func awakeFromNib() {
            
        super.awakeFromNib()
        
        tableStack.preservesSuperviewLayoutMargins = false
        tableStack.layoutMargins = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        
        tableStack.dataSource = self
        tableStack.delegate = self
    }
    
    func configure(with transactions: [MoneyStruct]){
        tableStack.reloadData()
    }
}

//MARK: - TableView DataSource, Delegate
extension FinancialWeeklyCVCell: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transcationsPerCell.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }
        return 40
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            
            self.transcationsPerCell = []
            self.tableStack.reloadData()
            self.layer.borderColor = UIColor.systemGray4.cgColor
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableStack.dequeueReusableCell(withIdentifier: "FinancialWeeklyTableCell", for: indexPath) as! FinancialWeeklyTableViewCell
                
        cell.transcationLabel.text = String(transcationsPerCell[indexPath.row].amount)
        return cell
//        if total > 0{
//            cell.transcationLabel.backgroundColor = .green
//        }else if total == 0 {
//            cell.transcationLabel.backgroundColor = UIColor.systemGray4
//        }else{
//            cell.transcationLabel.backgroundColor = .red
//        }
        
        
        cell.contentView.preservesSuperviewLayoutMargins = false
        

        if indexPath.row == 0 { //First Cell
            cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 10 , bottom: 10, right: 10)
           
        }else if (indexPath.row + 1) == indexPath.count{ // Last cell
            cell.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        }else{  //Cells between first and last cell
            cell.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        }
        return cell
    }
    

    
    
}

