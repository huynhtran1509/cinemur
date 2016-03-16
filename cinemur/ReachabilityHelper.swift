//
//  ReachabilityHelper.swift
//  cinemur
//
//  Created by Han Ngo on 3/16/16.
//  Copyright © 2016 Dwarves Foundation. All rights reserved.
//

import Foundation
import ReachabilitySwift
import SystemConfiguration
import XCGLogger

public class ReachabilityHelper {
    
    /**
     Use to check if device is connected to network or not
     
     - returns: true if the device is connected to network
     */
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .Reachable
        let needsConnection = flags == .ConnectionRequired
        
        return isReachable && !needsConnection
    }
    
    var reachability: Reachability?
    
    func setup () {
        setupReachability(useHostName: false, useClosures: true)
        startNotifier()
        
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(5) * NSEC_PER_SEC))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.stopNotifier()
            self.setupReachability(useHostName: true, useClosures: true)
            self.startNotifier()
        }
    }
    
    func setupReachability(useHostName useHostName: Bool, useClosures: Bool) {
        let hostName = "google.com"
        
        do {
            let reachability = try useHostName ? Reachability(hostname: hostName) : Reachability.reachabilityForInternetConnection()
            self.reachability = reachability
        } catch ReachabilityError.FailedToCreateWithAddress(let address) {
            log.warning("Unable to create\nReachability with address:\n\(address)")
            return
        } catch {}
        
        if useClosures {
            
            reachability?.whenReachable = { reachability in
            }
            
            reachability?.whenUnreachable = { reachability in
            }
            
        } else {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability)
        }
    }
    
    func startNotifier() {
        log.info("---- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            log.warning("Unable to start notifier")
            return
        }
    }
    
    func stopNotifier() {
        log.info("--- stop notifier")
        reachability?.stopNotifier()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }
    
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            
        } else {

        }
    }
}
