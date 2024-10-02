//
//  FSHelpers.swift
//  FS70
//
//  Created by antoine fenouillot on 27/08/2024.
//

import Foundation
import UIKit
import CoreLocation

class FSHelpers{
    
    static var shared = FSHelpers()
    
    private init() {}
    
    
    //MARK: Return distance beween two point in meters
    func getDistanceBetweenPoint(p1Lat: Double, p1Lon: Double, p2Lat: Double, p2Lon: Double)->Double {
        
        let coordinate1 = CLLocation(latitude: p1Lat, longitude: p1Lon)
        let coordinate2 = CLLocation(latitude: p2Lat, longitude: p2Lon)

        let distanceInMeters = coordinate1.distance(from: coordinate2)
        return distanceInMeters
        
    }
    
    //MARK: Return distance beween two point in meters
    func getDistanceBetweenPointInKm(p1Lat: Double, p1Lon: Double, p2Lat: Double, p2Lon: Double)->Double {
        
        let coordinate1 = CLLocation(latitude: p1Lat, longitude: p1Lon)
        let coordinate2 = CLLocation(latitude: p2Lat, longitude: p2Lon)

        return coordinate1.distance(from: coordinate2)/1000
        
    }
    
}
