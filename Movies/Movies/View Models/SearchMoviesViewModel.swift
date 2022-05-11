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

extension SearchMoviesViewModel {
    var isFirstLaunch: Bool {
        let defaults = UserDefaults.standard
        
        guard defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return true
        }
        
        return false
    }
    
    func fetchGenres(webServices: WebServices = WebServices(), coreData: CoreData = CoreData()) {
        WebServices().fetchGenres() { (result) in
            CoreData().saveGenres(result)
        }
    }
}
