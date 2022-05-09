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
                self.setTitle(" Remove from Favorites ", for: .normal)
            } else {
                self.setTitle(" Add to Favorites ", for: .normal)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction() {
        delegate?.buttonTapped()
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.transform = .identity
        })
    }
}
