import UIKit

class FilmSaveView: UIViewController {
    weak var delegate: FilmSaveViewDelegate?
    
    private var nameFlag = false
    private var dateFlag = false
    private var directorFlag = false
    private var regexProd = "^([А-ЯA-Z]+[а-яa-z]*[ ]*)+$"
    let imageNames = ["AssaultRioBravo", "Garfild", "Nevskiy", "Papich", "Van"]
    private var saveIsActive = false
    private var directoName = "None"
    private var filmName = "None"
    private var year: Date?
    private var rate = 0
    
    private lazy var header: UILabel = {
        let label = UILabel()
        label.text = "Фильм"
        label.textAlignment = .center
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 36.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameView : CategoryView = CategoryView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .film, fun: #selector(changeText), controller: self)
    
    private lazy var directorView : CategoryView = CategoryView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .director, fun: #selector(changeText), controller: self)
    
    private lazy var dateView : CategoryView = CategoryView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .year, fun: #selector(changeText), controller: self)
    
    private lazy var starsView: Stars = Stars(frame: CGRect(x: 0, y: 0, width: 0, height: 0), sel: #selector(changeButton), controller: self)
    
    private lazy var saveButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.isEnabled = false
        button.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveResult), for: .touchUpInside)
        button.setImage(UIImage(named: "saveButton.jpg")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    @objc func changeButton(_ sender: UIButton){
        rate = sender.tag
        if nameFlag && directorFlag && dateFlag && starsView.isComplete {
            activeSave(active: true)
        } else {
            activeSave(active: false)
        }
    }
    
    @objc func changeText(_ sender: UITextField){
        let text = sender.text ?? ""
        switch sender.layer.name {
        case "Name":
            if text.count > 0 && text.count <= 300 {
                nameFlag = true
                nameView.valideField()
            } else {
                nameView.unvalideField()
                nameFlag = false
            }
            filmName = text
            
        case "Director":
            if text.count > 2 && text.count <= 300 && text.range(of: regexProd, options: .regularExpression, range: nil, locale: nil) != nil {
                directorFlag = true
                directorView.valideField()
            } else {
                directorView.unvalideField()
                directorFlag = false
            }
            directoName = text

        case "Year":
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd.MM.yyyy"
            if dateFormatterGet.date(from: sender.text ?? "") != nil {
                dateFlag = true
                year = dateFormatterGet.date(from: text)!
                dateView.valideField()
            } else {
                dateFlag = false
                year = nil
                dateView.unvalideField()
            }
        default:
            break
        }
        if nameFlag && directorFlag && dateFlag && starsView.isComplete{
            activeSave(active: true)
        } else {
            activeSave(active: false)
        }
    }
    
    @objc
    private func saveResult(_ sender: UIButton){
        guard year != nil else { return }
        let film = Film(name: filmName, director: directoName, date: year!, rating: rate)
        film.imageName = imageNames[Int.random(in: 0..<imageNames.count)]
        delegate?.addFilm(film: film)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func activeSave(active: Bool){
        if active && !saveIsActive {
            saveButton.setImage(UIImage(named: "okSave.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            saveButton.isEnabled = true
            saveIsActive = true
        }
        else if !active && saveIsActive {
            saveButton.setImage(UIImage(named: "saveButton.jpg")?.withRenderingMode(.alwaysOriginal), for: .normal)
            saveButton.isEnabled = false
            saveIsActive = false
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        view.addSubview(header)
        view.addSubview(nameView)
        view.addSubview(directorView)
        view.addSubview(dateView)
        view.addSubview(starsView)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.heightAnchor.constraint(equalToConstant: 70),
            
            nameView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
            nameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            nameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            nameView.heightAnchor.constraint(equalToConstant: 80),
            
            directorView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 10),
            directorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            directorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            directorView.heightAnchor.constraint(equalToConstant: 80),

            dateView.topAnchor.constraint(equalTo: directorView.bottomAnchor, constant: 10),
            dateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            dateView.heightAnchor.constraint(equalToConstant: 80),
            
            starsView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 30),
            starsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starsView.heightAnchor.constraint(equalToConstant: 80),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}
