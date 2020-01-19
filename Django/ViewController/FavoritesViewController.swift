//
//  FavoritesViewController.swift
//  Django
//
//  Created by Shauni Van de Velde on 29/12/2019.
//  Copyright © 2019 Shauni Van de Velde. All rights reserved.
//

import UIKit

class FavoritesViewController : UIViewController {
    
    @IBOutlet weak var FavoritesTableView: UITableView!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favorites"
        
        // Do any additional setup after loading the view.
        ApiClient.getFavorites() { movies, error in
            MovieRepository.favorites = movies
           print(movies)
            self.FavoritesTableView.reloadData()
        }
        self.FavoritesTableView.rowHeight = 200
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        FavoritesTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showMovieDetail"{
            let detailViewController = segue.destination as! MovieDetailViewController
            detailViewController.movie = MovieRepository.favorites[selectedIndex]
            
        }
    }
    
}

extension FavoritesViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return MovieRepository.favorites.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieItemViewCell")!
        let movie = MovieRepository.favorites[indexPath.section]
        
        cell.textLabel?.text = movie.title
        cell.textLabel?.textColor = .white
        cell.imageView?.image = UIImage(named: "PlaceholderPoster")
        cell.imageView?.sd_setImage(with: movie.posterURL, placeholderImage: UIImage(named: "PlaceholderPoster"))
        cell.imageView?.frame = cell.frame.offsetBy(dx: 10, dy: 10);
        
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedIndex = indexPath.section
        performSegue(withIdentifier: "showMovieDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
