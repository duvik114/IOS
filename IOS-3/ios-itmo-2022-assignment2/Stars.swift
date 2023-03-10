import Foundation
import UIKit

class Stars: UIView{
    var selector: Selector
    var controller: FilmSaveView
    public var isComplete = false
    
    private lazy var star1: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Star.png"), for: .normal)
        button.addTarget(controller, action: selector, for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var star2: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Star.png"), for: .normal)
        button.addTarget(controller, action: selector, for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var star3: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Star.png"), for: .normal)
        button.addTarget(controller, action: selector, for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var star4: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Star.png"), for: .normal)
        button.addTarget(controller, action: selector, for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var star5: UIButton = {
        let button = UIButton.init(type: .custom)
        button.tag = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Star.png"), for: .normal)
        button.addTarget(controller, action: selector, for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
        return button
    }()
    private lazy var starArray = [star1, star2, star3, star4, star5]
    
    private lazy var rating: UILabel = {
        let label = UILabel()
        label.text = "Ваша оценка"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(frame: CGRect, sel: Selector, controller: FilmSaveView) {
        self.selector = sel
        self.controller = controller
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func didTouchButton(_ sender: UIButton){
        isComplete = true
        for i in 0..<5{
            if (i < sender.tag) {
                starArray[i].setImage(UIImage(named: "StarActive.png"), for: .normal)
            } else {
                starArray[i].setImage(UIImage(named: "Star.png"), for: .normal)
            }
        }
        
        switch sender.tag{
        case 1: rating.text = "Ужасно"
        case 2: rating.text = "Плохо"
        case 3: rating.text = "Нормально"
        case 4: rating.text = "Хорошо"
        case 5: rating.text = "AMAZING!"
        default:
            break
        }
    }
    
    private func setupView(){
        addSubview(star1)
        addSubview(star2)
        addSubview(star3)
        addSubview(star4)
        addSubview(star5)
        addSubview(rating)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            star1.topAnchor.constraint(equalTo: topAnchor),
            star1.bottomAnchor.constraint(equalTo: rating.topAnchor, constant: -10),
            star1.trailingAnchor.constraint(equalTo: star2.leadingAnchor, constant: -10),
            star1.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            star2.topAnchor.constraint(equalTo: topAnchor),
            star2.bottomAnchor.constraint(equalTo: rating.topAnchor, constant: -10),
            star2.trailingAnchor.constraint(equalTo: star3.leadingAnchor, constant: -10),
            
            star3.topAnchor.constraint(equalTo: topAnchor),
            star3.bottomAnchor.constraint(equalTo: rating.topAnchor, constant: -10),
            star3.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            star4.topAnchor.constraint(equalTo: topAnchor),
            star4.bottomAnchor.constraint(equalTo: rating.topAnchor, constant: -10),
            star4.leadingAnchor.constraint(equalTo: star3.trailingAnchor),
            
            star5.topAnchor.constraint(equalTo: topAnchor),
            star5.bottomAnchor.constraint(equalTo: rating.topAnchor, constant: -10),
            star5.leadingAnchor.constraint(equalTo: star4.trailingAnchor),
            star5.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            rating.centerXAnchor.constraint(equalTo: centerXAnchor),
            rating.bottomAnchor.constraint(equalTo: bottomAnchor),
            rating.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
