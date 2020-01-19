//
//  FirstViewController.swift
//  Django
//
//  Created by Shauni Van de Velde on 26/12/2019.
//  Copyright © 2019 Shauni Van de Velde. All rights reserved.
// SOURCE : Filling in UITableView: https://stackoverflow.com/questions/31673607/swift-tableview-in-viewcontroller/31691216
// SOURCE : Spacing between items in table view: https://stackoverflow.com/questions/6216839/how-to-add-spacing-between-uitableviewcell/33931591#33931591


import UIKit
import SDWebImage

class DiscoverViewController: UIViewController {

    @IBOutlet weak var PopularTableView: UITableView!
    
    
    var movies = [Movie]()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Discover"

        // Fetch the current Popular movies from the API
        ApiClient.getPopular() { movies, error in
            self.movies = movies
            self.PopularTableView.reloadData()
        }
        self.PopularTableView.rowHeight = 200
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        PopularTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showMovieDetail"{
            let detailViewController = segue.destination as! MovieDetailViewController
            detailViewController.movie = movies[selectedIndex]

        }
    }
    
}
extension DiscoverViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return movies.count
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
        let movie = movies[indexPath.section]
        
        cell.textLabel?.text = movie.title
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
    
    
    
        
   




