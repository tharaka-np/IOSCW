//
//  Temparature.swift
//  NIBMCOVID19
//
//  Created by Tharaka Pathirana on 9/20/20.
//  Copyright © 2020 Tharaka Pathirana. All rights reserved.
//

import UIKit

struct Temparature {
    
    var lastTime: String?
    var temparature: Int?
    
    
    init(lastTime: String?, temparature: Int?) {
        self.lastTime = lastTime
        self.temparature = temparature
    }
}
