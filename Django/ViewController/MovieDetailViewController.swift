//
//  MovieDetailViewController.swift
//  Django
//
//  Created by Shauni Van de Velde on 28/12/2019.
//  Copyright © 2019 Shauni Van de Velde. All rights reserved.
//

import UIKit
import Cosmos

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var BackDropImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var RatingView: CosmosView!
    @IBOutlet weak var FavoriteButton: UIButton!
    
    var movie: Movie!
    var isFavorite: Bool {
        return MovieRepository.favorites.contains(movie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movie.title
        
        self.BackDropImageView.sd_setImage(with: movie.backdropURL,  placeholderImage: UIImage(named: "PlaceholderBackdrop"))
        
        self.TitleLabel.text = movie.title + " (" + movie.releaseDate.prefix(4) + ")"
        self.RatingView.rating = (movie.voteAverage / 2)
        if isFavorite{
            FavoriteButton.setImage(UIImage(named: "heart-filled"), for: .normal)
        } else {
            FavoriteButton.setImage(UIImage(named: "heart-empty"), for: .normal)
        }
    }
    
    @IBAction func FavoriteButtonTapped(_ sender: UIButton) {
        ApiClient.addToFavorites(movieId: movie.id, favorite: !isFavorite, completion: handleFavorite(success:error:))
    }
    
    func handleFavorite(success: Bool, error: Error?) {
        if success{
            if isFavorite{
                MovieRepository.favorites = MovieRepository.favorites.filter() { $0 != movie}
                FavoriteButton.setImage(UIImage(named: "heart-empty"), for: .normal)

            } else {
                MovieRepository.favorites.append(movie)
                FavoriteButton.setImage(UIImage(named: "heart-filled"), for: .normal)
            }
            
        }
    }
}




