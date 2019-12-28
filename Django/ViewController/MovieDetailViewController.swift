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
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movie.title
        
        self.BackDropImageView.sd_setImage(with: movie.backdropURL,  placeholderImage: UIImage(named: "PlaceholderBackdrop"))
        
        self.TitleLabel.text = movie.title + " (" + movie.releaseDate.prefix(4) + ")"
        self.RatingView.rating = (movie.voteAverage / 2)
        print(movie.voteAverage)
        
    }
    
    
}
