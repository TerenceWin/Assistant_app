//
//  FinancialWeeklyCV.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/22.
//

import UIKit

class FinancialWeeklyCV: UICollectionView,
                         UICollectionViewDelegate,
                         UICollectionViewDataSource {

    // First column is intentionally empty
    private let days = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        collectionViewLayout = makeWeeklyLayout()
    }

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
    }

    // MARK: - Layout
    private func makeWeeklyLayout() -> UICollectionViewLayout {

        // 1️⃣ First column (Y-axis / empty)
        let yAxisItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(50),
                heightDimension: .fractionalHeight(1.0)
            )
        )

        // 2️⃣ ONE day column (Mon–Sun)
        let dayItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0 / 7.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )

        // 3️⃣ Create 7 identical day items
        let dayItems = Array(repeating: dayItem, count: 7)

        // 4️⃣ Group of Mon–Sun
        let daysGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            ),
            subitems: dayItems
        )

        // 5️⃣ Main row: [empty] + [Mon–Sun]
        let mainGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(44)
            ),
            subitems: [yAxisItem, daysGroup]
        )

        let section = NSCollectionLayoutSection(group: mainGroup)
        section.orthogonalScrollingBehavior = .none

        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return days.count // 8 columns
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = dequeueReusableCell(
            withReuseIdentifier: "FinancialWeeklyCell",
            for: indexPath
        ) as! FinancialWeeklyCVCell

        cell.financialWeeklyCVCellLabel.text = days[indexPath.item]
        return cell
    }
}
