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


/*
 struct Movie: Codable {
 let id: Int
 let title: String
 let originalTitle: String?
 let overview: String?
 let poster_path: String?
 let backdropPath: String?
 let releaseDate: String?
 let genreIds: [Int]?
 let adult: Bool?
 let originalLanguage: String?
 let popularity: Double?
 let voteAverage: Double?
 let voteCount: Int?
 let video: Bool?
 
 enum CodingKeys: String, CodingKey {
 case id, title, overview, adult, popularity, video,poster_path
 case originalTitle = "original_title"
 //case posterPath = "poster_path"
 case backdropPath = "backdrop_path"
 case releaseDate = "release_date"
 case genreIds = "genre_ids"
 case originalLanguage = "original_language"
 case voteAverage = "vote_average"
 case voteCount = "vote_count"
 }
 
 var fullPosterURL: String? {
 guard let posterPath = poster_path else { return nil }
 return "https://image.tmdb.org/t/p/w500\(posterPath)"
 }
 
 var fullBackdropURL: String? {
 guard let backdropPath = backdropPath else { return nil }
 return "https://image.tmdb.org/t/p/w780\(backdropPath)"
 }
 }
 
 */
