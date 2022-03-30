//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 30/03/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var releaseYear: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
