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
    
    var movie: Movie?
    var imageData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else { return }
        
        movieTitle.text = movie.title
        overview.text = movie.overview
        if movie.poster_path != "" {
            fetchImage()
        }
        moviePoster.image = UIImage(data: imageData, scale:1)
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        guard let movie = movie else { return }
        save(movie: movie, image: imageData)

    }
    
    func save(movie: Movie, image: Data) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "FavoriteMovies", in: managedContext)!

        let movieData = NSManagedObject(entity: entity, insertInto: managedContext)
        
        movieData.setValue(movie.id, forKeyPath: "id")
        movieData.setValue(movie.title, forKeyPath: "title")
        movieData.setValue(movie.overview, forKeyPath: "overview")
        movieData.setValue(movie.release_date, forKeyPath: "release_date")
        movieData.setValue(movie.vote_average, forKeyPath: "vote_average")
        movieData.setValue(image, forKeyPath: "poster_image")
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
