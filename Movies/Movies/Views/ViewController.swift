//
//  ViewController.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 16/03/22.
//

import Alamofire
import CoreData
import UIKit

class ViewController: UITableViewController {
    lazy var searchBar: UISearchBar = UISearchBar()
    var searchMoviesVM = SearchMoviesViewModel()
    
    var genres = [Genre]() {
        didSet {
            saveGenres()
        }
    }
    
    var searchText = ""
    var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "Movie")
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search for a movie..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
//        guard isFirstLaunch else { return }
//        fetchGenres()
//
//        print(genres)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMoviesVM.numberOfRows(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Movie", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movieModel = searchMoviesVM.modelAt(indexPath.row)
        cell.movieVM = MovieViewModel(movieModel)
        
        cell.configure()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }

        let movieModel = searchMoviesVM.modelAt(indexPath.row)
        dvc.movieVM = MovieViewModel(movieModel)

        navigationController?.pushViewController(dvc, animated: true)
    }
    
    func saveGenres() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "MovieGenres", in: managedContext)!

        for genre in genres { //TODO: for each
            let genreData = NSManagedObject(entity: entity, insertInto: managedContext)

            genreData.setValue(genre.id, forKeyPath: "id")
            genreData.setValue(genre.name, forKeyPath: "name")
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        searchMoviesVM.searchForMovies(searchText: searchText) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        if searchBar.text == "" {
            searchMoviesVM.eraseMovies()
            tableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearchbar(searchBar)
    }
    
    func resetSearchbar(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchMoviesVM.eraseMovies()
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }

}

extension ViewController {
//    func fetchMovies() {
//        searchText.removeAll(where: {$0.isSymbol || $0.isPunctuation})
//        let words = searchText.replacingOccurrences(of: " ", with: "+")
//
//        AF.request("https://api.themoviedb.org/3/search/movie?api_key=\(PrivateKey.key)&query=\(words)")
//            .validate()
//            .responseDecodable(of: Movies.self) { [weak self] (response) in
//                guard let films = response.value else { return }
//                self?.movies = films.results
//                self?.tableView.reloadData()
//            }
//    }

    
    func fetchGenres() {
        AF.request("https://api.themoviedb.org/3/genre/movie/list?api_key=\(PrivateKey.key)&language=en-US")
            .validate()
            .responseDecodable(of: Genres.self) { [weak self] (response) in
                guard let genres = response.value else { return }
                self?.genres = genres.genres
                self?.saveGenres()
            }
    }
}


extension ViewController {
    var isFirstLaunch: Bool {
        let defaults = UserDefaults.standard
        
        guard defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return true
        }
        
        return false
        
        
//        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
//            print("App already launched")
//            return false
//        } else {
//            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
//            print("App launched first time")
//            return true
//        }
    }
}

