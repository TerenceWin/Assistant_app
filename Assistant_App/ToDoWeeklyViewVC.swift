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
    
    var weeklyToDos: [Date: [ToDoStruct]] = [:]
    var indexter : [Int: Date] = [:]
    var currentWeekToDos : [Date: [ToDoStruct]] = [:]
    var selectedDay : Int? = nil
    var currentWeek : Date = Date()
    var calendar = Calendar.current
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.firstWeekday = 2

        weeklyTable.dataSource = self
        weeklyTable.delegate = self
        weeklyTable.bounces = false
        weeklyTable.reloadData()
        
        let weeklyCell = UINib(nibName: "weekdayTableViewCell", bundle: nil)
        weeklyTable.register(weeklyCell, forCellReuseIdentifier: "weekdaysCell")
        currentWeek = calendar.dateInterval(of: .weekOfYear, for: currentWeek)?.start ?? Date()
        filterCurrentWeeklysToDo()
    }
    
    func filterCurrentWeeklysToDo(){
        for i in 0...6{
            if let days = calendar.date(byAdding: .day, value: i, to: currentWeek){
                if indexter[i] == nil {
                    indexter[i] = days
                }
                currentWeekToDos[days] = []
            }
        }
        if let haveToDoList = weeklyToDos[currentWeek]{
            for todo in haveToDoList{
                let tempDate = calendar.dateInterval(of: .day, for: todo.date)?.start
                self.currentWeekToDos[tempDate!]?.append(todo)
            }
        }
    }
}

extension ToDoWeeklyViewVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekdays.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == selectedDay ? 240.0 : 120.0
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
        cell.todoDelegate = self
        
        cell.backgroundColor = UIColor(red: 0.851, green: 0.867, blue: 0.863, alpha: 1.0)
        cell.weekdayLabel.text = weekdays[indexPath.row]
                
        if let tempDateLabel = calendar.date(byAdding: .day, value: indexPath.row, to: currentWeek){
            let formatedDateLabel = tempDateLabel.getDateInYYYYMMMDD()
            cell.dateLabel.text = formatedDateLabel
        }

        let dateIndex = indexter[indexPath.row]
        let todosForThisDay = (dateIndex != nil) ? currentWeekToDos[dateIndex!] : []
        let isExpanded = (indexPath.row == selectedDay)
        cell.configure(with: todosForThisDay ?? [], isExpanded: isExpanded)
        
        return cell
        
    }
}

extension ToDoWeeklyViewVC: popBackToTodoMCDelegate{
    func popBack(_ popBackToDo: ToDoStruct) {
        if let viewControllers = self.navigationController?.viewControllers {
                if viewControllers.count >= 2 {
                    if let mainVC = viewControllers[viewControllers.count - 2] as? ToDoViewController {
                        mainVC.popBackItem = popBackToDo
                        mainVC.didSetPopBackItem(true)
                    }
                }
            }
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
