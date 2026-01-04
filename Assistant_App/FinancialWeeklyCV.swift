//
//  FinancialWeeklyCV.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/22.
//

import UIKit
import Foundation

protocol FinancialWeeklyCVDelegate: AnyObject{
    func updateMoneyLabel(to text: String)
}

class FinancialWeeklyCV: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
        
    let calendar = Calendar.current
    weak var financialDelegate : FinancialWeeklyCVDelegate?
    var weekStartDate: Date = Date() {
        didSet {
            updateEmptyDates() //For Header
            groupCurrentWeekTransactions()
            UIView.transition(with: self,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: {
                                  self.reloadData()
                              },
                              completion: nil)
        }
    }
    var weekEndDate: Date = Date()
    
    private let days = ["", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private var emptyDates : [Int] = []
    private let hours = ["0am - 5am", "6am - 11pm", "12pm - 17pm", "18pm - 23pm"]
    var groupedAllTransactions : [WeeklyKey: [MoneyStruct]] = [:]
    var currentWeekTransactions : [WeeklyKey: [MoneyStruct]] = [:]{
        didSet{
            self.reloadData()
        }
    }

    static let cellId = "DayCell"
    static let headerId = "HeaderView"
    static let sidebarId = "SidebarView"
    
    //MARK: - GroupCurrentWeekTransactions and updateHeader() func
    func groupCurrentWeekTransactions(){
        currentWeekTransactions.removeAll()
        var totalMoney : Int = 0
        let currentWeekStartDateInt = weekStartDate.getDateAsInt()
        let currentWeekEndDateInt = weekEndDate.getDateAsInt()
        
        for (key, value) in groupedAllTransactions{
            let keyYear = key.year
            let keyMonth = key.month
            let keyDay = key.day
            let keyHour = key.hour
            
            let currentKeyInt : Int = (keyYear * 1000000) + (keyMonth * 10000) + (keyDay * 100) + keyHour
                if currentKeyInt >= currentWeekStartDateInt && currentKeyInt <= currentWeekEndDateInt{
                    currentWeekTransactions[key, default: []].append(contentsOf: value)
                    let sumOfThisKey = value.reduce(0){$0 + $1.amount}
                    totalMoney += sumOfThisKey
            }
        }
        
        let totalMoneyString = String(totalMoney)
        financialDelegate?.updateMoneyLabel(to: totalMoneyString)

//        for (key, value) in currentWeekTransactions{
//            print("Key: \(key), Value: \(value.count)")
//        }
    }
    
    func updateEmptyDates(){
        emptyDates.removeAll()
        var tempDate = weekStartDate
        emptyDates.append(Calendar.current.component(.day, from: tempDate))
        for _ in 0..<6{
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to:tempDate)!
            emptyDates.append(Calendar.current.component(.day, from: tempDate))
        }
    }
 
    //MARK: - Init Section
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //Dont need it for now, but just in case the stoyboard crashes or future popup 
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }
    
    //MARK: - CommonInit func
    private func commonInit() {
        //CV Grid Layout

        self.collectionViewLayout = createCalendarLayout()
        self.delegate = self
        self.dataSource = self
        
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: FinancialWeeklyCV.cellId)
        self.register(FinancialWeeklyDaysHeaderView.self, forSupplementaryViewOfKind: "days-header-kind", withReuseIdentifier: FinancialWeeklyCV.headerId)
        self.register(FinancialWeeklyHoursSideBarView.self, forSupplementaryViewOfKind: "time-sidebar-kind", withReuseIdentifier: FinancialWeeklyCV.sidebarId)
        
    }

    // MARK: - DataSource: Items (The Grid)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hours.count * 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FinancialWeeklyCell", for: indexPath) as? FinancialWeeklyCVCell else {
            return UICollectionViewCell()
        }
        
        let column = indexPath.item % 7
        let row = indexPath.item / 7

            if let targetDate = calendar.date(byAdding: .day, value: column, to: weekStartDate) {
                let comp = calendar.dateComponents([.year, .month, .day], from: targetDate)
                
                let columnKey = WeeklyKey(
                    year: comp.year!,
                    month: comp.month!,
                    day: comp.day!,
                    hour: row
                )
                
                cell.transactionsPerCell = currentWeekTransactions[columnKey] ?? []
            }

        return cell
    }
    

    // MARK: - CV's Layout
    func createCalendarLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2.5), heightDimension: .absolute(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: "days-header-kind",
                alignment: .top
            )
            header.pinToVisibleBounds = true
            header.zIndex = 2
            
            let sideBarSize = NSCollectionLayoutSize(widthDimension: .absolute(60), heightDimension: .fractionalHeight(1.0))
            let sideBar = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: sideBarSize,
                elementKind: "time-sidebar-kind",
                alignment: .leading
            )
            
            sideBar.pinToVisibleBounds = true
            sideBar.zIndex = 1
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 7.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2.5), heightDimension: .fractionalHeight(0.25))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 7
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 0)  
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header, sideBar]
            return section
        }
        return layout
    }
    // MARK: - DataSource: Supplementary Views (Header & Sidebar)
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == "days-header-kind" {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FinancialWeeklyCV.headerId, for: indexPath) as! FinancialWeeklyDaysHeaderView
            var newDays = days
           
            if emptyDates.count == 7{
                for i in 1..<newDays.count{
                    newDays[i] = "\(newDays[i]) \(emptyDates[i - 1])"
                }
            }
            header.configure(titles: newDays)
            return header
        }
        
        if kind == "time-sidebar-kind" {
            let sidebar = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FinancialWeeklyCV.sidebarId, for: indexPath) as! FinancialWeeklyHoursSideBarView
            sidebar.configure(titles: hours)
            return sidebar
        }
        return UICollectionReusableView()
    }
    
}
