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

    var favoritesVM = FavoriteMoviesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoritesVM.getFavoriteMovies()
        collectionView.reloadData()
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoritesVM.numberOfItems(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FavoriteCell else {
            return UICollectionViewCell()
        }
        
        let imageData = favoritesVM.posterAt(indexPath.row)
        
        let posterImage = UIImage(data: imageData)
        cell.imageView.image = posterImage
        
        cell.layer.cornerRadius = 5

        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }
        
        let movie = favoritesVM.modelAt(indexPath.row)
        dvc.detailVM = DetailMovieViewModel(movie: movie)
        dvc.delegate = self
        dvc.fromFavoriteVC = true

        self.present(dvc, animated: true)
    }
}

extension FavoriteViewController: ReloadDataProtocol {
    func update() {
        favoritesVM.getFavoriteMovies()
        collectionView.reloadData()
    }
}
