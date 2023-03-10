//
//  Sas.swift
//  ios-itmo-2022-assignment2
//
//  Created by mac on 23.12.2022.
//

import UIKit
import Foundation

class LFBlock {
    
    private var labelText: String
    private var fieldText: String
    private var selector: Selector
//    private var invalidText: (_ str: String) -> Bool
//    private var textFieldDidChange: (_ textField: UITextField) -> Void
//    private var viewController: ViewController
//    private lazy var label: UILabel
//    private lazy var field: UITextField
    
    init(labelText: String, fieldText: String, selector: Selector) {
        self.labelText = labelText
        self.fieldText = fieldText
        self.selector = selector
//        self.invalidText = invalidText
//        self.textFieldDidChange = textFieldDidChange
//        self.selector = selector
//        self.label = {
//            let label = UILabel()
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.text = labelText
//            label.textColor = .darkGray
//            label.font = .systemFont(ofSize: 12)
//            return label
//        }()
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelText
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    lazy var field: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = fieldText
        field.backgroundColor = .systemGray6
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 4
        field.addTarget(self, action: selector, for: .editingChanged)
//        field.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)
        return field
    }()
    
//    @objc func nameTextFieldDidChange(_ textField: UITextField) {
//        if let fText = textField.text {
//            if invalidText(fText) {
//                label.textColor = .red
//                field.layer.borderColor = UIColor.red.cgColor
//                field.layer.borderWidth = 1.0
//                viewController.isNameValid = false
//            } else {
//                label.textColor = .darkGray
//                field.layer.borderColor = UIColor.systemGray6.cgColor
//                field.layer.borderWidth = 0
//                viewController.isNameValid = true
//            }
//        }
//
//        textFieldDidChange(textField)
//    }
}
