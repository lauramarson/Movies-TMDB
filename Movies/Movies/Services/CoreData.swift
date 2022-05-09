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
    
    var managedContext: NSManagedObjectContext?
    
    init() {
        managedContext = (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer
            .viewContext
    }
    
}

extension CoreData {
    
    func getFavoriteMovies(completion: @escaping ([Movie]) -> ()) {
        
        guard let managedContext = managedContext else { return }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
          
        do {
            let favorites = try managedContext.fetch(fetchRequest)
            let convertedMovies = favorites.map() { movie in
                convertMovie(movie: movie)
            }
            completion(convertedMovies)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func convertMovie(movie: NSManagedObject) -> Movie { //TODO
        let id = movie.value(forKey: "id") as! Int
        let title = movie.value(forKey: "title") as! String
        let overview = movie.value(forKey: "overview") as! String
        let release_date = movie.value(forKey: "release_date") as! String
        let vote_average = movie.value(forKey: "vote_average") as! Float
        let genre_names = movie.value(forKey: "genres") as! String
        let image_data = movie.value(forKey: "poster_image") as! Data
        
        let convertedMovie = Movie(id: id, title: title, release_date: release_date, genre_ids: [], vote_average: vote_average, overview: overview, poster_path: "", genre_names: genre_names, image_data: image_data)
        return convertedMovie
    }
    
}
    
extension CoreData {
    
    func setFavorite(id: Int) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let count = try managedContext?.count(for: fetchRequest)
            return (count == 1)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func addFavorite(_ movie: Movie) {
        
        guard let managedContext = managedContext else { return }

        let entity = NSEntityDescription.entity(forEntityName: "FavoriteMovies", in: managedContext)!

        let movieData = NSManagedObject(entity: entity, insertInto: managedContext)

        movieData.setValue(movie.id, forKeyPath: "id")
        movieData.setValue(movie.title, forKeyPath: "title")
        movieData.setValue(movie.overview, forKeyPath: "overview")
        movieData.setValue(movie.releaseYear, forKeyPath: "release_date")
        movieData.setValue(movie.vote_average, forKeyPath: "vote_average")
        movieData.setValue(movie.genre_names, forKeyPath: "genres")
        movieData.setValue(movie.image_data, forKeyPath: "poster_image")
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
    
    func saveChanges() {
        guard let managedContext = managedContext else { return }
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
}

extension CoreData {
    
    func getGenreNames(ids: [Int]) -> String {
        guard let managedContext = managedContext else {
            fatalError("Couldn't get managed context")
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieGenres")

        let genreNames: [String] = ids.compactMap { genreID in
            fetchRequest.predicate = NSPredicate(format: "id == %d", genreID)
            return try?
                managedContext.fetch(fetchRequest)
                .first?
                .value(forKey: "name") as? String
        }

        return genreNames.joined(separator: ", ")
    }
    
}
