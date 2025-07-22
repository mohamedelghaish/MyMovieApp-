//
//  MultiSearchItem.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 22/07/2025.
//

import Foundation
struct MultiSearchItem: Codable, Identifiable {
    let id: Int
    //let mediaType: String
    let popularity: Double?
    
    // Movie specific properties
    let title: String?
    let originalTitle: String?
    let releaseDate: String?
    
    // TV Show specific properties
    let name: String?
    let originalName: String?
    let firstAirDate: String?
    
    // Person specific properties
    let knownForDepartment: String?
    let profilePath: String?
    let knownFor: [KnownForItem]?
    
    // Common properties
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let genreIds: [Int]?
    let adult: Bool?
    let originalLanguage: String?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, popularity, title, name, overview, adult
        //case mediaType = "media_type"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
        case knownFor = "known_for"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    // Computed property to get display title
    var displayTitle: String {
        return title ?? name ?? "Unknown"
    }
    
    // Computed property for image URL
    var fullImageURL: String? {
        let imagePath = posterPath ?? profilePath
        guard let imagePath = imagePath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(imagePath)"
    }
}

// MARK: - Known For Item (for person search results)
struct KnownForItem: Codable, Identifiable {
    let id: Int
    //let mediaType: String
    let title: String?
    let name: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let firstAirDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, name, overview
        //case mediaType = "media_type"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
    }
}
