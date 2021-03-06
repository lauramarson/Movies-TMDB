//
//  DetailMovieViewModel.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 06/05/22.
//

import Foundation

class DetailMovieViewModel {
    var coreData: CoreData
    var movie: Movie
    
    init(movie: Movie, coreData: CoreData = CoreData()) {
        self.coreData = coreData
        self.movie = movie
    }
    
    func setFavorite() -> Bool {
        coreData.setFavorite(id: movie.id)
    }
    
    func addFavorite() {

        coreData.addFavorite(movie)
    }

    func removeFavorite() {

        coreData.removeFavorite(id: movie.id)
    }
    
    func saveChanges() {
        coreData.saveChanges()
    }
    
    func genreNames() {
        self.movie.genre_names = coreData.getGenreNames(ids: movie.genre_ids)
    }
    
}

extension DetailMovieViewModel {
    
    func getPoster(completion: @escaping () -> ()) {
        WebServices().fetchImage(posterPath: movie.poster_path) { [weak self] (data) in
            self?.movie.image_data = data
            completion()
        }
    }
    
}
