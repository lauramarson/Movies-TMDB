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
    
    var movieCellVM: MovieCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure() {
        guard let movieCellVM = movieCellVM else { return }
        
        self.movieTitle.text = movieCellVM.title
        
        self.releaseYear.text = movieCellVM.releaseYear
        
        let imageURL = movieCellVM.imageURL
        let placeholderImage = UIImage(named: "imagePlaceholder")

        posterImage.sd_setImage(with: imageURL, placeholderImage: placeholderImage)
    }
    
}
