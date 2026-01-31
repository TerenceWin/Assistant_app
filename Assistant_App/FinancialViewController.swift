//
//  FinancialViewController.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/21.
//

import Foundation
import UIKit

class FinancialViewController: UIViewController {

    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var yearlyButton: UIButton!
    
    @IBAction func yearlyButtonPressed(_ sender : UIButton){
        performSegue(withIdentifier: "FinancialToYearlyView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }


}
