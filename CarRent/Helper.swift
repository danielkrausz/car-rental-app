//
//  Helper.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 12. 02..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import Foundation
import MapKit

class Helper {
    static func centerMapOnLocation(_ location: CLLocationCoordinate2D, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}
