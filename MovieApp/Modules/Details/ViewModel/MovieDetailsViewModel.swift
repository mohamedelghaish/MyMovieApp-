//
//  MovieHomeViewModel.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 22/07/2025.
//

import Foundation
import Combine

final class MovieDetailsViewModel: ObservableObject {
    
    @Published var movieDetails: MovieDetails?

    private var cancellables = Set<AnyCancellable>()
    private let service = TMDbService()

    func fetchMovieDetails(by id: Int) {
        Task {
            do {
                async let movieDetails = try service.fetchMovieDetails(movieId: id)
                
                let movieDetailsResult = try await movieDetails

                
                self.movieDetails = movieDetailsResult
                
                print("✅ Data fetched - MovieDetails: \(movieDetailsResult.id)")
                
            } catch {
                print("❌ Failed to fetch home data: \(error)")
            }
        }
    }
    
    
}
