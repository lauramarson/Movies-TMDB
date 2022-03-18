//
//  Movies.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 17/03/22.
//

import Foundation

struct Movie: Codable {
    var id: Int
    var title: String
    var release_date: String
    var genre_ids: [Int]
    var vote_average: Float
    var overview: String
    var poster_path: String
}
