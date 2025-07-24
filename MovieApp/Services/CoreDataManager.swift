//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 24/07/2025.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MovieApp")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load Core Data stack: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveMovie(id: Int64, title: String, posterURL: String?, overview: String?) {
        let movie = SavedMovie(context: context)
        movie.id = id
        movie.title = title
        movie.posterURL = posterURL
        movie.overview = overview
        saveContext()
    }
    
    func fetchMovie(by id: Int64) -> SavedMovie? {
        let request: NSFetchRequest<SavedMovie> = SavedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        return try? context.fetch(request).first
    }
    
    func fetchAllMovies() -> [SavedMovie] {
        let request: NSFetchRequest<SavedMovie> = SavedMovie.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    func deleteMovie(by id: Int64) {
        if let movie = fetchMovie(by: id) {
            context.delete(movie)
            saveContext()
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                print("Movie saved successfuly")
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
