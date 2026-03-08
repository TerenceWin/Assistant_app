//
//  weekdayToDoListCell.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/03/05.
//

import UIKit

class weekdayToDoListCell: UITableViewCell {
    
    @IBOutlet weak var container : UIView!
    @IBOutlet weak var todoButton : UIButton!
    var delegate : popBackToTodoMCDelegate?
    var popBackToDo : ToDoStruct = ToDoStruct(title: "", date: Date(), category: "", location: "")
    
    @IBAction func todoButtonPressed(_ sender: UIButton){
        self.delegate?.popBack(popBackToDo)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        container.backgroundColor = .clear
        
        todoButton.layer.cornerRadius = 10
        todoButton.setTitleColor(.darkGray, for: .normal)
        todoButton.backgroundColor = .white
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        container.backgroundColor = .clear
        todoButton.setTitle("", for: .normal)
    }
    
    override var isHighlighted: Bool{
        didSet{
            UIView.animate(withDuration: 0.2){
                self.todoButton.backgroundColor = self.isHighlighted ? .lightGray : .white
                self.todoButton.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            }
        }
    }

    
}
