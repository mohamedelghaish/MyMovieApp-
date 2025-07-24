//
//  NetworkService.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 22/07/2025.
//

import Foundation


final class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func request<T: Decodable>(_ url: URL, responseType: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}


final class TMDbService: ObservableObject {
    private let apiKey = "3c262cc0ba355dd375282293b63884a5"
    private let baseURL = "https://api.themoviedb.org/3"
    private let network = NetworkService.shared

    func fetchTrendingMovies() async throws -> [Movie] {
        let url = URL(string: "\(baseURL)/trending/movie/day?api_key=\(apiKey)")!
        let response = try await network.request(url, responseType: TMDbResponse<Movie>.self)
        return response.results
    }

    func fetchPopularMovies() async throws -> [Movie] {
        let url = URL(string: "\(baseURL)/movie/popular?api_key=\(apiKey)")!
        let response = try await network.request(url, responseType: TMDbResponse<Movie>.self)
        print("resultttttt\(response)")
        return Array(response.results.prefix(3))
    }
    
    func fetchRecomendedMovies() async throws -> [Movie] {
        let url = URL(string: "\(baseURL)/movie/550/recommendations?api_key=\(apiKey)")!
        let response = try await network.request(url, responseType: TMDbResponse<Movie>.self)
        print("resultttttt\(response)")
        return response.results
    }

    func fetchTrendingAll() async throws -> [MultiSearchItem] {
        let url = URL(string: "\(baseURL)/trending/all/day?api_key=\(apiKey)")!
        let response = try await network.request(url, responseType: TMDbResponse<MultiSearchItem>.self)
        return Array(response.results.prefix(4))    }

    func fetchMovieDetails(movieId: Int) async throws -> MovieDetails {
        let url = URL(string: "\(baseURL)/movie/\(movieId)?api_key=\(apiKey)")!
        return try await network.request(url, responseType: MovieDetails.self)
    }
}


// MARK: - Generic Response Wrapper
struct TMDbResponse<T: Codable>: Codable {
    let page: Int?
    let results: [T]
    let totalPages: Int?
    let totalResults: Int?
}

// MARK: - Movie Details Model
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
