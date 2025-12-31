//
//  FinancialWeeklyTableView.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/27.
//

import UIKit

class FinancialWeeklyTableView: UITableView {
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView(){
        self.separatorStyle = .none
        self.isScrollEnabled = true
    }
    
    
}
