//
//  FirstViewController.swift
//  cinemur
//
//  Created by Han Ngo on 3/13/16.
//  Copyright © 2016 Dwarves Foundation. All rights reserved.
//

import UIKit
import Kingfisher

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var page: Int = 1
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init UISearchBar
        let searchBar: UISearchBar = UISearchBar()
        searchBar.frame = CGRectMake(-5.0, 0.0, 320.0, 44.0)
        
        let searchBarView: UIView = UIView()
        searchBarView.frame = CGRectMake(0.0, 0.0, 310.0, 44.0)
        searchBarView.addSubview(searchBar)
        searchBar.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        searchBar.delegate = self
        self.navigationItem.titleView = searchBarView;
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let options = ["page": page]
        Store.getNowPlayingMovies(options) { (items, error) -> Void in
            self.movies = items as! [Movie]
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("me.tieubao.cinemur.MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = self.movies[indexPath.row]
        
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
        return movies.count
    }
}

