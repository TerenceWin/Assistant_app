//
//  FinancialWeeklyCV.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/22.
//

import UIKit
import Foundation

class FinancialWeeklyCV: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let days = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private var emptyDates : [String] = ["", "", "", "", "", "", ""]
    private let hours = ["0am - 6am", "6am - 12pm", "12pm - 18pm", "18pm - 24pm"]
    
    private var allTranscations : [MoneyStruct] = [
        MoneyStruct(amount: 2000, date: Date().dateBy(days: -2, hours: 2), type: "earn", category: "salary", note: "Grocery"),
        MoneyStruct(amount: 5, date: Date().dateBy(days: -1, hours: 6), type: "spend", category: "food", note: "Coffee"),
        MoneyStruct(amount: 200, date: Date().dateBy(days: 0, hours: 12), type: "spend", category: "food", note: "Grocery"),
        MoneyStruct(amount: 200, date: Date().dateBy(days: 1, hours: 4), type: "earn", category: "Mercari", note: ""),
        MoneyStruct(amount: 2000, date: Date().dateBy(days: 2, hours: 0), type: "spend", category: "Goods", note: "LV Bag"),
        MoneyStruct(amount: 200, date: Date().dateBy(days: 3, hours: -6), type: "earn", category: "Mercari", note: ""),
        MoneyStruct(amount: 200, date: Date().dateBy(days: 4, hours: 0), type: "earn", category: "Mercari", note: ""),
        MoneyStruct(amount: 100, date: Date().dateBy(days: 4, hours: -6), type: "earn", category: "Mercari", note: ""),
    ]
    
    private var groupedTranscations : [String: [MoneyStruct]] = [:]
    
    func groupTranscation(){
        groupedTranscations = [:]
        for transcation in allTranscations {
            let transcationDay = transcation.date.getCurrentDays()
            let transcationHour = transcation.date.getHourIndex()
            let key = "\(transcationDay)-\(transcationHour)"
            if groupedTranscations[key] == nil{
                groupedTranscations[key] = [transcation]
            }else{
                groupedTranscations[key]?.append(transcation)
            }
        }
    }
    
    static let cellId = "DayCell"
    static let headerId = "HeaderView"
    static let sidebarId = "SidebarView"
    
    let dateManager = Date()
    var currentDate : Int = 0
    var currentDay : Int = 0
    var lastDate : Int = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //Dont need it for now, but just in case the stoyboard crashes or future popup 
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }
    
    private func commonInit() {
        currentDate = dateManager.getCurrentDate()
        currentDay = dateManager.getCurrentDays()
        lastDate = dateManager.endOfMonth

        let datesFromFirstDate = Int(currentDate) - 1
        let datesFromLastDate = Int(Int(lastDate) - Int(currentDate))
        
        let daysFromMonday = Int(currentDay) - 1
        let daysFromSunday = 7 - Int(currentDay)
        
        //Use to set the first day in the calendar and increment with for loop
        var firstDateInTheWeek = currentDate - (currentDay - 1 )

//        print("datesFromFirstDate: \(datesFromFirstDate)")
//        print("datesFromLastDate: \(datesFromLastDate)")
//        
//        print("daysFromMonday: \(daysFromMonday)")
//        print("daysFromSunday: \(daysFromSunday)")

        if datesFromFirstDate >= daysFromMonday && datesFromLastDate >= daysFromSunday{ //The weekdays are filled
            for i in 0..<emptyDates.count{
                emptyDates[i] = String(firstDateInTheWeek)
                firstDateInTheWeek += 1
            }
        }else{ //There exist empty day
            if daysFromMonday > datesFromFirstDate{ //Empty Monday until [daysFromMonday - datesFromFirstDate]
                let emptyDays = daysFromMonday - datesFromFirstDate
                var tempDay = 1

                for i in emptyDays..<emptyDates.count{
                    emptyDates[i] = String(tempDay)
                    tempDay += 1
                }
            }
            if daysFromSunday > datesFromLastDate{ //Empty Sunday until [daysFromSunday - datesFromLastDate]
                let emptyDays = daysFromSunday - datesFromLastDate
                for i in 0..<(emptyDates.count - emptyDays){
                    emptyDates[i] = String(firstDateInTheWeek)
                    firstDateInTheWeek += 1
                }
                        
            }
        }
        
        groupTranscation()
        print(groupedTranscations)
        
//        for transcation in groupedTranscations{
//            let key = transcation.key
//            let value = transcation.value
//            print("\(key)-\(value)")
//        }
        
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
            return UICollectionViewCell() // Fallback to avoid a crash
        }
        
        let numOfCol = 7
        let columIndex = indexPath.item % numOfCol
        let rowIndex = indexPath.item / numOfCol
        
        let key = "\(columIndex + 1)-\(rowIndex)"
                        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.systemGray4.cgColor
        
        cell.transcationsPerCell = groupedTranscations[key] ?? []
       
        return cell
    }
    

    // MARK: - Layout
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
           
            for i in 1..<newDays.count{
                newDays[i] = "\(newDays[i]) \(emptyDates[i - 1])"
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

