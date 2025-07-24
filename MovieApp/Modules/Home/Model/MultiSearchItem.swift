//
//  MultiSearchItem.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 22/07/2025.
//

import Foundation
struct MultiSearchItem: Codable, Identifiable {
    let id: Int
    let popularity: Double?

   
    let title: String?
    let originalTitle: String?
    let releaseDate: String?

   
    let name: String?
    let originalName: String?
    let firstAirDate: String?

    
    let knownForDepartment: String?
    let profilePath: String?
    let knownFor: [KnownForItem]?

    
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let genreIds: [Int]?
    let adult: Bool?
    let originalLanguage: String?
    let voteAverage: Double?
    let voteCount: Int?

    
    var displayTitle: String {
        return title ?? name ?? "Unknown Title"
    }

    
    var fullImageURL: String? {
        let imagePath = posterPath ?? profilePath
        guard let imagePath = imagePath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(imagePath)"
    }
}

// MARK: - Known For Item

struct KnownForItem: Codable, Identifiable {
    let id: Int
    let title: String?
    let name: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let firstAirDate: String?
}

