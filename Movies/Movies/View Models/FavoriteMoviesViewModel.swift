//
//  FavoriteMoviesViewModel.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 06/05/22.
//

import Foundation

class FavoriteMoviesViewModel {
    var coreData: CoreData
    var favorites = [Movie]()
    
    init(coreData: CoreData = CoreData()) {
        self.coreData = coreData
        getFavoriteMovies()
    }
    
    func numberOfItems(_ section: Int) -> Int {
        return favorites.count
    }
    
    func modelAt(_ index: Int) -> Movie {
        return favorites[index]
    }
    
    func posterAt(_ index: Int) -> Data {
        return favorites[index].image_data ?? Data()
    }
    
    func getFavoriteMovies() {
        coreData.getFavoriteMovies() { [weak self] (movies) in
            self?.favorites = movies
        }
    }
}

