import UIKit

class Cell: UITableViewCell{
    @IBOutlet private var star1: UIButton!
    @IBOutlet private var star2: UIButton!
    @IBOutlet private var star3: UIButton!
    @IBOutlet private var star4: UIButton!
    @IBOutlet private var star5: UIButton!
    @IBOutlet private var filmName: UILabel!
    @IBOutlet private var directorName: UILabel!
    private lazy var stars = [star1, star2, star3, star4, star5]
    private var film: Film? = nil    
    
    public func activateStars(lastIndex: Int){
        for i in 0..<5{
            if (i < lastIndex) {
                stars[i]!.setImage(UIImage(named: "StarActive.png"), for: .normal)
            } else {
                stars[i]!.setImage(UIImage(named: "Star.png"), for: .normal)
            }
        }
    }
    
    @IBAction
    func pressStar(_ sender: UIButton){
        film?.rate = sender.tag
        activateStars(lastIndex: sender.tag)
    }
    
    public func setup(with film: Film){
        self.film = film
        filmName.text = film.name
        directorName.text = film.director
        activateStars(lastIndex: film.rate)
        filmName.numberOfLines = film.name.count / 3 + 1
    }
}
