import UIKit

class Star: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var starButton1: UIButton = {
        let button = UIButton.init(type: .system)
        button.layer.cornerRadius = 7
        button.backgroundColor = .systemBrown
        button.setTitle("DO IT", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        return button
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Star.png"), for: .normal)
        return button
    }()
    
    
    func setupView(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(starButton)
        NSLayoutConstraint.activate([
            starButton.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            starButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            starButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}
