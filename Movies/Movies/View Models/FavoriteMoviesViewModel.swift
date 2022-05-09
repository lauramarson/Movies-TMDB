//
//  FavoriteMoviesViewModel.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 06/05/22.
//

import Foundation

class FavoriteMoviesViewModel {
    var coreData: CoreData?
    var favorites = [Movie]()
    
    init() {
        self.coreData = CoreData()
        getFavoriteMovies()
    }
    
    func numberOfItems(_ section: Int) -> Int {
        return favorites.count
    }
    
    func modelAt(_ index: Int) -> MovieViewModel {
        return MovieViewModel(favorites[index])
    }
    
    func getFavoriteMovies() {
        coreData?.getFavoriteMovies() { [weak self] (movies) in
            self?.favorites = movies
        }
    }
}

