//
//  FirstViewController.swift
//  Django
//
//  Created by Shauni Van de Velde on 26/12/2019.
//  Copyright © 2019 Shauni Van de Velde. All rights reserved.
//

import UIKit
import SDWebImage

class DiscoverViewController: UIViewController {

    @IBOutlet weak var PopularTableView: UITableView!
    
    
    var movies = [Movie]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ApiClient.getPopular() { movies, error in
            self.movies = movies
            self.PopularTableView.reloadData()

            
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        PopularTableView.reloadData()
    }
    
}
extension DiscoverViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "MovieItemViewCell")!
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
        cell.imageView?.sd_setImage(with: movie.posterURL, placeholderImage: UIImage(named: "placeholder.png"))
        cell.setNeedsLayout()

        return cell
    }
    
    
    
}
    
    
    
        
   




