import UIKit
import OrderedCollections
import SwiftUI

class ListFilmsView: UIViewController {
    @IBOutlet private var tableView: UITableView!
    var sectionCounter = Dictionary<Date, Int>()
    let dateFormatter = DateFormatter()
    var dateSections: [Date] = []
    var films: [Film] = []
    
    @IBAction
    private func addNewFilm(_ sender: UIButton){
        let filmSaveView = FilmSaveView()
        filmSaveView.delegate = self
        navigationItem.backButtonDisplayMode = .minimal
        self.navigationController?.pushViewController(filmSaveView, animated: true)
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Array")?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Array")?.withRenderingMode(.alwaysOriginal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dateFormatter.dateFormat = "dd.MM.yyyy"
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
}

class Film: Comparable{
    let name: String
    let director: String
    let date: Date
    var rate: Int
    var imageName: String
    let year: Int
    init(name: String, director: String, date: Date, rating: Int) {
        self.name = name
        self.director = director
        self.date = date
        self.rate = rating
        self.imageName = ""
        self.year = Calendar.current.component(.year, from: date)
    }
    
    static func == (lhs: Film, rhs: Film) -> Bool { return lhs.date == rhs.date }
    static func < (lhs: Film, rhs: Film) -> Bool { return lhs.date < rhs.date }
}

protocol CellDelegate: ListFilmsView {}

protocol FilmSaveViewDelegate: ListFilmsView {
    func addFilm(film: Film)
}

extension ListFilmsView: UITableViewDelegate, UITableViewDataSource, CellDelegate, FilmSaveViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Удалить") {
            action, view, completion in
            var c = 0
            for i in 0..<indexPath.section { c += self.sectionCounter[self.dateSections[i]] ?? 0 }
            var sectionDeleted = false
            if self.sectionCounter[self.dateSections[indexPath.section]] ?? 0 == 1 {
                self.sectionCounter[self.dateSections[indexPath.section]] = 0
                self.dateSections.remove(at: indexPath.section)
                sectionDeleted = true
            } else {
                self.sectionCounter[self.dateSections[indexPath.section]] = (self.sectionCounter[self.dateSections[indexPath.section]] ?? 1) - 1
            }
            
            tableView.performBatchUpdates( {
                tableView.deleteRows(at: [indexPath], with: .none)
                if sectionDeleted{
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .none)
                }
            }, completion: nil)
            self.films.remove(at: c + indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    private func helpFun(indexPath: IndexPath) -> Int {
        var index = 0
        var sectionNum = 0
        for i in dateSections{
            if sectionNum >= indexPath.section { break }
            index += sectionCounter[i] ?? 0
            sectionNum += 1
        }
        return index + indexPath.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? Cell else {
            return UITableViewCell()
        }
        let index = helpFun(indexPath: indexPath)
        tableCell.setup(with: films[index])
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = helpFun(indexPath: indexPath)
        let film = films[index]
        let host = UIHostingController(rootView: FIlmCardView(film.name, film.director, film.rate, film.imageName))
        navigationController?.pushViewController(host, animated: true)
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateFormatter.string(from: dateSections[section])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionCounter[dateSections[section]]!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 144 }
    
    func numberOfSections(in tableView: UITableView) -> Int { dateSections.count }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return films.map({ String($0.year) })
    }
    
    func addFilm(film: Film) {
        var sectionInsertIndex: Int
        sectionInsertIndex = dateSections.count
        for i in 0..<dateSections.count{
            if dateSections[i] >= film.date {
                sectionInsertIndex = i
                break
            }
        }
        let sectionRows = sectionCounter[film.date] ?? 0
        sectionCounter[film.date] = sectionRows + 1
        if films.count == 0 || films[films.count - 1].date <= film.date {
            films.append(film)
        }
        else {
            for i in 0..<films.count {
                if films[i].date > film.date {
                    films.insert(film, at: i)
                    break
                }
            }
        }
        var sectionInsertionNeeded = false
        if !dateSections.contains(film.date){
            sectionInsertionNeeded = true
            dateSections.insert(film.date, at: sectionInsertIndex)
        }
        tableView.performBatchUpdates({
            if sectionInsertionNeeded{
                tableView.insertSections(IndexSet(integer: sectionInsertIndex), with: .none)
            }
            tableView.insertRows(at: [IndexPath(row: sectionRows, section: sectionInsertIndex)], with: .none)
        }, completion: nil)
    }
}
