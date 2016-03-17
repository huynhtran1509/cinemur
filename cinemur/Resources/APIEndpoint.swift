//
//  APIEndpoint.swift
//  cinemur
//
//  Created by Han Ngo on 3/13/16.
//  Copyright © 2016 Dwarves Foundation. All rights reserved.
//

import Foundation

public class APIEndpoint {
    public static var nowPlaying: String = "https://api.themoviedb.org/3/movie/now_playing"
    public static var topRated: String = "https://api.themoviedb.org/3/movie/top_rated"
    public static var search: String = "https://api.themoviedb.org/3/search/keyword"
}