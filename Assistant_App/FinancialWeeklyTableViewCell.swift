//
//  FinancialWeeklyTableViewCell.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/27.
//

import UIKit
import Foundation

class FinancialWeeklyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var transactionLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.transactionLabel.layer.borderWidth = 0.5
        self.transactionLabel.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
