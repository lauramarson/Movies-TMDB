//
//  DetailViewController.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 18/03/22.
//

import Alamofire
import UIKit

protocol DataDelegateProtocol: AnyObject {
    func addFavorite(movie: Movie, poster: UIImage)
    func delFavorite(_ movie: Movie)
}

class DetailViewController: UIViewController {
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var overview: UILabel!
    
    weak var delegate: DataDelegateProtocol?
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else { return }
        
        movieTitle.text = movie.title
        overview.text = movie.overview
        fetchImage()
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        guard let movie = movie else { return }
        delegate?.addFavorite(movie: movie, poster: moviePoster.image ?? UIImage())
    }
    
    func fetchImage() {
        guard let movie = movie else { return }
        AF.request("https://image.tmdb.org/t/p/w500\(movie.poster_path)",method: .get).response { response in
            switch response.result {
                case .success(let responseData):
                    self.moviePoster.image = UIImage(data: responseData ?? Data(), scale:1)

                case .failure(let error):
                    print("ERROR:",error)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
