//
//  ViewController.swift
//  ios-itmo-2022-assignment2
//
//  Created by rv.aleksandrov on 29.09.2022.
//

import UIKit
import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}

class ViewController: UIViewController {
    
    private let btnImageOff = UIImage(named: "Star.png")
    private let btnImageOn = UIImage(named: "Star-2.png")
    private var rateButtons: [UIButton] = []
    private var lastStar: Int = 0
    private var starsCount: Int = 0
    private var rateFilled: Bool = false
    private var starReaction = [0: "Ваша Оценка",
                                1: "Ужасно",
                                2: "Плохо",
                                3: "Нормально",
                                4: "Хорошо",
                                5: "AMAZING!"]
    private var red: CGFloat = 0
    private var green: CGFloat = 0
    private var blue: CGFloat = 0
    private var alpha: CGFloat = 0
    private var isNameValid: Bool = false
    private var isProducerValid: Bool = false
    private var isYearValid: Bool = false
    
    private lazy var labelName = getLabel(text: "Название")
    private lazy var labelProducer = getLabel(text: "Режисёр")
    private lazy var labelYear = getLabel(text: "Год")
    
    private lazy var fieldName = getField(text: "Название фильма", selector: #selector(nameTextFieldDidChange))
    private lazy var fieldProducer = getField(text: "Режисёр фильма", selector: #selector(producerTextFieldDidChange))
    
    private lazy var labelFilms: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Фильм"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 28)
        return label
    }()

    private lazy var fieldYear: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Год выпуска"
        field.backgroundColor = .systemGray6
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 4
        field.addTarget(self, action: #selector(yearTextFieldDidChange), for: .editingChanged)
        field.inputView = datePicker
        field.inputAccessoryView = createToolBar()
        return field
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    private lazy var rateView: UIView = {
        let rview = UIView()
        rview.translatesAutoresizingMaskIntoConstraints = false
        rview.backgroundColor = .systemBackground
        return rview
    }()
    
    private lazy var star1: UIButton = makeStar(tag: 1)
    private lazy var star2: UIButton = makeStar(tag: 2)
    private lazy var star3: UIButton = makeStar(tag: 3)
    private lazy var star4: UIButton = makeStar(tag: 4)
    private lazy var star5: UIButton = makeStar(tag: 5)
    
    private lazy var labelRate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ваша Оценка"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 19)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 16
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.5)
        return button
    }()
    
