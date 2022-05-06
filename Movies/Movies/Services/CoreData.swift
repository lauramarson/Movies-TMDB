//
//  CoreData.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 06/05/22.
//

import Foundation
import CoreData
import UIKit

class CoreData {
    
    var managedContext: NSManagedObjectContext? {
        (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer
            .viewContext
    }
    
}
    
extension CoreData {
    
    func setFavorite(id: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let count = try managedContext?.count(for: fetchRequest)
            self.favorite = (count == 1)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addFavorite(_ movie: MovieViewModel) {
        guard let managedContext = managedContext else { return }

        let entity = NSEntityDescription.entity(forEntityName: "FavoriteMovies", in: managedContext)!

        let movieData = NSManagedObject(entity: entity, insertInto: managedContext)

        movieData.setValue(movie.id, forKeyPath: "id")
        movieData.setValue(movie.title, forKeyPath: "title")
        movieData.setValue(movie.overview, forKeyPath: "overview")
        movieData.setValue(movie.releaseYear, forKeyPath: "release_date")
        movieData.setValue(movie.voteAverage, forKeyPath: "vote_average")
        movieData.setValue(movie.genres, forKeyPath: "genres")
        movieData.setValue(movie.imageData, forKeyPath: "poster_image")
    }
    
    func removeFavorite(id: Int) {
        guard let managedContext = managedContext else { return }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do { //******
            let object = try managedContext.fetch(fetchRequest)
            managedContext.delete(object[0])
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
    
extension CoreData {
    
    @objc func saveChanges() {
        guard let managedContext = managedContext else { return }
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
}

extension CoreData {
    
    func getGenreNames() {
        guard let movie = movie, let managedContext = managedContext else { return }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieGenres")

        let genreNames: [String] = movie.genre_ids.compactMap { genreID in
            fetchRequest.predicate = NSPredicate(format: "id == %d", genreID)
            return try?
                managedContext.fetch(fetchRequest)
                .first?
                .value(forKey: "name") as? String
        }

        self.movie?.genre_names = genreNames.joined(separator: ", ")
    }
    
}
