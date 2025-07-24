//
//  MovieHomeViewModel.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 22/07/2025.
//

import Foundation
import Combine

final class MovieHomeViewModel: ObservableObject {
    
    @Published var recommendedMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var topSearchItems: [MultiSearchItem] = []

    private var cancellables = Set<AnyCancellable>()
    private let service = TMDbService()

    func fetchHomeData() {
        Task {
            do {
                async let recommended = try service.fetchRecomendedMovies()
                async let popular = try service.fetchPopularMovies()
                async let topSearches = try service.fetchTrendingAll()

                let (recommendedResult, popularResult, topSearchResult) = try await (recommended, popular, topSearches)

                
                self.recommendedMovies = recommendedResult
                self.popularMovies = popularResult
                self.topSearchItems = topSearchResult
                
               
                
            } catch {
                print(" Failed to fetch home data: \(error)")
               
                self.recommendedMovies = []
                self.topSearchItems = []
            }
        }
    }
    
    
}
