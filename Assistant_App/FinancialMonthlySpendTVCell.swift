//
//  FinancialMonthlySpendTVCellTableViewCell.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/01/20.
//

import UIKit
import Foundation
import JTAppleCalendar

class FinancialMonthlySpendTVCell: UITableViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
}
