//
//  FinancialWeeklyEditView.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/01/06.
//

import Foundation
import UIKit

protocol reloadFinancialVCDelegate{
    func addedTransaction()
}

class FinancialWeeklyEditView: UIViewController{
    private var earnCategoryArr : [String] = ["salary", "business", "side hustles", "bonus", "others"]
    private var spendCategoryArr : [String] = ["grocery", "drinks", "eat out", "transport", "goods", "fee", "subscriptions", "fun", "toiletry", "unknown"]
    private var currentCategoryArr : [String]?
    var isNew : Bool = false
    var delegate : reloadFinancialVCDelegate?
    
    @IBOutlet weak var earnButton: UIButton!
    @IBOutlet weak var spendButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var moneyText: UITextField!
    @IBOutlet weak var noteDescription: UITextView!
    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var currentTime: UIDatePicker!
    
    var amount : Int = 0
    var dateTime = Date()
    var currentSelectedCategory : String = ""
    var currentNoteDescription: String = ""
    var earnIsTrue : Bool = false
    
    var currentTransaction : MoneyStruct? {
        didSet{
            amount = currentTransaction?.amount ?? 0
            dateTime = currentTransaction?.date ?? Date()
            earnIsTrue = currentTransaction?.type == "earn"
            currentSelectedCategory = currentTransaction?.category ?? ""
            currentNoteDescription = currentTransaction?.note ?? ""
        }
    }
    
    func updateUI(){
        moneyText.text = "\(amount)"
        currentTime.date = dateTime
        updateTypeButtonUI()
        noteDescription.text = currentNoteDescription
    }
    
    func updateTypeButtonUI(){
        if earnIsTrue{
            earnButton.layer.cornerRadius = 5
            earnButton.layer.borderWidth = 3.0
            spendButton.layer.borderWidth = 0
        }else{
            spendButton.layer.cornerRadius = 5
            earnButton.layer.borderWidth = 0
            spendButton.layer.borderWidth = 3.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setUpView()
        categoryContainer.layer.borderWidth = 1.0
    }
    
    @IBAction func amountChange(_ sender: UITextField){
        if let text = sender.text, let newAmount = Int(text){
            self.amount = newAmount
        }else{
            self.amount = 0
        }
    }
    
    
    @IBAction func dateChange(_ sender: UIDatePicker){
        self.dateTime = sender.date
    }
    
    @IBAction func earnButtonPressed(){
        earnIsTrue = true
        updateTypeButtonUI()
        setUpView()
    }
    
    @IBAction func spendButtonPressed(){
        earnIsTrue = false
        updateTypeButtonUI()
        setUpView()
    }
    
    @IBAction func saveButtonPressed(){
        if currentSelectedCategory == ""{
            print("Please select a Category")
            return
        }
        
        var noteToSave = ""
        if noteDescription.text != "Type your notes here..." && noteDescription.textColor != .lightGray{
            noteToSave = noteDescription.text
        }
        
        print("Saving Transaction with ID: \(currentTransaction?.id ?? "NEW_ID")")
        
        let transaction = MoneyStruct(
            id : currentTransaction?.id ?? UUID().uuidString,
            amount: self.amount,
            date: self.dateTime,
            type: earnIsTrue ? "earn" : "spend",
            category: currentSelectedCategory,
            note: noteToSave
        )
        
        if isNew{   //NEW TRANSACTION -> Add
            print("This is New Transaction")
            TransactionManager.shared.addTransaction(transaction) {[weak self] success in
                self?.handleCompletion(success)
            }}
        else{       //OLD TRANSACTION -> Edit
            print("This is Old Transaction")
            TransactionManager.shared.editTransaction(transaction) { [weak self] success in
                self?.handleCompletion(success)
            }
        }
    }
    
    
    private func handleCompletion(_ success: Bool){
        if success{
            DispatchQueue.main.async{
                self.delegate?.addedTransaction()
                self.navigationController?.popViewController(animated: true)
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

        if let icon = currentCategoryArr?[indexPath.item]{
            cell.categoryCellImage.image = UIImage(named: icon)
            cell.categoryCellImage.backgroundColor = .white
        }else{
            cell.categoryCellImage.image = UIImage(systemName: "questionmark.square.dashed")
            cell.categoryCellImage.backgroundColor = .white
        }
        cell.categoryCellImage.layer.borderWidth = 0.5
        cell.categoryCellLabel.text = currentCategoryArr?[indexPath.item]
        cell.categoryCellLabel.backgroundColor = .clear
        
        if currentSelectedCategory == currentCategoryArr?[indexPath.item]{
            cell.categoryCellLabel.backgroundColor = UIColor.systemGray4
        }else{
            cell.categoryCellImage.backgroundColor = .none
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentCategory = currentCategoryArr?[indexPath.item] else{ return }
        currentSelectedCategory = currentCategory
        categoryCV.reloadData()
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


