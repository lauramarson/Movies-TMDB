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
    
    
    var favorite: Bool? {
        didSet {
            guard let favorite = favorite else { return }
            if favorite {
                self.setTitle("Remove from Favorites", for: .normal)
            } else {
                self.setTitle("Add to Favorites", for: .normal)
            }
//            self.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction() {
        delegate?.buttonTapped()
    }
}
