//
//  ViewController.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 16/03/22.
//

import Alamofire
import UIKit

class ViewController: UITableViewController {
    lazy var searchBar: UISearchBar = UISearchBar()
    var movies = [Movie]()
    
    var searchText = ""
    var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search for a movie..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Movie", for: indexPath)
        let movie = movies[indexPath.row]
        
        cell.textLabel?.text = movie.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }

        dvc.movie = movies[indexPath.row]
        
        navigationController?.pushViewController(dvc, animated: true)
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        fetchMovies()
        
        tableView.reloadData()
        
        if searchBar.text == "" {
            movies.removeAll(keepingCapacity: true)
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
        movies.removeAll(keepingCapacity: true)
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }

}

extension ViewController {
  func fetchMovies() {
    searchText.removeAll(where: {$0.isSymbol || $0.isPunctuation})
    let words = searchText.replacingOccurrences(of: " ", with: "+")
    
    AF.request("https://api.themoviedb.org/3/search/movie?api_key=\(PrivateKey.key)&query=\(words)")
      .validate()
      .responseDecodable(of: Movies.self) { (response) in
        guard let films = response.value else { return }
        self.movies = films.results
        self.tableView.reloadData()
      }
  }
}

