//
//  FinancialWeeklyFloatingAddButton.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/01/06.
//

import Foundation
import UIKit

class FinancialWeeklyFloatingAddButton : UIButton{
    
    override func awakeFromNib(){
        super.awakeFromNib()
        setUpProperty()
    }
    
    func setUpProperty(){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        self.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    @objc func addButtonPressed(){
        print("pressed!")
    }
    
}
