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
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    var movie: Movie!
    var isFavorite: Bool {
        return MovieRepository.favorites.contains(movie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movie.title
        
        // Set the image that will be displayed, this is the backdrop (not the poster!)
        self.BackDropImageView.sd_setImage(with: movie.backdropURL,  placeholderImage: UIImage(named: "PlaceholderBackdrop"))
        
        // Set the title of the movie
        self.TitleLabel.text = movie.title + " (" + movie.releaseDate.prefix(4) + ")"
        
        // Set the movie description
        self.DescriptionLabel.text = movie.overview
        
        // Calculate the rating, the RatingView goes up to 5 stars, and the rating in the API is a score out of 10, so divide by 2.
        self.RatingView.rating = (movie.voteAverage / 2)
        
        // Heart button for favorite
        if isFavorite{
            FavoriteButton.setImage(UIImage(named: "heart-filled"), for: .normal)
        } else {
            FavoriteButton.setImage(UIImage(named: "heart-empty"), for: .normal)
        }
    }
    
    // When the Heart button gets tapped, attempt to add the movie to favorites
    @IBAction func FavoriteButtonTapped(_ sender: UIButton) {
        ApiClient.addToFavorites(movieId: movie.id, favorite: !isFavorite, completion: handleFavorite(success:error:))
    }
    
    // Handle method for adding/removing from favorites.
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




