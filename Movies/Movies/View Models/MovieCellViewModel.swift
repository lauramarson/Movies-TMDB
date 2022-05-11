//
//  MovieCellViewModel.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 10/05/22.
//

import Foundation

class MovieCellViewModel {
    var movie: Movie
    
    init(_ movie: Movie) {
        self.movie = movie
    }
    
    var title: String {
        return movie.title
    }
    
    var releaseYear: String {
        return movie.releaseYear
    }
    
    var imageURL: URL {
        return movie.imageURL
    }
}
