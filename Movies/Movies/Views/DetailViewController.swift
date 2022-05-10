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
    
    var movieVM: MovieViewModel?
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
        
        detailVM = DetailMovieViewModel()
        
        favButton.delegate = self
        
        setComponents()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    func setComponents() {
        guard let movieVM = movieVM else { return }
        
        movieTitle.text = movieVM.title
        
        overview.text = movieVM.overview
        overview.flashScrollIndicators()
        
        if let imageData = movieVM.imageData {
            moviePoster.image = UIImage(data: imageData, scale:1)
            
        } else {
            movieVM.getPoster(posterPath: movieVM.posterPath) { [weak self] (data) in
                self?.moviePoster.image = UIImage(data: data, scale:1)
            }
            
        }
        
        favorite = detailVM?.setFavorite(id: movieVM.id)
        
        if fromFavoriteVC == false {
            detailVM?.genreNames(movie: movieVM)
        }
        
        genresLabel.text = """
        Genres
        \(movieVM.genres ?? "")
        """
        
        voteAverageLabel.text = "\(String(movieVM.voteAverage))/10"
    
        releaseYear.text = movieVM.releaseYear
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
        guard let movieVM = movieVM else { return }
        favorite = detailVM?.setFavorite(id: movieVM.id)
    }
}

extension DetailViewController: ActionDelegateProtocol {
    func buttonTapped() {
        guard let favorite = favorite, let movieVM = movieVM else { return }
        favorite ? detailVM?.removeFavorite(id: movieVM.id) : detailVM?.addFavorite(movieVM)

        self.favorite = !favorite
    }
}
