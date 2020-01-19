//
//  SecondViewController.swift
//  Django
//
//  Created by Shauni Van de Velde on 26/12/2019.
//  Copyright © 2019 Shauni Van de Velde. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var SearchTableView: UITableView!
    
    var movies = [Movie]()
    var selectedIndex = 0
    var currentSearch: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showMovieDetail"{
            let detailViewController = segue.destination as! MovieDetailViewController
            detailViewController.movie = movies[selectedIndex]

        }
    }
    
}

// MARK: -SearchBar Extension
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        // Cancel the current search task
        currentSearch?.cancel()
        // Update the search task to a new task with the new text
        currentSearch = ApiClient.search(query: searchText) { movies, error in
            self.movies = movies
            DispatchQueue.main.async {
                self.SearchTableView.reloadData()
            }
        }
    }
    
    
    
    // Display cancel button when editing search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    // Stop displaying cancel button
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    // When cancel button is clicked, stop 'editing'
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

// MARK: -TableView Extension

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieItemViewCell")!
        
        let movie = movies[indexPath.row]
        
        // Since we don't display poster images, it is useful to show the year the movie was released in
        cell.textLabel?.text = "\(movie.title) - \(movie.releaseDate.prefix(4))"
        
        cell.textLabel?.textColor = .white

        
        return cell
    }
    
    // Navigate to the detail page when a movie from the list is tapped.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showMovieDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
