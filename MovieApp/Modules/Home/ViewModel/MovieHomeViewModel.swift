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
    @Published var topSearchItems: [MultiSearchItem] = []

    private var cancellables = Set<AnyCancellable>()
    private let service = TMDbService()

    func fetchHomeData() {
        Task {
            do {
                async let recommended = try service.fetchPopularMovies()
                async let topSearches = try service.fetchTrendingAll()

                let (recommendedResult, topSearchResult) = try await (recommended, topSearches)

                
                self.recommendedMovies = recommendedResult
                self.topSearchItems = topSearchResult
                
                print("✅ Data fetched - Movies: \(recommendedResult.count), Top searches: \(topSearchResult.count)")
                
            } catch {
                print("❌ Failed to fetch home data: \(error)")
                // Optionally set empty arrays on error
                self.recommendedMovies = []
                self.topSearchItems = []
            }
        }
    }
    
    
}
