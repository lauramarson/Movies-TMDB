//
//  FavoriteButton.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 23/03/22.
//

import UIKit

protocol ActionDelegateProtocol: AnyObject {
    func buttonTapped()
}

class FavoriteButton: UIButton {
    weak var delegate: ActionDelegateProtocol?
    
    var favorite = false {
        didSet {
            if favorite {
                setTitle("Remove from Favorites", for: .normal)
            } else {
                setTitle("Add to Favorites", for: .normal)
            }
        }
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        self.delegate?.buttonTapped()
    }
    

    
}
