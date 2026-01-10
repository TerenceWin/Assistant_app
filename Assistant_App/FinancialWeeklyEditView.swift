//
//  FinancialWeeklyEditView.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/01/06.
//

import Foundation
import UIKit

protocol reloadFinanciallWeeklyVCDelegate{
    func addedTransaction()
}

class FinancialWeeklyEditView: UIViewController{
    private var earnCategoryArr : [String] = ["salary", "business", "side hustles", "bonus", "others"]
    private var spendCategoryArr : [String] = ["grocery", "drinks", "eat out", "transport", "goods", "fee", "subscriptions", "fun", "toiletry", "unknown"]
    private var currentCategoryArr : [String]?
    var delegate : reloadFinanciallWeeklyVCDelegate?
    
    @IBOutlet weak var earnButton: UIButton!
    @IBOutlet weak var spendButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var moneyText: UITextField!
    @IBOutlet weak var noteDescription: UITextView!
    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var currentTime: UIDatePicker!

    var earnIsTrue : Bool = false
    var dateTime = Date()
    var currentSelectedCategory : String?
    var currentNoteDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        categoryContainer.layer.borderWidth = 1.0
        
        dateTime = currentTime.date
        noteDescription.delegate = self
        noteDescription.text = "Type your notes here..."
        noteDescription.textColor = UIColor.lightGray
    }
    
    @IBAction func dateChange(_ sender: UIDatePicker){
        self.dateTime = sender.date
        print("Date change")
    }
    
    @IBAction func earnButtonPressed(){
        earnIsTrue = true
        earnButton.layer.cornerRadius = 5
        earnButton.layer.borderWidth = 3.0
        spendButton.layer.borderWidth = 0
        setUpView()
    }
    
    @IBAction func spendButtonPressed(){
        earnIsTrue = false
        spendButton.layer.cornerRadius = 5
        earnButton.layer.borderWidth = 0
        spendButton.layer.borderWidth = 3.0
        setUpView()
    }
    
    @IBAction func saveButtonPressed(){
        if currentSelectedCategory == nil{
            print("Please select a Category")
        }else{
            let newTransaction = MoneyStruct(
                amount: Int(moneyText.text ?? "0") ?? 0,
                date: dateTime,
                type: earnIsTrue ? "earn" : "spend",
                category: currentSelectedCategory!,
                note: currentNoteDescription ?? ""
            )
            TransactionManager.shared.addTransaction(newTransaction) {[weak self] success in
                if success{
                    DispatchQueue.main.async{
                        self?.delegate?.addedTransaction()
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    //MARK: - Set up CV and Creates Layout
    private func setUpView(){
        let layout = createLayout()
        earnIsTrue ? (currentCategoryArr = earnCategoryArr) : (currentCategoryArr = spendCategoryArr)
        categoryCV.collectionViewLayout = layout
        
        categoryCV.dataSource = self
        categoryCV.delegate = self
        
        categoryCV.reloadData()
        
        noteDescription.layer.borderWidth = 1.0
        noteDescription.layer.cornerRadius = 10
        noteDescription.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        noteDescription.textContainer.lineFragmentPadding = 0
        
    }
    
    private func createLayout() -> UICollectionViewLayout{
        let items = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 4.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 3.0)), subitems: [items])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
//MARK: - CV Delegates
extension FinancialWeeklyEditView: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCategoryArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCV.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! FinancialWeeklyEditViewCVCell

        cell.categoryCellImage.layer.borderWidth = 0.5
        cell.categoryCellLabel.text = currentCategoryArr?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectedCategory = currentCategoryArr?[indexPath.item]
    }
}

//MARK: - TextView Delegates
extension FinancialWeeklyEditView: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.blue.cgColor
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        currentNoteDescription = textView.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.black.cgColor
        if textView.text.isEmpty{
            textView.text = "Type your notes here..."
            textView.textColor = UIColor.lightGray
        }
    }
}


