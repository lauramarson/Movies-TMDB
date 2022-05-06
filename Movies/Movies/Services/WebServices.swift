//
//  WebServices.swift
//  Movies
//
//  Created by Laura Pinheiro Marson on 03/05/22.
//

import Foundation
import Alamofire
import SDWebImage

class WebServices {
    
    func fetchMovies(searchText: String, completion: @escaping ([Movie]) -> ()) {
        var searchText = searchText
        searchText.removeAll(where: {$0.isSymbol || $0.isPunctuation})
        let words = searchText.replacingOccurrences(of: " ", with: "+")
        
        AF.request("https://api.themoviedb.org/3/search/movie?api_key=\(PrivateKey.key)&query=\(words)")
            .validate()
            .responseDecodable(of: Movies.self) { (response) in
                guard let films = response.value else { return }
                completion(films.results)
            }
    }
    
}

extension WebServices {
    
    func fetchImage(posterPath: String, completion: @escaping (Data) -> ()) {
        AF.request("https://image.tmdb.org/t/p/w500\(posterPath)",method: .get).response { response in
            switch response.result {
                case .success(let responseData):
                    let imageData = responseData ?? Data()
                    completion(imageData)
                
                case .failure(let error):
                    print("ERROR:",error)
            }
        }
    }
    
//    func fetchImage(posterPath: String, imageView: UIImageView) {
//        //completion: @escaping (Data) -> ()
//        let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
//        let placeholderImage = UIImage(named: "imagePlaceholder")
//
//        imageView.sd_setImage(with: imageURL, placeholderImage: placeholderImage)
        
//        SDWebImageManager.shared.loadImage(
//            with: imageURL,
//            options: [.highPriority, .progressiveLoad],
//            progress: { (receivedSize, expectedSize, url) in
//                //Progress tracking code
//            },
//            completed: { (image, data, error, cacheType, finished, url) in
//                guard error == nil else { return }
//                if let data = data {
//                    completion(data)
//                }
//            }
//        )
        
//    }
}
