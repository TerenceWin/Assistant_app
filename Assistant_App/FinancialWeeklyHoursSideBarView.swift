//
//  FinancialWeeklyHoursSideBarView.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/25.
//

import UIKit

class FinancialWeeklyHoursSideBarView: UICollectionReusableView {
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    private func setUpView(){
        backgroundColor = .systemGray6
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configure(titles: [String]){
        stackView.arrangedSubviews.forEach{ $0.removeFromSuperview() }
        
            for hour in titles{
                let container = UIView()
                let label = UILabel()
                let bottomLine = UIView()
                
                label.text = String(hour)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = .systemFont(ofSize: 14, weight: .medium )
                label.numberOfLines = 2
                label.textAlignment = .center
                
                bottomLine.backgroundColor = .systemGray4
                bottomLine.translatesAutoresizingMaskIntoConstraints = false
                
                container.addSubview(label)
                container.addSubview(bottomLine)
                
                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: container.topAnchor),
                    label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                    
                    bottomLine.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    bottomLine.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    bottomLine.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                    bottomLine.heightAnchor.constraint(equalToConstant: 0.5)
                ])
                
                stackView.addArrangedSubview(container)
            }
        }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented in the class FinancialWeeklyHoursSideBarView") }
}
