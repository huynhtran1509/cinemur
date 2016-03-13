//
//  APIEndpoint.swift
//  cinemur
//
//  Created by Han Ngo on 3/13/16.
//  Copyright © 2016 Dwarves Foundation. All rights reserved.
//

import Foundation

public class APIEndpoint {
    
    public static var root: String = "http://www.phuot.co"
    public static var rooms: String = root + "/rooms"
    public static var checkRoom: String = rooms + "/check"
    public static var wsSubscribe: String = root + "/subscribe"
}