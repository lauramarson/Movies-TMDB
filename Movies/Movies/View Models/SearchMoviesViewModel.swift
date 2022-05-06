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
    
//    func imageFor(_ movie: Movie, completion: @escaping (Data) -> ()) {
//        let posterPath = movie.poster_path
//        
//        WebServices().fetchImage(posterPath: posterPath) { (data) in
//            completion(data)
//        }
//    }
    
}

class MovieViewModel {
    let movie: Movie
    
    init(_ movie: Movie) {
        self.movie = movie
    }
    
    var id: Int {
        return movie.id
    }
    
    var title: String {
        return movie.title
    }
    
    var releaseYear: String {
        return String(movie.release_date.prefix(4))
    }
    
    var overview: String {
        return movie.overview
    }
    
    var voteAverage: Float {
        movie.vote_average
    }
    
    var posterPath: String {
        return movie.poster_path
    }
    
    var imageURL: URL {
        let posterPath = movie.poster_path
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else {
            fatalError("URL error")
        }
        return imageURL
    }
    
    var imageData: Data?
}

extension MovieViewModel {
    
    func getPoster(posterPath: String, completion: @escaping (Data) -> ()) {
        WebServices().fetchImage(posterPath: posterPath) { [weak self] (data) in
            self?.imageData = data
            completion(data)
        }
    }
}

