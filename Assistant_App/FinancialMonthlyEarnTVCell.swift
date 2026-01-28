//
//  FinancialMonthlyEarnTVCell.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/01/20.
//

import UIKit
import Foundation

class FinancialMonthlyEarnTVCell: UITableViewCell {
    
    var category : String?
    var time = Date()
    var amnount : Int?
    @IBOutlet weak var contianer: UIView!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryName : UILabel!
    @IBOutlet weak var amount : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
