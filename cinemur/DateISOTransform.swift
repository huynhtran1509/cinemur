//
//  DateISOTransform.swift
//  cinemur
//
//  Created by Han Ngo on 3/13/16.
//  Copyright © 2016 Dwarves Foundation. All rights reserved.
//

import Foundation
import ObjectMapper

public class DateISOTransform: TransformType {
    public typealias Object = NSDate
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let timeInt = value as? Double {
            return NSDate(timeIntervalSince1970: NSTimeInterval(timeInt))
        }
        
        if let timeStr = value as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            var date = dateFormatter.dateFromString(timeStr)
            if date == nil {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                date = dateFormatter.dateFromString(timeStr)
            }
            return date
        }
        
        return nil
    }
    
    public func transformToJSON(value: NSDate?) -> String? {
        if let date = value {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            return dateFormatter.stringFromDate(date)
        }
        return nil
    }
}