    private lazy var fillValidRandomButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 16
        button.setTitle("Рандом", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(fillValidRandom), for: .touchUpInside)
        return button
    }()
    
    private func getLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12)
        return label
    }
    
    private func getField(text: String, selector: Selector) -> UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = text
        field.backgroundColor = .systemGray6
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 4
        field.addTarget(self, action: selector, for: .editingChanged)
        return field
    }
    
    private func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        toolBar.sizeToFit()
        return toolBar
    }
    
    private func textFieldDidChange() {
        confirmButton.backgroundColor = checkIfAllFieldsAreValid() ? .systemGreen : UIColor(red: red, green: green, blue: blue, alpha: 0.5)
        confirmButton.isEnabled = checkIfAllFieldsAreValid()
    }
    
    @objc func nameTextFieldDidChange() {
        if let fName = fieldName.text {
            if invalidFName(fName) {
                labelName.textColor = .red
                fieldName.layer.borderColor = UIColor.red.cgColor
                fieldName.layer.borderWidth = 1.0
                isNameValid = false
            } else {
                labelName.textColor = .darkGray
                fieldName.layer.borderColor = UIColor.systemGray6.cgColor
                fieldName.layer.borderWidth = 0
                isNameValid = true
            }
        }
        
        textFieldDidChange()
    }
    
    @objc func producerTextFieldDidChange() {
        if let fProducer = fieldProducer.text {
            if invalidFProducer(fProducer) {
                labelProducer.textColor = .red
                fieldProducer.layer.borderColor = UIColor.red.cgColor
                fieldProducer.layer.borderWidth = 1.0
                isProducerValid = false
            } else {
                labelProducer.textColor = .darkGray
                fieldProducer.layer.borderColor = UIColor.systemGray6.cgColor
                fieldProducer.layer.borderWidth = 0
                isProducerValid = true
            }
        }
        
        textFieldDidChange()
    }
    
    @objc func yearTextFieldDidChange() {
        if let fYear = fieldYear.text {
            if invalidFYear(fYear) {
                labelYear.textColor = .red
                fieldYear.layer.borderColor = UIColor.red.cgColor
                fieldYear.layer.borderWidth = 1.0
                isYearValid = false
            } else {
                labelYear.textColor = .darkGray
                fieldYear.layer.borderColor = UIColor.systemGray6.cgColor
                fieldYear.layer.borderWidth = 0
                isYearValid = true
            }
        }
        
        textFieldDidChange()
    }
    
    private func invalidFName(_ value: String) -> Bool {
        return value.count >= 1 && value.count <= 300 ? false : true
    }
    
    private func invalidFProducer(_ value: String) -> Bool {
        return value.count >= 3 && value.count <= 300 && (value.range(of: #"^([А-ЯA-Z][а-яa-z]*[\s]*)+$"#, options: .regularExpression) != nil) ? false : true
    }
    
    private func invalidFYear(_ value: String) -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd.MM.yyyy"
        return dateFormatterGet.date(from: value) == nil ? true : false
    }
    
    private func makeStar(tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = tag
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.setImage(btnImageOff?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(btnImageOn?.withRenderingMode(.alwaysOriginal), for: .selected)
        return button
    }
    
    @objc private func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = .none
        
        self.fieldYear.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        yearTextFieldDidChange()
    }
    
    func randomName() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZабвгдежзийклмнопрстуфхцчшщьюяАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЮЯ "
        return String((1..<301).map{ _ in letters.randomElement()! })
    }
    
    func randomWord(to: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZабвгдежзийклмнопрстуфхцчшщьюяАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЮЯ"
        var res = String((1..<to).map{ _ in letters.randomElement()! })
        res.capitalizeFirstLetter()
        return res
    }
    
    func randomProducer() -> String {
        let length = Int.random(in: 3..<301)
        var res = randomWord(to: length + 1)
        while res.count != length {
            let word = randomWord(to: length - res.count)
            res = res+" "+word
        }
        return res
    }
    
    func randomYear() -> String {
        let year = Int.random(in: 1895..<Calendar.current.component(.year, from: Date()))
        let month = Int.random(in: 1..<13)
        let day: Int
        if [1, 3, 5, 7, 8, 10, 12].contains(month) {
            day = Int.random(in: 1..<32)
        } else if month != 2 {
            day = Int.random(in: 1..<31)
        } else {
            if year % 4 == 0 {
                day = Int.random(in: 1..<30)
            } else {
                day = Int.random(in: 1..<29)
            }
        }
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: Calendar(identifier: .gregorian).date(from: dateComponents)!)
    }
    
    @objc private func fillValidRandom() {
        let randName = randomName()
        let randProducer = randomProducer()
        let randYear = randomYear()
        
        fieldName.text = randName
        fieldProducer.text = randProducer
        fieldYear.text = randYear
        
        nameTextFieldDidChange()
        producerTextFieldDidChange()
        yearTextFieldDidChange()
    }
    
    @objc private func buttonAction(sender: UIButton!) {
        let button: UIButton = sender
        if button.tag == lastStar {
            if button.isSelected {
                button.isSelected = false
                starsCount -= 1
            } else {
                for btn in rateButtons {
                    if btn.tag <= button.tag {
                        if !btn.isSelected {
                            btn.isSelected = true
                            starsCount += 1
                        }
                    }
                }
            }
        } else {
            if button.isSelected {
                for btn in rateButtons {
                    if btn.tag > button.tag {
                        if btn.isSelected {
                            btn.isSelected = false
                            starsCount -= 1
                        }
                    }
                }
            } else {
                for btn in rateButtons {
                    if btn.tag <= button.tag {
                        if !btn.isSelected {
                            btn.isSelected = true
                            starsCount += 1
                        }
                    }
                }
            }
            lastStar = button.tag
        }
        labelRate.text = starReaction[starsCount]
        rateFilled = starsCount > 0 ? true : false
        
        textFieldDidChange()
    }
    
    private func checkIfAllFieldsAreValid() -> Bool {
        let name = fieldName.text ?? ""
        let producer = fieldProducer.text ?? ""
        let year = fieldYear.text ?? ""
        return !name.isEmpty && !producer.isEmpty && !year.isEmpty && rateFilled && isNameValid && isProducerValid && isYearValid ? true : false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIColor.systemGreen.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        view.addSubview(labelFilms)
        view.addSubview(fillValidRandomButton)
        view.addSubview(confirmButton)
        view.addSubview(fieldName)
        view.addSubview(labelName)
        view.addSubview(fieldProducer)
        view.addSubview(labelProducer)
        view.addSubview(fieldYear)
        view.addSubview(labelYear)
        view.addSubview(rateView)
        rateView.addSubview(star1)
        rateView.addSubview(star2)
        rateView.addSubview(star3)
        rateView.addSubview(star4)
        rateView.addSubview(star5)
        rateView.addSubview(labelRate)
        
        rateButtons = [star1, star2, star3, star4, star5]
        
        NSLayoutConstraint.activate([
            labelFilms.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            labelFilms.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            labelFilms.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            labelFilms.heightAnchor.constraint(equalToConstant: 100),
            
            labelName.topAnchor.constraint(equalTo: labelFilms.bottomAnchor, constant: 16),
            labelName.leadingAnchor.constraint(equalTo: fieldName.leadingAnchor),
            
            fieldName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            fieldName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            fieldName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            fieldName.heightAnchor.constraint(equalToConstant: 48),
            
            labelProducer.topAnchor.constraint(equalTo: fieldName.bottomAnchor, constant: 16),
            labelProducer.leadingAnchor.constraint(equalTo: fieldName.leadingAnchor),
            
            fieldProducer.topAnchor.constraint(equalTo: labelProducer.bottomAnchor, constant: 8),
            fieldProducer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            fieldProducer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            fieldProducer.heightAnchor.constraint(equalToConstant: 48),
            
            labelYear.topAnchor.constraint(equalTo: fieldProducer.bottomAnchor, constant: 16),
            labelYear.leadingAnchor.constraint(equalTo: fieldProducer.leadingAnchor),
            
            fieldYear.topAnchor.constraint(equalTo: labelYear.bottomAnchor, constant: 8),
            fieldYear.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            fieldYear.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            fieldYear.heightAnchor.constraint(equalToConstant: 48),
            
            rateView.topAnchor.constraint(equalTo: fieldYear.bottomAnchor, constant: 48),
            rateView.widthAnchor.constraint(equalToConstant: 256), // (41 + 4) * 5
            rateView.heightAnchor.constraint(equalToConstant: 82),
            rateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            star3.topAnchor.constraint(equalTo: rateView.topAnchor),
            star3.centerXAnchor.constraint(equalTo: rateView.centerXAnchor),
            
            star2.topAnchor.constraint(equalTo: rateView.topAnchor),
            star2.trailingAnchor.constraint(equalTo: star3.leadingAnchor, constant: -12),
            star1.topAnchor.constraint(equalTo: rateView.topAnchor),
            star1.trailingAnchor.constraint(equalTo: star2.leadingAnchor, constant: -12),
            star4.topAnchor.constraint(equalTo: rateView.topAnchor),
            star4.leadingAnchor.constraint(equalTo: star3.trailingAnchor, constant: 12),
            star5.topAnchor.constraint(equalTo: rateView.topAnchor),
            star5.leadingAnchor.constraint(equalTo: star4.trailingAnchor, constant: 12),
            
            labelRate.bottomAnchor.constraint(equalTo: rateView.bottomAnchor),
            labelRate.centerXAnchor.constraint(equalTo: rateView.centerXAnchor),
            
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            confirmButton.heightAnchor.constraint(equalToConstant: 48),
            
            fillValidRandomButton.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -8),
            fillValidRandomButton.leadingAnchor.constraint(equalTo: confirmButton.leadingAnchor),
            fillValidRandomButton.trailingAnchor.constraint(equalTo: confirmButton.trailingAnchor),
            fillValidRandomButton.heightAnchor.constraint(equalToConstant: 48),
        ])
        confirmButton.isEnabled = false
    }
}
