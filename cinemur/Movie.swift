//
//  Movie.swift
//  cinemur
//
//  Created by Han Ngo on 3/13/16.
//  Copyright © 2016 Dwarves Foundation. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import Realm
import SwiftDate

class Movie: Object, Mappable {
    
    // MARK: Properties
    dynamic var id: Int = -1
    dynamic var runtime: Int = 0
    
    var title: String?
    var overview: String?
    var poster: String?
    var backdrop: String?
    var date: NSDate?
    
    // MARK: Constructors
    required init?(_ map: Map) {
        super.init()
    }
    
    required init() {
        
        self.title = ""
        self.overview = ""
        self.runtime = 0
        self.date = NSDate()
        self.poster = ""
        self.backdrop = ""
        super.init()
    }
    
    convenience init(id: Int, title: String, overview: String, runtime: Int, date: NSDate, poster: String, backdrop: String) {
        self.init()
        self.id = id
        self.overview = overview
        self.title = title
        self.runtime = runtime
        self.date = date
        self.poster = poster
        self.backdrop = backdrop
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    internal required override init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    // Mappable
    func mapping(map: Map) {
        self.id <- map["id"]
        self.title <- map["title"]
        self.overview <- map["overview"]
        self.poster <- map["poster_path"]
        self.backdrop <- map["backdrop_path"]
        self.runtime <- map["runtime"]
        self.date <- (map["release_date"], DateISOTransform())
    }
}