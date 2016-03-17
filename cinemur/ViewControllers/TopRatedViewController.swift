//
//  FirstViewController.swift
//  cinemur
//
//  Created by Han Ngo on 3/13/16.
//  Copyright © 2016 Dwarves Foundation. All rights reserved.
//

import UIKit
import Kingfisher
import ReachabilitySwift

class TopRatedViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var page: Int = 1
    var movies: [Movie] = []
    var filteredData: [Movie] = []
    
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    var reachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init UISearchBar
        let searchBar: UISearchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .Prominent
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar;
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Setup Reachability
        
        // Get first page of data
        let options = ["page": page]
        Store.getTopRatedMovies(options) { (items, error) -> Void in
            
            guard error == nil else {
                self.view.makeToast("Something went wrong with the connection.\nPlease try again")
                return
            }
            
            self.movies = items as! [Movie]
            self.filteredData = self.movies
            self.tableView.reloadData()
        }
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Setup Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        // Add place for loading more view
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        let options = ["page": 1]
        Store.getTopRatedMovies(options) { (items, error) -> Void in
            
            guard error == nil else {
                refreshControl.endRefreshing()
                self.view.makeToast("Something went wrong with the connection.\nPlease try again")
                return
            }
            
            self.movies = items as! [Movie]
            self.filteredData = self.movies
            
            // TODO: Maybe we need to merge the old data and new data before we call reloadData()
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MovieDetailsSegue" {
            let i = self.tableView.indexPathForSelectedRow
            let vc = segue.destinationViewController as! MovieDetailsViewController
            vc.movie = filteredData[(i?.row)!]
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
        
        if movie.backdrop != nil {
            let backdropURL = "https://image.tmdb.org/t/p/original" + movie.backdrop!
            cell.backdropView.kf_showIndicatorWhenLoading = true
            cell.backdropView.kf_setImageWithURL(NSURL(string: backdropURL)!,
                placeholderImage: nil,
                optionsInfo: [.Transition(ImageTransition.Fade(1))])
        }
        
        if movie.poster != nil {
            let posterURL = "https://image.tmdb.org/t/p/w342" + movie.poster!
            cell.posterView.bringSubviewToFront(cell.backdropView)
            cell.posterView.kf_showIndicatorWhenLoading = true
            cell.posterView.kf_setImageWithURL(
                NSURL(string: posterURL)!,
                placeholderImage: nil,
                optionsInfo: [.Transition(ImageTransition.Fade(1))])
            
        }
        
        cell.titleLabel.text = movie.title
        cell.runtimeLabel.text = movie.date
        cell.overviewLabel.text = movie.overview
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
}

extension TopRatedViewController: UIScrollViewDelegate {
    
    func loadMoreData() {
        
        guard ReachabilityHelper.isConnectedToNetwork() else {
            return
        }
        
        self.page = self.page + 1
        let options = ["page": page]
        Store.getTopRatedMovies(options) { (items, error) -> Void in
            
            guard error == nil else {
                
                // Restore states of the app
                self.page = self.page - 1
                self.isMoreDataLoading = false
                self.loadingMoreView!.stopAnimating()
                
                guard error == nil else {
                    self.view.makeToast("Something went wrong with the connection. Please try again.")
                    return
                }
                
                return
            }
            
            self.movies += items as! [Movie]
            self.filteredData = self.movies
            
            // TODO: Maybe we need to merge the old data and new data before we call reloadData()
            
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                
                guard ReachabilityHelper.isConnectedToNetwork() else {
                    self.view.makeToast("Something went wrong with the connection. Please try again.")
                    return
                }
                
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
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