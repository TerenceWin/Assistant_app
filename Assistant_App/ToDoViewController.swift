//
//  To-DoViewController.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/21.
//

import Foundation
import UIKit

class ToDoViewController: UIViewController{
    @IBOutlet weak var background : UIView!
    @IBOutlet weak var weeklyButton : UIButton!
    @IBOutlet weak var yearlyButton : UIButton!
    @IBOutlet weak var titleLabel : UITextField!
    @IBOutlet weak var textFieldContainer : UIView!
    @IBOutlet weak var textfield : UITextView!
    @IBOutlet weak var iconContainer : UIView!
    @IBOutlet weak var numberListIcon : UIImageView!
    @IBOutlet weak var bulletListIcon : UIImageView!
    @IBOutlet weak var toDoListIcon : UIImageView!
    @IBOutlet weak var imageIcon : UIImageView!
    @IBOutlet weak var strikeThroughIcon : UIImageView!
    @IBOutlet weak var categoryScrollView : UIScrollView!
    @IBOutlet weak var categoryStackView : UIStackView!
    @IBOutlet weak var zoomButton : UIButton!
    @IBOutlet weak var currentLocationButton : UIButton!
    @IBOutlet weak var otherLocationButton: UIButton!
    @IBOutlet weak var addButton : UIButton!
    
    private let categories = ["Personal", "Work", "School", "Home", "Relationship", "Family", "Finance", "Health"]
    private let categoriesColor : [UIColor] = [
        UIColor(red: 226/255.0, green: 114/255.0, blue: 91/255.0, alpha: 1.0),
        UIColor(red: 160/255.0, green: 82/255.0, blue: 45/255.0, alpha: 1.0),
        UIColor(red: 183/255.0, green: 65/255.0, blue: 14/255.0, alpha: 1.0),
        UIColor(red: 139.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0),
        UIColor(red: 34.0/255.0, green: 139.0/255.0, blue: 34.0/255.0, alpha: 1.0),
        UIColor(red: 107/255.0, green: 142/255.0, blue: 35/255.0, alpha: 1.0),
        UIColor(red: 15/255.0, green: 76/255.0, blue: 129/255.0, alpha: 1.0),
        UIColor(red: 29.0/255.0, green: 53.0/255.0, blue: 87.0/255.0, alpha: 1.0)
    ]
    private let locations = ["Zoom", "Current Location", "Others"]
    
    var taskTitle : String? = ""
    var taskTextField : String? = ""
    var date = Date()
    var currentSelectedText : String? = ""
    var currentSelectedRange: NSRange?
    var currentSelectedCategory : String? = ""
    var currentSelectedLocation : String? = ""
    var isStrikeThrough : Bool = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setBackgroundColor()
        setUIForButtons()
        setUIForTextFields()
        setupUIViews()
        
