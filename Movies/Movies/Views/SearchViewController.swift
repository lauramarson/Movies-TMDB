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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "Movie")
        
        setupSearchBar()

        if searchMoviesVM.isFirstLaunch {
            searchMoviesVM.fetchGenres()
        }
    }
    
    func setupSearchBar() {
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
        return searchMoviesVM.numberOfRows(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Movie", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movieModel = searchMoviesVM.modelAt(indexPath.row)
        cell.movieCellVM = MovieCellViewModel(movieModel)
        
        cell.configure()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }

        let movieModel = searchMoviesVM.modelAt(indexPath.row)
        dvc.detailVM = DetailMovieViewModel(movie: movieModel)

        navigationController?.pushViewController(dvc, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
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
