//
//  FinancialYearlyViewController.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/01/28.
//

import UIKit
import Foundation
import JTAppleCalendar

class FinancialYearlyViewController: UIViewController{
    
    @IBOutlet weak var yearLabel : UILabel!
    @IBOutlet weak var totalAmountLabel : UILabel!
    @IBOutlet weak var yearlyCV : UICollectionView!
    @IBOutlet weak var previousButton : UIButton!
    @IBOutlet weak var nextButton : UIButton!
    
    private let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var date = Date()
    var year : Int = 0
    var currentYearTotalAmount : Int = 0
    var allTransaction : [MoneyStruct] = []
    var currentYearTransaction : [MoneyStruct] = []
    var monthlyTransactionsArr : [Int : [MoneyStruct]] = [:]
    var monthlyTotalAmountArr : [Int : Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCV()
        year = Calendar.current.component(.year, from: date)
        
        updateYearLabel()
        fetchAllTransactions()
        
    }
    
    @IBAction func previousButtonPressed(_ sender: UIButton){
        year -= 1
        filterTransactionsToCurrentYear()
        updateYearLabel()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton){
        year += 1
        filterTransactionsToCurrentYear()
        updateYearLabel()
    }
    
    func updateYearLabel(){
        yearLabel.text = "\(year)"
    }
    
    func updateTotalAmountLabel(){
        totalAmountLabel.text = "¥\(currentYearTotalAmount)"
    }
    
    func fetchAllTransactions(){
        TransactionManager.shared.loadData{[weak self] in
            DispatchQueue.main.async{
                guard let self = self else{
                    print("View Controllelr was deallocated. Skipping UI update.")
                    return
                }
                self.allTransaction = TransactionManager.shared.allTransactions
                self.filterTransactionsToCurrentYear()
            }
            
        }
    }
    
    func filterTransactionsToCurrentYear(){
        currentYearTotalAmount = 0
        currentYearTransaction.removeAll()
        
        for transaction in allTransaction{
            let tempDate = transaction.date
            let transactionYear = Calendar.current.component(.year, from: tempDate)
            
            if transactionYear == year{
                currentYearTransaction.append(transaction)
                let transactionAmount = transaction.amount

                if transaction.type == "earn"{
                    currentYearTotalAmount += transactionAmount
                }else{
                    currentYearTotalAmount -= transactionAmount
                }
            }
        }
        updateTotalAmountLabel()
        filterTransactionToCurrentMonth()
    }
    
    func filterTransactionToCurrentMonth(){
        monthlyTransactionsArr.removeAll()
        monthlyTotalAmountArr.removeAll()
        
        
        for transaction in currentYearTransaction{
            let tempDate = transaction.date
            let month = Calendar.current.component(.month, from: tempDate)
            let tempYear = Calendar.current.component(.year, from: tempDate)
            
            if tempYear == self.year{
                if monthlyTransactionsArr[month] == nil{
                    monthlyTransactionsArr[month] = [transaction]
                    if transaction.type == "earn"{
                        monthlyTotalAmountArr[month] = transaction.amount
                    }else{
                        monthlyTotalAmountArr[month] = 0 - transaction.amount
                    }
                }else{
                    monthlyTransactionsArr[month]?.append(transaction)
                    
                    if transaction.type == "earn"{
                        monthlyTotalAmountArr[month]? += transaction.amount
                    }else{
                        monthlyTotalAmountArr[month]? -= transaction.amount
                    }
                }
            }
        }
        yearlyCV.reloadData()
    }
    
    func setUpCVLayout() -> UICollectionViewLayout{
        let items = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension : .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
        items.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groups = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(175.0)), subitems: [items])
            
        let section = NSCollectionLayoutSection(group: groups)
        return UICollectionViewCompositionalLayout(section: section)
        
    }
    
    func setUpCV(){
        let layout = setUpCVLayout()
        yearlyCV.collectionViewLayout = layout
        
        yearlyCV.delegate = self
        yearlyCV.dataSource = self
        
    }
}

extension FinancialYearlyViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "yearlyCVCell", for: indexPath) as! FinancialYearlyCVCell
        let tempMonth = indexPath.item + 1
        
        cell.currentYear = year
        cell.currentMonth = tempMonth
        if let transactions = self.monthlyTransactionsArr[indexPath.item + 1]{
            cell.monthlyTransactionsArr = transactions
        }
        if let amount = self.monthlyTotalAmountArr[indexPath.item + 1]{
            cell.monthlyTotalAmountArr = amount
        }
        
        cell.CVMonthLabel.text = months[indexPath.item]
        let month = indexPath.item + 1
        if let tempAmount = monthlyTotalAmountArr[month]{
            cell.CVMonthAmountLabel.text = "¥\(tempAmount)"
        }else{
            cell.CVMonthAmountLabel.text = "¥0"
        }

        return cell
    }

}
