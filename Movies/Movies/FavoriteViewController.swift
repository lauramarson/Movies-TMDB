//
//  FavoriteViewController.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 19/03/22.
//

import CoreData
import UIKit

private let reuseIdentifier = "Favorite"

class FavoriteViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var favorites = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        collectionView.reloadData()
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
          
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
          
        do {
            favorites = try managedContext.fetch(fetchRequest)
            print(try managedContext.fetch(fetchRequest))
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FavoriteCell else {
            fatalError("Unable to dequeue FavoriteCell.")
        }
        let movie = favorites[indexPath.row]
        if let posterData = movie.value(forKeyPath: "poster_image") as? Data {
            let posterImage = UIImage(data: posterData)
            cell.imageView.image = posterImage
        }
        cell.backgroundColor = .green

        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }
        let savedMovie = favorites[indexPath.row]
        let movie = convertMovie(movie: savedMovie)
        dvc.movie = movie
        dvc.imageData = savedMovie.value(forKey: "poster_image") as! Data
        dvc.delegate = self
        dvc.indexPath = indexPath.row
        dvc.fromFavoriteVC = true
        
        self.present(dvc, animated: true)
    }
    
    func convertMovie(movie: NSManagedObject) -> Movie {
        let id = movie.value(forKey: "id") as! Int
        let title = movie.value(forKey: "title") as! String
        let overview = movie.value(forKey: "overview") as! String
        let release_date = movie.value(forKey: "release_date") as! String
        let vote_average = movie.value(forKey: "vote_average") as! Float
        
        let convertedMovie = Movie(id: id, title: title, release_date: release_date, genre_ids: [], vote_average: vote_average, overview: overview, poster_path: "")
        
        return convertedMovie
    }
}

extension FavoriteViewController: ReloadDataProtocol {
    func update(favorite: Bool, indexPath: Int) {
        guard favorite == false else { return }
        
        favorites.remove(at: indexPath)
        collectionView.reloadData()
    }
}
