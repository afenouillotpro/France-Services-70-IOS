//
//  FSPinAnnotation.swift
//  FS 70
//
//  Created by antoine fenouillot on 06/09/2024.
//

import MapKit
import Foundation
import UIKit

class PinAnnotation : NSObject, MKAnnotation {
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private var _title: String = String("")
    private var _subtitle: String = String("")
    private var _antenne: Antenne = Antenne()

    var title: String? {
        get {
            return _title
        }
        set (value) {
            self._title = value!
        }
    }

    var subtitle: String? {
        get {
            return _subtitle
        }
        set (value) {
            self._subtitle = value!
        }
    }
        
    var antenne: Antenne? {
        get {
            return _antenne
        }
        set (value) {
            self._antenne = value!
        }
    }

    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }

    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
}

