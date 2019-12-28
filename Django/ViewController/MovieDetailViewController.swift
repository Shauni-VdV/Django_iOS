//
//  MovieDetailViewController.swift
//  Django
//
//  Created by Shauni Van de Velde on 28/12/2019.
//  Copyright © 2019 Shauni Van de Velde. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var BackDropImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movie.title
        
        self.BackDropImageView.sd_setImage(with: movie.backdropURL,  placeholderImage: UIImage(named: "PlaceholderPoster"))
        self.TitleLabel.text = movie.title
    }
    
    
}
