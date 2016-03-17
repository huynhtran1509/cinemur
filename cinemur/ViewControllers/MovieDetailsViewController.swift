//
//  MovieDetailsController.swift
//  cinemur
//
//  Created by Han Ngo on 3/14/16.
//  Copyright © 2016 Dwarves Foundation. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var starImage: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!

    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = contentView.bounds.size
        
        guard movie != nil else {
            log.error("Failed to pass data from source view controller")
            return
        }
        
        if movie?.backdrop != nil {
            
            let backdropURL = "https://image.tmdb.org/t/p/original" + (movie?.backdrop)!
            coverImage.kf_showIndicatorWhenLoading = true
            coverImage.kf_setImageWithURL(NSURL(string: backdropURL)!,
                placeholderImage: nil,
                optionsInfo: [.Transition(ImageTransition.Fade(1))])
        }
        
        titleLabel.text = movie?.title
        overviewLabel.text = movie?.overview
        
        let rating = movie?.rating
        ratingLabel.text = "\(rating!)"
        
        if rating == 0 {
            ratingLabel.hidden = true
            starImage.hidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
