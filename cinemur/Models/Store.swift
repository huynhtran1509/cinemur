//
//  Store.swift
//  cinemur
//
//  Created by Han Ngo on 3/13/16.
//  Copyright © 2016 Dwarves Foundation. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

public class Store {
    
    public static func getNowPlayingMovies(
        var options: [String: AnyObject],
        completion: (items: [AnyObject], error: ErrorType?) -> Void) {
            
            options["api_key"] = Constant.apiKey
            Alamofire.request(.GET, APIEndpoint.nowPlaying, parameters: options)
                .validate()
                .responseObject() { (response: Response<MovieResponse, NSError>) in
                    
                    switch response.result {
                    case .Success(let data):
                        completion(items: data.results!, error: nil)
                        break
                        
                    case .Failure(let error):
                        completion(items: [], error: error)
                        break
                    }
            }
            
    }
    
    public static func getTopRatedMovies(
        var options: [String: AnyObject],
        completion: (items: [AnyObject], error: ErrorType?) -> Void) {
            
            options["api_key"] = Constant.apiKey
            Alamofire.request(.GET, APIEndpoint.topRated, parameters: options)
                .validate()
                .responseObject() { (response: Response<MovieResponse, NSError>) in
                    switch response.result {
                    case .Success(let data):
                        completion(items: data.results!, error: nil)
                        break
                        
                    case .Failure(let error):
                        completion(items: [], error: error)
                        break
                    }
            }
    }
    
    public static func search(
        var options: [String: AnyObject],
        completion: (items: [AnyObject], error: ErrorType?) -> Void) {
            
            options["api_key"] = Constant.apiKey
            Alamofire.request(.GET, APIEndpoint.search, parameters: options)
                .validate()
                .responseObject() { (response: Response<MovieResponse, NSError>) in
                    switch response.result {
                    case .Success(let data):
                        completion(items: data.results!, error: nil)
                        break
                        
                    case .Failure(let error):
                        completion(items: [], error: error)
                        break
                    }
            }
    }
}