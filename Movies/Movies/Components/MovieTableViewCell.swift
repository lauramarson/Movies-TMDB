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
    
    var movieVM: MovieViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure() {
        guard let movieVM = movieVM else { return }
        
        self.movieTitle.text = movieVM.title
        
        self.releaseYear.text = movieVM.releaseYear
        
        let imageURL = movieVM.imageURL
        let placeholderImage = UIImage(named: "imagePlaceholder")

        posterImage.sd_setImage(with: imageURL, placeholderImage: placeholderImage)
    }
    
}
