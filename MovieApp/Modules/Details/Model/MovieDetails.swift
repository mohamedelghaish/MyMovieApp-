//
//  MovieDetails.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 24/07/2025.
//

import Foundation
struct MovieDetails: Codable, Identifiable {
    let id: Int
    let title: String
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let runtime: Int?
    let genres: [Genre]?
    let adult: Bool?
    let originalLanguage: String?
    let popularity: Double?
    let voteAverage: Double?
    let voteCount: Int?
    let budget: Int?
    let revenue: Int?
    let status: String?
    let tagline: String?
    let homepage: String?
    let imdbId: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let spokenLanguages: [SpokenLanguage]?

    var fullPosterURL: String? {
        guard let posterPath = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }

    var fullBackdropURL: String? {
        guard let backdropPath = backdropPath else { return nil }
        return "https://image.tmdb.org/t/p/original\(backdropPath)"
    }

    var formattedRuntime: String? {
        guard let runtime = runtime else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }
}

// MARK: - Genre Model
struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

// MARK: - Production Company Model
struct ProductionCompany: Codable, Identifiable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String?
}

// MARK: - Production Country Model
struct ProductionCountry: Codable {
    let iso31661: String
    let name: String
}

// MARK: - Spoken Language Model
struct SpokenLanguage: Codable {
    let englishName: String
    let iso6391: String
    let name: String
}
