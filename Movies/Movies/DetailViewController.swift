//
//  DetailViewController.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 18/03/22.
//

import Alamofire
import CoreData
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var overview: UILabel!
    @IBOutlet var favButton: FavoriteButton!
    
    var movie: Movie?
    var imageData = Data()
    
    var favorite = false {
        didSet {
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
    }
    
    func isFavorite(id: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let count = try managedContext?.count(for: fetchRequest)
            if let count = count, count > 0 {
                self.favorite = true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension DetailViewController: ActionDelegateProtocol {
    func buttonTapped() {
        if favorite {
            //remover do core data
            removeFavorite()
        } else {
            //add no core data
            addFavorite()
        }
        favorite = !favorite
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
        movieData.setValue(imageData, forKeyPath: "poster_image")
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
    func removeFavorite() {
        
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


