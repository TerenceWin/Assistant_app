//
//  To-DoViewController.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/21.
//

import Foundation
import UIKit

class ChecklistAttachment: NSTextAttachment {
    var isChecked: Bool = false
}

class ToDoViewController: UIViewController, UIGestureRecognizerDelegate{
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
    @IBOutlet weak var datePicker : UIDatePicker!
    @IBOutlet weak var categoryScrollView : UIScrollView!
    @IBOutlet weak var categoryStackView : UIStackView!
    @IBOutlet weak var zoomButton : UIButton!
    @IBOutlet weak var currentLocationButton : UIButton!
    @IBOutlet weak var otherLocationButton: UIButton!
    @IBOutlet weak var addButton : UIButton!
    
    
    private let categories = ["Personal", "Work", "School", "Home", "Relationship", "Family", "Finance", "Health"]
    private let categoriesColor : [UIColor] = [
        UIColor(red: 226/255.0, green: 114/255.0, blue: 91/255.0, alpha: 1.0),
        UIColor(red: 221/255, green: 187/255, blue: 127/255, alpha: 1.0),
        UIColor(red: 150/255, green: 172/255, blue: 141/255, alpha: 1.0),
        UIColor(red: 250/255, green: 194/255, blue: 164/255, alpha: 1.0),
        UIColor(red: 60/255.0, green: 160/255.0, blue: 60/255.0, alpha: 1.0),
        UIColor(red: 107/255.0, green: 142/255.0, blue: 35/255.0, alpha: 1.0),
        UIColor(red: 179/255, green: 170/255, blue: 161/255, alpha: 1.0),
        UIColor(red: 149/255, green: 177/255, blue: 198/255, alpha: 1.0)
    ]
    private let locations = ["Zoom", "Current Location", "Others"]
    private var locationButtons: [UIButton] {
        return [zoomButton, currentLocationButton, otherLocationButton]
    }
    
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
        setUIForTextFields()
        setupUIViews()
        setUIForButtons()
        setUpDatePicker()
        textfield.delegate = self
        titleLabel.delegate = self
        _ = textfield.layoutManager
    }

    @IBAction func weeklyViewPressed(_ sender: UIButton){
        performSegue(withIdentifier: "goToToDoWeeklyView", sender: self)
    }
    
    @IBAction func monthlyViewPressed(_ sender: UIButton){
        performSegue(withIdentifier: "goToToDoMonthlyView", sender: self)
    }
    
    
    //MARK: - setUp UI
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
    
    //StringToAdd, Cursor location, lineRange = NSRange
    
    func addStringToTextView(text: String, range: NSRange, cursorLocation: Int){
        let attribute : [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 20.0, weight: .regular)
        ]
        let addNumberList = NSAttributedString(string: "\(text)", attributes: attribute)
        textfield.textStorage.replaceCharacters(in: range, with: addNumberList)
        textfield.selectedRange = NSRange(location: cursorLocation, length: 0)
    }
    
    @objc func numberIconTapped(){
        let range = textfield.selectedRange
        let fullText = textfield.text as NSString
        let lineRange = fullText.lineRange(for: NSRange(location: range.location, length: 0))
        let lineText = fullText.substring(with: lineRange)
            
        if lineText.count > 0{
            let firstChar = lineText[lineText.startIndex]

            if let firstNum = Int(String(firstChar)){
                guard let secondIndex = lineText.index(lineText.startIndex, offsetBy: 1, limitedBy: lineText.index(before: lineText.endIndex)) else{
                    let newCursorLocation = lineRange.location + lineText.count + 4
                    addStringToTextView(text: "\(lineText)\n1) ", range: lineRange, cursorLocation:newCursorLocation)
                    return
                }
                
                if lineText[secondIndex] == ")"{
                    let newNum = firstNum + 1
                    let newNumLength = String(newNum).count
                    let newCursorLocation = lineRange.location + lineText.count + newNumLength + 3
                    addStringToTextView(text: "\(lineText)\n\(newNum)) ", range: lineRange, cursorLocation:newCursorLocation)
                }else{
                    let newCursorLocation = lineRange.location + lineText.count + 4
                    addStringToTextView(text: "\(lineText)\n1) ", range: lineRange, cursorLocation:newCursorLocation)
                }
            }else{
                let newCursorLocation = lineRange.location + lineText.count + 4
                addStringToTextView(text: "\(lineText)\n1) ", range: lineRange, cursorLocation:newCursorLocation)
            }
        }else{
            let newCursorLocation = lineRange.location + 3
            addStringToTextView(text: "1) ", range: lineRange, cursorLocation:newCursorLocation)
        }
    }

    
    @objc func bulletIconTapped(){
        let range = textfield.selectedRange
        let fullText = textfield.text as NSString
        let lineRange = fullText.lineRange(for: NSRange(location: range.location, length: 0))
        let currentLine = fullText.substring(with: lineRange)
        
        let attribute : [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20.0, weight: .regular)        ]
        
        if currentLine.count > 0{
            //Add [\n • ]
            let bulletIconNewLine : String = "\(currentLine)\n• "
            let attributedBullet = NSAttributedString(string: bulletIconNewLine, attributes: attribute)
            
            textfield.textStorage.replaceCharacters(in: lineRange, with: attributedBullet)
            
            let newCaretLocation = lineRange.location + currentLine.count + 3
            textfield.selectedRange = NSRange(location: newCaretLocation + 1, length: 0)
        }else{
            // Add [ • ]
            let bulletIconNoNewLine : String = "• "
            let attributedBullet = NSAttributedString(string: bulletIconNoNewLine, attributes: attribute)
            textfield.textStorage.replaceCharacters(in: lineRange, with: attributedBullet)
            
            let newCaretLocation = lineRange.location + 2
            textfield.selectedRange = NSRange(location: newCaretLocation + 1, length: 0)
        }
    }
    
    
    func getCurrentLineText() -> String? {
        let range = textfield.selectedRange //Cursor position
        let fullText = textfield.text as NSString //TextView text -> NSString, purpose = to use lineRange
        //Get range between previous \n and next \n
        let lineRange = fullText.lineRange(for: NSRange(location: range.location, length: 0))
        let lineText = fullText.substring(with: lineRange)  //Convert NSRange -> text from UITextView
        
        return lineText
    }
    
    
    @objc func toDoIconTapped(){
        var range = textfield.selectedRange
        let fullText = textfield.text as NSString
        let lineRange = fullText.lineRange(for: NSRange(location: range.location, length: 0))
        let currentLine = fullText.substring(with: lineRange)
        
        if currentLine == ""{
            addCheckMark(range: range)
        }else{
            let endOfLine = lineRange.length + lineRange.location
            let attributeString = NSAttributedString(string: "\n", attributes: [.font: UIFont.systemFont(ofSize: 20.0)])
            print(endOfLine)
            print(lineRange.location)
            
            textfield.textStorage.insert(attributeString, at: endOfLine)
            let newCursorPosition = endOfLine + 1
            textfield.selectedRange = NSRange(location: newCursorPosition, length: 0)
            range = textfield.selectedRange
            addCheckMark(range: range)
        }
        
        //If currentLine is blank?
        //Yes -> Add Icon at cursor.location, Add 5 spaces to texfield.textStorage, move cursor.location
        //No -> Add \n and move to new cursor.location + 1, add Icon at the new cursor.location, add 5 spaces to textfield.textStorage, move cursor.location

    }
    
    func addCheckMark(range: NSRange){
        let button = UIButton(type: .custom)
                let config = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .regular)
                button.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: config), for: .normal)
                button.tintColor = .workNavy
                button.addTarget(self, action: #selector(checkMarkTapped(_:)), for: .touchUpInside)
                
                
                let style = NSMutableParagraphStyle()
                style.firstLineHeadIndent = 0
                style.headIndent = 30
                
                let attribute : [NSAttributedString.Key: Any] = [
                    .font : UIFont.systemFont(ofSize: 20.0),
                    .paragraphStyle : style
                ]
                
                let spacer = NSAttributedString(string: "     ", attributes: attribute)
                textfield.textStorage.insert(spacer, at: range.location)
                
                textfield.layoutManager.ensureLayout(for: textfield.textContainer) //Update layout after spacer is added
               
                let glyphIndex = textfield.layoutManager.glyphIndexForCharacter(at: range.location)
                let lineRect = textfield.layoutManager.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: nil)
                
                button.frame = CGRect(
                    x: textfield.textContainerInset.left,
                    y: lineRect.origin.y + textfield.textContainerInset.top,
                    width: 25,
                    height: 25
                )
                button.tag = range.location
                print("button's tag = \(button.tag)")
                textfield.addSubview(button)
                textfield.selectedRange = NSRange(location: range.location + 5, length: 0)
    }
    
    @objc func checkMarkTapped(_ sender: UIButton){
        sender.isSelected.toggle()
        let symbolName = sender.isSelected ? "checkmark.circle.fill" : "checkmark.circle"
        let config = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .regular)
        sender.setImage(UIImage(systemName: symbolName, withConfiguration: config), for: .normal)
        
        let feedback = UISelectionFeedbackGenerator()
        feedback.selectionChanged()
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
        guard let tappedTitle = sender.configuration?.title else {return}
        if currentSelectedCategory != "" || currentSelectedCategory != nil{
            if currentSelectedCategory == tappedTitle{
                currentSelectedCategory = ""
            }else{
                currentSelectedCategory = tappedTitle
            }
        }else{
            currentSelectedCategory = tappedTitle
        }
                
        for case let button as UIButton in categoryStackView.arrangedSubviews{
            let isSelected = (button.configuration?.title == currentSelectedCategory)
            var updateConfig = button.configuration
            
            if isSelected{
                updateConfig?.background.strokeColor = .darkGray
                updateConfig?.background.strokeWidth = 2.5
            }else{
                updateConfig?.background.strokeColor = .clear
                updateConfig?.background.strokeWidth = 0.0
            }
            button.configuration = updateConfig
        }
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
        //Weekly and Monthly View Buttons
        let buttonBgColor = UIColor(red: 192.0 / 255.0, green: 202.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
        var config = UIButton.Configuration.filled()
        
        config.baseBackgroundColor = buttonBgColor
        config.background.cornerRadius = 15.0
        config.baseForegroundColor = UIColor.darkGray
        
        var fontContainer = AttributeContainer()
        fontContainer.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        
        config.attributedTitle = AttributedString("Weekly View", attributes: fontContainer)
        weeklyButton.configuration = config
        
        config.attributedTitle = AttributedString("Yearly View", attributes: fontContainer)
        yearlyButton.configuration = config
        
        //Location Buttons
        let locationBgColor = UIColor(red: 209.0/255.0, green: 187.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        var locationConfig = UIButton.Configuration.filled()
        
        locationConfig.background.cornerRadius = 15.0
        locationConfig.baseBackgroundColor = locationBgColor
        locationConfig.baseForegroundColor = UIColor.white
        
        var locationFontContainer = AttributeContainer()
        locationFontContainer.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        
        let locationButtonsName : [String] = ["Zoom?", "Current Location?", "Other Location?"]
        
        for (index, button) in locationButtons.enumerated(){
            locationConfig.attributedTitle = AttributedString("\(locationButtonsName[index])", attributes: locationFontContainer)
            button.configuration = locationConfig
            button.addTarget(self, action: #selector(locationTapped(_:)), for: .touchUpInside)
        }
        
        //Add Buttons
        var addButtonConfig = UIButton.Configuration.filled()
        
        addButtonConfig.baseBackgroundColor = UIColor.lightGray
        addButtonConfig.baseForegroundColor = UIColor.darkGray
        addButtonConfig.background.cornerRadius = 15.0
        
        var addButtonFontContainer = AttributeContainer()
        addButtonFontContainer.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        
        addButtonConfig.attributedTitle = AttributedString("Add", attributes: addButtonFontContainer)
        addButton.configuration = addButtonConfig
        addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func locationTapped(_ sender: UIButton){
        guard let tappedTitle = sender.titleLabel?.text else {return}
        
        if currentSelectedLocation == tappedTitle {
                currentSelectedLocation = ""
            } else {
                currentSelectedLocation = tappedTitle
            }
        
        for button in locationButtons{
            let isSelected = (button.configuration?.title == currentSelectedLocation)
            var config = button.configuration
            
            config?.background.strokeWidth = isSelected ? 2.0 : 0.0
            config?.background.strokeColor = .darkGray
            
            button.configuration = config
        }
    }
    
    @objc func addButtonTapped(_ sender: UIButton){
        print("Add button is pressed")
    }
    
    func setUpDatePicker(){
        datePicker.minuteInterval = 15
    }
}

//MARK: - TextField, TextView Delegate
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //If "Enter"
        //Get current Line text
        //If the first strings == [•] or [1) / 2) ] , *to-do symbol*]
        // If current line first string = [ • text...] then \n •
        // If current line have • then remove •
        if text == "\n"{
            let nsString = textView.text as NSString
            let lineRange = nsString.lineRange(for: range)
            let currentLine = nsString.substring(with: lineRange)
            let cleanLine = currentLine.trimmingCharacters(in: .whitespacesAndNewlines)
            if cleanLine.isEmpty
            {
                return true
            }
            
            if lineRange.location < textfield.textStorage.length{
                let attrs = textfield.textStorage.attributes(at: lineRange.location, effectiveRange: nil)
                let style = attrs[.paragraphStyle] as? NSParagraphStyle
                
                if style?.headIndent == 30{
                    let tempCurrentLine = nsString.substring(with: lineRange)
                    let tempCleanLine = tempCurrentLine.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if !tempCurrentLine.hasPrefix("     ") {
                        return true
                    }
                    
                    if tempCleanLine.isEmpty{
                        textfield.textStorage.replaceCharacters(in: lineRange, with: "")
                        return false
                    }
                    
                    let attribute: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 20.0),
                        .paragraphStyle: style!
                    ]
                    let newLineWithSpacer = NSAttributedString(string: "\n", attributes: attribute)
                    textfield.textStorage.replaceCharacters(in: range, with: newLineWithSpacer)
                    
                    addCheckMark(range: NSRange(location: range.location + 1, length: 0))
                    return false
                }
            }else{
                return true
            }
            
            
            let firstChar = currentLine[currentLine.startIndex]
            if firstChar == "•"{
                if cleanLine == "•"{
                    textView.textStorage.replaceCharacters(in: lineRange, with: "")
                    return false
                }
                let attribute : [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 20.0, weight: .regular)
                ]
                let addBulletList = NSAttributedString(string: "\n• ", attributes: attribute)
                textView.textStorage.replaceCharacters(in: range, with: addBulletList)
                
                let newCursorLocatoin = range.location + 3
                textView.selectedRange = NSRange(location: newCursorLocatoin, length: 0)
                return false
            }//end bulletList
            
            if let firstNum = Int(String(firstChar)){
                guard let secondCharIndex =  currentLine.index(currentLine.startIndex, offsetBy: 1, limitedBy: currentLine.index(before: currentLine.endIndex)) else{
                    return true
                }
                
                if currentLine[secondCharIndex] == ")"{
                    if cleanLine == "\(firstChar))"{
                        textView.textStorage.replaceCharacters(in: lineRange, with: "")
                        return false
                    }
                    let nextNum = firstNum + 1
                    let attribute : [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 20.0, weight: .regular)
                    ]
                    let addNumberList = NSAttributedString(string: "\n\(nextNum)) ", attributes: attribute)
                    textView.textStorage.replaceCharacters(in: range, with: addNumberList)
                    
                    let newCursorLocation = range.location + 4
                    textView.selectedRange = NSRange(location: newCursorLocation, length: 0)
                    
                    return false
                }
            } //end NumberList
           return true
        }//end "\n"
        if text == ""{
            print("delete button")
            let fullText = textView.text as NSString
            let deletedChar = fullText.substring(with: range)
            if deletedChar == " "{
                let currentRange = textView.selectedRange
                let lineRange = fullText.lineRange(for: currentRange)
                let currentLine = fullText.substring(with: lineRange)
                //get the text of the current line until the deleted whitespace character
                let relativeLocation = range.location - lineRange.location
                if currentLine.hasPrefix("    ") && relativeLocation < 5{
                    print("\(lineRange.location)")
                    removeButtonAt(tagLocation: lineRange.location)
                    
                    //Remove the spaces and move cursor location
                    if lineRange.location == 0{
                        let style = NSMutableParagraphStyle()
                        style.firstLineHeadIndent = 0
                        style.headIndent = 0
                        
                        let defaultAttributes: [NSAttributedString.Key: Any] = [
                            .font: UIFont.systemFont(ofSize: 20.0, weight: .regular),
                            .paragraphStyle: style
                        ]
                        
                        let newLine = NSAttributedString(string: "\n", attributes: defaultAttributes)
                        print("newLIne : (\(newLine))")
                        
                        textView.textStorage.beginEditing()
                        textView.textStorage.replaceCharacters(in: lineRange, with: newLine)
                        textView.textStorage.endEditing()
                        textView.selectedRange = NSRange(location: 0, length: 0)
                        
                        return false
                    }else{
                        print("else run")
                        textView.textStorage.replaceCharacters(in: lineRange, with: "")
                        textView.selectedRange = NSRange(location: lineRange.location, length: 0)
                        return false
                    }
                }else{
                    return true
                }
                
            }else{
                return true
            }
        }
        
        return true
    }//end function
    
    func removeButtonAt(tagLocation: Int){
        if let button = textfield.viewWithTag(tagLocation){
            button.removeFromSuperview()
        }
        for subview in textfield.subviews {
            if let button = subview as? UIButton {
                print("Existing button tag:", button.tag)
            }
        }
    }
    
    func textView(_ textView: UITextView,
                  shouldInteractWith textAttachment: NSTextAttachment,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        
        guard let checklist = textAttachment as? ChecklistAttachment else {
            return true
        }
        
        checklist.isChecked.toggle()
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        
        if checklist.isChecked {
            checklist.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
        } else {
            checklist.image = UIImage(systemName: "circle", withConfiguration: config)
        }
        
        return false
    }
    
    
}
