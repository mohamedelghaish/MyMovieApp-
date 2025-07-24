//
//  FavoriteViewModel.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 24/07/2025.
//

import Foundation
import Combine

class FavoriteViewModel {
    
    
    @Published private(set) var savedMovies: [SavedMovie] = []

    private var cancellables = Set<AnyCancellable>()

    func fetchSavedMovies() {
      
        DispatchQueue.global().async {
            let movies = CoreDataManager.shared.fetchAllMovies()
            DispatchQueue.main.async {
                self.savedMovies = movies
            }
        }
    }

    func deleteMovie(at index: Int) {
        let movie = savedMovies[index]
        CoreDataManager.shared.deleteMovie(by: movie.id)
        fetchSavedMovies()
    }
}
