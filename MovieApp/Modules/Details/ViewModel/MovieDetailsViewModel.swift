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
                

                
            } catch {
                print(" Failed to fetch home data: \(error)")
            }

        }

    }
    
    func saveCurrentMovie() {
        guard let movie = movieDetails else { return }
        CoreDataManager.shared.saveMovie(
            id: Int64(movie.id),
            title: movie.title,
            posterURL: movie.fullPosterURL,
            overview: movie.overview
        )
    }
    
    func deleteMovieFromCoreData(by id: Int) {
        CoreDataManager.shared.deleteMovie(by: Int64(id))
    }
    
    func isMovieSavedInCoreData(movieId: Int) -> Bool {
        return CoreDataManager.shared.fetchMovie(by: Int64(movieId)) != nil
    }
    
}