        textfield.delegate = self
        titleLabel.delegate = self
    }
  
    
    @IBAction func weeklyViewPressed(_ sender: UIButton){
        performSegue(withIdentifier: "goToToDoWeeklyView", sender: self)
    }
    
    @IBAction func monthlyViewPressed(_ sender: UIButton){
        performSegue(withIdentifier: "goToToDoMonthlyView", sender: self)
    }
    
    func setBackgroundColor(){
        background.backgroundColor = UIColor(red: 249.0 / 255.0, green: 244.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
        background.layer.cornerRadius = 40.0
        textFieldContainer.backgroundColor = .white
    }
    
    func setupUIViews(){
        numberListIcon.image = UIImage(systemName: "list.number")
        bulletListIcon.image = UIImage(systemName: "list.bullet")
        toDoListIcon.image = UIImage(systemName: "checklist")
        imageIcon.image = UIImage(systemName: "photo")
        strikeThroughIcon.image = UIImage(systemName: "pencil.slash")
        
        numberListIcon.tintColor = .gray
        bulletListIcon.tintColor = .gray
        toDoListIcon.tintColor = .gray
        imageIcon.tintColor = .gray
        strikeThroughIcon.tintColor = .gray
        
        numberListIcon.isUserInteractionEnabled = true
        bulletListIcon.isUserInteractionEnabled = true
        toDoListIcon.isUserInteractionEnabled = true
        imageIcon.isUserInteractionEnabled = true
        strikeThroughIcon.isUserInteractionEnabled = true
        
        let tapNumberListIcon = UITapGestureRecognizer(target: self, action: #selector(numberIconTapped))
        numberListIcon.addGestureRecognizer(tapNumberListIcon)
        
        let tapBulletListIcon = UITapGestureRecognizer(target: self, action: #selector(bulletIconTapped))
        bulletListIcon.addGestureRecognizer(tapBulletListIcon)
        
        let tapToDoListIcon = UITapGestureRecognizer(target: self, action: #selector(toDoIconTapped))
        toDoListIcon.addGestureRecognizer(tapToDoListIcon)
        
        let tapImageIcon = UITapGestureRecognizer(target: self, action: #selector(imageIconTapped))
        imageIcon.addGestureRecognizer(tapImageIcon)
        
        let tapStrikeThroughIcon = UITapGestureRecognizer(target: self, action: #selector(strikeThroughTapped))
        strikeThroughIcon.addGestureRecognizer(tapStrikeThroughIcon)
        
        setUpCategories()
    }
    
    @objc func numberIconTapped(){
        print("number list tapped")
    }
    
    @objc func bulletIconTapped(){
        print("Bullet list icon was clicked!")
    }
    
    @objc func toDoIconTapped(){
        print("To Do list tapped")
    }
    
    @objc func imageIconTapped(){
        print("Image icon pressed")
    }
    
    @objc func strikeThroughTapped(){
        guard let currentSelectedText = currentSelectedText, !currentSelectedText.isEmpty else { return }
        guard let range = currentSelectedRange else {return}
        
        let currentAttributes = textfield.attributedText.attributes(at: range.location, effectiveRange: nil)
        let isStrikeThrough = (currentAttributes[.strikethroughStyle] as? Int ?? 0) > 0
        
        let attributedString = NSMutableAttributedString(string: currentSelectedText)
        
        if isStrikeThrough{
            attributedString.addAttributes([
                .strikethroughStyle : 0,
                .font : UIFont.systemFont(ofSize: 20.0, weight: .regular)
            ], range: NSRange(location: 0, length: attributedString.length))
        }else {
            attributedString.addAttributes([
                        .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                        .font: UIFont.systemFont(ofSize: 20)
                    ], range: NSRange(location: 0, length: attributedString.length))
        }
        textfield.textStorage.replaceCharacters(in: range, with: attributedString)

    }
    
    func setUpCategories(){
        categoryStackView.layer.cornerRadius = 15.0

        for (index, category) in categories.enumerated() {
            let button = UIButton(configuration: .filled())
            let i = index
            var config = UIButton.Configuration.filled()
            config.title = category
            config.baseBackgroundColor = categoriesColor[i]
            config.cornerStyle = .capsule
            config.baseForegroundColor = .white
            
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer{ incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
                return outgoing
            }
            
            
            button.configuration = config
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            categoryStackView.addArrangedSubview(button)
        }
    }
    
    @objc func categoryTapped(_ sender: UIButton){
        print("Selected category: \(sender.configuration?.title ?? "")")
    }
    
    func setUIForTextFields(){
        titleLabel.borderStyle = .none
        titleLabel.textColor = .darkGray
        textFieldContainer.layer.cornerRadius = 15.0
        textfield.textContainerInset = UIEdgeInsets(top: 10.0, left: 8.0, bottom: 10.0, right: 10.0)
        textfield.layer.cornerRadius = 15.0
        textfield.textColor = .lightGray
    }
    
    func setUIForButtons(){
        let buttonBgColor = UIColor(red: 192.0 / 255.0, green: 202.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
        var config = UIButton.Configuration.filled()
        
        config.baseBackgroundColor = buttonBgColor
        config.background.cornerRadius = 15.0
        config.baseForegroundColor = UIColor.darkGray
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        
        config.attributedTitle = AttributedString("Weekly View", attributes: container)
        weeklyButton.configuration = config
        
        config.attributedTitle = AttributedString("Yearly View", attributes: container)
        yearlyButton.configuration = config
        
        let antiqueIvoryColor = UIColor(red: 209.0/255.0, green: 187.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        zoomButton.backgroundColor = antiqueIvoryColor
        currentLocationButton.backgroundColor = antiqueIvoryColor
        otherLocationButton.backgroundColor = antiqueIvoryColor
        addButton.backgroundColor = .darkGray
        
        zoomButton.titleLabel?.textColor = .white
        otherLocationButton.titleLabel?.textColor = .white
        currentLocationButton.titleLabel?.textColor = .white
        addButton.titleLabel?.textColor = .white

        zoomButton.layer.cornerRadius = 15.0
        currentLocationButton.layer.cornerRadius = 15.0
        otherLocationButton.layer.cornerRadius = 15.0
        addButton.layer.cornerRadius = 20.0
        
        let locationFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        zoomButton.titleLabel?.font = locationFont
        currentLocationButton.titleLabel?.font = locationFont
        otherLocationButton.titleLabel?.font = locationFont
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
    }
}

extension ToDoViewController: UITextFieldDelegate, UITextViewDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTitle = textField.text
        textfield.becomeFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.darkGray{
            textField.text = ""
            textField.textColor = UIColor.black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty{
            taskTitle = textField.text
        }else{
            textField.text = "Title..."
            textField.textColor = UIColor.darkGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.layer.borderWidth = 1.0
        if textView.textColor == UIColor.lightGray{
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        taskTextField = textView.text
        textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.clear.cgColor
        textView.layer.borderWidth = 0
        if textView.text.isEmpty{
            textView.text = "Task..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        self.currentSelectedText = ""
        self.currentSelectedRange = nil
        
        let range = textView.selectedRange
        
        if range.length > 0{
            self.currentSelectedRange = range
            if let textRange = textView.selectedTextRange{
                if let text = textView.text(in: textRange){
                    self.currentSelectedText = text
                    print("User selected: \(text)")
                }
            }
        }
    }
}


