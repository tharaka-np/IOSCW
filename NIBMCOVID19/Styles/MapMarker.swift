//
//  MapMarker.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/20/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import Foundation

import MapKit

class MapMarker: NSObject, MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
    }
    
}
