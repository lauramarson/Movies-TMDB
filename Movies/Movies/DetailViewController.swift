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
    @IBOutlet var overview: UILabel!
    @IBOutlet var favButton: FavoriteButton!
    
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
        
        guard let movie = movie else { return }
        
        favButton.delegate = self
        
        movieTitle.text = movie.title
        overview.text = movie.overview
        if movie.poster_path != "" {
            fetchImage()
        }
        moviePoster.image = UIImage(data: imageData, scale:1)
        isFavorite(id: movie.id)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func saveChanges() {
        guard let managedContext = managedContext else { return }
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
    func isFavorite(id: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let count = try managedContext?.count(for: fetchRequest)
            if let count = count, count == 1 {
                self.favorite = true
            } else {
                self.favorite = false
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveChanges()
        if fromFavoriteVC {
            fromFavoriteVC = false
            guard let favorite = favorite, let indexPath = indexPath else { return }
            self.delegate?.update(favorite: favorite, indexPath: indexPath)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let movie = movie else { return }
        isFavorite(id: movie.id)
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
        
        let genres = genreNames(movie: movie, managedContext: managedContext)
        
        movieData.setValue(movie.id, forKeyPath: "id")
        movieData.setValue(movie.title, forKeyPath: "title")
        movieData.setValue(movie.overview, forKeyPath: "overview")
        movieData.setValue(movie.release_date, forKeyPath: "release_date")
        movieData.setValue(movie.vote_average, forKeyPath: "vote_average")
        movieData.setValue(genres, forKeyPath: "genres")
        movieData.setValue(imageData, forKeyPath: "poster_image")
//        do {
//            try managedContext.save()
//          } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//          }
    }
    
    func removeFavorite() {
        guard let movie = movie, let managedContext = managedContext else { return }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
//        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
        
        do {
            let object = try managedContext.fetch(fetchRequest)
            print(object)
            managedContext.delete(object[0])
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func genreNames(movie: Movie, managedContext: NSManagedObjectContext) -> [String] {
        var genreNames = [String]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        
        for id in movie.genre_ids {
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        }
        
        do {
            let genres = try managedContext.fetch(fetchRequest)
            
            for genre in genres {
                let name = genre.value(forKey: "name") as! String
                genreNames.append(name)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return genreNames
    }
}

extension DetailViewController {
    func fetchImage() {
        guard let movie = movie else { return }
        AF.request("https://image.tmdb.org/t/p/w500\(movie.poster_path)",method: .get).response { response in
            switch response.result {
                case .success(let responseData):
                    self.imageData = responseData ?? Data()
                    self.moviePoster.image = UIImage(data: self.imageData, scale:1)
                
                case .failure(let error):
                    print("ERROR:",error)
            }
        }
    }
}


