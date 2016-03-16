//
//  SecondViewController.swift
//  cinemur
//
//  Created by Han Ngo on 3/13/16.
//  Copyright © 2016 Dwarves Foundation. All rights reserved.
//

import UIKit
import Kingfisher

class TopRatedViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var page: Int = 1
    var movies: [Movie] = []
    var filteredData: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init UISearchBar
        let searchBar: UISearchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar;
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let options = ["page": page]
        Store.getTopRatedMovies(options) { (items, error) -> Void in
            self.movies = items as! [Movie]
            self.filteredData = self.movies
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TopRatedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("me.tieubao.cinemur.MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = self.filteredData[indexPath.row]
        
        let backdropURL = "https://image.tmdb.org/t/p/original" + movie.backdrop!
        cell.backdropView.kf_showIndicatorWhenLoading = true
        cell.backdropView.kf_setImageWithURL(NSURL(string: backdropURL)!)
        
        let posterURL = "https://image.tmdb.org/t/p/w342" + movie.poster!
        cell.posterView.bringSubviewToFront(cell.backdropView)
        cell.posterView.kf_showIndicatorWhenLoading = true
        cell.posterView.kf_setImageWithURL(
            NSURL(string: posterURL)!,
            placeholderImage: nil,
            optionsInfo: [.Transition(ImageTransition.Fade(1))])
        
        cell.titleLabel.text = movie.title
        cell.runtimeLabel.text = movie.date
        cell.overviewLabel.text = movie.overview
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
}

extension TopRatedViewController: UISearchBarDelegate {
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredData = movies
        } else {
            
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = movies.filter({(movie: Movie) -> Bool in
                
                // If movie item matches the searchText, return true to include it
                if movie.title!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        
        tableView.reloadData()
    }
}