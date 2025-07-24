//
//  Movie.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 22/07/2025.
//

import Foundation
struct Movie: Codable {
    let id: Int
    let title: String
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let genreIds: [Int]?
    let adult: Bool?
    let originalLanguage: String?
    let popularity: Double?
    let voteAverage: Double?
    let voteCount: Int?
    let video: Bool?
    
    var fullPosterURL: String? {
        guard let posterPath = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
    
    var fullBackdropURL: String? {
        guard let backdropPath = backdropPath else { return nil }
        return "https://image.tmdb.org/t/p/w780\(backdropPath)"
    }
    
}


