//
//  DetailMovieViewModel.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 06/05/22.
//

import Foundation

class DetailMovieViewModel {
    var coreData: CoreData?
    
    init() {
        self.coreData = CoreData()
    }
    
    func setFavorite(id: Int) -> Bool {
        
        guard let coreData = coreData else {
            fatalError("Fail to access Core Data.")
        }
        
        return coreData.setFavorite(id: id)
        
    }
    
    func addFavorite(_ movieVM: MovieViewModel) {

        coreData?.addFavorite(movieVM.movie)
    }

    func removeFavorite(id: Int) {

        coreData?.removeFavorite(id: id)
    }
    
    func saveChanges() {
        coreData?.saveChanges()
    }
    
    func genreNames(ids: [Int]) -> String {
        if let genreNames = coreData?.getGenreNames(ids: ids) {
            return genreNames
        } else {
            fatalError("Error getting genre names")
        }
    }
    
}
