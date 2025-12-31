//
//  DaysHeaderView.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/25.
//
    
import UIKit

class FinancialWeeklyDaysHeaderView: UICollectionReusableView {
    private let stackView = UIStackView()
    private let cornerLabel = UILabel()
    private let bottomLine = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented in the class FinancialWeeklyDaysHeaderView") }
    
    private func setupView() {
        backgroundColor = .systemGray6
        
        bottomLine.backgroundColor = .systemGray4
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLine)
        
        cornerLabel.textAlignment = .center
        cornerLabel.font = .boldSystemFont(ofSize: 14)
        cornerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cornerLabel)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            
            cornerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            cornerLabel.topAnchor.constraint(equalTo: topAnchor),
            cornerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            cornerLabel.widthAnchor.constraint(equalToConstant: 60),
            
            stackView.leadingAnchor.constraint(equalTo: cornerLabel.trailingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(titles: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if let first = titles.first {
            cornerLabel.text = first
        }
        
        let dayTitles = titles.dropFirst()
        for title in dayTitles {
            
            let label = UILabel()
            label.text = String(title)
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 14, weight: .medium)
            stackView.addArrangedSubview(label)
            
        }
    }
}
