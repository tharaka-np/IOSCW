//
//  Model.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/19/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import Foundation

struct MapLocations {
    
    var lat: Double
    var log: Double
    var uid: String
    var syncDateTime: String
    
    init(lat: Double, log: Double, uid: String, syncDateTime: String) {
        self.lat = lat
        self.log = log
        self.uid = uid
        self.syncDateTime = syncDateTime
    }
}
