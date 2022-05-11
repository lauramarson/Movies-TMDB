//
//  Movies.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 17/03/22.
//

import UIKit

struct Movie: Codable { //TODO codingkey
    var id: Int
    var title: String
    var release_date: String
    var genre_ids: [Int]
    var vote_average: Float
    var overview: String
    var poster_path: String
    var genre_names: String?
    var image_data: Data?
}

extension Movie {
    
    var releaseYear: String { String(self.release_date.prefix(4)) }
    
    var imageURL: URL {
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster_path)") else {
            return URL(fileURLWithPath: "")
        }
        return imageURL
    }
}
