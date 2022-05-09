//
//  FavoriteViewController.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 19/03/22.
//

import UIKit

private let reuseIdentifier = "Favorite"

class FavoriteViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
//    var favorites = [NSManagedObject]()
    var favoritesVM = FavoriteMoviesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView.reloadData()
    }
    
//    func fetchData() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
//
//        do {
//            favorites = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }

}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoritesVM.numberOfItems(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FavoriteCell else {
            return UICollectionViewCell()
        }
        
        let movieVM = favoritesVM.modelAt(indexPath.row)
        if let imageData = movieVM.imageData {
            let posterImage = UIImage(data: imageData)
            cell.imageView.image = posterImage
        }
        
        cell.layer.cornerRadius = 5

        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }
        let movieVM = favoritesVM.modelAt(indexPath.row)
        
        dvc.movieVM = movieVM
//        dvc.imageData = savedMovie.value(forKey: "poster_image") as! Data //TODO
        dvc.delegate = self
//        dvc.indexPath = indexPath.row
        dvc.fromFavoriteVC = true

        self.present(dvc, animated: true)
    }
    
//    func convertMovie(movie: NSManagedObject) -> Movie { //TODO
//        let id = movie.value(forKey: "id") as! Int
//        let title = movie.value(forKey: "title") as! String
//        let overview = movie.value(forKey: "overview") as! String
//        let release_date = movie.value(forKey: "release_date") as! String
//        let vote_average = movie.value(forKey: "vote_average") as! Float
//        let genre_names = movie.value(forKey: "genres") as! String
//        
//        let convertedMovie = Movie(id: id, title: title, release_date: release_date, genre_ids: [], vote_average: vote_average, overview: overview, poster_path: "", genre_names: genre_names)
//        return convertedMovie
//    }
}

extension FavoriteViewController: ReloadDataProtocol {
    func update(favorite: Bool, indexPath: Int) {
//        guard favorite == false else { return }
//
//        favorites.remove(at: indexPath)
        collectionView.reloadData()
    }
}
