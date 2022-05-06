//
//  DetailViewController.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 18/03/22.
//

import Alamofire
import CoreData
import UIKit

protocol ReloadDataProtocol: AnyObject {
    func update(favorite: Bool, indexPath: Int)
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
    
    var fromFavoriteVC = false
    var indexPath: Int?
//    var imageData = Data()
    
    var favorite: Bool? {
        didSet {
            guard let favorite = favorite else { return }
            favButton.favorite = favorite
        }
    }
    
//    var managedContext: NSManagedObjectContext? {
//        (UIApplication.shared.delegate as? AppDelegate)?
//            .persistentContainer
//            .viewContext
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favButton.delegate = self
//
//        if fromFavoriteVC == false {
//            genreNames()
//        }
        
        setComponents()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    func setComponents() {
        guard let movieVM = movieVM else { return }
        
        movieTitle.text = movieVM.title
        
        overview.text = movieVM.overview
        overview.flashScrollIndicators()
        
        if movieVM.posterPath != "" {
            movieVM.getPoster(posterPath: movieVM.posterPath) { [weak self] (data) in
//                self?.imageData = data
                self?.moviePoster.image = UIImage(data: data, scale:1)
            }
        }
//        moviePoster.image = UIImage(data: imageData, scale:1)
        
        setFavorite(id: movieVM.id)
        
        genresLabel.text = """
        Genres
        \(movie.genre_names ?? "")
        """
        
        voteAverageLabel.text = "\(String(movieVM.voteAverage))/10"
    
        releaseYear.text = movieVM.releaseYear
    }
    
//    @objc func saveChanges() {
//        guard let managedContext = managedContext else { return }
//        
//        do {
//            try managedContext.save()
//          } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//          }
//    }
    
//    func setFavorite(id: Int) {
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
//        fetchRequest.fetchLimit =  1
//        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
//
//        do {
//            let count = try managedContext?.count(for: fetchRequest)
//            self.favorite = (count == 1)
//
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if fromFavoriteVC { //TODO
            fromFavoriteVC = false
            guard let favorite = favorite, let indexPath = indexPath, !favorite else { return }
            saveChanges()
            self.delegate?.update(favorite: favorite, indexPath: indexPath)
        } else {
            saveChanges()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let movie = movie else { return }
        setFavorite(id: movie.id)
    }
}

extension DetailViewController: ActionDelegateProtocol {
    func buttonTapped() {
        guard let favorite = favorite else { return }
        favorite ? removeFavorite() : addFavorite()

        self.favorite = !favorite
    }

//    func addFavorite() {
//        guard let movieVM = movieVM, let managedContext = managedContext else { return }
//
//        let entity = NSEntityDescription.entity(forEntityName: "FavoriteMovies", in: managedContext)!
//
//        let movieData = NSManagedObject(entity: entity, insertInto: managedContext)
//
//        movieData.setValue(movieVM.id, forKeyPath: "id")
//        movieData.setValue(movieVM.title, forKeyPath: "title")
//        movieData.setValue(movieVM.overview, forKeyPath: "overview")
//        movieData.setValue(movieVM.releaseYear, forKeyPath: "release_date")
//        movieData.setValue(movieVM.voteAverage, forKeyPath: "vote_average")
//        movieData.setValue(movieVM.genres, forKeyPath: "genres")
//        movieData.setValue(movieVM.imageData, forKeyPath: "poster_image")
//    }

//    func removeFavorite() {
//        guard let movieVM = movieVM, let managedContext = managedContext else { return }
//
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
//        fetchRequest.fetchLimit =  1
//        fetchRequest.predicate = NSPredicate(format: "id == %d", movieVM.id)
//
//        do { //******
//            let object = try managedContext.fetch(fetchRequest)
//            managedContext.delete(object[0])
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }
}

extension DetailViewController {

//    func genreNames() {
//        guard let movie = movie, let managedContext = managedContext else { return }
//
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieGenres")
//
//        let genreNames: [String] = movie.genre_ids.compactMap { genreID in
//            fetchRequest.predicate = NSPredicate(format: "id == %d", genreID)
//            return try?
//                managedContext.fetch(fetchRequest)
//                .first?
//                .value(forKey: "name") as? String
//        }
//
//        self.movie?.genre_names = genreNames.joined(separator: ", ")
//    }
}




