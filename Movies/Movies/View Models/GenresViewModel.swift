//
//  GenresViewModel.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 09/05/22.
//

import Foundation

class GenresViewModel {
//    var genres: [Genre]?
    
}

extension GenresViewModel {
    func isFirstLaunch() -> Bool {
        let defaults = UserDefaults.standard
        
        guard defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return true
        }
        
        return false
    }
    
    func fetchGenres() {
        WebServices().fetchGenres() { (result) in
//            self?.genres = result
            CoreData().saveGenres(result)
        }
    }

}
