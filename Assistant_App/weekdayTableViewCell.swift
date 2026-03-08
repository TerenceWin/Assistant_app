//
//  weekdayTableViewCell.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/02/25.
//

import UIKit
import Foundation

protocol popBackToTodoMCDelegate{
    func popBack(_ popBackToDo: ToDoStruct)
}

class weekdayTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var weekdayLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var container : UIView!
    @IBOutlet weak var todoList : UITableView!
    @IBOutlet weak var todoListHeightConstraint : NSLayoutConstraint!
    var todoDelegate : popBackToTodoMCDelegate?

    var currentDayToDoList: [ToDoStruct] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        container.backgroundColor = .clear
        weekdayLabel.backgroundColor = .clear
        dateLabel.backgroundColor = .clear
        todoList.backgroundColor = .clear
        todoList.backgroundView = nil
        todoList.separatorStyle = .none
    
        weekdayLabel.textColor = UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 1.0)
        dateLabel.textColor = UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 1.0)
        
        todoList.dataSource = self
        todoList.delegate = self
        todoList.reloadData()
        
        let todoListCell = UINib(nibName: "weekdayToDoListCell", bundle: nil)
        todoList.register(todoListCell, forCellReuseIdentifier: "todoListCell")
    }
    
    func configure(with todos: [ToDoStruct], isExpanded: Bool) {
        self.currentDayToDoList = todos
        self.todoList.reloadData()
        self.setExpand(isExpanded)
    }
    
    func setExpand(_ expanded: Bool){
        if expanded{
            todoList.reloadData()
            todoList.layoutIfNeeded()
            let contentHeight = todoList.contentSize.height
            todoListHeightConstraint.constant = min(contentHeight, 90)
        }else{
            todoListHeightConstraint.constant = 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        weekdayLabel.text = nil
        dateLabel.text = nil
        currentDayToDoList = []
        setExpand(false)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDayToDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath) as! weekdayToDoListCell
        cell.backgroundColor = .clear
        cell.delegate = self.todoDelegate
        
        if !currentDayToDoList.isEmpty{
            let title = currentDayToDoList[indexPath.row].title
            cell.todoButton.setTitle(title, for: .normal)
            cell.popBackToDo = currentDayToDoList[indexPath.row]
        }else{
            cell.todoButton.setTitle("", for: .normal)
        }
        
        return cell
    }
    

}
