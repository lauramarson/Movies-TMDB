//
//  Movies.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 17/03/22.
//

import Foundation

struct Movie: Codable {
    var title: String
    var release_date: String
    var vote_average: Float
    var overview: String
}
