//
//  SearchMoviesViewModel.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 03/05/22.
//

import Foundation

class SearchMoviesViewModel {
    var moviesSearched = [Movie]()
    
    func numberOfRows(_ section: Int) -> Int {
        return moviesSearched.count
    }
    
    func modelAt(_ index: Int) -> Movie {
        return moviesSearched[index]
    }
    
    func eraseMovies() {
        self.moviesSearched.removeAll(keepingCapacity: true)
    }
}

extension SearchMoviesViewModel {
    
    func searchForMovies(searchText: String, completion: @escaping () -> ()) {
        
        WebServices().fetchMovies(searchText: searchText) { [weak self] (result) in
            self?.moviesSearched = result
            completion()
        }
    }
}
