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
    
    var fromFavoriteVC = false
    var indexPath: Int?
    var movie: Movie?
    var imageData = Data()
    
    var favorite: Bool? {
        didSet {
            guard let favorite = favorite else { return }
            favButton.favorite = favorite
        }
    }
    
    var managedContext: NSManagedObjectContext? {
        (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer
            .viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favButton.delegate = self
        
        if fromFavoriteVC == false {
            genreNames()
        }
        
        setComponents()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    func setComponents() {
        guard let movie = movie else { return }
        
        movieTitle.text = movie.title
        
        overview.text = movie.overview
        overview.flashScrollIndicators()
        
        if movie.poster_path != "" {
            fetchImage()
        }
        moviePoster.image = UIImage(data: imageData, scale:1)
        
        setFavorite(id: movie.id)
        
        genresLabel.text = """
        Genres
        \(movie.genre_names ?? "")
        """
        
        voteAverageLabel.text = "\(String(movie.vote_average))/10"
    
        let yearString = String(movie.release_date.prefix(4))
        releaseYear.text = yearString  
    }
    
    @objc func saveChanges() {
        guard let managedContext = managedContext else { return }
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
    func setFavorite(id: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let count = try managedContext?.count(for: fetchRequest)
            self.favorite = (count == 1)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveChanges()
        if fromFavoriteVC { //TODO
            fromFavoriteVC = false
            guard let favorite = favorite, let indexPath = indexPath else { return }
            self.delegate?.update(favorite: favorite, indexPath: indexPath)
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
    
    func addFavorite() {
        guard let movie = movie, let managedContext = managedContext else { return }

        let entity = NSEntityDescription.entity(forEntityName: "FavoriteMovies", in: managedContext)!

        let movieData = NSManagedObject(entity: entity, insertInto: managedContext)
        
        movieData.setValue(movie.id, forKeyPath: "id")
        movieData.setValue(movie.title, forKeyPath: "title")
        movieData.setValue(movie.overview, forKeyPath: "overview")
        movieData.setValue(movie.release_date, forKeyPath: "release_date")
        movieData.setValue(movie.vote_average, forKeyPath: "vote_average")
        movieData.setValue(movie.genre_names, forKeyPath: "genres")
        movieData.setValue(imageData, forKeyPath: "poster_image")
    }
    
    func removeFavorite() {
        guard let movie = movie, let managedContext = managedContext else { return }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
        
        do { //******
            let object = try managedContext.fetch(fetchRequest)
            managedContext.delete(object[0])
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension DetailViewController {
    func fetchImage() {
        guard let movie = movie else { return }
        AF.request("https://image.tmdb.org/t/p/w500\(movie.poster_path)",method: .get).response { [weak self] response in
            guard let self = self else { return }
            switch response.result {
                case .success(let responseData):
                    self.imageData = responseData ?? Data()
                    self.moviePoster.image = UIImage(data: self.imageData, scale:1)
                
                case .failure(let error):
                    print("ERROR:",error)
            }
        }
    }
    
    func genreNames() {
        guard let movie = movie, let managedContext = managedContext else { return }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieGenres")
        
        let genreNames: [String] = movie.genre_ids.compactMap { genreID in
            fetchRequest.predicate = NSPredicate(format: "id == %d", genreID)
            return try?
                managedContext.fetch(fetchRequest)
                .first?
                .value(forKey: "name") as? String
        }

        self.movie?.genre_names = genreNames.joined(separator: ", ")
    }
}



