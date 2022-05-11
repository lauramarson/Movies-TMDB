//
//  DetailViewController.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 18/03/22.
//

import UIKit

protocol ReloadDataProtocol: AnyObject {
    func update()
}

class DetailViewController: UIViewController {
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var overview: UITextView!
    @IBOutlet var favButton: FavoriteButton!
    @IBOutlet var genresLabel: UILabel!
    @IBOutlet var voteAverageLabel: UILabel!
    @IBOutlet var releaseYear: UILabel!
    
    weak var delegate: ReloadDataProtocol?
    
//    var movie: Movie
    var detailVM: DetailMovieViewModel?
    
    var fromFavoriteVC = false
    
    var favorite: Bool? {
        didSet {
            guard let favorite = favorite else { return }
            favButton.favorite = favorite
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        detailVM = DetailMovieViewModel()
        
        favButton.delegate = self
        
        setComponents()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    func setComponents() {
//        guard let detailVM = detailVM else { return }
        
        movieTitle.text = detailVM?.movie.title
        
        overview.text = detailVM?.movie.overview
        overview.flashScrollIndicators()
        
        if let imageData = detailVM?.movie.image_data {
            moviePoster.image = UIImage(data: imageData, scale:1)
            
        } else {
            detailVM?.getPoster() { [weak self] in
                guard let imageData = self?.detailVM?.movie.image_data else {return}
                self?.moviePoster.image = UIImage(data: imageData, scale:1)
            }
            
        }
        
        favorite = detailVM?.setFavorite()
        
        if fromFavoriteVC == false {
            detailVM?.genreNames()
        }
        
        genresLabel.text = """
        Genres
        \(detailVM?.movie.genre_names ?? "")
        """
        
        voteAverageLabel.text = "\(String(detailVM?.movie.vote_average ?? 0))/10"
    
        releaseYear.text = detailVM?.movie.releaseYear
    }
    
    @objc func saveChanges() {
        detailVM?.saveChanges()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if fromFavoriteVC { //TODO
            fromFavoriteVC = false
            guard let favorite = favorite, !favorite else { return }
            detailVM?.saveChanges()
            self.delegate?.update()
        } else {
            detailVM?.saveChanges()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favorite = detailVM?.setFavorite()
    }
}

extension DetailViewController: ActionDelegateProtocol {
    func buttonTapped() {
        guard let favorite = favorite else { return }
        favorite ? detailVM?.removeFavorite() : detailVM?.addFavorite()

        self.favorite = !favorite
    }
}
