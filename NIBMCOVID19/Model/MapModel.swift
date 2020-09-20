//
//  MapModel.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/20/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import Foundation

struct MapModel {
    
    var latitude: Double
    var longtitude: Double
    var uid: String
    var temp: Int
    var syncDateTime: String
    
    init(latitude: Double, longtitude: Double, uid: String, temp: Int, syncDateTime: String) {
        self.latitude = latitude
        self.longtitude = longtitude
        self.uid = uid
        self.temp = temp
        self.syncDateTime = syncDateTime
    }
    
}
