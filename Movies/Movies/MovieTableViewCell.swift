//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 30/03/22.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var releaseYear: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override func prepareForReuse() {
//        posterImage.image = UIImage(named: "imagePlaceholder")
//    }

    func fetchImage(posterPath: String) {
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        let placeholderImage = UIImage(named: "imagePlaceholder")
        
        posterImage.sd_setImage(with: imageURL, placeholderImage: placeholderImage)
    }
    
}
