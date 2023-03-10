import UIKit
public enum typeCategory{
    case film, director, year
}
class CategoryView: UIView, UITextFieldDelegate{
    let type: typeCategory
    var selector: Selector
    var controller: FilmSaveView
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 12
        return CGSize(width: originalContentSize.width + 20, height: height)
    }
    
    private lazy var header: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fieldYear: UITextField = {
        let field = UITextField()
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        field.layer.cornerRadius = 4
        field.inputView = datePicker
        field.borderStyle = .roundedRect
        field.placeholder = "Год выпуска"
        field.inputAccessoryView = toolBar
        field.translatesAutoresizingMaskIntoConstraints = false
        field.addTarget(controller, action: selector, for: .allEditingEvents)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        return field
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    init(frame: CGRect, type: typeCategory, fun: Selector, controller: FilmSaveView) {
        self.type = type
        self.selector = fun
        self.controller = controller
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    public func setLabel(text: String) {
        header.text = text
    }
    
    @objc private func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .none
        dateFormatter.dateFormat = "dd.MM.yyyy"
        self.fieldYear.text = dateFormatter.string(from: datePicker.date)
        fieldYear.endEditing(true)
    }
    
    public func valideField(){
        header.textColor = .darkGray
        stepsTextField.layer.borderWidth = 0.0
        stepsTextField.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    public func unvalideField(){
        header.textColor = .red
        stepsTextField.layer.borderWidth = 1.0
        stepsTextField.layer.borderColor = UIColor.red.cgColor
    }
    
    var stepsTextField = UITextField()
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(header)
        switch type{
        case .film, .director, .year:
            stepsTextField = UITextField()
            if type == .film{
                header.text = "Название"
                stepsTextField.layer.name = "Name"
                stepsTextField.placeholder = "Название фильма"
            }  else if type == .director {
                header.text = "Режиссёр"
                stepsTextField.layer.name = "Director"
                stepsTextField.placeholder = "Режиссёр фильма"
            } else {
                header.text = "Год"
                stepsTextField = fieldYear
                stepsTextField.placeholder = "Год"
                stepsTextField.layer.name = "Year"
            }
            
            stepsTextField.backgroundColor = .systemGray6
            stepsTextField.addTarget(controller, action: selector, for: .editingChanged)
            stepsTextField.translatesAutoresizingMaskIntoConstraints = false
            stepsTextField.borderStyle = .roundedRect
            addSubview(stepsTextField)
            NSLayoutConstraint.activate([
                header.topAnchor.constraint(equalTo: topAnchor, constant: 12),
                header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                header.heightAnchor.constraint(equalToConstant: 15),
                
                stepsTextField.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
                stepsTextField.leadingAnchor.constraint(equalTo: header.leadingAnchor),
                stepsTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
                stepsTextField.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}
