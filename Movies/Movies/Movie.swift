//
//  Movies.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 17/03/22.
//

import UIKit

struct Movie: Codable {
    var id: Int
    var title: String
    var release_date: String
    var genre_ids: [Int]
    var vote_average: Float
    var overview: String
    var poster_path: String
}

struct Poster: Codable {
    var poster_path: String
    let image: Data
    
//    init(image: UIImage) {
//        self.image = image.jpegData(compressionQuality: 0.8) ?? Data()
//    }
}
