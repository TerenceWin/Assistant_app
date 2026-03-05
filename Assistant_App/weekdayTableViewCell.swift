//
//  weekdayTableViewCell.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/02/25.
//

import UIKit
import Foundation

class weekdayTableViewCell: UITableViewCell {
    @IBOutlet weak var weekdayLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var container : UIView!
    
    let viewContainer : UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        container.backgroundColor = .clear
        weekdayLabel.backgroundColor = .clear
        dateLabel.backgroundColor = .clear
        weekdayLabel.textColor = UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 1.0)
        dateLabel.textColor = UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 1.0)
        super.awakeFromNib()
        setupContainer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupContainer(){
        contentView.addSubview(viewContainer)
        NSLayoutConstraint.activate([
            viewContainer.centerXAnchor.constraint(equalTo: dateLabel.centerXAnchor, constant: 30),
            viewContainer.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor, constant: 40),
            viewContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -60),
            viewContainer.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

}
