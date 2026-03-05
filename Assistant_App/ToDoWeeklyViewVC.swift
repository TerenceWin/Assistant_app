//
//  ToDoWeeklyViewVC.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/02/04.
//

import Foundation
import UIKit

class ToDoWeeklyViewVC: UIViewController{
    
    private let weekdays: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    @IBOutlet weak var weeklyTable : UITableView!
    
    var weeklyToDos: [Date: [ToDoStruct]] = [:] {
        didSet {
            print(weeklyToDos)
            DispatchQueue.main.async {
                self.weeklyTable.reloadData()
            }
        }
    }
    var selectedDay : Int? = nil
    var currentWeek : Date = Date()
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weeklyTable.dataSource = self
        weeklyTable.delegate = self
        weeklyTable.bounces = false
        
        let weeklyCell = UINib(nibName: "weekdayTableViewCell", bundle: nil)
        weeklyTable.register(weeklyCell, forCellReuseIdentifier: "weekdaysCell")
        currentWeek = Calendar.current.dateInterval(of: .weekOfYear, for: currentWeek)?.start ?? Date()
    }
    
    
}

extension ToDoWeeklyViewVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekdays.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == selectedDay ? 200.0 : 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedDay == indexPath.row{
            selectedDay = nil
        }else{
            selectedDay = indexPath.row
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekdaysCell", for: indexPath) as! weekdayTableViewCell
        cell.contentView.subviews.filter {$0.tag == 999}.forEach {$0.removeFromSuperview()}
        
        cell.backgroundColor = UIColor(red: 0.851, green: 0.867, blue: 0.863, alpha: 1.0)
        cell.weekdayLabel.text = weekdays[indexPath.row]
        if let tempDateLabel = calendar.date(byAdding: .day, value: indexPath.row + 1, to: currentWeek){
            let formatedDateLabel = tempDateLabel.getDateInYYYYMMMDD()
            cell.dateLabel.text = formatedDateLabel
        }
        
        cell.viewContainer.isHidden = (indexPath.row != selectedDay)
        return cell
        
    }
}
