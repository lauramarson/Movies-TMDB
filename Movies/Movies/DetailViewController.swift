//
//  DetailViewController.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 18/03/22.
//

import Alamofire
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var overview: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else { return }
        
        movieTitle.text = movie.title
        overview.text = movie.overview
        fetchImage()
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        
    }
    
    func fetchImage() {
        AF.request("https://image.tmdb.org/t/p/w500\(movie!.poster_path)",method: .get).response { response in
            switch response.result {
                case .success(let responseData):
                    self.moviePoster.image = UIImage(data: responseData!, scale:1)

                case .failure(let error):
                    print("error--->",error)
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
